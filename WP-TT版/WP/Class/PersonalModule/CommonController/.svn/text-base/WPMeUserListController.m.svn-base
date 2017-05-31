//
//  WPMeUserListController.m
//  WP
//
//  Created by CBCCBC on 16/3/30.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMeUserListController.h"
#import "WPCompanysCell.h"
#import "WPPersonalManager.h"
#import "WPSelectedButton.h"
#import "WPEditButton.h"
#import "WPPersonalInfoController.h"
#import "WPResumeEditVC.h"
#import "MJRefresh.h"
#import "WPCompanyManager.h"
#import "WPCompanyEditController.h"
#import "WPResumeEditVC.h"
#import "WPResumeWebVC.h"
#import "WPComInfWebViewController.h"
#import "MTTDatabaseUtil.h"
#define kWPMeUserListCellReuse @"WPMeUserListCellReuse"

@interface WPMeUserListController ()<UITableViewDelegate,UITableViewDataSource,WPPersonalManagerDelegate,WPResumeEditVCDelagte,WPCompanyManagerDelegate,UIAlertViewDelegate,RefreshCompanyInfoDelegate>
{
    WPEditButton *editbutton;
    WPSelectedButton *SelectedButton;
    UIButton *backButton;
    BOOL isEdit;
}
@property (nonatomic, strong)NSMutableArray *modelArr;
@property (nonatomic ,strong)UITableView *tableView;
@end

@implementation WPMeUserListController
#pragma mark - 添加返回按钮
-(void)createBackButton:(NSInteger)tag
{
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 50, 22);
    backButton.tag=tag;
    [backButton addTarget:self action:@selector(backToView:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
    imageV.image = [UIImage imageNamed:@"fanhui"];
    [backButton addSubview:imageV];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
    title.text = @"返回";
    title.font = kFONT(14);
    [backButton addSubview:title];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

#pragma mark-backAction
-(void)backToView:(UIButton *)sender
{
    //用户点击了返回按钮
    if (sender.tag==100)
    {
        if ([self.title isEqualToString:@"个人信息"]) {
            if (self.personalInfo) {
                self.personalInfo(self.modelArr.count);
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        //点击编辑后切换对应按钮
        [self addRightBarButtonItem:50];
        [SelectedButton removeFromSuperview];
        isEdit=NO;
        [self.tableView reloadData];
        editbutton = [[WPEditButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        
        [editbutton setEditTarget:self editdAction:@selector(editdAction:)];
        [self.view addSubview:editbutton];
        backButton.tag=100;
        
        for (WPPersonModel*model in self.modelArr) {
            model.selected = NO;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self createBackButton:100];
    if ([self.title isEqualToString:@"个人信息"]) {
        [self requestForPersonList];
    }else if ([self.title isEqualToString:@"我的企业"]) {
        [self requestForCompanyList];
    }
//    [self addRemoveButton];
    [self addRightBarButtonItem:50];
}
- (void)addRightBarButtonItem:(NSInteger)tag
{
    if (tag==50)
    {
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
    } else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    }
}
#pragma mark 点击创建
- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    if ([self.title isEqualToString:@"个人信息"]) {
        WPResumeEditVC *VC = [[WPResumeEditVC alloc]init];
        [VC setupSubViews];
        VC.setup = YES;
        VC.delegate =self;
        VC.isPersonInfo = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([self.title isEqualToString:@"我的企业"]) {
        WPCompanyEditController *VC = [[WPCompanyEditController alloc]init];
//        VC.companyModel = self.conpanyModel;
        VC.delegate = self;
        [self.navigationController pushViewController:VC animated:YES];
    }
}
-(void)RefreshCompanyInfo
{
   [self requestForCompanyList];
    if (self.deleteMyCompany) {
        self.deleteMyCompany(0,YES);
    }
    
}
#pragma mark 点击编辑按钮触发事件
- (void)addRemoveButton
{
   editbutton = [[WPEditButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    [editbutton setEditTarget:self editdAction:@selector(editdAction:)];
    [self.view addSubview:editbutton];
}
-(void)editdAction:(UIButton *)sender
{
     [self createBackButton:1];
    [self addRightBarButtonItem:10];
    //点击编辑进入全选删除
    [editbutton removeFromSuperview];
    isEdit=YES;
    [self.tableView reloadData];
    //创建全选和删除按钮
    SelectedButton = [[WPSelectedButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    [SelectedButton setSelectedTarget:self selectedAction:@selector(selectedAction:)];
    [SelectedButton setDeleteTarget:self deleteAction:@selector(deleteAction:)];
    [self.view addSubview:SelectedButton];
}
#pragma mark点击全选
- (void)selectedAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if ([self.title isEqualToString:@"个人信息"]) {
        for (WPPersonModel *model in self.modelArr) {
            model.selected = sender.selected;
        }
        
    }else if ([self.title isEqualToString:@"我的企业"]) {
        for (CompanyModel *model in self.modelArr) {
            model.selected = sender.selected;
        }
    }
    [self getNumOfChoise];
   
    for (int i = 0 ; i < self.modelArr.count; i++) {
        NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
        WPCompanysCell *cell = [self.tableView cellForRowAtIndexPath:index];
        cell.chooseButton.selected = sender.selected;
    }
    
//    [self.tableView reloadData];
}
#pragma mark点击删除
- (void)deleteAction:(UIButton *)sender
{
    NSString * title = [self.title isEqualToString:@"个人信息"]?@"如删除个人信息，个人信息对应的求职简历和求职申请也将会被一并删除，确定删除个人信息吗？":@"如删除企业信息，企业信息对应的企业招聘和企业投递也将会被一并删除，确定删除企业信息吗？";
    [[[UIAlertView alloc]initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //删除完成后
        [self addRightBarButtonItem:50];
        
        SelectedButton.numLabel.text = @"";
        SelectedButton.numLabel.hidden = YES;
        SelectedButton.delete.selected = NO;
        SelectedButton.selected.selected = NO;
        
        [SelectedButton removeFromSuperview];
        isEdit=NO;
        [editbutton removeFromSuperview];
        [self removePersonalInfoAction];
        //[self.tableView reloadData];

//        if (self.modelArr.count) {
//            editbutton = [[WPEditButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
//            
//            [editbutton setEditTarget:self editdAction:@selector(editdAction:)];
//            [self.view addSubview:editbutton];
//            backButton.tag=100;
//        }
    }
}

- (void)removePersonalInfoAction
{
    NSString *IDs = [self giveMeIds];
    if (!IDs) {
        return;
    }else{
        [self removeWithIds:IDs];
    }
}

- (NSString *)giveMeIds
{
    NSString *friends;
    int i =0 ;
    if ([self.title isEqualToString:@"个人信息"]) {
        for (WPPersonModel *model in self.modelArr) {
            if (model.selected) {
                if (friends.length == 0) {
                    friends = model.sid;
                }else{
                    friends = [NSString stringWithFormat:@"%@,%@",friends,model.sid];
                }
            }
            i++;
        }
    }else if ([self.title isEqualToString:@"我的企业"]) {
        for (CompanyModel *model in self.modelArr) {
            if (model.selected) {
                if (friends.length == 0) {
                    friends = model.ep_id;
                }else{
                    friends = [NSString stringWithFormat:@"%@,%@",friends,model.ep_id];
                }
            }
            i++;
        }
    }
    return friends;
}

- (void)removeWithIds:(NSString *)Ids
{
    WS(ws);
    if ([self.title isEqualToString:@"个人信息"]) {
        [[WPPersonalManager sharedManager]removePersonInfoWithIDs:Ids success:^(id json) {
            [ws requestForPersonList];
            if (self.deleteMyCompany) {
                NSArray * array = [Ids componentsSeparatedByString:@","];
                self.deleteMyCompany(array.count,NO);
            }
        }];
    }else if ([self.title isEqualToString:@"我的企业"]) {
        [[WPCompanyManager sharedManager]removeCompanyWithIDs:Ids success:^(id json) {
            [ws requestForCompanyList];
            if (self.deleteMyCompany) {
                NSArray * array = [Ids componentsSeparatedByString:@","];
                self.deleteMyCompany(array.count,NO);
            }
        }];
    }
    
}

- (void)requestForPersonList
{
    WPPersonalManager *manager = [WPPersonalManager sharedManager];
    manager.delegate = self;
    [manager requstPersonInfoList];
}

- (void)requestForCompanyList
{
    WPCompanyManager *manager = [WPCompanyManager sharedManager];
    manager.delegate = self;
    [manager requstCompanyList];
}

- (void)reloadVCData
{
    [self requestForPersonList];
    if (self.deleteMyCompany) {
        self.deleteMyCompany(0,YES);
    }
}

- (void)reloadData
{
    [editbutton removeFromSuperview];
    [self.modelArr removeAllObjects];
    if ([self.title isEqualToString:@"个人信息"]) {
        WPPersonalManager *manager = [WPPersonalManager sharedManager];
        [self.modelArr addObjectsFromArray:manager.modelArr];
    }else if ([self.title isEqualToString:@"我的企业"]) {
        WPCompanyManager *manager = [WPCompanyManager sharedManager];
        [self.modelArr addObjectsFromArray:manager.modelArr];
    }

    backButton.tag=100;

    [self.tableView reloadData];
    if (self.modelArr.count) {
        [self addRemoveButton];
    }
}

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        self.modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  kHEIGHT(58);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPCompanysCell *cell = [tableView dequeueReusableCellWithIdentifier:kWPMeUserListCellReuse forIndexPath:indexPath];
    cell.tag = indexPath.row;
    if ([self.title isEqualToString:@"个人信息"]) {
        cell.personModel = self.modelArr[indexPath.row];
        //点击cell上的按钮的回调
        
    }else if ([self.title isEqualToString:@"我的企业"]) {
        cell.companyModel = self.modelArr[indexPath.row];
    }
    cell.ChooseCurrentCompanyForResumeBlock = ^(NSInteger CellTag){
        WPPersonModel * model = self.modelArr[CellTag];
        model.selected = !model.selected;
        [self getNumOfChoise];
        
    };
    
    
    if (isEdit) {
//        cell.chooseButton.hidden=NO;
        cell.isHideChoise = NO;
    }
    else
    {
        cell.isHideChoise = YES;
//        cell.chooseButton.hidden=YES;
    }
    
    return cell;
}
#pragma mark 获取被选择的数量
-(void)getNumOfChoise
{
    int num = 0;
    for (WPPersonModel  * model in self.modelArr) {
        if (model.selected) {
            num++;
        }
    }
    if (num == 0)
    {
      SelectedButton.numLabel.text = @"";
        SelectedButton.numLabel.hidden = YES;
        SelectedButton.delete.selected = NO;
        SelectedButton.selected.selected= NO;
    }
    else if (num<self.modelArr.count)
    {
        SelectedButton.numLabel.text = [NSString stringWithFormat:@"%d",num];
        SelectedButton.numLabel.hidden = NO;
        SelectedButton.delete.selected = YES;
        SelectedButton.selected.selected= NO;
    }
    
    else
    {
        SelectedButton.numLabel.text = [NSString stringWithFormat:@"%d",num];
        SelectedButton.numLabel.hidden = NO;
        SelectedButton.delete.selected = YES;
        SelectedButton.selected.selected= YES;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isEdit)
    {
        WPPersonModel * model = self.modelArr[indexPath.row];
        model.selected = !model.selected;
//      [tableView reloadData];
        
        WPCompanysCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.chooseButton.selected = !cell.chooseButton.selected;
        
        
        [self getNumOfChoise];
    }
    else
    {
        if ([self.title isEqualToString:@"个人信息"]) {

                WPResumeWebVC *WebVC = [WPResumeWebVC new];
                WebVC.isBuildNew = YES;
                WebVC.isRecuilist = 1;
                WPResumeUserModel * resumeModel = [[WPResumeUserModel alloc]init];
                WPPersonModel*personal = self.modelArr[indexPath.row];
                resumeModel.name = personal.name;
                resumeModel.resumeUserId = personal.sid;
                WebVC.model = resumeModel;
                WebVC.choiseResume = YES;//直接选择查看简历
                WebVC.isMyPersonalInfo = YES;
                WebVC.personalModel = self.modelArr[indexPath.row];
                WebVC.setAgain = ^(){
                [self requestForPersonList];
                if (self.deleteMyCompany) {
                    self.deleteMyCompany(0,YES);
                 }
                };
                [self.navigationController pushViewController:WebVC animated:YES];
            
            
            
//            WPResumeEditVC *VC = [[WPResumeEditVC alloc]init];
//            VC.isEdit=1000;
//            VC.isPerson=100;
//            VC.isPersonInfo = YES;
//            VC.personModel = self.modelArr[indexPath.row];
//            [self.navigationController pushViewController:VC animated:YES];
        }
        else if ([self.title isEqualToString:@"我的企业"])
        {
               WPCompanyListModel * listModel = [[WPCompanyListModel alloc]init];
               CompanyModel * model = self.modelArr[indexPath.row];
            
                WPComInfWebViewController *infoWebVC = [[WPComInfWebViewController alloc]init];
                infoWebVC.companyModel = model;
            
                listModel.epId = model.ep_id;
                listModel.enterpriseName = model.enterprise_name;
                listModel.dataIndustry = model.dataIndustry;
                listModel.enterpriseProperties = model.enterprise_properties;
                listModel.enterpriseScale = model.enterprise_scale;
                infoWebVC.listModel = listModel;
                infoWebVC.isMyPersonalCompany = YES;
                [self.navigationController pushViewController:infoWebVC animated:YES];

            
            
//            WPCompanyEditController *VC = [[WPCompanyEditController alloc]init];
//            VC.isEditCompany=1000;
//            VC.isCompany=100;
//            VC.delegate = self;
//            VC.companyModel = self.modelArr[indexPath.row];
//            [self.navigationController pushViewController:VC animated:YES];
        }
        
        
//        WPPersonalInfoController *edit = [[WPPersonalInfoController alloc]init];
//        edit.isedit=1000;
//        edit.title = self.title;
//        if ([self.title isEqualToString:@"个人信息"]) {
//            WPPersonModel *model = self.modelArr[indexPath.row];
//            edit.personModel = model;
//        }else if ([self.title isEqualToString:@"我的企业"]) {
//            CompanyModel *model = self.modelArr[indexPath.row];
//            edit.conpanyModel = model;
//        }
//        [self.navigationController pushViewController:edit animated:YES];
    }
}
- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor whiteColor];//RGB(235, 235, 235)
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[WPCompanysCell class] forCellReuseIdentifier:kWPMeUserListCellReuse];
        __weak typeof(self) unself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if ([unself.title isEqualToString:@"个人信息"]) {
                [unself requestForPersonList];
            }else if ([unself.title isEqualToString:@"我的企业"]) {
                [unself requestForCompanyList];
            }
            [unself.tableView.mj_header endRefreshing];
        }];
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

@end
