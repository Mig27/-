//
//  SPTextView.h
//  WP
//
//  Created by CBCCBC on 15/9/22.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface SPTextView : UIView

@property (copy, nonatomic) NSString *title;/**< 获取textview的text */
@property (strong, nonatomic) UIPlaceHolderTextView *text;/**< textview */
@property (copy, nonatomic) void (^showToFont)();/**< 变成第一响应者 */
@property (copy, nonatomic) void (^hideFromFont)(NSString *title);/**< 释放第一响应者 */
/**
 *  重置textview的内容
 *
 *  @param title 重置的内容
 */
-(void)resetTitle:(NSString *)title;
/**
 *  设置textview的title和placeholder
 *
 *  @param title       title
 *  @param placeholder placeholder
 */
-(void)setWithTitle:(NSString *)title  placeholder:(NSString *)placeholder;

@end
