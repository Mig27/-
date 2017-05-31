//
//  WPMeRecruitController.m
//  WP
//
//  Created by CBCCBC on 16/1/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMeRecruitController.h"
#import "WPMeActivitiesCell.h"
#import "WPMeCompanyListController.h"
#import "WPMeApplyViewController.h"
#import "WPMeRecruitResumeController.h"
#import "WPNewMeResumeController.h"
#import "WPMeUserListController.h"
#import "WPTipModel.h"
@interface WPMeRecruitController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation WPMeRecruitController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的招聘";
    
    NSArray *array = @[@{@"name":@"我的企业",
                         @"icon":@"me_wodeqiye",
                         @"recruitCount":@"0"},
                       @{@"name":@"我发布的招聘",
                         @"icon":@"me_wodezhaopin",
                         @"recruitCount":@"0"},
                       @{@"name":@"我抢的人",
                         @"icon":@"me_wodebaoming",
                         @"recruitCount":@"0"}];
    for (int i = 0; i < array.count; i++) {
        WPMeRecruitModel *model = [WPMeRecruitModel mj_objectWithKeyValues:array[i]];
        [self.array addObject:model];
    }
    
    [self.tableView reloadData];
    [self requestForCount];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteEmploySuccess) name:@"deleteApplySuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageTip) name:@"GlobalMessageTip" object:nil];
    
}
-(void)messageTip
{
    WPTipModel *model = [WPTipModel sharedManager];
    WPMeRecruitModel *model1 = self.array[1];
    model1.jobSignCount = model.job_UnReadCount;
    [self.tableView reloadData];
}
-(void)deleteEmploySuccess
{
    [self requestForCount];
}
- (NSMutableArray *)array{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(235, 235, 235);
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(64);
        }];
        
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
- (void)requestForCount{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    NSDictionary *params = @{@"action":@"MyJobCount",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        if ([json[@"status"] isEqualToString:@"0"]) {
            NSArray *array = @[json[@"companyCount"],json[@"jobCount"],json[@"resumeCount"]];
            for (int i = 0; i < self.array.count; i++) {
                WPMeRecruitModel *model = self.array[i];
                model.recruitCount = array[i];
            }
            [self.tableView reloadData];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"myInviteCount"];
        }
        else
        {
            NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"myInviteCount"];
            if (array.count) {
                for (int i = 0; i < self.array.count; i++) {
                    WPMeRecruitModel *model = self.array[i];
                    model.recruitCount = array[i];
                }
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"myInviteCount"];
        if (array.count) {
            for (int i = 0; i < self.array.count; i++) {
                WPMeRecruitModel *model = self.array[i];
                model.recruitCount = array[i];
            }
            [self.tableView reloadData];
        }
       NSLog(@"%@",error.localizedDescription);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1)
    {
        return 20;
    }
    else
    {
    return kHEIGHT(43);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"WPMeActivitiesCell";
    WPMeActivitiesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WPMeActivitiesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    WPMeRecruitModel *model = [[WPMeRecruitModel alloc]init];
    if (indexPath.row == 0) {
       model = self.array[indexPath.row];
    }
    else if (indexPath.row == 1)
    {
      model = nil;
        for (UIView * view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
            cell.backgroundColor = RGB(235, 235, 235);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    else
    {
      model = self.array[indexPath.row-1];
    }
    
//  WPMeRecruitModel *model = self.array[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:model.icon];
    cell.titleLabel.text = model.name;
    cell.countLabel.text = model.recruitCount;
    cell.inviteCount = model.jobSignCount;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) { // 推出 我的企业 页面
        
        WPMeUserListController *company = [[WPMeUserListController alloc]init];
        company.title = @"我的企业";
        company.deleteMyCompany = ^(NSInteger inter, BOOL creatOrNot){
//            WPMeRecruitModel *model = self.array[indexPath.row];
//            NSInteger interger = 0;
//            if (creatOrNot)//创建
//            {
//                interger = model.recruitCount.integerValue+1;
//            }
//            else//删除
//            {
//                interger = model.recruitCount.integerValue-inter;
//            }
//            
//            model.recruitCount =[NSString stringWithFormat:@"%ld",(long)interger];
//            [self.array replaceObjectAtIndex:indexPath.row withObject:model];
//            [self.tableView reloadData];
            [self requestForCount];
            
        };
        [self.navigationController pushViewController:company animated:YES];
        
    }
    if (indexPath.row == 2) { // 推出 我的招聘 / 求职 页面
        
        WPNewMeResumeController *resume = [[WPNewMeResumeController alloc]init];
        resume.type = WPNewMeResumeTypeRecruit;
        [self.navigationController pushViewController:resume animated:YES];
    }
    if (indexPath.row == 3) { // 推出 我抢的人 页面
        WPMeApplyViewController *apply = [[WPMeApplyViewController alloc]init];
        apply.type = WPMeApplyViewControllerTypeRecruit;
        [self.navigationController pushViewController:apply animated:YES];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation WPMeRecruitModel
@end
