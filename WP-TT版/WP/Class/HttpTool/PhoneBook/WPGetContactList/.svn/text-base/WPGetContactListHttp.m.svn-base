//
//  WPGetContactListHttp.m
//  WP
//
//  Created by Kokia on 16/5/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGetContactListHttp.h"

@implementation WPGetContactListHttp

+ (void)WPGetContactListHttpWithParam:(WPGetContactListParam *)param success:(void (^)(WPGetContactListResult *result))success failure:(void (^)(NSError *error))failure{

    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
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
        WPGetContactListResult *result = [WPGetContactListResult mj_objectWithKeyValues:responseObject];
        DebugLog(@"%@",result);
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
