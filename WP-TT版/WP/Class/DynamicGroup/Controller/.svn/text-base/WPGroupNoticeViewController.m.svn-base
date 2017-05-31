//
//  WPGroupNoticeViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/4/20.
//  Copyright © 2016年 WP. All rights reserved.
//  群公告

#import "WPGroupNoticeViewController.h"
#import "GroupNoticeModel.h"
#import "GroupNoticeCell.h"
#import "WPNoticeDetailViewController.h"
#import "WPCreateGroupNoticeViewController.h"
#import "RKAlertView.h"
#import "MTTDatabaseUtil.h"
@interface WPGroupNoticeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign) NSUInteger page;        //分页

@end

@implementation WPGroupNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[MTTDatabaseUtil instance] getGroupGongGao:self.model.group_id success:^(NSArray *array) {
        if (array.count) {
            NSDictionary * dic = @{@"list":array};
            GroupNoticeModel *model = [GroupNoticeModel mj_objectWithKeyValues:dic];
            NSArray *arr = [[NSArray alloc] initWithArray:model.list];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
    }];
    
    
    
    [self initNav];
    self.page = 1;
    [self.tableView.mj_header beginRefreshing];
//    [self requsetData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo:) name:@"noticeUpdate" object:nil];
}

- (void)initNav
{
    self.view.backgroundColor = BackGroundColor;
    self.title = @"群公告";
    if ([self.gtype isEqualToString:@"1"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    }

}

- (void)updateInfo:(NSNotification *)notification
{
    NSIndexPath *index = notification.userInfo[@"index"];
    GroupNoticeListModel *noticeModel = self.dataSource[index.row];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_notice.ashx"];
    NSDictionary *params = @{@"action" : @"GetNotice",
                             @"id" : noticeModel.notice_id,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"user_id" : kShareModel.userId};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        GroupNoticeModel *model = [GroupNoticeModel mj_objectWithKeyValues:json];
        
        
        [self.dataSource removeObjectAtIndex:index.row];
        [self.dataSource insertObject:model.list[0] atIndex:0];
//        [self.dataSource replaceObjectAtIndex:index.row withObject:model.list[0]];
        
        
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noticeUpdate" object:nil];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)requsetData
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_notice.ashx"];
    NSDictionary *params = @{@"action" : @"NoticeList",
                             @"group_id" : self.model.group_id,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"user_id" : kShareModel.userId,
                             @"page" : @"1"};
    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        GroupNoticeModel *model = [GroupNoticeModel mj_objectWithKeyValues:json];
        [self.dataSource addObjectsFromArray:model.list];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - create new notice
- (void)rightBtnClick
{
    WPCreateGroupNoticeViewController *create = [[WPCreateGroupNoticeViewController alloc] init];
    create.infoModel = self.model;
    create.mouble = self.mouble;
    create.isEditing = NO;
    create.groupId = self.groupId;
    create.createSuccessBlock = ^(){
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
    };
    [self.navigationController pushViewController:create animated:YES];
    
}

- (void)delay
{
    _page = 1;
    [self requestWithPageIndex:_page Success:^(NSArray *datas, int more) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:datas];
        [_tableView reloadData];
    } Error:^(NSError *error) {
        
    }];
}

#pragma mark tableView
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BackGroundColor;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_topLayoutGuide);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        __weak typeof(self) unself = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableView.mj_footer resetNoMoreData];
            _page = 1;
            [unself requestWithPageIndex:_page Success:^(NSArray *datas, int more) {
                
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:datas];
                [_tableView reloadData];
            } Error:^(NSError *error) {
                
            }];
            [_tableView.mj_header endRefreshing];
        }];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [unself requestWithPageIndex:_page Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.dataSource addObjectsFromArray:datas];
                }
                [unself.tableView reloadData];
            } Error:^(NSError *error) {
                _page--;
            }];
            [_tableView.mj_footer endRefreshing];
        }];
    }
    
    return _tableView;
}


#pragma mark - 封装网络请求
- (void)requestWithPageIndex:(NSInteger)page Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_notice.ashx"];
    NSDictionary *params = @{@"action" : @"NoticeList",
                             @"group_id" : self.model.group_id,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"user_id" : kShareModel.userId,
                             @"page" : @(page)};
    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        GroupNoticeModel *model = [GroupNoticeModel mj_objectWithKeyValues:json];
        NSArray *arr = [[NSArray alloc] initWithArray:model.list];
        success(arr,(int)arr.count);
        if (page == 1 && arr.count) {
            [[MTTDatabaseUtil instance] deleteGroupGongGao:self.model.group_id];
            [[MTTDatabaseUtil instance] upDataGroupGongGao:json[@"list"]];
        }
        
        
    } failure:^(NSError *error) {
        //NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
        [MBProgressHUD createHUD:@"网络错误,请稍后重试" View:self.view];
        if (page == 1) {
            [[MTTDatabaseUtil instance] getGroupGongGao:self.model.group_id success:^(NSArray *array) {
                if (array.count) {
                    NSDictionary * dic = @{@"list":array};
                    GroupNoticeModel *model = [GroupNoticeModel mj_objectWithKeyValues:dic];
                    NSArray *arr = [[NSArray alloc] initWithArray:model.list];
                    success(arr,(int)arr.count);
                }
            }];
        }
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupNoticeCell *cell = [GroupNoticeCell cellWithTableView:tableView];
    cell.isDetail = NO;
    if ([self.gtype isEqualToString:@"1"]) {
        cell.isOwner = YES;
    } else {
        cell.isOwner = NO;
    }
    cell.index = indexPath;
    cell.deleteBlock = ^(NSIndexPath *index){
        [RKAlertView showAlertWithTitle:@"提示" message:@"你确定要删除该条公告吗？" cancelTitle:@"取消" confirmTitle:@"确定" confrimBlock:^(UIAlertView *alertView) {
            [self deleteWithIndex:index];
        } cancelBlock:^{
            
        }];
    };
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupNoticeCell *cell = [GroupNoticeCell cellWithTableView:tableView];
    CGFloat height = [cell calculateHeightWithInfo:self.dataSource[indexPath.row] isDetail:NO];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPNoticeDetailViewController *detail = [[WPNoticeDetailViewController alloc] init];
    detail.model = self.dataSource[indexPath.row];
    detail.gtype = self.gtype;
    detail.groupID = self.groupId;
    detail.infoModel = self.model;
    detail.clickIndex = indexPath;
    detail.changeNotice = ^(NSIndexPath*index){
    };
    detail.deletActionBlock = ^(NSIndexPath *index){
        [self.dataSource removeObjectAtIndex:index.row];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)deleteWithIndex:(NSIndexPath *)indexPath
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_notice.ashx"];
    GroupNoticeListModel *noticeModel = self.dataSource[indexPath.row];
    NSDictionary *params = @{@"action" : @"DelNotice",
                             @"id" : noticeModel.notice_id,
                             @"group_id" : self.model.group_id,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"user_id" : kShareModel.userId};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"status"] integerValue] == 0) {
            [MBProgressHUD createHUD:@"删除公告成功!" View:self.view];
            [self.dataSource removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            
            //数据库中删除
            [[MTTDatabaseUtil instance] deleteGroupGongGao:self.model.group_id gong:noticeModel.notice_id];
            
        }
    } failure:^(NSError *error) {
        
    }];
    
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
