//
//  WPGetFriendInfoHttp.m
//  WP
//
//  Created by Kokia on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGetFriendInfoHttp.h"
#import "MTTDatabaseUtil.h"
@implementation WPGetFriendInfoHttp

+ (void)WPGetFriendInfoHttpWithParam:(WPGetFriendInfoParam *)param success:(void (^)(WPGetFriendInfoResult *result))success failure:(void (^)(NSError *error))failure{

    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info_new.ashx"];
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
    if (param.indexPage) {
        parame[@"indexPage"]= param.indexPage;
    }

    [mgr POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WPGetFriendInfoResult *result = [WPGetFriendInfoResult mj_objectWithKeyValues:responseObject];
        if (success && responseObject) {
            success(result);
            [[MTTDatabaseUtil instance] deletePersonalInfo:result.uid];
            [[MTTDatabaseUtil instance] upDatePersonalInfo:@[result]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            failure(error);
        }
        [[MTTDatabaseUtil instance] getPersonalInfo:param.friend_id success:^(NSArray *array) {
            if (array.count) {
              success(array[0]);   
            }
           
        }];
        
        
    }];
}

@end
