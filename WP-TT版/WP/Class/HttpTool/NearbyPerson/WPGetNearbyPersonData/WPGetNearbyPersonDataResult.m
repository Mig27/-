//
//  WPGetNearbyPersonDataResult.m
//  WP
//
//  Created by Kokia on 16/5/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGetNearbyPersonDataResult.h"
#import "WPNearbyPersonModel.h"

@implementation WPGetNearbyPersonDataResult


+(NSDictionary *)objectClassInArray
{
    return @{
             @"list":@"WPNearbyPersonModel"
             };
}


@end
