//
//  WPInterviewApplyCompanyController.h
//  WP
//
//  Created by CBCCBC on 15/12/10.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"

@protocol WPInterviewApplyCompanyDelegate <NSObject>

- (void)getInterviewApplyCompanyInfo:(NSString *)epId andIsall:(BOOL)isAll;

@end

@interface WPInterviewApplyCompanyController : BaseViewController

@property (nonatomic, assign) id <WPInterviewApplyCompanyDelegate>delegate;
@property (nonatomic, copy) NSString *choiseCell;
@property (nonatomic, assign)BOOL isFix;
@property (nonatomic, assign)BOOL isFromDetail;

@property (nonatomic, assign)BOOL personalApply;//个人申请
@property (nonatomic, assign)BOOL personalApplyList;

@property (nonatomic, assign)BOOL isFromMyRob;//我抢的人
@property (nonatomic, assign)BOOL isFromMyRobList;

@property (nonatomic, assign)BOOL isFRromCollection;
@property (nonatomic, assign)BOOL isFRromMuchCollection;
@end
