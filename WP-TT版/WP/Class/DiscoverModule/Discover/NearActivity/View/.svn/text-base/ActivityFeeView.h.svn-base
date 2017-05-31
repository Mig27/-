//
//  ActivityFeeView.h
//  WP
//
//  Created by 沈亮亮 on 15/10/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPItemView.h"
#import "FeeModel.h"

@interface ActivityFeeView : UIView

@property (nonatomic,copy) void(^addMoreItem)(NSInteger tag); //添加费用
@property (nonatomic,copy) void(^deleteItem)(NSInteger tag);  //删除费用
@property (nonatomic,strong) UIButton *deleteBtn;             //删除按钮
@property (nonatomic,strong) SPItemView *name;                //名字
@property (nonatomic,strong) SPItemView *money;               //金额
@property (nonatomic,strong) SPItemView *num;                 //名额

- (void)setNumber:(NSInteger)number;
- (void)setNumber:(NSInteger)number andModel:(FeeModel *)model;

@end
