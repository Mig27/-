//
//  WPGetContactListResult.m
//  WP
//
//  Created by Kokia on 16/5/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGetContactListResult.h"

@implementation WPGetContactListResult

+(NSDictionary *)objectClassInArray
{
    return @{
             @"list":@"WPPhoneBookContactModel"
             };
}

@end
