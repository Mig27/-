//
//  AddNewFriendController.m
//  WP
//
//  Created by 沈亮亮 on 15/12/24.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "AddNewFriendController.h"

#import "AddLinkButton.h"
#import "WPAllSearchController.h"
#import "LinkmanInfoModel.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "WPHttpTool.h"
#import "WPShareModel.h"
#import "LinkMobileCell.h"
#import "LinkMobileModel.h"
#import "DDUserModule.h"
#import "AppDelegate.h"
//#import "UMSocialControllerService.h"
#import "MobileLinkController.h"
#import "LinkAddViewController.h"
#import "ShareOperation.h"
#import "PersonalInfoViewController.h"
#import "WPAddNewFriendValidateController.h"
#import "MCSearchViewController.h"
#import "WPUpdateFriendStatusHttp.h"
#import "WPDeleteNewFriendInfoHttp.h"
#import "CCAlertView.h"
#import "WPReadSettingHttp.h"
#import "MTTSessionEntity.h"
#import "MTTMessageEntity.h"
#import "MTTDatabaseUtil.h"
#import "ChattingModule.h"
#import "DDMessageModule.h"
#import "DDMessageSendManager.h"
#import "WPAddNewFriendParam.h"
#import "WPAddNewFriendHttp.h"
#import "WPPhoneBookFriendSettingController.h"
#import "WPBlackNameModel.h"
#import "MTTDatabaseUtil.h"

@interface AddNewFriendController ()<UITableViewDataSource,UITableViewDelegate,MCSearchViewControllerDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>{
    
    LinkMobileCell *currentCell;
}
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *linkmanDatasource; /**< 手机联系人 */
@property (nonatomic, strong) NSMutableArray *dataSource;        /**< 数据源 */
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)MCSearchViewController *searchViewController;
@property (nonatomic,weak)UITextField *searchViw;
@property (nonatomic,weak)UIView *searchBar;

@property (nonatomic,strong)LinkMobileListModel *selectedModel;

@property (nonatomic,strong)NSMutableArray *searchData; //搜索过的数据

@property (nonatomic,assign,getter=isSearching)BOOL searching;



@end

@implementation AddNewFriendController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //界面将要出现时获取手机联系人
//    [self address];
//    [self readSetting];
}


// 判断获取通讯录的权限状态
-(void)getAddressStatus{
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        if (kShareModel.show == YES) {
            return;
        }else{
            //更新界面
            CCAlertView * alert = [[CCAlertView alloc]initWithTitle:@"" message:@"快聘无法访问你的通讯录，无法帮你添加朋友。请在系统设置 - 隐私 - 通讯录里允许快聘访问你的通讯录。"];
            [alert addBtnTitle:@"确定" action:^{
                kShareModel.show = YES;
            }];
            [alert showAlertWithSender:self];
        }
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (kShareModel.show == YES) {
                return;
            }else{
                // 更新界面
                CCAlertView * alert = [[CCAlertView alloc]initWithTitle:@"" message:@"快聘无法访问你的通讯录，无法帮你添加朋友。请在系统设置 - 隐私 - 通讯录里允许快聘访问你的通讯录。"];
                [alert addBtnTitle:@"确定" action:^{
                    kShareModel.show = YES;
                }];
                [alert showAlertWithSender:self];
            }
        });
    }
}


//----- 这个方法要实现  不然长按是没有效果的  --------------
- (BOOL)canBecomeFirstResponder{
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MTTDatabaseUtil instance] getNewFriends:^(NSArray *array) {
        if (array.count) {
            NSDictionary * dic = @{@"list":array};
            LinkMobileModel *model = [LinkMobileModel mj_objectWithKeyValues:dic];
            self.dataSource = [[NSMutableArray alloc] initWithArray:model.list];
            [self.tableView reloadData];
        }
    }];
    
    
    
    // Do any additional setup after loading the view.
    self.title = @"新的好友";
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self initDatasource];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
//    [self.view addSubview:self.headView];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self address];
    [self readSetting];
//    [self getAddressStatus];
    
}
-(void)showHud
{
[MBProgressHUD createHUD:@"添加成功" View:self.view];
}
-(void)cintinueOtherOperation:(id)objc
{
    NSDictionary * dictionary = (NSDictionary*)objc;
    NSString * friendId = [NSString stringWithFormat:@"%@",dictionary[@"friengID"]];
    NSString * userName = [NSString stringWithFormat:@"%@",dictionary[@"name"]];
    NSIndexPath * index = dictionary[@"index"];
    PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
    personInfo.friendID = friendId;
    personInfo.newType = NewRelationshipTypeFriend;
    [self.navigationController pushViewController:personInfo animated:YES];
    
    LinkMobileListModel *changeModel = self.dataSource[index.row];
    changeModel.isatt = @"0";//设置为已添加
    //            changeModel.form_state = @"1";
    [self.tableView reloadData];
    //更新数据库中的新的好友
    [[MTTDatabaseUtil instance] upDateNewFriends:self.dataSource];
    
    //从对方的数据库中移除黑名单
    WPPhoneBookFriendSettingController * phoneBook = [[WPPhoneBookFriendSettingController alloc]init];
    [phoneBook sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",friendId] and:@"3"];
    
    //从本地移除添加的黑名单
    WPBlackNameModel * model = [[WPBlackNameModel alloc]init];
    model.userId = [NSString stringWithFormat:@"user_%@",friendId];
    [[MTTDatabaseUtil instance] removeFromBlackName:@[model] completion:^(BOOL success) {
    }];
    
    
    //发条消息给对方
    MTTSessionEntity* session = [[MTTSessionEntity alloc]initWithSessionID:[@"user_" stringByAppendingString:friendId] SessionName:userName type:SessionTypeSessionTypeSingle];
    ChattingModule * mouble = [[ChattingModule alloc]init];
    mouble.MTTSessionEntity = session;
    NSDictionary * dic = @{@"display_type":@"14",
                           @"content":@{@"from_name":[NSString stringWithFormat:@"%@",userName],
                                        @"from_id":[NSString stringWithFormat:@"%@",kShareModel.userId],
                                        @"to_id":[NSString stringWithFormat:@"%@",friendId],
                                        @"from_type":@"0"}
                           };
    NSError * error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
    NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    MTTMessageEntity * message = [MTTMessageEntity makeMessage:cardStr Module:mouble MsgType:DDMEssageAcceptApply];
    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
        DDLog(@"消息插入DB成功");
    } failure:^(NSString *errorDescripe) {
        DDLog(@"消息插入DB失败");
    }];
    message.msgContent = cardStr;
    [[DDMessageSendManager instance] sendMessage:message isGroup:NO Session:session  completion:^(MTTMessageEntity* theMessage,NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            message.state= theMessage.state;
        });
    } Error:^(NSError *error) {
    }];

}
#pragma mark - 通过验证
-(void)passedValidateWithFriendId:(NSString *)friendId nadName:(NSString*)userName  andIndex:(NSIndexPath*)index
{
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPUpdateFriendStatusparam *param = [[WPUpdateFriendStatusparam alloc] init];
    param.action = @"Verification";
    param.friend_id = friendId;
    param.user_id = userInfo[@"userid"];
    param.VerState = @"0";
    param.username = model.username;
    param.password = model.password;
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPUpdateFriendStatusHttp WPUpdateFriendStatusHttpWithParam:param success:^(WPUpdateFriendStatusResult *result) {
        [MBProgressHUD hideHUDForView:self.view];
        if (result.status.intValue == 0) {
            [MBProgressHUD createHUD:@"添加成功" View:self.view];
            NSDictionary * dic = @{@"index":index,@"friengID":friendId,@"name":userName};
            [self performSelector:@selector(cintinueOtherOperation:) withObject:dic afterDelay:0.2];
//            PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
//            personInfo.friendID = friendId;
//            personInfo.newType = NewRelationshipTypeFriend;
//            [self.navigationController pushViewController:personInfo animated:YES];
//            
//            LinkMobileListModel *changeModel = self.dataSource[index.row];
//            changeModel.isatt = @"0";//设置为已添加
////            changeModel.form_state = @"1";
//            [self.tableView reloadData];
//            //更新数据库中的新的好友
//            [[MTTDatabaseUtil instance] upDateNewFriends:self.dataSource];
//            
//            //从对方的数据库中移除黑名单
//            WPPhoneBookFriendSettingController * phoneBook = [[WPPhoneBookFriendSettingController alloc]init];
//            [phoneBook sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",friendId] and:@"3"];
//            
//            //从本地移除添加的黑名单
//            WPBlackNameModel * model = [[WPBlackNameModel alloc]init];
//            model.userId = [NSString stringWithFormat:@"user_%@",friendId];
//            [[MTTDatabaseUtil instance] removeFromBlackName:@[model] completion:^(BOOL success) {
//            }];
//            
//            
//            //发条消息给对方
//            MTTSessionEntity* session = [[MTTSessionEntity alloc]initWithSessionID:[@"user_" stringByAppendingString:friendId] SessionName:userName type:SessionTypeSessionTypeSingle];
//            ChattingModule * mouble = [[ChattingModule alloc]init];
//            mouble.MTTSessionEntity = session;
//            NSDictionary * dic = @{@"display_type":@"14",
//                                   @"content":@{@"from_name":[NSString stringWithFormat:@"%@",userName],
//                                                @"from_id":[NSString stringWithFormat:@"%@",kShareModel.userId],
//                                                @"to_id":[NSString stringWithFormat:@"%@",friendId],
//                                                @"from_type":@"0"}
//                                   };
//            NSError * error = nil;
//            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
//            NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            MTTMessageEntity * message = [MTTMessageEntity makeMessage:cardStr Module:mouble MsgType:DDMEssageAcceptApply];
//            [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
//                DDLog(@"消息插入DB成功");
//            } failure:^(NSString *errorDescripe) {
//                DDLog(@"消息插入DB失败");
//            }];
//            message.msgContent = cardStr;
//            [[DDMessageSendManager instance] sendMessage:message isGroup:NO Session:session  completion:^(MTTMessageEntity* theMessage,NSError *error) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        message.state= theMessage.state;
//                    });
//                } Error:^(NSError *error) {
//            }]; 
        }else{
            [MBProgressHUD createHUD:result.info View:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
}
-(NSString *)getStringFromDic:(NSString*)contentStr
{
    NSDictionary * dic = @{@"display_type":@"1",@"content":contentStr};
    NSError * erreo = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&erreo];
    NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
    
    
}

#pragma mark - 设置已读
-(void)readSetting{
    if ([self.isHaveFriend isEqualToString:@"1"]) {
        WPShareModel *model = [WPShareModel sharedModel];
        NSMutableDictionary *userInfo = model.dic;
        WPReadSettingParam *param = [[WPReadSettingParam alloc] init];
        param.action = @"ReadMessage";
        param.friend_id = self.friend_id;
        param.user_id = userInfo[@"userid"];
        param.username = model.username;
        param.password = model.password;
        
        [WPReadSettingHttp WPReadSettingHttpWithParam:param success:^(WPReadSettingResult *result) {
            if (result.status.intValue == 0) {
            }else{
                [MBProgressHUD createHUD:result.info View:self.view];
            }

        } failure:^(NSError *error) {
//            [MBProgressHUD showError:@"网络不给力哦"];
        }];
        
    }else{
        return;
    }
}



#pragma mark - 删除好友信息
-(void)deleteFriendInfo:(NSString *)friendId{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPDeleteNewFriendInfoParam *param = [[WPDeleteNewFriendInfoParam alloc] init];
    param.action = @"DelNewFriend";
    param.friend_id = friendId;
    param.user_id = userInfo[@"userid"];
    param.username = model.username;
    param.password = model.password;
    param.is_mf = self.selectedModel.is_mf;
    
    [WPDeleteNewFriendInfoHttp WPDeleteNewFriendInfoHttpWithParam:param success:^(WPWPDeleteNewFriendInfoResult *result) {
        if (result.status.intValue == 0) {
            [self address];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD createHUD:result.info View:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
}



- (void)rightButtonClick
{
    NSLog(@"右按钮点击");
    LinkAddViewController *add = [[LinkAddViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}

#pragma mark - 长按处理
-(void)longPressCell:(UILongPressGestureRecognizer *)gestureRecognizer{
    // 判断长按状态
    if ([gestureRecognizer state]==UIGestureRecognizerStateBegan)
    {
        //必须设置为第一响应者
        currentCell = (LinkMobileCell *)gestureRecognizer.view;
        //        currentCell.selected = YES;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:currentCell];
        self.selectedModel =self.dataSource[indexPath.row];
        [currentCell becomeFirstResponder];
        currentCell.selected = YES;
        //得到菜单栏
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        //        [menuController setMenuVisible:NO];
        //设置菜单
        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menuItem:)];
        [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1, nil]];
        //设置菜单栏位置
        [menuController setTargetRect:currentCell.frame inView:currentCell.superview];
        //显示菜单栏
        [menuController setMenuVisible:YES animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
    }
}

//ios开发中，默认是在同一时间只能有一个手势被执行，要实现多个手势同时进行，须实现
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}


- (void)WillHideMenu:(id)sender
{
    currentCell.selected = NO;
}

//点击删除
-(void)menuItem:(id)sender
{
    [self deleteFriendInfo:self.selectedModel.fk_id];
}




#pragma mark - 初始化Datasoure
- (void)initDatasource
{
    self.linkmanDatasource = [NSMutableArray array];
}

- (void)requestData
{
//    [MBProgressHUD showMessage:@"" toView:self.view];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/friend.ashx"]; ///ios/personal_info.ashx
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableArray *arr = [NSMutableArray array];
    
    for (LinkmanInfoModel *model in self.linkmanDatasource) {
        NSDictionary *dic = @{ @"name" : model.name == nil ? @"" : model.name,
                               @"mobile" : model.telephone == nil ? @"" : model.telephone};
        [arr addObject:dic];
    }
    
    NSDictionary *jsonDic = @{@"mobileJson" : arr};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    params[@"action"] = @"NewFriendsList";   //GetNewFans
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    params[@"mobileJson"] = jsonString;
    
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        if ([json[@"list"] count]) {
            [[MTTDatabaseUtil instance] deleteAllNewFriends];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDEBADGAGE" object:nil];
        
//        [MBProgressHUD hideHUDForView:self.view];
        LinkMobileModel *model = [LinkMobileModel mj_objectWithKeyValues:json];
        self.dataSource = [[NSMutableArray alloc] initWithArray:model.list];
        [self.tableView reloadData];
        
        NSArray * array = json[@"list"];
        [[MTTDatabaseUtil instance] upDateNewFriends:array];
        
    } failure:^(NSError *error) {
        [MBProgressHUD createHUD:@"网络错误" View:self.view];
        [[MTTDatabaseUtil instance] getNewFriends:^(NSArray *array) {
            if (array.count) {
                NSDictionary * dic = @{@"list":array};
                LinkMobileModel *model = [LinkMobileModel mj_objectWithKeyValues:dic];
                self.dataSource = [[NSMutableArray alloc] initWithArray:model.list];
                [self.tableView reloadData];
            }
        }];
    }];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = [LinkMobileCell cellHeight];
       
        
        _tableView.tableHeaderView = self.headView;
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //现在取消了关注的情况
    // 添加 -- 等待验证  -- 已添加    接受 -- 进入他的个人资料 -- 已添加
    LinkMobileCell *cell = [LinkMobileCell cellWithTableView:tableView];
    cell.isMobile = NO;
    cell.index = indexPath;
    LinkMobileListModel *model = self.dataSource[indexPath.row];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCell:)];
    [longPressGesture setDelegate:self];
    [cell addGestureRecognizer:longPressGesture];
    
    //点击接受
    cell.clickAccept = ^(NSString *friendId,NSIndexPath* index){
        //将好友信息添加到本地
        [[DDUserModule shareInstance] getUserForUserID:model.user_id Block:^(MTTUserEntity *user) {
        }];
        //点击接受
        [self passedValidateWithFriendId:model.user_id nadName:model.user_name andIndex:index];
    };
    cell.acceptActionBlock = ^(NSString *friendId){
//        //将好友信息添加到本地
////        [[DDUserModule shareInstance] addNewFriend:model.user_id];
//        [[DDUserModule shareInstance] getUserForUserID:model.user_id Block:^(MTTUserEntity *user) {
//        }];
//        
//        //点击接受
//        [self passedValidateWithFriendId:model.user_id nadName:model.user_name];
    };
    cell.opertionAddBlock = ^(NSIndexPath *index,NSString *title){
        NSLog(@"点击");
        if ([title isEqualToString:@"添加"]) {
            //将好友信息添加到本地
            [[DDUserModule shareInstance] addNewFriend:model.user_id];
            
            
            //判断是否在对方列表中
            [MBProgressHUD showMessage:@"" toView:self.view];
            [self isexitOfFriend:model.user_id success:^(id json) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [MBProgressHUD hideHUDForView:self.view];
//                });
                [MBProgressHUD hideHUDForView:self.view];
              NSString * is_shield = [NSString stringWithFormat:@"%@",json[@"is_shield"]];
              if (is_shield.intValue)//被加入黑名单
              { UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"对方拒绝接收你的消息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                    [alert show];
              }
              else
              {
                
                
                NSDictionary * dic = (NSDictionary*)json;
                NSString * is_friend = dic[@"is_friend"];
                if (is_friend.intValue)//在对方好友列表中直接添加成功
                {
                    [MBProgressHUD createHUD:@"添加成功" View:self.view];
                        AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                        if (appDelegate.mobileArr == nil){
                            appDelegate.mobileArr = [NSMutableArray array];
                        }
                        //添加之前还要进行判断，去重
                        for (NSString *str in appDelegate.mobileArr) {
                            if ([str isEqualToString:model.user_id]) {
                                return;
                            }else{
                                [appDelegate.mobileArr addObject:model.user_id];
                            }
                        }
                        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:model.user_id,@"UserId",nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"onlyShowOneTimeWaitValidate" object:self userInfo:dict];
                        LinkMobileListModel *model = self.dataSource[index.row];
                        model.isatt = @"0";//设置为已添加
                        model.form_state = @"1";
                        LinkMobileCell * cell1 = [self.tableView cellForRowAtIndexPath:index];
                        cell1.isMobile = NO;
                        cell1.model = model;
                    
                    //更新数据库中的新的好友
                    [[MTTDatabaseUtil instance] upDateNewFriends:self.dataSource];
                    
                    
                    //发送消息从多方的数据库中删除黑名单
                    WPPhoneBookFriendSettingController * phoneBook = [[WPPhoneBookFriendSettingController alloc]init];
                    [phoneBook sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",model.user_id] and:@"3"];
                }
                else//不在对方好友列表中
                {
                    NSString * moshi = dic[@"moshi"];
                    if (moshi.intValue)//求职招聘模式
                    {
                        [MBProgressHUD createHUD:@"添加成功" View:self.view];
                        AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                        if (appDelegate.mobileArr == nil){
                            appDelegate.mobileArr = [NSMutableArray array];
                        }
                        //添加之前还要进行判断，去重
                        for (NSString *str in appDelegate.mobileArr) {
                            if ([str isEqualToString:model.user_id]) {
                                return;
                            }else{
                                [appDelegate.mobileArr addObject:model.user_id];
                            }
                        }
                        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:model.user_id,@"UserId",nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"onlyShowOneTimeWaitValidate" object:self userInfo:dict];
                        LinkMobileListModel *model = self.dataSource[index.row];
                        model.isatt = @"0";//设置为已添加
                        model.form_state = @"1";
                        LinkMobileCell * cell1 = [self.tableView cellForRowAtIndexPath:index];
                        cell1.isMobile = NO;
                        cell1.model = model;
                        
                        //更新数据库中的新的好友
                        [[MTTDatabaseUtil instance] upDateNewFriends:self.dataSource];
                    
                        //从本地移除添加的黑名单
                        WPBlackNameModel * model1 = [[WPBlackNameModel alloc]init];
                        model1.userId = [NSString stringWithFormat:@"user_%@",model.user_id];
                        [[MTTDatabaseUtil instance] removeFromBlackName:@[model1] completion:^(BOOL success) {
                        }];
                        //发送消息，从对方的数据库中删除黑名单
                        WPPhoneBookFriendSettingController * phoneBook = [[WPPhoneBookFriendSettingController alloc]init];
                        [phoneBook sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",model.user_id] and:@"3"];
                        //发送消息告诉对方添加好友成功
                        [self sendeMessageToOther:model.user_id andUser:nil];
                    }
                    else//正常模式
                    {
                        WPAddNewFriendValidateController *addnew = [[WPAddNewFriendValidateController alloc] init];
                        LinkMobileListModel *model = self.dataSource[indexPath.row];
                        addnew.fuser_id = model.user_id;
                        addnew.friend_mobile = model.mobile;
                        addnew.needPassIsShow = YES;
                        addnew.index = indexPath;
                        addnew.refreshState = ^(NSIndexPath*index){
                           LinkMobileListModel *model = self.dataSource[index.row];
                            model.isatt = @"1";
                            [self.tableView reloadData];
                            
                            //更新数据库中的新的好友
                            [[MTTDatabaseUtil instance] upDateNewFriends:self.dataSource];
                            
                        };
                        [self.navigationController pushViewController:addnew animated:YES];
                    }
                }
            }
            } Failed:^(NSError *error) {
                
            }];
//            [self isExitUserid:model.user_id success:^(id string) {
//                NSString * str =(NSString*)string;
//                if (str.intValue)//不在对方列表中
//                {
//                    WPAddNewFriendValidateController *addnew = [[WPAddNewFriendValidateController alloc] init];
//                    LinkMobileListModel *model = self.dataSource[indexPath.row];
//                    addnew.fuser_id = model.user_id;
//                    addnew.friend_mobile = model.mobile;
//                    addnew.needPassIsShow = YES;
//                    [self.navigationController pushViewController:addnew animated:YES];
//                }
//                else//在对方列表中
//                {
//                    LinkMobileListModel *model = self.dataSource[indexPath.row];
//                    __weak typeof(self) weakSelf = self;
//                    [self addFriendsanf:model.user_id andfriend_mobile:model.mobile success:^(id response) {
//                        LinkMobileListModel *model = weakSelf.dataSource[index.row];
//                        model.isatt = @"1";
//                        model.form_state = @"1";
//                        LinkMobileCell * cell1 = [weakSelf.tableView cellForRowAtIndexPath:index];
//                        cell1.isMobile = NO;
//                        cell1.model = model;
//                    }];
//                }
//            } Failed:^(NSError *error) {
//                [MBProgressHUD createHUD:error.description View:self.view];
//            }];
            //  跳转到验证页面  成功的话则是更改按钮的文字为等待验证(直接刷新数据) 以及按钮状态为不可点击
//            WPAddNewFriendValidateController *addnew = [[WPAddNewFriendValidateController alloc] init];
//            LinkMobileListModel *model = self.dataSource[indexPath.row];
//            addnew.fuser_id = model.user_id;
//            addnew.friend_mobile = model.mobile;
//            addnew.needPassIsShow = YES;
//            [self.navigationController pushViewController:addnew animated:YES];
            
        } else {
        
        }
    };

    cell.model = self.dataSource[indexPath.row];
    return cell;
}
-(void)sendeMessageToOther:(NSString*)friendId andUser:(NSString*)userName
{
    //self.isSendMessageOrNot = NO;
    MTTSessionEntity* session = [[MTTSessionEntity alloc]initWithSessionID:[@"user_" stringByAppendingString:friendId] SessionName:userName type:SessionTypeSessionTypeSingle];
    
    ChattingModule * mouble = [[ChattingModule alloc]init];
    mouble.MTTSessionEntity = session;
    
//    NSDictionary * dic = @{@"display_type":@"14",
//                           @"content":@{@"from_name":[NSString stringWithFormat:@"%@",kShareModel.nick_name],
//                                        @"from_id":[NSString stringWithFormat:@"%@",friendId],
//                                        @"to_id":[NSString stringWithFormat:@"%@",kShareModel.userId]}
//                           };
    
    NSDictionary * dic = @{@"display_type":@"14",
                           @"content":@{@"from_name":[NSString stringWithFormat:@"%@",kShareModel.nick_name],
                                        @"from_id":kShareModel.userId,
                                        @"to_id":friendId,
                                        @"from_type":@"1"}
                           };
    NSError * error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
    NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    MTTMessageEntity * message = [MTTMessageEntity makeMessage:cardStr Module:mouble MsgType:DDMEssageAcceptApply];
    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
        DDLog(@"消息插入DB成功");
    } failure:^(NSString *errorDescripe) {
        DDLog(@"消息插入DB失败");
    }];
    message.msgContent = cardStr;
    [[DDMessageSendManager instance] sendMessage:message isGroup:NO Session:session  completion:^(MTTMessageEntity* theMessage,NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            message.state= theMessage.state;
        });
    } Error:^(NSError *error) {
    }];
}
-(void)addFriendsanf:(NSString*)fuser_id andfriend_mobile:(NSString*)friend_mobile success:(void(^)(id))Success
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPAddNewFriendParam *param = [[WPAddNewFriendParam alloc] init];
    param.action = @"AddFriend";
    param.username = model.username;
    param.password = model.password;
    param.user_id = userInfo[@"userid"];
    param.fuser_id = fuser_id;
    param.is_fjob = @"true";
    param.is_fcircle = @"true";
    param.is_fresume = @"true";
    param.belongGroup = @"请求添加你为好友";
    param.AddFriend = @"1";
    param.is_show = @"0";
    param.friend_mobile = friend_mobile;
    [WPAddNewFriendHttp WPAddNewFriendHttpWithParam:param success:^(WPAddNewFriendResult *result) {
        if (result.status.intValue == 0) {
            Success(result.status);
            AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            if (appDelegate.mobileArr == nil){
                appDelegate.mobileArr = [NSMutableArray array];
            }
            //添加之前还要进行判断，去重
            for (NSString *str in appDelegate.mobileArr) {
                if ([str isEqualToString:fuser_id]) {
                    return;
                }else{
                    [appDelegate.mobileArr addObject:fuser_id];
                }
            }
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:fuser_id,@"UserId",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"onlyShowOneTimeWaitValidate" object:self userInfo:dict];
        }else{
            [MBProgressHUD createHUD:result.info View:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
}
-(void)isExitUserid:(NSString*)userId success:(void(^)(id))Success Failed:(void(^)(NSError*))Failed
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/friend.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"isFriend",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"friend_id":userId};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        Success(json[@"status"]);
    } failure:^(NSError *error) {
        Failed(error);
    }];
}
-(void)isexitOfFriend:(NSString * )userId success:(void(^)(id))Success Failed:(void(^)(NSError*))failed
{
   
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSDictionary * dic = @{@"action":@"AddFriend",
                           @"user_id":userInfo[@"userid"],
                           @"username":model.username,
                           @"password":model.password,
                           @"fuser_id":userId,
                           @"post_remark":@"",
                           @"belongGroup":@"",
                           @"is_fcircle":@"Flase",
                           @"is_fjob":@"Flase",
                           @"is_fresume":@"Flase",
                           @"exec":@"1"};
    
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/friend.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        Success(json);
    } failure:^(NSError *error) {
        failed(error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD createHUD:@"网络错误,请稍后重试" View:self.view];
        });
    }];
}


- (void)attenteUserWith:(NSIndexPath *)indexPath
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/attention.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    LinkMobileListModel *attModel = self.dataSource[indexPath.row];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"attentionSigh";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    params[@"by_user_id"] = attModel.user_id;
    params[@"by_nick_name"] = attModel.user_name;
    //    NSLog(@"*****%@",url);
    //    NSLog(@"#####%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        //        if ([json[@"status"] integerValue] == 1) {
        [self.dataSource removeAllObjects];
        [self requestData];
        //        }
    } failure:^(NSError *error) {
        
    }];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LinkMobileListModel *model = self.dataSource[indexPath.row];
    LinkMobileCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
    personInfo.FriendVC = @"1";
    personInfo.friendID = model.user_id;
    personInfo.comeFromVc = @"新的好友";
    if ([cell.addButton.titleLabel.text isEqualToString:@"已添加"] ||[cell.valiLabel.text isEqualToString:@"已添加"]) {
        personInfo.newType = NewRelationshipTypeFriend;
    }else if ([cell.addButton.titleLabel.text isEqualToString:@"等待验证"]||[cell.valiLabel.text isEqualToString:@"等待验证"]){
        personInfo.newType = NewRelationshipTypeWaitConfirm;
    }else if ([cell.addButton.titleLabel.text isEqualToString:@"添加"]||[cell.valiLabel.text isEqualToString:@"添加"]){
        personInfo.newType = NewRelationshipTypeStranger;
    }else if ([cell.addButton.titleLabel.text isEqualToString:@"接受"]||[cell.valiLabel.text isEqualToString:@"接受"]){
        personInfo.newType = NewRelationshipTypeAccept;
    }
    personInfo.acceptFriends = ^(NSIndexPath*index){
        LinkMobileListModel *model = self.dataSource[index.row];
        model.isatt = @"0";//设置为已添加
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:personInfo animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];


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



- (UIView *)headView
{
    if (_headView == nil) {
        
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44 + kHEIGHT(72))];
        _headView.backgroundColor = RGB(235, 235, 235);

        UIView *searchBar = [[UIView alloc] init];
        searchBar.backgroundColor =  RGBCOLOR(245, 245, 245);
        [self.headView addSubview:searchBar];
        self.searchBar = searchBar;
        
        searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGBCOLOR(240, 240, 240);
        [self.searchBar addSubview:lineView];
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.backgroundColor = [UIColor whiteColor];
        
        
        UIImage *yuyinImage = [UIImage imageNamed:@"MCSearch"];
        [searchBtn setImage:yuyinImage forState:UIControlStateNormal];
        [searchBtn setImage:yuyinImage forState:UIControlStateSelected];
        [searchBtn setImage:yuyinImage forState:UIControlStateHighlighted];
        //top left bottom right
        [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 15)];
        
        NSString *soundButtonTitle = @"搜索";
        [searchBtn setTitle:soundButtonTitle forState:UIControlStateNormal];
        [searchBtn setTitle:soundButtonTitle forState:UIControlStateSelected];
        [searchBtn setTitle:soundButtonTitle forState:UIControlStateHighlighted];
        [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 0)];
        [searchBtn setTitleColor:RGBCOLOR(184, 184, 187) forState:UIControlStateNormal];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)]; //4个参数是上边界，左边界，下边界，右边界。
        
        searchBtn.frame = CGRectMake(0, 0, 200, 30);
        [searchBtn.layer setMasksToBounds:YES];
        [searchBtn.layer setCornerRadius:5.0];
        //设置矩形四个圆角半径
        [searchBtn.layer setBorderWidth:0.2];
        //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
        [searchBtn.layer setBorderColor:colorref];
        
        [searchBtn addTarget:self action:@selector(didClicekedReturnWithKey:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.searchBar addSubview:searchBtn];
        
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchBar);
            make.height.mas_equalTo(@1);
            make.top.right.equalTo(self.searchBar);
        }];
        
        
        [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView.mas_bottom).with.offset(5);
            make.left.equalTo(self.searchBar).with.offset(10);
            make.right.equalTo(self.searchBar).with.offset(-10);
            make.height.mas_equalTo(@30);
        }];

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, searchBar.bottom, SCREEN_WIDTH, kHEIGHT(72))];
        view.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:view];
        
        NSArray *titles = @[@"添加手机好友",@"添加微信好友",@"添加QQ好友"];
        NSArray *icons = @[@"nf_shouji",@"nf_weixin",@"nf_qq"];
        for (int i = 0; i<3; i++) {
            
            
            if (i!=0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*i, 0, 0.5, kHEIGHT(72))];
                line.backgroundColor = RGB(226, 226, 226);
                [view addSubview:line];
            }
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*i, 0, SCREEN_WIDTH/3, kHEIGHT(72))];
            btn.tag = i + 1;
            [btn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[UIImage imageNamed:@"videoPlaceImage"] forState:UIControlStateHighlighted];
            [view addSubview:btn];
            
            CGSize normalSize = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
            CGFloat height = kHEIGHT(72);
            CGFloat width = SCREEN_WIDTH/3;
            CGFloat x = width/2 - kHEIGHT(18)/2;
            CGFloat y = (height - kHEIGHT(18) - 8 -normalSize.height)/2;
            UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, kHEIGHT(18), kHEIGHT(18))];
            iconImage.image = [UIImage imageNamed:icons[i]];
            [btn addSubview:iconImage];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImage.bottom + 8, width, normalSize.height)];
            titleLabel.text = titles[i];
            titleLabel.textColor = RGB(153, 153, 153);
            titleLabel.font = GetFont(12);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:titleLabel];
            
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, btn.bottom-1, SCREEN_WIDTH, 1)];
            bottomLine.backgroundColor = RGB(226, 226, 226);
            [btn addSubview:bottomLine];
            
        }
    }
    return _headView;
}

- (void)addBtnClick:(UIButton *)sender
{
    if (sender.tag == 1) {//手机好友
        MobileLinkController *mobile = [[MobileLinkController alloc] init];
//        mobile.mobileData = self.linkmanDatasource;
        [self.navigationController pushViewController:mobile animated:YES];
    } else if (sender.tag == 2) { //微信好友
//        [self shareToPlatform:@"wxsession"];
        [ShareOperation shareToPlatform:UMSocialPlatformType_WechatSession presentController:self status:nil];
    } else if (sender.tag == 3) { //QQ
//        [self shareToPlatform:@"qq"];
        [ShareOperation shareToPlatform:UMSocialPlatformType_QQ presentController:self status:nil];
    }
}

- (void)shareToPlatform:(NSString *)platform
{
//    NSString *shareText = @"我是快聘，希望大家能够喜欢！ http://www.umeng.com/social";
//    UIImage *shareImage = [UIImage imageNamed:@"图层 14"];
//    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[platform] content:shareText image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity * response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//            [alertView show];
//        } else if(response.responseCode != UMSResponseCodeCancel) {
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//            [alertView show];
//        }
//    }];
}

#pragma mark - 获取通讯录里联系人姓名和手机号
- (void)address
{
//    dataSource = [[NSMutableArray alloc] init];
    //    NSMutableArray *contactsdata= [[NSMutableArray alloc] init];
    //新建一个通讯录类
    
    ABAddressBookRef addressBooks = nil;
    //判断是否在ios6.0版本以上
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0){
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        CFErrorRef* error=nil;
        addressBooks = ABAddressBookCreateWithOptions(NULL, error);
    }
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        LinkmanInfoModel *addressBook = [[LinkmanInfoModel alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        }else {
            if ((__bridge id)abLastName != nil){
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        
        
        NSLog(@"%@",addressBook.name);
        //        addressBook.recordID = (int)ABRecordGetRecordID(person);
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.telephone = (__bridge NSString*)value;
                        NSLog(@"%@",addressBook.telephone);
                        break;
                    }
                        //                    case 1: {// Email
                        //                        addressBook.email = (__bridge NSString*)value;
                        //                        break;
                        //                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [self.linkmanDatasource addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    [self requestData];
}


//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    
//    WPAllSearchController *search = [[WPAllSearchController alloc]init];
//    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:search];
//    [self presentViewController:navc animated:NO completion:nil];
//    
//    return NO;
//}
//

#pragma mark 搜索的代理


- (void)didClicekedReturnWithKey:(NSString *)key
{
    //展示搜索控制器
    [self.searchViewController.resultSource removeAllObjects];
    [self.searchViewController.tableView reloadData];
    self.searchViewController.searchView.text = nil;
    [self.searchViewController.searchView becomeFirstResponder];
    self.searchViewController.cancelColor = [UIColor whiteColor];
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:self.searchViewController animated:YES];
    
}
//点击取消按钮
- (void)searchViewController:(MCSearchViewController *)searchViewController didClickedSearchCancelButton:(UIButton *)button
{
    self.navigationController.navigationBarHidden = NO;
    self.searching = NO;
}

//点击搜索按钮
- (void)searchViewController:(MCSearchViewController *)searchViewController didClickedSearchReturnWithKey:(NSString *)key
{
    self.searching = YES;
    // 直接拿到key来遍历
    for (int i = 0;i < self.dataSource.count; i ++) {
        NSString * str = [self.dataSource[i] user_name];
        if([str rangeOfString:key].location !=NSNotFound){
            [self.searchViewController.resultSource removeAllObjects];
            [self.searchViewController.resultSource addObject:self.dataSource[i]];
            [self.searchViewController.tableView reloadData];
        }else{
        }
    }
 
    
    
}

- (MCSearchViewController *)searchViewController
{
    if (_searchViewController == nil) {
        _searchViewController = [[MCSearchViewController alloc] init];
        _searchViewController.delegate = self;
        
        //设置搜索控制器
        __weak AddNewFriendController *weakSelf = self;
        __weak MCSearchViewController *weakSearch = _searchViewController;
        [_searchViewController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            LinkMobileCell *cell = [LinkMobileCell cellWithTableView:weakSelf.tableView];
            LinkMobileListModel *model = weakSearch.resultSource[indexPath.row];
            cell.model = model;
            return cell;
        }];
        //设置搜索cell的高度
        [_searchViewController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return kHEIGHT(58);
        }];
        ///设置选中cell后的操作
        
        [_searchViewController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            
            LinkMobileListModel *model = weakSearch.resultSource[indexPath.row];
            if (!model) {
                return;
            }
            PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
            personInfo.friendID = model.user_id;
//            UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:personInfo];
//            [weakSelf presentViewController:navc animated:NO completion:nil];
            [weakSelf.navigationController pushViewController:personInfo animated:YES];
        }];
        
    }
    return _searchViewController;
}
@end
