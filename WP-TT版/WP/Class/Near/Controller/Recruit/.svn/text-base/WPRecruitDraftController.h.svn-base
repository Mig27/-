//
//  WPRecruitDraftController.h
//  WP
//
//  Created by CBCCBC on 15/12/9.
//  Copyright © 2015年 WP. All rights reserved.
//

// 企业招聘 草稿

#import "BaseViewController.h"
#import "WPCompanyListModel.h"
#import "WPRecruitDraftInfoModel.h"

typedef void (^RecruitDraftSuccessBlock)(WPRecruitDraftInfoModel *model);

@protocol WPGetDraftInfoDelegate <NSObject>

- (void)getDraftInfo:(WPRecruitDraftInfoModel *)model;

@end

@interface WPRecruitDraftController : BaseViewController

@property (assign, nonatomic) id <WPGetDraftInfoDelegate> delegate;

@end
