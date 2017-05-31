//
//  SPRecPreview.h
//  WP
//
//  Created by CBCCBC on 15/10/27.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPRecruitController.h"
#import "WPCompanyListModel.h"
#import "SPShareView.h"
@interface WPRecruitPreviewModel : BaseModel

@property (nonatomic, strong) WPCompanyListModel *listModel;/**< 公司信息Model */
@property (nonatomic, strong) NSArray *photosArr;/**< 照片数组 */
@property (nonatomic, strong) NSArray *videosArr;/**< 视频数组 */
@property (nonatomic, strong) NSArray *logoArr;/**< LOGO */
@property (nonatomic, strong) NSArray *briefArr;/**< 公司简介数组 */
@property (nonatomic, copy) NSString *briefStr;//公司简介
@property (nonatomic, strong) NSArray *recruitResumeArr;/**< 招聘简历数组 */


@end

@interface SPRecPreview : UIScrollView

@property (nonatomic, strong) WPRecruitPreviewModel *model;
@property (copy, nonatomic) void (^checkAllVideosBlock)();/**< 查看照片视频Block */
@property (copy, nonatomic) void (^checkVideosBlock)(NSInteger number);/**< 播放视频Block */
@property (copy, nonatomic) void (^clickOpen)();
@property (strong , nonnull) SPShareView *share;
@property (nonatomic, assign) BOOL isAddShare;
@end
