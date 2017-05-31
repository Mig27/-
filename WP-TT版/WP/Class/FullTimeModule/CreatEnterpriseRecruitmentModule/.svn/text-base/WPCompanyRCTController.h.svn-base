//
//  WPCompanyRCTController.h
//  WP
//
//  Created by Kokia on 16/4/19.
//  Copyright © 2016年 WP. All rights reserved.
//  全职 --> 企业招聘 --> 创建 --> 草稿

#import <UIKit/UIKit.h>
#import "WPRecruitDraftInfoModel.h"

typedef void (^RecruitDraftSuccessBlock)(WPRecruitDraftInfoModel *model);

@protocol getCompanyDreaftInfo <NSObject>

-(void)getCompanyInfoDreaft:(WPRecruitDraftInfoModel*)model;

@end
@interface WPCompanyRCTController : BaseViewController
@property (nonatomic,strong)id <getCompanyDreaftInfo> delegate;
@property (nonatomic, copy) NSString * choiseDraftId;
@end
