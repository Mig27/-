//
//  WPCompanyController.h
//  WP
//
//  Created by Kokia on 16/3/4.
//  Copyright © 2016年 WP. All rights reserved.
//

// 企业列表  我的企业

#import <UIKit/UIKit.h>
#import "WPCompanyListModel.h"
#import "WPRecruitDraftInfoModel.h"
#import "WPCompanyListModel.h"
#import "WPRecruitDraftInfoModel.h"
typedef void (^SPSuccessBlock)(WPCompanyListModel *listModel);
typedef void (^SPErrorBlock)(NSError *);

@protocol WPGetCompanyInfoDelegate <NSObject>

- (void)getCompanyInfo:(WPCompanyListModel *)model;

@end

@interface WPCompanyController : BaseViewController
@property (nonatomic, assign) BOOL isBuild;
@property (nonatomic, copy) NSString * choiseCompanyId;
@property (assign, nonatomic) id <WPGetCompanyInfoDelegate> delegate;

@end
