//
//  WPScrollView.m
//  WP
//
//  Created by CBCCBC on 16/4/7.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPScrollView.h"

@implementation WPScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.delaysContentTouches = NO;
    }
    return self;
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ([view isKindOfClass:[UIButton class]])
    {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
