//
//  SPAlert.h
//  WP
//
//  Created by CBCCBC on 15/11/27.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AlertcancelAction)();
typedef void (^AlertDefaultAction)();

@interface SPAlert : NSObject

/**
 *  快速创建提示Alert
 *
 *  @param controller 显示的controller
 */
+(void)quickNotice:(UIViewController *)controller;

/**
 *  两个按钮的Alert
 *
 *  @param title         alert标题
 *  @param message       alert内容
 *  @param controller    alert要显示在的控制器
 *  @param cancelTitle   取消按钮文字
 *  @param cancelAction  取消按钮事件
 *  @param defaultTitle  默认按钮文字
 *  @param defaultAction 默认按钮事件
 */
+ (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message superController:(UIViewController *)controller cancelButtonTitle:(NSString *)cancelTitle cancelAction:(AlertcancelAction)cancelAction defaultButtonTitle:(NSString *)defaultTitle defaultAction:(AlertDefaultAction)defaultAction;

/**
 *  一个按钮的Alert
 *
 *  @param title        alert标题
 *  @param message      alert内容
 *  @param controller   alert要显示在的控制器
 *  @param cancelAction 取消按钮文字
 *  @param cancelTitle  取消按钮事件
 */
+ (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message superController:(UIViewController *)controller cancelButtonTitle:(NSString *)cancelTitle cancelAction:(AlertcancelAction)cancelAction;



@end
