//
//  WPInterviewEducationListController.h
//  WP
//
//  Created by CBCCBC on 15/12/15.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"

@protocol WPInterviewEducationListDelegate <NSObject>

-(void)getEducationList:(NSArray *)educationArray;
@end

@interface WPInterviewEducationListController : BaseViewController
@property (nonatomic ,getter=isBuildNew) BOOL BuildNew;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, assign) id <WPInterviewEducationListDelegate> delegate;
@property(nonatomic,assign)NSInteger isEdit;
@property (nonatomic,assign)BOOL isFix;//是否是从修改界面push的
@property (nonatomic,assign)BOOL listFix;//是否是从所有简历列表中选择的

@property (nonatomic,assign)BOOL isFromPersonInfo;//是否从个人信息界面来

@property (nonatomic, assign)BOOL isApplyFromDetail;//从详情中申请
@property (nonatomic,assign)BOOL isAppyFromDetailList;//从详情列表中申请

@end
