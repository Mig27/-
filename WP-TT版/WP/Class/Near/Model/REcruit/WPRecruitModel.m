//
//  WPRecruiListModel.m
//  WP
//
//  Created by CBCCBC on 15/9/18.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPRecruitModel.h"

@implementation WPRecruitListModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"enterpriseName":@"enterprise_name",
             @"epId":@"ep_id",
             @"updateTime":@"update_Time",
             @"userId":@"user_id",
             @"sid":@"id"
             };
}

@end

@implementation WPRecruitModel

+(NSDictionary *)objectClassInArray
{
    return @{
             @"list":@"WPRecruitListModel"
             };
}

@end
