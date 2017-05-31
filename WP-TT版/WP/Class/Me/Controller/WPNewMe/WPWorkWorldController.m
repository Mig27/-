//
//  WPWorkWorldController.m
//  WP
//
//  Created by CBCCBC on 16/3/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPWorkWorldController.h"
#import "WPSetCell.h"
#import "SwitchView.h"
#import "WPDoNotWatchController.h"
#import "WPPersonSetDontSeeOrLetSeeHttp.h"
#import "WPGetForStrangerSettingHttp.h"
#define kHeightForHeaders 20
#define kHeightForRows kHEIGHT(43)
#define kWorkWorldCellReuse @"WorkWorldCellReuse"
@interface WPWorkWorldController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *nextTitle;
}
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSArray *titleArr;
@property (nonatomic ,strong)SwitchView *switchView;

@property (nonatomic ,copy) NSString *circle;
@property (nonatomic ,copy) NSString *resume;
@property (nonatomic ,copy) NSString *job;


@end

@implementation WPWorkWorldController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getForStangerSettingWithAction];
    self.title = [NSString stringWithFormat:@"%@%@",self.action,@"范围"];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.switchView;
    
}

#pragma mark - 数据相关
-(void)setOtherPersonSeeMeWorkloopPrioirtyWithStatus:(NSString *)status{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPPersonSetDontSeeOrLetSeeParam *param = [[WPPersonSetDontSeeOrLetSeeParam alloc] init];
    if ([self.action isEqualToString:@"话题"]) {
        param.action = @"setcircle";  //工作圈
    }else if([self.action isEqualToString:@"求职"]){
        param.action = @"setresume";
    }else{
        param.action = @"setjob";
    }
    param.username = model.username;
    param.password = model.password;
    param.user_id = userInfo[@"userid"];
    param.state = status;

    [WPPersonSetDontSeeOrLetSeeHttp WPPersonSetDontSeeOrLetSeeHttpWithParam:param success:^(WPPersonSetDontSeeOrLetSeeResult *result) {
        if (result.status.intValue == 0) { //成功
            
        }else{
            //如果设置失败 还是保持之前的状态
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
    
}

-(void)getForStangerSettingWithAction{
    WPShareModel *model = [WPShareModel sharedModel];
    WPGetForStrangerSettingParam *param = [[WPGetForStrangerSettingParam alloc] init];
    if ([self.action isEqualToString:@"话题"]) {
        param.action = @"getcircle";
    }else if([self.action isEqualToString:@"求职"]){
        param.action = @"getresume";
    }else{
        param.action = @"getjob";
    }
    param.username = model.username;
    param.password = model.password;
    param.user_id = model.userId;
    
    [WPGetForStrangerSettingHttp WPGetForStrangerSettingHttpWithParam:param success:^(WPGetForStrangerSettingResult *result) {
        if (result.status.intValue == 0) {
            if ([self.action isEqualToString:@"话题"]) {
                if ([result.is_circle isEqualToString:@"True"]) {
                    [self.switchView.switchView setOn:YES animated:YES];
                }else{
                    [self.switchView.switchView setOn:NO animated:YES];
                }
            }else if([self.action isEqualToString:@"求职"]){
                if ([result.is_resume isEqualToString:@"True"]) {
                    [self.switchView.switchView setOn:YES animated:YES];
                }else{
                    [self.switchView.switchView setOn:NO animated:YES];
                }

            }else{
                if ([result.is_job isEqualToString:@"True"]) {
                    [self.switchView.switchView setOn:YES animated:YES];
                }else{
                    [self.switchView.switchView setOn:NO animated:YES];
                }
            }
        }else{
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
}


- (SwitchView *)switchView
{
    if (!_switchView) {
        self.switchView = [[SwitchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43))];
        self.switchView.switchView.on = YES;
        self.switchView.backgroundColor = [UIColor whiteColor];
        self.switchView.title = [NSString stringWithFormat:@"允许陌生人看我的%@",self.action];
        __weak typeof(_switchView) weakSelf = _switchView;
        __weak typeof(self) weakSelf1 = self;
        self.switchView.switchBlock = ^(){
            if (weakSelf.switchView.isOn == YES) {
                [weakSelf1 setOtherPersonSeeMeWorkloopPrioirtyWithStatus:@"0"];
            }else{
                [weakSelf1 setOtherPersonSeeMeWorkloopPrioirtyWithStatus:@"1"];
            }
        };
    }
    return _switchView;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeightForHeaders;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightForRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPSetCell *cell = [[WPSetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWorkWorldCellReuse];
    cell.title = self.titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WPDoNotWatchController *DonotVC = [[WPDoNotWatchController alloc]init];
    if ([self.action isEqualToString:@"话题"]) {// 工作圈
        
        if (indexPath.row == 0) {// 推出 让 页面
            DonotVC.title = self.titleArr[0];
            DonotVC.action = @"DontSeeCircleFromHe";
        }else if (indexPath.row == 1){// 推出 不看 页面
            DonotVC.title = self.titleArr[1];
            DonotVC.action = @"DontSeeCircleToHe";
        }
        
    }else if ([self.action isEqualToString:@"求职"]){// 求职
        
        if (indexPath.row == 0) {// 推出 让 页面
            DonotVC.title = self.titleArr[0];
            DonotVC.action = @"DontSeeResumeFromHe";
        }else if (indexPath.row == 1){// 推出 不看 页面
            DonotVC.title = self.titleArr[1];
            DonotVC.action = @"DontSeeResumeToHe";
        }
        
    }else{// 招聘
        
        if (indexPath.row == 0) {// 推出 让 页面
            DonotVC.title = self.titleArr[0];
            DonotVC.action = @"DontSeeJobFromHe";
        }else if (indexPath.row == 1){// 推出 不看 页面
            DonotVC.title = self.titleArr[1];
            DonotVC.action = @"DontSeeJobToHe";
        }
        
    }
    
    
    [self.navigationController pushViewController:DonotVC animated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+15, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = RGB(235, 235, 235);
        self.tableView.showsVerticalScrollIndicator = NO;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSArray *)titleArr
{
    if (!_titleArr) {
        NSString *str1 = [NSString stringWithFormat:@"不让他(她)看我的%@",self.action];
        NSString *str2 = [NSString stringWithFormat:@"不看他(她)的%@",self.action];
        self.titleArr = @[str1,str2];
    }
    return _titleArr;
}

@end
