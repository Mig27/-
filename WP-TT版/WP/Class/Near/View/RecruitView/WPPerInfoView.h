//
//  WPPerInfoView.h
//  WP
//
//  Created by CBCCBC on 16/3/11.
//  Copyright © 2016年 WP. All rights reserved.
//

// 用户个人信息，界面
#import <UIKit/UIKit.h>

typedef void(^frameBlock)(CGRect frame);

@interface WPPerInfoView : UIView

@property (nonatomic , strong)NSMutableArray *viewArr;  // View 视图
@property (nonatomic , assign)CGFloat leftCorner;

- (instancetype)initWithTop:(CGFloat)top;
- (BOOL)couldnotCommitFrameBlock:(frameBlock)frameBloack;
@end
