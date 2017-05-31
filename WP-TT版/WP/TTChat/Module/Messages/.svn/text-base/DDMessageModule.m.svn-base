
//
//  DDMessageModule.m
//  IOSDuoduo
//
//  Created by 独嘉 on 14-5-27.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import "DDMessageModule.h"
#import "MTTDatabaseUtil.h"
#import "DDReceiveMessageAPI.h"
#import "GetUnreadMessagesAPI.h"
#import "MTTAFNetworkingClient.h"
#import "MTTSessionEntity.h"
#import "RuntimeStatus.h"
#import "MsgReadACKAPI.h"
#import "DDUserModule.h"
#import "DDReceiveMessageACKAPI.h"
#import "RecentUsersViewController.h"
#import "GetMessageQueueAPI.h"
#import "DDGroupModule.h"
#import "MsgReadNotify.h"
#import "MTTNotification.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDImageCache.h>
#import "WPMySecurities.h"
#import "WPDownLoadVideo.h"
#import "SessionModule.h"
#import "WPBlackNameModel.h"
#import "GetGroupInfoAPI.h"
@interface DDMessageModule(){

    NSMutableDictionary* _unreadMessages;
}
@property (nonatomic, copy)NSString*avatarStr;
@property (nonatomic, assign)int numOfVoice;
@end

@implementation DDMessageModule

+ (instancetype)shareInstance
{
    static DDMessageModule* g_messageModule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_messageModule = [[DDMessageModule alloc] init];
    });
    return g_messageModule;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        //注册收到消息API
        self.unreadMsgCount =0;
        _unreadMessages = [[NSMutableDictionary alloc] init];
        
        [self p_registerReceiveMessageAPI];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NSUInteger )getMessageID
{
    NSInteger messageID = [[NSUserDefaults standardUserDefaults] integerForKey:@"msg_id"];
    if(messageID == 0)
    {
        messageID=LOCAL_MSG_BEGIN_ID;
    }else{
        messageID ++;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:messageID forKey:@"msg_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return messageID;
}

-(void)sendMsgRead:(MTTMessageEntity *)message
{
    MsgReadACKAPI* readACK = [[MsgReadACKAPI alloc] init];
    [readACK requestWithObject:@[message.sessionId,@(message.msgID),@(message.sessionType)] Completion:nil];
}

-(void)removeAllUnreadMessages{
    [_unreadMessages removeAllObjects];
}

- (NSUInteger)getUnreadMessgeCount
{
    __block NSUInteger count = 0;
    [_unreadMessages enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        count += [obj count];
    }];
    return count;
}

-(void)addUserToBlackName:(NSDictionary*)dictionary
{
    WPBlackNameModel * model = [[WPBlackNameModel alloc]init];
    id objc = dictionary[@"content"];
    if ([objc isKindOfClass:[NSString class]]) {
        NSString * string = (NSString*)objc;
        NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString * friend_id = dic[@"friend_id"];
        NSString * friend_type = dic[@"friend_type"];
        switch (friend_type.intValue) {
            case 0://拉入黑名单
            {
                model.userId = [NSString stringWithFormat:@"user_%@",friend_id];
                model.state = @"0";
                [[MTTDatabaseUtil instance] updateBlackName:@[model] completion:^(NSError *error) {
                }];
            }
                break;
            case 1://取消黑名单
            {
                model.userId = [NSString stringWithFormat:@"user_%@",friend_id];
                [[MTTDatabaseUtil instance] removeFromBlackName:@[model] completion:^(BOOL success) {
                }];
            }
                break;
            case 2://删除好友
            {
                model.userId = [NSString stringWithFormat:@"user_%@",friend_id];
                model.state = @"2";
                [[MTTDatabaseUtil instance] updateBlackName:@[model] completion:^(NSError *error) {
                }];
            }
                break;
            case 3://添加好友成功
            {
                model.userId = [NSString stringWithFormat:@"user_%@",friend_id];
                [[MTTDatabaseUtil instance] removeFromBlackName:@[model] completion:^(BOOL success) {
                }];
            }
                break;
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DELETEORBLACKNAME" object:dic];
    }
    else
    {
    }
}

-(void)pushNotification:(MTTMessageEntity*)obj
{
    NSString * string = (obj.sessionType == SessionTypeSessionTypeSingle)?@"2":@"1";
    NSString*messageId = [NSString stringWithFormat:@"%@:%@",[NSString stringWithFormat:@"%ld",(long)obj.msgID],@"1"];
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/delmsg.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"delgchatmsg",
                           @"TallType":string,
                           @"MsgID":messageId,
                           @"username":kShareModel.username,
                           @"password":kShareModel.password};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
    } failure:^(NSError *error) {
    }];
}
-(void)changeGroupInfo:(NSString*)string messag:(NSString*)sessionId
{
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (dic) {
        NSString * note_type = [NSString stringWithFormat:@"%@",dic[@"note_type"]];
        if ([note_type isEqualToString:@"10"]) {
            MTTSessionEntity * session = [[SessionModule instance] getSessionById:sessionId];
            if (session) {//当session存在时再去请求数据，因为不存在时后面添加session时会获取请求数据
                GetGroupInfoAPI* request = [[GetGroupInfoAPI alloc] init];
                [request requestWithObject:@[@([MTTUtil changeIDToOriginal:sessionId]),@(0)] Completion:^(id response, NSError *error) {
                    if (!error)
                    {
                        if ([response count]) {
                            MTTGroupEntity* group = (MTTGroupEntity*)response[0];
                            if (group)
                            {
                                [[DDGroupModule instance] addGroup:group];
                                [[MTTDatabaseUtil instance] updateRecentGroup:group completion:^(NSError *error) {
                                }];
                                //获取session病改变信息
                                    session.name = group.name;
                                    session.avatar = group.avatar;
                                    [[SessionModule instance] addToSessionModel:session];
                                    [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
                                    }];
                            }
                        }
                    }
                }];
            }
        }
    }
}


-(void)removeUser:(NSString*)string
{
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString * userID = dic[@"from_id"];
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"addFriends"];
    if ([array containsObject:userID]) {
        NSMutableArray * muarr = [NSMutableArray array];
        [muarr addObjectsFromArray:array];
        [muarr removeObject:userID];
        array = [NSArray arrayWithArray:muarr];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"addFriends"];
    }
    
}
#pragma mark - privateAPI收到发送来的消息
- (void)p_registerReceiveMessageAPI
{
    DDReceiveMessageAPI* receiveMessageAPI = [[DDReceiveMessageAPI alloc] init];
    [receiveMessageAPI registerAPIInAPIScheduleReceiveData:^(MTTMessageEntity* object, NSError *error) {
        
//        object.msgContent = [object.msgContent substringFromIndex:1];
        //将消息格式进行转换
        //如果群已经被解散了那么收到的消息不要在显示
        NSString * msgcontent = [NSString stringWithFormat:@"%@",object.msgContent];
        NSString * content = [NSString string];
        content = [WPMySecurities textFromBase64String:msgcontent];
        NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (dic)
        {
            NSString * display_type = [NSString stringWithFormat:@"%@",dic[@"display_type"]];
            if ([display_type isEqualToString:@"6"])
            {
                object.msgContentType = DDMEssagePersonalaCard;
                object.msgContent = [NSString stringWithFormat:@"%@",dic[@"content"]];
                
                id objc = dic[@"content"];
                if ([objc isKindOfClass:[NSString class]]) {
                    NSString * string = (NSString*)objc;
                    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [self downPhoto:dic[@"avatar"]];
                }
                else
                {
                   [self downPhoto:dic[@"content"][@"avatar"]];
                }
                
               
            }
            else if ([display_type isEqualToString:@"17"])//被拉黑或删除，不用写入数据库中
            {
                [self addUserToBlackName:dic];
                //从消息服务器删除
                dispatch_async(dispatch_get_main_queue(), ^{
                  [self pushNotification:object];
                });
                return ;
            }
            else if ([display_type isEqualToString:@"8"]||[display_type isEqualToString:@"9"])
            {
                object.msgContentType = [display_type isEqualToString:@"8"]? DDMEssageMyApply: DDMEssageMyWant;
                object.msgContent = [NSString stringWithFormat:@"%@",dic[@"content"]];
                id objc = dic[@"content"];
                if ([objc isKindOfClass:[NSString class]]) {
                    NSString * string = (NSString*)objc;
                    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [self downPhoto:[display_type isEqualToString:@"8"]?dic[@"qz_avatar"]:dic[@"zp_avatar"]];
                }
                else
                {
                    [self downPhoto:[display_type isEqualToString:@"8"]?dic[@"content"][@"qz_avatar"]:dic[@"content"][@"zp_avatar"]];
                }
//                
//                [self downPhoto:[display_type isEqualToString:@"8"]?dic[@"content"][@"qz_avatar"]:dic[@"content"][@"zp_avatar"]];
            }
            else if ([display_type isEqualToString:@"10"])
            {
                object.msgContentType = DDMEssageMuchMyWantAndApply;
                object.msgContent = [NSString stringWithFormat:@"%@",dic[@"content"]];
//                [self downPhoto:dic[@"content"][@""]];
            }
            else if ([display_type isEqualToString:@"11"])
            {
                object.msgContentType = DDMEssageSHuoShuo;
                object.msgContent = [NSString stringWithFormat:@"%@",dic[@"content"]];
                id objc = dic[@"content"];
                if ([objc isKindOfClass:[NSString class]]) {
                    NSString * string = (NSString*)objc;
                    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [self downPhoto:dic[@"avatar"]];
                }
                else
                {
                  [self downPhoto:dic[@"content"][@"avatar"]];
                }
                
                
                
            }
            else if ([display_type isEqualToString:@"7"])
            {
                object.msgContentType = DDMEssageLitterVideo;
                object.msgContent = [NSString stringWithFormat:@"%@",dic[@"content"]];
            }
            else if ([display_type isEqualToString:@"12"])
            {
                object.msgContentType = DDMEssageLitterInviteAndApply;
                object.msgContent = [NSString stringWithFormat:@"%@",dic[@"content"]];
                //notetype为10时需要重新加载群组的信息
                [self changeGroupInfo:dic[@"content"] messag:object.sessionId];
            }
            else if ([display_type isEqualToString:@"13"])
            {
                object.msgContentType = DDMEssageLitteralbume;
                object.msgContent = [NSString stringWithFormat:@"%@",dic[@"content"]];
                id objc = dic[@"content"];
                if ([objc isKindOfClass:[NSString class]]) {
                    NSString * string = (NSString*)objc;
                    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [self downPhoto:dic[@"from_avatar"]];
                }
                else
                {
                  [self downPhoto:dic[@"content"][@"from_avatar"]];
                }
                
                
                
            }
            else if ([display_type isEqualToString:@"15"])
            {
                object.msgContentType = DDMEssageMuchCollection;
                object.msgContent = [NSString stringWithFormat:@"%@",dic[@"content"]];
                
                id objc = dic[@"content"];
                if ([objc isKindOfClass:[NSString class]]) {
                    NSString * string = (NSString*)objc;
                    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [self downPhoto:dic[@"avatar"]];
                }
                else
                {
                    [self downPhoto:dic[@"content"][@"avatar"]];
                }
                
//                [self downPhoto:dic[@"content"][@"avatar"]];
            }
            else if ([display_type isEqualToString:@"16"])//添加好友的推送
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self pushNotification:object];
                });
                return;
            }
            else if ([display_type isEqualToString:@"14"])
            {
                object.msgContentType = DDMEssageAcceptApply;
                id conte = dic[@"content"];
                if ([conte isKindOfClass:[NSString class]])
                {
                    object.msgContent = conte;
                }
                else
                {
                    NSData * data = [NSJSONSerialization dataWithJSONObject:dic[@"content"] options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    object.msgContent = contentStr;
                }
                //移除本地添加缓存数据
                [self removeUser:object.msgContent];
    
            }
            else if ([display_type isEqualToString:@"2"])
            {
                NSString * string = [NSString stringWithFormat:@"%@",dic[@"content"]];
                NSRange range = NSMakeRange(0, [DD_MESSAGE_IMAGE_PREFIX length]);
                NSString * subStr = [string substringWithRange:range];
                if (![subStr isEqualToString:DD_MESSAGE_IMAGE_PREFIX])
                {
                    string = [NSString stringWithFormat:@"%@%@",DD_MESSAGE_IMAGE_PREFIX,string];
                    string = [NSString stringWithFormat:@"%@%@",string,DD_MESSAGE_IMAGE_SUFFIX];
                }
                object.msgContentType = DDMessageTypeImage;
                object.msgContent = string;
                
                NSString * urlStr = [NSString stringWithFormat:@"%@",dic[@"content"]];
                urlStr = [urlStr stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_PREFIX withString:@""];
                urlStr = [urlStr stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_SUFFIX withString:@""];
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:urlStr] options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        [manager saveImageToCache:image forURL:imageURL];
                    }];
                //将等比例图片存在本地
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSArray * array = [urlStr componentsSeparatedByString:@"/"];
                    NSMutableArray * muarray = [NSMutableArray array];
                    [muarray addObjectsFromArray:array];
                    NSString * lastStr = array[array.count-1];
                    lastStr = [@"thumbd_" stringByAppendingString:lastStr];
                    [muarray replaceObjectAtIndex:array.count-1 withObject:lastStr];
                    //本地中没有缩略图
                        WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
                    NSString * imageUrl = [muarray componentsJoinedByString:@"/"];
                        if (![imageUrl hasPrefix:@"http"]) {
                            imageUrl = [IPADDRESS stringByAppendingString:imageUrl];
                        }
                        [down downLoadImage:imageUrl success:^(id response) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"loadThumbdImageSuccess" object:dic];
                            });
                        } failed:^(NSError *error) {
                        }];
                });
            }
            else
            {
               object.msgContent = [NSString stringWithFormat:@"%@",dic[@"content"]];
            }
        }
        object.state=DDmessageSendSuccess;
        DDReceiveMessageACKAPI *rmack = [[DDReceiveMessageACKAPI alloc] init];
        [rmack requestWithObject:@[object.senderId,@(object.msgID),object.sessionId,@(object.sessionType)] Completion:^(id response, NSError *error) {
        }];
        NSArray* messages = [self p_spliteMessage:object];
        if ([object isGroupMessage]) {
            MTTGroupEntity *group = [[DDGroupModule instance] getGroupByGId:object.sessionId];
            
           _avatarStr = [NSString stringWithFormat:@"%@",group.avatar];
            if ([_avatarStr isEqualToString:@"(null)"] || !_avatarStr.length)
            {
                object.avatarStr = _avatarStr;
            }
            else
            {
              object.avatarStr = [_avatarStr substringWithRange:NSMakeRange(0, _avatarStr.length-1)];
            }
            if (group.isShield == 1) {
                MsgReadACKAPI* readACK = [[MsgReadACKAPI alloc] init];
                [readACK requestWithObject:@[object.sessionId,@(object.msgID),@(object.sessionType)] Completion:nil];
            }
        }
//       收到消息时插入到数据库中
        [[MTTDatabaseUtil instance] insertMessages:@[object] success:^{
        } failure:^(NSString *errorDescripe) {
        }];
        
          [MTTNotification postNotification:DDNotificationReceiveMessage userInfo:nil object:object];

    }];
    
}
#pragma mark 下载图片
-(void)downPhoto:(NSString*)photoStr
{
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
#pragma mark 从服务器中加载数据   需要转码
-(void)getMessageFromServer:(NSInteger)fromMsgID currentSession:(MTTSessionEntity *)session count:(NSInteger)count Block:(void(^)(NSMutableArray *array, NSError *error))block
{
    GetMessageQueueAPI *getMessageQueue = [GetMessageQueueAPI new];//count
    [getMessageQueue requestWithObject:@[@(fromMsgID),@(count),@(session.sessionType),session.sessionID] Completion:^(NSMutableArray *response, NSError *error) {
        
        //从服务器获取的数据要移除
//        NSSortDescriptor * sortDes = [[NSSortDescriptor alloc]initWithKey:@"msgTime" ascending:NO];
//        [response sortUsingDescriptors:[NSArray arrayWithObject:sortDes]];
//        [response removeObjectsInRange:NSMakeRange(session.unReadMsgCount, response.count-session.unReadMsgCount)];
        
        self.numOfVoice = 0;
        for (MTTMessageEntity * message in response) {
            if (message.msgContentType == DDMessageTypeVoice) {
                self.numOfVoice++;
            }
        }
        
        if (self.numOfVoice) {//判断从服务器加载的语音在本地是否存在，如果存在的话要根据本地语音是否读取来改变从服务器上加载的语音读取状态
            for (MTTMessageEntity * message in response)
            {
                NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
                NSString * content = [WPMySecurities textFromBase64String:contentStr];
                NSString * encodeStr = [[NSString alloc]initWithString:content];
                NSData * data = [encodeStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                
                
                if (message.msgContentType == DDMessageTypeVoice) {
                    
                    [[MTTDatabaseUtil instance] loadMessgaeForSeeeionID:message.sessionId andMessage:message.msgID completion:^(NSArray *messages, NSError *error) {
                        if (messages.count) {
                            MTTMessageEntity * mess = messages[0];
                            if ([[mess.info objectForKey:DDVOICE_PLAYED] intValue]) {
                                [message.info setObject:@"1" forKey:DDVOICE_PLAYED];
                            }
                            else
                            {
                                [message.info setObject:@"0" forKey:DDVOICE_PLAYED];
                            }
                        }
                        else
                        {
                            [message.info setObject:@"0" forKey:DDVOICE_PLAYED];
                        }
                        self.numOfVoice--;
                        if (!self.numOfVoice) {
                            block(response,error);
                        }
                    }];
                    
                }
                if (dic)
                {
                    NSString * display_type = [NSString stringWithFormat:@"%@",dic[@"display_type"]];
                    if ([display_type isEqualToString:@"6"]||[display_type isEqualToString:@"8"]||[display_type isEqualToString:@"9"]||[display_type isEqualToString:@"10"]||[display_type isEqualToString:@"11"]||[display_type isEqualToString:@"12"]||[display_type isEqualToString:@"13"]||[display_type isEqualToString:@"14"])
                    {
                        NSString * contetStr = [NSString stringWithFormat:@"%@",dic[@"content"]];
                        NSData * data1 = [contetStr dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableLeaves error:nil];
                        NSDictionary * dcitionary1 = @{@"display_type":dic[@"display_type"],@"content":dictionary};
                        NSString * messageStr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:dcitionary1 options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                        message.msgContent = messageStr;
                    }
                    else if ([display_type isEqualToString:@"17"])
                    {
                        [self addUserToBlackName:dic];
                        return ;
                    }
                    else if ([display_type isEqualToString:@"16"])//叫群的通知,需要移除
                    {
                        [response removeObject:message];
                        continue;
                    }
                    else
                    {
                        message.msgContent = content;
                        //是图片时应该提前将图片写入本地中
                        if ([display_type isEqualToString:@"2"])
                        {
                            //将图片写到缓存中
                            NSString *urlStr = [NSString stringWithFormat:@"%@",dic[@"content"]];
                            NSString * string = [urlStr substringFromIndex:DD_MESSAGE_IMAGE_PREFIX.length];
                            NSString * string1 = [string substringToIndex:string.length- DD_MESSAGE_IMAGE_SUFFIX.length];
                            NSURL * url = [NSURL URLWithString:string1];
                            SDWebImageManager *manager = [SDWebImageManager sharedManager];
                            [manager downloadImageWithURL:url options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                [manager saveImageToCache:image forURL:imageURL];
                            }];
                            
                            //下载缩略图
                            NSArray * array = [string1 componentsSeparatedByString:@"/"];
                            NSMutableArray * muarray = [NSMutableArray array];
                            [muarray addObjectsFromArray:array];
                            NSString * lastStr = array[array.count-1];
                            lastStr = [@"thumbd_" stringByAppendingString:lastStr];
                            [muarray replaceObjectAtIndex:array.count-1 withObject:lastStr];
                            WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
                            NSString * imageUrl = [muarray componentsJoinedByString:@"/"];
                            if (![imageUrl hasPrefix:@"http"]) {
                                imageUrl = [IPADDRESS stringByAppendingString:imageUrl];
                            }
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                [down downLoadImage:imageUrl success:^(id response) {
                                } failed:^(NSError *error) {
                                }];
                            });
                        }
                    }
                }
                else
                {
                    if (content.length) {
                        message.msgContent = content;
                    }
                    else
                    {
                        message.msgContent = contentStr;
                    }
                    
                }
            }
            
           // if (!self.numOfVoice) {
           //     block(response,error);
           // }
            
        }
        else
        {
            for (MTTMessageEntity * message in response)
            {
                NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
                NSString * content = [WPMySecurities textFromBase64String:contentStr];
                NSString * encodeStr = [[NSString alloc]initWithString:content];
                NSData * data = [encodeStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                
                if (dic)
                {
                    NSString * display_type = [NSString stringWithFormat:@"%@",dic[@"display_type"]];
                    if ([display_type isEqualToString:@"6"]||[display_type isEqualToString:@"8"]||[display_type isEqualToString:@"9"]||[display_type isEqualToString:@"10"]||[display_type isEqualToString:@"11"]||[display_type isEqualToString:@"12"]||[display_type isEqualToString:@"13"]||[display_type isEqualToString:@"14"])
                    {
                        NSString * contetStr = [NSString stringWithFormat:@"%@",dic[@"content"]];
                        NSData * data1 = [contetStr dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableLeaves error:nil];
                        NSDictionary * dcitionary1 = @{@"display_type":dic[@"display_type"],@"content":dictionary};
                        NSString * messageStr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:dcitionary1 options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                        message.msgContent = messageStr;
                    }
                    else if ([display_type isEqualToString:@"17"])
                    {
                        [self addUserToBlackName:dic];
                        return ;
                    }
                    else if ([display_type isEqualToString:@"16"])//叫群的通知,需要移除
                    {
                        [response removeObject:message];
                        continue;
                    }
                    else
                    {
                        message.msgContent = content;
                        //是图片时应该提前将图片写入本地中
                        if ([display_type isEqualToString:@"2"])
                        {
                            //将图片写到缓存中
                            NSString *urlStr = [NSString stringWithFormat:@"%@",dic[@"content"]];
                            NSString * string = [urlStr substringFromIndex:DD_MESSAGE_IMAGE_PREFIX.length];
                            NSString * string1 = [string substringToIndex:string.length- DD_MESSAGE_IMAGE_SUFFIX.length];
                            NSURL * url = [NSURL URLWithString:string1];
                            SDWebImageManager *manager = [SDWebImageManager sharedManager];
                            [manager downloadImageWithURL:url options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                [manager saveImageToCache:image forURL:imageURL];
                            }];
                            
                            //下载缩略图
                            NSArray * array = [string1 componentsSeparatedByString:@"/"];
                            NSMutableArray * muarray = [NSMutableArray array];
                            [muarray addObjectsFromArray:array];
                            NSString * lastStr = array[array.count-1];
                            lastStr = [@"thumbd_" stringByAppendingString:lastStr];
                            [muarray replaceObjectAtIndex:array.count-1 withObject:lastStr];
                            WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
                            NSString * imageUrl = [muarray componentsJoinedByString:@"/"];
                            if (![imageUrl hasPrefix:@"http"]) {
                                imageUrl = [IPADDRESS stringByAppendingString:imageUrl];
                            }
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                [down downLoadImage:imageUrl success:^(id response) {
                                } failed:^(NSError *error) {
                                }];
                            });
                        }
                    }
                }
                else
                {
                    if (content.length) {
                        message.msgContent = content;
                    }
                    else
                    {
                        message.msgContent = contentStr;
                    }
                    
                }
            }
            
             block(response,error);
            
        }
        
        
        
        /*
        for (MTTMessageEntity * message in response)
        {
            NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
            NSString * content = [WPMySecurities textFromBase64String:contentStr];
            NSString * encodeStr = [[NSString alloc]initWithString:content];
            NSData * data = [encodeStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if (dic)
            {
                NSString * display_type = [NSString stringWithFormat:@"%@",dic[@"display_type"]];
                if ([display_type isEqualToString:@"6"]||[display_type isEqualToString:@"8"]||[display_type isEqualToString:@"9"]||[display_type isEqualToString:@"10"]||[display_type isEqualToString:@"11"]||[display_type isEqualToString:@"12"]||[display_type isEqualToString:@"13"]||[display_type isEqualToString:@"14"])
                {
                    NSString * contetStr = [NSString stringWithFormat:@"%@",dic[@"content"]];
                    NSData * data1 = [contetStr dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableLeaves error:nil];
                    NSDictionary * dcitionary1 = @{@"display_type":dic[@"display_type"],@"content":dictionary};
                    NSString * messageStr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:dcitionary1 options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                    message.msgContent = messageStr;
                }
                else if ([display_type isEqualToString:@"17"])
                {
                    [self addUserToBlackName:dic];
                    return ;
                }
                else if ([display_type isEqualToString:@"16"])//叫群的通知,需要移除
                {
                    [response removeObject:message];
                    continue;
                }
                else
                {
                 message.msgContent = content;
                    //是图片时应该提前将图片写入本地中
                    if ([display_type isEqualToString:@"2"])
                    {
                        //将图片写到缓存中
                        NSString *urlStr = [NSString stringWithFormat:@"%@",dic[@"content"]];
                        NSString * string = [urlStr substringFromIndex:DD_MESSAGE_IMAGE_PREFIX.length];
                        NSString * string1 = [string substringToIndex:string.length- DD_MESSAGE_IMAGE_SUFFIX.length];
                        NSURL * url = [NSURL URLWithString:string1];
                        SDWebImageManager *manager = [SDWebImageManager sharedManager];
                        [manager downloadImageWithURL:url options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            [manager saveImageToCache:image forURL:imageURL];
                        }];
                        
                        //下载缩略图
                        NSArray * array = [string1 componentsSeparatedByString:@"/"];
                        NSMutableArray * muarray = [NSMutableArray array];
                        [muarray addObjectsFromArray:array];
                        NSString * lastStr = array[array.count-1];
                        lastStr = [@"thumbd_" stringByAppendingString:lastStr];
                        [muarray replaceObjectAtIndex:array.count-1 withObject:lastStr];
                        WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
                        NSString * imageUrl = [muarray componentsJoinedByString:@"/"];
                        if (![imageUrl hasPrefix:@"http"]) {
                            imageUrl = [IPADDRESS stringByAppendingString:imageUrl];
                        }
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            [down downLoadImage:imageUrl success:^(id response) {
                            } failed:^(NSError *error) {
                            }];
                        });
                    }
                }
            }
            else
            {
                if (content.length) {
                  message.msgContent = content;
                }
                else
                {
                    message.msgContent = contentStr;
                }
               
            }
        }
        */
       // block(response,error);
    }];
}






- (NSArray*)p_spliteMessage:(MTTMessageEntity*)message
{
    NSMutableArray* messageContentArray = [[NSMutableArray alloc] init];
    if (message.msgContentType == DDMessageTypeImage || (message.msgContentType == DDMessageTypeText && [message.msgContent rangeOfString:DD_MESSAGE_IMAGE_PREFIX].length > 0))
    {
        NSString* messageContent = [message msgContent];
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
                    MTTMessageEntity* messageEntity = [[MTTMessageEntity alloc] initWithMsgID:[DDMessageModule getMessageID] msgType:message.msgType msgTime:message.msgTime sessionID:message.sessionId senderID:message.senderId msgContent:imageContent toUserID:message.toUserID];
                    messageEntity.msgContentType = DDMessageTypeImage;
                    messageEntity.state = DDmessageSendSuccess;
                    [messageContentArray addObject:messageEntity];
                    
                    
                    NSString* secondComponent = [content substringFromIndex:suffixRange.location + suffixRange.length];
                    if (secondComponent.length > 0)
                    {
                        MTTMessageEntity* secondmessageEntity = [[MTTMessageEntity alloc] initWithMsgID:[DDMessageModule getMessageID] msgType:message.msgType msgTime:message.msgTime sessionID:message.sessionId senderID:message.senderId msgContent:secondComponent toUserID:message.toUserID];
                        secondmessageEntity.msgContentType = DDMessageTypeText;
                        secondmessageEntity.state = DDmessageSendSuccess;
                        [messageContentArray addObject:secondmessageEntity];
                    }
                }
                else
                {
           
                    MTTMessageEntity* messageEntity = [[MTTMessageEntity alloc] initWithMsgID:[DDMessageModule getMessageID] msgType:message.msgType msgTime:message.msgTime sessionID:message.sessionId senderID:message.senderId msgContent:content toUserID:message.toUserID];
                    messageEntity.msgContentType = DDMessageTypeText;
                    messageEntity.state = DDmessageSendSuccess;
                    [messageContentArray addObject:messageEntity];
                }
            }
        }];
    }
    if ([messageContentArray count] == 0)
    {
        [messageContentArray addObject:message];
    }
    return messageContentArray;
}

-(void)setApplicationUnreadMsgCount
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[self getUnreadMessgeCount]];
}

@end
