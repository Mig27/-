//
//  MRCommonViewController.m
//  闵瑞微博
//
//  Created by Asuna on 15/4/21.
//  Copyright (c) 2015年 Asuna. All rights reserved.
//

#import "MRCommonViewController.h"
#import "MRCommonGroup.h"
#import "MRCommonCheckGroup.h"
#import "MRCommonArrowItem.h"
#import "MRCommonCell.h"
#import "WPHttpTool.h"
#import "WPShareModel.h"

@interface MRCommonViewController ()
{
    NSMutableArray* dataSource;
}
@property (nonatomic, strong) NSMutableArray *groups;
@end

@implementation MRCommonViewController

- (NSMutableArray *)groups
{
    if (!_groups) {
        self.groups = [NSMutableArray array];
    }
    return _groups;
}

- (MRCommonGroup *)addGroup
{
    MRCommonGroup *group = [MRCommonGroup group];
    [self.groups addObject:group];
    return group;
}

- (MRCommonCheckGroup *)addCheckGroup
{
    MRCommonCheckGroup *group = [MRCommonCheckGroup group];
    [self.groups addObject:group];
    return group;
}

- (id)groupInSection:(int)section
{
    return self.groups[section];
}

// init 内部默认会调用 initWithNibName
// initWithStyle 内部默认会调用 initWithNibName
- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置tableview属性
    [self setupTable];
}

/**
 *  设置tableview属性
 */
- (void)setupTable
{
    // 1.去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 2.设置每一组头部尾部的高度
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 10;
    
    // 3.设置背景色
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = WPGlobalBgColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //    self.tableView.contentInset : 增加滚动区域(内容)
    if (iOS7) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    //    IWLog(@"viewDidLoad--%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
}

#pragma mark 每一行显示怎样的cell（内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MRCommonCell *cell = [MRCommonCell cellWithTableView:tableView];
    MRCommonGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row]; // 传递cell显示的模型数据
    cell.indexPath = indexPath; // 传递cell所在的行
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MRCommonGroup *group = self.groups[section];
    return group.items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    MRCommonGroup *group = self.groups[section];
    return group.footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MRCommonGroup *group = self.groups[section];
    return group.header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 1.取出这行对应的模型
    MRCommonGroup *group = self.groups[indexPath.section];
    MRCommonItem *item = group.items[indexPath.row];
    
    // 2.判断有没有设置目标控制器
    if (item.destVc) {
        UIViewController *vc = [[item.destVc alloc] init];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 3.判断有没有想要执行的操作(block)
    if (item.operation) {
        item.operation();
    }
}


@end
