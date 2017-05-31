//
//  LoadLocalData.m
//  WP
//
//  Created by CC on 16/11/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "LoadLocalData.h"
#import "DDClientState.h"
#import "MTTUserEntity.h"
#import "MTTDatabaseUtil.h"
#import "SessionModule.h"
#import "DDGroupModule.h"
#import "SpellLibrary.h"
#import "DDUserModule.h"
#import "DDAllUserAPI.h"
@implementation LoadLocalData
{
    NSString * _priorIP;
    NSInteger _port;
    NSString* _lastLoginPassword;
    NSString* _lastLoginUserName;
    BOOL _relogining;
}
+(instancetype)instance
{
    static LoadLocalData*loadData;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadData = [[LoadLocalData alloc]init];
    });
    return loadData;
}
-(void)loadLocalData:(NSString*)password nameStr:(NSString*)name success:(void(^)())Success
{
    NSDictionary * dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"serveDic"];
    _priorIP = [dictionary objectForKey:@"priorIP"];
    _port    =  [[dictionary objectForKey:@"port"] integerValue];
    [MTTUtil setMsfsUrl:[dictionary objectForKey:@"msfsPrior"]];
//    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
//    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"username"];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autologin"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    _lastLoginPassword=password;
//    _lastLoginUserName=name;
//    DDClientState* clientState = [DDClientState shareInstance];
//    clientState.userState=DDUserOffLine;
//    _relogining=NO;
    
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"runTimeUser"];
    MTTUserEntity* user = [[MTTUserEntity alloc]init];
    user.name = dic[@"name"];
    user.nick = dic[@"nick"];
    user.avatar = dic[@"avatar"];
    user.department = dic[@"department"];
    user.signature = dic[@"signature"];
    user.position = dic[@"position"];
    user.sex = [dic[@"sex"] integerValue];
    user.departId = dic[@"departId"];
    user.telphone = dic[@"telphone"];
    user.email = dic[@"email"];
    user.pyname = dic[@"pyname"];
    user.userStatus = [dic[@"userStatus"] integerValue];
    user.lastUpdateTime = [dic[@"lastUpdateTime"] longValue];
    user.objID = dic[@"objID"];
    user.objectVersion = [dic[@"objectVersion"] integerValue];
    TheRuntime.user=user;
    [[MTTDatabaseUtil instance] openCurrentUserDB];
    [[SessionModule instance] loadLocalSession:^(bool isok) {
    }];
    //加载所有人信息,创建检索拼音
    [self p_loadAllUsersCompletion:^{
        if ([[SpellLibrary instance] isEmpty]) {
                [[[DDUserModule shareInstance] getAllMaintanceUser] enumerateObjectsUsingBlock:^(MTTUserEntity *obj, NSUInteger idx, BOOL *stop) {
                    [[SpellLibrary instance] addSpellForObject:obj];
                    [[SpellLibrary instance] addDeparmentSpellForObject:obj];
                }];
                NSArray *array =  [[DDGroupModule instance] getAllGroups];
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [[SpellLibrary instance] addSpellForObject:obj];
                }];
        }
        Success();
    }];
    
    
}
- (void)p_loadAllUsersCompletion:(void(^)())completion
{
    __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    __block NSInteger version = [[defaults objectForKey:@"alllastupdatetime"] integerValue];
    [[MTTDatabaseUtil instance] getAllUsers:^(NSArray *contacts, NSError *error) {
        if ([contacts count] !=0) {
            [contacts enumerateObjectsUsingBlock:^(MTTUserEntity *obj, NSUInteger idx, BOOL *stop) {
                [[DDUserModule shareInstance] addMaintanceUser:obj];
            }];
            if (completion !=nil) {
                completion();
            }
        }else{
            version=0;
            DDAllUserAPI* api = [[DDAllUserAPI alloc] init];
            [api requestWithObject:@[@(version)] Completion:^(id response, NSError *error) {
                if (!error)
                {
                    NSUInteger responseVersion = [[response objectForKey:@"alllastupdatetime"] integerValue];
                    if (responseVersion == version && responseVersion !=0) {
                        
                        return ;
                        
                    }
                    [defaults setObject:@(responseVersion) forKey:@"alllastupdatetime"];
                    NSMutableArray *array = [response objectForKey:@"userlist"];
                    [[MTTDatabaseUtil instance] insertAllUser:array completion:^(NSError *error) {
                        
                    }];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [array enumerateObjectsUsingBlock:^(MTTUserEntity *obj, NSUInteger idx, BOOL *stop) {
                            [[DDUserModule shareInstance] addMaintanceUser:obj];
                        }];
                        
                        dispatch_async(dispatch_get_main_queue(),^{
                            if (completion !=nil) {
                                completion();
                            }
                        });
                        
                    });
                    
                    
                }
            }];
        }
    }];
    
    DDAllUserAPI* api = [[DDAllUserAPI alloc] init];
    [api requestWithObject:@[@(version)] Completion:^(id response, NSError *error) {
        if (!error)
        {
            NSUInteger responseVersion = [[response objectForKey:@"alllastupdatetime"] integerValue];
            if (responseVersion == version && responseVersion !=0) {
                return ;
            }
            [defaults setObject:@(responseVersion) forKey:@"alllastupdatetime"];
            NSMutableArray *array = [response objectForKey:@"userlist"];
            [[MTTDatabaseUtil instance] insertAllUser:array completion:^(NSError *error) {
                
            }];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [array enumerateObjectsUsingBlock:^(MTTUserEntity *obj, NSUInteger idx, BOOL *stop) {
                    [[DDUserModule shareInstance] addMaintanceUser:obj];
                }];
            });
        }
    }];
    
}
@end
