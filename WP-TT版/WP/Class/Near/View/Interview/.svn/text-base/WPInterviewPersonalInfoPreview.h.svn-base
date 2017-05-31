//
//  WPInterviewPersonalInfoView.h
//  WP
//
//  Created by CBCCBC on 15/11/26.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPUserListModel.h"

/**
 *  面试，求职个人信息预览界面
 */
@interface WPInterviewPersonalInfoPreview : UIScrollView

@property (strong, nonatomic) NSArray *photosArr;
@property (strong, nonatomic) NSArray *videosArr;


@property (nonatomic, strong) NSArray *educationListArr;
@property (nonatomic, strong) NSArray *workListArr;

@property (nonatomic, copy) NSString *lightspotStr; // 个人使用,拼接的字符串；
@property (nonatomic, strong) NSArray *lightspotArr; // 似乎废弃；


@property (strong, nonatomic) WPUserListModel *model;

@property (copy, nonatomic) void (^checkPhotosBlock)();
@property (copy, nonatomic) void (^checkAllVideosBlock)();
@property (copy, nonatomic) void (^checkVideosBlock)(NSInteger number);

-(void)reloadData;

@end
