//
//  WPRecruiteCell.h
//  WP
//
//  Created by CBCCBC on 16/4/18.
//  Copyright © 2016年 WP. All rights reserved.
//  创建求职简历控制器---> cell 类型

#import <UIKit/UIKit.h>

@protocol WPRecruiteCellDelegate <NSObject>

@optional
- (void)WPRecruiteCellDelegateClickeSwitchButton:(BOOL)isOepn;
@end

@interface WPRecruiteCell : UITableViewCell

@property (nonatomic, weak) id <WPRecruiteCellDelegate> delegate;
@property (nonatomic , assign)BOOL enable;
@property (nonatomic , strong)NSString *title;
@property (nonatomic , strong)NSString *placeHolder;
@property (nonatomic , strong)NSString *text;
@property (nonatomic , strong)UITextField *textFied;
@property (nonatomic, assign)BOOL swithEnable;  //是否显示switch开关
@property (nonatomic,assign) BOOL openShowTelephone; //是否显示电话号码
@property (nonatomic, strong)UIButton * selectButton;

- (void)resignFirstResponder;
- (void)textFieldIsnotNil:(BOOL)isNil;


@end
