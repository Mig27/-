//
//  WPPhoneBookGetGroupListHttp.m
//  WP
//
//  Created by Kokia on 16/5/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPhoneBookGetGroupListHttp.h"
#import "MTTDatabaseUtil.h"
@implementation WPPhoneBookGetGroupListHttp

+ (void)wPPhoneBookGetGroupListHttpWithParam:(WPPhoneBookGetGroupListParam *)param success:(void (^)(WPPhoneBookGetGroupListResult *result))success failure:(void (^)(NSError *error))failure{
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

    [mgr POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSDictionary * diic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        WPPhoneBookGetGroupListResult *result = [WPPhoneBookGetGroupListResult mj_objectWithKeyValues:responseObject];
        if (success && responseObject) {
            success(result);
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray * mycreated = dic[@"mycreated"];
            NSArray * myjoin = dic[@"myjoin"];
            if (mycreated.count || myjoin.count) {
                [[MTTDatabaseUtil instance] deleteAllMyGroup];
                [[MTTDatabaseUtil instance] upDateMyGroup:myjoin];
                [[MTTDatabaseUtil instance] upDateMyGroup:mycreated];
            }
        }
        if (success && !responseObject) {
            [[self class] getMyGroup:^(WPPhoneBookGetGroupListResult *result) {
                success(result);
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            failure(error);
        }
        [[self class] getMyGroup:^(WPPhoneBookGetGroupListResult *result) {
            success(result);
        }];
    }];
}
+(void)getMyGroup:(void(^)(WPPhoneBookGetGroupListResult*))Success
{
    [[MTTDatabaseUtil instance] getMyGroup:^(NSArray *array) {
        NSMutableArray * myJoin = [NSMutableArray array];
        NSMutableArray * myCreat = [NSMutableArray array];
        for (NSDictionary * dic  in array) {
            NSString * create_user_id = dic[@"create_user_id"];
            if ([create_user_id isEqualToString:kShareModel.userId]) {
                [myCreat addObject:dic];
            }
            else
            {
                [myJoin addObject:dic];
            }
        }
        NSDictionary * dic = @{@"mycreated":myCreat,@"myjoin":myJoin};
        WPPhoneBookGetGroupListResult *result = [WPPhoneBookGetGroupListResult mj_objectWithKeyValues:dic];
        Success(result);
    }];
}
@end
