//
//  SPButton1.h
//  WP
//
//  Created by CBCCBC on 15/10/27.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPButton.h"

//typedef NS_ENUM(NSInteger, SPButtonContentAlignment) {
//    SPButtonContentAlignmentRight,
//    SPButtonContentAlignmentLeft,
//    SPButtonContentAlignmentCenter,
//};

/**
 *  图片与文字间隔为6，默认居中
 */
@interface SPButton1 : UIButton

/**
 *  创建图片和文字显示的Button
 *
 *  @param frame     Button的Frame
 *  @param title     显示文字
 *  @param imageName 图片名称
 *  @param target    代理对象
 *  @param action    实现方法
 *
 *  @return UIButton
 */

@property (strong, nonatomic) UILabel *contentLabel;
@property (assign, nonatomic) SPButtonContentAlignment contentAlignment;
@property (nonatomic, strong) UIImageView *mageView;
-(id)initWithFrame:(CGRect)frame title:(NSString *)title ImageName:(NSString *)imageName Target:(id)target Action:(SEL)action;

- (void)setContentLabelSize:(NSString *)title font:(CGFloat)font;

- (void)setContentLabelTitle:(NSString *)title font:(CGFloat)font;
-(void)titleColor:(UIColor*)color;
-(void)setContentLabelTextColor:(UIColor*)color;
@end
