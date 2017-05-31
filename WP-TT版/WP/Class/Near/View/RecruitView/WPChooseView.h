//
//  WPChooseView.h
//  WP
//
//  Created by CBCCBC on 16/3/11.
//  Copyright © 2016年 WP. All rights reserved.
//

// 选择求职者

#import <UIKit/UIKit.h>



@interface WPChooseView : UIView

@property (nonatomic ,strong)UIButton *button;

@property (nonatomic ,strong)UILabel *label;

@property(nonatomic , strong) UILabel * title;
@property (nonatomic , strong) UIButton * titleBtn;
@property (nonatomic, assign) BOOL BuildNew;
@end
