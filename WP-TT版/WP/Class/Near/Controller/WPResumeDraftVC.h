//
//  WPResumeDraftVC.h
//  WP
//
//  Created by Kokia on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//  求职 --> 草稿页面

#import <UIKit/UIKit.h>

#import "WPResumeUserInfoModel.h"

// 简历草稿

@protocol WPResumeDraftVCDelegate <NSObject>

- (void)draftReloadResumeDataWithModel:(WPResumeUserInfoModel *)model;

@end

@interface WPResumeDraftVC : BaseViewController

@property (nonatomic, weak) id<WPResumeDraftVCDelegate> delegate;
@property (nonatomic, copy) NSString * choiseResumeId;

@end
