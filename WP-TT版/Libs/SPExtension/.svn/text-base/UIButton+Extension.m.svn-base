//
//  UIButton+Extension.m
//  ShopStore
//
//  Created by Spyer on 15/7/21.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "UIButton+Extension.h"
#import "NSString+StringType.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "MacroDefinition.h"


@implementation UIButton (Extension)

+(UIButton *)creatUIButtonWithFrame:(CGRect)frame BackgroundColor:(UIColor *)backgroundColor Title:(NSString *)title TitleColor:(UIColor *)titleColor Font:(CGFloat)font Target:(id)target Action:(SEL)action
{
    if (backgroundColor==nil)
    {
        backgroundColor = [UIColor clearColor];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundColor:backgroundColor];
    if (titleColor==nil)
    {
        titleColor = [UIColor whiteColor];
        
    }
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:titleColor forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(UIButton *)creatUIButtonWithFrame:(CGRect)frame ImageName:(NSString *)imageName Target:(id)target Action:(SEL)action
{
    UIButton *button  =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kHEIGHT(12))];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(UIButton *)creatImageButtonWithFrame:(CGRect)frame superView:(UIView *)view ImageName:(NSString *)imageName defaultImageName:(NSString *)defaultName Target:(id)target Action:(SEL)action
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    [view addSubview:imageView];
    if ([imageName hasPrefix:@"http"]) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:defaultName]];
    }else{
        [imageView setImage:[UIImage imageNamed:imageName]];
    }
    
    UIButton *button  =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return button;
}

-(void)normalTitle:(NSString *)title Color:(UIColor *)color Font:(UIFont *)font{
    if (title) {
        [self setTitle:title forState:UIControlStateNormal];
    }
    if (color) {
       [self setTitleColor:color forState:UIControlStateNormal];
    }
    if (font) {
       self.titleLabel.font = font;
    }
}

-(void)selectedTitle:(NSString *)title Color:(UIColor *)color{
    if (title) {
       [self setTitle:title forState:UIControlStateSelected];
    }
    if (color) {
        [self setTitleColor:color forState:UIControlStateSelected];
    }
}

@end
