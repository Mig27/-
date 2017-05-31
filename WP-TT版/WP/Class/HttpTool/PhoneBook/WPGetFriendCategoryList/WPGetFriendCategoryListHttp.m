//
//  WPGetFriendCategoryListHttp.m
//  WP
//
//  Created by Kokia on 16/5/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGetFriendCategoryListHttp.h"
#import "MTTDatabaseUtil.h"
@implementation WPGetFriendCategoryListHttp

+ (void)wPGetFriendCategoryListHttpWithParam:(WPGetFriendCategoryListParam *)param success:(void (^)(WPGetFriendCategoryListResult *result))success failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/friend_type.ashx"];
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
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        WPGetFriendCategoryListResult *result = [WPGetFriendCategoryListResult mj_objectWithKeyValues:responseObject];
        if (success && responseObject) {
            success(result);
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray * list = dic[@"list"];
            if (list.count) {
                [[MTTDatabaseUtil instance] deleteAllFriendsCategory];
                [[MTTDatabaseUtil instance] upDateFriendsCategory:list];
            }
            else
            {
                [[MTTDatabaseUtil instance] getFriendsCategory:^(NSArray *array) {
                    if (array.count) {
                        NSDictionary * dic = @{@"list":array,@"status":@"1"};
                          WPGetFriendCategoryListResult *result = [WPGetFriendCategoryListResult mj_objectWithKeyValues:dic];
                        success(result);
                    }
                }];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            failure(error);
        }
        [[MTTDatabaseUtil instance] getFriendsCategory:^(NSArray *array) {
            if (array.count) {
                NSDictionary * dic = @{@"list":array,@"status":@"1"};
                WPGetFriendCategoryListResult *result = [WPGetFriendCategoryListResult mj_objectWithKeyValues:dic];
                success(result);
            }
        }];
        
    }];

}

@end
