//
//  chatNotiViewController.m
//  WP
//
//  Created by CC on 16/9/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "chatNotiViewController.h"
#import "chatNotificationCell.h"
#import "WPHttpTool.h"
#import "chatNotiModel.h"
#import "DDAddMemberToGroupAPI.h"
#import "joinGroupApplyController.h"
#import "DDMessageSendManager.h"
#import "DDGroupModule.h"
#import "SessionModule.h"
#import "ChattingModule.h"
#import "MTTDatabaseUtil.h"
@interface chatNotiViewController ()<UITableViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, strong)UIButton*button1;
@property (nonatomic, strong)UITableView*tableView;
@property (nonatomic, strong)NSMutableArray*datasource;
@property (nonatomic, strong)chatNotiModel * notiModel;
@property (nonatomic, strong)NSIndexPath*choiseIndexPath;
@property (nonatomic, strong)chatNotificationCell*currentCell;
@property (nonatomic, strong)NSIndexPath*clickIndexpath;
@end

@implementation chatNotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群通知";
    [self initNavc];
    [self.view addSubview:self.tableView];
    [self requstDta];
    // Do any additional setup after loading the view.
}
-(void)requstDta
{
    [MBProgressHUD showMessage:@"" toView:self.view];
    NSDictionary * dic = @{@"action":@"getGroupMsg",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId};
    NSString * urlStr = [NSString stringWithFormat:@"%@/msg/getmsg.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.datasource addObjectsFromArray:json[@"List"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
    
}

-(void)initNavc
{
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button1.frame = CGRectMake(0, 0, 35, 22);
    _button1.titleLabel.font = kFONT(14);
    [_button1 setTitle:@"清空" forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_button1 addTarget:self action:@selector(rightBarBtnItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:_button1];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
#pragma mark 清空
-(void)rightBarBtnItemClick:(UIButton*)sender
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认清空所有消息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1)
    {
        
        if (alertView.tag == 8899)
        {
            NSString * strId = [NSString string];
            strId = [NSString stringWithFormat:@"%@",self.datasource[_choiseIndexPath.row][@"id"]];
            [self clearAllData:@"0" andId:strId];
        }
        else
        {
            NSString * IdStr = [NSString string];
            for (NSDictionary * dic  in self.datasource) {
                if (IdStr.length)
                {
                    IdStr = [NSString stringWithFormat:@"%@,%@",IdStr,dic[@"id"]];
                }
                else
                {
                    IdStr = dic[@"id"];
                }
            }
         [self clearAllData:@"3" andId:IdStr];
        }
    }
}

-(void)clearAllData:(NSString*)type andId:(NSString*)strId
{
    NSDictionary * dic = @{@"action":@"delGroupMsg",@"msg_type":type,@"msg_id":strId};//,@"user_id":kShareModel.userId
    NSString * urlStr = [NSString stringWithFormat:@"%@/msg/delmsg.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        if (json[@"status"]) {
            if ([type isEqualToString:@"3"]) {
                [self.datasource removeAllObjects];
                [self.tableView reloadData];
                if (self.clearAllNoti) {
                    self.clearAllNoti();
                }
            }
            else
            {
                NSArray* array = [NSArray arrayWithArray:self.datasource];
                for (NSDictionary * dic  in array) {
                    if ([dic[@"id"] isEqualToString:strId]) {
                        [self.datasource removeObject:dic];
                    }

                [self.tableView reloadData];
                }
            }
            
            if (self.datasource.count == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"removeAllNotification" object:nil];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
-(NSMutableArray*)datasource
{
    if (!_datasource)
    {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
//        _tableView.backgroundColor = [UIColor redColor];
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(58);
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString * identifier = @"chatNotificationCellidentifier";
    chatNotificationCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[chatNotificationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.indexPath = indexPath;
    cell.model = self.datasource[indexPath.row];
    cell.clickAgree = ^(NSIndexPath*indexPath){//点击同意
        [self clickAgree:indexPath];
    };
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressCell:)];
    longPress.minimumPressDuration = 0.5;
    [cell addGestureRecognizer:longPress];
    return cell;
}

-(void)isFullOrNot:(NSString *)groupId success:(void(^)(id))Success andFailed:(void(^)(NSError*))failed
{
    
    
    NSDictionary * dic = @{@"action":@"IsGroupMember",@"group_id":groupId,@"username":kShareModel.username,@"password":kShareModel.password};
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/Group_member.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        NSString * string = json[@"count"];
        Success(string);
    } failure:^(NSError *error) {
        failed(error);
    }];
}
-(void)clickAgree:(NSIndexPath*)indexPath
{
    
    [self isFullOrNot:self.datasource[indexPath.row][@"group_id"] success:^(id str) {
        NSString * string = (NSString*)str;
        if (string.intValue >= 500)
        {
            [MBProgressHUD createHUD:@"群人数已达上限" View:self.view];
            return ;
        }else if (string.intValue == 0){
            [MBProgressHUD createHUD:@"该群已被解散" View:self.view];
            return;
        }
        else
        {
            _clickIndexpath = indexPath;
            NSDictionary * dict = self.datasource[indexPath.row];
            NSString * b_user_id = [NSString stringWithFormat:@"%@",dict[@"b_user_id"]];
            NSString * actionStr ;
            if (![b_user_id isEqualToString:kShareModel.userId])
            {
                actionStr = @"examineJoin";
            }
            else
            {
                actionStr = @"examineJoin2";
            }
            NSDictionary * dictionary = @{@"action":actionStr,//@"examineJoin"
                                          @"status":@"0",
                                          @"user_id":kShareModel.userId,
                                          @"username":kShareModel.username,
                                          @"password":kShareModel.password,
                                          @"denial":@"",
                                          @"group_id":self.datasource[indexPath.row][@"group_id"],
                                          @"join_nick_name":self.datasource[indexPath.row][@"b_user_name"],
                                          @"join_user_id":self.datasource[indexPath.row][@"b_user_id"]
                                          };
            NSString * urlStr = [NSString stringWithFormat:@"%@/android/Group_member.ashx",IPADDRESS];
            DDAddMemberToGroupAPI *groupApi = [[DDAddMemberToGroupAPI alloc]init];
            __block NSMutableArray * muarray = [NSMutableArray array];
            [muarray addObject:[NSString stringWithFormat:@"user_%@",self.datasource[indexPath.row][@"b_user_id"]]];
            NSArray * array = @[[NSString stringWithFormat:@"group_%@",self.datasource[indexPath.row][@"g_id"]],muarray];
            
            [groupApi requestWithObject:array Completion:^(id response, NSError *error) {
                if (response) {
                    [WPHttpTool postWithURL:urlStr params:dictionary success:^(id json) {
                        NSDictionary * dic = self.datasource[indexPath.row];
                        [dic setValue:@"0" forKey:@"status"];
                        [self.datasource replaceObjectAtIndex:indexPath.row withObject:dic];
                        [self.tableView reloadData];
                        [self sendMessageToGroup];
                        NSDictionary * di = self.datasource[indexPath.row];
                        NSLog(@"%@",di);
                        NSLog(@"审核情况反馈 == %@", json[@"info"]);
                        //改变群组人数group_378
                        [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",dic[@"g_id"]] completion:^(MTTGroupEntity *group) {
                            [group.groupUserIds addObject:self.datasource[indexPath.row][@"b_user_id"]];
                            [group.fixGroupUserIds addObject:self.datasource[indexPath.row][@"b_user_id"]];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEGROUPNUMBER" object:nil];
                        }];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }
            }];
        }
    
    } andFailed:^(NSError *error) {
        [MBProgressHUD createHUD:@"添加失败!" View:self.view];
    }];
    
    
    
//    _clickIndexpath = indexPath;
//    NSDictionary * dict = self.datasource[indexPath.row];
//    NSString * b_user_id = [NSString stringWithFormat:@"%@",dict[@"b_user_id"]];
//    NSString * actionStr ;
//    if (![b_user_id isEqualToString:kShareModel.userId])
//    {
//        actionStr = @"examineJoin";
//    }
//    else
//    {
//        actionStr = @"examineJoin2";
//    }
//    NSDictionary * dictionary = @{@"action":actionStr,//@"examineJoin"
//                                  @"status":@"0",
//                                  @"user_id":kShareModel.userId,
//                                  @"username":kShareModel.username,
//                                  @"password":kShareModel.password,
//                                  @"denial":@"",
//                                  @"group_id":self.datasource[indexPath.row][@"group_id"],
//                                  @"join_nick_name":self.datasource[indexPath.row][@"b_user_name"],
//                                  @"join_user_id":self.datasource[indexPath.row][@"b_user_id"]
//                                  };
//    NSString * urlStr = [NSString stringWithFormat:@"%@/android/Group_member.ashx",IPADDRESS];
//    DDAddMemberToGroupAPI *groupApi = [[DDAddMemberToGroupAPI alloc]init];
//   __block NSMutableArray * muarray = [NSMutableArray array];
//    [muarray addObject:[NSString stringWithFormat:@"user_%@",self.datasource[indexPath.row][@"b_user_id"]]];
//    NSArray * array = @[[NSString stringWithFormat:@"group_%@",self.datasource[indexPath.row][@"g_id"]],muarray];
//    
//    [groupApi requestWithObject:array Completion:^(id response, NSError *error) {
//        if (response) {
//            [WPHttpTool postWithURL:urlStr params:dictionary success:^(id json) {
//                NSDictionary * dic = self.datasource[indexPath.row];
//                [dic setValue:@"0" forKey:@"status"];
//                [self.datasource replaceObjectAtIndex:indexPath.row withObject:dic];
//                [self.tableView reloadData];
//                [self sendMessageToGroup];
//                NSDictionary * di = self.datasource[indexPath.row];
//                NSLog(@"%@",di);
//                //改变群组人数group_378
//                [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",dic[@"g_id"]] completion:^(MTTGroupEntity *group) {
//                    [group.groupUserIds addObject:self.datasource[indexPath.row][@"b_user_id"]];
//                    [group.fixGroupUserIds addObject:self.datasource[indexPath.row][@"b_user_id"]];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEGROUPNUMBER" object:nil];
//                }];
//                
//            } failure:^(NSError *error) {
//                
//            }];
//        }
//    }];
}

-(void)sendMessageToGroup
{
    [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",self.datasource[_clickIndexpath.row][@"g_id"]] completion:^(MTTGroupEntity *group) {
         MTTSessionEntity * session = [[SessionModule instance] getSessionById:group.objID];
        if (!session) {
            session = [[MTTSessionEntity alloc]initWithSessionID:group.objID type:SessionTypeSessionTypeGroup];
        }
        ChattingModule*mouble = [[ChattingModule alloc] init];
        mouble.MTTSessionEntity = session;
        DDMessageContentType msgContentType = DDMEssageLitterInviteAndApply;
       
        
//        NSMutableArray * array = [NSMutableArray array];
//
//        NSDictionary * dic = @{@"mark":[[NSString stringWithFormat:@"%@",self.datasource[_clickIndexpath.row][@"nick_name"]] length]?[NSString stringWithFormat:@"%@",self.datasource[_clickIndexpath.row][@"nick_name"]]:@"",
//                               @"name":[[NSString stringWithFormat:@"%@",self.datasource[_clickIndexpath.row][@"user_name"]] length]?[NSString stringWithFormat:@"%@",self.datasource[_clickIndexpath.row][@"user_name"]]:@"",
//                               @"avatar":[[NSString stringWithFormat:@"%@",self.datasource[_clickIndexpath.row][@"avatar"]] length]?[NSString stringWithFormat:@"%@",self.datasource[_clickIndexpath.row][@"avatar"]]:@"",
//                               @"id":[[NSString stringWithFormat:@"%@",self.datasource[_clickIndexpath.row][@"friend_id"]] length]?[NSString stringWithFormat:@"%@",self.datasource[_clickIndexpath.row][@"friend_id"]]:@""};
//        [array addObject: dic];
//        
//        
//        NSDictionary * tempDic = @{@"list": array};
//        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:tempDic options:NSJSONWritingPrettyPrinted error:nil];
//        NSString * jsonStirng = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

        
        NSDictionary * dictionary = @{@"display_type":@"12",
                                      @"content":@{@"for_userid":self.datasource[_clickIndexpath.row][@"b_user_id"],
                                                   @"for_username":self.datasource[_clickIndexpath.row][@"b_nick_name"],
                                                   @"note_type":@"0",
                                                   @"create_userid":@"",
                                                   @"create_username":@"",
                                                   @"for_user_info_1":@"",
                                                   @"for_user_info_0":@""
                                                   }
                                      };
        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:mouble MsgType:msgContentType];
        [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        message.msgContent = contentStr;
        [[DDMessageSendManager instance] sendMessage:message isGroup:YES Session:session  completion:^(MTTMessageEntity* theMessage,NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        } Error:^(NSError *error) {
            [self.tableView reloadData];
        }];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary * dictionary = self.datasource[indexPath.row];
     NSString * state = [NSString stringWithFormat:@"%@",dictionary[@"status"]];
    if ([state isEqualToString:@"5"])
    {
      [MBProgressHUD createHUD:@"该群已被解散" View:self.view];
        return;
    }
    joinGroupApplyController * jon = [[joinGroupApplyController alloc]init];
    jon.infoDic = self.datasource[indexPath.row];
    jon.indexpath = indexPath;
    jon.listAgree = ^(NSIndexPath*indexpath){
        NSDictionary * dic = self.datasource[indexpath.row];
        [dic setValue:@"0" forKey:@"status"];
        [self.datasource replaceObjectAtIndex:indexpath.row withObject:dic];
        [self.tableView reloadData];
        
//        [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",dic[@"g_id"]] completion:^(MTTGroupEntity *group) {
//            [group.groupUserIds addObject:dic[@"b_user_id"]];
//            [group.fixGroupUserIds addObject:dic[@"b_user_id"]];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEGROUPNUMBER" object:nil];
//        }];
    };
    jon.listReject = ^(NSIndexPath*indexpath){
    
        NSDictionary * dic = self.datasource[indexpath.row];
        [dic setValue:@"3" forKey:@"status"];
        [self.datasource replaceObjectAtIndex:indexpath.row withObject:dic];
        [self.tableView reloadData];
        
    };
    
    NSString * statues = self.datasource[indexPath.row][@"status"];
    jon.title = [statues isEqualToString:@"2"]?@"拒绝申请":([statues isEqualToString:@"4"]?@"移出群主":[statues isEqualToString:@"7"]?@"群主转移":@"加群申请");//@"加群申请"
    NSDictionary * dictio = self.datasource[indexPath.row];
    NSString *a_user_id = [NSString stringWithFormat:@"%@",dictio[@"a_user_id"]];
    NSString *b_user_id = [NSString stringWithFormat:@"%@",dictio[@"b_user_id"]];
    if (![a_user_id isEqualToString:@"0"] && [b_user_id isEqualToString:kShareModel.userId]) {
        
        if (statues.intValue == 4) {
            jon.title = @"移除群组";
        }
        else
        {
          jon.title = @"加群邀请";
        }
    }
    
    if ([a_user_id isEqualToString:kShareModel.userId]) {
        jon.title = @"拒绝邀请";
    }
    
    if  (![b_user_id isEqualToString:kShareModel.userId] && [a_user_id isEqualToString:@"0"])
    {
        if (statues.intValue == 6)
        {
            jon.title = @"退出群组";
        }
    }
    
    
    [self.navigationController pushViewController:jon animated:YES];
}
-(void)longPressCell:(UILongPressGestureRecognizer*)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        _currentCell = (chatNotificationCell*)longPress.view;
        _currentCell.selected = YES;
        
        NSIndexPath* indesPath = [self.tableView indexPathForCell:_currentCell];
        _choiseIndexPath = indesPath;
        [_currentCell becomeFirstResponder];
         UIMenuController * controller = [UIMenuController sharedMenuController];
        [controller setMenuVisible:NO];
        
        UIMenuItem * item = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteOne)];
       
        controller.menuItems = nil;
        [controller setMenuItems:@[item]];
//        [controller setMenuVisible:YES animated:YES];
        [controller setTargetRect:_currentCell.frame inView:_currentCell.superview];
         [controller setMenuVisible:YES animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
    }
}
- (void)WillHideMenu:(id)sender
{
    _currentCell.selected = NO;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}
-(void)deleteOne
{
    
    NSString * strId = [NSString string];
    strId = [NSString stringWithFormat:@"%@",self.datasource[_choiseIndexPath.row][@"id"]];
    [self clearAllData:@"0" andId:strId];
    
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除该消息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//    alert.tag = 8899;
//    [alert show];
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
