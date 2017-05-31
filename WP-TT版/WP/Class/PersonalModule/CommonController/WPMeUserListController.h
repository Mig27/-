//
//  WPMeUserListController.h
//  WP
//
//  Created by CBCCBC on 16/3/30.
//  Copyright © 2016年 WP. All rights reserved.
//  我的招聘 --> 我的企业
//  个人求职 --> 我的信息

#import "BaseViewController.h"

@interface WPMeUserListController : BaseViewController
@property (nonatomic, copy)void (^personalInfo)(NSInteger inter);
@property (nonatomic, copy) void (^deleteMyCompany)(NSInteger inter,BOOL creatOrNot);//创建传yes
@end
