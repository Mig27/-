//
//  WPTransferFriendToNewCateogryHttp.m
//  WP
//
//  Created by Kokia on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPTransferFriendToNewCateogryHttp.h"

@implementation WPTransferFriendToNewCateogryHttp

+ (void)WPTransferFriendToNewCateogryHttpWithParam:(WPTransferFriendToNewCateogryParam *)param success:(void (^)(WPTransferFriendToNewCateogryResult *result))success failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/friend_type.ashx"];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    
    if (param.action) {
        parame[@"action"]= param.action;
    }
    if (param.friend_id) {
        parame[@"friend_id"]= param.friend_id;
    }
    if (param.username) {
        parame[@"username"]= param.username;
    }
    if (param.password) {
        parame[@"password"]= param.password;
    }
    if (param.typeid) {
        parame[@"typeid"]= param.typeid;
    }
    if (param.user_id) {
        parame[@"user_id"]= param.user_id;
    }
    [mgr POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WPTransferFriendToNewCateogryResult *result = [WPTransferFriendToNewCateogryResult mj_objectWithKeyValues:responseObject];
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
