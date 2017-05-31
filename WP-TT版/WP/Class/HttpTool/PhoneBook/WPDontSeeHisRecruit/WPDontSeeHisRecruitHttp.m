//
//  WPDontSeeHisRecruitHttp.m
//  WP
//
//  Created by Kokia on 16/5/10.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPDontSeeHisRecruitHttp.h"

@implementation WPDontSeeHisRecruitHttp

+ (void)WPDontSeeHisRecruitHttpWithParam:(WPDontSeeHisRecruitParam *)param success:(void (^)(WPDontSeeHisRecruitResult *result))success failure:(void (^)(NSError *error))failure{

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
    if (param.friend_id) {
        parame[@"friend_id"]= param.friend_id;
    }
    if (param.type) {
        parame[@"type"]= param.type;
    }
    if (param.username) {
        parame[@"username"]= param.username;
    }
    if (param.password) {
        parame[@"password"]= param.password;
    }
    
    [mgr POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WPDontSeeHisRecruitResult *result = [WPDontSeeHisRecruitResult mj_objectWithKeyValues:responseObject];
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
