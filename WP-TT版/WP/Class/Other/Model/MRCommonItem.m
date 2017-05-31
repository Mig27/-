//
//  MRCommonItem.m
//  闵瑞微博
//
//  Created by Asuna on 15/4/21.
//  Copyright (c) 2015年 Asuna. All rights reserved.
//

#import "MRCommonItem.h"

@implementation MRCommonItem
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon
{
    MRCommonItem *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithTitle:title icon:nil];
}
@end
