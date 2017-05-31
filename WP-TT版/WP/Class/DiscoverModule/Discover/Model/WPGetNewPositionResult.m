//
//  WPGetNewPositionResult.m
//  WP
//
//  Created by Kokia on 16/5/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGetNewPositionResult.h"
#import "WPNewPositionModel.h"

@implementation WPGetNewPositionResult

+(NSDictionary *)objectClassInArray
{
    return @{
             @"list":@"WPNewPositionModel"
             };
}

@end
