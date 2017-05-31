//
//  WPSysNotificationViewController.h
//  WP
//
//  Created by CC on 17/2/3.
//  Copyright © 2017年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "WPNewResumeController.h"

@interface WPSysNotificationViewController : BaseViewController
@property(nonatomic, assign) BOOL isApplyOrNot;//我的求职还是招聘
@property (nonatomic, copy) NSString * jobID;
@property (assign, nonatomic) WPMainPositionType type;
@property (nonatomic, copy)void(^requstSuccess)();
@end
