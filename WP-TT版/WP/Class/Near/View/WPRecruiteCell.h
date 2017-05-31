//
//  WPRecruiteCell.h
//  WP
//
//  Created by CBCCBC on 16/4/18.
//  Copyright © 2016年 WP. All rights reserved.
//  创建求职简历控制器---> cell 类型

#import <UIKit/UIKit.h>

@interface WPRecruiteCell : UITableViewCell

@property (nonatomic , assign)BOOL enable;
@property (nonatomic , strong)NSString *title;
@property (nonatomic , strong)NSString *placeHolder;
@property (nonatomic , strong)NSString *text;
@property (nonatomic , strong)UITextField *textFied;

- (void)resignFirstResponder;
- (void)textFieldIsnotNil:(BOOL)isNil;


@end
