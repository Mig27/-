//
//  SPButton.h
//  WP
//
//  Created by CBCCBC on 15/9/17.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SPButtonContentAlignment) {
    SPButtonContentAlignmentRight,
    SPButtonContentAlignmentLeft,
    SPButtonContentAlignmentCenter,
};

/**
 *  图片与文字间隔为10，默认居中
 */
@interface SPButton : UIButton

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
@property (nonatomic, strong) UIImageView *subImageView;;

@property (assign, nonatomic) SPButtonContentAlignment contentAlignment;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title ImageName:(NSString *)imageName Target:(id)target Action:(SEL)action;

- (void)setContentLabelSize:(NSString *)title font:(CGFloat)font;
- (void)setSelectedTitle:(NSString *)title imageName:(NSString *)imageName;

@end
