//
//  WPStatusTool.m
//  WP
//
//  Created by 沈亮亮 on 15/6/9.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPStatusTool.h"
#import "WPHttpTool.h"
#import "MJExtension.h"
@implementation WPStatusTool
+ (void)jobsStatusesWithParam:(WPStatusParam *)param success:(void (^)( WPStatusResult*))success failure:(void (^)(NSError *))failure
{
    [WPHttpTool postWithURL:[IPADDRESS stringByAppendingString:@"/tools/speak_manage.ashx"] params:param.mj_keyValues success:^(id json) {
       
        if (success) {
            WPStatusResult *result = [WPStatusResult mj_objectWithKeyValues:json];
            NSLog(@"%@",json);
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    }];
}
@end
