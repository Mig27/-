//
//  LinkAddViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/12/29.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "LinkAddViewController.h"
#import "LinkAddCell.h"

#import "MobileLinkController.h"
#import "AppDelegate.h"
//#import "UMSocialControllerService.h"
#import "ShareOperation.h"
#import "ScanQRCodePage.h"

@interface LinkAddViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *iconAndTitle;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;

@end

@implementation LinkAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}

- (void)createUI
{
    self.iconAndTitle = @[
//                          @{@"image" : @"tj_saoyidao",
//                            @"title" : @"扫一扫",
//                            @"subtitle" : @"扫描二维码名片"},
                          @{@"image" : @"tj_shouji",
                            @"title" : @"手机联系人",
                            @"subtitle" : @"添加或邀请通讯录中的好友"},
                          @{@"image" : @"tj_weixin",
                            @"title" : @"微信联系人",
                            @"subtitle" : @"添加或邀请微信好友"},
                          @{@"image" : @"tj_qq",
                            @"title" : @"QQ联系人",
                            @"subtitle" : @"添加或邀请QQ联系人"}];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = RGB(235, 235, 235);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = [LinkAddCell cellHeight];
    _tableView.tableHeaderView = self.headView;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    [self.view addSubview:_tableView];
}

- (UIView *)headView
{
    if (_headView == nil) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(37) + 20)];
        _headView.backgroundColor = RGB(235, 235, 235);
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, kHEIGHT(37))];
        backView.backgroundColor = [UIColor whiteColor];
        _headView.userInteractionEnabled = YES;
        backView.userInteractionEnabled = YES;
        [_headView addSubview:backView];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(37)/2 - 7.5, 15, 15)];
        icon.image = [UIImage imageNamed:@"add_search"];
        [backView addSubview:icon];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + 8, kHEIGHT(37)/2 - 8.5, SCREEN_WIDTH - 100, 17)];
        titleLabel.text = @"微聘号/群号码/手机号";
        titleLabel.textColor = RGB(170, 170, 170);
        titleLabel.font = kFONT(15);
        [backView addSubview:titleLabel];
        
        UIButton *control = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(37))];
        [control addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:control];
    }
    
    return _headView;
}

- (void)searchBtnClick
{
    NSLog(@"点击搜索");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _iconAndTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LinkAddCell *cell = [LinkAddCell cellWithTableView:tableView];
    cell.info = self.iconAndTitle[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) { //扫一扫
////        NSLog(@"扫一扫");
//        ScanQRCodePage *vc = [ScanQRCodePage new];
//        [self.navigationController pushViewController:vc animated:YES];
//    } else
        if (indexPath.row ==0) { //手机联系人
//        NSLog(@"手机联系人");
        MobileLinkController *mobile = [[MobileLinkController alloc] init];
        [self.navigationController pushViewController:mobile animated:YES];
    } else if (indexPath.row == 1) { //微信联系人
        [ShareOperation shareToPlatform:UMSocialPlatformType_WechatSession presentController:self status:nil];
    } else if (indexPath.row == 2) { //QQ联系人
        [ShareOperation shareToPlatform:UMSocialPlatformType_QQ presentController:self status:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)shareToPlatform:(NSString *)platform
{
//    NSString *shareText = @"我是微聘，希望大家能够喜欢！ http://www.umeng.com/social";
//    UIImage *shareImage = [UIImage imageNamed:@"图层 14"];
//    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[platform] content:shareText image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity * response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//            [alertView show];
//        } else if(response.responseCode != UMSResponseCodeCancel) {
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//            [alertView show];
//        }
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
