//
//  DDChattingModule.m
//  IOSDuoduo
//
//  Created by 独嘉 on 14-5-28.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import "ChattingModule.h"
#import "MTTDatabaseUtil.h"
#import "DDChatTextCell.h"
#import "NSDate+DDAddition.h"
#import "DDUserModule.h"
#import "GetMessageQueueAPI.h"
#import "DDMessageModule.h"
#import "MsgReadACKAPI.h"
#import <math.h>
#import "GetMsgByMsgIDsAPI.h"
#import "DDClientState.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDImageCache.h>
#import "MTTUtil.h"
#import "NSDictionary+JSON.h"
#import "MTTPhotosCache.h"
#import "WPMySecurities.h"
#import "WPDownLoadVideo.h"
static NSUInteger const showPromptGap = 300;
@interface ChattingModule(privateAPI)
- (NSUInteger)p_getMessageCount;
- (void)p_addHistoryMessages:(NSArray*)messages Completion:(DDChatLoadMoreHistoryCompletion)completion;

@end

@implementation ChattingModule
{
    //只是用来获取cell的高度的
    DDChatTextCell* _textCell;
    
    NSUInteger _earliestDate;
    NSUInteger _lastestDate;
    
    float heightPhoto;
    float lastHeight;
    
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.showingMessages = [[NSMutableArray alloc] init];
        self.ids = [NSMutableArray new];
    }
    return self;
}

- (void)setMTTSessionEntity:(MTTSessionEntity *)MTTSessionEntity
{
    _MTTSessionEntity = MTTSessionEntity;
    
    self.showingMessages = nil;
    self.showingMessages = [[NSMutableArray alloc] init];
}

#pragma mark   锁屏后再次进入时获取新消息
-(void)getNewMsg:(DDChatLoadMoreHistoryCompletion)completion
{
    [[DDMessageModule shareInstance] getMessageFromServer:0 currentSession:self.MTTSessionEntity count:20 Block:^(NSMutableArray *response, NSError *error) {
        //[self p_addHistoryMessages:response Completion:completion];
        NSUInteger msgID = [[response valueForKeyPath:@"@max.msgID"] integerValue];
        if ( msgID !=0) {
            if (response) {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"msgTime" ascending:YES];
                [response sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                [[MTTDatabaseUtil instance] insertMessages:response success:^{
                    MsgReadACKAPI* readACK = [[MsgReadACKAPI alloc] init];
                    if(msgID){
                        [readACK requestWithObject:@[self.MTTSessionEntity.sessionID,@(msgID),@(self.MTTSessionEntity.sessionType)] Completion:nil];
                    }
                } failure:^(NSString *errorDescripe) {
                }];
                [response enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self addShowMessage:obj];
                }];
                completion([response count],error);
            }
        }else{
            completion(0,error);
        }
    }];
}
-(void)loadHisToryMessageFromServer:(NSUInteger)FromMsgID loadCount:(NSUInteger)count Completion:(DDChatLoadMoreHistoryCompletion)completion
{
    if (self.MTTSessionEntity) {
        if (FromMsgID !=1) {
            [[DDMessageModule shareInstance] getMessageFromServer:FromMsgID currentSession:self.MTTSessionEntity count:count Block:^(NSArray *response, NSError *error) {
                NSUInteger msgID = [[response valueForKeyPath:@"@max.msgID"] integerValue];
                if ( msgID !=0) {
                    if (response) {
                        //从服务器加载数据时需要改变类型
                        for ( MTTMessageEntity* message in response) {
                            NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
                            //base64转吗
                            NSString * content =  [WPMySecurities textFromBase64String:contentStr];
                            if (!content.length) {
                                content = contentStr;
                            }
                            NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
                            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                            if (dic)
                            {
                                NSString * display_type = [NSString stringWithFormat:@"%@",dic[@"display_type"]];
                                switch (display_type.intValue) {
                                    case 7:
                                        message.msgContentType = DDMEssageLitterVideo;
                                        break;
                                    case 6:
                                    {
                                        message.msgContentType = DDMEssagePersonalaCard;
                                        [self downPhoto:dic andType:DDMEssagePersonalaCard];
                                    }
                                        break;
                                    case 8:
                                    {
                                        message.msgContentType = DDMEssageMyApply;
                                        [self downPhoto:dic andType:DDMEssageMyApply];
                                    }
                                        break;
                                    case 9:
                                    {
                                        message.msgContentType = DDMEssageMyWant;
                                        [self downPhoto:dic andType:DDMEssageMyWant];
                                    }
                                        break;
                                    case 1:
                                        message.msgContentType = DDMessageTypeText;
                                        break;
                                    case 2:
                                    {
                                         message.msgContentType = DDMessageTypeImage;
                                        [self downPhoto:dic andType:DDMessageTypeImage];
                                    }
                                        break;
                                    case 3:
                                    {
                                        message.msgContentType = DDMessageTypeVoice;
                                        [message.info setObject:@"0" forKey:DDVOICE_PLAYED];
                                        [[MTTDatabaseUtil instance] loadSingleMessage:[NSString stringWithFormat:@"%lu",(unsigned long)message.msgID] comple:^(NSArray *messages, NSError *error) {
                                            if (messages.count) {
                                                MTTMessageEntity * message = messages[0];
                                                if ([[message.info objectForKey:DDVOICE_PLAYED] intValue]) {
                                                    [message.info setObject:@"1" forKey:DDVOICE_PLAYED];
                                                }
                                                else
                                                {
                                                    [message.info setObject:@(0) forKey:DDVOICE_PLAYED];
                                                }
                                            }
                                            else
                                            {
                                                [message.info setObject:@(0) forKey:DDVOICE_PLAYED];
                                            }
                                        }];
                                    }
                                        break;
                                    case 10:
                                        message.msgContentType = DDMEssageMuchMyWantAndApply;
                                        break;
                                    case 11:
                                    {
                                        message.msgContentType = DDMEssageSHuoShuo;
                                        [self downPhoto:dic andType:DDMEssageSHuoShuo];
                                    }
                                        break;
                                    case 12:
                                        message.msgContentType = DDMEssageLitterInviteAndApply;
                                        break;
                                    case 13:
                                    {
                                        message.msgContentType = DDMEssageLitteralbume;
                                        [self downPhoto:dic andType:DDMEssageLitteralbume];
                                    }
                                        break;
                                    case 14:
                                        message.msgContentType = DDMEssageAcceptApply;
                                        break;
                                    case 15:
                                    {
                                        message.msgContentType = DDMEssageMuchCollection;
                                        
                                        [self downPhoto:dic andType:DDMEssageMuchCollection];
                                    }
                                        break;
                                    case 17:
                                        message.msgContentType = DDMEssageDeleteOrBlackName;
                                        break;
                                    default:
                                        break;
                                }
                            }
                        }
                        [[MTTDatabaseUtil instance] insertMessages:response success:^{
                            MsgReadACKAPI* readACK = [[MsgReadACKAPI alloc] init];
                            [readACK requestWithObject:@[self.MTTSessionEntity.sessionID,@(msgID),@(self.MTTSessionEntity.sessionType)] Completion:nil];
                        } failure:^(NSString *errorDescripe) {
                        }];
                        [self p_addHistoryMessages:response Completion:^(NSUInteger addcount, NSError *error) {
                            completion([response count],error);
                        }];
                    }
                }else{
                    completion(0,error);
                }
            }];
        }else{
            completion(0,nil);
        }
    }
}
-(NSString *)backPhoto:(NSDictionary*)dic and:(DDMessageContentType)type
{
    NSString * urlStr = [NSString new];
    switch (type) {
        case DDMEssageMyWant:
            urlStr = dic[@"zp_avatar"];
            break;
        case DDMEssageMyApply:
            urlStr = dic[@"qz_avatar"];
            break;
        case DDMEssageLitteralbume:
            urlStr = dic[@"from_avatar"];
            break;
        default:
            urlStr = dic[@"avatar"];
            break;
    }
    
    return urlStr;
}
-(void)downPhoto:(NSDictionary*)dic andType:(DDMessageContentType)type
{
    NSString * photoStr = [NSString new];
    id objc = dic[@"content"];
    if ([objc isKindOfClass:[NSString class]]) {
        
        //&$#@~^@[{:http://uxinsoft.iok.la:85//upload/201702/04/201702040923246586_918_1632.jpg:}]&$~@#@
        if (type == DDMessageTypeImage) {
            NSString * string = (NSString*)objc;
            photoStr = [string stringByReplacingOccurrencesOfString:@"&$#@~^@[{:" withString:@""];
            photoStr = [photoStr stringByReplacingOccurrencesOfString:@":}]&$~@#@" withString:@""];
        }
        else
        {
            NSString * string = (NSString*)objc;
            NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            //photoStr = dictionary[@"qz_avatar"];
            photoStr = [self backPhoto:dictionary and:type];
         }
        
    }
    else
    {
        if (dic[@"content"]) {
            //photoStr = dic[@"content"][@"qz_avatar"];
            photoStr = [self backPhoto:dic[@"content"] and:type];
        }
        else
        {
          //photoStr = dic[@"qz_avatar"];//avatar
            photoStr = [self backPhoto:dic and:type];
        }
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray * array = [photoStr componentsSeparatedByString:@"/"];
        NSMutableArray * muarray = [NSMutableArray array];
        [muarray addObjectsFromArray:array];
        NSString * lastStr = array[array.count-1];
        lastStr = [@"thumbd_" stringByAppendingString:lastStr];
        [muarray replaceObjectAtIndex:array.count-1 withObject:lastStr];
        WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
        NSString * imageUrl = [muarray componentsJoinedByString:@"/"];
         NSData * data = [self photoData:imageUrl];
        if (!data) {
            if (![imageUrl hasPrefix:@"http"]) {
                imageUrl = [IPADDRESS stringByAppendingString:imageUrl];
            }
            [down downLoadImage:imageUrl success:^(id response) {
            } failed:^(NSError *error) {
            }];
        }
    });
}
-(NSData*)photoData:(NSString*)filePath
{
    NSArray * pathArray = [filePath componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSData * data = [NSData dataWithContentsOfFile:fileName1];
    return data;
}
-(void)loadHostoryMessageFromServer:(NSUInteger)FromMsgID Completion:(DDChatLoadMoreHistoryCompletion)completion{
    [self loadHisToryMessageFromServer:FromMsgID loadCount:self.MTTSessionEntity.unReadMsgCount Completion:completion];//19->self.MTTSessionEntity.unReadMsgCount
}
-(void)loadLastMessage:(NSUInteger)FromMsgID complete:(void(^)(MTTMessageEntity*message))Complete
{
    if (self.MTTSessionEntity) {
        if (FromMsgID !=1) {
            [[DDMessageModule shareInstance] getMessageFromServer:FromMsgID currentSession:self.MTTSessionEntity count:1 Block:^(NSArray *response, NSError *error) {
                NSUInteger msgID = [[response valueForKeyPath:@"@max.msgID"] integerValue];
                if (msgID !=0) {
                    if (response) {
                        //从服务器加载数据时需要改变类型
                        MTTMessageEntity * message = response[0];
                        Complete(message);
                    }
                    else
                    {
                        Complete(nil);
                    }
                }else{
                    Complete(nil);
                }
            }];
        }else{
            Complete(nil);
        }
    }
    else
    {
        Complete(nil);
    }

}
-(void)preLoad:(DDChatLoadMoreHistoryCompletion)completion
{
    NSUInteger count = [self p_getMessageCount];
    [[MTTDatabaseUtil instance] loadMessageForSessionID:self.MTTSessionEntity.sessionID pageCount:DD_PAGE_ITEM_COUNT index:count completion:^(NSArray *messages, NSError *error)
     {
     [self p_addHistoryMessages:messages Completion:completion];
     }];
    
    
//    NSUInteger count = [self p_getMessageCount];
//    [[MTTDatabaseUtil instance] loadMessageForSessionID:self.MTTSessionEntity.sessionID pageCount:DD_PAGE_ITEM_COUNT index:count completion:^(NSArray *messages, NSError *error){
//       [self p_addHistoryMessages:messages Completion:completion];
//    }];
}
-(void)loadAllMessage:(DDChatLoadMoreHistoryCompletion)completion
{
    [[MTTDatabaseUtil instance] loadAllMessage:self.MTTSessionEntity.sessionID completion:^(NSArray *messages, NSError *error) {
        [self p_addHistoryMessages:messages Completion:completion];
    }];
}
//-(void)loadPreViewCompletion:(DDChatLoadMoreHistoryCompletion)completion
//{
//    NSUInteger count = [self p_getMessageCount];
//    [[MTTDatabaseUtil instance] loadMessageForSessionID:self.MTTSessionEntity.sessionID pageCount:DD_PAGE_ITEM_COUNT index:count completion:^(NSArray *messages, NSError *error)
//     {
//        [self p_addHistoryMessages:messages Completion:completion];
//     
//     }];
//}
- (void)loadMoreHistoryCompletion:(DDChatLoadMoreHistoryCompletion)completion
{
    NSUInteger count = [self p_getMessageCount];
    [[MTTDatabaseUtil instance] loadMessageForSessionID:self.MTTSessionEntity.sessionID pageCount:DD_PAGE_ITEM_COUNT index:count completion:^(NSArray *messages, NSError *error)
     {
         
        
         
         
//         [self p_addHistoryMessages:messages Completion:completion];
        if ([DDClientState shareInstance].networkState == DDNetWorkDisconnect||([DDClientState shareInstance].networkState == DDNetWorkWifi &&[DDClientState shareInstance].userState != DDUserOnline))
        {
            [self p_addHistoryMessages:messages Completion:completion];
        }
        else
        {
            if ([messages count] !=0)
            {
                BOOL isHaveMissMsg = [self p_isHaveMissMsg:messages];
                if (isHaveMissMsg || ([self getMiniMsgId] - [self getMaxMsgId:messages] !=0))
                {
                    //不能删除
                    [self loadHostoryMessageFromServer:[self getMiniMsgId] Completion:^(NSUInteger addcount, NSError *error) {
                        if (addcount) {
                            [self p_addHistoryMessages:messages Completion:completion];
                            completion(addcount,error);
                        }else{
                            [self p_addHistoryMessages:messages Completion:completion];
                        }
                    }];
                }
                else
                {
                    //检查消息是否连续
                    [self p_addHistoryMessages:messages Completion:completion];
                }
         }
        else
        {
                if (self.MTTSessionEntity.unReadMsgCount)//未读消息的个数不为0时需要从服务器获取未读的消息
                {
                    [self loadHostoryMessageFromServer:[self getMiniMsgId] Completion:^(NSUInteger addcount, NSError *error) {
                        completion(addcount,error);
                    }];
                }
                else
                {
                    NSError * error = nil;
                    completion(0,error);

                }
            
                //数据库中已获取不到消息
                //(不要删除)拿出当前最小的msgid去服务端取
//                [self loadHostoryMessageFromServer:[self getMiniMsgId] Completion:^(NSUInteger addcount, NSError *error) {
//                    completion(addcount,error);
//                }];
            }
            
            
        }
        
    }];
}
- (void)loadAllHistoryCompletion:(MTTMessageEntity*)message Completion:(DDChatLoadMoreHistoryCompletion)completion
{
    [[MTTDatabaseUtil instance] loadMessageForSessionID:self.MTTSessionEntity.sessionID afterMessage:message completion:^(NSArray *messages, NSError *error) {
        [self p_addHistoryMessages:messages Completion:completion];
    }];
}

-(NSUInteger )getMiniMsgId
{
    if ([self.showingMessages count] == 0) {
        return self.MTTSessionEntity.lastMsgID;
    }
    __block NSInteger minMsgID =[self getMaxMsgId:self.showingMessages];
    
    [self.showingMessages enumerateObjectsUsingBlock:^(MTTMessageEntity * obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[MTTMessageEntity class]]) {
            if(obj.msgID <minMsgID)
            {
                minMsgID = obj.msgID;
            }
        }
    }];
    return minMsgID;
}
-(NSDictionary*)getLastMessage:(id)string
{
    if ([string isKindOfClass:[NSString class]]) {
        NSData *JSONData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        return responseJSON;
    }
    else
    {
        NSDictionary * dic = (NSDictionary*)string;
        return dic;
    }
}

//#warning 这里计算cell的高度，当为图片的时候，需要自己重新计算（原来写的有错）
- (float)messageHeight:(MTTMessageEntity*)message
{
    lastHeight = 0;
    if (message.msgContentType == DDMessageTypeText ||message.msgContentType == DDMEssageLitterInviteAndApply|| message.msgContentType == DDMEssageAcceptApply) {
        if (!_textCell)
        {
            _textCell = [[DDChatTextCell alloc] init];
        }
        
        MTTMessageEntity * mess = [[MTTMessageEntity alloc]init];
        mess.msgContent = @"";
        if (message.msgContentType == DDMEssageAcceptApply)
        {
            mess = [MTTMessageEntity makeMessage:message.msgContent Module:[[ChattingModule alloc] init] MsgType:DDMEssageAcceptApply];
            NSDictionary * dic = [self getLastMessage:message.msgContent];
            if (dic)
            {
                NSString * userId = [NSString stringWithFormat:@"%@",dic[@"from_id"]];
                if ([userId isEqualToString:kShareModel.userId]) {
                    mess.msgContent = [NSString stringWithFormat:@"你好,我是%@。",dic[@"from_name"]];
                }
                else
                {
                    mess.msgContent = @"我通过了你的好友验证请求,现在我们可以聊天了。";
                    mess.senderId = mess.sessionId;
                }
            }
            else
            {
              
            }
        }
        return [_textCell cellHeightForMessage:mess.msgContent.length?mess:message];
    }
    else if (message.msgContentType == DDMessageTypeVoice )
    {
        return 60;
    }else if(message.msgContentType == DDMessageTypeImage)
    {
        float height = 150;
        float last_height = 0;
        
        NSDictionary* messageContent = [NSDictionary initWithJsonString:message.msgContent];
        if (messageContent[DD_IMAGE_LOCAL_KEY]) {//
            NSString* localPath = messageContent[DD_IMAGE_LOCAL_KEY];
            NSData* data = [[MTTPhotosCache sharedPhotoCache] photoFromDiskCacheForKey:localPath];
            UIImage *image = [[UIImage alloc] initWithData:data];
            height = [MTTUtil sizeTrans:image.size].height;
            
            
            CGFloat width = [MTTUtil sizeTrans:image.size].width;
            CGFloat max = height>width?height:width;
            if (max != 150) {
                
                if (height>width)
                {
                    height= 150;
                }
                else
                {
                    height = height/max*150;
                }
            }
            
            
            last_height = height+10;//10->20
        }
        else
        {
            NSString* urlString = message.msgContent;
            NSData * data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (dic)
            {
                urlString = [NSString stringWithFormat:@"%@",dic[@"url"]];
            }
            else
            {
                urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_PREFIX withString:@""];
                urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_SUFFIX withString:@""];
            }
            NSString * string = [NSString stringWithFormat:@"%@",urlString];
            string = [string stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
            NSArray * array = [string componentsSeparatedByString:@"_"];
            if (array.count== 1) {
                return 0;
            }
            NSString * widthStr = [NSString stringWithFormat:@"%@",array[1]];
            NSString * string1 = array[2];
            NSArray * array1 = [string1 componentsSeparatedByString:@"."];
            NSString * heightStr = array1[0];
            CGSize size = CGSizeMake(widthStr.floatValue, heightStr.floatValue);
            height = [MTTUtil sizeTrans:size].height;
            
            //比较宽和高，当最大的小于150时将最大的置为150，然后等比
            CGFloat width = [MTTUtil sizeTrans:size].width;
            CGFloat max = height>width?height:width;
            if (max != 150) {
               
                if (height>width)
                {
                    height= 150;
                }
                else
                {
                    height = (height>width?width:height)/max*150;
                }
            }
            last_height = height+10;
        }
        last_height = lastHeight?lastHeight:last_height;
//        last_height = last_height>kHEIGHT(133)?kHEIGHT(133)+15+15:last_height+15;
        return last_height>60?last_height:60;
    }
    else if(message.msgContentType == DDMEssageEmotion){
        return 133+10;//20->10
    }
    else
    {
        return 135;
    }
    
}

- (void)addPrompt:(NSString*)promptContent
{
    DDPromptEntity* prompt = [[DDPromptEntity alloc] init];
    prompt.message = promptContent;
    [self.showingMessages addObject:prompt];
}

- (void)addShowMessage:(MTTMessageEntity*)message
{
    if (![self.ids containsObject:@(message.msgID)])
    {
        if (message.msgTime - _lastestDate > showPromptGap)//showPromptGap
        {
            _lastestDate = message.msgTime;
            DDPromptEntity* prompt = [[DDPromptEntity alloc] init];
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:message.msgTime];
            prompt.message = [date promptDateString];
            [self.showingMessages addObject:prompt];
        }
        else//快速创建群组时直接发消息要有时间显示
        {
            NSLog(@"%lu",(unsigned long)self.showingMessages.count);
            NSString * string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@",message.sessionId]];
            if (string.intValue == 1) {
                _lastestDate = message.msgTime;
                DDPromptEntity* prompt = [[DDPromptEntity alloc] init];
                NSDate* date = [NSDate dateWithTimeIntervalSince1970:message.msgTime];
                prompt.message = [date promptDateString];
                [self.showingMessages addObject:prompt];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@",message.sessionId]];
            }
            else
            {
                if (self.showingMessages.count == 0)//创建一个新的session发送第一条消息是要有时间
                {
                    _lastestDate = message.msgTime;
                    DDPromptEntity* prompt = [[DDPromptEntity alloc] init];
                    NSDate* date = [NSDate dateWithTimeIntervalSince1970:message.msgTime];
                    prompt.message = [date promptDateString];
                    [self.showingMessages addObject:prompt];
                }
            }
        
        }
        NSArray *array = [[self class] p_spliteMessage:message];
        [array enumerateObjectsUsingBlock:^(MTTMessageEntity* obj, NSUInteger idx, BOOL *stop) {
            [[self mutableArrayValueForKeyPath:@"showingMessages"] addObject:obj];
        }];
    }
}

- (void)addShowMessages:(NSArray*)messages
{
    
    [[self mutableArrayValueForKeyPath:@"showingMessages"] addObjectsFromArray:messages];
}
-(void)getCurrentUser:(void(^)(MTTUserEntity *))block
{
    [[DDUserModule shareInstance] getUserForUserID:self.MTTSessionEntity.sessionID  Block:^(MTTUserEntity *user) {
        block(user);
    }];
    
}


- (void)updateSessionUpdateTime:(NSUInteger)time
{
    [self.MTTSessionEntity updateUpdateTime:time];
    _lastestDate = time;
}


#pragma mark -
#pragma mark PrivateAPI
- (NSUInteger)p_getMessageCount
{
    __block NSUInteger count = 0;
    [self.showingMessages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"MTTMessageEntity")])
        {
            count ++;
        }
    }];
    return count;
}

- (void)p_addHistoryMessages:(NSArray*)messages Completion:(DDChatLoadMoreHistoryCompletion)completion
{
    __block NSUInteger tempEarliestDate = [[messages valueForKeyPath:@"@min.msgTime"] integerValue];
    __block NSUInteger tempLasteestDate = 0;
    NSUInteger itemCount = [self.showingMessages count];
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:messages];
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"msgTime" ascending:YES];
    //    [tmp sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSMutableArray* tempMessages = [[NSMutableArray alloc] init];
    for (NSInteger index = [tmp count] - 1; index >= 0;index --)
    {
        MTTMessageEntity* message = tmp[index];
        if ([self.ids containsObject:@(message.msgID)]) {
            continue;
        }
        //            if (index == [tmp count] - 1)
        //            {
        //                tempEarliestDate = message.msgTime;
        //
        //            }
        if (message.msgTime - tempLasteestDate > showPromptGap)
        {
            DDPromptEntity* prompt = [[DDPromptEntity alloc] init];
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:message.msgTime];
            prompt.message = [date promptDateString];
            [tempMessages addObject:prompt];
        }
        tempLasteestDate = message.msgTime;
        NSArray *array = [[self class] p_spliteMessage:message];
        [array enumerateObjectsUsingBlock:^(MTTMessageEntity * obj, NSUInteger idx, BOOL *stop) {
            [self.ids addObject:@(message.msgID)];
            [tempMessages addObject:obj];
        }];
    }
    
    if ([self.showingMessages count] == 0)
    {
        [[self mutableArrayValueForKeyPath:@"showingMessages"] addObjectsFromArray:tempMessages];
        _earliestDate = tempEarliestDate;
        _lastestDate = tempLasteestDate;
    }
    else
    {
        [self.showingMessages insertObjects:tempMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [tempMessages count])]];
        _earliestDate = tempEarliestDate;
    }
    NSUInteger newItemCount = [self.showingMessages count];
    completion(newItemCount - itemCount,nil);
    
}

+ (NSArray*)p_spliteMessage:(MTTMessageEntity*)message
{
    message.msgContent = [message.msgContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableArray* messageContentArray = [[NSMutableArray alloc] init];
    
    if ( [ message.msgContent rangeOfString:DD_MESSAGE_IMAGE_PREFIX].length > 0)//图片类型
    {
        NSString* messageContent = [message msgContent];
        if ([messageContent rangeOfString:DD_MESSAGE_IMAGE_PREFIX].length > 0 && [messageContent rangeOfString:DD_IMAGE_LOCAL_KEY].length > 0 && [messageContent rangeOfString:DD_IMAGE_URL_KEY].length > 0) {
            
            MTTMessageEntity* messageEntity = [[MTTMessageEntity alloc] initWithMsgID: message.msgID msgType:message.msgType msgTime:message.msgTime sessionID:message.sessionId senderID:message.senderId msgContent:messageContent toUserID:message.toUserID];
            messageEntity.msgContentType = DDMessageTypeImage;
            messageEntity.state = DDmessageSendSuccess;
        }else{
            
            NSArray* tempMessageContent = [messageContent componentsSeparatedByString:DD_MESSAGE_IMAGE_PREFIX];
            [tempMessageContent enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString* content = (NSString*)obj;
                if ([content length] > 0)
                {
                    NSRange suffixRange = [content rangeOfString:DD_MESSAGE_IMAGE_SUFFIX];
                    if (suffixRange.length > 0)
                    {
                       
                        //是图片,再拆分
                        NSString* imageContent = [NSString stringWithFormat:@"%@%@",DD_MESSAGE_IMAGE_PREFIX,[content substringToIndex:suffixRange.location + suffixRange.length]];
                        MTTMessageEntity* messageEntity = [[MTTMessageEntity alloc] initWithMsgID: message.msgID msgType:message.msgType msgTime:message.msgTime sessionID:message.sessionId senderID:message.senderId msgContent:imageContent toUserID:message.toUserID];
                        messageEntity.msgContentType = DDMessageTypeImage;
                        messageEntity.state = DDmessageSendSuccess;
                        [messageContentArray addObject:messageEntity];
                        
                        
                        NSString* secondComponent = [content substringFromIndex:suffixRange.location + suffixRange.length];
                        if (secondComponent.length > 0)
                        {
                            MTTMessageEntity* secondmessageEntity = [[MTTMessageEntity alloc] initWithMsgID: message.msgID msgType:message.msgType msgTime:message.msgTime sessionID:message.sessionId senderID:message.senderId msgContent:secondComponent toUserID:message.toUserID];
                            secondmessageEntity.msgContentType = DDMessageTypeText;
                            secondmessageEntity.state = DDmessageSendSuccess;
                            [messageContentArray addObject:secondmessageEntity];
                        }
                    }
                    else
                    {
                        
                        MTTMessageEntity* messageEntity = [[MTTMessageEntity alloc] initWithMsgID: message.msgID msgType:message.msgType msgTime:message.msgTime sessionID:message.sessionId senderID:message.senderId msgContent:content toUserID:message.toUserID];
                        messageEntity.state = DDmessageSendSuccess;
                        [messageContentArray addObject:messageEntity];
                    }
                }
            }];
        }
    }
    
    if ([messageContentArray count] == 0)
    {
        [messageContentArray addObject:message];
    }
    
    return messageContentArray;
    
}
-(NSInteger)getMaxMsgId:(NSArray *)array
{
    __block NSInteger maxMsgID =0;
    [array enumerateObjectsUsingBlock:^(MTTMessageEntity * obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[MTTMessageEntity class]]) {
            if (obj.msgID > maxMsgID && obj.msgID<LOCAL_MSG_BEGIN_ID) {
                maxMsgID =obj.msgID;
            }
        }
    }
     ];
    return maxMsgID;
}
- (BOOL)p_isHaveMissMsg:(NSArray*)messages
{
    
    __block NSInteger maxMsgID =[self getMaxMsgId:messages];
    __block NSInteger minMsgID =[self getMaxMsgId:messages];;
    [messages enumerateObjectsUsingBlock:^(MTTMessageEntity * obj, NSUInteger idx, BOOL *stop) {
        if (obj.msgID > maxMsgID && obj.msgID<LOCAL_MSG_BEGIN_ID) {
            //maxMsgID =obj.msgID;
        }else if(obj.msgID <minMsgID)
        {
            minMsgID = obj.msgID;
        }
    }];
    
    //   NSUInteger maxMsgID = [msgIds valueForKeyPath:@"@max"];
    //    NSUInteger minMsgID = [msgIds valueForKeyPath:@"@min"];
    
    NSUInteger diff = maxMsgID - minMsgID;
    if (diff != 19) {
        return YES;
    }
    return NO;
}

-(void)checkMsgList:(DDChatLoadMoreHistoryCompletion)completion
{
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.showingMessages];
    [tmp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DDPromptEntity class]]) {
            [tmp removeObject:obj];
        }else{
            MTTMessageEntity *msg = obj;
            if (msg.msgID>=LOCAL_MSG_BEGIN_ID) {
                [tmp removeObject:obj];
            }
        }
        
    }];
    
    [tmp enumerateObjectsUsingBlock:^(MTTMessageEntity *obj, NSUInteger idx, BOOL *stop) {
        if (idx +1 < [tmp count]) {
            MTTMessageEntity * msg = [tmp objectAtIndex:idx+1];
            if (abs(obj.msgID - msg.msgID) !=1) {
                [self loadHisToryMessageFromServer:MIN(obj.msgID, msg.msgID) loadCount:abs(obj.msgID - msg.msgID) Completion:^(NSUInteger addcount, NSError *error) {
                    completion(addcount,error);
                }];
            }
        }
        
    }];
}
@end

@implementation DDPromptEntity

@end
