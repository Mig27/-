//
//  CCCustomButton.m
//  WP
//
//  Created by CC on 16/6/16.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "CCCustomButton.h"

@implementation CCCustomButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.centerX = self.imageView.centerX;
        [self setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];//100
        [self setBackgroundImage:[UIImage imageWithColor:RGB(210, 210, 210)] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:FUCKFONT(10)];//12
        
//        self.titleEdgeInsets = UIEdgeInsetsMake(6, 0, 0, 0);
//        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 6, 0);
        
        
    }
    return self;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    CGFloat imageH = self.height*0.8;
    CGFloat imageW = self.width;
    CGFloat imageY = 0;
    CGFloat imageX = 0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleH = self.height * 0.2;
    CGFloat titleW = self.width;
    CGFloat titleY = self.height*0.7;
    CGFloat titleX = 0;
    return CGRectMake(titleX, titleY, titleW, titleH);
    
}

@end
