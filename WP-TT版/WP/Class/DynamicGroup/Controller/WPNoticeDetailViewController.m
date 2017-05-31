//
//  WPNoticeDetailViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/5/11.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPNoticeDetailViewController.h"
#import "GroupNoticeCell.h"
#import "WPCreateGroupNoticeViewController.h"
#import "RKAlertView.h"
#import "MTTDatabaseUtil.h"
@interface WPNoticeDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WPNoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    if (self.noticeId.length)
    {
        [self reloadData];
    }
    else
    {
      [self.tableView reloadData];
    }
//    [self.tableView reloadData];
//    [self reloadData];
}

- (void)initNav
{
    self.view.backgroundColor = BackGroundColor;
    self.title = @"公告详情";
    if ([self.gtype isEqualToString:@"1"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    }
    
}

- (void)rightBtnClick
{
    WPCreateGroupNoticeViewController *create = [[WPCreateGroupNoticeViewController alloc] init];
    create.infoModel = self.infoModel;
    create.mouble = self.mouble;
    create.model = self.model;
    create.isEditing = YES;
    create.groupId = self.groupID;
    create.currentIndex = self.clickIndex;
    create.modifiedSuccessBlock = ^(){
        [MBProgressHUD createHUD:@"修改公告成功！" View:self.view];
        [self reloadData];
        if (self.changeNotice) {
            self.changeNotice(self.clickIndex);
        }
    };
    [self.navigationController pushViewController:create animated:YES];

}

#pragma mark - 请求数据
- (void)reloadData
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_notice.ashx"];
    NSDictionary *params = @{@"action" : @"GetNotice",
                             @"id" : self.noticeId.length?self.noticeId:self.model.notice_id,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"user_id" : kShareModel.userId};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@",json);
        GroupNoticeModel *model = [GroupNoticeModel mj_objectWithKeyValues:json];
        _model = model.list[0];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark tableView
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];//BackGroundColor
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_topLayoutGuide);
            make.left.right.bottom.equalTo(self.view);
        }];
        
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupNoticeCell *cell = [GroupNoticeCell cellWithTableView:tableView];
    cell.isDetail = YES;
    if ([self.gtype isEqualToString:@"1"]) {
        cell.isOwner = YES;
    } else {
        cell.isOwner = NO;
    }
    cell.deleteBlock = ^(NSIndexPath *index){
        [RKAlertView showAlertWithTitle:@"提示" message:@"你确定要删除该条公告吗？" cancelTitle:@"取消" confirmTitle:@"确定" confrimBlock:^(UIAlertView *alertView) {
            [self deleteWithIndex:index];
        } cancelBlock:^{
            
        }];
    };
    cell.model = self.model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupNoticeCell *cell = [GroupNoticeCell cellWithTableView:tableView];
    CGFloat height = [cell calculateHeightWithInfo:self.model isDetail:YES];
    return height;
}

- (void)deleteWithIndex:(NSIndexPath *)indexPath
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_notice.ashx"];
//    GroupNoticeListModel *noticeModel = self.dataSource[indexPath.row];
    NSDictionary *params = @{@"action" : @"DelNotice",
                             @"id" : self.model.notice_id,
                             @"group_id" : self.infoModel.group_id,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"user_id" : kShareModel.userId};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"status"] integerValue] == 0) {
            [MBProgressHUD createHUD:@"删除公告成功!" View:self.view];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.deletActionBlock) {
                self.deletActionBlock(self.clickIndex);
            }
            //数据库中删除
            [[MTTDatabaseUtil instance] deleteGroupGongGao:self.infoModel.group_id gong:self.model.notice_id];
            
        }
    } failure:^(NSError *error) {
        
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
