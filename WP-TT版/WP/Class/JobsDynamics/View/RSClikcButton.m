//
//  RSClikcButton.m
//  WP
//
//  Created by RS on 16/7/16.
//  Copyright © 2016年 WP. All rights reserved.
//  扩大按钮的点击范围

#import "RSClikcButton.h"

@implementation RSClikcButton

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event

{
    
    CGRect bounds =self.bounds;
    
    CGFloat widthDelta =44.0- bounds.size.width;
    
    CGFloat heightDelta =44.0- bounds.size.height;
    
    /*  1.注意这里是负数，扩大了之前的bounds的范围
     
     *  2.通过第二个参数 dx和第三个参数 dy 重置第一个参数rect 作为结果返回。
     
     *  重置的方式为，首先将rect 的坐标（origin）按照（dx,dy) 进行平移，然后将rect的大小（size） 宽度缩小2倍的dx，高度缩小2倍的dy；
     
      *   所以我们这里设置的范围就是44.0 *44.0 如果想设置大点就把上面的宽高44.0  改一下
     
     */
    
    bounds =CGRectInset(bounds, -0.5* widthDelta, -0.5* heightDelta);
    
    //CGRectContainsPoint函数:判断给定的点是否被一个CGRect包含
    
    return CGRectContainsPoint(bounds, point);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
