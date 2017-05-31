//
//  WPInterviewApplyView.h
//  WP
//
//  Created by CBCCBC on 15/11/10.
//  Copyright © 2015年 WP. All rights reserved.
//


// 求职简历界面

#import <UIKit/UIKit.h>
#import "WPRecruitApplyModel.h"
//#import "WPRecruitApplyChooseDetailModel.h"
#import "WPInterviewApplyModel.h"
#import "WPInterviewApplyChooseModel.h"
#import "WPInterviewApplyChooseDetailModel.h"
#import "UISelectCity.h"
typedef NS_ENUM(NSInteger,WPInterviewType) {
    WPInterviewTypeRequire,
    WPInterviewTypeCompanyBrief
};

typedef NS_ENUM(NSInteger,WPInterviewApplyViewActionType) {
    WPInterviewApplyViewActionTypeCompanyName = 20,     // 姓名
    WPInterviewApplyViewActionTypeCompanyIndustry,      // 行业
    WPInterviewApplyViewActionTypePropreties,           // 性质
    WPInterviewApplyViewActionTypeScale,                // 规模
    WPInterviewApplyViewActionTypeAddress,              // 地址
    WPInterviewApplyViewActionTypeDetailAddress,        //详细地址
    WPInterviewApplyViewActionTypePersonName,           // 联系人
    WPInterviewApplyViewActionTypePersonWebSite,        // 官网
    WPInterviewApplyViewActionTypeCompanyBrief,         // 简介
    WPInterviewApplyViewActionTypeRecruitPosition,      // 职位
    WPInterviewApplyViewActionTypeSalary,               // 待遇
    WPInterviewApplyViewActionTypeWelfare,              // 福利
    WPInterviewApplyViewActionTypeWorkAddress,          // 工作年限
    WPInterviewApplyViewActionTypeWorkAds,              // 学历要求
    WPInterviewApplyViewActionTypeRequire,              // 性别要求
    WPInterviewApplyViewActionTypeCompanyPhone,         // 年龄要求
    WPInterviewApplyViewActionTypeCompanyQQ,            // 招聘人数
    WPInterviewApplyViewActionTypeCompanyWeChat,        // 工作区域
    WPInterviewApplyViewActionTypeCompanyWebsite,       // 详细地点
    WPInterviewApplyViewActionTypePhone,                // 手机号码
    WPInterviewApplyViewActionTypeCompanyEmail          // 任职要求
    
};


@interface WPInterviewApplyView : UIView
@property (strong, nonatomic) UIView *chooseView;
@property (copy, nonatomic) NSMutableArray *photosArray;
@property (copy, nonatomic) NSMutableArray *videosArray;
@property (copy, nonatomic) void (^addPhotoBlock)();
@property (copy, nonatomic) void (^addBackBlock)();
@property (copy, nonatomic) void (^pushSubController)();
@property (copy, nonatomic) void (^checkVideoBlock)(NSInteger videoTag);
@property (copy, nonatomic) void (^checkALlBlock)();
@property (copy, nonatomic) void (^InterviewApplyBlock)(WPInterviewType type);

@property (nonatomic, copy)void (^isPhoto)(BOOL isOrNot);//图片没有数据的回调
@property (nonatomic, copy)void (^isCompany)(BOOL isOrNot);//企业没有数据的回调
@property (nonatomic, copy)void (^isZhaoPin)(BOOL isOrNot);//招聘没有数据的回调
@property (strong, nonatomic) UIScrollView *baseView;
@property (strong, nonatomic) UIView *photoBaseView;
@property (strong, nonatomic) UIButton *backBtn;
@property (nonatomic, strong)UILabel * title;
//@property (strong, nonatomic) WPRecruitApplyModel *model;
@property (strong, nonatomic) WPInterviewApplyModel *model;
@property (nonatomic, copy) void(^telephoneNumShowOrHiddenBlock)(BOOL showed);  //手机号码隐藏,显示回调
//@property (strong, nonatomic) WPRecruitApplyChooseDetailModel *listModel;
@property (strong, nonatomic) WPInterviewApplyChooseDetailModel *listModel;
@property (strong, nonatomic) UISelectCity*city;
@property (nonatomic, assign) BOOL isChoised;
@property (nonatomic, assign) BOOL changeResume;
@property (nonnull, copy,nonatomic) void (^clickImage) (NSArray *imageArray, NSInteger firstInter,NSInteger secondInter );//点击第三个图片的回调
- (void)updatePhotoView;
- (void)updateBackView:(UIImage *)image;

- (BOOL)isAnyItemIsNil;

/**
 *  WPInterviewApplyView初始化入口
 *
 *  @param model 报名条件Model(弃用)
 */
- (void)startLayoutSubViews:(WPInterviewApplyChooseModel *)model;

+(NSArray *)getApplyConditionIndexesInArray:(NSArray *)applyArray;

@end
