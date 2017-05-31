//
//  WPInterviewWorkListController.h
//  WP
//
//  Created by CBCCBC on 15/12/15.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseModel.h"

#import "WPResumeUserInfoModel.h"


@interface WPInterviewWorkModel : BaseModel

@property (nonatomic, copy) NSString *work_id;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *epName;
@property (nonatomic, copy) NSString *Industry_id;
@property (nonatomic, copy) NSString *industry;
@property (nonatomic, copy) NSString *ep_properties;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *position_id;
@property (nonatomic, copy) NSString *salary;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, strong) NSArray *epList;
@property (nonatomic, assign) BOOL isSelected;

@end

typedef NS_ENUM(NSInteger,WPInterviewWorkType)
{
    WPInterviewWorkTypeCreate ,
    WPInterviewWorkTypeEdit        // 编辑状态， 替换数据
          // 创建状态， 新增数据
};


@protocol WPInterviewWorkDelegate <NSObject>

- (void)getwork:(Work *)model type:(WPInterviewWorkType)type;

@end



@interface WPInterviewWorkController : BaseViewController
@property (nonatomic ,getter=isBuildNew) BOOL buildNew;
@property (nonatomic, strong) Work *model;

@property (nonatomic, assign) WPInterviewWorkType type;

/** 用来存放Work详情的相关数据 图片描述、文字描述*/
@property (nonatomic, strong) NSMutableArray *objects;      // 图片 、文字
@property (nonatomic,copy)NSMutableString * workStr;//职位描述
@property (nonatomic, assign) id <WPInterviewWorkDelegate> delegate;
@property(nonatomic,assign)NSInteger isEditCome;
@property (nonatomic,strong)NSMutableArray * workArray;
@property (nonatomic,assign)NSInteger indexpath;
@property (nonatomic,assign)BOOL isFix;//判断是否是修改界面来的
@property (nonatomic,assign)BOOL listFix;//是否从列表界面来

@property (nonatomic,assign)BOOL isFromPersonInfo;//从个人信息界面过来
@property (nonatomic,assign)BOOL isApplyFromDetail;//从详情中申请
@property (nonatomic,assign)BOOL isAppyFromDetailList;//从详情列表中申请
@end
