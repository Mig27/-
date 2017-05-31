//
//  WPResumePreview.h
//  WP
//
//  Created by Kokia on 16/3/31.
//  Copyright © 2016年 WP. All rights reserved.
//

//

#import <UIKit/UIKit.h>

#import "WPResumeUserInfoModel.h"

@class WPRecruitApplyController;

@interface WPResumePreview : UIScrollView

@property (nonatomic, strong) WPRecruitApplyController *vc;

@property (nonatomic, strong) NSArray *photosArr;
@property (nonatomic, strong) NSArray *videosArr;

@property (nonatomic, copy)   NSString *lightspotStr;

@property (nonatomic, strong) NSArray *lightspotArr;
@property (nonatomic, strong) NSArray *educationListArr;
@property (nonatomic, strong) NSArray *workListArr;

@property (nonatomic,copy) NSString * lightStr;//亮点描述
@property (nonatomic, assign) BOOL isApply;//点击申请

@property (nonatomic, strong) WPResumeUserInfoModel *model;
@property (nonatomic, copy) void (^isOpenOrNot)(NSString*openStr,NSString *userID,BOOL isOr);
@property (nonatomic, copy) void (^checkPhotosBlock)();
@property (nonatomic, copy) void (^checkAllVideosBlock)();
@property (nonatomic, copy) void (^checkVideosBlock)(NSInteger number);

-(void)reloadData;



@end
