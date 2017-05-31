//
//  PersonalFriendViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/1/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "PersonalFriendViewController.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "MJRefresh.h"
#import "PersonalFriendModel.h"
#import "PersonalFriendCell.h"
#import "PersonalInfoViewController.h"

@interface PersonalFriendViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *attStates;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;

@end

@implementation PersonalFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    self.dataSource = [NSMutableArray array];
    [self initNav];
//    [self requestData];
    [self.tableView.mj_header beginRefreshing];
}

- (void)initNav
{
    if (self.type == PersonalViewControllerTypeFriend) {
        self.title = @"好友";
    } else if (self.type == PersonalViewControllerTypeAttention) {
        self.title = @"关注";
    } else if (self.type == PersonalViewControllerTypeFans) {
        self.title = @"粉丝";
    }
}

- (void)requestData
{
    NSString *action = [[NSString alloc] init];
    if (self.type == PersonalViewControllerTypeFriend) {
        action = @"Myfriends";
    } else if (self.type == PersonalViewControllerTypeAttention) {
        action = @"MyAttention";
    } else if (self.type == PersonalViewControllerTypeFans) {
        action = @"MyFans";
    }
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = action;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    params[@"friend_id"] = self.friend_id;
//    NSLog(@"*******%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
    } failure:^(NSError *error) {
        
    }];
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = [PersonalFriendCell cellHeight];
        [self.view addSubview:_tableView];
        __weak typeof(self) unself = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableView.mj_footer resetNoMoreData];
            unself.page = 1;
            [unself requireWithPageIndex:self.page Success:^(NSArray *datas, int more) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:datas];
                [_tableView reloadData];
            } Error:^(NSError *error) {
                
            }];
            [_tableView.mj_header endRefreshing];
        }];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            unself.page++;
            [unself requireWithPageIndex:self.page Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.dataSource addObjectsFromArray:datas];
                }
                [self.tableView reloadData];
            } Error:^(NSError *error) {
                self.page--;
            }];
            [_tableView.mj_footer endRefreshing];
        }];
        
    }
    
    return _tableView;
}

- (void)requireWithPageIndex:(NSInteger)page Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
    NSString *action = [[NSString alloc] init];
    if (self.type == PersonalViewControllerTypeFriend) {
        action = @"Myfriends";
    } else if (self.type == PersonalViewControllerTypeAttention) {
        action = @"MyAttention";
    } else if (self.type == PersonalViewControllerTypeFans) {
        action = @"MyFans";
    }
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info_new.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    params[@"action"] = action;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    params[@"friend_id"] = self.friend_id;
    params[@"page"] = [NSString stringWithFormat:@"%ld",(long)page];
//        NSLog(@"*******%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        PersonalFriendModel *model = [PersonalFriendModel mj_objectWithKeyValues:json];
        NSArray *arr = [[NSArray alloc] initWithArray:model.FriendsList];
        success(arr,(int)arr.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
    }];
}


#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *noDataStr = [[NSString alloc] init];
    if (self.type == PersonalViewControllerTypeFriend) {
        noDataStr = @"暂无好友信息";
    } else if (self.type == PersonalViewControllerTypeAttention) {
        noDataStr = @"暂无关注信息";
    } else if (self.type == PersonalViewControllerTypeFans) {
        noDataStr = @"暂无粉丝信息";
    }
    [tableView tableViewDisplayWitMsg:noDataStr ifNecessaryForRowCount:self.dataSource.count];

    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalFriendCell *cell = [PersonalFriendCell cellWithTableView:tableView];
    cell.index = indexPath;
    cell.opertionAttentionBlock = ^(NSIndexPath *index,NSString *title){
        NSLog(@"点击");
        if ([title isEqualToString:@"关注"]) {
            [self attenteUserWith:index];
        } else {
            [SPAlert alertControllerWithTitle:@"提示"
                                      message:@"是否取消关注？"
                              superController:self
                            cancelButtonTitle:@"否" cancelAction:^{
                                
                            }
                           defaultButtonTitle:@"是"
                                defaultAction:^{
                                    [self attenteUserWith:index];
                                }];
        }
        
    };
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)attenteUserWith:(NSIndexPath *)indexPath
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/attention.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    PersonalFriendListModel *attModel = self.dataSource[indexPath.row];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"attentionSigh";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    params[@"by_user_id"] = attModel.by_user_id;
    params[@"by_nick_name"] = attModel.nick_name;
//        NSLog(@"*****%@",url);
//        NSLog(@"#####%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        if (self.friendRefreshBlock) {
            self.friendRefreshBlock();
        }
        NSString *status = json[@"status"];
        attModel.attention_state = status;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
    info.friendID = [self.dataSource[indexPath.row] by_user_id];
    [self.navigationController pushViewController:info animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
