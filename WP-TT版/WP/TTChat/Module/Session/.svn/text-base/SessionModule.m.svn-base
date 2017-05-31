//
//  SessionModule.m
//  TeamTalk
//
//  Created by Michael Scofield on 2014-12-05.
//  Copyright (c) 2014 dujia. All rights reserved.
//

#import "SessionModule.h"
#import "MTTSessionEntity.h"
#import "NSDictionary+Safe.h"
#import "GetUnreadMessagesAPI.h"
#import "RemoveSessionAPI.h"
#import "MTTDatabaseUtil.h"
#import "GetRecentSession.h"
#import "MTTMessageEntity.h"
#import "ChattingMainViewController.h"
#import "MsgReadNotify.h"
#import "MsgReadACKAPI.h"
#import "SpellLibrary.h"
#import "DDGroupModule.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DDUserModule.h"
#import "WPMySecurities.h"
#import "WPMySecurities.h"
#import "GetGroupInfoAPI.h"
#import "MessagerManager.h"
#import "MessagerModel.h"
#import "requstUnreadMessageApi.h"
#import "WPMySecurities.h"
#import "DDAllUserAPI.h"
#import "ChattingModule.h"
@interface SessionModule()<PlayingDelegate>
@property(strong)NSMutableDictionary *sessions;
@end

@implementation SessionModule

+ (instancetype)instance
{
    static SessionModule* module;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        module = [[SessionModule alloc] init];
        
    });
    return module;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessions = [NSMutableDictionary new];
        //发送消息成功
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sentMessageSuccessfull:) name:@"SentMessageSuccessfull" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageReadACK:) name:@"MessageReadACK" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteMessageSuccess:) name:@"deleteMessageSuccessFull" object:nil];
        
        //收到消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(n_receiveMessageNotification:)
                                                     name:DDNotificationReceiveMessage
                                                   object:nil];
        MsgReadNotify *msgReadNotify = [[MsgReadNotify alloc] init];
        [msgReadNotify registerAPIInAPIScheduleReceiveData:^(NSDictionary *object, NSError *error) {
            NSString *fromId= [object objectForKey:@"from_id"];
            NSInteger msgID = [[object objectForKey:@"msgId"] integerValue];
            SessionType type = [[object objectForKey:@"type"] intValue];
            [self cleanMessageFromNotifi:msgID SessionID:fromId Session:type];
        }];
        
//        MessagerManager *manager =  [MessagerManager sharedManager];
//        [manager requestMessagerSetting];
        MessagerManager *manager =  [MessagerManager sharedManager];
        NSUserDefaults * stnadDefault = [NSUserDefaults standardUserDefaults];
        NSString * voice = [stnadDefault objectForKey:@"messageVoice"];
         NSString * shock = [stnadDefault objectForKey:@"messageShock"];
         NSString * noti = [stnadDefault objectForKey:@"messageNotification"];
        if (voice.length == 0 || [voice isEqualToString:@"(null)"]) {
            voice = @"1";
        }
        if (shock.length == 0 || [shock isEqualToString:@"(null)"]) {
            shock = @"1";
        }
        if (noti.length == 0 || [noti isEqualToString:@"(null)"]) {
            noti = @"1";
        }
        
        MessagerModel * model = [[MessagerModel alloc]init];
        model.voice = voice;
        model.shock = shock;
        model.deplayMsgContent = noti;
        manager.model = model;
    }
    return self;
}
-(MTTSessionEntity *)getSessionById:(NSString *)sessionID
{
    return [self.sessions safeObjectForKey:sessionID];
}
-(void)removeSessionById:(NSString *)sessionID
{
    [self.sessions removeObjectForKey:sessionID];
}
-(void)removeSessionById:(NSString *)sessionID succecc:(NSString*)succec
{
   [self.sessions removeObjectForKey:sessionID];
    [[MTTDatabaseUtil instance] removeSession:sessionID];
  

}
-(void)addToSessionModel:(MTTSessionEntity *)session
{
    [self.sessions safeSetObject:session forKey:session.sessionID];
}
-(NSUInteger)getAllUnreadMessageCount
{
    NSArray *allSession = [self getAllSessions];
    __block NSUInteger count = 0;
    [allSession enumerateObjectsUsingBlock:^(MTTSessionEntity *obj, NSUInteger idx, BOOL *stop) {
        NSInteger unReadMsgCount = obj.unReadMsgCount;
        if(obj.isGroup){
            MTTGroupEntity *group = [[DDGroupModule instance] getGroupByGId:obj.sessionID];
            if (group) {
                if(group.isShield){
                    if(obj.unReadMsgCount){
                        unReadMsgCount = 0;
                    }
                }
            }
        }
        count += unReadMsgCount;
    }];
    return count;
//    return [[[self getAllSessions] valueForKeyPath:@"@sum.unReadMsgCount"] integerValue];
}
-(void)addSessionsToSessionModel:(NSArray *)sessionArray
{
    [sessionArray enumerateObjectsUsingBlock:^(MTTSessionEntity *session, NSUInteger idx, BOOL *stop) {
        [self.sessions safeSetObject:session forKey:session.sessionID];
    }];
}

#pragma mark 锁屏后重新进入时获取未读的消息
-(void)getHadUnreadMessageSession:(void(^)(NSUInteger count))block
{
    requstUnreadMessageApi * getUnreadMessage = [requstUnreadMessageApi new];
//    GetUnreadMessagesAPI *getUnreadMessage = [GetUnreadMessagesAPI new];
    [getUnreadMessage requestWithObject:TheRuntime.user.objID Completion:^(NSDictionary *dic, NSError *error) {
        NSInteger m_total_cnt =[dic[@"m_total_cnt"] integerValue];
        NSArray *localsessions = dic[@"sessions"];
        [localsessions enumerateObjectsUsingBlock:^(MTTSessionEntity *obj, NSUInteger idx, BOOL *stop){
            NSString * string = [WPMySecurities textFromBase64String:obj.lastMsg];
            NSString * lastMessage = [WPMySecurities textFromEmojiString:string];
            NSData * data = [lastMessage dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (dic) {
                if ( [dic[@"display_type"] isEqualToString:@"17"] ||[dic[@"display_type"] isEqualToString:@"16"]) {//删除这两种类型
                    obj.unReadMsgCount -= 1;
                  NSString * string = (obj.sessionType == SessionTypeSessionTypeSingle)?@"2":@"1";
                  NSString*messageId = [NSString stringWithFormat:@"%@:%@",[NSString stringWithFormat:@"%ld",(long)obj.lastMsgID],@"1"];
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
                else
                {
                    if ([self getSessionById:obj.sessionID])
                    {
                        MTTSessionEntity *session = [self getSessionById:obj.sessionID];
                        NSInteger lostMsgCount =obj.lastMsgID-session.lastMsgID;
                        
                        if (lostMsgCount) {//获取未读消息
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                ChattingModule * mouble = [[ChattingModule alloc]init];
                                mouble.MTTSessionEntity = session;
                                [mouble loadHostoryMessageFromServer:session.lastMsgID Completion:^(NSUInteger addcount, NSError *error) {
                                    
                                }];
                            });
                        }
                        if ([[ChattingMainViewController shareInstance].module.MTTSessionEntity.sessionID isEqualToString:obj.sessionID])
                        {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChattingSessionUpdate" object:@{@"session":obj,@"count":@(lostMsgCount)}];
                        }
                        session=obj;
                        [[DDUserModule shareInstance] getUserForUserID:[NSString stringWithFormat:@"user_%ld",(long)obj.lastMsgFromUserId] Block:^(MTTUserEntity *user) {
                            session.lastMesageName = user.nick;
                            obj.lastMesageName = user.nick;
                            [self addToSessionModel:obj];
                            [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
                            }];
                        }];
                    }
                    else//第一次登陆时本地没有数据，需要将未读的消息保存到本地
                    {
                        [[DDUserModule shareInstance] getUserForUserID:[NSString stringWithFormat:@"user_%ld",(long)obj.lastMsgFromUserId] Block:^(MTTUserEntity *user) {
                            obj.lastMesageName = user.nick;
                            [self addToSessionModel:obj];
                            [[MTTDatabaseUtil instance] updateRecentSession:obj completion:^(NSError *error) {
                            }];
                        }];
                    }
                    //获取最后一条消息的时间
                    
                    ChattingModule * mouble = [[ChattingModule alloc]init];
                    mouble.MTTSessionEntity = obj;
                    [mouble loadLastMessage:obj.lastMsgID complete:^(MTTMessageEntity *message) {
                        if (!message) {
                            if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
                                [self.delegate sessionUpdate:obj Action:ADD];
                            }
                        }
                        obj.timeInterval = message.msgTime;
                        if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
                            [self.delegate sessionUpdate:obj Action:ADD];
                        }
                    }];
                    
                    
//                    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
//                        [self.delegate sessionUpdate:obj Action:ADD];
//                    }
                }
            }
            else
            {
                //语音是需要单独处理
                if ([obj.lastMsg isEqualToString:@"[语音]"]) {
                    if ([self getSessionById:obj.sessionID])
                    {
                        MTTSessionEntity *session = [self getSessionById:obj.sessionID];
                        NSInteger lostMsgCount =obj.lastMsgID-session.lastMsgID;
                        if ([[ChattingMainViewController shareInstance].module.MTTSessionEntity.sessionID isEqualToString:obj.sessionID])
                        {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChattingSessionUpdate" object:@{@"session":obj,@"count":@(lostMsgCount)}];
                        }
                        session=obj;
                        [[DDUserModule shareInstance] getUserForUserID:[NSString stringWithFormat:@"user_%ld",(long)obj.lastMsgFromUserId] Block:^(MTTUserEntity *user) {
                            session.lastMesageName = user.nick;
                            obj.lastMesageName = user.nick;
                            [self addToSessionModel:obj];
                            [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
                            }];
                        }];
                    }
                    else//第一次登陆时本地没有数据，需要将未读的消息保存到本地
                    {
                        [[DDUserModule shareInstance] getUserForUserID:[NSString stringWithFormat:@"user_%ld",(long)obj.lastMsgFromUserId] Block:^(MTTUserEntity *user) {
                            obj.lastMesageName = user.nick;
                            [self addToSessionModel:obj];
                            [[MTTDatabaseUtil instance] updateRecentSession:obj completion:^(NSError *error) {
                            }];
                        }];
                    }
                    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
                        [self.delegate sessionUpdate:obj Action:ADD];
                    }
                }
            }
//            if ([self getSessionById:obj.sessionID])
//            {
//                MTTSessionEntity *session = [self getSessionById:obj.sessionID];
//                NSInteger lostMsgCount =obj.lastMsgID-session.lastMsgID;
//                if ([[ChattingMainViewController shareInstance].module.MTTSessionEntity.sessionID isEqualToString:obj.sessionID])
//                {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChattingSessionUpdate" object:@{@"session":obj,@"count":@(lostMsgCount)}];
//                }
//                session=obj;
//                [[DDUserModule shareInstance] getUserForUserID:[NSString stringWithFormat:@"user_%ld",(long)obj.lastMsgFromUserId] Block:^(MTTUserEntity *user) {
//                session.lastMesageName = user.nick;
//                obj.lastMesageName = user.nick;
//                [self addToSessionModel:obj];
//                [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
//                  }];
//                }];
//            }
//            else//第一次登陆时本地没有数据，需要将未读的消息保存到本地
//            {
//                [[DDUserModule shareInstance] getUserForUserID:[NSString stringWithFormat:@"user_%ld",(long)obj.lastMsgFromUserId] Block:^(MTTUserEntity *user) {
//                    obj.lastMesageName = user.nick;
////                    MTTSessionEntity * session = (MTTSessionEntity*)obj;
////                    if (session.sessionType == SessionTypeSessionTypeGroup)
////                    {
////                        [[DDGroupModule instance] getGroupInfogroupID:session.sessionID completion:^(MTTGroupEntity *group) {
////                            if (group.groupUserIds.count) {
////                                [self addToSessionModel:obj];
////                                [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
////                                }];
////                            }
////                        }];
////                    }
////                    else
////                    {
////                        [self addToSessionModel:obj];
////                        [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
////                        }];
////                    }
//                    [self addToSessionModel:obj];
//                    [[MTTDatabaseUtil instance] updateRecentSession:obj completion:^(NSError *error) {
//                    }];
//                }];
//            }
//            if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
//                [self.delegate sessionUpdate:obj Action:ADD];
//            }
        }];
        //[self addSessionsToSessionModel:sessions];
        block(m_total_cnt);
        //通知外层sessionmodel发生更新
    }];
}

-(NSUInteger )getMaxTime
{
    NSArray *array =[self getAllSessions];
    NSUInteger maxTime = [[array valueForKeyPath:@"@max.timeInterval"] integerValue];
    if (maxTime) {
        return maxTime;
    }
    return 0;
}

#pragma mark 从服务器获取session

-(void)getRecentSession:(void(^)(NSUInteger count))block
{
    GetRecentSession *getRecentSession = [[GetRecentSession alloc] init];
    NSInteger localMaxTime = [self getMaxTime];
    [getRecentSession requestWithObject:@[@(localMaxTime)] Completion:^(NSArray *response, NSError *error) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:response];
        [self addSessionsToSessionModel:array];
        [self getHadUnreadMessageSession:^(NSUInteger count) {}];
        [[MTTDatabaseUtil instance] updateRecentSessions:response completion:^(NSError *error) {}];
        block(0);
    }];
}

-(NSArray *)getAllSessions
{
    NSArray *sessions = [self.sessions allValues];
    [sessions enumerateObjectsUsingBlock:^(MTTSessionEntity *obj, NSUInteger idx, BOOL *stop) {
        if([MTTUtil checkFixedTop:obj.sessionID]){
            obj.isFixedTop = YES;
        }
    }];
    return [self.sessions allValues];
}

-(void)removeSessionByServer:(MTTSessionEntity *)session
{
    if (!session) {
        return;
    }
    [self.sessions removeObjectForKey:session.sessionID];
    [[MTTDatabaseUtil instance] removeSession:session.sessionID];
//    RemoveSessionAPI *removeSession = [RemoveSessionAPI new];
//    SessionType sessionType = session.sessionType;
//    [removeSession requestWithObject:@[session.sessionID,@(sessionType)] Completion:^(id response, NSError *error) {
        [self deleteSession:session];
//    }];
}

-(void)deleteSession:(MTTSessionEntity*)session
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/delmsg.ashx",IPADDRESS];
    NSDictionary * dic = [NSDictionary dictionary];
    if (session.sessionType == SessionTypeSessionTypeSingle)//单个对话
    {
        NSString * string = session.singleReceiveId;
        NSArray * array = [string componentsSeparatedByString:@"_"];
        NSString * receiveStr = [NSString stringWithFormat:@"%@",array[1]];
        dic = @{@"action":@"delMsg",@"TallType":@"2",@"user_id":kShareModel.userId,@"friend_id":(receiveStr.length&& (![receiveStr isEqualToString:@"(null)"]))?receiveStr:([session.sessionID componentsSeparatedByString:@"_"][1]),@"password":kShareModel.password,@"username":kShareModel.username};
    }
    else
    {
        dic = @{@"action":@"delMsg",@"TallType":@"1",@"groupId":session.sessionID,@"password":kShareModel.password,@"username":kShareModel.username};
    }
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        NSLog(@"删除成功:%@",json);
    } failure:^(NSError *error) {
    }];
}

-(void)clearSession
{
    [self.sessions removeAllObjects];
}

-(void)getMessageReadACK:(NSNotification *)notification
{
      MTTMessageEntity* message = [notification object];
    if ([[self.sessions allKeys] containsObject:message.sessionId])
    {
        MTTSessionEntity *session = [self.sessions objectForKey:message.sessionId];
        session.unReadMsgCount=session.unReadMsgCount-1;
    }
}

- (void)playingStoped
{
}

#pragma mark - 播放提示音
- (void)playSound
{
    // 要播放的音频文件地址
    NSString *urlPath = [[NSBundle mainBundle] pathForResource:@"msg" ofType:@"caf"];
    NSURL *url = [NSURL fileURLWithPath:urlPath];
    // 声明需要播放的音频文件ID[unsigned long]
    SystemSoundID ID;
    // 创建系统声音，同时返回一个ID
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &ID);
    // 根据ID播放自定义系统声音
    AudioServicesPlaySystemSound(ID);
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

#pragma mark 在消息界面收到消息
- (void)n_receiveMessageNotification:(NSNotification*)notification
{
    //震动
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
      MTTMessageEntity* message = [notification object];
    //判断这个session是否开启消息免打扰
    [[MTTDatabaseUtil instance] loadSessionsCompletion:^(NSArray *session, NSError *error) {
        BOOL isEquOrNot = NO;
        MTTSessionEntity * sameSession;
        for (MTTSessionEntity* sessio in session)
        {
            if ([sessio.sessionID isEqualToString:message.sessionId])
            {
                isEquOrNot = YES;
                sameSession = sessio;
            }
        }
        if (isEquOrNot)
        {
            if (!sameSession.isShield)//没有开启消息免打扰
            {
                MessagerModel * model = [MessagerManager sharedManager].model;
                if ([model.voice isEqualToString:@"1"] && [model.shock isEqualToString:@"1"])
                {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    [self playSound];
                }
                else if ([model.voice isEqualToString:@"1"] && [model.shock isEqualToString:@"0"])
                {
                    [self playSound];
                }
                else if ([model.voice isEqualToString:@"0"]&&[model.shock isEqualToString:@"1"])
                {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
                else
                {
                
                }
            }
        }
        else
        {
            MessagerModel * model = [MessagerManager sharedManager].model;
            if ([model.voice isEqualToString:@"1"] && [model.shock isEqualToString:@"1"])
            {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                [self playSound];
            }
            else if ([model.voice isEqualToString:@"1"] && [model.shock isEqualToString:@"0"])
            {
                [self playSound];
            }
            else if ([model.voice isEqualToString:@"0"]&&[model.shock isEqualToString:@"1"])
            {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            else
            {
                
            }
        }
        
    }];
//    MessagerModel * model = [MessagerManager sharedManager].model;
//    if ([model.voice isEqualToString:@"1"] && [model.shock isEqualToString:@"1"]) {
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        [self playSound];
//    }
//    else if ([model.voice isEqualToString:@"1"] && [model.shock isEqualToString:@"0"])
//    {
//      [self playSound];
//    }
//    else if ([model.voice isEqualToString:@"0"]&&[model.shock isEqualToString:@"1"])
//    {
//      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    }
//    else
//    {
//    }
//      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//      [self playSound];
//    }

    //获取nickName
    [[DDUserModule shareInstance] getUserForUserID:message.senderId Block:^(MTTUserEntity *user) {
        
        
         [self sendUser:user andMessage:message];
//        if (!user)
//        {//本地没有这个人需要重新加载
//            DDAllUserAPI* api = [[DDAllUserAPI alloc] init];
//            [api requestWithObject:@[@(0)] Completion:^(id response, NSError *error) {
//                if (!error)
//                {
//                    NSUInteger responseVersion = [[response objectForKey:@"alllastupdatetime"] integerValue];
//                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//                    [defaults setObject:@(responseVersion) forKey:@"alllastupdatetime"];
//                    NSMutableArray *array = [response objectForKey:@"userlist"];
//                    [[MTTDatabaseUtil instance] insertAllUser:array completion:^(NSError *error) {
//                    }];
//                    for (MTTUserEntity * user in array) {
//                        if ([user.objID isEqualToString:message.senderId]) {
//                            [self sendUser:user andMessage:message];
//                            [[DDUserModule shareInstance] addMaintanceUser:user];
//                            break;
//                        }
//                    }
//                    
//                }
//                else
//                {
//                  [self sendUser:user andMessage:message];
//                }
//            }];
//        }
//        else
//        {
//            [self sendUser:user andMessage:message];
//        }
        
        
//       MTTSessionEntity *session;
//        if (user&&user.avatar.length > 0) {
//            session.nickName = user.nick;
//            session.lastMesageName = user.nick;
//        }
//        SessionType sessionType;
//        if ([message isGroupMessage]) {
//            sessionType = SessionTypeSessionTypeGroup;
//            
//        } else{
//            sessionType = SessionTypeSessionTypeSingle;
//        }
//        
//        if ([[self.sessions allKeys] containsObject:message.sessionId]) {
//            session = [self.sessions objectForKey:message.sessionId];
//            if (sessionType == SessionTypeSessionTypeSingle) {
//                session.singleReceiveId = message.senderId;
//            }
//
//            session.lastMsg=message.msgContent;
//            session.lastMsgID = message.msgID;
//            session.timeInterval = message.msgTime;
//            session.avatar = message.avatarStr;
//            session.lastMesageName = user.nick;
//            if (![message.sessionId isEqualToString:[ChattingMainViewController shareInstance].module.MTTSessionEntity.sessionID]) {
//                if (![message.senderId isEqualToString:TheRuntime.user.objID]) {
//                
//                    //发送的是邀请时不改变
//                    if (message.msgContentType != DDMEssageLitterInviteAndApply) {
//                       session.unReadMsgCount=session.unReadMsgCount+1;
//                        
//                        [self addSessionsToSessionModel:@[session]];
//                        session.senderId = message.senderId;
//                        session.lastMsgFromUserId = [[message.senderId substringFromIndex:5] integerValue];
//                        session.avatar = message.avatarStr;
//                        //新创建一个帐号时直接添加需要加载个人信息
//                        if (!session.avatar && session.sessionType == SessionTypeSessionTypeSingle) {
//                            
//                        }
//                        
//                        
//                        [self updateToDatabase:session];
//                        if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)])
//                        {
//                            [self.delegate sessionUpdate:session Action:ADD];
//                        }
//                    }
//                    else//改变群组的人数
//                    {
//                        session.unReadMsgCount=session.unReadMsgCount+1;
//                        MTTGroupEntity* group = [[MTTGroupEntity alloc]init];
//                        GetGroupInfoAPI* request = [[GetGroupInfoAPI alloc] init];
//                        [request requestWithObject:@[@([MTTUtil changeIDToOriginal:session.sessionID]),@(group.objectVersion)] Completion:^(id response, NSError *error) {
//                            if (!error)
//                            {
//                                if ([response count]) {
//                                    MTTGroupEntity* group = (MTTGroupEntity*)response[0];
//                                    if (group)
//                                    {
//                                        [[DDGroupModule instance] addGroup:group];
//                                        [[MTTDatabaseUtil instance] updateRecentGroup:group completion:^(NSError *error) {
//                                        }];
//                                        session.avatar = group.avatar;
//                                    }
//                                  
//                                }
//                                
//                            }
//                            
//                            [self addSessionsToSessionModel:@[session]];
//                            session.senderId = message.senderId;
//                            session.lastMsgFromUserId = [[message.senderId substringFromIndex:5] integerValue];
////                            session.avatar = message.avatarStr;
//                            [self updateToDatabase:session];
//                            
//                            if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
//                                [self.delegate sessionUpdate:session Action:ADD];
//                            }
//                        }];
//                    }
//                }
//            }
////            [self addSessionsToSessionModel:@[session]];
//            
//        }else{
//            session = [[MTTSessionEntity alloc] initWithSessionID:message.sessionId type:sessionType];
//            if (sessionType == SessionTypeSessionTypeSingle) {
//                session.singleReceiveId = message.senderId;
//            }
//            session.lastMsg=message.msgContent;
//            session.lastMesageName = user.nick;
//            session.lastMsgID = message.msgID;
//            session.timeInterval = message.msgTime;
//            session.avatar = message.avatarStr;
//            if (![message.sessionId isEqualToString:[ChattingMainViewController shareInstance].module.MTTSessionEntity.sessionID]) {
//                if (![message.senderId isEqualToString:TheRuntime.user.objID]) {
//                    
//                     //发送的是邀请时不改变
//                    if (message.msgContentType != DDMEssageLitterInviteAndApply) {
//                       session.unReadMsgCount=session.unReadMsgCount+1;
//                        
//                        [self addSessionsToSessionModel:@[session]];
//                        session.senderId = message.senderId;
//                        session.lastMsgFromUserId = [[message.senderId substringFromIndex:5] integerValue];
//                        session.avatar = message.avatarStr;
//                        [self updateToDatabase:session];
//                        if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
//                            [self.delegate sessionUpdate:session Action:ADD];
//                        }
//                    }
//                    else
//                    {
//                        session.unReadMsgCount=session.unReadMsgCount+1;
//                        MTTGroupEntity* group = [[MTTGroupEntity alloc]init];
//                        GetGroupInfoAPI* request = [[GetGroupInfoAPI alloc] init];
//                        [request requestWithObject:@[@([MTTUtil changeIDToOriginal:session.sessionID]),@(group.objectVersion)] Completion:^(id response, NSError *error) {
//                            if (!error)
//                            {
//                                if ([response count]) {
//                                    MTTGroupEntity* group = (MTTGroupEntity*)response[0];
//                                    if (group)
//                                    {
//                                        [[DDGroupModule instance] addGroup:group];
//                                        [[MTTDatabaseUtil instance] updateRecentGroup:group completion:^(NSError *error) {
//                                            DDLog(@"insert group to database error.");
//                                        }];
//                                        session.avatar = group.avatar;
//                                    }
//                                }
//                            }
//                            
//                            //发起群聊直接发消息时如果在后台运行会出现未读个数不对的情况
//                            if ([self.sessions containsObjectForKey:session.sessionID]) {
//                                MTTSessionEntity * sess = [self getSessionById:session.sessionID];
//                                session.unReadMsgCount = sess.unReadMsgCount+1;
//                            }
//                            
//                            
//                            
//                            
//                            [self addSessionsToSessionModel:@[session]];
//                            session.senderId = message.senderId;
//                            session.lastMsgFromUserId = [[message.senderId substringFromIndex:5] integerValue];
//
//                            [self updateToDatabase:session];
//                            if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
//                                [self.delegate sessionUpdate:session Action:ADD];
//                            }
//                        }];
//                    }
//                }
//            }
//        }
    }];
   
}
-(void)sendUser:(MTTUserEntity*)user andMessage:(MTTMessageEntity*)message
{
    MTTSessionEntity *session;
    if (user&&user.avatar.length > 0) {
        session.nickName = user.nick;
        session.lastMesageName = user.nick;
    }
    SessionType sessionType;
    if ([message isGroupMessage]) {
        sessionType = SessionTypeSessionTypeGroup;
        
    } else{
        sessionType = SessionTypeSessionTypeSingle;
    }
    
    if ([[self.sessions allKeys] containsObject:message.sessionId]) {
        session = [self.sessions objectForKey:message.sessionId];
        if (sessionType == SessionTypeSessionTypeSingle) {
            session.singleReceiveId = message.senderId;
        }
        
        session.lastMsg=message.msgContent;
        session.lastMsgID = message.msgID;
        session.timeInterval = message.msgTime;
        session.avatar = message.avatarStr;
        session.lastMesageName = user.nick;
        if (!([ChattingMainViewController shareInstance].isCurrentVC)) {//[message.sessionId isEqualToString:[ChattingMainViewController shareInstance].module.MTTSessionEntity.sessionID]
            if (![message.senderId isEqualToString:TheRuntime.user.objID]) {
                
                //发送的是邀请时不改变
                if (message.msgContentType != DDMEssageLitterInviteAndApply) {
                    session.unReadMsgCount=session.unReadMsgCount+1;
                    
                    [self addSessionsToSessionModel:@[session]];
                    session.senderId = message.senderId;
                    session.lastMsgFromUserId = [[message.senderId substringFromIndex:5] integerValue];
                    session.avatar = message.avatarStr;
                    //新创建一个帐号时直接添加需要加载个人信息
                    if (!session.avatar && session.sessionType == SessionTypeSessionTypeSingle) {
                        
                    }
                    
                    
                    [self updateToDatabase:session];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)])
                    {
                        [self.delegate sessionUpdate:session Action:ADD];
                    }
                }
                else//改变群组的人数
                {
                    session.unReadMsgCount=session.unReadMsgCount+1;
                    MTTGroupEntity* group = [[MTTGroupEntity alloc]init];
                    GetGroupInfoAPI* request = [[GetGroupInfoAPI alloc] init];
                    [request requestWithObject:@[@([MTTUtil changeIDToOriginal:session.sessionID]),@(group.objectVersion)] Completion:^(id response, NSError *error) {
                        if (!error)
                        {
                            if ([response count]) {
                                MTTGroupEntity* group = (MTTGroupEntity*)response[0];
                                if (group)
                                {
                                    [[DDGroupModule instance] addGroup:group];
                                    [[MTTDatabaseUtil instance] updateRecentGroup:group completion:^(NSError *error) {
                                    }];
                                    session.avatar = group.avatar;
                                }
                                
                            }
                            
                        }
                        
                        [self addSessionsToSessionModel:@[session]];
                        session.senderId = message.senderId;
                        session.lastMsgFromUserId = [[message.senderId substringFromIndex:5] integerValue];
                        //                            session.avatar = message.avatarStr;
                        [self updateToDatabase:session];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
                            [self.delegate sessionUpdate:session Action:ADD];
                        }
                    }];
                }
            }
        }
        else//退出消息内容界面是收到相同的session的消息
        {
        }
        //            [self addSessionsToSessionModel:@[session]];
        
    }else{
        session = [[MTTSessionEntity alloc] initWithSessionID:message.sessionId type:sessionType];
        if (sessionType == SessionTypeSessionTypeSingle) {
            session.singleReceiveId = message.senderId;
        }
        session.lastMsg=message.msgContent;
        session.lastMesageName = user.nick;
        session.lastMsgID = message.msgID;
        session.timeInterval = message.msgTime;
        session.avatar = message.avatarStr;
        if (!([ChattingMainViewController shareInstance].isCurrentVC)) {////[message.sessionId isEqualToString:[ChattingMainViewController shareInstance].module.MTTSessionEntity.sessionID]
            if (![message.senderId isEqualToString:TheRuntime.user.objID]) {
                
                //发送的是邀请时不改变
                if (message.msgContentType != DDMEssageLitterInviteAndApply) {
                    session.unReadMsgCount=session.unReadMsgCount+1;
                    
                    [self addSessionsToSessionModel:@[session]];
                    session.senderId = message.senderId;
                    session.lastMsgFromUserId = [[message.senderId substringFromIndex:5] integerValue];
                    session.avatar = message.avatarStr;
                    [self updateToDatabase:session];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
                        [self.delegate sessionUpdate:session Action:ADD];
                    }
                }
                else
                {
                    session.unReadMsgCount=session.unReadMsgCount+1;
                    MTTGroupEntity* group = [[MTTGroupEntity alloc]init];
                    GetGroupInfoAPI* request = [[GetGroupInfoAPI alloc] init];
                    [request requestWithObject:@[@([MTTUtil changeIDToOriginal:session.sessionID]),@(group.objectVersion)] Completion:^(id response, NSError *error) {
                        if (!error)
                        {
                            if ([response count]) {
                                MTTGroupEntity* group = (MTTGroupEntity*)response[0];
                                if (group)
                                {
                                    [[DDGroupModule instance] addGroup:group];
                                    [[MTTDatabaseUtil instance] updateRecentGroup:group completion:^(NSError *error) {
                                        DDLog(@"insert group to database error.");
                                    }];
                                    session.avatar = group.avatar;
                                }
                            }
                        }
                        
                        //发起群聊直接发消息时如果在后台运行会出现未读个数不对的情况
                        if ([self.sessions containsObjectForKey:session.sessionID]) {
                            MTTSessionEntity * sess = [self getSessionById:session.sessionID];
                            session.unReadMsgCount = sess.unReadMsgCount+1;
                        }
                        
                        
                        
                        
                        [self addSessionsToSessionModel:@[session]];
                        session.senderId = message.senderId;
                        session.lastMsgFromUserId = [[message.senderId substringFromIndex:5] integerValue];
                        
                        [self updateToDatabase:session];
                        if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
                            [self.delegate sessionUpdate:session Action:ADD];
                        }
                    }];
                }
            }
        }
    }

}
-(void)updateToDatabase:(MTTSessionEntity *)session{
    [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
        
    }];
}
-(void)sentMessageSuccessfull:(NSNotification*)notification
{
    MTTSessionEntity* session = [notification object];
    session.senderId = TheRuntime.user.objID;
    session.singleSendId = TheRuntime.user.objID;
    session.lastMsgFromUserId = [[TheRuntime.user.objID substringFromIndex:5] integerValue];
    
    [self addSessionsToSessionModel:@[session]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
        [self.delegate sessionUpdate:session Action:ADD];
    }
     [self updateToDatabase:session];
}
-(void)deleteMessageSuccess:(NSNotification*)notification
{
     MTTSessionEntity* session = [notification object];
    session.senderId = TheRuntime.user.objID;
    session.lastMsgFromUserId = [[TheRuntime.user.objID substringFromIndex:5] integerValue];
    [self addSessionsToSessionModel:@[session]];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)])
    {
        [self.delegate sessionUpdate:session Action:DELETE];
    }
    [self updateToDatabase:session];
}
-(void)loadLocalSession:(void(^)(bool isok))block
{
    [[MTTDatabaseUtil instance] loadSessionsCompletion:^(NSArray *session, NSError *error) {
        [self addSessionsToSessionModel:session];
        block(YES);
        
    }];

}
-(void)cleanMessageFromNotifi:(NSUInteger)messageID  SessionID:(NSString *)sessionid Session:(SessionType)type
{
    if(![sessionid isEqualToString:TheRuntime.user.objID]){
        MTTSessionEntity *session = [self getSessionById:sessionid];
        if (session) {
            NSInteger readCount =messageID-session.lastMsgID;
            if (readCount == 0) {
                session.unReadMsgCount =0;
                if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
                    [self.delegate sessionUpdate:session Action:ADD];
                }
                [self updateToDatabase:session];
                
            }else if(readCount > 0){
                session.unReadMsgCount =readCount;
                if (self.delegate && [self.delegate respondsToSelector:@selector(sessionUpdate:Action:)]) {
                    [self.delegate sessionUpdate:session Action:ADD];
                }
                [self updateToDatabase:session];
            }
            MsgReadACKAPI* readACK = [[MsgReadACKAPI alloc] init];
            [readACK requestWithObject:@[sessionid,@(messageID),@(type)] Completion:nil];
        }
        
    }
}

@end
