//
//  WPCompanyController.m
//  WP
//
//  Created by Kokia on 16/3/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPCompanyController.h"
#import "WPCompanyEditController.h"

#import "WPCompanysCell.h"
#import "WPCompanyModel.h"
#import "WPCompanyListModel.h"

#import "TYAttributedLabel.h"
#import "MLSelectPhotoAssets.h"
#import "UIImageView+WebCache.h"

#import "RequestManager.h"

#import "WPComInfWebViewController.h"

#import "MJRefresh.h"

@interface WPCompanyController () <RefreshCompanyInfoDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arr;
@property (strong, nonatomic) UITableView *tableView;

@end
#pragma mark -- 该页面由 全职 -> 企业招聘 点击创建-> 招聘简历 点击选择企业 推出
@implementation WPCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业信息";
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 50, 22);
    button1.titleLabel.font = kFONT(14);
    button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button1 setTitle:@"确认" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button1 addTarget:self action:@selector(rightButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem= rightBarItem;
    //    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonItemClick:)];
    //    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self.view addSubview:self.tableView];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        self.tableView. showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];//RGB(235, 235, 235)
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        __weak typeof(self) unself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableView.mj_footer resetNoMoreData];
            [unself getCompanyList:^(NSArray *datas, int more) {
                [self.arr removeAllObjects];
                [self.arr addObjectsFromArray:datas];
                [self.tableView reloadData];
            } error:^(NSError *error) {
            }];
            [unself.tableView.mj_header endRefreshing];
        }];
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightButtonItemClick:(UIButton *)sender
{
    WPCompanyListDetailModel *DetailModel = nil;
    for (WPCompanyListDetailModel *model in self.arr) {
        (model.itemIsSelected?(DetailModel = model):0);
    }
    if (DetailModel) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(getCompanyInfo:)]) {
            [self callBackActionWith:DetailModel];
        }else{
            [SPAlert alertControllerWithTitle:@"提示" message:@"请选择一个公司！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
        }
    }
}
// 回调 返回前一个页面
- (void)callBackActionWith:(WPCompanyListDetailModel *)DetailModel
{
    WS(ws);
    [self requestCompanyInfo:DetailModel success:^(WPCompanyListModel *listModel) {
        [ws.delegate getCompanyInfo:listModel];
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}
// 网络请求 获取Model
- (void)requestCompanyInfo:(WPCompanyListDetailModel *)detailModel success:(SPSuccessBlock)success{
    
    RequestManager *manager = [RequestManager shareManager];
    [manager getCompanyInfoWithEpid:detailModel.epId status:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        WPCompanyListModel *listModel = [WPCompanyListModel mj_objectWithKeyValues:json];
        success(listModel);
    }fail:^(NSError *error) {
        
    }];
}

- (NSMutableArray *)arr
{
    if (!_arr) {
        _arr = [[NSMutableArray alloc]init];
    }
    return _arr;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(58);;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    WPCompanysCell *cell = [WPCompanysCell tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.listModel = self.arr[indexPath.row];
    cell.ChooseCurrentCompanyForResumeBlock = ^(NSInteger cellTag){
        [weakSelf chooseCurrentCompanyForResumeClick:cellTag];
    };
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor =RGB(226, 226, 226);
    cell.choiseCompany = YES;
    return cell;
}

- (void)chooseCurrentCompanyForResumeClick:(NSInteger)cellTag{
    for (int i = 0; i < self.arr.count; i++) {
        WPCompanyListModel *model = self.arr[i];
        (i == cellTag?(model.itemIsSelected = !model.itemIsSelected):(model.itemIsSelected = NO));
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WPCompanyListDetailModel *model = self.arr[indexPath.row];
    
    WS(ws);
    WPComInfWebViewController *infoWebVC = [[WPComInfWebViewController alloc]init];
    [self requestCompanyInfo:model success:^(WPCompanyListModel *listModel) {
        infoWebVC.listModel = listModel;
        infoWebVC.isBuild = ws.isBuild;
        [ws.navigationController pushViewController:infoWebVC animated:YES];
    }];
}

- (void)getCompanyList:(DealsSuccessBlock)success error:(DealsErrorBlock)dalError{
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetMyCompany",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.dic[@"userid"]};
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        WPCompanyModel *model = [WPCompanyModel mj_objectWithKeyValues:json];
        for (WPCompanyListDetailModel *listModel in model.companyList) {
            if ([listModel.epId isEqualToString:self.choiseCompanyId]) {
                listModel.itemIsSelected = YES;
            }
            else
            {
                listModel.itemIsSelected = NO;
            }
            
          
        }
        success(model.companyList,0);
    } failure:^(NSError *error) {
        dalError(error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
    
//    RequestManager *manager = [RequestManager shareManager];
//    [manager getMyCompanyWithstatus:^(id json) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        WPCompanyModel *model = [WPCompanyModel mj_objectWithKeyValues:json];
//        for (WPCompanyListDetailModel *listModel in model.companyList) {
//            listModel.itemIsSelected = NO;
//        }
//        success(model.companyList,0);
//    }];
    
}


- (void)RefreshCompanyInfo{
    [self.tableView.mj_header beginRefreshing];
}

@end
