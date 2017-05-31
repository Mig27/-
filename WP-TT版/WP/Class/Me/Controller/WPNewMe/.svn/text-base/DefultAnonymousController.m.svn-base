//
//  DefultAnonymousController.m
//  WP
//
//  Created by CBCCBC on 16/3/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "DefultAnonymousController.h"
#import "AnonymousManager.h"
#import "DefultAnonymousCell.h"

#import "WPAnonymousController.h"
#define kDefultAnonymousCellReuse @"DefultAnonymousCellReuse"
@interface DefultAnonymousController ()<UITableViewDataSource,UITableViewDelegate,AnonymousManagerDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *modelArr;
@property (nonatomic ,strong)NSMutableArray *cellArr;
@end

@implementation DefultAnonymousController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统推荐";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [AnonymousManager sharedManager].delegate = self;
    [[AnonymousManager sharedManager]getAnonymityList];
    [self addRightBarButtonItem];
}

- (void)addRightBarButtonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    for (AnonymousModel *model in self.cellArr) {
        if (model.selected) {
            [[AnonymousManager sharedManager]setAnonymousModelWithModel:model];
        }
    }
}

- (void)backToControllerWithStatus:(BOOL)status
{
    if (status) {
        NSArray *arr = self.navigationController.viewControllers;
        self.delegate = arr[2];
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestForData)]) {
            [self.delegate requestForData];
        }
        
        [self.navigationController popToViewController:arr[2] animated:YES];
    }
}

- (void)reloadData
{
    [self.modelArr removeAllObjects];
    [self.cellArr removeAllObjects];
    self.modelArr = [NSMutableArray arrayWithArray:[AnonymousManager sharedManager].anonyList];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(58);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DefultAnonymousCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.model.selected = !cell.model.selected;
    [self justOneCanbeWithModel:cell.model];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DefultAnonymousCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefultAnonymousCellReuse];
    AnonymousModel *model = self.modelArr [indexPath.row];
    cell.model = model;
    [self.cellArr addObject:cell.model];
    return cell;
}

- (void)justOneCanbeWithModel:(AnonymousModel *)model
{
    for (AnonymousModel *anonymousModel in self.modelArr) {
        if (anonymousModel != model) {
            anonymousModel.selected = NO;
        }
    }
    [self.tableView reloadData];
}

- (NSMutableArray *)cellArr
{
    if (!_cellArr) {
        self.cellArr = [NSMutableArray array];
    }
    return _cellArr;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
//        self.tableView.backgroundColor = RGB(235, 235, 235);
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.tableFooterView = [[UIView alloc]init];
        [self.tableView registerClass:[DefultAnonymousCell class] forCellReuseIdentifier:kDefultAnonymousCellReuse];
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

@end
