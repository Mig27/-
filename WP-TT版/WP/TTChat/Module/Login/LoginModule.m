//
//  DDLoginManager.m
//  Duoduo
//
//  Created by 独嘉 on 14-4-5.
//  Copyright (c) 2015年 MoguIM All rights reserved.
//

#import "LoginModule.h"
#import "DDHttpServer.h"
#import "DDMsgServer.h"
#import "DDTcpServer.h"
#import "SpellLibrary.h"
#import "DDUserModule.h"
#import "MTTUserEntity.h"
#import "DDClientState.h"
#import "RuntimeStatus.h"
#import "ContactsModule.h"
#import "MTTDatabaseUtil.h"
#import "DDAllUserAPI.h"
#import "LoginAPI.h"
#import "MTTNotification.h"
#import "SessionModule.h"
#import "DDGroupModule.h"
#import "MTTUtil.h"
#import "DDFixedGroupAPI.h"
#import "IMBaseDefine.pb.h"
#import "GetGroupInfoAPI.h"
#import "MTTSessionEntity.h"
@interface LoginModule(privateAPI)

- (void)p_loadAfterHttpServerWithToken:(NSString*)token userID:(NSString*)userID dao:(NSString*)dao password:(NSString*)password uname:(NSString*)uname success:(void(^)(MTTUserEntity* loginedUser))success failure:(void(^)(NSString* error))failure;
- (void)reloginAllFlowSuccess:(void(^)())success failure:(void(^)())failure;

@end

@implementation LoginModule
{
    NSString* _lastLoginUser;       //最后登录的用户ID
    NSString* _lastLoginPassword;
    NSString* _lastLoginUserName;
    NSString* _dao;
    NSString * _priorIP;
    NSInteger _port;
    BOOL _relogining;
    BOOL _isGroupChnage;
}
+ (instancetype)instance
{
    static LoginModule *g_LoginManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_LoginManager = [[LoginModule alloc] init];
    });
    return g_LoginManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _httpServer = [[DDHttpServer alloc] init];
        _msgServer = [[DDMsgServer alloc] init];
        _tcpServer = [[DDTcpServer alloc] init];
        _relogining = NO;
    }
    return self;
}


#pragma mark Public API
- (void)loginWithUsername:(NSString*)name password:(NSString*)password success:(void(^)(MTTUserEntity* loginedUser))success failure:(void(^)(NSString* error))failure
{
    [_httpServer getMsgIp:^(NSDictionary *dic) {
        NSInteger code  = [[dic objectForKey:@"code"] integerValue];
        if (code == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"serveDic"];
            _priorIP = [dic objectForKey:@"priorIP"];
            _port    =  [[dic objectForKey:@"port"] integerValue];
            [MTTUtil setMsfsUrl:[dic objectForKey:@"msfsPrior"]];
            [_tcpServer loginTcpServerIP:_priorIP port:_port Success:^{
                [_msgServer checkUserID:name Pwd:password token:@"" success:^(id object) {
                    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
                    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"username"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autologin"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
    
                    _lastLoginPassword=password;
                    _lastLoginUserName=name;
                    DDClientState* clientState = [DDClientState shareInstance];
                    clientState.userState=DDUserOnline;
                    _relogining=YES;
                    MTTUserEntity* user = object[@"user"];
                    TheRuntime.user=user;
                    
                    NSDictionary * saveDic = @{@"name":user.name,
                                               @"nick":user.nick,
                                               @"avatar":user.avatar,
                                               @"department":user.department,
                                               @"signature":user.signature,
                                               @"position":user.position,
                                               @"sex":[NSString stringWithFormat:@"%ld",(long)user.sex],
                                               @"departId":user.departId,
                                               @"telphone":user.telphone,
                                               @"email":user.email,
                                               @"pyname":user.pyname,
                                               @"userStatus":[NSString stringWithFormat:@"%ld",(long)user.userStatus],
                                               @"lastUpdateTime":[NSString stringWithFormat:@"%ld",user.lastUpdateTime],
                                              @"objID":user.objID,
                                              @"objectVersion":[NSString stringWithFormat:@"%ld",(long)user.objectVersion]};
                    [[NSUserDefaults standardUserDefaults] setObject:saveDic forKey:@"runTimeUser"];
                    
                    
                    [[MTTDatabaseUtil instance] openCurrentUserDB];
                    //加载所有人信息，创建检索拼音
                    [self p_loadAllUsersCompletion:^{
                        
                        if ([[SpellLibrary instance] isEmpty]) {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                [[[DDUserModule shareInstance] getAllMaintanceUser] enumerateObjectsUsingBlock:^(MTTUserEntity *obj, NSUInteger idx, BOOL *stop) {
                                    [[SpellLibrary instance] addSpellForObject:obj];
                                    [[SpellLibrary instance] addDeparmentSpellForObject:obj];
                                }];
                                NSArray *array =  [[DDGroupModule instance] getAllGroups];
                                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                    [[SpellLibrary instance] addSpellForObject:obj];
                                }];
                            });
                        }
                    }];
                    [[SessionModule instance] loadLocalSession:^(bool isok) {}];
                    success(user);
                    
                     [MTTNotification postNotification:DDNotificationUserLoginSuccess userInfo:nil object:user];
                    
                } failure:^(NSError *object) {
                    
                    DDLog(@"login#登录验证失败");
                    failure(object.domain);
                }];
                
            } failure:^{
                 DDLog(@"连接消息服务器失败");
                  failure(@"连接消息服务器失败");
            }];
        }
    } failure:^(NSString *error) {
        
        
        //无网络时也要加载数据
        [self loadLocalData:password nameStr:name success:^(id boj) {
            
        }];
        failure(@"连接消息服务器失败");
    }];
}

-(void)loadLocalData:(NSString*)password nameStr:(NSString*)name success:(void(^)(id))Success
{
    NSDictionary * dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"serveDic"];
    _priorIP = [dictionary objectForKey:@"priorIP"];
    _port    =  [[dictionary objectForKey:@"port"] integerValue];
    [MTTUtil setMsfsUrl:[dictionary objectForKey:@"msfsPrior"]];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autologin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _lastLoginPassword=password;
    _lastLoginUserName=name;
    DDClientState* clientState = [DDClientState shareInstance];
    clientState.userState=DDUserOffLine;
    _relogining=NO;
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[[DDUserModule shareInstance] getAllMaintanceUser] enumerateObjectsUsingBlock:^(MTTUserEntity *obj, NSUInteger idx, BOOL *stop) {
                    [[SpellLibrary instance] addSpellForObject:obj];
                    [[SpellLibrary instance] addDeparmentSpellForObject:obj];
                }];
                NSArray *array =  [[DDGroupModule instance] getAllGroups];
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [[SpellLibrary instance] addSpellForObject:obj];
                }];
            });
        }
    }];
    
    Success(@"1");
}
- (void)reloginSuccess:(void(^)())success failure:(void(^)(NSString* error))failure
{
    DDLog(@"relogin fun");
    if ([DDClientState shareInstance].userState == DDUserOffLine && _lastLoginPassword && _lastLoginUserName) {
        [self loginWithUsername:_lastLoginUserName password:_lastLoginPassword success:^(MTTUserEntity *user) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloginSuccess" object:nil];
            success(YES);
        } failure:^(NSString *error) {
            failure(@"重新登陆失败");
        }];
    }
}
- (void)offlineCompletion:(void(^)())completion
{
    completion();
}
/**
 *  登录成功后获取所有用户
 *
 *  @param completion 异步执行的block
 */
- (void)p_loadAllUsersCompletion:(void(^)())completion
{
    __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    __block NSInteger version = [[defaults objectForKey:@"alllastupdatetime"] integerValue];
    [[MTTDatabaseUtil instance] getAllUsers:^(NSArray *contacts, NSError *error) {
        if ([contacts count] !=0) {
            [contacts enumerateObjectsUsingBlock:^(MTTUserEntity *obj, NSUInteger idx, BOOL *stop) {               [[DDUserModule shareInstance] addMaintanceUser:obj];
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
    //重新获取好友信息2
    DDAllUserAPI* api = [[DDAllUserAPI alloc] init];
    [api requestWithObject:@[@(0)] Completion:^(id response, NSError *error) {
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"personalInfoChanged" object:nil];
                    });
                  
                }];
            });
        }
    }];
    //获取群组信息
    DDFixedGroupAPI *getFixgroup = [DDFixedGroupAPI new];
    [getFixgroup requestWithObject:nil Completion:^(NSArray *response, NSError *error) {
        [response enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
            NSString *groupID = [MTTUtil changeOriginalToLocalID:(UInt32)[obj[@"groupid"] integerValue] SessionType:SessionTypeSessionTypeGroup];
            NSInteger version = [obj[@"version"] integerValue];
            MTTGroupEntity *group = [[DDGroupModule instance] getGroupByGId:groupID];
            if (group) {
                //版本改变时需要重新获取数据
                if (group.objectVersion != version) {
                    _isGroupChnage = YES;
                    [self getGroupInfo:groupID];
                }
            }else{
                [[DDGroupModule instance] getGroupInfogroupID:groupID completion:^(MTTGroupEntity *group) {
                    [[DDGroupModule instance] addGroup:group];
                }];
            }
        }];
        //有群租信息改变时需要刷新数据
        _isGroupChnage?[[NSNotificationCenter defaultCenter] postNotificationName:@"groupHaseChanged" object:nil]:0;
    }];
}
-(void)getGroupInfo:(NSString*)groupId
{
    GetGroupInfoAPI* request = [[GetGroupInfoAPI alloc] init];
    [request requestWithObject:@[@([MTTUtil changeIDToOriginal:groupId]),@(0)] Completion:^(id response, NSError *error) {
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
                   MTTSessionEntity * session = [[SessionModule instance] getSessionById:groupId];
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
@end
