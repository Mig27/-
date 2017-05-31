//
//  DDUserModule.h
//  IOSDuoduo
//
//  Created by 独嘉 on 14-5-26.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTTUserEntity.h"

typedef void(^DDLoadRecentUsersCompletion)();


@interface DDUserModule : NSObject

@property (nonatomic,strong)NSString* currentUserID;
@property (nonatomic,strong)NSMutableDictionary* recentUsers;
+ (instancetype)shareInstance;
-(MTTUserEntity*)offLineUser:(NSString*)userID;
-(void)addOffLineMa:(MTTUserEntity*)user;
-(void)reMoveOffline:(NSString*)userID;
-(void)getOffLine:(NSString*)userid Block:(void(^)(MTTUserEntity *user))block;
-(void)upDateUser:(MTTUserEntity*)user;
- (void)addMaintanceUser:(MTTUserEntity*)user;
- (void )getUserForUserID:(NSString*)userID Block:(void(^)(MTTUserEntity *user))block;
- (void)addRecentUser:(MTTUserEntity*)user;
- (void)loadAllRecentUsers:(DDLoadRecentUsersCompletion)completion;
-(void)clearRecentUser;
-(NSArray *)getAllMaintanceUser;
-(NSArray *)getAllUsersNick;
-(MTTUserEntity *)getUserByNick:(NSString*)nickName;
-(void)addNewFriend:(NSString*)mobile;
-(void)getUserFromUserID:(NSString*)userID Block:(void(^)(MTTUserEntity *user))block;
@end
