//
//  WPRecruitDraftController.m
//  WP
//
//  Created by CBCCBC on 15/12/9.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPRecruitDraftController.h"
#import "WPCompanyController.h"
#import "WPCompanysCell.h"
#import "WPCompanyModel.h"
#import "WPCompanyListModel.h"
#import "WPRecruitDraftInfoModel.h"
#import "WPRecruitDraftEditController.h"
#import "MJRefresh.h"

@interface WPRecruitDraftController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arr;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation WPRecruitDraftController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"草稿";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(235, 235, 235);
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
            arr = [NSString stringWithFormat:@"%@%@,",arr,model.jobId];
        }
    }
    
    if (![arr isEqualToString:@""]) {
        NSDictionary *params = @{@"action":@"BatchDeleteJobDraft",
                                 @"username":kShareModel.username,
                                 @"password":kShareModel.password,
                                 @"user_id":kShareModel.userId,
                                 @"jobList":[arr substringToIndex:arr.length-1]};
        [WPHttpTool postWithURL:str params:params success:^(id json) {
            [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
            [self.tableView.mj_header beginRefreshing];
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }else{
        [SPAlert alertControllerWithTitle:@"提示" message:@"请选择要删除的草稿！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
    }
    
}

//- (void)rightButtonItemClick:(UIButton *)sender
//{
//    WPCompanyListDetailModel *listModel = nil;
//    for (WPCompanyListDetailModel *model in self.arr) {
//        (model.itemIsSelected?(listModel = model):0);
//    }
//    if (listModel) {
//        if (self.delegate) {
//            WS(ws);
//            [self requestCompanyInfo:listModel success:^(WPCompanyListModel *listModel) {
//                [ws.delegate getDraftInfo:listModel];
//                [ws.navigationController popViewControllerAnimated:YES];
//            }];
//        }else{
//            [SPAlert alertControllerWithTitle:@"提示" message:@"请选择一个草稿！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
//        }
//    }
//}

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
    int height = 58;
    return kHEIGHT(height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    WPCompanysCell *cell = [WPCompanysCell tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.listModel = self.arr[indexPath.row];
    cell.ChooseCurrentCompanyForResumeBlock = ^(NSInteger cellTag){
        [weakSelf chooseCurrentDraftClick:cellTag];
    };
    cell.imageV.hidden = NO;
    cell.editLabel.hidden = NO;
    return cell;
}

- (void)chooseCurrentDraftClick:(NSInteger)cellTag{
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

    WPCompanyListDetailModel *detailModel = self.arr[indexPath.row];
    WS(ws);
    [self requestCompanyInfo:detailModel success:^(WPRecruitDraftInfoModel *model) {
        //if (self.delegate) {
            //[ws.delegate getDraftInfo:model];
            //[ws.navigationController popViewControllerAnimated:YES];
        //}
        WPRecruitDraftEditController *edit = [[WPRecruitDraftEditController alloc]init];
        edit.Infomodel = model;
        [ws.navigationController pushViewController:edit animated:YES];
    }];
    
//    WPCompanyListDetailModel *model = self.arr[indexPath.row];
//    WPCompanyEditController *company = [[WPCompanyEditController alloc]init];
//    company.delegate = self;
//    company.title = @"企业信息";
//    
//    WS(ws);
//    
//    [self requestCompanyInfo:model success:^(WPCompanyListModel *listModel) {
//        
//        company.listModel = listModel;
//        
//        [ws.navigationController pushViewController:company animated:YES];
//        
//    }];
}

- (void)getCompanyList:(DealsSuccessBlock)success error:(DealsErrorBlock)dalError{
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetJobDraftList",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.dic[@"userid"]};
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        WPCompanyModel *model = [WPCompanyModel mj_objectWithKeyValues:json];
        for (WPCompanyListDetailModel *listModel in model.companyList) {
            listModel.itemIsSelected = NO;
        }
        success(model.draftList,0);
    } failure:^(NSError *error) {
        dalError(error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)requestCompanyInfo:(WPCompanyListDetailModel *)detailModel success:(RecruitDraftSuccessBlock)success{
    
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    NSDictionary *params = @{@"action":@"GetJobDraftInfo",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"job_id":detailModel.jobId};
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        WPRecruitDraftInfoModel *model = [WPRecruitDraftInfoModel mj_objectWithKeyValues:json];
        success(model);
    
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

@end
