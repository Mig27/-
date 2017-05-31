//
//  WPPersonalInfoPreview.h
//  WP
//
//  Created by Kokia on 16/3/28.
//  Copyright © 2016年 WP. All rights reserved.
//


//

#import <UIKit/UIKit.h>

#import "WPResumeUserInfoModel.h"

/**
 *  求职个人信息预览界面
 *  参考 WPInterviewPersonalInfoPreview
 */
@interface WPPersonalInfoPreview : UIScrollView

@property (nonatomic, strong) NSArray *photosArr;
@property (nonatomic, strong) NSArray *videosArr;       // 照片、视频

@property (nonatomic, strong) NSArray *educationListArr;    // 教育经历
@property (nonatomic, strong) NSArray *workListArr;         // 工作经历

@property (nonatomic, copy) NSString *lightspotStr;     // 个人亮点,拼接的字符串；
@property (nonatomic, strong) NSArray *lightspotArr;    // 个人亮点

@property (nonatomic, strong) WPResumeUserInfoModel *model;

@property (nonatomic, copy) void (^checkPhotosBlock)();     // 箭头点击

@property (nonatomic, copy) void (^checkVideosBlock)(NSInteger number); // 视频播放

@property (nonatomic, copy) void (^checkAllVideosBlock)();



-(void)reloadData;


@end
