//
//  WPRecilistApplyChooseController.m
//  WP
//
//  Created by CBCCBC on 15/11/6.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPRecruitApplyChooseController.h"

#import "WPInterviewController.h"
#import "WPRecruitApplyCell.h"
#import "WPRecruitApplyChooseModel.h"
#import "WPRecruitApplyController.h"
#import "MJRefresh.h"
#import "WPRecruitWebViewController.h"

@interface WPRecruitApplyChooseController () <UITableViewDelegate,UITableViewDataSource,WPInterviewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSMutableArray *dataSource;

@property (assign, nonatomic) NSInteger page;
@property (nonatomic ,strong)WPRecruitApplyChooseModel *model;

@end

@implementation WPRecruitApplyChooseController


// 该页面由 全职 -> 企业招聘 -> 申请职位 -> 填写个人信息页面 点击选择求职简历推出

- (void)viewDidLoad {
    [super viewDidLoad];

    _page = 1;
    self.title = @"求职者";
    
    //[self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"确认"];
    
    [self.view addSubview:self.tableView];
    
    [self setRightBarButtonItem];
    
}

- (void)setRightBarButtonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
}

#warning 需要修改
- (void)rightBarButtonItemAction:(UIButton *)sender
{
    WPRecruitApplyChooseListModel *DetailModel = nil;
    for (WPRecruitApplyChooseListModel *model in self.dataSource) {
        (model.itemIsSelected?(DetailModel = model):0);
    }
    if (DetailModel) {
        [self getDetailMessages:DetailModel];
    }else{
        [SPAlert alertControllerWithTitle:@"提示" message:@"请选择一个公司！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
    }
}



- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        WS(ws);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            [ws.tableView.mj_footer resetNoMoreData];
            
            [ws requestGetApplyCondition:_page Success:^(NSArray *datas, int more) {
                
                _dataSource = [[NSMutableArray alloc]initWithArray:datas];
                
                [ws.tableView reloadData];
            } Error:^(NSError *error) {
            }];
            [ws.tableView.mj_header endRefreshing];
        }];
        
        [self.tableView.mj_header beginRefreshing];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [ws requestGetApplyCondition:_page Success:^(NSArray *datas, int more) {
                if (!more) {
                    [ws.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [ws.dataSource addObjectsFromArray:datas];
                [ws.tableView reloadData];
                
            } Error:^(NSError *error) {
            }];
            [ws.tableView.mj_footer endRefreshing];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)rightButtonAction:(UIButton *)sender{
    
    for (WPRecruitApplyChooseListModel *listModel in self.dataSource) {
        if (listModel.itemIsSelected) {
            [self getDetailMessages:listModel];
            return;
        }
    }
    [SPAlert alertControllerWithTitle:@"提示" message:@"请选择一个简历！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
}

- (void)WPInterviewControllerDelegate{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - NetWorking
- (void)requestGetApplyCondition:(NSInteger)page Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)dealError
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/invitejob.ashx"];
    
    WPShareModel *model = [WPShareModel sharedModel];
    
    NSDictionary *params = @{@"action":@"GetJobResumeList",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"],@"page":[NSString stringWithFormat:@"%d",(int)page]};
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        
        WPRecruitApplyChooseModel *model = [WPRecruitApplyChooseModel mj_objectWithKeyValues:json];
        for (WPRecruitApplyChooseListModel *listModel in model.resumeList) {
            listModel.itemIsSelected = NO;
        }
        success(model.resumeList,(int)model.resumeList.count);
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT(58);
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    WPRecruitApplyCell *cell = [WPRecruitApplyCell cellWithTableView:tableView];
//    cell.model = self.dataSource[indexPath.row];
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(ws);

    WPRecruitApplyCell *cell = [WPRecruitApplyCell tableView:tableView cellForRowAtIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.row];
    
    cell.ChooseCurrentRecruitApplyBlock = ^(NSInteger cellTag){
        [ws ChooseCurrentRecruitApplyAction:cellTag];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WPRecruitWebViewController *WebVC = [[WPRecruitWebViewController alloc]init];
    WebVC.model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:WebVC animated:YES];
    
    //for (int i = 0; i < self.dataSource.count; i++) {
    //WPRecruitApplyChooseListModel *model = self.dataSource[i];
    //i == indexPath.row?(model.itemIsSelected = !model.itemIsSelected):(model.itemIsSelected = NO);
    //}
    
    //[self.tableView reloadData];
    //    [self getDetailMessages:self.dataSource[indexPath.row]];
}



- (void)ChooseCurrentRecruitApplyAction:(NSInteger)cellTag
{
    for (int i = 0; i < self.dataSource.count; i++)
    {
        WPCompanyListModel *model = self.dataSource[i];
        
        (i == cellTag ? (model.itemIsSelected = !model.itemIsSelected) : (model.itemIsSelected = NO));
    }
    
    [self.tableView reloadData];
}



#pragma mark -

- (void)getDetailMessages:(WPRecruitApplyChooseListModel *)listModel{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/invitejob.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetJobResumeInfo",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"],@"resume_id":listModel.resume_id};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        
        WPRecruitApplyChooseDetailModel *detailModel = [WPRecruitApplyChooseDetailModel mj_objectWithKeyValues:json];
        if (![detailModel.status integerValue]) {
            if ([self.delegate respondsToSelector:@selector(reloadDataWithModel:)]) {
                [self.delegate reloadDataWithModel:detailModel];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                WPRecruitApplyController *apply = [[WPRecruitApplyController alloc] init];
                apply.detailModel = detailModel;
                apply.sid = self.sid;
                [self.navigationController pushViewController:apply animated:YES];
                
            }
        }else{
            [MBProgressHUD alertView:@"" Message:@"网络异常，请重试"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

@end
