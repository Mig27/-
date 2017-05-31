//
//  WPGetContactListWithCategoryIDHttp.m
//  WP
//
//  Created by Kokia on 16/5/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGetContactListWithCategoryIDHttp.h"
#import "MTTDatabaseUtil.h"
@implementation WPGetContactListWithCategoryIDHttp

+ (void)WPGetContactListWithCategoryIDHttpWithParam:(WPGetContactListWithCategoryIDParam *)param success:(void (^)(WPGetContactListWithCategoryIDResult *result))success failure:(void (^)(NSError *error))failure{

    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Friend.ashx"];
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
    if (param.typeid) {
        parame[@"typeid"]= param.typeid;
    }
    
    [mgr POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        WPGetContactListWithCategoryIDResult *result = [WPGetContactListWithCategoryIDResult mj_objectWithKeyValues:responseObject];
        if (success && responseObject) {
            success(result);
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray * list = dic[@"list"];
            if (list.count) {
                [[MTTDatabaseUtil instance] deleteFriendsCategoryDetail:param.typeid];
                [[MTTDatabaseUtil instance] upDataFriendsCategoryDetail:list];
            }
            else
            {
                [[MTTDatabaseUtil instance] getFriendsCategoryDetail:param.typeid success:^(NSArray *array) {
                    if (array.count) {
                        NSDictionary * dic = @{@"list":array,@"status":@"1"};
                        WPGetContactListWithCategoryIDResult *result = [WPGetContactListWithCategoryIDResult mj_objectWithKeyValues:dic];
                        success(result);
                    }
                }];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            failure(error);
        }
        [[MTTDatabaseUtil instance] getFriendsCategoryDetail:param.typeid success:^(NSArray *array) {
            if (array.count) {
                NSDictionary * dic = @{@"list":array,@"status":@"1"};
                WPGetContactListWithCategoryIDResult *result = [WPGetContactListWithCategoryIDResult mj_objectWithKeyValues:dic];
                success(result);
            }
        }];
    }];


}

@end
