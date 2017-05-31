//
//  WPStrangerSettingController.m
//  WP
//
//  Created by Kokia on 16/5/14.
//  Copyright © 2016年 WP. All rights reserved.
//  陌生人的设置页面

#import "WPStrangerSettingController.h"
#import "WPDragIntoBlackListCell.h"
#import "WPGetFriendInfoHttp.h"
#import "ReportViewController.h"
#import "WPPhoneBookSettingCell.h"
#import "WPDragIntoBlackListHttp.h"
#import "CCAlertView.h"
#import "WPReblackHttp.h"
#import "MTTSessionEntity.h"
#import "ChattingModule.h"
#import "MTTMessageEntity.h"
#import "DDMessageSendManager.h"
#import "WPPersonalSetBlackListController.h"
@interface WPStrangerSettingController ()<UITableViewDelegate,UITableViewDataSource,WPDragIntoBlackListCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) WPGetFriendInfoResult *result;

@end

@implementation WPStrangerSettingController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getSettingInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self initNav];
    [self setupTableView];
}


#pragma mark - 数据相关
-(void)getSettingInfo{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPGetFriendInfoParam *param = [[WPGetFriendInfoParam alloc] init];
    param.action = @"userinfo";
    param.friend_id = self.friendId;
    param.user_id = userInfo[@"userid"];
    
    [WPGetFriendInfoHttp WPGetFriendInfoHttpWithParam:param success:^(WPGetFriendInfoResult *result) {
        self.result = result;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
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
            if (indexPath.row == 0) {
                WPDragIntoBlackListCell *cell= [WPDragIntoBlackListCell cellWithTableView:tableView];
                cell.delegate = self;
                cell.titleLbl.text = @"加入黑名单";
                if (self.isFromBlackList)
                {
                  [cell.switchView setOn:YES animated:YES];
                }
                else
                {
                    if ([self.result.fstate isEqualToString:@"3"]) {
                        [cell.switchView setOn:YES animated:YES];
                    }else{
                        [cell.switchView setOn:NO animated:YES];
                    }
                }
//                if ([self.result.fstate isEqualToString:@"3"]) {
//                    [cell.switchView setOn:YES animated:YES];
//                }else{
//                    [cell.switchView setOn:NO animated:YES];
//                }
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
            if (indexPath.row == 0) {

            }else{
                ReportViewController *jubao = [[ReportViewController alloc] init];
                jubao.speak_trends_id = self.friendId;
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


#pragma mark  点击转换条的代理
- (void)WPDragIntoBlackListCellDidClickedCoverBtn:(WPDragIntoBlackListCell *)WPDragIntoBlackListCell
{
    if (WPDragIntoBlackListCell.switchView.isOn == YES){
        WPShareModel *model = [WPShareModel sharedModel];
        NSMutableDictionary *userInfo = model.dic;
        WPReblackParam *param = [[WPReblackParam alloc] init];
        param.action = @"ReBlack";
        param.username = model.username;
        param.password = model.password;
        param.user_id = userInfo[@"userid"];
        param.friend_id = self.friendId;
        
        [MBProgressHUD showMessage:@"" toView:self.view];
        [WPReblackHttp WPReblackHttpWithParam:param success:^(WPReblackResult *result) {
            [MBProgressHUD hideHUDForView:self.view];
            if (result.status.intValue == 1) {
                [WPDragIntoBlackListCell.switchView setOn:NO animated:YES];
                
                //发送消息移除黑名单
                [self sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",self.friendId] and:@"1"];
                
                if (self.isFromBlackList)//从黑名单中来
                {
                    if (self.pushToBlack) {
                        self.pushToBlack();
                    }
                    NSArray * viewArray = self.navigationController.viewControllers;
                    [self.navigationController popToViewController:viewArray[viewArray.count-3] animated:YES];
                }
               
                
            }else{
                [MBProgressHUD showError:result.info];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"网络不给力哦"];
        }];
        
    }else{
        
        CCAlertView * alert = [[CCAlertView alloc]initWithTitle:@"" message:@"确认加入黑名单？"];
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
            param.friend_id = self.friendId;
            
            [WPDragIntoBlackListHttp WPDragIntoBlackListHttpWithParam:param success:^(WPDragIntoBlackListResult *result) {
                if (result.status.intValue == 1) {
                    // 不要提醒
                    [WPDragIntoBlackListCell.switchView setOn:YES animated:YES];
                    
                    
                    //发送消息加入黑名单
                    [self sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",self.friendId] and:@"0"];
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
@end
