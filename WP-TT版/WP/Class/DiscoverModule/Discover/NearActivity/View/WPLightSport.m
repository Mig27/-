//
//  WPLightSport.m
//  WP
//
//  Created by CC on 17/1/9.
//  Copyright © 2017年 WP. All rights reserved.
//

#import "WPLightSport.h"

@implementation WPLightSport

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGRect)borderRectForBounds:(CGRect)bounds
{
    bounds.size.height = kHEIGHT(43);
    return bounds;
}
@end
