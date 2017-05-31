//
//  DDUserModule.m
//  IOSDuoduo
//
//  Created by 独嘉 on 14-5-26.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import "DDUserModule.h"
#import "MTTDatabaseUtil.h"
#import "MTTNotification.h"
#import "DDAllUserAPI.h"
@interface DDUserModule(PrivateAPI)

- (void)n_receiveUserLogoutNotification:(NSNotification*)notification;
- (void)n_receiveUserLoginNotification:(NSNotification*)notification;
@end

@implementation DDUserModule
{
    NSMutableDictionary* _allUsers;
    NSMutableDictionary* _allUsersNick;
    NSMutableDictionary* _offLineMan;
}

+ (instancetype)shareInstance
{
    static DDUserModule* g_userModule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_userModule = [[DDUserModule alloc] init];
    });
    return g_userModule;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _allUsers = [[NSMutableDictionary alloc] init];
        _recentUsers = [[NSMutableDictionary alloc] init];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(n_receiveUserLogoutNotification:) name:MGJUserDidLogoutNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(n_receiveUserLoginNotification:) name:DDNotificationUserLoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(n_receiveUserLoginNotification:) name:DDNotificationUserReloginSuccess object:nil];
        

    }
    return self;
}

-(void)addOffLineMa:(MTTUserEntity*)user
{
    if (!user) {
        return;
    }
    if (!user.objID) {
        return;
    }
    
    if (!_offLineMan) {
        _offLineMan = [NSMutableDictionary dictionary];
    }
    [_offLineMan setObject:user forKey:user.objID];
}
-(void)getOffLine:(NSString*)userid Block:(void(^)(MTTUserEntity *user))block
{
    MTTUserEntity * user = _offLineMan[userid];
    block(user);
}
-(MTTUserEntity*)offLineUser:(NSString*)userID
{
  MTTUserEntity * user = _offLineMan[userID];
    return user;
}
-(void)reMoveOffline:(NSString*)userID
{
    [_offLineMan removeObjectForKey:userID];
}
- (void)addMaintanceUser:(MTTUserEntity*)user
{
    
    if (!user)
    {
        return;
    }
    if (!user.objID) {
        return;
    }
    if (!_allUsers)
    {
        _allUsers = [[NSMutableDictionary alloc] init];
    }
    if(!_allUsersNick)
    {
        _allUsersNick = [[NSMutableDictionary alloc] init];
    }
    [_allUsers setValue:user forKey:user.objID];
    [_allUsersNick setValue:user forKey:user.nick];
    
}
-(NSArray *)getAllUsersNick
{
    return [_allUsersNick allKeys];
}
-(MTTUserEntity *)getUserByNick:(NSString *)nickName
{
//    NSInteger index = [[self getAllUsersNick] indexOfObject:nickName];
    return [_allUsersNick objectForKey:nickName];
}
-(NSArray *)getAllMaintanceUser
{
    return [_allUsers allValues];
}
-(void)getUserFromUserID:(NSString*)userID Block:(void(^)(MTTUserEntity *user))block
{
    MTTUserEntity * user = _allUsers[userID];
    block(user);
}
- (void )getUserForUserID:(NSString*)userID Block:(void(^)(MTTUserEntity *user))block
{
//    return block(_allUsers[userID]);
    
    MTTUserEntity * use = _allUsers[userID];
    if (!use) {//user 不存在需要重新加载
        DDAllUserAPI* api = [[DDAllUserAPI alloc] init];
        [api requestWithObject:@[@(0)] Completion:^(id response, NSError *error) {
            if (!error)
            {
                NSUInteger responseVersion = [[response objectForKey:@"alllastupdatetime"] integerValue];
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@(responseVersion) forKey:@"alllastupdatetime"];
                NSMutableArray *array = [response objectForKey:@"userlist"];
                [[MTTDatabaseUtil instance] insertAllUser:array completion:^(NSError *error) {
                }];
                
               
                
                for (MTTUserEntity * user in array) {
                    [[DDUserModule shareInstance] addMaintanceUser:user];
                    
                    if ([user.objID isEqualToString:[NSString stringWithFormat:@"user_%@",userID]]) {
                        [[DDUserModule shareInstance] addMaintanceUser:user];
                        return block(user);
                    }
                }
                
            }
        }];
    }
    else
    {
       return block(_allUsers[userID]);
    }
   return block(_allUsers[userID]);

}

- (void)addRecentUser:(MTTUserEntity*)user
{
    if (!user)
    {
        return;
    }
    if (!self.recentUsers)
    {
        self.recentUsers = [[NSMutableDictionary alloc] init];
    }
    NSArray* allKeys = [self.recentUsers allKeys];
    if (![allKeys containsObject:user.objID])
    {
        [self.recentUsers setValue:user forKey:user.objID];
        [[MTTDatabaseUtil instance] insertUsers:@[user] completion:^(NSError *error) {
        }];
    }
}

-(void)upDateUser:(MTTUserEntity*)user
{
    [self.recentUsers setValue:user forKey:user.objID];
//    [[MTTDatabaseUtil instance] insertUsers:@[user] completion:^(NSError *error) {
//    }];
}


- (void)loadAllRecentUsers:(DDLoadRecentUsersCompletion)completion
{
    
    //加载本地最近联系人
    }

#pragma mark - 
#pragma mark PrivateAPI

- (void)n_receiveUserLogoutNotification:(NSNotification*)notification
{
    //用户登出
    _recentUsers = nil;
}

- (void)n_receiveUserLoginNotification:(NSNotification*)notification
{
    if (!_recentUsers)
    {
        _recentUsers = [[NSMutableDictionary alloc] init];
        [self loadAllRecentUsers:^{
            [MTTNotification postNotification:DDNotificationRecentContactsUpdate userInfo:nil object:nil];
        }];
    }
}
-(void)clearRecentUser
{
    DDUserModule* userModule = [DDUserModule shareInstance];
    [[userModule recentUsers] removeAllObjects];
}


-(void)addNewFriend:(NSString*)mobile
{
    //将好友信息添加到本地
    [self getPeopleInfo:mobile success:^(id json) {
        NSDictionary * dic = (NSDictionary*)json;
        if (!dic.count) {
            return ;
        }
        MTTUserEntity * user = [[MTTUserEntity alloc]init];
        user.objID = dic[@"id"];
        user.avatar = dic[@"avatar"];
        user.name = dic[@"user_name"];
        user.nick = dic[@"nick_name"];
        [[MTTDatabaseUtil instance] insertAllUser:@[user] completion:^(NSError *error) {
        }];
        [self addMaintanceUser:user];
    } failed:^(NSError *error) {
    }];
}
-(void)getPeopleInfo:(NSString*)mobile success:(void(^)(id))Success failed:(void(^)(NSError*))Failed
{
    NSDictionary * dic = @{@"action":@"userinfo",@"mobile":mobile,@"username":kShareModel.username,@"password":kShareModel.password};
    NSString * urlStr = [NSString stringWithFormat:@"%@/userInfo.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        Success(json);
    } failure:^(NSError *error) {
        Failed(error);
    }];
}


@end
