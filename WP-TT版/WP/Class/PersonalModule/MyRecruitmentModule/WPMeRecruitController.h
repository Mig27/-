//
//  WPMeRecruitController.h
//  WP
//
//  Created by CBCCBC on 16/1/5.
//  Copyright © 2016年 WP. All rights reserved.
//  个人--->我的招聘

#import "BaseViewController.h"
#import "BaseModel.h"

@interface WPMeRecruitController : BaseViewController

@end

@interface WPMeRecruitModel : BaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *recruitCount;
@property (nonatomic, copy) NSString *reSignCount;//投递的求职的个数
@property (nonatomic, copy) NSString *jobSignCount;//投递的招聘的个数

@end
