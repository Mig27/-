//
//  WPRecruitApplyController.h
//  WP
//
//  Created by CBCCBC on 16/4/18.
//  Copyright © 2016年 WP. All rights reserved.
//  创建求职简历


#import "BaseViewController.h"

//#import "WPRecruitApplyChooseDetailModel.h"

#import "WPResumeUserInfoModel.h"

@protocol WPRecruitApplyDelegate <NSObject>

- (void)recruitApplyDelegate;

@end

@interface WPRecruitApplyController : BaseViewController

@property (copy, nonatomic) NSString *sid;      // 可以使job_id;

//@property (strong, nonatomic) WPRecruitApplyChooseDetailModel *detailModel;

@property (strong, nonatomic) WPResumeUserInfoModel *detailModel;

@property (assign, nonatomic) id <WPRecruitApplyDelegate> delegate;

@property (assign , nonatomic) BOOL isBuildNew;
@property (assign , nonatomic) BOOL isBuild;
@property (assign , nonatomic) BOOL isApplyFromList;
@property (assign , nonatomic) BOOL isApplyFromDetail;
@property (assign , nonatomic) BOOL isApplyFromDetailList;

@property (assign , nonatomic) BOOL isFromCompanyGiveList;//从企业投递中点击到职位列表的申请
@property (assign , nonatomic) BOOL isFromCompanyGive;

@property (assign , nonatomic) BOOL isFromMyApply;//我的申请

@property (assign , nonatomic) BOOL isFromcollection;//从收藏中申请
@property (assign , nonatomic) BOOL isFromMuchcollection;
@property (nonatomic,copy)NSString * lightStr;
@property (nonatomic,assign)int isRecuilist;
@property (nonatomic,assign)BOOL isFix;
@property (nonatomic, copy)void(^upLoadMyApply)(NSDictionary*);
@property (nonatomic, copy)void(^applySuccess)();
- (void)reloadResumeUserDataWithModel:(WPResumeUserInfoModel *)model;     // 选择用户返回；

@end
