//
//  WPInterviewEdltController.h
//  WP
//
//  Created by CBCCBC on 15/10/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "WPUserListModel.h"
#import "DefaultParamsModel.h"

@protocol RefreshMyResumeDelegate <NSObject>

- (void)refreshUserListDelegate;

@end

@interface MyResumeEditController : BaseViewController

@property (strong, nonatomic) DefaultParamsModel *listModel;
@property (assign, nonatomic) id <RefreshMyResumeDelegate> delegate;
@property (assign, nonatomic) BOOL isEditing;                      //是否是修改

- (void)setupSubViews;

@end
