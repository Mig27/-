//
//  WPInterviewApplyChooseController.m
//  WP
//
//  Created by CBCCBC on 15/11/10.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPInterviewApplyChooseController.h"

#import "WPRecruitApplyCell.h"
#import "WPInterviewApplyChooseModel.h"
#import "WPInterviewApplyChooseDetailModel.h"
#import "WPInterviewApplyController.h"
#import "WPRecruitController.h"
#import "WPInterviewApplyCompanyController.h"
#import "MJRefresh.h"
#import "WPcompanyInfoViewController.h"


@interface WPInterviewApplyChooseController () <UITableViewDelegate,UITableViewDataSource,WPRecuilistControllerDelegate,WPInterviewApplyCompanyDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) NSInteger page;
@property (copy, nonatomic) NSString *epId;
@property (strong, nonatomic)UIButton* rightBtn;
@end

@implementation WPInterviewApplyChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _page = 1;
    _epId = @"";
    if (self.string) {
        self.title = self.string;
    }else{
        self.title = @"企业招聘信息";
    }
    //[self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"确认"];
    [self.view addSubview:self.tableView];
    [self setRightBarButtonItem];
}
-(UIButton*)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0, 0, 45, 45);
//        [_rightBtn setBackgroundColor:[UIColor redColor]];
        [_rightBtn setTitle:@"确认" forState:UIControlStateNormal];
        _rightBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
//        [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kHEIGHT(12))];
        [_rightBtn addTarget:self action:@selector(barButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateSelected];
        _rightBtn.selected = !self.choiseJobId.length;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _rightBtn.userInteractionEnabled =self.choiseJobId.length;
    }
    return  _rightBtn;
}
- (void)setRightBarButtonItem
{
//      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(barButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
}


#pragma mark 点击确认
- (void)barButtonItemAction:(UIBarButtonItem *)sender
{
    WPInterviewApplyListModel *DetailModel = nil;
    for (WPInterviewApplyListModel *model in self.dataSource) {
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
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        self.tableView.backgroundColor = [UIColor lightGrayColor];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, ItemViewHeight)];
        view.backgroundColor = [UIColor whiteColor];
        
       
        
        
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 160, ItemViewHeight)];
//        label.text = @"请选择企业";
//        label.userInteractionEnabled = YES;
//        label.font = kFONT(15);
//        [view addSubview:label];
        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(kHEIGHT(12), 0, 120-kHEIGHT(12), ItemViewHeight);
        [leftBtn setTitle:@"选择企业" forState:UIControlStateNormal];
        leftBtn.titleLabel.font = kFONT(15);
        [leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
        [leftBtn addTarget:self action:@selector(chooseCompanyClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:leftBtn];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(120, 0, SCREEN_WIDTH-120-kHEIGHT(12)-14, ItemViewHeight);
        button.titleLabel.font = kFONT(12);
        button.tag = 200;
        NSString *str = @"默认·全部";
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [button addTarget:self action:@selector(chooseCompanyClick:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
        [view addSubview:button];
        
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(button.right, 0, SCREEN_WIDTH-button.right, ItemViewHeight);
        [button1 addTarget:self action:@selector(chooseCompanyClick:) forControlEvents:UIControlEventTouchUpInside];
        [button1 addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
        [view addSubview:button1];
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"jinru"]];
        imageV.frame = CGRectMake(view.width-kHEIGHT(12)-8, view.height/2-7, 8,14);
        [view addSubview:imageV];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, view.height-0.5, view.width, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [view addSubview:line];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
//        _tableView.tableHeaderView = view;
        
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
//-(void)labelTap:(UITapGestureRecognizer*)sender
//{
//    UILabel * label = (UILabel*)sender.view;
//    label.superview.backgroundColor = RGB(226, 226, 226);
//    
//    WPInterviewApplyCompanyController *company = [[WPInterviewApplyCompanyController alloc]init];
//    company.delegate = self;
//    [self.navigationController pushViewController:company animated:YES];
//    
//}
// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
}
-(void)clickDown:(UIButton*)sender
{
    UIView * view = sender.superview;
    view.backgroundColor = RGB(226, 226, 226);
//    [sender setBackgroundColor:RGB(226, 226, 226)];
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)rightButtonAction:(UIButton *)sender{
//    WPRecruitController *interview = [[WPRecruitController alloc]init];
//    interview.title = @"招聘简历";
//    interview.delegate = self;
//    [self.navigationController pushViewController:interview animated:YES];
    //for (WPInterviewApplyListModel *model in self.dataSource) {
        //if (model.itemIsSelected) {
            //[self getDetailMessages:model];
        //}
    //}
    
}

//TODO: 
- (void)WPRecuilistControllerDelegate{
    
}

- (void)WPInterviewControllerDelegate{
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestGetApplyCondition:(NSInteger)page Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)dealError{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetInviteJobList",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"],@"ep_id":_epId,@"page":[NSString stringWithFormat:@"%d",(int)page]};
//    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:str params:params success:^(id json) {
//        [MBProgressHUD hideHUDForView:self.view];
        WPInterviewApplyChooseModel *model = [WPInterviewApplyChooseModel mj_objectWithKeyValues:json];
        NSArray * array = model.jobList;
        for (WPInterviewApplyListModel*model in array) {
            if ([self.choiseJobId isEqualToString:model.job_id]) {
                model.itemIsSelected = YES;
            }
            else
            {
                model.itemIsSelected = NO;
            }
        }
        
        
        success(model.jobList,(int)model.jobList.count);
    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark  点击  选择企业
- (void)chooseCompanyClick:(UIButton*)sender{
    UIView * view = sender.superview;
    view.backgroundColor = [UIColor whiteColor];
    
    WPInterviewApplyCompanyController *company = [[WPInterviewApplyCompanyController alloc]init];
    company.isFromMyRob = self.isFromMyRob;
    company.delegate = self;
    company.isFix = self.isFix;
    company.personalApply = self.personalApply;
    company.personalApplyList = self.personalApplyList;
    
    company.isFromMyRobList = self.isFromMyRobList;
    
    company.isFromDetail = self.isFromDetail;
    company.isFRromCollection = self.isFromCollection;
    company.isFRromMuchCollection = self.isFromMuchCollection;
    
    
    company.choiseCell = _epId.length?_epId:@"";
    company.title = @"我的企业";
    [self.navigationController pushViewController:company animated:YES];
}
#pragma mark 选择我的企业的代理回调
- (void)getInterviewApplyCompanyInfo:(NSString *)epId andIsall:(BOOL)isAll{
//    self.choiseJobId = @"";
    
    _epId = epId;
    NSString * str = epId;
    NSArray * array = [NSArray array];
    if (str.length)
    {
        array = [str componentsSeparatedByString:@","];
    }
    
    UIButton *button = [self.tableView.tableHeaderView viewWithTag:200];
    [button setTitle:(isAll?@"全选":[NSString stringWithFormat:@"已选择%lu个企业",(unsigned long)array.count]) forState:UIControlStateNormal];//([epId isEqualToString:@""]?@"全部":@"")
    [self.tableView.mj_header beginRefreshing];
    _rightBtn.selected = YES;
    _rightBtn.userInteractionEnabled = NO;
}

#pragma mark  从查看企业中返回的代理
- (void)getCompanyInfo:(WPCompanyListModel *)model{
    _epId = model.epId;
    UIButton *button = [self.view viewWithTag:200];
    [button setTitle:[NSString stringWithFormat:@"已选择1个企业"] forState:UIControlStateNormal];
    [self.tableView.mj_header beginRefreshing];
}



#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT(58);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    WPRecruitApplyCell *cell = [WPRecruitApplyCell cellWithTableView:tableView];
//    cell.model = self.dataSource[indexPath.row];
    WPRecruitApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WPRecruitApplyCell"];
    if (!cell) {
        cell = [[WPRecruitApplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WPRecruitApplyCell"];
    }
    __weak typeof(self) weakSelf = self;
//    WPRecruitApplyCell *cell = [WPRecruitApplyCell tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.model = weakSelf.dataSource[indexPath.row];
    cell.tag = indexPath.row;
    cell.ChooseCurrentRecruitApplyBlock = ^(NSInteger cellTag){
        [weakSelf ChooseCurrentRecruitApplyBlock:cellTag];
    };

    return cell;
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    __weak typeof(self) weakSelf = self;
//    WPCompanysCell *cell = [WPCompanysCell tableView:tableView cellForRowAtIndexPath:indexPath];
//    cell.listModel = self.arr[indexPath.row];
//    cell.ChooseCurrentCompanyForResumeBlock = ^(NSInteger cellTag){
//        [weakSelf chooseCurrentCompanyForResumeClick:cellTag];
//    };
//    return cell;
//}
//
- (void)ChooseCurrentRecruitApplyBlock:(NSInteger)cellTag{
    for (int i = 0; i < self.dataSource.count; i++) {
        WPInterviewApplyListModel *model = self.dataSource[i];
        (i == cellTag)?(model.itemIsSelected = !model.itemIsSelected):(model.itemIsSelected = NO);
    }
    
    WPInterviewApplyListModel *model = self.dataSource[cellTag];
    _rightBtn.selected = !model.itemIsSelected;
    _rightBtn.userInteractionEnabled = model.itemIsSelected;
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetInviteJobInfo",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"],@"job_id":[self.dataSource[indexPath.row] job_id]};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPInterviewApplyChooseDetailModel *detailModel = [WPInterviewApplyChooseDetailModel mj_objectWithKeyValues:json];
        WPcompanyInfoViewController * company = [[WPcompanyInfoViewController alloc]init];
        //判断从哪里选择了抢人 
        company.isFromList = self.isFromList;
        company.isFromDetail = self.personIsFromDetail;
        company.isFromDetailList = self.personDetailList;
        company.personalApply = self.personalApply;
        company.personalApplyList = self.personalApplyList;
        company.isFromMyRob = self.isFromMyRob;
        company.isFromMyRobList = self.isFromMyRobList;
        company.isFromCollection = self.isFromCollection;
        company.isFromMuchCollection = self.isFromMuchCollection;
        
        company.title = @"企业招聘";
        company.infoModel = detailModel;
        company.subId = [self.dataSource[indexPath.row] ep_id];
        //    company.isRecuilist = 3;
        NSString * urlstring = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@&isVisible=1",IPADDRESS,[self.dataSource[indexPath.row] job_id],kShareModel.userId];
        company.urlStr = urlstring;
        [self.navigationController pushViewController:company animated:YES];
    } failure:^(NSError *error) {
        
    }];
    
    
//    WPcompanyInfoViewController * company = [[WPcompanyInfoViewController alloc]init];
//    company.title = @"企业招聘";
//    company.subId = [self.dataSource[indexPath.row] ep_id];
////    company.isRecuilist = 3;
//    NSString * urlstring = [NSString stringWithFormat:@"http://192.168.1.160/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@&isVisible=1",[self.dataSource[indexPath.row] job_id],kShareModel.userId];
//    company.urlStr = urlstring;
//    [self.navigationController pushViewController:company animated:YES];
}
#pragma mark  点击时获取招聘信息
- (void)getDetailMessages:(WPInterviewApplyListModel *)listModel{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetInviteJobInfo",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"],@"job_id":listModel.job_id};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPInterviewApplyChooseDetailModel *detailModel = [WPInterviewApplyChooseDetailModel mj_objectWithKeyValues:json];
        
        if (![detailModel.status integerValue]) {
            if ([self.delegate respondsToSelector:@selector(controller:Model:)]) {
                [self.delegate controller:self Model:detailModel];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [MBProgressHUD alertView:@"" Message:@"网络异常，请重试"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
@end
