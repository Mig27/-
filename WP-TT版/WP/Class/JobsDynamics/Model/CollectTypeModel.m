//
//  CollectTypeModel.m
//  WP
//
//  Created by 沈亮亮 on 16/3/28.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "CollectTypeModel.h"

@implementation CollectTypeModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"type_name":@"typename",
             @"type_id" : @"id"
             };
}

@end

@implementation CollectTypeListModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"list":@"CollectTypeModel"};
}

@end