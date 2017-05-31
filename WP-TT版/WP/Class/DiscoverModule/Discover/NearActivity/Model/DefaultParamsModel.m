//
//  DefaultParamsModel.m
//  WP
//
//  Created by 沈亮亮 on 15/10/27.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "DefaultParamsModel.h"

@implementation DefaultParamsModel

+ (NSDictionary *)objectClassInArray{
    return @{ @"Photo" : [PhotoList class]};
}

@end

@implementation PhotoList

@end
