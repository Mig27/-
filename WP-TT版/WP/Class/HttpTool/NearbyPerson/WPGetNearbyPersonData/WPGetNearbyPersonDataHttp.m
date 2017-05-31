//
//  WPGetNearbyPersonDataHttp.m
//  WP
//
//  Created by Kokia on 16/5/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGetNearbyPersonDataHttp.h"

@implementation WPGetNearbyPersonDataHttp

+ (void)WPGetNearbyPersonDataHttpWithParam:(WPGetNearbyPersonDataParam *)param success:(void (^)(WPGetNearbyPersonDataResult *result))success failure:(void (^)(NSError *error))failure{

    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/resume.ashx"];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    
    if (param.action) {
        parame[@"action"]= param.action;
    }
    if (param.userId) {
        parame[@"userId"]= param.userId;
    }
    if (param.latitude) {
        parame[@"latitude"]= param.latitude;
    }
    if (param.longitude) {
        parame[@"longitude"]= param.longitude;
    }
    if (param.page) {
        parame[@"page"]= param.page;
    }
    if (param.position) {
        parame[@"position"]= param.position;
    }
    if (param.sex) {
        parame[@"sex"]= param.sex;
    }
    
    
    
    [mgr POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        WPGetNearbyPersonDataResult *result = [WPGetNearbyPersonDataResult mj_objectWithKeyValues:dic];
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
