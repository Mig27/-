//
//  WPcompanyInfoViewController.h
//  WP
//
//  Created by CC on 16/8/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "WPInterviewApplyChooseDetailModel.h"
#import "WPInterviewApplyChooseController.h"
@protocol getCompamyInfo <NSObject>

- (void)controller:(WPInterviewApplyChooseController *)controller Model:(WPInterviewApplyChooseDetailModel *)model;

@end

@interface WPcompanyInfoViewController : BaseViewController
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *subId;
@property (nonatomic, assign) int isRecuilist;
@property (nonatomic, assign) id<getCompamyInfo>delegate;
@property  (nonatomic, strong) WPInterviewApplyChooseDetailModel*infoModel;


@property (assign ,nonatomic) BOOL isFromList;
@property (assign, nonatomic) BOOL isFromDetail;
@property (assign, nonatomic) BOOL isFromDetailList;
@property (assign, nonatomic) BOOL personalApply;
@property (assign, nonatomic) BOOL personalApplyList;

@property (assign, nonatomic) BOOL isFromMyRob;//我抢的人
@property (assign, nonatomic) BOOL isFromMyRobList;

@property (assign, nonatomic) BOOL isFromCollection;//
@property (assign, nonatomic) BOOL isFromMuchCollection;
@end
