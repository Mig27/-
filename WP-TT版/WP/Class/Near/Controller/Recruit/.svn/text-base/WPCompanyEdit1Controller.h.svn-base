//
//  WPCompanyEditController.h
//  WP
//
//  Created by CBCCBC on 15/10/9.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "WPCompanyModel.h"
#import "WPRecruitController.h"

@protocol RefreshCompanyInfo1Delegate <NSObject>

- (void)RefreshCompanyInfo1:(SPRecuilistModel *)model;

@end

@interface WPCompanyEdit1Controller : BaseViewController

@property (strong, nonatomic) WPCompanyListModel *listModel;
@property (assign, nonatomic) id <RefreshCompanyInfo1Delegate>delegate;

@end
