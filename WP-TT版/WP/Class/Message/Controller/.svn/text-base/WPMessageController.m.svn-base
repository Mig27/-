//
//  WPMessageController.m
//  WP
//
//  Created by Asuna on 15/5/20.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPMessageController.h"
#import "WPSearchBar.h"
#import "WPMessageModel.h"
#import "WPMessageCell.h"
//#import "XHDemoWeChatMessageTableViewController.h"
#import "RSSocketClinet.h"
#import "LinkManViewController.h"
#import "RSChatMessageModel.h"
#import "WPHttpTool.h"
#import "RSFmdbTool.h"
#import "User.h"
#import "Depart.h"
#import "OfflineMessageModel.h"
#import "WPTabBar.h"
#import "WPTabBarButton.h"
#import "WPMainController.h"

#define HOST @"192.168.1.210"
#define PORT  9999

@interface WPMessageController () <UITextFieldDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UISearchBar* searchBarTwo;
@property (nonatomic, strong) NSMutableArray* messageArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong)   UITableView* tableView;
@property (nonatomic, strong) UISearchDisplayController *mySearchDisplayController;
@end

@implementation WPMessageController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ///self.edgesForExtendedLayout = UIRectEdgeNone;
    [self getOfflineMessages];
//    [self readDataFromDatabase];
//    RSSocketClinet *socketClinet = [RSSocketClinet sharedSocketClinet];
//    //socket连接前先断开连接以免之前socket连接没有断开导致闪退
//    [socketClinet cutOffSocket];
//    socketClinet.disConnectResaon = SocketDidDisConnectReasonByServer;
//    [socketClinet connectServer];
    
//    [self.navigationController.navigationBar setTranslucent:NO];
    [self.view setBackgroundColor:WPColor(235, 235, 235)];
    
    [self.view addSubview:self.searchBarTwo];
    [self.view addSubview:self.tableView];
    
    [self setUpGesture];
    [self setNavbarItem];
    [self setsearchDisplayController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDataSources) name:@"updateList" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notification) name:@"kkkk" object:nil];

}

- (void)notification{
    [self performSelector:@selector(delay) withObject:nil afterDelay:0];
    
}

- (void)delay{
////    self.tabBarController.hidesBottomBarWhenPushed = NO;
//    WPTabBar *tabbar = [[WPTabBar alloc] init];
//    WPTabBarButton *button = (WPTabBarButton *)[tabbar viewWithTag:2];
//    [tabbar jumpTo:button];
//    self.tabBarController.selectedIndex = 2;

    [self.tabBarController setSelectedViewController:self.tabBarController.viewControllers[0]];
}


- (void)updateDataSources
{
    [self.dataSource removeAllObjects];
    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_modals WHERE login_ID = '%@' ORDER BY timestamp DESC",[self getLoginID]];
    NSArray *megArr = [RSFmdbTool queryData:querySql];
    [self.dataSource addObjectsFromArray:megArr];
    NSLog(@"%@",self.dataSource);
    [self.tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateList" object:nil];
}

- (NSString *)getLoginID
{
    NSMutableDictionary *userInfo = kShareModel.dic;
    return userInfo[@"userid"];
}

#pragma mark - 从数据库中读取数据
- (void)readDataFromDatabase
{
    [self.dataSource removeAllObjects];
    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_modals WHERE login_ID = '%@'",[self getLoginID]];
    NSArray *megArr = [RSFmdbTool queryData:querySql];
    [self.dataSource addObjectsFromArray:megArr];
    NSLog(@"%@",self.dataSource);
}

#pragma mark - 获取离线消息
- (void)getOfflineMessages
{
    NSString *url = @"http://192.168.1.180:8810/getMsg.ashx";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = kShareModel.dic[@"mobile"];
//    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
      NSLog(@"%@",json);
      OfflineMessageModel *model = [OfflineMessageModel mj_objectWithKeyValues:json];
        [self hadleOfflineMessages:model];
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 处理离线消息
- (void)hadleOfflineMessages:(OfflineMessageModel *)offineMessages
{
    NSArray *messages = offineMessages.MsgBegin;
    for (OfflineMsgModel *model in messages) {
        [self writeToDatabaseWithArr:model.MsgList];
        BOOL isExist = [self isExistWithMemberID:model.friendid];
        NotiMessageType type;
        RSChatMessageModel *chatModel;
        if ([model.type isEqualToString:@"3"]) {
            type = MessageTypeText;
            chatModel  = [RSChatMessageModel modelwithName:model.nick_name avatar:model.avatar no:model.friendid.integerValue type:type detail:model.MsgEnd time:model.MsgTime noReadCount:model.noMsg.integerValue loginID:[self getLoginID].integerValue timestamp:model.btime.integerValue];
        }
        if (!isExist) { //不存在，请求头像和昵称，插入消息列表
            [self writeToMessageListWith:chatModel];
        } else {        //存在，更新消息列表
            [self updateListDatabaseWith:chatModel];
        }
    }
    [self updateDataSources];
}

#pragma mark - 将未读数据写入数据库
- (void)writeToDatabaseWithArr:(NSArray *)messages
{
    for (OfflineMsgListModel *model in messages) {
        NotiMessageType type;
        if ([model.type isEqualToString:@"3"]) {
            type = MessageTypeText;
        }
        dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
        dispatch_async(q1, ^{
        User *user = [[User alloc] init];
        user.messageType = type;
        user.messageDetail = model.Msg;
        user.messageFrom = MessageFromOpposite;
        user.messageID = [model.friendid integerValue];
        user.login_ID = [self getLoginID].integerValue;
        user.meaageTime = model.MsgTime;
        user.timestamp = model.Mtime.integerValue;
        [user save];
        });

    }
}

#pragma mark - 将最新的数据插到消息列表
- (void)writeToMessageListWith:(RSChatMessageModel *)model
{
    BOOL success = [RSFmdbTool insertModel:model];
    if (success) {
        NSLog(@"插入消息列表成功");
    } else {
        NSLog(@"插入消息列表失败");
    }
}

#pragma mark - 更新消息列表数据，头像，未读数据，最后一条数据
- (void)updateListDatabaseWith:(RSChatMessageModel *)model
{
    NSString *modifySql = [NSString stringWithFormat:@"UPDATE t_modals SET time = '%@',detail = '%@',avatar = '%@',name = '%@',type = '%zd',amount = '%zd' WHERE ID_No = '%zd' AND login_ID = '%zd'",model.meaageTime, model.messageDetail, model.avatarUrl, model.avatarName, model.messageType,model.noReadCount, model.messageID,model.loginID];
    BOOL success = [RSFmdbTool modifyData:modifySql];
    if (success) {
        NSLog(@"第一种情况更新成功");
    } else {
        NSLog(@"第一种情况更新失败");
    }
}

#pragma mark - 判断这条这个人是否已在数据库中
- (BOOL)isExistWithMemberID:(NSString *)ID
{
    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_modals WHERE ID_No = '%@' AND login_ID = '%@'",ID,[self getLoginID]];
    NSArray *data = [RSFmdbTool queryData:querySql];
    if (data.count == 0) {
        return NO;
    }
    return YES;
}

//#pragma mark -
//- (void)requestInfo
//{
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/userInfo.ashx"];
//    NSDictionary *params = @{@"action" : @"userinfo",
//                             @"mobile" : @"14888888888",
//                             @"username" : kShareModel.username,
//                             @"password" : kShareModel.password};
//    NSLog(@"****%@*****%@",url,params);
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@",json);
//    } failure:^(NSError *error) {
//        
//    }];
//}

- (void)setUpGesture
{
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)setNavbarItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"通讯录" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"plus"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

- (void)leftBtnClick
{
    LinkManViewController *linkMane = [[LinkManViewController alloc] init];
    [self.navigationController pushViewController:linkMane animated:YES];
}

//**************************************处理代理事件**********************************************//
//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchBarTwo.showsCancelButton = YES;
    
    NSArray *subViews;
    
    if (iOS7) {
        subViews = [(_searchBarTwo.subviews[0]) subviews];
    }
    else {
        subViews = _searchBarTwo.subviews;
    }
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
        }];
    }
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformIdentity;
        }];
    }
}


-(void)setsearchDisplayController
{
    _mySearchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBarTwo contentsController:self];
    //_mySearchDisplayController.displaysSearchBarInNavigationBar = NO;
    _mySearchDisplayController.delegate = self;
    _mySearchDisplayController.searchResultsDataSource = self;
    _mySearchDisplayController.searchResultsDelegate = self;
    
}


- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }

    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    RSChatMessageModel *model = self.dataSource[indexPath.row];
//    XHDemoWeChatMessageTableViewController *demo = [[XHDemoWeChatMessageTableViewController alloc] init];
//    demo.chatObj = [NSString stringWithFormat:@"%ld",model.messageID];
//    demo.nick_name = model.avatarName;
//    demo.avatar = model.avatarUrl;
//    [self.navigationController pushViewController:demo animated:YES];
}

- (void)dismissKeyBoard
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    //  [textField resignFirstResponder];
    return YES;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    // 1. 通过类方法快速实例化Cell
    WPMessageCell* cell = [WPMessageCell cellWithTableView:tableView];

    // 2. 使用模型为单元格赋值
    cell.messageModel = self.dataSource[indexPath.row];

    return cell;
}

- (NSMutableArray*)messageArray
{
    if (_messageArray == nil) {
        _messageArray = [WPMessageModel messages];

    }
    return _messageArray;
}

-(UISearchBar *)searchBarTwo
{
    if (_searchBarTwo == nil) {
        self.searchBarTwo = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -4 + 64, SCREEN_WIDTH, SEARCHBARHEIGHT/2+12)];
        self.searchBarTwo.delegate =self;
        self.searchBarTwo.placeholder = @"搜索";
        self.searchBarTwo.tintColor = [UIColor lightGrayColor];
        self.searchBarTwo.autocorrectionType = UITextAutocorrectionTypeNo;
        self.searchBarTwo.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.searchBarTwo.keyboardType = UIKeyboardTypeDefault;
        self.searchBarTwo.backgroundColor = WPColor(235, 235, 235);
        for (UIView *view in self.searchBarTwo.subviews) {
            // for before iOS7.0
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
                break;
            }
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
    }
    return _searchBarTwo;
}

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.frame = CGRectMake(0, HEADVIEWHEIGHT/2-3 + 64, SCREEN_WIDTH, SCREEN_HEIGHT- HEADVIEWHEIGHT/2 - 64 - 49);
        // 分隔线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor = WPColor(235, 235, 235);
        self.tableView.rowHeight = [WPMessageCell rowHeight];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
    
}


- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
    tableView.rowHeight = 58;
}
@end
