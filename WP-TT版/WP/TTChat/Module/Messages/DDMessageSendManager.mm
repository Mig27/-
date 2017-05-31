
//
//  DDMessageSendManager.m
//  Duoduo
//
//  Created by 独嘉 on 14-3-30.
//  Copyright (c) 2015年 MoguIM All rights reserved.
//

#import "DDMessageSendManager.h"
#import "DDUserModule.h"
#import "MTTMessageEntity.h"
#import "DDMessageModule.h"
#import "DDTcpClientManager.h"
#import "SendMessageAPI.h"
#import "RuntimeStatus.h"
#import "RecentUsersViewController.h"
#import "EmotionsModule.h"
#import "NSDictionary+JSON.h"
#import "UnAckMessageManager.h"
#import "DDGroupModule.h"
#import "DDClientState.h"
#import "NSData+Conversion.h"
#import "MTTDatabaseUtil.h"
#import "security.h"
#import "WPSetMessageType.h"
#import "WPMySecurities.h"
#import "RSSocketClinet.h"
static uint32_t seqNo = 0;

@interface DDMessageSendManager(PrivateAPI)

- (NSString* )toSendmessageContentFromContent:(NSString*)content;

@end

@implementation DDMessageSendManager
{
    NSUInteger _uploadImageCount;
}
+ (instancetype)instance
{
    static DDMessageSendManager* g_messageSendManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_messageSendManager = [[DDMessageSendManager alloc] init];
    });
    return g_messageSendManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _uploadImageCount = 0;
        _waitToSendMessage = [[NSMutableArray alloc] init];
        _sendMessageSendQueue = dispatch_queue_create("com.mogujie.Duoduo.sendMessageSend", NULL);
        
    }
    return self;
}

// FIXME: 发送消息
- (void)sendMessage:(MTTMessageEntity *)message isGroup:(BOOL)isGroup Session:(MTTSessionEntity*)session completion:(DDSendMessageCompletion)completion Error:(void (^)(NSError *))block
{
    dispatch_async(self.sendMessageSendQueue, ^{
        SendMessageAPI* sendMessageAPI = [[SendMessageAPI alloc] init];
        uint32_t nowSeqNo = ++seqNo;
        message.seqNo=nowSeqNo;
        NSString* newContent = message.msgContent;
        NSDictionary *contentDic = [NSDictionary dictionary];
        if ([message isImageMessage]) {
            NSDictionary* dic = [NSDictionary initWithJsonString:message.msgContent];
            NSString* urlPath = dic[DD_IMAGE_URL_KEY];
            if (!urlPath.length) {
                urlPath = dic[@"content"];
            }
            if (!urlPath.length) {
                urlPath = message.msgContent;
            }
            contentDic = @{@"display_type":@"2",@"content":urlPath};
            NSError * erreo = nil;
            NSData * dcidata = [NSJSONSerialization dataWithJSONObject:contentDic options:NSJSONWritingPrettyPrinted error:&erreo];
            NSString * string = [[NSString alloc]initWithData:dcidata encoding:NSUTF8StringEncoding];
            newContent = string;
        }
        
        if (message.msgContentType == DDMEssageLitterVideo) {//小视频
            NSDictionary * dic = [NSDictionary initWithJsonString:message.msgContent];
            NSString * urlPsth = dic[DD_IMAGE_URL_KEY];
            if (!dic) {
                urlPsth = message.msgContent;
            }
            if (!urlPsth) {
                urlPsth = @"";
            }
            contentDic  = @{@"display_type":@"7",@"content":urlPsth};
            NSError * error = nil;
            NSData * data = [NSJSONSerialization dataWithJSONObject:contentDic options:NSJSONWritingPrettyPrinted error:&error];
            NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            newContent = string;
            
        }
        
        if (message.msgContentType == DDMEssagePersonalaCard)
        {
            NSString * ctring = [NSString stringWithFormat:@"%@",message.msgContent];
            NSData * data = [ctring dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary * dictionary = dic[@"content"];
            if (!dictionary) {
                dictionary = dic;
            }
            NSData * data1 = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
            NSString * string = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            NSDictionary * dictionary1= @{@"content":string,@"display_type":@"6"};
            NSData * data2 = [NSJSONSerialization dataWithJSONObject:dictionary1 options:NSJSONWritingPrettyPrinted error:nil];
            NSString * contentStr = [[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
            newContent = contentStr;
        }
        
        if (message.msgContentType == DDMEssageAcceptApply)
        {
            NSString * ctring = [NSString stringWithFormat:@"%@",message.msgContent];
            NSData * data = [ctring dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary * dictionary = dic[@"content"];
            if (!dictionary) {
                dictionary = dic;
            }
            NSData * data1 = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
            NSString * string = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            NSDictionary * dictionary1= @{@"content":string,@"display_type":@"14"};
            NSData * data2 = [NSJSONSerialization dataWithJSONObject:dictionary1 options:NSJSONWritingPrettyPrinted error:nil];
            NSString * contentStr = [[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
            newContent = contentStr;
        }
        
        if (message.msgContentType == DDMEssageMyApply || message.msgContentType == DDMEssageMyWant)
        {
            NSString * ctring = [NSString stringWithFormat:@"%@",message.msgContent];
            NSData * data = [ctring dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary * dictionary = dic[@"content"];
            if (!dictionary) {
                dictionary = dic;
            }
            NSData * data1 = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
            NSString * string = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            NSDictionary * dictionary1= @{@"content":string,@"display_type":(message.msgContentType == DDMEssageMyApply)?@"8":@"9"};
            NSData * data2 = [NSJSONSerialization dataWithJSONObject:dictionary1 options:NSJSONWritingPrettyPrinted error:nil];
            NSString * contentStr = [[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
            newContent = contentStr;
        }
        
        if (message.msgContentType == DDMEssageMuchMyWantAndApply || message.msgContentType == DDMEssageSHuoShuo) {
            NSString * ctring = [NSString stringWithFormat:@"%@",message.msgContent];
            NSData * data = [ctring dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary * dictionary = dic[@"content"];
            if (!dictionary) {
                dictionary = dic;
            }
            NSData * data1 = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
            NSString * string = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            NSDictionary * dictionary1= @{@"content":string,@"display_type":(message.msgContentType == DDMEssageMuchMyWantAndApply)?@"10":@"11"};
            NSData * data2 = [NSJSONSerialization dataWithJSONObject:dictionary1 options:NSJSONWritingPrettyPrinted error:nil];
            NSString * contentStr = [[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
            newContent = contentStr;
        }
        
        if (message.msgContentType == DDMEssageMuchCollection) {
            NSString * ctring = [NSString stringWithFormat:@"%@",message.msgContent];
            NSData * data = [ctring dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary * dictionary = dic[@"content"];
            if (!dictionary) {
                dictionary = dic;
            }
            NSData * data1 = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
            NSString * string = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            NSDictionary * dictionary1= @{@"content":string,@"display_type":@"15"};
            NSData * data2 = [NSJSONSerialization dataWithJSONObject:dictionary1 options:NSJSONWritingPrettyPrinted error:nil];
            NSString * contentStr = [[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
            newContent = contentStr;
        }
        
        if (message.msgContentType == DDMEssageLitterInviteAndApply) {
            NSString * ctring = [NSString stringWithFormat:@"%@",message.msgContent];
            NSData * data = [ctring dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary * dictionary = dic[@"content"];
            if (!dictionary) {
                dictionary = dic;
            }
            NSData * data1 = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
            NSString * string = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            NSDictionary * dictionary1= @{@"content":string,@"display_type":@"12"};
            NSData * data2 = [NSJSONSerialization dataWithJSONObject:dictionary1 options:NSJSONWritingPrettyPrinted error:nil];
            NSString * contentStr = [[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
            newContent = contentStr;
        }
        
        if (message.msgContentType == DDMEssageLitteralbume) {
            NSString * ctring = [NSString stringWithFormat:@"%@",message.msgContent];
            NSData * data = [ctring dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary * dictionary = dic[@"content"];
            if (!dictionary) {
                dictionary = dic;
            }
            NSData * data1 = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
            NSString * string = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            NSDictionary * dictionary1= @{@"content":string,@"display_type":@"13"};
            NSData * data2 = [NSJSONSerialization dataWithJSONObject:dictionary1 options:NSJSONWritingPrettyPrinted error:nil];
            NSString * contentStr = [[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
            newContent = contentStr;
        }
        
        if (message.msgContentType == DDMEssageDeleteOrBlackName||message.msgContentType == DDMEssageNotification) {
            NSString * ctring = [NSString stringWithFormat:@"%@",message.msgContent];
            NSData * data = [ctring dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary * dictionary = dic[@"content"];
            if (!dictionary) {
                dictionary = dic;
            }
            NSData * data1 = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
            NSString * string = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            NSDictionary * dictionary1= @{@"content":string,@"display_type":((message.msgContentType == DDMEssageDeleteOrBlackName)?@"17":@"16")};
            NSData * data2 = [NSJSONSerialization dataWithJSONObject:dictionary1 options:NSJSONWritingPrettyPrinted error:nil];
            NSString * contentStr = [[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
            newContent = contentStr;
        }
        
        //转码成base64
        NSData * data1 = [newContent dataUsingEncoding:NSUTF8StringEncoding];
        newContent = [data1 base64EncodedStringWithOptions:0];
        char* pOut;
        uint32_t nOutLen;
        const char *test =[newContent cStringUsingEncoding:NSUTF8StringEncoding];
        uint32_t nInLen  = strlen(test);
        EncryptMsg(test, nInLen, &pOut, nOutLen);
        
        NSString * string = nil;
        if (message.msgContentType == DDMEssageDeleteOrBlackName || message.msgContentType == DDMEssageRemind) {
            string = [NSString stringWithCString:pOut encoding:NSUTF8StringEncoding];
            string = [@"1" stringByAppendingString:string];
        }
        else
        {
            string = [NSString stringWithCString:pOut encoding:NSUTF8StringEncoding];
            string = [@"0" stringByAppendingString:string];
        }
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//        NSData *data = [[NSString stringWithCString:pOut encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
        Free(pOut);
        if(!message.msgID){
            return;
        }
        
        if (session.sessionID.length) {
           // [[NSUserDefaults standardUserDefaults] setObject:session.sessionID forKey:@"sessionID"];
            self.needSessionID = session.sessionID;
        }
        else
        {
           // session.sessionID = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
            session.sessionID = self.needSessionID;
        }
        
        NSArray* object = @[TheRuntime.user.objID,session.sessionID,data,@(message.msgType),@(message.msgID)];
        if ([message isImageMessage]) {
            session.lastMsg=@"[图片]";
        }else if ([message isVoiceMessage])
        {
            session.lastMsg=@"[语音]";
        }
        else if ([message isPersonCard])
        {
          session.lastMsg = message.msgContent;
        }
        else
        {
            session.lastMsg = message.msgContent;
        }
        if (isGroup)
        {
            session.lastMesageName = kShareModel.nick_name;
        }
        
        [[UnAckMessageManager instance] addMessageToUnAckQueue:message];
        if (message.msgContentType != DDMEssageDeleteOrBlackName && message.msgContentType != DDMEssageNotification) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SentMessageSuccessfull" object:session];
        }
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"SentMessageSuccessfull" object:session];
        
        
        [sendMessageAPI requestWithObject:object Completion:^(id response, NSError *error) {
            if (!error)
            {

                [[MTTDatabaseUtil instance] deleteMesages:message completion:^(BOOL success){
                }];
                [[UnAckMessageManager instance] removeMessageFromUnAckQueue:message];
                message.msgID=[response[0] integerValue];
                message.state=DDmessageSendSuccess;
                session.lastMsgID=message.msgID;
                session.timeInterval=message.msgTime;
                if (message.msgContentType != DDMEssageDeleteOrBlackName && message.msgContentType != DDMEssageNotification) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"SentMessageSuccessfull" object:session];
                }
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"SentMessageSuccessfull" object:session];
                
                if (message.msgContentType != DDMEssageDeleteOrBlackName && message.msgContentType != DDMEssageNotification) {
                    
                    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
                    } failure:^(NSString *errorDescripe) {
                    }];
                }
                
//                [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
//                } failure:^(NSString *errorDescripe) {
//                }];
                completion(message,nil);
                
                
                 NSArray * sessionArray = [session.sessionID componentsSeparatedByString:@"_"];
                //发送成功时是否需要推送
                if (session.sessionType == SessionTypeSessionTypeSingle) {
                    [[DDUserModule shareInstance] getOffLine:[NSString stringWithFormat:@"user_%@",sessionArray[1]] Block:^(MTTUserEntity *user) {
                        if (user) {//当前用户不在线需要推送
                            //推送内容样式类
                            WPSetMessageType * type = [[WPSetMessageType alloc]init];
                            NSString * contentSt = [type notificationStr:message];
                            NSString * receive = [session.sessionID componentsSeparatedByString:@"_"][1];
                            NSString * string = [NSString stringWithFormat:@"3^%@^%@^%@：%@",kShareModel.userId,receive,kShareModel.nick_name,contentSt];
                            if (contentSt.length) {
                              [[RSSocketClinet sharedSocketClinet] sendNotificationMessage:string];
                            }
                        }
                    }];
                }
                else//群组推送
                {
                    
                    NSArray * arrar = [session.sessionID componentsSeparatedByString:@"_"];
                    
                    
                    NSString * userId = [NSString new];
                 MTTGroupEntity * group = [[DDGroupModule instance] getGroupByGId:session.sessionID];
                    for (NSString * string  in group.groupUserIds) {
                        NSLog(@"%@",string);
                        MTTUserEntity * user = [[DDUserModule shareInstance] offLineUser:string];
                        if (user) {
                            if (userId.length) {
                               userId =  [NSString stringWithFormat:@"%@,%@",userId,[string componentsSeparatedByString:@"_"][1]];
                            }
                            else
                            {
                                userId = [string componentsSeparatedByString:@"_"][1];
                            }
                        }
                    }
                    
//                    if (userId.length) {//有需要推送的
                        WPSetMessageType * type = [[WPSetMessageType alloc]init];
                        NSString * contentSt = [type notificationStr:message];
                        NSString * string = [NSString stringWithFormat:@"13^%@^%@^%@：%@^2",kShareModel.userId,arrar[1],kShareModel.nick_name,contentSt];
                        if (contentSt.length) {
                         [[RSSocketClinet sharedSocketClinet] sendNotificationMessage:string];   
                        }
                       // [[RSSocketClinet sharedSocketClinet] sendNotificationMessage:string];
//                    }
                }
            }
            else
            {

                message.state=DDMessageSendFailure;
                if (message.msgContentType != DDMEssageDeleteOrBlackName) {
                    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
                    } failure:^(NSString *errorDescripe) {
                    }];
                }
//                [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
//                } failure:^(NSString *errorDescripe) {
//                }];
                NSError* error = [NSError errorWithDomain:@"发送消息失败" code:0 userInfo:nil];
                block(error);
            }
        }];
        
    });
}

- (void)sendVoiceMessage:(NSData*)voice filePath:(NSString*)filePath forSessionID:(NSString*)sessionID isGroup:(BOOL)isGroup Message:(MTTMessageEntity *)msg Session:(MTTSessionEntity*)session completion:(DDSendMessageCompletion)completion
{
    dispatch_async(self.sendMessageSendQueue, ^{
        SendMessageAPI* sendVoiceMessageAPI = [[SendMessageAPI alloc] init];
        
        NSString* myUserID = [RuntimeStatus instance].user.objID;
        NSArray* object = @[myUserID,sessionID,voice,@(msg.msgType),@(0)];
        [sendVoiceMessageAPI requestWithObject:object Completion:^(id response, NSError *error) {
            if (!error)
            {
                NSArray * sessionArray = [session.sessionID componentsSeparatedByString:@"_"];
                //发送成功时是否需要推送
                if (session.sessionType == SessionTypeSessionTypeSingle) {
                    [[DDUserModule shareInstance] getOffLine:[NSString stringWithFormat:@"user_%@",sessionArray[1]] Block:^(MTTUserEntity *user) {
                        if (user) {//当前用户不在线需要推送
                            NSString * contentSt =@"[语音]";
                            NSString * receive = [session.sessionID componentsSeparatedByString:@"_"][1];
                            NSString * string = [NSString stringWithFormat:@"3^%@^%@^%@：%@",kShareModel.userId,receive,kShareModel.nick_name,contentSt];
                            if (contentSt.length) {
                                [[RSSocketClinet sharedSocketClinet] sendNotificationMessage:string];
                            }
                        }
                    }];
                }
                else//群组推送
                {
                    NSString * userId = [NSString new];
                    MTTGroupEntity * group = [[DDGroupModule instance] getGroupByGId:session.sessionID];
                    for (NSString * string  in group.groupUserIds) {
                        NSLog(@"%@",string);
                        MTTUserEntity * user = [[DDUserModule shareInstance] offLineUser:string];
                        if (user) {
                            if (userId.length) {
                                userId =  [NSString stringWithFormat:@"%@,%@",userId,[string componentsSeparatedByString:@"_"][1]];
                            }
                            else
                            {
                                userId = [string componentsSeparatedByString:@"_"][1];
                            }
                        }
                    }
                    if (userId.length) {//有需要推送的
                        NSString * contentSt = @"[语音]";
                        NSString * string = [NSString stringWithFormat:@"3^%@^%@^%@：%@",kShareModel.userId,userId,kShareModel.nick_name,contentSt];
                        if (contentSt.length) {
                            [[RSSocketClinet sharedSocketClinet] sendNotificationMessage:string];
                        }
                        // [[RSSocketClinet sharedSocketClinet] sendNotificationMessage:string];
                    }
                }
                NSLog(@"发送消息成功");
                [[MTTDatabaseUtil instance] deleteMesages:msg completion:^(BOOL success){
                    
                }];
                
                
                NSUInteger messageTime = [[NSDate date] timeIntervalSince1970];
                msg.msgTime=messageTime;
                msg.msgID=[response[0] integerValue];
                msg.state=DDmessageSendSuccess;
                session.lastMsg=@"[语音]";
                session.lastMsgID=msg.msgID;
                session.timeInterval=msg.msgTime;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SentMessageSuccessfull" object:session];
                [[MTTDatabaseUtil instance] insertMessages:@[msg] success:^{
                    
                } failure:^(NSString *errorDescripe) {
                    
                }];
                
                completion(msg,nil);
                
            }
            else
            {
                NSError* error = [NSError errorWithDomain:@"发送消息失败" code:0 userInfo:nil];
                completion(nil,error);
            }
        }];
        
    });
}

#pragma mark Private API

- (NSString* )toSendmessageContentFromContent:(NSString*)content
{
    EmotionsModule* emotionModule = [EmotionsModule shareInstance];
    NSDictionary* unicodeDic = emotionModule.unicodeEmotionDic;
    NSArray* allEmotions = emotionModule.emotions;
    NSMutableString* newContent = [NSMutableString stringWithString:content];
    [allEmotions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString* emotion = (NSString*)obj;
        if ([newContent rangeOfString:emotion].length > 0)
        {
            NSString* placeholder = unicodeDic[emotion];
            NSRange range = NSMakeRange(0, newContent.length);
            [newContent replaceOccurrencesOfString:emotion withString:placeholder options:0 range:range];
        }
    }];
    return newContent;
}


@end
