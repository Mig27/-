//
//  WPMessageAlertViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/4/22.
//  Copyright © 2016年 WP. All rights reserved.
//  消息提醒

#import "WPMessageAlertViewController.h"
#import "WPMessageAlertCell.h"
#import "MTTNotification.h"
#import "MTTDatabaseUtil.h"
@interface WPMessageAlertViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation WPMessageAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self.tableView reloadData];
}

- (void)initNav
{
    self.view.backgroundColor = BackGroundColor;
    self.title = @"消息提醒";
    self.dataSource = @[@"有声模式",
                        @"无声模式"
//                        ,
//                        @"屏蔽群消息"
                        ];
}

- (void)backToFromViewController:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"groupUpdate" object:nil];
    if (self.modifiedSuccess) {
        self.modifiedSuccess(self.model);
    }
}

#pragma mark tableView
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = [WPMessageAlertCell rowHeight];
        _tableView.bounces = NO;
        _tableView.backgroundColor = BackGroundColor;
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPMessageAlertCell *cell = [WPMessageAlertCell cellWithTableView:tableView];
    cell.titleString = self.dataSource[indexPath.row];
    if (indexPath.row == self.model.is_sound.integerValue) {
        cell.selectBtn.selected = YES;
    } else {
        cell.selectBtn.selected = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.model.is_sound = [NSString stringWithFormat:@"%ld",indexPath.row];
    [self.tableView reloadData];
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
    NSDictionary *params = @{@"action" : @"updateGroupOneInfo",
                             @"userID" : kShareModel.userId,
                             @"group_id" : self.model.group_id,
                             @"is_near" : self.model.is_near,
                             @"is_to" : self.model.is_to,
                             @"is_sound" : self.model.is_sound,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password};
    [self setVolume:indexPath.row];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@---%@",json,json[@"info"]);
    } failure:^(NSError *error) {
        
    }];
}

-(void)setVolume:(BOOL)isOrNot
{
    self.groupSession.isShield= isOrNot;
    [MTTNotification postNotification:MTTNotificationSessionShieldAndFixed userInfo:nil object:nil];
    [[MTTDatabaseUtil instance] updateRecentSessions:@[self.groupSession] completion:^(NSError *error) {
        
    }];
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
