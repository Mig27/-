//
//  groupNotificationModel.h
//  WP
//
//  Created by CC on 16/9/24.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface groupNotificationModel : NSObject
@property (nonatomic, copy)NSString *add_time;
@property (nonatomic, copy)NSString *add_time_diff;
@property (nonatomic, copy)NSString *count;
@property (nonatomic, copy)NSString *info;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *sys_add_time;
@property (nonatomic, copy)NSString *sys_add_time_diff;
@property (nonatomic, copy)NSString *sys_count;
@property (nonatomic, copy)NSString *sys_remark;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)NSDictionary * modelDic;
@property (nonatomic, assign)NSUInteger timeInterval;

@property (nonatomic,assign) BOOL isFixedTop;
@end
