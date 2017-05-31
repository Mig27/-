//
//  WPChooseResumerController.h
//  WP
//
//  Created by CBCCBC on 16/4/15.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "WPResumeUserInfoModel.h"
@protocol WPChooseResumerDelegate <NSObject>

- (void)reloadResumeDataWithModel:(WPResumeUserInfoModel *)model;
-(void)getInterviewApplypersonInfo:(NSString*)resumeUserId andIsAll:(BOOL)isAll;
@end
@interface WPChooseResumerController : BaseViewController

@property (nonatomic ,strong) id<WPChooseResumerDelegate>delegate;
@property (nonatomic, copy) NSString*choiseCell;
@property (assign , nonatomic) BOOL isBuild;
@property (assign , nonatomic) BOOL isApplyFromList;
@property (assign , nonatomic) BOOL isApplyFromDetail;
@property (assign , nonatomic) BOOL isApplyFromDetailList;

@property (assign , nonatomic) BOOL isFromCompanyGive;//企业投递中申请
@property (assign , nonatomic) BOOL isFromCompanyGiveList;
@property (assign , nonatomic) BOOL isFromMyApply;//我的申请

@property (assign , nonatomic) BOOL isFromCollection;//从收藏中申请
@property (assign , nonatomic) BOOL isFromMuchCollection;
@end
