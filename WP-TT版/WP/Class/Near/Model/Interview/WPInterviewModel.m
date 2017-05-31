//
//  WPInterviewModel.m
//  WP
//
//  Created by CBCCBC on 15/9/18.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPInterviewModel.h"


@implementation WPInterviewListModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"HopePosition":@"Hope_Position",
             @"jobId":@"id",
             @"updateTime":@"update_Time",
             @"userId":@"user_id"
             };
}

@end

@implementation WPInterviewModel

+(NSDictionary *)objectClassInArray
{
    return @{
             @"list":@"WPInterviewListModel"
             };
}

@end
