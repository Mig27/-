//
//  WPInterviewWorkListController.h
//  WP
//
//  Created by CBCCBC on 15/12/15.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"

@protocol WPInterviewWorkListDelegate <NSObject>

- (void)getWorkList:(NSArray *)workArray;

@end

@interface WPInterviewWorkListController : BaseViewController

@property (nonatomic ,getter=isBuildNew) BOOL buildNew;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, assign) id <WPInterviewWorkListDelegate> delegate;
@property(nonatomic,assign)NSInteger isworkEdit;
@property (nonatomic,assign)BOOL isFix;
@property (nonatomic,assign)BOOL listFix;

@property (nonatomic,assign)BOOL isFromPersonInfo;//从个人信息界面过来
@property (nonatomic,assign)BOOL isApplyFromDetail;//从详情中申请
@property (nonatomic,assign)BOOL isAppyFromDetailList;//从详情列表中申请
@end
