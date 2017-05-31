//
//  WPResumeEditVC.h
//  WP
//
//  Created by Kokia on 16/3/28.
//  Copyright © 2016年 WP. All rights reserved.
//  个人信息 -->编辑个人信息
//  个人信息 -->创建个人信息

// 参考WPInterviewEditController修改



#import <UIKit/UIKit.h>

#import "WPResumeUserInfoModel.h"
#import "WPPersonListModel.h"
#import "WPInterviewEducationController.h"
#import "WPInterviewWorkController.h"
extern NSString *const kNotifacationInterviewUserIsSelected;


// 参考这里 WPRecruitApplyView

typedef NS_ENUM(NSInteger, InterviewEditItemType) {
    InterviewEditItemTypeName,
    InterviewEditItemTypeSex,
    InterviewEditItemTypeBirthday,
    InterviewEditItemTypeEducation,
    InterviewEditItemTypeWorkTimes,
    InterviewEditItemTypeNowSalary,
    InterviewEditItemTypeMarriage,
    InterviewEditItemTypeHometown,
    InterviewEditItemTypeNowAddress,    // 8

    InterviewEditItemTypeLightPoint,
    InterviewEditItemTypeEducationList,
    InterviewEditItemTypeNowWorkList,

};

@protocol WPResumeEditVCDelagte <NSObject>

- (void)reloadVCData;

@end

@interface WPResumeEditVC : BaseViewController
@property (nonatomic ,strong) id<WPResumeEditVCDelagte>delegate;
@property (nonatomic, strong) WPPersonModel *personModel;
@property (nonatomic, strong) WPResumeUserInfoModel *userModel;
@property (nonatomic, assign) BOOL setup;
@property (nonatomic, assign) NSInteger isPerson;
@property (nonatomic, assign) NSInteger isEdit;
@property (nonatomic, assign) BOOL isPersonInfo;
@property (nonatomic, copy) void(^upDataSuccess)();


- (void)setupSubViews;

@end
