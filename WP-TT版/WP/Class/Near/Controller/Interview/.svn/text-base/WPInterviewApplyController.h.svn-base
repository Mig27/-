//
//  WPInterviewApplyController.h
//  WP
//
//  Created by CBCCBC on 15/11/10.
//  Copyright © 2015年 WP. All rights reserved.
//

// 创建简历 界面


#import "WPInterviewApplyChooseDetailModel.h"


@protocol WPInterviewApplyDelegate <NSObject>
@optional
- (void)interviewApplyDelegate;
- (void)isAlready;
@end

@interface WPInterviewApplyController : BaseViewController
@property (nonatomic ,strong)NSString *controller;
@property (copy, nonatomic) NSString *sid;
@property (nonatomic, copy) NSString * jobId;
@property (nonatomic,assign) BOOL isFix;
@property (nonatomic, assign) BOOL isFromDetail;
@property (nonatomic, assign) BOOL personIsFromDetail;
@property (nonatomic, assign) BOOL personDetailList;
@property (nonatomic, assign) BOOL personalApply;//个人申请
@property (nonatomic, assign) BOOL personalApplytList;
@property (strong, nonatomic) WPInterviewApplyChooseDetailModel *detailModel;
@property (assign, nonatomic) id <WPInterviewApplyDelegate> delegate;

@property (assign ,nonatomic) BOOL isFromList;

@property (assign ,nonatomic) BOOL isFromMyRob;//我抢的人
@property (assign ,nonatomic) BOOL isFromMyRobList;

@property (assign ,nonatomic) BOOL isFromCollection;//从收藏中强人
@property (assign ,nonatomic) BOOL isFromMuchCollection;
@property (nonatomic,copy) void (^robSuccess)();
@end
