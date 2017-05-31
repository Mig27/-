//
//  UIImage+autoGenerate.m
//  WP
//
//  Created by CBCCBC on 16/3/8.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "UIImage+autoGenerate.h"

@implementation UIImage (autoGenerate)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
