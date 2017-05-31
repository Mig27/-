//
//  WPIsFriendJusticeHttp.m
//  WP
//
//  Created by CC on 16/6/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPIsFriendJusticeHttp.h"

@implementation WPIsFriendJusticeHttp

+ (void)WPIsFriendJusticeHttpWithParam:(WPIsFriendJusticeParam *)param success:(void (^)(WPIsFriendJusticeResult *result))success failure:(void (^)(NSError *error))failure{
    
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
    if (param.friend_id) {
        parame[@"friend_id"]= param.friend_id;
    }
    [mgr POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WPIsFriendJusticeResult *result = [WPIsFriendJusticeResult mj_objectWithKeyValues:responseObject];
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
