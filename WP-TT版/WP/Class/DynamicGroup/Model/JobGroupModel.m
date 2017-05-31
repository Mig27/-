//
//  JobGroupModel.m
//  WP
//
//  Created by 沈亮亮 on 16/4/14.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "JobGroupModel.h"

@implementation JobGroupModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"list":@"JobGroupListModel"};
}

@end

@implementation JobGroupListModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"group_id" : @"id"
             };
}

@end