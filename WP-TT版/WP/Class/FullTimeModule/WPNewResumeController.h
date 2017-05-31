//
//  WPMainInterviewController.h
//  WP
//
//  Created by CBCCBC on 16/1/21.
//  Copyright © 2016年 WP. All rights reserved.
//  全职 --> 面试
//  全职 --> 企业招聘
//  首页 --> 热门职位展示列表
//  首页 --> 热门专区展示列表

/**
 *  面试
 *
 *  企业招聘
 *
 */

#import "BaseViewController.h"
#import "WPTitleView.h"
typedef NS_ENUM(NSInteger,WPMainPositionType) {
    WPMainPositionTypeInterView,        // 面试    0
    WPMainPositionTypeRecruit,          // 企业招聘 1
};

@interface WPNewResumeController : BaseViewController
@property (nonatomic, assign) BOOL isPostion;
@property (nonatomic, assign) BOOL isIndustry;
@property (assign, nonatomic) WPMainPositionType type;
@property (nonatomic, strong) NSString *hotPosition;
@property (nonatomic, strong) NSString *hotArea;
@property (nonatomic, strong) WPTitleView * titleView;
@property (nonatomic, assign) BOOL isNew;//陌生人发布的
@property (nonatomic, assign) BOOL isFriend;//好友发布的
@property (nonatomic, assign) BOOL isFromInduetry;//从行业中点击不显示消息提醒
@property (nonatomic, strong) NSString * titleString; /**< 行业名称  例如: 销售*/
@property (nonatomic, copy) NSString * positionHangID;/**< 行业中的职位id  例如: 1903(销售--->电话销售) */
@property (nonatomic, copy) NSString * hangFatherID;/**< 行业中的fatherid 例如: 1900(销售) */

@end
