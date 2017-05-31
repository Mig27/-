//
//  WPResumeUserVC.h
//  WP
//
//  Created by Kokia on 16/3/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPResumeUserInfoModel.h"

@protocol WPResumeUserDelegate <NSObject>

- (void)reloadResumeDataWithModel:(WPResumeUserInfoModel *)model;

@end

@interface WPResumeUserVC : BaseViewController
@property (nonatomic ,assign)BOOL isBuildNew;
@property (nonatomic, weak) id<WPResumeUserDelegate> delegate;
@property (nonatomic, assign)int isRecuilist;
@property (assign , nonatomic) BOOL isBuild;
@property (assign , nonatomic) BOOL isApplyFromList;
@property (assign , nonatomic) BOOL isApplyFromDetail;
@property (assign , nonatomic) BOOL isApplyFromDetailList;
@property (assign , nonatomic) BOOL isFromCompanyGive;
@property (assign , nonatomic) BOOL isFromCompanyGiveList;
@property (assign , nonatomic)BOOL isFromMyApply;//我的申请

@property (assign , nonatomic) BOOL isFromCollection;//从收藏中申请
@property (assign , nonatomic) BOOL isFromMuchCollection;

@property (copy , nonatomic) NSString * choiseResume;//创建时选择的简历ID
@end
