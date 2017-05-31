//
//  WPResumeWebVC.h
//  WP
//
//  Created by Kokia on 16/3/24.
//  Copyright © 2016年 WP. All rights reserved.
//


// 参考 WPRecruitWebViewController

#import <UIKit/UIKit.h>
#import "WPResumeUserInfoModel.h"
#import "WPResumeUserListModel.h"
#import "WPPersonListModel.h"
#import "WPCompanysModel.h"
@protocol WPResumeWebVCDelegate <NSObject>

- (void)reloadResumeDataWithModel:(WPResumeUserInfoModel *)model;
-(void)reloadDataWithEpid:(NSString*)epid;
@end

@interface WPResumeWebVC : BaseViewController
@property (nonatomic , weak) id<WPResumeWebVCDelegate>delegate;
@property (nonatomic , assign) BOOL isBuildNew;
@property (nonatomic , strong) WPResumeUserModel *model;
@property (nonatomic , strong) WPResumeUserInfoModel *infoModel;
@property (nonatomic , assign)int isRecuilist;
@property (nonatomic , copy) NSString * resumeId;

@property (assign , nonatomic) BOOL isBuild;
@property (assign , nonatomic) BOOL isApplyFromList;
@property (assign , nonatomic) BOOL isApplyFromDetail;
@property (assign , nonatomic) BOOL isApplyFromDetailList;

@property (assign , nonatomic) BOOL choiseResume;

@property (assign , nonatomic) BOOL isFromCompanyGive;
@property (assign , nonatomic) BOOL isFromCompanyGiveList;

@property (assign , nonatomic) BOOL isFromMyApply;//我的申请

@property (assign , nonatomic) BOOL isFromCollection;//从收藏中申请
@property (assign , nonatomic) BOOL isFromMuchCollection;
@property (assign , nonatomic) BOOL isMyPersonalInfo;//从个人信息中来
@property (strong , nonatomic) WPPersonModel * personalModel;
@property (strong , nonatomic) CompanyModel  * company;
@property (copy , nonatomic) void(^setAgain)();
@end
