//
//  WPConcealController.m
//  WP
//
//  Created by CBCCBC on 16/3/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPConcealController.h"
#import "WPSetCell.h"
#import "WPFriendSettingController.h"
#import "WPWorkWorldController.h"
#import "WPBlackListController.h"
#import "WPPersonalSetBlackListController.h"

#define kHeightForHeaders 15
#define kHeightForRows kHEIGHT(43)
#define kConcealCellReuse @"ConcealCellReuse"

@interface WPConcealController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSArray *titleArr;


@end

@implementation WPConcealController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"隐私";
    [self.view addSubview:self.tableView];
    
}



- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArr.count;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeightForHeaders;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightForRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPSetCell *cell = [[WPSetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kConcealCellReuse];
    cell.title = [self.titleArr[indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {// 推出 设置好友验证 页面
        
        WPFriendSettingController *friendVC = [[WPFriendSettingController alloc]init];
        [self.navigationController pushViewController:friendVC animated:YES];
        
    }else if (indexPath.section == 1){// 推出 黑名单 页面
        
        WPPersonalSetBlackListController *blackVC = [[WPPersonalSetBlackListController alloc]init];
        [self.navigationController pushViewController:blackVC animated:YES];
        
    }else{
        
        WPWorkWorldController *WWVC = [[WPWorkWorldController alloc]init];
        if (indexPath.row == 0) {// 推出 工作圈范围 页面
            WWVC.action = @"话题";
        }else if (indexPath.row == 1){// 推出 求职范围 页面
            WWVC.action = @"求职";
        }else if (indexPath.row == 2){// 推出 招聘范围 页面
            WWVC.action = @"招聘";
        }
        [self.navigationController pushViewController:WWVC animated:YES];
        
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = RGB(235, 235, 235);
        self.tableView.showsVerticalScrollIndicator = NO;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSArray *)titleArr
{
    if (!_titleArr) {
        self.titleArr = @[@[@"设置好友验证"],@[@"黑名单"],@[@"话题设置",@"求职设置",@"招聘设置"]];
    }
    return _titleArr;
}

@end
