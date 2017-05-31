//
//  WPAddMobileFriendHttp.m
//  WP
//
//  Created by Kokia on 16/5/11.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPAddMobileFriendHttp.h"

@implementation WPAddMobileFriendHttp

+ (void)WPAddMobileFriendHttpWithParam:(WPAddMobileFriendParam *)param success:(void (^)(WPAddMobileFriendResult *result))success failure:(void (^)(NSError *error))failure{
    
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
    if (param.mobileJson) {
        parame[@"mobileJson"]= param.mobileJson;
    }
    
    [mgr POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WPAddMobileFriendResult *result = [WPAddMobileFriendResult mj_objectWithKeyValues:responseObject];
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
