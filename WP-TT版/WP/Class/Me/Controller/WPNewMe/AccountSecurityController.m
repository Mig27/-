//
//  AccountSecurityController.m
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "AccountSecurityController.h"
// 推出页面
#import "WPSetCell.h"
#import "WPSetAccountController.h"
#import "TelePhoneViewController.h"
#import "ResetPassWordController.h"

#import "PersonalView.h"

#import "WPInfoManager.h"
#import "WPInfoController.h"

#define kHeightForHeaders 15
#define kHeightForRows kHEIGHT(43)
#define kWPAccountCellReuse @"WPAccountCellReuse"

@interface AccountSecurityController ()<UITableViewDataSource,UITableViewDelegate,WPInfoManagerDelegate>
{
    BOOL couldTouch;
}
//@property (nonatomic ,strong)WPInfoMo
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSArray *titleArr;
@end

@implementation AccountSecurityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账号设置与安全";
    [self request];
    [self.view addSubview:self.tableView];
    
}

-(void)request
{
    WPInfoManager *manager = [WPInfoManager sharedManager];
    manager.delegate = self;
    [manager requestForWPInFo];
    [self reloadData];
}

- (void)reloadData
{
    WPInfoManager *manager = [WPInfoManager sharedManager];
    NSLog(@"哈哈哈哈哈%@",manager.model.wpId);
    if (manager.model.wpId.length && ![manager.model.wpId isEqualToString:@"(null)"]) {
        couldTouch = YES;
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeightForHeaders;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightForRows;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPSetCell *cell = [[WPSetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWPAccountCellReuse];
    if (couldTouch) {
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    cell.title = self.titleArr[indexPath.row];
    if (indexPath.row == 0) {
        cell.detailTitle = [WPInfoManager sharedManager].model.wpId;
        cell.type = @"wpidType";
    }else{
        cell.detailTitle = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {// 推出 设置微聘号 页面
        if (!couldTouch) {
            WPSetAccountController *accountVC = [[WPSetAccountController alloc]init];
            accountVC.setSucceed = ^(NSString*weiPinId){
            WPSetCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.detailTitle = weiPinId;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            couldTouch = YES;
            
        };
            [self.navigationController pushViewController:accountVC animated:YES];
        }
        
    }else if (indexPath.row == 1){// 推出 手机号 页面
        TelePhoneViewController *telephoneVC = [[TelePhoneViewController alloc]init];
        telephoneVC.telephoneNumber = kShareModel.username;
        [self.navigationController pushViewController:telephoneVC animated:YES];
    }else{// 推出 密码修改 页面
        ResetPassWordController *resetVC = [[ResetPassWordController alloc]init];
        [self.navigationController pushViewController:resetVC animated:YES];
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
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
        self.titleArr = @[@"微聘号",@"手机号",@"密码修改"];
    }
    return _titleArr;
}

@end
