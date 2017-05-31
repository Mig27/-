//
//  WPComInfWebViewController.h
//  WP
//
//  Created by CBCCBC on 16/3/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "WPCompanyListModel.h"
#import "WPInterviewApplyChooseController.h"
#import "WPCompanysModel.h"

@protocol WPComInfWebViewDelegate <NSObject>

- (void)getCompanyInfo:(WPCompanyListModel *)model;

@end

@interface WPComInfWebViewController : BaseViewController
@property (strong, nonatomic) WPCompanyListModel *listModel;
@property (nonatomic ,assign)id <WPComInfWebViewDelegate> delegate;
@property (nonatomic, assign) BOOL isFix;
@property (nonatomic, assign) BOOL isFromDetail;
@property (nonatomic, assign) BOOL isBuild;
@property (nonatomic, assign) BOOL personalApply;
@property (nonatomic, assign) BOOL personalApplyList;

@property (nonatomic, assign) BOOL isFromMyRob;//我抢的人
@property (nonatomic, assign) BOOL isFromMyRobList;
@property (nonatomic, assign) BOOL isFromcollection;
@property (nonatomic, assign) BOOL isFromMuchcollection;
@property (nonatomic, assign) BOOL isMyPersonalCompany;
@property (nonatomic ,strong) CompanyModel *companyModel;
//@property (nonatomic , strong)NSString *ep_id;

@end
