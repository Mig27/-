//
//  SetAnonymousController.m
//  WP
//
//  Created by CBCCBC on 16/3/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "SetAnonymousController.h"
#import "WPSetCell.h"
#import "CustomAnonymousController.h"
#import "DefultAnonymousController.h"
#define kSetAnonymousCellReuse @"SetAnonymousCellReuse"

@interface SetAnonymousController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSArray *titleArr;
@end

@implementation SetAnonymousController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"设置匿名信息";
    [self.view addSubview:self.tableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(43);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPSetCell *cell = [tableView dequeueReusableCellWithIdentifier:kSetAnonymousCellReuse forIndexPath:indexPath];
    cell.title = self.titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        DefultAnonymousController *defultVC = [[DefultAnonymousController alloc]init];
        [self.navigationController pushViewController:defultVC animated:YES];
    }else{
        CustomAnonymousController *customVC = [[CustomAnonymousController alloc]init];
        [self.navigationController pushViewController:customVC animated:YES];
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
        [self.tableView registerClass:[WPSetCell class] forCellReuseIdentifier:kSetAnonymousCellReuse];
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
        self.titleArr = @[@"系统推荐",@"自定义"];
    }
    return _titleArr;
}



@end
