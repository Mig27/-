//
//  WPInterviewApplyChooseController.h
//  WP
//
//  Created by CBCCBC on 15/11/10.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "WPInterviewApplyChooseDetailModel.h"

@protocol WPInterviewApplyChooseUserDelegate;

@interface WPInterviewApplyChooseController : BaseViewController

@property (nonatomic ,strong)NSString *string;

@property (copy, nonatomic) NSString *sid;

@property (nonatomic, copy) NSString * choiseJobId;

@property (nonatomic ,assign)BOOL isFix;
@property (nonatomic, assign)BOOL isFromDetail;
@property (nonatomic, assign)BOOL isFromList;
@property (nonatomic, assign)BOOL personIsFromDetail;
@property (nonatomic, assign)BOOL personDetailList;
@property (nonatomic, assign)BOOL personalApply;//个人申请
@property (nonatomic, assign)BOOL personalApplyList;

@property (nonatomic, assign)BOOL isFromMyRob;//我抢的人
@property (nonatomic, assign)BOOL isFromMyRobList;
@property (nonatomic, assign)BOOL isFromCollection;//从收藏中强人
@property (nonatomic, assign)BOOL isFromMuchCollection;
@property (assign, nonatomic) id <WPInterviewApplyChooseUserDelegate> delegate;

@end

@protocol WPInterviewApplyChooseUserDelegate <NSObject>

@optional 

- (void)controller:(WPInterviewApplyChooseController *)controller Model:(WPInterviewApplyChooseDetailModel *)model;

- (void)getCompanyInfoWithModel:(WPCompanyListModel *)model;

@end