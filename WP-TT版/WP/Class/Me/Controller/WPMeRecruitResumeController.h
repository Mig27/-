//
//  WPMeRecruitResumeController.h
//  WP
//
//  Created by CBCCBC on 16/1/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,WPMeRecruitResumeType) {
    WPMeRecruitResumeTypeRecruit = 0,
    WPMeRecruitResumeTypeInterview,
};

@interface WPMeRecruitResumeController : BaseViewController

@property (assign, nonatomic) WPMeRecruitResumeType type;

@end
