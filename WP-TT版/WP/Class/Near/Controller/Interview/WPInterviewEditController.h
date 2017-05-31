//
//  WPInterviewEdltController.h
//  WP
//
//  Created by CBCCBC on 15/10/20.
//  Copyright © 2015年 WP. All rights reserved.
//

// 点击用户，个人信息；

#import "BaseViewController.h"
#import "WPUserListModel.h"
#import "WPPersonListModel.h"

extern NSString *const kNotifacationInterviewUserIsSelected;

typedef NS_ENUM(NSInteger, InterviewEditItemType) {
    InterviewEditItemTypeName,
    InterviewEditItemTypeSex,
    InterviewEditItemTypeEducation,
    InterviewEditItemTypeWorkTimes,
    InterviewEditItemTypeHometown,
    InterviewEditItemTypeNowAddress,
    InterviewEditItemTypeNowPhone = 35
};

@protocol RefreshUserListDelegate <NSObject>

- (void)refreshUserListDelegate:(WPUserListModel *)model;

@end

@interface WPInterviewEditController : BaseViewController
@property (nonatomic ,strong) WPPersonModel *personModel;
@property (strong, nonatomic) WPUserListModel *listModel;
@property (assign, nonatomic) id <RefreshUserListDelegate> delegate;

- (void)setupSubViews;

@end
