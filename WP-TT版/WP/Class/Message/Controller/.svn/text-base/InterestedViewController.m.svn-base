//
//  InterestedViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/12/28.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "InterestedViewController.h"
#import "WPHttpTool.h"
#import "WPShareModel.h"
#import "MJRefresh.h"
#import "InterestedModel.h"
#import "InterestedCell.h"

@interface InterestedViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;

@end

@implementation InterestedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    self.page = 1;
    self.dataSource = [NSMutableArray array];
    self.title = @"可能感兴趣";
//    [self requestData];
    [self.tableView.mj_header beginRefreshing];
    
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = [InterestedCell cellHeight];
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
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *longitude = [user objectForKey:@"longitude"];
    NSString *latitude = [user objectForKey:@"latitude"];
//    NSLog(@"===%@****%@",longitude,latitude);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"GetInterest";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    params[@"page"] = [NSString stringWithFormat:@"%ld",(long)page];
    if (longitude == NULL) {
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    } else {
        params[@"longitude"] = longitude;
        params[@"latitude"] = latitude;
    }
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        InterestedModel *model = [InterestedModel mj_objectWithKeyValues:json];
        NSArray *arr = [[NSArray alloc] initWithArray:model.list];
        success(arr,(int)arr.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
    }];
    
}

- (void)requestData
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *longitude = [user objectForKey:@"longitude"];
    NSString *latitude = [user objectForKey:@"latitude"];
    //    NSLog(@"===%@****%@",longitude,latitude);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"GetInterest";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    params[@"page"] = @"0";
    if (longitude == NULL) {
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    } else {
        params[@"longitude"] = longitude;
        params[@"latitude"] = latitude;
    }
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InterestedCell *cell = [InterestedCell cellWithTableView:tableView];
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
        //        [self attenteUserWith:index];
    };
    cell.model = self.dataSource[indexPath.row];
    return cell;
}


- (void)attenteUserWith:(NSIndexPath *)indexPath
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/attention.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    InterestedListModel *attModel = self.dataSource[indexPath.row];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"attentionSigh";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    params[@"by_user_id"] = attModel.user_id;
    params[@"by_nick_name"] = attModel.name;
    //        NSLog(@"*****%@",url);
    //        NSLog(@"#####%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
//        if (self.friendRefreshBlock) {
//            self.friendRefreshBlock();
//        }
        NSString *status = json[@"status"];
        attModel.isatt = status;
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
