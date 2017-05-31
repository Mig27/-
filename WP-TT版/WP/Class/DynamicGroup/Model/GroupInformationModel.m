
//
//  GroupInformationModel.m
//  WP
//
//  Created by 沈亮亮 on 16/4/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GroupInformationModel.h"

@implementation GroupInformationModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"json":@"GroupInformationListModel"};
}

@end

@implementation GroupInformationListModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"iconList":@"iconListModel",
             @"PhotoList" : @"PhotoListModel",
             @"NoticeList" : @"NoticeListModel",
             @"MenberList" : @"MenberListModel"};
}

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"group_id" : @"id"
             };
}

@end

@implementation iconListModel


@end

@implementation PhotoListModel


@end

@implementation NoticeListModel


@end

@implementation MenberListModel


@end