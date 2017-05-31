//
//  WPInterviewEducationController.h
//  WP
//
//  Created by CBCCBC on 15/12/15.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseModel.h"

#import "WPResumeUserInfoModel.h"

@interface WPInterviewEducationModel : BaseModel

@property (nonatomic, copy) NSString *epId;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *endTWPInterviewEducationModelime;
@property (nonatomic, copy) NSString *schoolName;
@property (nonatomic, copy) NSString *major;
@property (nonatomic, copy) NSString *majorId;
@property (nonatomic, copy) NSString *education;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, strong) NSArray *epList;
@property (nonatomic, assign) BOOL isSelected;





@end




typedef NS_ENUM(NSInteger,WPInterviewEducationType) {
    WPInterviewEducationTypeCreate,
    WPInterviewEducationTypeEdit
    
};


@protocol WPInterviewEducationDelegate <NSObject>

- (void)getEducation:(Education *)educationModel type:(WPInterviewEducationType)type;

@end


@interface WPInterviewEducationController : BaseViewController
@property (nonatomic ,getter=isAdd) BOOL add;
@property (nonatomic,strong) Education *model;         //用来存放活动详情的相关数据
@property (nonatomic, assign) WPInterviewEducationType type;
@property (nonatomic, assign) id <WPInterviewEducationDelegate> delegate;
@property (nonatomic, assign) NSInteger isEditCome;
@property (nonatomic,strong) NSMutableArray * modelArray;//存放编辑时传来的model;
@property (nonatomic,assign) NSInteger indespath;//存放编辑时传来的位置
@property (nonatomic,assign)BOOL isFix;
@property (nonatomic,assign)BOOL listFix;

@property (nonatomic,assign)BOOL isFromPersonInfo;//是否从个人信息界面过来
@property (nonatomic, assign) BOOL isApplyFromDetail;//从详情中申请
@property (nonatomic,assign)BOOL isAppyFromDetailList;//从详情列表中申请
@end
