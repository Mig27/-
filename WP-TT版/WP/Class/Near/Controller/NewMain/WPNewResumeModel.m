//
//  WPNewResumeModel.m
//  WP
//
//  Created by CBCCBC on 16/1/25.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPNewResumeModel.h"

@implementation WPNewResumeModel

+(NSDictionary *)objectClassInArray
{
    return @{
             @"list":@"WPNewResumeListModel"
             };
}

@end

@implementation WPNewResumeListModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"HopePosition":@"Hope_Position",
             @"resumeId":@"id",
             @"updateTime":@"update_Time",
             @"userId":@"user_id",
             @"enterpriseName":@"enterprise_name",
             @"epId":@"ep_id",
             @"enterprise_brief":@"txtcontent",
             };
}

@end