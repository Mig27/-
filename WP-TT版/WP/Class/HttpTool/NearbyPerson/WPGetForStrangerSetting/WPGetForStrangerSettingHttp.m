//
//  WPGetForStrangerSettingHttp.m
//  WP
//
//  Created by CC on 16/6/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGetForStrangerSettingHttp.h"

@implementation WPGetForStrangerSettingHttp

+ (void)WPGetForStrangerSettingHttpWithParam:(WPGetForStrangerSettingParam *)param success:(void (^)(WPGetForStrangerSettingResult *result))success failure:(void (^)(NSError *error))failure{

    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/userInfo.ashx"];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    
    if (param.action) {
        parame[@"action"]= param.action;
    }
    if (param.username) {
        parame[@"username"]= param.username;
    }
    if (param.password) {
        parame[@"password"]= param.password;
    }
    if (param.user_id) {
        parame[@"user_id"]= param.user_id;
    }
    
    [mgr POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WPGetForStrangerSettingResult *result = [WPGetForStrangerSettingResult mj_objectWithKeyValues:responseObject];
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
