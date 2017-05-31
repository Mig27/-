//
//  WPMeCompanyListController.m
//  WP
//
//  Created by CBCCBC on 16/1/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMeCompanyListController.h"
#import "WPCompanyEditController.h"

#import "WPCompanysCell.h"
#import "WPCompanyModel.h"
#import "WPCompanyListModel.h"

#import "TYAttributedLabel.h"
#import "MLSelectPhotoAssets.h"
#import "UIImageView+WebCache.h"

#import "MJRefresh.h"

@interface WPMeCompanyListController () <RefreshCompanyInfoDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arr;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation WPMeCompanyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的企业";
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 32, 22);
    button1.titleLabel.font = kFONT(14);
    [button1 setTitle:@"创建" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button1 addTarget:self action:@selector(rightButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem= rightBarItem;
    //    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonItemClick:)];
    //    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak typeof(self) unself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableView.mj_footer resetNoMoreData];
            [unself getCompanyList:^(NSArray *datas, int more) {
                [self.arr removeAllObjects];
                [self.arr addObjectsFromArray:datas];
                [self.tableView reloadData];
                
                UIButton *button = (UIButton *)[self.view viewWithTag:1000];
                button.selected = NO;
                
            } error:^(NSError *error) {
            }];
            [unself.tableView.mj_header endRefreshing];
        }];
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIButton *all = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 120, 49)];
        all.tag = 1000;
        [all normalTitle:@"全选" Color:RGB(0, 0, 0) Font:kFONT(15)];
        [all selectedTitle:@"取消全选" Color:RGB(0, 0, 0)];
        [all setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [all addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:all];
        
        UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50-10, 0, 50, 49)];
        [delete normalTitle:@"删除" Color:RGB(0, 0, 0) Font:kFONT(15)];
        [delete setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [delete addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:delete];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomView addSubview:line];
    }
    return _bottomView;
}

- (void)allAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    for (WPCompanyListDetailModel *model in self.arr) {
        model.itemIsSelected = sender.selected;
    }
    [self.tableView reloadData];
}

- (void)deleteAction{
    NSString *str = [IPADDRESS stringByAppendingFormat:@"/ios/inviteJob.ashx"];
    
    NSString *arr = @"";
    for (WPCompanyListDetailModel *model in self.arr) {
        if (model.itemIsSelected) {
            arr = [NSString stringWithFormat:@"%@%@,",arr,model.epId];
        }
    }
    
    if (![arr isEqualToString:@""]) {
        [SPAlert alertControllerWithTitle:nil message:@"确认删除？" superController:self cancelButtonTitle:@"否" cancelAction:nil defaultButtonTitle:@"是" defaultAction:^{
            NSDictionary *params = @{@"action":@"BatchDeleteCompany",
                                     @"username":kShareModel.username,
                                     @"password":kShareModel.password,
                                     @"user_id":kShareModel.userId,
                                     @"ep_id":[arr substringToIndex:arr.length-1]};
            
            
            [WPHttpTool postWithURL:str params:params success:^(id json) {
                [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
                [self.tableView.mj_header beginRefreshing];
            } failure:^(NSError *error) {
                NSLog(@"%@",error.localizedDescription);
            }];
        }];
    }else{
        [SPAlert alertControllerWithTitle:@"提示" message:@"请选择要删除的公司！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
    }
    
}

- (void)rightButtonItemClick:(UIButton *)sender
{
    WPCompanyEditController *company = [[WPCompanyEditController alloc]init];
    company.delegate = self;
    company.title = @"企业信息";
    company.edit = YES;
    [self.navigationController pushViewController:company animated:YES];
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
//    int height = 136;
    return kHEIGHT(58);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    WPCompanysCell *cell = [WPCompanysCell tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.listModel = self.arr[indexPath.row];
    cell.ChooseCurrentCompanyForResumeBlock = ^(NSInteger cellTag){
        [weakSelf chooseCurrentCompanyForResumeClick:cellTag];
    };
    return cell;
}

- (void)chooseCurrentCompanyForResumeClick:(NSInteger)cellTag{
    //for (int i = 0; i < self.arr.count; i++) {
        //WPCompanyListModel *model = self.arr[i];
        //(i == cellTag?(model.itemIsSelected = !model.itemIsSelected):(model.itemIsSelected = NO));
    //}
    //[self.tableView reloadData];
    
    for (int i = 0; i < self.arr.count; i++) {
        WPCompanyListDetailModel *model = self.arr[i];
        (i == cellTag?(model.itemIsSelected = !model.itemIsSelected):0);
        
    }
    [self.tableView reloadData];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:1000];
    button.selected = [self judgeAllIsSelected];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WPCompanyListDetailModel *model = self.arr[indexPath.row];
    WPCompanyEditController *company = [[WPCompanyEditController alloc]init];
    company.delegate = self;
    company.title = @"企业信息";
    
    WS(ws);
    
    [self requestCompanyInfo:model success:^(WPCompanyListModel *listModel) {
        company.listModel = listModel;
        [ws.navigationController pushViewController:company animated:YES];
        
    }];
}

- (void)getCompanyList:(DealsSuccessBlock)success error:(DealsErrorBlock)dalError{
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetMyCompany",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.dic[@"userid"]};
    //[MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        
        WPCompanyModel *model = [WPCompanyModel mj_objectWithKeyValues:json];
        for (WPCompanyListDetailModel *listModel in model.companyList) {
            listModel.itemIsSelected = NO;
        }
        success(model.companyList,0);
    } failure:^(NSError *error) {
        dalError(error);
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)requestCompanyInfo:(WPCompanyListDetailModel *)detailModel success:(void (^)(WPCompanyListModel *listModel))success{
    
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    NSDictionary *params = @{@"action":@"GetCompanyInfo",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"ep_id":detailModel.epId};
    //[MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        WPCompanyListModel *listModel = [WPCompanyListModel mj_objectWithKeyValues:json];
        
        success(listModel);
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)RefreshCompanyInfo{
    [self.tableView.mj_header beginRefreshing];
}

- (BOOL)judgeAllIsSelected{
    for (WPCompanyListDetailModel *model in self.arr) {
        if (!model.itemIsSelected) {
            return NO;
        }
    }
    return YES;
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
