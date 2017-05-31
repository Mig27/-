//
//  WPInterviewController.h
//  WP
//
//  Created by CBCCBC on 15/9/21.
//  Copyright (c) 2015年 WP. All rights reserved.
//

// 创建简历 界面

#import "BaseViewController.h"
#import "WPUserListModel.h"

typedef NS_ENUM(NSInteger,WPInterviewAfterChooseUserViewType) {
    WPInterviewAfterChooseUserViewTypeName = 10000,
    WPInterviewAfterChooseUserViewTypeIcon = 10001,
    WPInterviewAfterChooseUserViewTypeInfo = 10002,
    WPInterviewAfterChooseUserViewTypeChoose = 10003,
};

@protocol WPInterviewControllerDelegate <NSObject>

- (void)WPInterviewControllerDelegate;

@end

@interface WPInterviewController : BaseViewController

@property (strong, nonatomic) WPUserListModel *model;/**< 唯一作用：判断是否为第一次创建 */
@property (assign, nonatomic) id <WPInterviewControllerDelegate> delegate;

@end
