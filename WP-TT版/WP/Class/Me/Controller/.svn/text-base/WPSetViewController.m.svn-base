//
//  WPSetViewController.m
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPSetViewController.h"
#import "WPSetCell.h"
#import "AccountSecurityController.h"
#import "WPMessagerNoticeController.h"
#import "WPConcealController.h"
#import "WPAnonymousController.h"
#import "MBProgressHUD.h"
#import "HJCActionSheet.h"
#import "WPWiFiSetViewController.h"
#import "LogoutAPI.h"
#import "WPLoginViewController1.h"
#import "DDClientState.h"
#import "MTTUtil.h"
#import "MTTNotification.h"
#import "WPShuoStaticData.h"
#import "WriteViewController.h"
#define kHeightForHeaders 15
#define kHeightForRows kHEIGHT(43)
#define kWPSetCellReuse @"WPSetCellReuse"

@interface WPSetViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,HJCActionSheetDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSArray *titleArr;
@property (nonatomic, copy) NSString * wifiStr;

@end

@implementation WPSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.title = @"设置";
    _wifiStr = @"仅WiFi";
    [self requstWiFiData];
    
    //请求wifi数据
    
}

//获取缓存文件的大小
- (float)filePath

{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    return [ self folderSizeAtPath :cachPath];
}
- (float) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    
    return folderSize/( 1024.0 * 1024.0 );
}
- (long long) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0 ;
}
//清除缓存
- ( void )clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject :nil waitUntilDone : YES ];
}
-(void)clearCachSuccess
{
    [MBProgressHUD createHUD:@"清除成功" View:self.view];
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:2];
    WPSetCell * cell = [_tableView cellForRowAtIndexPath:indexpath];
    cell.WiFiDetail = @"";
}
-(void)requstWiFiData
{
    NSDictionary * dci = @{@"action":@"getAutoPlay",
                           @"username":kShareModel.username,
                           @"password":kShareModel.password,
                           @"user_id":kShareModel.userId};
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/userInfo.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dci success:^(id json) {
        NSString * string = json[@"auto_play"];
        switch (string.intValue) {
            case 0:
                _wifiStr = @"仅WiFi";
                break;
            case 1:
                _wifiStr = @"3G/4G和WiFi";
                break;
            case 2:
                _wifiStr = @"关闭";
                break;
            default:
                break;
        }
        [self.tableView reloadData];
     
    } failure:^(NSError *error) {
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeightForHeaders;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) { // 退出登录 按钮
        return kHEIGHT(38);
    }
    return kHeightForRows;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeightForHeaders)];
    view.backgroundColor = RGB(235, 235, 235);
    return view;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    view.backgroundColor = RGB(235, 235, 235);
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.titleArr.count-1) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UItableViewCellReuse"];
        cell.textLabel.text = self.titleArr[indexPath.section] [indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    WPSetCell *cell = [[WPSetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWPSetCellReuse];
    cell.title = self.titleArr[indexPath.section][indexPath.row];
    if (indexPath.section == 1 && indexPath.row == 4) {
        cell.WiFiDetail = _wifiStr;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        float rubbish;
       dispatch_async(dispatch_get_global_queue(0, 0), ^{
           float num = [self filePath];
           dispatch_async_on_main_queue(^{
                cell.WiFiDetail =(rubbish>0)?[NSString stringWithFormat:@"%.2fM",num]:@"";
           });
       });
//        float rubbish = [self filePath];
//        cell.WiFiDetail =(rubbish>0)?[NSString stringWithFormat:@"%.2fM",rubbish]:@"";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {// 推出 账号与安全 页面
        
        AccountSecurityController *asVC = [[AccountSecurityController alloc]init];
        [self.navigationController pushViewController:asVC animated:YES];
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {// 推出 消息通知 页面
            
            WPMessagerNoticeController *messagerVC = [[WPMessagerNoticeController alloc]init];
            [self.navigationController pushViewController:messagerVC animated:YES];
            
        }else if (indexPath.row == 1){// 推出 隐私 页面
            
            WPConcealController *concealVC = [[WPConcealController alloc]init];
            [self.navigationController pushViewController:concealVC animated:YES];
            
        }else if (indexPath.row == 2){// 推出 匿名信息 页面
            
            WPAnonymousController *anonyVC = [[WPAnonymousController alloc]init];
            [self.navigationController pushViewController:anonyVC animated:YES];
        }
//        else if (indexPath.row == 3)// 推出 邀请好友 页面
//        {
//          [self alertshow];
//        }
        else//跳到wifi设置界面
        {
            WPWiFiSetViewController * wifi = [[WPWiFiSetViewController alloc]init];
            wifi.WiFiStr = _wifiStr;
            wifi.choiseSet = ^(NSString *wifiSet){
                NSIndexPath * indexpath = [NSIndexPath indexPathForRow:4 inSection:1];
                WPSetCell * cell = [_tableView cellForRowAtIndexPath:indexpath];
                cell.WiFiDetail = wifiSet;
                _wifiStr = wifiSet;
            };
            [self.navigationController pushViewController:wifi animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {// 清除缓存
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认清除缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil] show];
        }
      else if (indexPath.row == 1)//意见反馈
      {
          WriteViewController * write = [[WriteViewController alloc]init];
          write.isOpinition = YES;
          [self.navigationController pushViewController:write animated:YES];
      }
        else{// 推出 关于微聘
        }
    }else if (indexPath.section == 3){// 退出登录
        [MBProgressHUD showMessage:@"" toView:self.view];
        NSArray * object = @[kShareModel.username,kShareModel.password];
        LogoutAPI * login = [[LogoutAPI alloc]init];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [login requestWithObject:object Completion:^(id response, NSError *error) {
                
               dispatch_async(dispatch_get_main_queue(), ^{
                   //清除静态数据
                   WPShuoStaticData * dataShuo = [WPShuoStaticData shareShuoData];
                   [dataShuo clearContent];
                   //改变群通知的个数
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGENOTIFICATIONCOUNT" object:nil];
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutClearSession" object:nil];
                   [MBProgressHUD hideHUD];
                   [MTTUtil loginOut];
                   WPLoginViewController1 * login = [[WPLoginViewController1 alloc]init];
                   login.isFromQuit = YES;
                   [self.navigationController pushViewController:login animated:NO];
                   [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
               });
            }];
        });
        
        
//        [login requestWithObject:object Completion:^(id response, NSError *error) {
//            //清除静态数据
//            WPShuoStaticData * dataShuo = [WPShuoStaticData shareShuoData];
//            [dataShuo clearContent];
//            
//            //改变群通知的个数
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGENOTIFICATIONCOUNT" object:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutClearSession" object:nil];
//            
//            [MBProgressHUD hideHUD];
//            [MTTUtil loginOut];           
//            WPLoginViewController1 * login = [[WPLoginViewController1 alloc]init];
//            login.isFromQuit = YES;
//            [self.navigationController pushViewController:login animated:NO];
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//        }];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self clearFile];
//        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:2];
//        WPSetCell * cell = [_tableView cellForRowAtIndexPath:indexpath];
//        cell.WiFiDetail = @"";
    }
}
- (void)alertshow
{
    HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"通过短信邀请",@"通过微信好友邀请",@"通过微信朋友圈邀请",@"通过QQ邀请", nil];
    
    [sheet show];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//    短信邀请
        
    }else if (buttonIndex == 1){//    微信好友邀请
        
    }else if (buttonIndex == 2){//    微信朋友邀请
        
    }else if (buttonIndex == 3){//    QQ邀请
        
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
        self.titleArr = @[@[@"账号与安全"],
                          @[@"消息通知",@"隐私",@"匿名信息",
//                            @"邀请好友",
                          //  @"视频自动播放设置"
                            ],
                          @[@"清除缓存",@"意见与反馈",@"关于快捷招聘"],
                          @[@"退出登录"]];
    }
    return _titleArr;
}


@end
