//
//  WPInterviewDraftController.h
//  WP
//
//  Created by CBCCBC on 15/12/9.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "WPInterviewDraftInfoModel.h"

@protocol WPInterviewDraftControllerDelegate <NSObject>

- (void)returnDraftToInterviewController:(WPInterviewDraftInfoModel *)model;

@end

@interface WPInterviewDraftController : BaseViewController

@property (nonatomic, assign) id <WPInterviewDraftControllerDelegate> delegate;

@end
