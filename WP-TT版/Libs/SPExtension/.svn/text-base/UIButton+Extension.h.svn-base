//
//  UIButton+Extension.h
//  ShopStore
//
//  Created by Spyer on 15/7/21.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,UIButtonFontType){
    UIButtonFontTypeDefault = 17,
    UIButtonFontTypeSmall = 15,
    UIButtonFontTypeLarge = 20,
};

@interface UIButton (Extension)

/**创建文字显示的UIbutton*/
+(UIButton *)creatUIButtonWithFrame:(CGRect)frame BackgroundColor:(UIColor *)backgroundColor Title:(NSString *)title TitleColor:(UIColor *)titleColor Font:(CGFloat)font Target:(id)target Action:(SEL)action;

/**创建图片显示的UIbutton*/
+(UIButton *)creatUIButtonWithFrame:(CGRect)frame ImageName:(NSString *)imageName Target:(id)target Action:(SEL)action;

/**
 *  创建静态图片显示的效果的Button
 */

+(UIButton *)creatImageButtonWithFrame:(CGRect)frame superView:(UIView *)view ImageName:(NSString *)imageName defaultImageName:(NSString *)defaultName Target:(id)target Action:(SEL)action;
/**
 *  设置Button的Normal状态下的内容和颜色、字号(可为空)
 *
 *  @param title button标题
 *  @param color button颜色
 *  @param font  button字号
 */
-(void)normalTitle:(NSString *)title Color:(UIColor *)color Font:(UIFont *)font;
/**
 *  设置Button的Selected状态下的内容和颜色(可为空)
 *
 *  @param title button标题
 *  @param color button颜色
 */
-(void)selectedTitle:(NSString *)title Color:(UIColor *)color;

@end
