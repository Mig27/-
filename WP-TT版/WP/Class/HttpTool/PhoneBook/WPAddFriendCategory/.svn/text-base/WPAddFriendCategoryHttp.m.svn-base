//
//  WPAddFriendCategoryHttp.m
//  WP
//
//  Created by Kokia on 16/5/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPAddFriendCategoryHttp.h"

@implementation WPAddFriendCategoryHttp

+ (void)wPAddFriendCategoryHttpWithParam:(WPAddFriendCategoryParam *)param success:(void (^)(WPAddFriendCategoryResult *result))success failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/friend_type.ashx"];
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
    if (param.typename) {
        parame[@"typename"]= param.typename;
    }
    
    [mgr POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WPAddFriendCategoryResult *result = [WPAddFriendCategoryResult mj_objectWithKeyValues:responseObject];
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
