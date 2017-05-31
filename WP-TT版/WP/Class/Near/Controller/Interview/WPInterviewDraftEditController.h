//
//  WPInterviewDraftEditController.h
//  WP
//
//  Created by CBCCBC on 15/12/25.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "WPRecruitApplyChooseModel.h"

typedef NS_ENUM(NSInteger, WPInterviewEditType) {
    WPInterviewEditTypeDraft,
    WPInterviewEditTypeEdit,//修改简历
    WPInterviewEditTypeInfo,
};

@class WPInterviewDraftInfoModel;

@protocol WPInterviewDraftEditControllerDelegate <NSObject>

- (void)reloadView;

@end
@interface WPInterviewDraftEditController : BaseViewController
@property (nonatomic , weak)id<WPInterviewDraftEditControllerDelegate> delegate;
@property (nonatomic , strong)WPRecruitApplyChooseListModel *model;

@property (nonatomic, strong) WPInterviewDraftInfoModel *draftInfoModel;

@property (nonatomic, copy) void (^RefreshDraftListBlock)();
@property (nonatomic, assign) WPInterviewEditType type;
@property (nonatomic, assign)BOOL listFix;
@property (nonatomic, copy) NSString *lightspot;/**< 个人亮点描述*/
//@property (nonatomic, strong)UINavigationController*navigationcontroller;

@end
