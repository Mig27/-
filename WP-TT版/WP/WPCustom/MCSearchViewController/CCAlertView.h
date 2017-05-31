//
//  CCAlertView.h
//  YipaiShop
//
//  Created by chenchao on 15/12/21.
//  Copyright © 2015年 Yipai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ClickAction)();

@interface CCAlertView : NSObject

@property (nonatomic,copy) NSString *title;   // 标题
@property (nonatomic,copy) NSString *message; // 提示信息


//---------------构造器方法--------------------
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

//---------------实例化方法------------------------
-(void)setTitle:(NSString *)title message:(NSString *)message;


//===============添加按钮以及相应的点击事件===================
-(void)addBtnTitle:(NSString *)title action:(ClickAction)action;

//===============显示提示框===================
-(void)showAlertWithSender:(UIViewController *)sender;




NS_ASSUME_NONNULL_END

@end
