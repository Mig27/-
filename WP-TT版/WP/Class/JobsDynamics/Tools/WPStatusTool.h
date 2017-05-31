//
//  WPStatusTool.h
//  WP
//
//  Created by 沈亮亮 on 15/6/9.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPStatusParam.h"
#import "WPStatusResult.h"

@interface WPStatusTool : NSObject
//发送职场动态请求，获得数据
+ (void)jobsStatusesWithParam:(WPStatusParam *)param success:(void (^)(WPStatusResult *result))success failure:(void (^)(NSError *error))failure;
@end
