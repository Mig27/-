//
//  WPWiFiSetViewController.m
//  WP
//
//  Created by CC on 16/9/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPWiFiSetViewController.h"
#import "WPWiFiSetCell.h"
@interface WPWiFiSetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSArray * titleArr;
@property (nonatomic, strong)UITableView*tableView;
@end

@implementation WPWiFiSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频自动播放设置";
    [self.view addSubview:self.tableView];
    self.view.backgroundColor= RGB(235, 235, 235);
    // Do any additional setup after loading the view.
}
-(NSArray*)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"3G/4G和WiFi",@"仅WiFi",@"关闭"];
    }
    return _titleArr;
}
-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.layoutMargins = UIEdgeInsetsZero;
        _tableView.separatorColor = RGB(226, 226, 226);
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.titleArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(43);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"WPWiFiSetCellIdentifier";
    WPWiFiSetCell * cell= [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WPWiFiSetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.nameStr = _titleArr[indexPath.row];
    cell.wifiStr = self.WiFiStr;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString * string = [NSString string];
    switch (indexPath.row) {
        case 0:
            string = @"1";
            break;
        case 1:
            string = @"0";
            break;
        case 2:
            string = @"2";
            break;
        default:
            break;
    }
    
    NSDictionary * dic = @{@"action":@"setAutoPlay",
                           @"username":kShareModel.username,
                           @"password":kShareModel.password,
                           @"user_id":kShareModel.userId,
                           @"auto_play":string};
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/userInfo.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        if (self.choiseSet) {
            self.choiseSet(_titleArr[indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
    
    
//    
//    if (self.choiseSet) {
//        self.choiseSet(_titleArr[indexPath.row]);
//    }
//    [self.navigationController popViewControllerAnimated:YES];
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
