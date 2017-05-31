//
//  WPRecruitDraftEditController.h
//  WP
//
//  Created by CBCCBC on 15/12/25.
//  Copyright © 2015年 WP. All rights reserved.
//

// 草稿 编辑界面

#import "BaseViewController.h"
#import "WPCompanyListModel.h"
#import "WPRecruitDraftInfoModel.h"

typedef NS_ENUM(NSInteger, WPRecuitEditType) {
    WPRecuitEditTypeDraft,
    WPRecuitEditTypeEdit,
    WPRecuitEditTypeInfo,
};

@interface WPRecruitDraftEditController : BaseViewController

@property (strong, nonatomic) WPCompanyListModel *model;/**< 数据Model */
@property (strong, nonatomic) WPRecruitDraftInfoModel *Infomodel;/**< 数据Model */
@property (nonatomic, assign) WPRecuitEditType type;
@property (nonatomic, copy) NSString * guid;
@end
