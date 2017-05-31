//
//  WPSetRefreshModel.m
//  WP
//
//  Created by CBCCBC on 16/4/1.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPSetRefreshModel.h"

@implementation WPSetRefreshListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [WPSetRefreshModel class]};
}

@end

@implementation WPSetRefreshModel


+ (NSDictionary *)objectClassInArray{
    return @{@"id" : @"sid"};
}

@end
