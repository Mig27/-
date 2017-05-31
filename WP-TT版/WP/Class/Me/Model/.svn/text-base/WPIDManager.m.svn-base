//
//  WPIDManager.m
//  WP
//
//  Created by CBCCBC on 16/3/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPIDManager.h"

#define kPersonal_info @"/ios/personal_info.ashx"


@implementation WPIDManager

singleton_implementation(WPIDManager)

- (void)requestWPIDWithWp_id:(NSString *)wp_id return:(void (^)(id))returnVlaue
{
    NSString *url = [IPADDRESS stringByAppendingString:kPersonal_info];
    NSDictionary *params = @{@"action":@"SetWPID",
                             @"user_id":kShareModel.userId,
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"wp_id":wp_id};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        returnVlaue(json);
    } failure:^(NSError *error) {
        
    }];
    
}


@end
