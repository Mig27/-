//
//  WPDragIntoBlackListHttp.m
//  WP
//
//  Created by Kokia on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPDragIntoBlackListHttp.h"

@implementation WPDragIntoBlackListHttp

+ (void)WPDragIntoBlackListHttpWithParam:(WPDragIntoBlackListParam *)param success:(void (^)(WPDragIntoBlackListResult *result))success failure:(void (^)(NSError *error))failure{

    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Friend.ashx"];
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
        WPDragIntoBlackListResult *result = [WPDragIntoBlackListResult mj_objectWithKeyValues:responseObject];
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
