//
//  WPStatus.m
//  WP
//
//  Created by Asuna on 15/6/4.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPStatus.h"
#import "WPPhoto.h"
#import "MJExtension.h"
@implementation WPStatus

- (NSDictionary *)objectClassInArray
{
    return @{@"original_photos" : [WPPhoto class]};
}




@end
