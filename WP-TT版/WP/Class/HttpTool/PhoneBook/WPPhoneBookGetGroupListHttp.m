//
//  WPPhoneBookGetGroupListHttp.m
//  WP
//
//  Created by Kokia on 16/5/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPhoneBookGetGroupListHttp.h"

@implementation WPPhoneBookGetGroupListHttp

+ (void)wPPhoneBookGetGroupListHttpWithParam:(WPPhoneBookGetGroupListParam *)param success:(void (^)(WPPhoneBookGetGroupListResult *result))success failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *mgr = [CCUtil shareAFNMgrInstance];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    
    parame[@"terminalType"]= @"IOS";
    
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

    [mgr POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WPPhoneBookGetGroupListResult *result = [WPPhoneBookGetGroupListResult mj_objectWithKeyValues:responseObject];
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
