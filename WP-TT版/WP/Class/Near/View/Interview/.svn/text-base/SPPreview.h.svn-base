//
//  SPItemPreview.h
//  WP
//
//  Created by CBCCBC on 15/9/23.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPInterView.h"
#import "SPShareView.h"
//#import "WPInterviewDraftEditController.h"
@class WPInterviewDraftEditController;
@interface SPPreview : UIScrollView
@property (nonatomic, strong) WPInterviewDraftEditController *vc;
@property (nonatomic, strong) NSArray *photosArr;
@property (nonatomic, strong) NSArray *videosArr;

@property (nonatomic, copy)   NSString *lightspotStr;
@property (nonatomic, copy)   NSString *lightspot;//亮点描述

@property (nonatomic, strong) NSArray *lightspotArr;
@property (nonatomic, strong) NSArray *educationListArr;
@property (nonatomic, strong) NSArray *workListArr;

@property (nonatomic, strong) WPInterEditModel *model;

@property (nonatomic, copy) void (^checkPhotosBlock)();
@property (nonatomic, copy) void (^checkAllVideosBlock)();
@property (nonatomic, copy) void (^checkVideosBlock)(NSInteger number);
@property (nonatomic, copy) void(^clickShareBlock)();
@property (nonatomic, strong) SPShareView * shareView;
-(void)reloadData;

@end
