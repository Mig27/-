//
//  WPCompanyEditController.h
//  WP
//
//  Created by CBCCBC on 15/10/9.
//  Copyright © 2015年 WP. All rights reserved.
//  我的招聘--> 编辑企业信息
//  我的招聘--> 创建企业信息

#import "BaseViewController.h"
#import "WPCompanyListModel.h"
#import "WPCompanysModel.h"

@protocol RefreshCompanyInfoDelegate <NSObject>

- (void)RefreshCompanyInfo;

@end

@interface WPCompanyEditController : BaseViewController
@property (nonatomic ,assign)BOOL launch;
@property (nonatomic ,assign)BOOL edit;
@property (nonatomic ,assign)NSInteger isCompany;
@property (nonatomic ,assign)NSInteger isEditCompany;
@property (strong, nonatomic) WPCompanyListModel *listModel;
@property (nonatomic ,strong) CompanyModel *companyModel;
@property (assign, nonatomic) id <RefreshCompanyInfoDelegate>delegate;
@property (nonatomic, copy) void(^upDateSuccess)();
@end
