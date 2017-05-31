//
//  DDGroupModule.m
//  IOSDuoduo
//
//  Created by Michael Scofield on 2014-08-11.
//  Copyright (c) 2014 dujia. All rights reserved.
//

#import "DDGroupModule.h"
#import "RuntimeStatus.h"
#import "GetGroupInfoAPi.h"
#import "DDReceiveGroupAddMemberAPI.h"
#import "MTTDatabaseUtil.h"
#import "MTTNotification.h"
#import "NSDictionary+Safe.h"
#import "IMGroup.pb.h"
//#import "DDReceiveGroupDeleteMemberAPI.h"
@implementation DDGroupModule
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allGroups = [NSMutableDictionary new];
        [[MTTDatabaseUtil instance] loadGroupsCompletion:^(NSArray *contacts, NSError *error) {
            [contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                MTTGroupEntity *group = (MTTGroupEntity *)obj;
                if(group.objID)
                {
                    [self addGroup:group];
                    GetGroupInfoAPI* request = [[GetGroupInfoAPI alloc] init];
                    [request requestWithObject:@[@([MTTUtil changeIDToOriginal:group.objID]),@(group.objectVersion)] Completion:^(id response, NSError *error) {
                        if (!error)
                        {
                            if ([response count]) {
                                MTTGroupEntity* group = (MTTGroupEntity*)response[0];
                                if (group)
                                {
                                    [self addGroup:group];
                                    [[MTTDatabaseUtil instance] updateRecentGroup:group completion:^(NSError *error) {
                                        DDLog(@"insert group to database error.");
                                    }];
                                }
                            }
                            
                        }
                    }];

                }
            }];
        }];
        [self registerAPI];
    }
    return self;
}

+ (instancetype)instance
{
    static DDGroupModule* group;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        group = [[DDGroupModule alloc] init];
        
    });
    return group;
}
-(void)getGroupFromDB
{
    
}
-(void)addGroup:(MTTGroupEntity*)newGroup
{
    if (!newGroup)
    {
        return;
    }
    MTTGroupEntity* group = newGroup;
    [_allGroups setObject:group forKey:group.objID];
    newGroup = nil;
}
-(NSArray*)getAllGroups
{
    return [_allGroups allValues];
}
-(MTTGroupEntity*)getGroupByGId:(NSString*)gId
{
    
    MTTGroupEntity *entity= [_allGroups safeObjectForKey:gId];
  
    return entity;
}

- (void)getGroupInfogroupID:(NSString*)groupID completion:(GetGroupInfoCompletion)completion
{
    MTTGroupEntity *group = [self getGroupByGId:groupID];
    if (group) {
        completion(group);
    }else{
        GetGroupInfoAPI* request = [[GetGroupInfoAPI alloc] init];
        [request requestWithObject:@[@([MTTUtil changeIDToOriginal:groupID]),@(group.objectVersion)] Completion:^(id response, NSError *error) {
            if (!error)
            {
                if ([response count]) {
                    MTTGroupEntity* group = (MTTGroupEntity*)response[0];
                    if (group)
                    {
                        [self addGroup:group];
                        [[MTTDatabaseUtil instance] updateRecentGroup:group completion:^(NSError *error) {
                        }];
                    }
                    completion(group);
                }
                
            }
        }];
    }
}

-(void)getGroupAgain:(NSString*)groupID complete:(GetGroupInfoCompletion)completion
{
     MTTGroupEntity *group = [self getGroupByGId:groupID];
    GetGroupInfoAPI* request = [[GetGroupInfoAPI alloc] init];
    [request requestWithObject:@[@([MTTUtil changeIDToOriginal:groupID]),@(group.objectVersion)] Completion:^(id response, NSError *error) {
        if (!error)
        {
            if ([response count]) {
                MTTGroupEntity* group = (MTTGroupEntity*)response[0];
                if (group)
                {
                    [self addGroup:group];
                    [[MTTDatabaseUtil instance] updateRecentGroup:group completion:^(NSError *error) {
                    }];
                }
                completion(group);
            }
            
        }
    }];

}
-(BOOL)isContainGroup:(NSString*)gId
{
    return ([_allGroups valueForKey:gId] != nil);
}

- (void)registerAPI
{
    DDReceiveGroupAddMemberAPI* addmemberAPI = [[DDReceiveGroupAddMemberAPI alloc] init];
    [addmemberAPI registerAPIInAPIScheduleReceiveData:^(id object, NSError *error) {
        if (!error)
        {
            IMGroupChangeMemberNotify*notifi = (IMGroupChangeMemberNotify*)object;
            if (notifi) {
                if (notifi.changeType == GroupModifyTypeGroupModifyTypeDel)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DELETEGROUPSESSION" object:notifi];
                }
                else
                {
                    
                    [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%u",(unsigned int)notifi.groupId] completion:^(MTTGroupEntity *group) {
//                        [group.groupUserIds addObject:[NSString stringWithFormat:@"user_%u",(unsigned int)notifi.userId]];
//                        [group.fixGroupUserIds addObject:[NSString stringWithFormat:@"user_%u",(unsigned int)notifi.userId]];
//                        if (!group.avatar) {
                            [[DDGroupModule instance] getGroupAgain:[NSString stringWithFormat:@"group_%u",(unsigned int)notifi.groupId] complete:^(MTTGroupEntity *group) {
                            }];
//                        }
                        
//                        user_
                        NSLog(@"%@====%@",group.groupUserIds,notifi.curUserIdList);
//                        [group.groupUserIds removeObject:[NSString stringWithFormat:@"user_%u",(unsigned int)notifi.userId]];
//                        [[DDGroupModule instance] addGroup:group];
//                        if (!notifi.curUserIdList.count)//群组解散
//                        {
//                            MTTSessionEntity * session = [[SessionModule instance] getSessionById:group.objID];
//                            [[SessionModule instance] removeSessionByServer:session];
//                            
//                        }
                       
                    }];
                }
            }
            
            
//            if (!groupEntity)
//            {
//                return;
//            }
//            if ([self getGroupByGId:groupEntity.objID])
//            {
//                //自己本身就在组中
//            }
//            else
//            {
//                //自己被添加进组中
//                groupEntity.lastUpdateTime = [[NSDate date] timeIntervalSince1970];
//                [[DDGroupModule instance] addGroup:groupEntity];
//                [[NSNotificationCenter defaultCenter] postNotificationName:DDNotificationRecentContactsUpdate object:nil];
//            }
        }
        else
        {
            DDLog(@"error:%@",[error domain]);
        }
    }];
    
//    DDReceiveGroupDeleteMemberAPI* deleteMemberAPI = [[DDReceiveGroupDeleteMemberAPI alloc] init];
//    [deleteMemberAPI registerAPIInAPIScheduleReceiveData:^(id object, NSError *error) {
//        if (!error)
//        {
//            MTTGroupEntity* MTTGroupEntity = (MTTGroupEntity*)object;
//            if (!MTTGroupEntity)
//            {
//                return;
//            }
//            DDUserlistModule* userModule = getDDUserlistModule();
//            if ([MTTGroupEntity.groupUserIds containsObject:userModule.myUserId])
//            {
//                //别人被踢了
//                [[DDMainWindowController instance] updateCurrentChattingViewController];
//            }
//            else
//            {
//                //自己被踢了
//                [self.recentlyGroupIds removeObject:MTTGroupEntity.groupId];
//                DDSessionModule* sessionModule = getDDSessionModule();
//                [sessionModule.recentlySessionIds removeObject:MTTGroupEntity.groupId];
//                DDMessageModule* messageModule = getDDMessageModule();
//                [messageModule popArrayMessage:MTTGroupEntity.groupId];
//                [NotificationHelp postNotification:notificationReloadTheRecentContacts userInfo:nil object:nil];
//            }
//        }
//    }];
}


@end
