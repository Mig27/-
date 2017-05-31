//
//  WPRecuilistApplyView.h
//  WP
//
//  Created by CBCCBC on 15/11/6.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPDateView.h"
//#import "WPRecruitApplyModel.h"

//#import "WPRecruitApplyChooseModel.h"

//#import "WPRecruitApplyChooseDetailModel.h"

#import "WPResumeUserInfoModel.h"

typedef NS_ENUM(NSInteger,WPRecruitApplyViewType){
    WPRecruitApplyViewTypeLightspot,
    WPRecruitApplyViewTypeEducationList,
    WPRecruitApplyViewTypeWorkList
};

typedef NS_ENUM(NSInteger,WPRecruitApplyViewActionType) {
     /** 姓名 */
    WPRecruitApplyViewActionTypeName = 20,
     /** 性别 */
    WPRecruitApplyViewActionTypeSex,
     /** 出生年月 */
    WPRecruitApplyViewActionTypeBirthday,
     /** 学历 */
    WPRecruitApplyViewActionTypeEducation,
     /** 工作年限 */
    WPRecruitApplyViewActionTypeWorkTime,
    /** 目前薪资 */
    WPRecruitApplyViewActionTypeNowSalary,
    /** 婚姻状况 */
    WPRecruitApplyViewActionTypeMarriage,
    /** 户籍 */
    WPRecruitApplyViewActionTypeHometown,
     /** 现居住地 */
    WPRecruitApplyViewActionTypeNowAddress,
    
     /** 期望职位 */
    WPRecruitApplyViewActionTypePosition,
     /** 期望薪资 */
    WPRecruitApplyViewActionTypeSalary,
    /** 期望地区 */
    WPRecruitApplyViewActionTypeArea,
     /** 期望福利  */
    WPRecruitApplyViewActionTypeWelfare,
  
     /** 个人亮点 */
    WPRecruitApplyViewActionTypeLightPoint,
     /** 教育经历 */
    WPRecruitApplyViewActionTypeEducationList,
     /** 工作经历 */
    WPRecruitApplyViewActionTypeWorkList,

     /** WeChat */
    WPRecruitApplyViewActionTypeWeChat,
     /** QQ */
    WPRecruitApplyViewActionTypeQQ,
     /** Email */
    WPRecruitApplyViewActionTypeEmail
};

@interface WPRecruitApplyView : UIView

@property (copy, nonatomic) NSMutableArray *photosArray;
@property (copy, nonatomic) NSMutableArray *videosArray;

@property (copy, nonatomic) void (^addPhotoBlock)();

@property (copy, nonatomic) void (^pushSubController)();

@property (copy, nonatomic) void (^checkVideoBlock)(NSInteger videoTag);

@property (copy, nonatomic) void (^checkALlBlock)();

@property (nonatomic, copy) void (^RecruitApplyViewBlock)(WPRecruitApplyViewType type);

//@property (strong, nonatomic) WPRecruitApplyModel *model;

//@property (strong, nonatomic) WPRecruitApplyChooseDetailModel *listModel;

@property (strong, nonatomic) WPResumeUserInfoModel *listModel;

@property (nonatomic ,assign)BOOL addChooseView;

@property (strong, nonatomic) SPDateView *dateView;
- (void)removeRedView;
- (BOOL)couldnotCommit;
- (void)updatePhotoView;

+(NSArray *)getApplyConditionIndexesInArray:(NSArray *)applyArray;

// 选择求职者
- (void)setChooseViewName:(NSString *)name;

@end
