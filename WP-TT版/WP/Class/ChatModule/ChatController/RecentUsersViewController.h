//
//  DDRecentUsersViewController.h
//  IOSDuoduo
//
//  Created by 独嘉 on 14-5-26.
//  Copyright (c) 2014年 dujia. All rights reserved.
//  消息 主页面

#import "MTTPullScrollViewController.h"
#import "SessionModule.h"
#import "WPTitleView.h"
@class RecentUserVCModule;
@interface RecentUsersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UISearchBarDelegate,SessionModuelDelegate,UIScrollViewDelegate>

@property(nonatomic,weak)IBOutlet UITableView* tableView;
@property(nonatomic,strong)RecentUserVCModule* module;
@property(nonatomic,strong)UIView* placeholderView;
@property(nonatomic,strong)NSMutableArray *items;
@property (nonatomic, strong)WPTitleView * titleView;
@property (nonatomic, assign)BOOL isLoginAnother;//退出登录其他账号
+ (instancetype)shareInstance;

@end
