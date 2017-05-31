//
//  RelevanceGroupController.m
//  WP
//
//  Created by 沈亮亮 on 15/10/21.
//  Copyright © 2015年 WP. All rights reserved.
//  关联群组

#import "RelevanceGroupController.h"
#import "WPHttpTool.h"
#import "WPShareModel.h"
#import "RelevanceGroupModel.h"
#import "MJRefresh.h"
#import "RelevanceGroupCell.h"

@interface RelevanceGroupController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView;


@end

@implementation RelevanceGroupController
{
    NSInteger _page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    [self initUI];
    self.dataSource = [NSMutableArray array];
    [self reloadData];
}

- (void)initUI
{
    self.title = @"关联群组";
    self.view.backgroundColor = RGB(235, 235, 235);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    
//    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds]; // Here is where the magic happens
//    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = [RelevanceGroupCell height];
    __weak typeof(self) unself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [unself.tableView.mj_footer resetNoMoreData];
        _page = 1;
        [unself reloadData];
//        [_tableView.mj_header endRefreshing];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [unself reloadData];
//        [_tableView.mj_footer endRefreshing];
    }];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]){
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //    [_tableView setEditing:YES animated:YES]; //打开UItableView 的编辑模式
    //    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:_tableView];
    [_tableView reloadData];

}

- (void)rightBtnClick
{
    
}

- (void)reloadData
{
    if (_page == 1) {
        [_dataSource removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
//    NSLog(@"*****%@",url);
    //    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page1];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"MyGroup";
    params[@"page"] = [NSString stringWithFormat:@"%ld",(long)_page];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"userID"] = userInfo[@"userid"];
    params[@"isSys"] = @"1";
    NSLog(@"*****%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        RelevanceGroupModel *model = [RelevanceGroupModel mj_objectWithKeyValues:json];
        NSArray *arr = [[NSArray alloc] initWithArray:model.list];
        [_dataSource addObjectsFromArray:arr];
        [_tableView reloadData];
//        NSLog(@"***%@",_dataSource);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (arr.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
        _page--;
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RelevanceGroupCell *cell = [RelevanceGroupCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RelevanceGroupListModel *model = _dataSource[indexPath.row];
    if (self.selectBlock) {
        self.selectBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
