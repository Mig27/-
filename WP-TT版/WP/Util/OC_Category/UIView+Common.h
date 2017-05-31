//
//  UIView+Common.h
//  WPkeyboard
//
//  Created by Kokia on 16/3/8.
//  Copyright © 2016年 Kokia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Common)


- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color;

- (void)setY:(CGFloat)y;
- (void)setX:(CGFloat)x;
- (void)setOrigin:(CGPoint)origin;
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;
- (void)setSize:(CGSize)size;

@end
