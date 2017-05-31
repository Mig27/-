//
//  UILabel+Extension.m
//  ShopStore
//
//  Created by Spyer on 15/7/21.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "UILabel+Extension.h"
#import "NSString+StringType.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "MacroDefinition.h"

@implementation UILabel (Extension)
+(UILabel *)creatUILabelWithOrignalX:(CGFloat)orignalX OrignalY:(CGFloat)orignalY Height:(CGFloat)height Text:(NSString *)text TextColor:(UIColor *)textColor Font:(UIFont *)font
{
    CGSize size;
    
    size = [text sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(orignalX, orignalY, size.width, height)];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+(UILabel *)creatUILabelWithOrignalY:(CGFloat)orignalY Width:(CGFloat)width Text:(NSString *)text TextColor:(UIColor *)textColor Font:(UIFont *)font
{
    CGSize size = [text getSizeWithFont:font Width:width];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-size.width)/2, orignalY, size.width, size.height)];
    label.textColor = textColor;
    label.text = text;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

+(UILabel *)creatUILabelWithFrame:(CGRect)frame Text:(NSString *)text TextColor:(UIColor *)textColor Font:(CGFloat)font
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = textColor;
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+(UILabel *)creatUILabelWithX:(CGFloat)orignalX WithOrignalY:(CGFloat)orignalY Width:(CGFloat)width Text:(NSString *)text TextColor:(UIColor *)textColor Font:(UIFont *)font
{
    CGSize size = [text getSizeWithFont:font Width:width];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(orignalX, orignalY, width, size.height)];
    label.textColor = textColor;
    label.text = text;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    return label;
}
@end
