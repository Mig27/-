//
//  WPIVModel.m
//  WP
//
//  Created by CBCCBC on 16/4/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPIVModel.h"

@implementation WPIVModel
+ (NSDictionary *)objectClassInArray{
    return @{@"ImgPhoto" : [Pohotolist class],
             @"VideoPhoto":[Dvlist class]};
}

@end
