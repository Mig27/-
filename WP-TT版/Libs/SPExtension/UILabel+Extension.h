//
//  UILabel+Extension.h
//  ShopStore
//
//  Created by Spyer on 15/7/21.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

/**创建指定宽度，宽度随字符串长度改变的Label*/
+(UILabel *)creatUILabelWithOrignalX:(CGFloat)orignalX OrignalY:(CGFloat)orignalY Height:(CGFloat)height Text:(NSString *)text TextColor:(UIColor *)textColor Font:(UIFont *)font;

/**创建制定宽度,高度随字符串长度改变的Label*/
+(UILabel *)creatUILabelWithOrignalY:(CGFloat)orignalY Width:(CGFloat)width Text:(NSString *)text TextColor:(UIColor *)textColor Font:(UIFont *)font;

/**创建指定frame居中对齐的Label*/
+(UILabel *)creatUILabelWithFrame:(CGRect)frame Text:(NSString *)text TextColor:(UIColor *)textColor Font:(CGFloat)font;
+(UILabel *)creatUILabelWithX:(CGFloat)orignalX WithOrignalY:(CGFloat)orignalY Width:(CGFloat)width Text:(NSString *)text TextColor:(UIColor *)textColor Font:(UIFont *)font;
@end
