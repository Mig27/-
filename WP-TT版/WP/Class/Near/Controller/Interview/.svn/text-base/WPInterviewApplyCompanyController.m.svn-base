//
//  WPInterviewApplyCompanyController.m
//  WP
//
//  Created by CBCCBC on 15/12/10.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPInterviewApplyCompanyController.h"
#import "WPCompanyEditController.h"

#import "WPCompanysCell.h"
#import "WPCompanyModel.h"
#import "WPCompanyListModel.h"

#import "WPResumeListManager.h"
#import "WPComInfWebViewController.h"
#import "MJRefresh.h"

@interface WPInterviewApplyCompanyController () <RefreshCompanyInfoDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arr;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic ,strong) WPResumeListManager *manager;
@property (nonatomic, strong) UILabel *makeView;
@property (nonatomic, strong) UIButton *doneBtn;


@end

@implementation WPInterviewApplyCompanyController
#pragma mark -- 全职 点击面试->面试 点击cell->求职简历 点击抢人->填写企业信息 点击选择招聘信息->选择报名简历 点击选择企业
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestForData];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self initNavc];

}
-(void)initNavc
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.doneBtn];
}
- (UILabel *)makeView{
    if (!_makeView) {
        _makeView = [[UILabel alloc] init];
        _makeView.textColor = [UIColor whiteColor];
        _makeView.textAlignment = NSTextAlignmentCenter;
        _makeView.font = [UIFont systemFontOfSize:13];
        _makeView.frame = CGRectMake(-20, 12, 20, 20);
        _makeView.hidden = self.choiseCell.length?NO:YES;
        if (self.choiseCell.length) {
            NSArray * array = [self.choiseCell componentsSeparatedByString:@","];
            _makeView.text = [NSString stringWithFormat:@"%lu",(unsigned long)array.count];
        }
        _makeView.layer.cornerRadius = _makeView.frame.size.height / 2.0;
        _makeView.clipsToBounds = YES;
        //        makeView.backgroundColor = [UIColor redColor];
        //        makeView.backgroundColor = RGB(10, 110, 210);
        _makeView.backgroundColor = RGB(0, 172, 255);
        
        
        [_makeView.layer removeAllAnimations];
        CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaoleAnimation.duration = 0.25;
        scaoleAnimation.autoreverses = YES;
        scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
        scaoleAnimation.fillMode = kCAFillModeForwards;
        [_makeView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
        
    }
    else
    {
        [_makeView.layer removeAllAnimations];
        CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaoleAnimation.duration = 0.25;
        scaoleAnimation.autoreverses = YES;
        scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
        scaoleAnimation.fillMode = kCAFillModeForwards;
        [_makeView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    }
    return _makeView;
}
- (UIButton *)doneBtn{
    if (!_doneBtn) {
        _doneBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        //        [rightBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:91/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
      
//        _doneBtn.selected = YES;
    
        _doneBtn.userInteractionEnabled = self.choiseCell.length?YES:NO;
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _doneBtn.frame = CGRectMake(0, 0, 45, 45);
        [_doneBtn setTitle:@"确认" forState:UIControlStateNormal];
        _doneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        [_doneBtn setBackgroundColor:[UIColor redColor]];
        [_doneBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        [_doneBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateSelected];
        _doneBtn.selected = self.choiseCell.length?YES:NO;
//        [_doneBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateHighlighted];
        [_doneBtn addTarget:self action:@selector(clickRightDown:) forControlEvents:UIControlEventTouchDown];
        [_doneBtn addTarget:self action:@selector(completeActions:) forControlEvents:UIControlEventTouchUpInside];
        [_doneBtn addSubview:self.makeView];
//        self.doneBtn = rightBtn;
    }
    return _doneBtn;
}
-(void)clickRightDown:(UIButton*)sender
{
    [sender setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
    
}

- (void)requestForData
{
    if ([self.title isEqualToString:@"我的求职"]) {
        self.manager = [WPResumeListManager sharedManager];
        
        self.manager.resumeUserIds = nil;
//        [self.manager requestForResumeList];
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak typeof(self) unself = self;
        if (![self.title isEqualToString:@"我的求职"]) {
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
    }
    return _tableView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIButton *chooseAllBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 120, 49)];
//        chooseAllBtn.tag = 1000;
        [chooseAllBtn normalTitle:@"全选" Color:RGB(0, 0, 0) Font:kFONT(14)];
        [chooseAllBtn selectedTitle:@"取消全选" Color:RGB(0,0,0)];
        [chooseAllBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [chooseAllBtn addTarget:self action:@selector(chooseAllActions:) forControlEvents:UIControlEventTouchUpInside];
//        [_bottomView addSubview:chooseAllBtn];
        
        UIButton *comleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(12)-120, 0, 120, 49)];
        comleteBtn.tag = 1000;
        [comleteBtn normalTitle:@"全选" Color:RGB(0, 0, 0) Font:kFONT(14)];
        [comleteBtn selectedTitle:@"取消全选" Color:RGB(0,0,0)];
        [comleteBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [comleteBtn addTarget:self action:@selector(chooseAllActions:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray * array = [self.choiseCell componentsSeparatedByString:@","];
        comleteBtn.selected = (array.count == self.arr.count)?YES:NO;
        
        [_bottomView addSubview:comleteBtn];
    }
    
    return _bottomView;
}
#pragma mark 点击全选
- (void)chooseAllActions:(UIButton *)sender{
    sender.selected = !sender.selected;
    for (WPCompanyListModel *model in self.arr) {
        model.itemIsSelected = sender.selected;
    }
    [self.tableView reloadData];
    
    self.doneBtn.selected = sender.selected;
    self.doneBtn.userInteractionEnabled = sender.selected;
    
    if (sender.selected) {
        self.makeView.hidden = NO;
        self.makeView.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.arr.count];
    }
    else
    {
      self.makeView.text = @"";
      self.makeView.hidden = YES;
    }
}
#pragma mark 点击确认
- (void)completeActions:(UIButton *)sender{
    [sender setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    if ([self.title isEqualToString:@"我的求职"]) {
        
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(getInterviewApplyCompanyInfo:andIsall:)]) {
            NSString *str = @"";
            int numOfChoise = 0;
            for (WPCompanyListModel *model in self.arr) {
                if (model.itemIsSelected) {
                    numOfChoise++;
//                    str = [NSString stringWithFormat:@"%@,%@",str,model.epId];
                    str = str.length?[NSString stringWithFormat:@"%@%@,",str,model.epId]:[NSString stringWithFormat:@"%@,",model.epId];
                }
            }
            if (str) {
                
                
                
                
                [self.delegate getInterviewApplyCompanyInfo:[str substringToIndex:str.length-1] andIsall:(numOfChoise == self.arr.count)];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SPAlert alertControllerWithTitle:@"提示" message:@"请选择一个企业!" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
            }
        }
    }
}

//- (void)rightButtonItemClick:(UIButton *)sender
//{
//    if ([self.title isEqualToString:@"我的求职"]) {
//        
//        return;
//    }
//    WPCompanyListDetailModel *listModel = nil;
//    for (WPCompanyListDetailModel *model in self.arr) {
//        (model.itemIsSelected?(listModel = model):0);
//    }
//    if (listModel) {
//        if (self.delegate) {
//            WS(ws);
//            [self requestCompanyInfo:listModel success:^(WPCompanyListModel *listModel) {
//                [ws.delegate getInterviewApplyCompanyInfo:listModel.epId andIsall:NO];
//                [ws.navigationController popViewControllerAnimated:YES];
//            }];
//        }else{
//            [SPAlert alertControllerWithTitle:@"提示" message:@"请选择一个公司！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
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
    
    for (int i = 0; i < self.arr.count; i++) {
        WPCompanyListModel *model = self.arr[i];
        (i == cellTag?(model.itemIsSelected = !model.itemIsSelected):0);
    }
    [self.tableView reloadData];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:1000];
    button.selected = [self judgeAllIsSelected];
    
    self.doneBtn.selected = [self isThereSelected];
    self.doneBtn.userInteractionEnabled = [self isThereSelected];
    
    self.makeView.text = [NSString stringWithFormat:@"%d",[self numofChoiose]];
    self.makeView.hidden = ![self numofChoiose];
}
-(int)numofChoiose
{
    int num = 0;
    for (WPCompanyListDetailModel *model in self.arr) {
        if (model.itemIsSelected) {
            num++;
        }
    }
    
    return num;
}
-(BOOL)isThereSelected
{
    BOOL isOrNot = NO;
    for (WPCompanyListDetailModel *model in self.arr) {
        if (model.itemIsSelected) {
            return YES;
        }
    }
    
    return isOrNot;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPCompanyListDetailModel *model = self.arr[indexPath.row];
    
    WS(ws);
    WPComInfWebViewController *infoWebVC = [[WPComInfWebViewController alloc]init];
    [self requestCompanyInfo:model success:^(WPCompanyListModel *listModel) {
        infoWebVC.listModel = listModel;
        infoWebVC.isFix = ws.isFix;
        infoWebVC.isFromDetail = ws.isFromDetail;
        infoWebVC.personalApply = ws.personalApply;
        infoWebVC.personalApplyList = ws.personalApplyList;
        
        infoWebVC.isFromMyRob = ws.isFromMyRob;
        infoWebVC.isFromMyRobList = self.isFromMyRobList;
        infoWebVC.isFromcollection = self.isFRromCollection;
        infoWebVC.isFromMuchcollection = ws.isFRromMuchCollection;
        [ws.navigationController pushViewController:infoWebVC animated:YES];
    }];
}

- (void)launchNextPagesWithModel:(WPCompanyListDetailModel *)model
{
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
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        WPCompanyModel *model = [WPCompanyModel mj_objectWithKeyValues:json];
        for (WPCompanyListDetailModel *listModel in model.companyList)
        {
            if (self.choiseCell.length)
            {
                NSArray * array = [self.choiseCell componentsSeparatedByString:@","];
                UIButton * button = (UIButton*)[_bottomView viewWithTag:1000];
                button.selected = (array.count == model.companyList.count)?YES:NO;
                
                for (NSString * string in array)
                {
                    if ([string isEqualToString:listModel.epId])
                    {
                        listModel.itemIsSelected = YES;
                    }
                }
            }
            else
            {
                listModel.itemIsSelected = NO;
            }
//            listModel.itemIsSelected = NO;
        }
        success(model.companyList,0);
    } failure:^(NSError *error) {
        dalError(error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)requestCompanyInfo:(WPCompanyListDetailModel *)detailModel success:(void(^)(WPCompanyListModel *listModel))success{
    
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    NSDictionary *params = @{@"action":@"GetCompanyInfo",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"ep_id":detailModel.epId};
    [MBProgressHUD showMessage:@"" toView:self.view];
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
    for (WPCompanyListModel *model in self.arr) {
        if (!model.itemIsSelected) {
            return NO;
        }
    }
    return YES;
}

@end
