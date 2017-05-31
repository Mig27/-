//
//  WPPersonSetDontSeeOrLetSeeHttp.m
//  WP
//
//  Created by CC on 16/6/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPersonSetDontSeeOrLetSeeHttp.h"

@implementation WPPersonSetDontSeeOrLetSeeHttp

+ (void)WPPersonSetDontSeeOrLetSeeHttpWithParam:(WPPersonSetDontSeeOrLetSeeParam *)param success:(void (^)(WPPersonSetDontSeeOrLetSeeResult *result))success failure:(void (^)(NSError *error))failure{
    
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
    if (param.state) {
        parame[@"state"]= param.state;
    }

    
    [mgr POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSJSONSerialization * json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        WPPersonSetDontSeeOrLetSeeResult *result = [WPPersonSetDontSeeOrLetSeeResult mj_objectWithKeyValues:json];
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
