//
//  WPGroupSettingViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/4/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGroupSettingViewController.h"
#import "WPGroupSettingCell.h"
#import "WPGroupInfoEditingViewController.h"
#import "WPMessageAlertViewController.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "HJCActionSheet.h"
#import "ReportViewController.h"
#import "WPTransferGroupOwnerViewController.h"
#import "RKAlertView.h"
#import "WPDynamicGroupViewController.h"
#import "DDDeleteMemberFromGroupAPI.h"
#import "MTTGroupEntity.h"
#import "SessionModule.h"
#import "MTTSessionEntity.h"
#import "DDGroupModule.h"
#import "MTTDatabaseUtil.h"
#import "ChattingModule.h"
#import "MTTMessageEntity.h"
#import "MTTNotification.h"
@interface WPGroupSettingViewController ()<UITableViewDelegate,UITableViewDataSource,HJCActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong)  ChattingModule * module;
@end

@implementation WPGroupSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDataSource];
    [self initNav];
    [self.tableView reloadData];
}

- (void)initNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"群设置";
}
- (ChattingModule*)module
{
    if (!_module)
    {
        _module = [[ChattingModule alloc] init];
    }
    return _module;
}
- (void)initDataSource
{
    NSString *is_sond = [[NSString alloc] init];
//    is_sond = @"";
    if ([self.inforModel.is_sound isEqualToString:@"0"]) {
        is_sond = @"有声模式";
    } else if ([self.inforModel.is_sound isEqualToString:@"1"]) {
        is_sond = @"无声模式";
    } else {
        
        if (self.inforModel.is_sound.length && ![self.inforModel.is_sound isEqualToString:@"(null)"]) {
           is_sond = @"屏蔽群消息";
        }
        else
        {
          is_sond = @"有声模式";
        }
        
//        is_sond = @"屏蔽群消息";
    }
    if ([self.gtype isEqualToString:@"1"]) {
        if (self.isFromZhiChang)
        {
            self.data = @[@[
                              @{@"title" : @"群编辑",
                              @"subTitle" : @"",
                              @"isArr" : @"1"}
                            ],
                          @[@{@"title" : @"群主转移",
                              @"subTitle" : @"",
                              @"isArr" : @"1"},
                            @{@"title" : @"清空聊天记录",
                              @"subTitle" : @"",
                              @"isArr" : @"0"}],
                          @[@{@"title" : @"举报",
                              @"subTitle" : @"",
                              @"isArr" : @"1"}]];
        }
        else
        {
            self.data = @[@[@{@"title" : @"群编辑",
                              @"subTitle" : @"",
                              @"isArr" : @"1"},
                            @{@"title" : @"消息提醒",
                              @"subTitle" : is_sond,
                              @"isArr" : @"1"},
                            ],
                          @[@{@"title" : @"群主转移",
                              @"subTitle" : @"",
                              @"isArr" : @"1"},
                            @{@"title" : @"清空聊天记录",
                              @"subTitle" : @"",
                              @"isArr" : @"0"}],
                          @[@{@"title" : @"举报",
                              @"subTitle" : @"",
                              @"isArr" : @"1"}]];
        }
        
//        self.data = @[@[@{@"title" : @"群编辑",
//                          @"subTitle" : @"",
//                          @"isArr" : @"1"},
//                        @{@"title" : @"消息提醒",
//                          @"subTitle" : is_sond,
//                          @"isArr" : @"1"},
////                        @{@"title" : @"设置聊天背景",
////                          @"subTitle" : @"",
////                          @"isArr" : @"1"}
//                        ],
//                      @[@{@"title" : @"群主转移",
//                          @"subTitle" : @"",
//                          @"isArr" : @"1"},
//                        @{@"title" : @"清空聊天记录",
//                          @"subTitle" : @"",
//                          @"isArr" : @"0"}],
//                      @[@{@"title" : @"举报",
//                          @"subTitle" : @"",
//                          @"isArr" : @"1"}]];
    } else if ([self.gtype isEqualToString:@"2"]) {
        
        if (self.isFromZhiChang)
        {
            self.data = @[
                          @[@{@"title" : @"清空聊天记录",
                              @"subTitle" : @"",
                              @"isArr" : @"0"}],
                          @[@{@"title" : @"举报",
                              @"subTitle" : @"",
                              @"isArr" : @"1"}]];
        }
        else
        {
            self.data = @[
                            @[@{
                                @"title" : @"消息提醒",
                                @"subTitle" : is_sond,
                                @"isArr" : @"1"}],
                          @[@{@"title" : @"清空聊天记录",
                              @"subTitle" : @"",
                              @"isArr" : @"0"}],
                          @[@{@"title" : @"举报",
                              @"subTitle" : @"",
                              @"isArr" : @"1"}]];
        }
        
//        self.data = @[
////                       @[
//////                         @{
//////                            @"title" : @"消息提醒",
//////                          @"subTitle" : is_sond,
//////                          @"isArr" : @"1"},
//////                        @{@"title" : @"设置聊天背景",
//////                          @"subTitle" : @"",
//////                          @"isArr" : @"1"}
////                        ],
//                      @[@{@"title" : @"清空聊天记录",
//                          @"subTitle" : @"",
//                          @"isArr" : @"0"}],
//                      @[@{@"title" : @"举报",
//                          @"subTitle" : @"",
//                          @"isArr" : @"1"}]];
    } else {
        self.data = @[@[@{@"title" : @"举报",
                          @"subTitle" : @"",
                          @"isArr" : @"1"}]];
    }
}

#pragma mark tableView
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = [WPGroupSettingCell rowHeight];
        _tableView.bounces = NO;
        _tableView.backgroundColor = BackGroundColor;
        if ([self.gtype isEqualToString:@"1"] || [self.gtype isEqualToString:@"2"]) {
            _tableView.tableFooterView = self.bottomView;
        }
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

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15 + kHEIGHT(38))];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kHEIGHT(10), 15, SCREEN_WIDTH - 2*kHEIGHT(10), kHEIGHT(38));
        btn.backgroundColor = [UIColor redColor];
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 5;
        if ([self.gtype isEqualToString:@"1"]) {
            [btn setImage:[UIImage imageNamed:@"group_dismiss"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"group_dismiss"] forState:UIControlStateHighlighted];
            [btn setTitle:@"  解散该群" forState:UIControlStateNormal];
        } else if ([self.gtype isEqualToString:@"2"]) {
            [btn setTitle:@"退出该群" forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(204, 37, 37)] forState:UIControlStateHighlighted];
        btn.titleLabel.font = kFONT(15);
        [_bottomView addSubview:btn];
    }
    return _bottomView;
}

- (void)bottomBtnClick
{
    NSString *meaasge;
    if ([self.gtype isEqualToString:@"1"]) {
        meaasge = @"你将退出并解散群组，确认解散吗？";
    } else {
        meaasge = @"确认退出该群？";
    }
    [RKAlertView showAlertWithTitle:@"提示" message:meaasge cancelTitle:@"取消" confirmTitle:@"确认" confrimBlock:^(UIAlertView *alertView) {
        if ([self.gtype isEqualToString:@"1"]) {
            [self dismissGroup];
        } else {
            [self quitGroup];
        }
    } cancelBlock:^{
       
    }];
}

#pragma mark - 退出群组
- (void)quitGroup
{
    [MBProgressHUD showMessage:@"" toView:self.view];
    MTTGroupEntity * group = [[DDGroupModule instance] getGroupByGId:[NSString stringWithFormat:@"group_%@",self.groupId]];
    if (!group) {//本地中找不到群组是需要将群组加入到本地中
        MTTGroupEntity * groupEntity = [[MTTGroupEntity alloc]init];
        groupEntity.objID = [NSString stringWithFormat:@"group_%@",self.groupId];
    
        [[DDGroupModule instance] addGroup:groupEntity];
    }
    [self giveUpGroup];
    
    
    
    
//    DDDeleteMemberFromGroupAPI * delete = [[DDDeleteMemberFromGroupAPI alloc]init];
//    NSArray *array =@[[NSString stringWithFormat:@"group_%@",self.groupId],[NSString stringWithFormat:@"user_%@",kShareModel.userId]];
//    [delete requestWithObject:array Completion:^(id response, NSError *error) {
//        MTTGroupEntity * entitty = (MTTGroupEntity*)response;
//        if (entitty) {
//            NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
//            NSDictionary *params = @{@"group_id" : self.inforModel.group_id,
//                                     @"userID" : kShareModel.userId,
//                                     @"action" : @"outgroup",
//                                     @"username" : kShareModel.username,
//                                     @"password" : kShareModel.password};
//            [WPHttpTool postWithURL:url params:params success:^(id json) {
//                if ([json[@"status"] integerValue] == 0) {
//                    NSArray * viewArray = self.navigationController.viewControllers;
//                    if (self.isFromZhiChang)
//                    {
//                        [self.navigationController popToViewController:viewArray[1] animated:YES];
//                    }
//                    else
//                    {
//                        [self.navigationController popToViewController:viewArray[0] animated:YES];
//                    }
////                    [self.navigationController popToViewController:viewArray[0] animated:YES];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"groupDataUpdate" object:nil];
//                    
//                    MTTSessionEntity *session = [[MTTSessionEntity alloc] initWithSessionID:[NSString stringWithFormat:@"group_%@",self.groupId] type:SessionTypeSessionTypeGroup];
//                    [[SessionModule instance] removeSessionByServer:session];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REMOVESESSIONSUCCES" object:nil];
//                }
//            } failure:^(NSError *error) {
//                
//            }];
//        }
//    }];
}
-(void)giveUpGroup
{
    DDDeleteMemberFromGroupAPI * delete = [[DDDeleteMemberFromGroupAPI alloc]init];
    NSArray *array =@[[NSString stringWithFormat:@"group_%@",self.groupId],[NSString stringWithFormat:@"user_%@",kShareModel.userId]];
    [delete requestWithObject:array Completion:^(id response, NSError *error) {
        MTTGroupEntity * entitty = (MTTGroupEntity*)response;
        if (entitty) {
            NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
            NSDictionary *params = @{@"group_id" : self.inforModel.group_id,
                                     @"userID" : kShareModel.userId,
                                     @"action" : @"outgroup",
                                     @"username" : kShareModel.username,
                                     @"password" : kShareModel.password};
            [WPHttpTool postWithURL:url params:params success:^(id json) {
                [MBProgressHUD hideHUD];
                if ([json[@"status"] integerValue] == 0) {
                    NSArray * viewArray = self.navigationController.viewControllers;
                    if (self.isFromZhiChang)
                    {
                        [self.navigationController popToViewController:viewArray[1] animated:YES];
                    }
                    else
                    {
                        [self.navigationController popToViewController:viewArray[0] animated:YES];
                    }
                    //                    [self.navigationController popToViewController:viewArray[0] animated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"groupDataUpdate" object:nil];
                    
                    MTTSessionEntity *session = [[MTTSessionEntity alloc] initWithSessionID:[NSString stringWithFormat:@"group_%@",self.groupId] type:SessionTypeSessionTypeGroup];
                    [[SessionModule instance] removeSessionByServer:session];
                    
                
                    [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",self.groupId] completion:^(MTTGroupEntity *group) {
                        [group.groupUserIds removeObject:kShareModel.userId];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"REMOVESESSIONSUCCES" object:nil];
                    }];
                    
                    //退出群
                    [[MTTDatabaseUtil instance] deleteGroupMember:self.groupId];
                    [[MTTDatabaseUtil instance] deleteGroupInfoGroupID:self.groupId];
                    [[MTTDatabaseUtil instance] deleteAlbum:self.groupId];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
            }];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD createHUD:@"退出失败!" View:self.view];
        }
    }];
}
#pragma mark - 解散群组
- (void)dismissGroup
{
//    NSLog(@"解散群组");
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    NSMutableArray * muarray = [NSMutableArray array];
    for (MenberListModel*model in self.memberArray) {
        NSString * user_id = [NSString stringWithFormat:@"%@",model.user_id];
        [muarray addObject:[NSString stringWithFormat:@"user_%@",user_id]];
    }
    
       DDDeleteMemberFromGroupAPI * delete = [[DDDeleteMemberFromGroupAPI alloc]init];
      NSArray *array =@[[NSString stringWithFormat:@"group_%@",self.groupId],muarray];
        [delete requestWithObject:array Completion:^(id response, NSError *error) {
            if (response) {
                NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
                NSDictionary *params = @{@"group_id" : self.inforModel.group_id,
                                         @"userID" : kShareModel.userId,
                                         @"action" : @"spreadgroup",
                                         @"username" : kShareModel.username,
                                         @"password" : kShareModel.password,
                                         @"g_id":self.inforModel.g_id};
                
                [WPHttpTool postWithURL:url params:params success:^(id json) {
//                    NSLog(@"%@",json);
                    [MBProgressHUD hideHUDForView:self.view];
                    if ([json[@"status"] integerValue] == 0)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"groupDataUpdate" object:nil];
                        NSArray * viewArray = self.navigationController.viewControllers;
                        if (self.isFromZhiChang)
                        {
                           [self.navigationController popToViewController:viewArray[1] animated:YES];
                        }
                        else
                        {
                         [self.navigationController popToViewController:viewArray[0] animated:YES];
                        }
                        
//                        [self.navigationController popToViewController:viewArray[0] animated:YES];
                        
                        MTTSessionEntity *session = [[MTTSessionEntity alloc] initWithSessionID:[NSString stringWithFormat:@"group_%@",self.groupId] type:SessionTypeSessionTypeGroup];
                        [[SessionModule instance] removeSessionByServer:session];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"REMOVESESSIONSUCCES" object:nil];
                        
                        
                        //解散群
                        [[MTTDatabaseUtil instance] deleteGroupMember:self.groupId];
                        [[MTTDatabaseUtil instance] deleteGroupInfoGroupID:self.groupId];
                        [[MTTDatabaseUtil instance] deleteAlbum:self.groupId];
                        
                    }
                    else
                    {
                        [MBProgressHUD createHUD:json[@"info"] View:self.view];
                    }
                } failure:^(NSError *error) {
                   [MBProgressHUD hideHUD];
                }];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD createHUD:@"解散失败!" View:self.view];
            }
        }];
    
    
    
    
    
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
//    NSDictionary *params = @{@"group_id" : self.inforModel.group_id,
//                             @"userID" : kShareModel.userId,
//                             @"action" : @"spreadgroup",
//                             @"username" : kShareModel.username,
//                             @"password" : kShareModel.password};
//    
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
////        NSLog(@"%@---%@",json,json[@"info"]);
//        if ([json[@"status"] integerValue] == 0) {
//            for (UIViewController *controller in self.navigationController.viewControllers) {
//                if ([controller isKindOfClass:[WPDynamicGroupViewController class]]) {
//                    [self.navigationController popToViewController:controller animated:YES];
//                }
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"groupDataUpdate" object:nil];
//        }
//    } failure:^(NSError *error) {
//        
//    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPGroupSettingCell *cell = [WPGroupSettingCell cellWithTableView:tableView];
    
//    alert.model = self.inforModel;
    
    cell.dict = self.data[indexPath.section][indexPath.row];
    cell.switchState = self.groupSession.isShield;
    cell.mssageSwitch = ^(BOOL isOrNot){
        [self messageIngo:isOrNot];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.gtype isEqualToString:@"1"]) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                [self editeInformation];//群编辑
            } else if (indexPath.row == 1) {
                WPGroupSettingCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.messageSwitch.on = !cell.messageSwitch.on;
                [self messageIngo:cell.messageSwitch.isOn];
                
                [self editeAlert];
            } else if (indexPath.row == 2) {
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {//转移群主
                [self transferGroupOwner];
            } else {
                [self emptyChattingRecords];
            }
        } else {
            [self report];
        }
    } else if ([self.gtype isEqualToString:@"2"]) {
        if (self.isFromZhiChang)
        {
            if(indexPath.section == 0)
                {
                    [self emptyChattingRecords];
                }
                else
                {
                    [self report];
                }
 
        }
        else
        {
            if (indexPath.section == 0)
            {
                if (indexPath.row == 0)
                {
                    [self editeAlert];
                    
                    WPGroupSettingCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.messageSwitch.on = !cell.messageSwitch.on;
                    [self messageIngo:cell.messageSwitch.isOn];
                }
                else
                {
                }
            }
            else if(indexPath.section == 1)
                {
                    [self emptyChattingRecords];
                }
            else
                {
                    [self report];
                }

        }
//        if (indexPath.section == 0)
//        {
//            if (indexPath.row == 0)
//            {
//                [self editeAlert];
//            }
//            else
//            {
//            }
//        }
//        else
//        if(indexPath.section == 0)
//        {
//            [self emptyChattingRecords];
//        }
//        else
//        {
//            [self report];
//        }
    }
    else
    {
        [self report];
    }
}
-(void)messageIngo:(BOOL)isOrNot
{
    self.groupSession.isShield= isOrNot;
    [MTTNotification postNotification:MTTNotificationSessionShieldAndFixed userInfo:nil object:nil];
    [[MTTDatabaseUtil instance] updateRecentSessions:@[self.groupSession] completion:^(NSError *error) {
        
    }];
}
#pragma mark - 群编辑
- (void)editeInformation
{
    WPGroupInfoEditingViewController *editing = [[WPGroupInfoEditingViewController alloc] init];
    editing.arr = self.inforModel.iconList;
    editing.model = self.inforModel;
    editing.groupId = self.groupId;
    editing.mouble = self.mouble;
    editing.groupSession = self.groupSession;
    editing.editingSuccess = ^(){
        [self requestData];
    };
    [self.navigationController pushViewController:editing animated:YES];
}

- (void)requestData
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
    NSDictionary *params = @{@"action" : @"GroupInfo",
                             @"g_id" : self.inforModel.g_id,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"user_id" : kShareModel.userId};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        GroupInformationModel *groupModel = [GroupInformationModel mj_objectWithKeyValues:json];
        self.inforModel = groupModel.json[0];
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark - 消息提醒
- (void)editeAlert
{
    WPMessageAlertViewController *alert = [[WPMessageAlertViewController alloc] init];
    alert.model = self.inforModel;
    alert.groupSession = self.groupSession;
    alert.modifiedSuccess = ^(GroupInformationListModel *newModel){
        self.inforModel = newModel;
        [self initDataSource];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:alert animated:YES];
}

#pragma mark - 设置聊天背景
- (void)editeBackgroungImage
{
    HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册", @"拍照", nil];
    // 2.显示出来
    [sheet show];

}

#pragma mark - 群主转移
- (void)transferGroupOwner
{
    NSLog(@"群主转移");
    WPTransferGroupOwnerViewController *transfer = [[WPTransferGroupOwnerViewController alloc] init];
    transfer.model = self.inforModel;
    transfer.groupId = self.groupId;
    transfer.transferSuccess = ^(){
        //改变数据库中的数
        
        
        
        self.gtype = @"2";
        [self initDataSource];
        [self.tableView reloadData];
        if (self.traneFormSuccess) {
            self.traneFormSuccess();
        }
        
        UIView * bottom = self.tableView.tableFooterView;
        for (UIView * subView in bottom.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton * button = (UIButton*)subView;
                [button setTitle:@"退出该群" forState:UIControlStateNormal];
            }
        }
        
    };
    [self.navigationController pushViewController:transfer animated:YES];
}

#pragma mark - 清空聊天记录
- (void)emptyChattingRecords
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定清空聊天记录？"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 5;
    [alert show];
}

#pragma mark - 举报
- (void)report
{
    ReportViewController *report = [[ReportViewController alloc] init];
    report.speak_trends_id = self.inforModel.group_id;
    report.type = ReportTypeGroup;
    [self.navigationController pushViewController:report animated:YES];
}

#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5) {
        if (buttonIndex == 1) {
            [MBProgressHUD createHUD:@"清空聊天记录" View:self.view];
            //从本地清清除,
            MTTSessionEntity * session =[[MTTSessionEntity alloc]initWithSessionID:[NSString stringWithFormat:@"group_%@",self.groupId] type:SessionTypeSessionTypeGroup];
                self.module.MTTSessionEntity = session;
            [self.module loadAllMessage:^(NSUInteger addcount, NSError *error) {
                for (id objc in self.module.showingMessages) {
                    if ([objc isKindOfClass:[MTTMessageEntity class]]) {
                        MTTMessageEntity * message = (MTTMessageEntity*)objc;
                        NSString * type = [NSString string];
                        DDMessageContentType msgContentType = message.msgContentType;
                        switch (msgContentType) {
                            case DDMessageTypeVoice:
                                type = @"2";
                                break;
                            case DDMessageTypeImage:
                                type = @"3";
                                break;
                            default:
                                type = @"1";
                                break;
                        }
                        [[MTTDatabaseUtil instance] deleteMesages:message completion:^(BOOL success) {
                        }];
                        //                            从服务器清除
                        [self deleteMessage:[NSString stringWithFormat:@"%lu",(unsigned long)message.msgID] andType:type];
                        if (message == self.module.showingMessages[self.module.showingMessages.count-1]) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"CLEARALLCHATMESSAGE" object:nil];
                        }
                    }
                }
 
            }];
//                [self.module loadMoreHistoryCompletion:^(NSUInteger addcount, NSError *error) {
//                    for (id objc in self.module.showingMessages) {
//                        if ([objc isKindOfClass:[MTTMessageEntity class]]) {
//                            MTTMessageEntity * message = (MTTMessageEntity*)objc;
//                            NSString * type = [NSString string];
//                            DDMessageContentType msgContentType = message.msgContentType;
//                            switch (msgContentType) {
//                                case DDMessageTypeVoice:
//                                    type = @"2";
//                                    break;
//                                case DDMessageTypeImage:
//                                    type = @"3";
//                                    break;
//                                default:
//                                    type = @"1";
//                                    break;
//                            }
//                            [[MTTDatabaseUtil instance] deleteMesages:message completion:^(BOOL success) {
//                            }];
////                            从服务器清除
//                            [self deleteMessage:[NSString stringWithFormat:@"%lu",(unsigned long)message.msgID] andType:type];
//                            if (message == self.module.showingMessages[self.module.showingMessages.count-1]) {
//                               [[NSNotificationCenter defaultCenter] postNotificationName:@"CLEARALLCHATMESSAGE" object:nil]; 
//                            }
//                        }
//                    }
//                }];
        }
    }
}

-(void)deleteMessage:(NSString *)messageId andType:(NSString*)typeStr
{
    MTTSessionEntity * session =[[MTTSessionEntity alloc]initWithSessionID:[NSString stringWithFormat:@"group_%@",self.groupId] type:SessionTypeSessionTypeGroup];
    NSString * string = (session.sessionType == SessionTypeSessionTypeSingle)?@"2":@"1";
    
    messageId = [NSString stringWithFormat:@"%@:%@",messageId,typeStr];
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/delmsg.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"delgchatmsg",
                           @"TallType":string,
                           @"MsgID":messageId,
                           @"username":kShareModel.username,
                           @"password":kShareModel.password};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        NSLog(@"删除成功:%@",json);
    } failure:^(NSError *error) {
        
    }];
}


- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
        {
            MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
            // 默认显示相册里面的内容SavePhotos
            pickerVc.status = PickerViewShowStatusCameraRoll;
            pickerVc.minCount = 1;
            [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
            pickerVc.callBack = ^(NSArray *assets){
                for (MLSelectPhotoAssets *asset in assets) {
                    UIImage *image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
                    _backgroundImage = image;
                    [self setBackImageWith:image];
                }
            };
            break;
            
        }
        case 2:
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            
            break;
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    _backgroundImage = image;
    [self setBackImageWith:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 设置聊天背景
- (void)setBackImageWith:(UIImage *)backgroungImage
{
    
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
