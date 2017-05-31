//
//  BYArrowInfo.m
//  WP
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "BYArrowInfo.h"

@implementation BYArrowInfo

+(instancetype)defaultInfo
{
    static BYArrowInfo *info = nil;
    @synchronized(self)
    {
        if(!info)
        {
            info = [[BYArrowInfo alloc] init];
            info.one = 1;

            
            
        }
    }
    return info;
}


@end
