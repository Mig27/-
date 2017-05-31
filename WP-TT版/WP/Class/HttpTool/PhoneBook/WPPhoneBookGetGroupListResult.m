//
//  WPPhoneBookGetGroupListResult.m
//  WP
//
//  Created by Kokia on 16/5/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPhoneBookGetGroupListResult.h"

@implementation WPPhoneBookGetGroupListResult

+(NSDictionary *)objectClassInArray
{
    return @{
             @"mycreated":@"WPPhoneBookGroupModel",
             @"myjoin":@"WPPhoneBookGroupModel"
             };
}

@end
