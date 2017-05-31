//
//  WPChattingSingleEditViewController.m
//  WP
//
//  Created by CBCCBC on 16/6/27.
//  Copyright © 2016年 WP. All rights reserved.
//  聊天设置界面,个人的

#import "WPChattingSingleEditViewController.h"
#import "MTTGroupInfoCell.h"
#import "DDUserModule.h"
#import "PersonalInfoViewController.h"
#import "MTTNotification.h"
#import "ShieldGroupMessageAPI.h"
#import "MTTDatabaseUtil.h"
#import "WPChooseLinkViewController.h"
#import "ReportViewController.h"
#import "ChattingModule.h"
#import "MTTMessageEntity.h"
@interface WPChattingSingleEditViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *tableView;     //tableView
@property (nonatomic,strong) UIView *tableHeaderView;    //tableView Header
@property (nonatomic,strong) NSArray *dataSource; //tableView dataSource
@property (nonatomic,strong) MTTUserEntity *user;
@property (nonatomic, strong)ChattingModule*module;

@end

@implementation WPChattingSingleEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"聊天设置";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = @[@[@"置顶聊天",
                      @"消息免打扰"],
//                    @[@"聊天文件"],
//                    @[@"设置当前聊天背景",
//                      @"查找聊天内容"],
                    @[@"清空聊天记录"],
                    @[@"举报"]];
    
    [[DDUserModule shareInstance] getUserForUserID:self.session.sessionID Block:^(MTTUserEntity *user) {
        if (user) {
            self.user = user;
            [self.tableView reloadData];
        }
    }];
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.backgroundColor = BackGroundColor;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64));
            make.left.mas_equalTo(0);
        }];
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
    
    return _tableView;
}

#pragma mark - tableView的头视图
- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(89))];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        CGFloat y = (kHEIGHT(89) - kHEIGHT(54) - kHEIGHT(10) - 8)/2;
        CGFloat clip = (SCREEN_WIDTH - kHEIGHT(54)*4 - 32)/3;
        UIButton *iconBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        iconBtn.layer.cornerRadius = 5;
        iconBtn.clipsToBounds = YES;
        [iconBtn sd_setBackgroundImageWithURL:URLWITHSTR([IPADDRESS stringByAppendingString:self.user.avatar]) forState:UIControlStateNormal];
        [_tableHeaderView addSubview:iconBtn];
        [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.size.mas_equalTo(CGSizeMake(kHEIGHT(54), kHEIGHT(54)));
            make.top.mas_equalTo(y);
        }];
        
        [iconBtn bk_addEventHandler:^(id sender) {
            NSLog(@"点击头像");
            PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
            info.friendID = [self.user.objID substringFromIndex:5];
            info.newType = NewRelationshipTypeFriend;
            [self.navigationController pushViewController:info animated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nickLabel.textAlignment = NSTextAlignmentCenter;
        nickLabel.font = kFONT(10);
//        nickLabel.text = @"你好啊";
        nickLabel.text = self.user.nick;
        [_tableHeaderView addSubview:nickLabel];
        [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.equalTo(iconBtn.mas_bottom).offset(8);
            make.size.mas_equalTo(CGSizeMake(kHEIGHT(54), kHEIGHT(10)));
        }];
        
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"member_add"] forState:UIControlStateNormal];
        [_tableHeaderView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconBtn.mas_right).offset(clip);
            make.top.mas_equalTo(iconBtn.mas_top);
            make.size.mas_equalTo(CGSizeMake(kHEIGHT(54), kHEIGHT(54)));
        }];
        
        [addBtn bk_addEventHandler:^(id sender) {
            NSLog(@"添加新成员");
            WPChooseLinkViewController * add = [[WPChooseLinkViewController alloc] init];
//            add.isComeFromChatting = YES;
            add.isFromSingle = YES;
            add.addType = ChooseLinkTypeChatGroup;
            add.currentUserId = [self.user.objID substringFromIndex:5];
            [self.navigationController pushViewController:add animated:YES];
        } forControlEvents:UIControlEventTouchUpInside];

        
    }
    return _tableHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ChatEditCellIdentifier";
    MTTGroupInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MTTGroupInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell showDesc:self.dataSource[indexPath.section][indexPath.row]];
    if (indexPath.section == 0) {
        [cell showSwitch];
        if (indexPath.row == 0) {//置顶消息
            if([MTTUtil checkFixedTop:self.session.sessionID]){
                [cell opSwitch:YES];
            }else{
                [cell opSwitch:NO];
            }
            [cell setChangeSwitch:^(BOOL on){
                if(on){
                    [MTTUtil setFixedTop:self.session.sessionID];
                }else{
                    [MTTUtil removeFixedTop:self.session.sessionID];
                }
                self.session.isFixedTop = on;
                [[MTTDatabaseUtil instance] updateRecentSessions:@[self.session] completion:^(NSError *error) {
                }];
                [MTTNotification postNotification:MTTNotificationSessionShieldAndFixed userInfo:nil object:nil];
            }];
        } else {//消息免打扰
            [cell opSwitch:self.session.isShield];
            [cell setChangeSwitch:^(BOOL on){
                [self switchIsAddShielding:on];
                //将免打扰的session存到本地
//                NSUserDefaults * standDefault = [NSUserDefaults standardUserDefaults];
//                NSArray * array = [standDefault objectForKey:@"sessionArray"];
//                NSMutableArray * muSessionArray = [NSMutableArray array];
//                [muSessionArray addObjectsFromArray:array];
//                if (on)
//                {
//                    
//                }
//                else
//                {
//                
//                }
                
                
            }];
            
            
        
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        [cell showArrow];
    }
    return cell;
}

#pragma mark - 消息免打扰
-(void)switchIsAddShielding:(BOOL)on
{
    
    self.session.isShield= on;
    [MTTNotification postNotification:MTTNotificationSessionShieldAndFixed userInfo:nil object:nil];
    [[MTTDatabaseUtil instance] updateRecentSessions:@[self.session] completion:^(NSError *error) {
        
    }];

//    ShieldGroupMessageAPI *request = [ShieldGroupMessageAPI new];
//    NSMutableArray *array = [NSMutableArray new];
//    [array addObject:self.session.sessionID];
//    if (on) {
//        [array addObject:@(1)];
//    }else
//    {
//        [array addObject:@(0)];
//    }
//    [request requestWithObject:array Completion:^(id response, NSError *error) {
//        if (error) {
//            return ;
//        }
//        self.session.isShield=!self.session.isShield;
//        [MTTNotification postNotification:MTTNotificationSessionShieldAndFixed userInfo:nil object:nil];
//        [[MTTDatabaseUtil instance] updateRecentSessions:@[self.session] completion:^(NSError *error) {
//            
//        }];
//    }];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(43);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {//清空记录
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认清空聊天记录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    
    if (indexPath.section == 2) {//举报
        NSArray * userArr = [self.session.sessionID componentsSeparatedByString:@"_"];
        NSString * userId = [NSString stringWithFormat:@"%@",userArr[1]];
        ReportViewController *report = [[ReportViewController alloc] init];
        report.speak_trends_id = userId;
        report.type = ReportTypeUser;
        [self.navigationController pushViewController:report animated:YES];
  
    }
    
//    ReportViewController *report = [[ReportViewController alloc] init];
//    report.speak_trends_id = self.inforModel.group_id;
//    report.type = ReportTypeGroup;
//    [self.navigationController pushViewController:report animated:YES];
}
- (ChattingModule*)module
{
    if (!_module)
    {
        _module = [[ChattingModule alloc] init];
    }
    return _module;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
//        MTTSessionEntity * session =[[MTTSessionEntity alloc]initWithSessionID:[NSString stringWithFormat:@"group_%@",self.groupId] type:SessionTypeSessionTypeGroup];
        //            [[MTTDatabaseUtil instance] deleteMesagesForSession:[NSString stringWithFormat:@"group_%@",self.groupId] completion:^(BOOL success) {
        self.module.MTTSessionEntity = self.session;
        [self.module loadMoreHistoryCompletion:^(NSUInteger addcount, NSError *error) {
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
                        NSLog(@"清空成功");
                    }];
                    //                            从服务器清除
                    [self deleteMessage:[NSString stringWithFormat:@"%lu",(unsigned long)message.msgID] andType:type];
                    if (message == self.module.showingMessages[self.module.showingMessages.count-1]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CLEARALLCHATMESSAGE" object:nil];
                    }
                }
            }
        }];
    }
}

-(void)deleteMessage:(NSString *)messageId andType:(NSString*)typeStr
{
//    MTTSessionEntity * session =[[MTTSessionEntity alloc]initWithSessionID:[NSString stringWithFormat:@"group_%@",self.groupId] type:SessionTypeSessionTypeGroup];
    NSString * string = (self.session.sessionType == SessionTypeSessionTypeSingle)?@"2":@"1";
    
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
