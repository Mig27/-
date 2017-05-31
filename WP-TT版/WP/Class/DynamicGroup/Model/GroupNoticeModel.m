//
//  GroupNoticeModel.m
//  WP
//
//  Created by 沈亮亮 on 16/5/10.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GroupNoticeModel.h"

@implementation GroupNoticeModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"list":@"GroupNoticeListModel"};
}

@end

@implementation GroupNoticeListModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"notice_id" : @"id"
             };
}

@end