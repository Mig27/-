//
//  SPItemView.h
//  WP
//
//  Created by CBCCBC on 15/9/22.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonTipView.h"
#import "WPtextFiled.h"
#define kCellTypeText @"kCellTypeText"
#define kCellTypeTextWithSwitch @"kCellTypeTextWithSwitch"
#define kCellTypeButton @"kCellTypeButton"

@protocol SPItemViewTelePhoneShowOrHiddenDelegate <NSObject>

@optional
- (void)SPItemViewTelePhoneShowOrHiddenDelegateWithShowed:(BOOL)showed;

@end

@interface SPItemView : UIView
//@property (nonatomic ,assign)BOOL hidden;
@property (nonatomic ,assign)CGFloat padding;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *industryId;

@property (copy, nonatomic) void (^SPItemBlock)(NSInteger tag);
@property (copy, nonatomic) void (^showToFont)();
@property (copy, nonatomic) void (^hideFromFont)(NSInteger tag,NSString *title);
@property (copy,nonatomic) void(^textChanged)(NSString*title);

@property (nonatomic, assign) BOOL isName;
@property (strong, nonatomic) WPtextFiled *textField;
@property (nonatomic, strong) UIButton *selectButton;   //右侧手机号码选择开关
@property (nonatomic,assign)BOOL openShowTelephone; //是否显示手机号
//@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIImageView *rightImageView;

@property (nonatomic, strong) CommonTipView *tipView;//textTipView
@property (nonatomic, strong) CommonTipView *textTipView;
@property (nonatomic, strong)  CommonTipView *telTipView; //手机号码格式

@property (nonatomic, assign) BOOL personalInfo;//个人资料中创建的
@property (nonatomic, weak) id<SPItemViewTelePhoneShowOrHiddenDelegate> delegate;

-(void)setTitle:(NSString *)title placeholder:(NSString *)placeholder style:(NSString *)type;
- (BOOL)textFieldIsnotNil;

-(void)resetTitle:(NSString *)title;

-(void)deleteTitle:(NSString *)title;


-(void)resetPlacehoder:(NSString *)placehoder;
- (void)textFieldCheckWithClickButton;  /** 判断当前switchbutton 是否需要打开 */

@end
