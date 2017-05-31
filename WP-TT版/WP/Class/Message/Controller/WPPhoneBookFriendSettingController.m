//
//  WPPhoneBookFriendSettingController.m
//  WP
//
//  Created by Kokia on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//  好友设置页面
//

#import "WPPhoneBookFriendSettingController.h"
#import "WPPhoneBookFriendSettingDetailController.h"
#import "WPGetFriendInfoHttp.h"
#import "ReportViewController.h"
#import "WPPhoneBookSettingSwitchController.h"
#import "WPPhoneBookRecruitSetController.h"
#import "WPSearchJobController.h"
#import "WPDragIntoBlackListHttp.h"
#import "WPRecommendToFriendController.h"
#import "CCAlertView.h"
#import "WPDeleteFriendHttp.h"
#import "WPPhoneBookSettingCell.h"
#import "WPDragIntoBlackListCell.h"
#import "LinkManViewController.h"
#import "AddNewFriendController.h"
#import "WPPersonalSetBlackListController.h"
#import "WPReblackHttp.h"
#import "WPNearbyPeopleController.h"
#import "SessionModule.h"
#import "MTTSessionEntity.h"
#import "DDGroupModule.h"
#import "MobileLinkController.h"
#import "WPBlackNameModel.h"
#import "MTTDatabaseUtil.h"
#import "ChattingModule.h"
#import "MTTMessageEntity.h"
#import "DDMessageSendManager.h"
#import "RecentUsersViewController.h"
#import "WPSendToFriends.h"
#import "WPRecentLinkManController.h"
@interface WPPhoneBookFriendSettingController ()<UITableViewDelegate,UITableViewDataSource,WPDragIntoBlackListCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,strong) WPGetFriendInfoResult *result;

@property (nonatomic,copy) NSString *remarkName;

@property (nonatomic,copy) NSString *categoryName;

@end

@implementation WPPhoneBookFriendSettingController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getSettingInfo];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self getSettingInfo];
    [self initNav];
    [self setupTableView];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRemarkName:) name:@"PostRemarkName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postNewCategoryName:) name:@"PostNewCategoryName" object:nil];
}


#pragma mark - 数据相关
-(void)getSettingInfo{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPGetFriendInfoParam *param = [[WPGetFriendInfoParam alloc] init];
    param.action = @"userinfo";
    param.friend_id = self.friendID;
    param.user_id = userInfo[@"userid"];
    
    [WPGetFriendInfoHttp WPGetFriendInfoHttpWithParam:param success:^(WPGetFriendInfoResult *result) {
        self.result = result;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];

}

-(void)sendeMessageAboutRemove:(NSString*)sendUser and:(NSString*)type
{
    MTTSessionEntity * session = [[MTTSessionEntity alloc]initWithSessionID:sendUser type:SessionTypeSessionTypeSingle];
    ChattingModule*mouble = [[ChattingModule alloc] init];
    mouble.MTTSessionEntity = session;
    DDMessageContentType msgContentType = DDMEssageDeleteOrBlackName;
    NSDictionary * dictionary = @{@"display_type":@"17",
                                  @"content":@{@"friend_id":kShareModel.userId,
                                               @"friend_type":type
                                               }
                                  };
    NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:mouble MsgType:msgContentType];
    message.msgContent = contentStr;
    [[DDMessageSendManager instance] sendMessage:message isGroup:NO Session:session  completion:^(MTTMessageEntity* theMessage,NSError *error) {
    } Error:^(NSError *error) {
    }];
}
#pragma mark 设置黑名单和取消黑名单
- (void)WPDragIntoBlackListCellDidClickedCoverBtn:(WPDragIntoBlackListCell *)WPDragIntoBlackListCell{
    if (WPDragIntoBlackListCell.switchView.isOn == YES) {
        WPShareModel *model = [WPShareModel sharedModel];
        NSMutableDictionary *userInfo = model.dic;
        WPReblackParam *param = [[WPReblackParam alloc] init];
        param.action = @"ReBlack";
        param.username = model.username;
        param.password = model.password;
        param.user_id = userInfo[@"userid"];
        param.friend_id = self.friendID;
        [MBProgressHUD showMessage:@"" toView:self.view];
        [WPReblackHttp WPReblackHttpWithParam:param success:^(WPReblackResult *result) {
            [MBProgressHUD hideHUDForView:self.view];
            if (result.status.intValue == 1) {
                [WPDragIntoBlackListCell.switchView setOn:NO animated:YES];
                
                //从本地数据库中移除黑名单
//                WPBlackNameModel * model = [[WPBlackNameModel alloc]init];
//                model.userId = [NSString stringWithFormat:@"user_%@",self.friendID];
//                [[MTTDatabaseUtil instance] removeFromBlackName:@[model] completion:^(BOOL success) {
//                }];
                
                
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[WPPersonalSetBlackListController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
                //发送移除消息
                [self sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",self.friendID] and:@"1"];
                
            }else{
                
                [MBProgressHUD showError:result.info];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"网络不给力哦"];
        }];
        
    }else{
        CCAlertView * alert = [[CCAlertView alloc]initWithTitle:@"提示" message:@"确认加入黑名单？"];
        [alert addBtnTitle:@"取消" action:^{
            [WPDragIntoBlackListCell.switchView setOn:NO animated:YES];
            return;
        }];
        [alert addBtnTitle:@"确定" action:^{
            WPShareModel *model = [WPShareModel sharedModel];
            NSMutableDictionary *userInfo = model.dic;
            WPDragIntoBlackListParam *param = [[WPDragIntoBlackListParam alloc] init];
            param.action = @"AddBlack";
            param.username = model.username;
            param.password = model.password;
            param.user_id = userInfo[@"userid"];
            param.friend_id = self.friendID;
            [WPDragIntoBlackListHttp WPDragIntoBlackListHttpWithParam:param success:^(WPDragIntoBlackListResult *result) {
                if (result.status.intValue == 1) {
                    //不要提醒
                    [WPDragIntoBlackListCell.switchView setOn:YES animated:YES];
                    
                    //加入到本地数据中
//                    WPBlackNameModel * model = [[WPBlackNameModel alloc]init];
//                    model.userId = [NSString stringWithFormat:@"user_%@",self.friendID];
//                    [[MTTDatabaseUtil instance] updateBlackName:@[model] completion:^(NSError *error) {
//                    }];
                    
                    [self sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",self.friendID] and:@"0"];
                    
                }else{
                    [MBProgressHUD showError:result.info];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"网络不给力哦"];
            }];
            
        }];
        [alert showAlertWithSender:self];
    }

}



-(void)deleteFriendHttp{

    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPDeleteFriendParam *param = [[WPDeleteFriendParam alloc] init];
    param.action = @"DelFriend";
    param.username = model.username;
    param.password = model.password;
    param.user_id = userInfo[@"userid"]; 
    param.friend_id = self.friendID;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPDeleteFriendHttp WPDeleteFriendHttpWithParam:param success:^(WPDeleteFriendResult *result) {
        [MBProgressHUD hideHUDForView:self.view];
        if (result.status.intValue == 0) {
            
            if ([self.comeFromVc isEqualToString:@"黑名单"])
            {
               [self sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",self.friendID] and:@"0"];
            }
            else
            {
              [self sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",self.friendID] and:@"2"];
            }
//            [self sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",self.friendID] and:@"2"];
            
            
            [MBProgressHUD createHUD:result.info View:self.view];
            if ([self.comeFromVc isEqualToString:@"新的好友"]) {
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[AddNewFriendController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }else if([self.comeFromVc isEqualToString:@"黑名单"]){
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[WPPersonalSetBlackListController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }else if([self.comeFromVc isEqualToString:@"附近的人脉"]){
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[WPNearbyPeopleController class]]) {
                        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.ccindex,@"ccindex",nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PopNoGoToTop" object:self userInfo:dict];
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }
            else if ([self.comeFromVc isEqualToString:@"添加手机好友"])
            {
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[MobileLinkController class]]) {
                        if (self.refreshData) {
                            self.refreshData(self.ccindex);
                        }
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }
            else if ([self.comeFromVc isEqualToString:@"话题详情"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGERELATIONSHIP" object:self.ccindex];
                NSArray * array = self.navigationController.viewControllers;
                [self.navigationController popToViewController:array[array.count-3] animated:YES];
            }
            else{
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[LinkManViewController class]]) {
                        if (self.refreshData) {
                            self.refreshData(self.ccindex);
                        }
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                    else if ([temp isKindOfClass:[RecentUsersViewController class]])
                    {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    
                }
            }
            NSArray * array = [[SessionModule instance] getAllSessions];
            for (MTTSessionEntity*session in array) {
                if (session.sessionType == SessionTypeSessionTypeSingle)
                {
                    if ([session.sessionID isEqualToString:[NSString stringWithFormat:@"user_%@",self.friendID]]) {
                        [[SessionModule instance] removeSessionByServer:session];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"REMOVESESSIONSUCCES" object:nil];
                    }
                }
                else
                {
//                    [[DDGroupModule instance] getGroupInfogroupID:session.sessionID completion:^(MTTGroupEntity *group) {
//                        NSArray * array = group.groupUserIds;
//                        for (NSString * string  in array) {
//                            if ([string isEqualToString:self.friendID]) {
//                                [[SessionModule instance] removeSessionByServer:session];
//                            }
//                        }
//                    }];
                }
            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"REMOVESESSIONSUCCES" object:nil];
        }else{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:result.info];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"网络不给力哦"];
    }];

}

#pragma mark - 通知相关
-(void)postRemarkName:(NSNotification *)notice{
    self.remarkName = notice.userInfo[@"RemarkName"];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)postNewCategoryName:(NSNotification *)notice{
    self.categoryName = notice.userInfo[@"CategoryName"];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

-(void)dealloc{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -  初始化UI
- (void)initNav{
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 22);
    [back addTarget:self action:@selector(backToFromVC) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
    imageV.image = [UIImage imageNamed:@"fanhui"];
    [back addSubview:imageV];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
    title.text = @"返回";
    title.font = kFONT(14);
    [back addSubview:title];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

-(void)backToFromVC{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 设置tableView
-(void)setupTableView{
    //设置tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 44) style:UITableViewStyleGrouped];
    self.tableView.delegate= self;
    self.tableView.dataSource= self;
    self.tableView.backgroundColor= RGBCOLOR(238, 238, 238);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = WP_Line_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.tableView.tableFooterView.userInteractionEnabled = YES;

    
}


#pragma mark - 数据源,代理方法

/**
 *  每一行显示怎样的cell
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 2;
            break;
            
        default:
            break;
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            WPPhoneBookSettingCell *cell=  [WPPhoneBookSettingCell cellWithTableView:tableView];
            cell.titleLbl.text = @"设置备注名称";
            if (self.remarkName) {
                cell.detailLbl.text = self.remarkName;
            }else if (self.result.fremark){
                cell.detailLbl.text = self.result.fremark;
            }
            return cell;
        }
            break;
        case 1:{
            if (indexPath.row == 0) {
                WPPhoneBookSettingCell *cell=  [WPPhoneBookSettingCell cellWithTableView:tableView];
                cell.titleLbl.text = @"推荐给好友";
                return cell;
            }else{
                WPPhoneBookSettingCell *cell=  [WPPhoneBookSettingCell cellWithTableView:tableView];
                cell.titleLbl.text = @"设置好友类别";
                if (self.categoryName) {
                    cell.detailLbl.text = self.categoryName;
                }else if (self.result.type_name){
                    cell.detailLbl.text = self.result.type_name;
                }
                return cell;
            }
            
        }
            break;
        case 2:{
            if (indexPath.row == 0) {
                 WPPhoneBookSettingCell *cell=  [WPPhoneBookSettingCell cellWithTableView:tableView];
                cell.titleLbl.text = @"话题设置";
                return cell;
            }else if(indexPath.row == 1){
                WPPhoneBookSettingCell *cell=  [WPPhoneBookSettingCell cellWithTableView:tableView];
                cell.titleLbl.text = @"求职设置";
                return cell;
            }else{
                WPPhoneBookSettingCell *cell=  [WPPhoneBookSettingCell cellWithTableView:tableView];
                cell.titleLbl.text = @"招聘设置";
                return cell;
            }

            
        }
            break;
        case 3:{
            if (indexPath.row == 0) {
                WPDragIntoBlackListCell *cell= [WPDragIntoBlackListCell cellWithTableView:tableView];
                cell.delegate = self;
                cell.titleLbl.text = @"加入黑名单";
                if ([self.result.is_shield isEqualToString:@"1"]) {
                    [cell.switchView setOn:YES];
                }else{
                    [cell.switchView setOn:NO];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                WPPhoneBookSettingCell *cell=  [WPPhoneBookSettingCell cellWithTableView:tableView];
                cell.titleLbl.text = @"举报";
                return cell;
            }

        }
            break;
        default:
            break;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            WPPhoneBookSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            WPPhoneBookFriendSettingDetailController *detail = [[WPPhoneBookFriendSettingDetailController alloc] init];
            detail.vcTitle = cell.titleLbl.text;
            detail.friendID = self.friendID;
            
            //1. 如果备注之前没有设置  直接把好友的名字带过去  如果设置了则显示备注名 所以肯定不为空
            if (self.result.fremark.length>0){
                detail.TFContent = self.result.fremark;
            }else{
                detail.TFContent = self.result.nick_name;
            }
            //2. 修改了备注名 返回这个页面的时候要刷新显示最新的内容
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 1:{
            if (indexPath.row == 0) {
//                WPRecommendToFriendController *detail = [[WPRecommendToFriendController alloc] init];
//                detail.friendID = self.friendID;
//                [self.navigationController pushViewController:detail animated:YES];
                
                
                WPSendToFriends *toFriends = [[WPSendToFriends alloc]init];
                [toFriends sendPersonalCard:self.personalModel success:^(NSArray *array, NSString *userId, NSString *messageContent, NSString *display_type) {
                    WPRecentLinkManController * linkMan = [[WPRecentLinkManController alloc]init];
                    linkMan.dataSource = array;
                    linkMan.toUserId = userId;
                    linkMan.transStr = messageContent;
                    linkMan.display_type = display_type;
                    [self.navigationController pushViewController:linkMan animated:YES];
                }];
            }else{
                WPPhoneBookSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                WPPhoneBookFriendSettingDetailController *detail = [[WPPhoneBookFriendSettingDetailController alloc] init];
                detail.vcTitle = cell.titleLbl.text;
                detail.friendName = self.result.nick_name;
                detail.friendID = self.friendID;
                [self.navigationController pushViewController:detail animated:YES];

            }
            
        }
            break;
        case 2:{
            if (indexPath.row == 0) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                WPPhoneBookSettingSwitchController *detail = [[WPPhoneBookSettingSwitchController alloc] init];
                detail.vcTitle = cell.textLabel.text;
                detail.friendID = self.friendID;
//                detail.result = self.result;
                [self.navigationController pushViewController:detail animated:YES];
            }else if(indexPath.row == 1){
                WPSearchJobController *detail = [[WPSearchJobController alloc] init];
                detail.friendID = self.friendID;
                detail.result = self.result;
                [self.navigationController pushViewController:detail animated:YES];

            }else{
                WPPhoneBookRecruitSetController *detail = [[WPPhoneBookRecruitSetController alloc] init];
                detail.friendID = self.friendID;
                detail.result = self.result;
                [self.navigationController pushViewController:detail animated:YES];
            }
        }
            break;
        case 3:{
            if (indexPath.row == 0) {
            
            }else{
                ReportViewController *jubao = [[ReportViewController alloc] init];
                jubao.speak_trends_id = self.friendID;
                [self.navigationController pushViewController:jubao animated:YES];
            }
        }
            break;
        default:
            break;
    }
   }
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 3) {
        UIView *footerView = [[UIView alloc] init];
        footerView.userInteractionEnabled = YES;
        UIButton *sendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendMsg setTitle:@"删除好友" forState:UIControlStateNormal];
        [sendMsg setBackgroundColor:RGB(240,43,43)];
        [sendMsg setBackgroundImage:[UIImage imageWithColor:RGB(204,31,31)] forState:UIControlStateHighlighted];
        [sendMsg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendMsg.layer setMasksToBounds:YES];
        [sendMsg.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
        
        [sendMsg addTarget:self action:@selector(deleteFriend) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:sendMsg];
        
        [sendMsg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footerView.mas_centerX);
            make.top.equalTo(footerView.mas_top).with.offset(20);
            make.left.equalTo(footerView.mas_left).with.offset(kHEIGHT(12));
            make.right.equalTo(footerView.mas_right).with.offset(-kHEIGHT(12));
            make.height.equalTo(@(kHEIGHT(38)));
        }];
        
        footerView.backgroundColor = [UIColor clearColor];
        return footerView;

    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 100;
    }
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    return view;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //将分割线拉伸到屏幕的宽度
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



#pragma mark  点击删除好友
-(void)deleteFriend{
    CCAlertView * alert = [[CCAlertView alloc]initWithTitle:@"提示" message:@"确定要删除好友并清空聊天记录?"];
    [alert addBtnTitle:@"取消" action:^{
        
    }];
    [alert addBtnTitle:@"确定" action:^{
        [self deleteFriendHttp];
    }];
    [alert showAlertWithSender:self];

    
}

@end
