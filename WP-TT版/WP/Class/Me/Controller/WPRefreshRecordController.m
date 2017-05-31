//
//  WPRefreshRecordController.m
//  WP
//
//  Created by CBCCBC on 16/4/1.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPRefreshRecordController.h"
#import "WPRefreshManager.h"
#import "WPSetRefreshModel.h"
#import "WPRefreshCell.h"

#define kRefreshRecordCellReuse @"RefreshRecordCellReuse"
@interface WPRefreshRecordController ()<UITableViewDelegate,UITableViewDataSource,WPRefreshManagerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation WPRefreshRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"刷新纪录";
    [self requestForDataList];
    [self.view addSubview:self.tableView];
    [self addRightBarButtonItem];
}

- (void)addRightBarButtonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认清空刷新记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        WPRefreshManager *manager = [WPRefreshManager sharedManager];
        manager.delegate = self;
        [manager requestForClearReFreshList];
    }
}

- (void)cleanAction
{
    [self requestForDataList];
}

- (void)requestForDataList
{
    WPRefreshManager *manager = [WPRefreshManager sharedManager];
    manager.delegate = self;
    [manager requestForRefreshList];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [WPRefreshManager sharedManager].modelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(43);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPRefreshCell *cell = [[WPRefreshCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRefreshRecordCellReuse];
    WPSetRefreshModel *model = [WPRefreshManager sharedManager].modelArr[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = RGB(235, 235, 235);
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


@end
