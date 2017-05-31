//
//  WPGroupInformationViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/4/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGroupInformationViewController.h"
#import "GroupInformationModel.h"
#import "GroupInformationHeadView.h"
#import "WPGroupInformationCell1.h"
#import "WPGroupInformationCell2.h"
#import "WPGroupInformationCell3.h"

#import "WPGroupIntroduceViewController.h"
#import "ApplyGroupController.h"
#import "WPGroupSettingViewController.h"
#import "WPGroupNoticeViewController.h"
#import "WPNickNameEditViewController.h"
#import "WPGroupPhotoAlbumViewController.h"
#import "WPGroupMemberViewController.h"
#import "WPChooseLinkViewController.h"
#import "MTTDatabaseUtil.h"
#import "DDGroupModule.h"
#import "MTTSessionEntity.h"
#import "ChattingMainViewController.h"
#import "MTTGroupEntity.h"
#import "MTTDatabaseUtil.h"
#import "WPGroupCreateViewController.h"
@interface WPGroupInformationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) GroupInformationListModel *model;
@property (nonatomic, strong) UIView *tableHeadrView;
@property (nonatomic, strong) GroupInformationHeadView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIButton *bottomView;

@end

@implementation WPGroupInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //滑动时能够直接返回群组界面
    NSArray * viewControllerArr = self.navigationController.viewControllers;
    NSMutableArray * muarr = [NSMutableArray array];
    [muarr addObjectsFromArray:viewControllerArr];
    for (id objc in viewControllerArr) {
        if ([objc isKindOfClass:[WPGroupCreateViewController class]]) {
            [muarr removeObject:objc];
        }
    }
    [self.navigationController setViewControllers:muarr];
    
    
    
    [self initDataSource];
    if (!self.isComeChatting) {
        [self.view addSubview:self.bottomView];
    }
//    [self initNav];
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo) name:@"groupUpdate" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo1) name:@"deletegroupUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:DDNotificationReceiveMessage object:nil];

}
-(void)receiveMessage:(NSNotification*)noti
{
    MTTMessageEntity * message = (MTTMessageEntity*)noti.object;
    if (message.msgContentType == DDMEssageLitterInviteAndApply) {
        if ([message.sessionId isEqualToString:[NSString stringWithFormat:@"group_%@",self.group_id]]) {
           self.gtype = @"2";
            
            
            
            [self initDataSource];
            [self requestData];
            
            
            [self.bottomView setTitle:@"  进入群聊" forState:UIControlStateNormal];
            [self.bottomView setImage:[UIImage imageNamed:@"common_liaoliao"] forState:UIControlStateNormal];
            [self.bottomView setImage:[UIImage imageNamed:@"common_liaoliao"] forState:UIControlStateHighlighted];
            if (self.joinSuccees) {
                self.joinSuccees(self.index);
            }
        }
    }
    NSLog(@"%@--%@",message.senderId,message.sessionId);
}
-(void)backToFromViewController:(UIButton *)sender
{
    if (self.isFromCreat)
    {
        NSArray * viewArray = self.navigationController.viewControllers;
        [self.navigationController popToViewController:viewArray[viewArray.count-2] animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"groupUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deletegroupUpdate" object:nil];
}

- (void)updateInfo
{
    [self requestData];
}
- (void)updateInfo1
{
    [self requestData];
}
- (void)initDataSource
{
    if ([self.gtype isEqualToString:@"1"]) {//自己创建
        if (self.isFromZhiChang)
        {
            self.items = @[@[@"群名称",
                             @"群号码",
                             @"群行业",
                             @"群地点",
                             @"群相册",
                             @"群成员",
                             @"群介绍",
                             @"群公告"],
                           @[@"我的群昵称",
                             @"群组隐身"]];
        }
        else
        {
            self.items = @[@[@"群名称",
                             @"群号码",
                             @"群行业",
                             @"群地点",
                             @"群相册",
                             @"群成员",
                             @"群介绍",
                             @"群公告"],
                           @[@"我的群昵称",
                            @"置顶消息",
                             @"群组隐身"]];
        }
        
//        self.items = @[@[@"群名称",
//                         @"群号码",
//                         @"群行业",
//                         @"群地点",
//                         @"群相册",
//                         @"群成员",
//                         @"群介绍",
//                         @"群公告"],
//                       @[@"我的群昵称",
////                         @"置顶消息",
//                         @"群组隐身"]];
    } else if ([self.gtype isEqualToString:@"2"]) {//加入的群
        
        if (self.isFromZhiChang)
        {
            self.items = @[@[@"群名称",
                             @"群号码",
                             @"群行业",
                             @"群地点",
                             @"群相册",
                             @"群成员",
                             @"群介绍",
                             @"群公告"],
                           @[@"我的群昵称",
                             ]];
        }
        else
        {
            self.items = @[@[@"群名称",
                             @"群号码",
                             @"群行业",
                             @"群地点",
                             @"群相册",
                             @"群成员",
                             @"群介绍",
                             @"群公告"],
                           @[@"我的群昵称",
                             @"置顶消息"
                             ]];
        }

//        self.items = @[@[@"群名称",
//                         @"群号码",
//                         @"群行业",
//                         @"群地点",
//                         @"群相册",
//                         @"群成员",
//                         @"群介绍",
//                         @"群公告"],
//                       @[@"我的群昵称",
//                         @"置顶消息"
//                         ]];
        
        
        
    } else if ([self.gtype isEqualToString:@"3"]) {
        self.items = @[@[@"群名称",
                         @"群号码",
                         @"群行业",
                         @"群地点",
                         @"群介绍"]];
    }
}

- (void)initNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.model.group_name;
    NSArray * array = [self.model.group_name componentsSeparatedByString:@","];
    if (array.count>3) {
        self.title = [NSString stringWithFormat:@"%@,%@,%@等",array[0],array[1],array[2]];
    }
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

- (void)rightBtnClick
{
    WPGroupSettingViewController *setting = [[WPGroupSettingViewController alloc] init];
    setting.groupSession = self.groupSession;
    setting.memberArray = self.model.MenberList;
    setting.inforModel = self.model;
    setting.gtype = self.gtype;
    setting.groupId = self.group_id;
    setting.isFromZhiChang = self.isFromZhiChang;
    setting.isFromGroup = YES;
    setting.mouble = self.chatMouble;
    setting.traneFormSuccess = ^(){//转移群主成功
        [self updateInfo];
        self.gtype = @"2";
    };
    [self.navigationController pushViewController:setting animated:YES];
}

- (GroupInformationListModel *)model
{
    if (_model == nil) {
        _model = [[GroupInformationListModel alloc] init];
    }
    return _model;
}

- (UIButton *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
        [_bottomView setBackgroundImage:[UIImage creatUIImageWithColor:RGB(0, 172, 255)] forState:UIControlStateNormal];
//        _bottomView.backgroundColor = RGB(0, 172, 255);
        [_bottomView setTitle:[self.gtype isEqualToString:@"3"] ? @"  申请加入" : @"  进入群聊" forState:UIControlStateNormal];
        [_bottomView setBackgroundImage:[UIImage creatUIImageWithColor:RGB(0, 146, 217)] forState:UIControlStateHighlighted];
        [_bottomView addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView setImage:[UIImage imageNamed:[self.gtype isEqualToString:@"3"] ? @"group_apply" : @"common_liaoliao"] forState:UIControlStateNormal];
        [_bottomView setImage:[UIImage imageNamed:[self.gtype isEqualToString:@"3"] ? @"group_apply" : @"common_liaoliao"] forState:UIControlStateHighlighted];
        _bottomView.titleLabel.font = kFONT(15);
    }
    
    return _bottomView;
}

- (void)bottomBtnClick
{
//    iconListModel
    
    
    
    
    if ([self.gtype isEqualToString:@"3"]) {//申请加入
        NSArray * array = self.model.MenberList;
        if (array.count == 500)
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该群人数已达上限,无法申请加入!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alert show];
        }
        else
        {
            ApplyGroupController *apply = [[ApplyGroupController alloc] init];
            apply.group_id = self.groupId;
            [self.navigationController pushViewController:apply animated:YES];
        }
        
        
//        ApplyGroupController *apply = [[ApplyGroupController alloc] init];
//        apply.group_id = self.groupId;
//        [self.navigationController pushViewController:apply animated:YES];
    } else {
        [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",self.group_id] completion:^(MTTGroupEntity *group) {
            MTTSessionEntity *session = [[MTTSessionEntity alloc] initWithSessionID:group.objID type:SessionTypeSessionTypeGroup];
            session.isFixedTop = group.isFixTop;
            session.lastMsg=@" ";
            session.avatar = [NSString stringWithFormat:@"%@",self.model.iconList.count?[self.model.iconList[0] thumb_path]:@""];
            [[ChattingMainViewController shareInstance] showChattingContentForSession:session];
            [ChattingMainViewController shareInstance].title=group.name;
            [ChattingMainViewController shareInstance].isFromZhiChangCreat = YES;;
            [self.navigationController pushViewController:[ChattingMainViewController shareInstance] animated:YES];
        }];
    }
}

#pragma mark tableView
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        if (self.isComeChatting) {
            _tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        } else {
            _tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.bounces = NO;
        _tableView.backgroundColor = BackGroundColor;
        _tableView.tableHeaderView = self.headView;
        
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

#pragma makr 请求数据
- (void)requestData
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
    NSDictionary *params = @{@"action" : @"GroupInfo",
                             @"g_id" : self.group_id,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"user_id" : kShareModel.userId};
    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
    
        if ([json[@"status"] isEqualToString:@"0"]) {
            [MBProgressHUD createHUD:json[@"info"] View:self.view];
            [self performSelector:@selector(back) afterDelay:1];
            return;
        }
        
        [[MTTDatabaseUtil instance] deleteGroupInfo:self.group_id];
         [[MTTDatabaseUtil instance] upDateGroupInfo:json[@"json"]];
        
        GroupInformationModel *groupModel = [GroupInformationModel mj_objectWithKeyValues:json];
        self.model = groupModel.json[0];
        [self upDateHeader];
        [self initNav];
        self.tableView.tableHeaderView = self.headView;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [[MTTDatabaseUtil instance] getGroupInfo:self.group_id success:^(NSArray *array) {
            if (array.count) {
                NSDictionary * dic = @{@"json":array};
                GroupInformationModel *groupModel = [GroupInformationModel mj_objectWithKeyValues:dic];
                self.model = groupModel.json[0];
                [self upDateHeader];
                [self initNav];
                self.tableView.tableHeaderView = self.headView;
                [self.tableView reloadData];
            }
        }];
        
    }];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (GroupInformationHeadView *)headView
{
    if (!_headView) {
        CGFloat width = (SCREEN_WIDTH - 5*kHEIGHT(10))/4;
        CGFloat height = self.model.iconList.count>4 ? 2*width + 2*15 + kHEIGHT(10) : width + 2*15;
        if (self.model.iconList.count == 0) {
            height = 0;
        }
        _headView = [[GroupInformationHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) andModel:self.model];
//        [self.view addSubview:_headView];
    }
    return _headView;
}

- (void)upDateHeader
{
    CGFloat width = (SCREEN_WIDTH - 5*kHEIGHT(10))/4;
    CGFloat height = self.model.iconList.count>4 ? 2*width + 2*15 + kHEIGHT(10) : width + 2*15;
    if (self.model.iconList.count == 0) {
        height = 0;
    }
    self.headView.height = height;
    [self.headView resetWith:self.model];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items[section] count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *itemString = _items[indexPath.section][indexPath.row];
    
    if ([self.gtype isEqualToString:@"1"] || [self.gtype isEqualToString:@"2"]) {
        if (indexPath.section == 0) {
            if (indexPath.row == 4 || indexPath.row == 5) {
                WPGroupInformationCell2 *cell = [WPGroupInformationCell2 cellWithTableView:tableView];
                if (indexPath.row == 4) {
                    [cell setPhotoWith:self.model.PhotoList andCount:@"" item:itemString isAvatar:NO];//self.model.photoCount
                } else {
                    [cell setPhotoWith:self.model.MenberList andCount:@"" item:itemString isAvatar:YES];//self.model.MenberCount
                    cell.addNewMemberBlock = ^(){//点击添加群成员
                        [self pushMember];
//                        WPChooseLinkViewController *choose = [[WPChooseLinkViewController alloc] init];
//                        choose.numOfMemember = self.model.MenberCount;
//                        choose.addType = ChooseLinkTypeDynamicGroup;
//                        choose.chatMouble = self.chatMouble;
//                        choose.model = _model;
//                        choose.groupId = self.group_id;
//                        [self.navigationController pushViewController:choose animated:YES];
                    };
                }
                return cell;
            } else {
                WPGroupInformationCell1 *cell = [WPGroupInformationCell1 cellWithTableView:tableView];
                cell.itemStr = itemString;
                if (indexPath.row == 0) {
                    cell.milti = NO;
                    cell.lines = 1;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.informationStr = self.model.group_name;
                    NSArray * array = [self.model.group_name componentsSeparatedByString:@","];
                    if (array.count > 3) {
                        cell.informationStr = [NSString stringWithFormat:@"%@,%@,%@等",array[0],array[1],array[2]];
                    }
                } else if (indexPath.row == 1) {
                    cell.milti = NO;
                    cell.lines = 1;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.informationStr = self.model.group_no;
                } else if (indexPath.row == 2) {
                    cell.milti = NO;
                    cell.lines = 1;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.informationStr = self.model.group_Industry;
                } else if (indexPath.row == 3) {
                    cell.milti = NO;
                    cell.lines = 1;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.informationStr = self.model.add_addressDesc;
                } else if (indexPath.row == 6) {
                    cell.milti = YES;
                    cell.lines = 2;
                    cell.informationStr = self.model.group_cont;
                    cell.siAccess = YES;
                } else if (indexPath.row == 7) {
                    cell.milti = YES;
                    cell.lines = 3;
                    cell.siAccess = YES;
                    NSString *string = [[NSString alloc] init];
                    if (self.model.NoticeList.count == 0) {
                        string = @"群主很懒，暂无公告";
                    } else {
                        NoticeListModel *model = self.model.NoticeList[0];
                        string = model.notice;
                    }
                    cell.informationStr = string;
                }
                
                return cell;
            }
            
        } else {
            WPGroupInformationCell3 *cell = [WPGroupInformationCell3 cellWithTableView:tableView];
            cell.index = indexPath;
            if (indexPath.row == 0) {
                cell.isNick = YES;
                cell.isCloaking = NO;
                cell.nickName = self.model.remark_name;
            }
            else if (indexPath.row == 1) {//设置置顶消息
                if (self.isFromZhiChang)
                {
                    cell.isNick = NO;
                    cell.isCloaking = YES;
                    cell.isOn = self.model.is_near;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                else
                {
                    cell.isNick = NO;
                    cell.isCloaking = NO;
                    NSString * string =self.groupSession.isFixedTop?@"1":@"0";
                    cell.isOn = string;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                
//                cell.isNick = NO;
//                cell.isCloaking = NO;
//                cell.isOn = self.model.is_to;
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            else if (indexPath.row == 2) {//设置群组隐身
                cell.isNick = NO;
                cell.isCloaking = YES;
                cell.isOn = self.model.is_near;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.switchActionBlock = ^(NSIndexPath *index, NSString *str){
                [self settingWith:index statue:str];
                if (self.groupSession)
                {
                  self.groupSession.isFixedTop = str.intValue;
                    [[MTTDatabaseUtil instance] updateRecentSession:self.groupSession completion:^(NSError *error) {
                    }];
                }
                else
                {
                    [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",self.group_id] completion:^(MTTGroupEntity *group) {
                        group.isFixTop = !group.isFixTop;
                        [[MTTDatabaseUtil instance] updateRecentGroup:group completion:^(NSError *error) {
                        }];
                    }];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:MTTNotificationSessionShieldAndFixed object:nil];
                
                
            };
            cell.itemStr = itemString;
            return cell;
        }
    } else {//陌生人的群
        WPGroupInformationCell1 *cell = [WPGroupInformationCell1 cellWithTableView:tableView];
        cell.itemStr = itemString;
        if (indexPath.row == 0) {
            cell.milti = NO;
            cell.lines = 1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray * array = [self.model.group_name componentsSeparatedByString:@","];
            if (array.count > 3) {
                cell.informationStr = [NSString stringWithFormat:@"%@,%@,%@等",array[0],array[1],array[2]];
            }
            cell.informationStr = self.model.group_name;
        } else if (indexPath.row == 1) {
            cell.milti = NO;
            cell.lines = 1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.informationStr = self.model.group_no;
        } else if (indexPath.row == 2) {
            cell.milti = NO;
            cell.lines = 1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.informationStr = self.model.group_Industry;
        } else if (indexPath.row == 3) {
            cell.milti = NO;
            cell.lines = 1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.informationStr = self.model.add_addressDesc;
        } else if (indexPath.row == 4) {
            cell.milti = YES;
            cell.lines = 2;
            cell.informationStr = self.model.group_cont;
        }
        return cell;
     }
    
    
}

#pragma mark - 按钮的切换设置
- (void)settingWith:(NSIndexPath *)index statue:(NSString *)statue
{
    if (index.row == 0) {
        return;
    }
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
    NSDictionary *params = @{@"action"   : @"updateGroupOneInfo",
                             @"userID"   : kShareModel.userId,
                             @"group_id" : self.groupId,
                             @"is_near"  : statue,//index.row == 1 ? self.model.is_near : statue
                             @"is_to"    : statue,//index.row == 1 ? statue : self.model.is_to
                             @"is_sound" : self.model.is_sound,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password};
//    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@---%@",json,json[@"info"]);
        if (index.row == 1) {
            self.model.is_to = [self.model.is_to isEqualToString:@"1"] ? @"0" : @"1";
        } else if (index.row == 2) {
            self.model.is_near = [self.model.is_near isEqualToString:@"1"] ? @"0" : @"1";
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.gtype isEqualToString:@"1"] || [self.gtype isEqualToString:@"2"]) {
        if (indexPath.section == 0) {
            if (indexPath.row == 6) {
                return [WPGroupInformationCell1 rowHeightWithString:self.model.group_cont andLines:2 isMulti:YES];
            } else if (indexPath.row == 7) {
                NSString *string = [[NSString alloc] init];
                if (self.model.NoticeList.count == 0) {
                    string = @"";
                } else {
                    NoticeListModel *model = self.model.NoticeList[0];
                    string = model.notice;
                }
                return [WPGroupInformationCell1 rowHeightWithString:string andLines:3 isMulti:YES];
            } else if (indexPath.row == 4 || indexPath.row == 5) {
                return [WPGroupInformationCell2 rowHeight];
            }else {
                return [WPGroupInformationCell1 rowHeightWithString:@"" andLines:1 isMulti:NO];
            }
            
        } else {
//            if (indexPath.row == 0 || indexPath.row == 1) {
//                return kHEIGHT(43);
//            } else {
//                return kHEIGHT(58);
//            }
            
            if (indexPath.row == 0)
            {
                return kHEIGHT(43);
            }
            else if(indexPath.row == 1)
            {
                if (self.isFromZhiChang)
                {
                    return kHEIGHT(58);
                }
                else
                {
                    return kHEIGHT(43);
                }
            }
            else
            {
                return kHEIGHT(58);
            }
            
            
        }
    } else {
        if (indexPath.row == 4) {
            return [WPGroupInformationCell1 rowHeightWithString:self.model.group_cont andLines:2 isMulti:YES];
        } else {
            return [WPGroupInformationCell1 rowHeightWithString:@"" andLines:1 isMulti:NO];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.gtype isEqualToString:@"1"] || [self.gtype isEqualToString:@"2"]) {
        if (indexPath.section == 0) {
            if (indexPath.row == 6) {
                WPGroupIntroduceViewController *introduce = [[WPGroupIntroduceViewController alloc] init];
                introduce.introduce = self.model.group_cont;
                [self.navigationController pushViewController:introduce animated:YES];
            } else if (indexPath.row == 4) {
                NSLog(@"群相册");
                WPGroupPhotoAlbumViewController *album = [[WPGroupPhotoAlbumViewController alloc] init];
                if ([self.gtype isEqualToString:@"1"]) {
                    album.isOwner = YES;
                } else {
                    album.isOwner = NO;
                }
                album.numberOfClume = self.model.photoCount;
                album.model = self.model;
                album.groupId = self.group_id;
                album.isNeedChat = YES;
                album.mouble = self.chatMouble;
                [self.navigationController pushViewController:album animated:YES];
            } else if (indexPath.row == 5) {
                NSLog(@"群成员");
//                WPGroupMemberViewController *member = [[WPGroupMemberViewController alloc] init];
//                member.mouble = self.chatMouble;
//                member.deleteGroupId = self.group_id;
//                member.numOfMemeber = self.model.MenberCount;
//                member.model = self.model;
//                if ([self.gtype isEqualToString:@"1"]) {
//                    member.isOwner = YES;
//                } else {
//                    member.isOwner = NO;
//                }
//                [self.navigationController pushViewController:member animated:YES];
                
                [self pushMember];
                
            } else if (indexPath.row == 7) {
                NSLog(@"群公告");
                WPGroupNoticeViewController *notice = [[WPGroupNoticeViewController alloc] init];
                notice.model = self.model;
                notice.gtype = self.gtype;
                notice.groupId = self.group_id;
                notice.mouble = self.chatMouble;
                [self.navigationController pushViewController:notice animated:YES];
            }
        } else {
            if (indexPath.row == 0) {
                NSLog(@"我的群昵称");
                WPNickNameEditViewController *nameEdit = [[WPNickNameEditViewController alloc] init];
                nameEdit.nickName = self.model.remark_name.length == 0 ? kShareModel.nick_name : self.model.remark_name;
                nameEdit.model = self.model;
                nameEdit.modifyNickSuccess = ^(){
                    [self requestData];
                };
                [self.navigationController pushViewController:nameEdit animated:YES];
            }
        }
    } else {
        if (indexPath.row == 4) {
            WPGroupIntroduceViewController *introduce = [[WPGroupIntroduceViewController alloc] init];
            introduce.introduce = self.model.group_cont;
            [self.navigationController pushViewController:introduce animated:YES];
        }
    }
}
-(void)pushMember
{
    WPGroupMemberViewController *member = [[WPGroupMemberViewController alloc] init];
    member.mouble = self.chatMouble;
    member.deleteGroupId = self.group_id;
    member.numOfMemeber = self.model.MenberCount;
    member.model = self.model;
    if ([self.gtype isEqualToString:@"1"]) {
        member.isOwner = YES;
    } else {
        member.isOwner = NO;
    }
    [self.navigationController pushViewController:member animated:YES];
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
