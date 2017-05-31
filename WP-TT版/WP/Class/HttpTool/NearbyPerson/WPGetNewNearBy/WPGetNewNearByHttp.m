//
//  WPGetNewNearByHttp.m
//  WP
//
//  Created by CC on 16/6/3.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGetNewNearByHttp.h"

@implementation WPGetNewNearByHttp

+ (void)WPGetNewNearByHttpWithParam:(WPGetNewNearByParam *)param success:(void (^)(WPGetNewNearByResult *result))success failure:(void (^)(NSError *error))failure{

    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/area.ashx"];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    
    if (param.action) {
        parame[@"action"]= param.action;
    }
    if (param.fatherid) {
        parame[@"fatherid"]= param.fatherid;
    }
 
    
    
    [mgr POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WPGetNewNearByResult *result = [WPGetNewNearByResult mj_objectWithKeyValues:responseObject];
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
