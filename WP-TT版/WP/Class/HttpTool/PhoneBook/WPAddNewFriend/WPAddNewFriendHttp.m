//
//  WPAddNewFriendHttp.m
//  WP
//
//  Created by Kokia on 16/5/16.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPAddNewFriendHttp.h"

@implementation WPAddNewFriendHttp

+ (void)WPAddNewFriendHttpWithParam:(WPAddNewFriendParam *)param success:(void (^)(WPAddNewFriendResult *result))success failure:(void (^)(NSError *error))failure{
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/friend.ashx"];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    
    if (param.action) {
        parame[@"action"]= param.action;
    }
    if (param.user_id) {
        parame[@"user_id"]= param.user_id;
    }
    if (param.username) {
        parame[@"username"]= param.username;
    }
    if (param.password) {
        parame[@"password"]= param.password;
    }
    if (param.fuser_id) {
        parame[@"fuser_id"]= param.fuser_id;
    }
    if (param.is_fcircle) {
        parame[@"is_fcircle"]= param.is_fcircle;
    }
    if (param.is_fjob) {
        parame[@"is_fjob"]= param.is_fjob;
    }
    if (param.is_fresume) {
        parame[@"is_fresume"]= param.is_fresume;
    }
    if (param.belongGroup) {
        parame[@"belongGroup"]= param.belongGroup;
    }
    if (param.is_show) {
        parame[@"is_show"]= param.is_show;
    }
    if (param.AddFriend) {
        parame[@"AddFriend"]= param.AddFriend;
    }
    if (param.friend_mobile) {
        parame[@"friend_mobile"]= param.friend_mobile;
    }
    if (param.exec) {
        parame[@"exec"] = param.exec;
    }
    
    
    [mgr POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WPAddNewFriendResult *result = [WPAddNewFriendResult mj_objectWithKeyValues:responseObject];
        if (success && responseObject) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            failure(error);
        }
    }];
    
    
}

@end
