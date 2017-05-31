//
//  WPRecilistApplyChooseController.h
//  WP
//
//  Created by CBCCBC on 15/11/6.
//  Copyright © 2015年 WP. All rights reserved.
//

// 选择求职者 界面

#import "WPRecruitApplyChooseDetailModel.h"

@protocol WPRecruitApplyChooseUserDelegate;
@protocol WPRecruitApplyChooseUserDelegate <NSObject>

//- (void)controller:(WPRecruitApplyChooseController *)controller Model:(WPRecruitApplyChooseDetailModel *)model;

- (void)reloadDataWithModel:(WPRecruitApplyChooseDetailModel *)model;

@end

@interface WPRecruitApplyChooseController : BaseViewController

@property (nonatomic, strong)NSString *subController;

@property (copy, nonatomic) NSString *sid;

@property (assign ,nonatomic) id <WPRecruitApplyChooseUserDelegate>delegate;

@end

