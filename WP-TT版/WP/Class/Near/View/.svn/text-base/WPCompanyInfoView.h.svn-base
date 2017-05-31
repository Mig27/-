//
//  WPCompanyInfoView.h
//  WP
//
//  Created by CBCCBC on 16/3/31.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPCompanyListModel.h"

@interface WPCompanyInfoView : UIScrollView

@property (nonatomic ,strong) WPCompanyListModel *model;


@property (nonatomic, strong) NSArray *photosArr;
@property (nonatomic, strong) NSArray *videosArr;

@property (nonatomic, strong) NSArray *educationListArr;
@property (nonatomic, strong) NSArray *workListArr;

@property (nonatomic, copy) NSString *lightspotStr;
@property (nonatomic, strong) NSMutableArray *lightspotArr;

//@property (nonatomic, strong) WPResumeUserInfoModel *model;

@property (nonatomic, copy) void (^checkVideosBlock)(NSInteger number); // 视频播放

@property (nonatomic, copy) void (^checkAllVideosBlock)();



-(void)reloadData;
//-(void)reloadData;
@end
