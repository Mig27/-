//
//  DDRecentUsersViewController.m
//  IOSDuoduo
//
//  Created by 独嘉 on 14-5-26.
//  Copyright (c) 2014年 dujia. All rights reserved.
//
#import "groupNotificationModel.h"
#import "RecentUsersViewController.h"
#import "RecentUserCell.h"
#import "MTTPCStatusCell.h"
#import "inviteNoTableViewCell.h"
#import "RecentGroupMessageCell.h"
#import "DDUserModule.h"
#import "DDMessageModule.h"
#import "ChattingMainViewController.h"
#import "MTTSessionEntity.h"
#import "MTTDatabaseUtil.h"
#import "LoginModule.h"
#import "DDClientState.h"
#import "RuntimeStatus.h"
#import "DDUserModule.h"
#import "DDGroupModule.h"
#import "DDFixedGroupAPI.h"
#import "SearchContentViewController.h"
#import "MBProgressHUD.h"
#import "SessionModule.h"
#import "MTTLoginViewController.h"
#import "MTTPCLoginViewController.h"
#import "MTTUsersStatAPI.h"
#import "UIImageView+WebCache.h"
#import <Masonry.h>
#import "LinkManViewController.h"
#import "SCLAlertView.h"
#import "LoginModule.h"
#import "SendPushTokenAPI.h"
#import "WPActionSheet.h"
#import "LinkAddViewController.h"
#import "ScanQRCodePage.h"
#import "WPChooseLinkViewController.h"
#import <objc/runtime.h>
#import "WPMySecurities.h"
#import "chatNotiViewController.h"
#import "WPHttpTool.h"
#import "GetGroupInfoAPI.h"
#import "IMGroup.pb.h"
#import "NSDate+DDAddition.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LinkmanInfoModel.h"
#import "WPteamEntityModel.h"
#import "MsgReadACKAPI.h"
#import "WPBlackNameModel.h"
#import "LoadLocalData.h"
#import "WPInfoViewController.h"
#define StartColor [UIColor clearColor]
#define EndColor RGBA(0, 0, 0, 0.5)

@interface RecentUsersViewController ()<WPActionSheet>
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)NSMutableDictionary *lastMsgs;       //最后一条信息
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)SearchContentViewController *searchContent;
@property(nonatomic,assign)NSInteger fixedCount;
@property(nonatomic,strong)UITableView* searchTableView;
@property(nonatomic,strong)UIView* searchPlaceholderView;
@property(nonatomic,assign)BOOL isMacOnline;
@property(nonatomic, strong) MBProgressHUD *myHUD;
@property(nonatomic,strong) UIView *subView;
@property(nonatomic, strong) WPActionSheet *sheet;
@property(nonatomic, strong)NSDictionary *groupInfo;
@property(nonatomic, copy)NSString * inviteCount;
@property(nonatomic, strong)groupNotificationModel * groupModel;
@property(nonatomic, strong)WPteamEntityModel * teamModel;
@property(nonatomic, strong)NSMutableArray * allDataArr;//包括通知和session
@property(nonatomic, assign) BOOL hideOrAppear;
@property(nonatomic, assign)BOOL isHidenOrNot;
@property(nonatomic, assign) int numOfCount;
@property(nonatomic, copy) NSString* bandgeNum;
@property(nonatomic, assign) BOOL isOffLine;//是否掉线
@property(nonatomic, assign) BOOL isRelogin;//是否正在登陆
@property(nonatomic, strong) UIButton * leftBarBtn;
@property(nonatomic, strong) UILabel * leftLabel;
@property(nonatomic, copy) NSString * f_inCount;
@property(nonatomic, copy) NSString * notificationCount;//通知数量
@property(nonatomic,strong) UIView* backTitleView;
@property(nonatomic, strong)UIActivityIndicatorView * activityView;
@property(nonatomic, assign)BOOL hideGroupOrNot;
@property (nonatomic, assign)BOOL isChangeOrNot;
@property (nonatomic, assign)BOOL isChangeOfLine;

- (void)n_receiveStartLoginNotification:(NSNotification*)notification;
- (void)n_receiveLoginFailureNotification:(NSNotification*)notification;
@end

@implementation RecentUsersViewController
+ (instancetype)shareInstance
{
    static RecentUsersViewController* g_recentUsersViewController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_recentUsersViewController = [RecentUsersViewController new];
    });
    return g_recentUsersViewController;
}

-(UIView*)backTitleView
{
    if (!_backTitleView) {
        _backTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        [_backTitleView addSubview:self.activityView];
        [self.activityView startAnimating];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 50, 30)];
        label.text = @"消息";
        label.font = kFONT(15);
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        [_backTitleView addSubview:label]; 
    }
    return _backTitleView;
}

-(UIButton*)leftBarBtn
{
    
    if (!_leftBarBtn)
    {
        _leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBarBtn.frame = CGRectMake(0, 0, 90, 30);
        [_leftBarBtn setTitle:@"通讯录" forState:UIControlStateNormal];
        [_leftBarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _leftBarBtn.titleLabel.font = kFONT(14);
        _leftBarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_leftBarBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
        
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 18, 18)];
        self.leftLabel.backgroundColor = [UIColor redColor];
        self.leftLabel.layer.cornerRadius = 9;
        self.leftLabel.clipsToBounds = YES;
        self.leftLabel.font = systemFont(12);
        self.leftLabel.text = @"10";
        self.leftLabel.text = self.f_inCount;
        self.leftLabel.textColor = [UIColor whiteColor];
        self.leftLabel.textAlignment = NSTextAlignmentCenter;;
        [_leftBarBtn addSubview:self.leftLabel];
    }
    else
    {
        self.leftLabel.text = self.f_inCount;
    }
    return _leftBarBtn;
}

-(void)clickLeftBtn
{
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"通讯录" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    LinkManViewController *linkMane = [[LinkManViewController alloc] init];
//    [self.navigationController pushViewController:linkMane animated:YES];
    [CATransaction begin];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    transition.duration=0.3;
    transition.fillMode=kCAFillModeBoth;
    transition.removedOnCompletion=YES;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    [UIApplication sharedApplication].keyWindow.layer.shadowColor = [UIColor clearColor].CGColor;
    [UIApplication sharedApplication];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [CATransaction setCompletionBlock: ^ {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    }];
    [self.navigationController pushViewController:linkMane animated:NO];
    [CATransaction commit];
}

-(UIActivityIndicatorView*)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _activityView.hidesWhenStopped = YES;
    }
    return _activityView;
}

-(NSMutableArray *)allDataArr
{
    if (!_allDataArr)
    {
        _allDataArr = [[NSMutableArray alloc]init];
    }
    return _allDataArr;
}

-(NSDictionary *)groupInfo
{
    if (!_groupInfo) {
        _groupInfo = [NSDictionary dictionary];
    }
    return _groupInfo;
}




- (UIView *)subView
{
    if (!_subView)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _subView.backgroundColor = RGBA(0, 0, 0, 0);
        [window addSubview:_subView];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]init];
        [tap1 addTarget:self action:@selector(hidden)];
        [_subView addGestureRecognizer:tap1];
    }
    return _subView;
}

- (void)hidden
{
    [self.sheet hideFromView:self.view];
    self.subView.hidden = YES;
}




- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.subView.hidden = YES;
    if (buttonIndex == 1) { //发起群聊
        [self performSelector:@selector(createChat) afterDelay:0.3];
    } else if (buttonIndex == 2) { //添加好友
        [self performSelector:@selector(addNewLink) afterDelay:0.3];
    } else if(buttonIndex == 3) {  //扫一扫
        [self performSelector:@selector(saoyisao) afterDelay:0.2];
    }
}

//快速创建群聊
- (void)createChat
{
    WPChooseLinkViewController *choose = [[WPChooseLinkViewController alloc] init];
    choose.addType = ChooseLinkTypeCreateChat;
    [self.navigationController pushViewController:choose animated:YES];
}

- (void)addNewLink
{
    LinkAddViewController *add = [[LinkAddViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)saoyisao
{
    ScanQRCodePage *vc = [ScanQRCodePage new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 通知
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.isChangeOrNot = YES;
        [self loginButtonPressed];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(n_receiveLoginFailureNotification:)
                                                     name:DDNotificationUserLoginFailure
                                                   object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(n_receiveLoginNotification:)
                                                 name:DDNotificationUserLoginSuccess
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:@"RefreshRecentData"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(n_receiveReLoginSuccessNotification)
                                                 name:@"ReloginSuccess"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:MTTNotificationSessionShieldAndFixed
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pcLoginNotification:)
                                                 name:DDNotificationPCLoginStatusChanged
                                               object:nil];
    //向群组中添加成员成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccessRequireData)
                                                 name:@"ADDMEMEMBERSUCCESS"
                                               object:nil];
    //解散群组成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeSessionSuccess)
                                                 name:@"REMOVESESSIONSUCCES"
                                               object:nil];
    //更新群组消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(upDateGroupSuccess)
                                                 name:@"UPDATEGROUPINFOSUCCESS"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(upDateGroupSuccess)
                                                 name:@"ADDMEMEMBERSUCCESS"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(upDateGroupSuccess)
                                                 name:@"deletegroupUpdate"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(upDateGroupSuccess)
                                                 name:@"REMOVESESSIONSUCCES"
                                               object:nil];
    //收到移出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteSession:)
                                                 name:@"DELETEGROUPSESSION"
                                               object:nil];;//DELETEGROUPSESSION
    //收到群组邀请
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inviteGroup:)
                                                 name:@"INVITEGROUP"
                                               object:nil];
    //清除所有的消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeAllNoti)
                                                 name:@"removeAllNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stateIsOffLine)
                                                 name:@"OFFLINEOFNETWORK"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Relogining)
                                                 name:@"Relogining"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginAgain)
                                                 name:@"loginAnother"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeNoNum)
                                                 name:@"CHANGENOTIFICATIONCOUNT"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeGroupNum)
                                                 name:@"CHANGEGROUPNUMBER"
                                               object:nil];
    //removeNotExitGroup
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sortItems)
                                                 name:@"removeNotExitGroup"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addSessionSuccess)
                                                 name:@"SentMessageSuccessfull"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginButtonPressed)
                                                 name:@"dismissLoginSuccess"
                                               object:nil];
    //HIDEBADGAGE
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBadgage)
                                                 name:@"HIDEBADGAGE"
                                               object:nil];
    //有群组的信息改变时需要刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addSessionSuccess)
                                                 name:@"groupHaseChanged"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addSessionSuccess)
                                                 name:@"personalInfoChanged"
                                               object:nil];
    
    //reloginSuccess
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloginSuccess)
                                                 name:@"reloginSuccess"
                                               object:nil];
    //loginOutClearSession
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginOutClearSession)
                                                 name:@"loginOutClearSession"
                                               object:nil];
    return self;
}
//推出时清空session
-(void)loginOutClearSession
{
    
//    [[SessionModule instance] clearSession];
    [self.items removeAllObjects];
    [self.allDataArr removeAllObjects];
//    [self.tableView reloadData];
}
//用户重新登陆成功
-(void)reloginSuccess
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"notShowDisconnect"];
    self.isOffLine = NO;
    [self.tableView reloadData];
}
-(void)hideBadgage
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"通讯录" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
}
-(void)addSessionSuccess
{
    [self sortItems];
}
-(void)changeGroupNum
{
    [self.tableView reloadData];
}
-(void)changeNoNum
{
    self.numOfCount = -1;
}
-(void)hideMyHUD
{
  [self.myHUD removeFromSuperview];
//    self.navigationItem.titleView = [[UIView alloc]init];
//    self.title = @"消息";
}
#pragma mark  再次登录
-(void)loginAgain
{
    self.isLoginAnother = YES;
    [self loginButtonPressed];
}
//正在重新登陆
-(void)Relogining
{
    self.isRelogin = YES;
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowAtIndexPath:indexpath withRowAnimation:UITableViewRowAnimationNone];
}
//收到掉线通知时要显示网络未连接
-(void)stateIsOffLine
{
    BOOL isOrNOt = [[[NSUserDefaults standardUserDefaults] objectForKey:@"notShowDisconnect"] boolValue];
    BOOL isOr  = [[[NSUserDefaults standardUserDefaults] objectForKey:@"enterBackGround"] boolValue];
    if (isOrNOt || isOr) {
        if ([DDClientState shareInstance].networkState!=DDNetWorkDisconnect) {
          return;
        }
    }
    self.isOffLine = YES;
    [self.tableView reloadData];
}

#pragma mark 有群成员数量变动
-(void)deleteSession:(NSNotification*)noticication
{
    IMGroupChangeMemberNotify * notifi = noticication.object;
    [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%u",(unsigned int)notifi.groupId] completion:^(MTTGroupEntity *group) {
        [group.groupUserIds removeObject:[NSString stringWithFormat:@"user_%u",(unsigned int)notifi.userId]];
        [[DDGroupModule instance] addGroup:group];
        if (!notifi.curUserIdList.count)//群组解散
        {
            MTTSessionEntity * session = [[SessionModule instance] getSessionById:group.objID];
            [[SessionModule instance] removeSessionByServer:session];
        }
         [self sortItems];
    }];
}
-(void)removeAllNoti
{
    self.hideGroupOrNot = YES;
    self.groupModel = nil;
    for (int i = 0; i < self.allDataArr.count; i++) {
        id objc = self.allDataArr[i];
        if ([objc isKindOfClass:[groupNotificationModel class]]) {
            [self.allDataArr removeObject:objc];
        }
    }
    [self.tableView reloadData];
}
-(void)setBadge
{
    NSUInteger unreadcount =  [[SessionModule instance]getAllUnreadMessageCount];
    [self setToolbarBadge:unreadcount];
}
#pragma mark 群消息通知
-(void)inviteGroup:(NSNotification*)notification
{
    NSDictionary * dictionary = (NSDictionary*)notification.object;
    _groupInfo = dictionary;
    self.notificationCount = [NSString stringWithFormat:@"%d",[dictionary[@"count"] intValue]+[dictionary[@"sys_count"] intValue]];
    NSUInteger inter = [[SessionModule instance] getAllUnreadMessageCount];
    [self setToolbarBadge:inter];
    
    WPteamEntityModel * teamModel = [[WPteamEntityModel alloc]init];
    teamModel.isFixedTop = NO;
    teamModel.dictionary = dictionary;
    
    groupNotificationModel * model = [[groupNotificationModel alloc]init];
    model.isFixedTop = NO;
    model.modelDic = dictionary;
    if (model.count.intValue) {
        self.hideGroupOrNot = NO;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FIRSTLOADSESSION"];
    }
    BOOL isFreshOrNot = NO;
    BOOL isAddGroup = NO;
    if (![self.teamModel.sys_remark isEqualToString:teamModel.sys_remark]) {
        isFreshOrNot = YES;
        self.teamModel = teamModel;
        NSString * dicTime1 = teamModel.sys_add_time;
        NSDate * date2 = [NSDate dateWithString:dicTime1 format:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval timeInte2 = [date2 timeIntervalSince1970]+5;
        self.teamModel.timeInterval = timeInte2;
    }
    if (![self.groupModel.content isEqualToString:model.content] && !self.hideGroupOrNot) {
            isFreshOrNot = YES;
            self.groupModel = model;
            NSString * dicTime = model.add_time;
            NSDate * date1 = [NSDate dateWithString:dicTime format:@"yyyy-MM-dd HH:mm:ss"];
            NSTimeInterval timeInte1 = [date1 timeIntervalSince1970]+5;
            self.groupModel.timeInterval = timeInte1;
            isAddGroup = YES;
        
        //新账号注册时不需要显示
        NSString * string = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"registNew"]];
        if (string.intValue) {
            isAddGroup = NO;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"registNew"];
        }
    }
    if (isFreshOrNot)//数据变化时进行刷新
    {
        NSString * firstSession = [[NSUserDefaults standardUserDefaults] objectForKey:@"FIRSTLOADSESSION"];
        [self.items removeAllObjects];
        [self.items addObjectsFromArray:[[SessionModule instance] getAllSessions]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
        NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
        [self.allDataArr removeAllObjects];
        [self.allDataArr addObjectsFromArray:self.items];
        self.teamModel?[self.allDataArr insertObject:self.teamModel atIndex:0]:0;
        isAddGroup?(firstSession.intValue?0:[self.allDataArr insertObject:self.groupModel atIndex:0]):0;
        if (!self.allDataArr.count) {
            return;
        }
        [self.allDataArr sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [self.allDataArr sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
        [self.tableView reloadData];
        isFreshOrNot = NO;
    }
    //小红点
    NSString * f_count = [NSString stringWithFormat:@"%@",dictionary[@"f_count"]];
    if (f_count.intValue >0)
    {
        self.f_inCount = f_count;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftBarBtn];
    }
}
-(void)upDateGroupSuccess
{
   [self sortItems];
}
-(void)removeSessionSuccess
{
    [self sortItems];
}

#pragma mark 收到推送
-(void)receiveNoti
{

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.titleView.titleString = @"消息";
    self.navigationItem.titleView= self.titleView;
//    [self.titleView.activity startAnimating];
    self.numOfCount = -1;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDelegateMessage) name:@"deleteMessageSuccessFull" object:nil];
//    unsigned int count;
//    //获取属性列表
//    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
//    for (unsigned int i=0; i<count; i++) {
//        const char *propertyName = property_getName(propertyList[i]);
//        NSLog(@"property---->%@", [NSString stringWithUTF8String:propertyName]);
//    }
//    //获取方法列表
//    Method *methodList = class_copyMethodList([self class], &count);
//    for (unsigned int i; i<count; i++) {
//        Method method = methodList[i];
//        NSLog(@"method---->%@", NSStringFromSelector(method_getName(method)));
//    }
//    //获取成员变量列表
//    Ivar *ivarList = class_copyIvarList([self class], &count);
//    for (unsigned int i; i<count; i++) {
//        Ivar myIvar = ivarList[i];
//        const char *ivarName = ivar_getName(myIvar);
//        NSLog(@"Ivar---->%@", [NSString stringWithUTF8String:ivarName]);
//    }
//    //获取协议列表
//    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
//    for (unsigned int i; i<count; i++) {
//        Protocol *myProtocal = protocolList[i];
//        const char *protocolName = protocol_getName(myProtocal);
//        NSLog(@"protocol---->%@", [NSString stringWithUTF8String:protocolName]);
//    }
//    self.title=@"消息";
    self.titleView.titleString = @"消息";
    [self setNavbarItem];
//    self.navigationItem.title=@"消息"; //appname
//    [WPMySecurities textFromEmojiString:@""];
    self.items=[NSMutableArray new];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];//TTBG
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, FULL_WIDTH, 40)];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = RGB(247, 247, 247);//TTBG
    self.searchBar.layer.borderWidth = 0.5;
    self.searchBar.layer.borderColor = RGB(226, 226, 226).CGColor;
    self.searchBar.inputAccessoryView.layer.borderWidth = 0.5;
    
    //获取searchBar上的textFiled;
    UITextField * searchTextFiled = nil;
    searchTextFiled = [[[self.searchBar.subviews firstObject] subviews] lastObject];
    searchTextFiled.layer.borderWidth = 0.5;
    searchTextFiled.layer.borderColor = RGB(226, 226, 226).CGColor;
    CGRect rect = searchTextFiled.frame;
    rect.origin.y = kHEIGHT(32)/2-kHEIGHT(20)/2;
    rect.size.height = kHEIGHT(20);
    searchTextFiled.frame = rect;
    searchTextFiled.layer.cornerRadius = 5;
//  self.searchBar.tintColor =[UIColor redColor];
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView =  [[UIView alloc]init];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.lastMsgs = [NSMutableDictionary new];
    self.isMacOnline = 0;
    self.isOffLine = NO;
    /*
     [[SessionModule instance] loadLocalSession:^(bool isok) {
     if (isok) {
     [self.items addObjectsFromArray:[[SessionModule instance] getAllSessions]];
     [self sortItems];
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     [[SessionModule instance] getRecentSession:^(NSUInteger count) {
     [self.items removeAllObjects];
     [self.items addObjectsFromArray:[[SessionModule instance] getAllSessions]];
     [self sortItems];
     NSUInteger unreadcount =  [[self.items valueForKeyPath:@"@sum.unReadMsgCount"] integerValue];
     [self setToolbarBadge:unreadcount];
     }];
     });
     }
     }];
     */
//    [self.tableView reloadData];
}

- (void)setNavbarItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"通讯录" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"plus"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

#pragma mark 点击通讯录
- (void)leftBtnClick
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"通讯录" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    LinkManViewController *linkMane = [[LinkManViewController alloc] init];
    //  [self.navigationController pushViewController:linkMane animated:YES];
    [CATransaction begin];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    transition.duration=0.3;
    transition.fillMode=kCAFillModeBoth;
    transition.removedOnCompletion=YES;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    [UIApplication sharedApplication];
    [UIApplication sharedApplication].keyWindow.layer.shadowColor = [UIColor redColor].CGColor;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [CATransaction setCompletionBlock: ^ {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    }];
    [self.navigationController pushViewController:linkMane animated:NO];
    [CATransaction commit];
}

#pragma mark点击右侧加号
- (void)rightBtnClick
{
    WPActionSheet *action = [[WPActionSheet alloc] initWithDelegate:self otherButtonTitle:@[@"发起群聊",@"添加好友"] imageNames:@[@"group_chat",@"add_friend",@"saoyisao"] top:64];//,@"扫一扫    "
    self.sheet = action;
    self.subView.hidden = NO;
    [action showInViewSpecial:self.view];
}

-(void)hideMb
{
 [self.myHUD removeFromSuperview];
 [MBProgressHUD hideHUDForView:self.view];
}
#pragma mark登陆成功时请求数据
-(void)loginSuccessRequireData
{
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:[[SessionModule instance] getAllSessions]];
    [self sortItems];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if (!self.items.count) {//第一次登陆本地没有数据，从服务器请求数据
            [[SessionModule instance] getHadUnreadMessageSession:^(NSUInteger count) {
                [self performSelectorOnMainThread:@selector(hideMb) withObject:nil waitUntilDone:NO];
                [self.items removeAllObjects];
                [self.items addObjectsFromArray:[[SessionModule instance] getAllSessions]];
                dispatch_async(dispatch_get_main_queue(), ^{
                  [self sortItems];
                });
//                [self sortItems];
                NSUInteger unreadcount =  [[SessionModule instance]getAllUnreadMessageCount];
                [self setToolbarBadge:unreadcount];
            }];
//        }
#pragma mark从服务器获取session
//        [[SessionModule instance] getRecentSession:^(NSUInteger count) {
//            [self performSelectorOnMainThread:@selector(hideMb) withObject:nil waitUntilDone:NO];
//            [self.items removeAllObjects];
//            [self.items addObjectsFromArray:[[SessionModule instance] getAllSessions]];
//            [self sortItems];
//            NSUInteger unreadcount =  [[SessionModule instance]getAllUnreadMessageCount];
//            [self setToolbarBadge:unreadcount];
//        }];
    });
    [SessionModule instance].delegate=self;
    //    [self addCustomSearchControll];
    // 获取mac登陆状态
    [self getMacLoginStatus];
    // 初始化searchTableView
    [self addSearchTableView];
}
- (MBProgressHUD *)myHUD
{
    if (!_myHUD) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _myHUD = [[MBProgressHUD alloc] initWithView:window];
        [_myHUD show:YES];
//        _myHUD.dimBackground = YES;
        _myHUD.labelText = @"正在连接...";
    }
    return _myHUD;
}
#pragma mark 获取黑名单
-(void)getBlackName
{
    [[MTTDatabaseUtil instance] removeAllBlackName:^(BOOL result) {
    }];
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/friend.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"BlackAllList",
                           @"user_id":kShareModel.userId,
                           @"username":kShareModel.username,
                           @"password":kShareModel.password};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        NSArray * list = json[@"list"];
        NSMutableArray * muarray = [NSMutableArray array];
        if (list.count)
        {
            for (NSDictionary * dic in list)
            {
                WPBlackNameModel * model = [[WPBlackNameModel alloc]init];
                model.userId = [NSString stringWithFormat:@"user_%@",[dic[@"userid"] componentsSeparatedByString:@":"][0]];
                model.state = [NSString stringWithFormat:@"%@",[dic[@"userid"] componentsSeparatedByString:@":"][1]];
                [muarray addObject:model];
                if ([model.state isEqualToString:@"4"]) {
                    model.state = @"0";
                }
            }
            [[MTTDatabaseUtil instance] updateBlackName:muarray completion:^(NSError *error) {
            }];
        }
        else
        {
            [[MTTDatabaseUtil instance] loadBlackNamecompletion:^(NSArray *array) {
            }];
        }
    }failure:^(NSError *error) {
        [[MTTDatabaseUtil instance] loadBlackNamecompletion:^(NSArray *array) {
        }];
    }];
}
#pragma mark  点击登陆
- (void)loginButtonPressed
{

    if (!self.isLoginAnother) {
        [[LoadLocalData instance] loadLocalData:kShareModel.password  nameStr:kShareModel.username success:^{
            [self sortItems];
        }];
    }
    
    [self hideBadgage];
    [self.titleView.activity startAnimating];
    [[LoginModule instance] loginWithUsername:kShareModel.username password:kShareModel.password success:^(MTTUserEntity *user) {
        [self.titleView.activity stopAnimating];
        [self performSelectorOnMainThread:@selector(hideMyHUD) withObject:nil waitUntilDone:NO];
        if (user) {
            TheRuntime.user=user ;
            [TheRuntime updateData];
            if (TheRuntime.pushToken) {
                SendPushTokenAPI *pushToken = [[SendPushTokenAPI alloc] init];
                [pushToken requestWithObject:TheRuntime.pushToken Completion:^(id response, NSError *error) {
                }];
            }
            [self loginSuccessRequireData]; // 这里这样做
            [self removeNotExitGroup];//移除不存在的群组
            [self getBlackName];//获取黑名单并保存到本地
        }
    } failure:^(NSString *error) {
        [self.titleView.activity stopAnimating];
        [self.myHUD removeFromSuperview];
        [self performSelector:@selector(sortItems) afterDelay:0.5];
//            [self.items removeAllObjects];
//            [self.items addObjectsFromArray:[[SessionModule instance] getAllSessions]];
//            [self sortItems];
//        if([error isEqualToString:@"版本过低"])
//        {
//            DDLog(@"强制更新");
//            SCLAlertView *alert = [SCLAlertView new];
//            [alert addButton:@"确定" actionBlock:^{
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://tt.mogu.io"]];
//            }];
//            [alert showError:self title:@"升级提示" subTitle:@"版本过低，需要强制更新" closeButtonTitle:nil duration:0];
//            
//        }else{
//            [alert showError:self title:@"错误" subTitle:error closeButtonTitle:@"确定" duration:0];
//        }
    }];
}
-(void)addSearchTableView{
    self.searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 105, SCREEN_WIDTH, SCREEN_HEIGHT-105)];
    [self.view addSubview:self.searchTableView];
    [self.searchTableView setHidden:YES];
    [self.searchTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.searchTableView setBackgroundColor:TTBG];
    self.searchContent = [SearchContentViewController new];
    self.searchContent.viewController=self;
    self.searchTableView.delegate = self.searchContent.delegate;
    self.searchTableView.dataSource = self.searchContent.dataSource;
    __weak __typeof(self)weakSelf = self;
    self.searchContent.didScrollViewScrolled = ^(){
        [weakSelf.view endEditing:YES];
        [weakSelf enableControlsInView:weakSelf.searchBar];
    };
    self.searchPlaceholderView = [[UIView alloc]initWithFrame:CGRectMake(0, 105, SCREEN_WIDTH, SCREEN_HEIGHT-105)];
    [self.view addSubview:self.searchPlaceholderView];
    [self.searchPlaceholderView setHidden:YES];
    [self.searchPlaceholderView setBackgroundColor:[UIColor whiteColor]];
    
    // 点击取消
    self.searchPlaceholderView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endSearch)];
    [self.searchPlaceholderView addGestureRecognizer:tapGesture];
    
    // 添加其他元素
    UILabel *searchMore = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 20)];
    [self.searchPlaceholderView addSubview:searchMore];
    [searchMore setTextAlignment:NSTextAlignmentCenter];
    [searchMore setText:@"搜索更多内容"];
    [searchMore setFont:systemFont(20)];
    [searchMore setTextColor:RGB(129, 129, 131)];
    
    UILabel *searchMoreLine = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 95, 200, 0.5)];
    [self.searchPlaceholderView addSubview:searchMoreLine];
    [searchMoreLine setBackgroundColor:RGB(230, 230, 232)];
    
    UIView *searchMoreContent = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 110, 200, 50)];
    [self.searchPlaceholderView addSubview:searchMoreContent];
    
    UIImageView *searchUser = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [searchUser setImage:[UIImage imageNamed:@"search_user"]];
    [searchMoreContent addSubview:searchUser];
    
    UILabel *searchUserLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 25, 25)];
    [searchUserLabel setText:@"用户"];
    [searchUserLabel setTextColor:RGB(170, 170, 171)];
    [searchUserLabel setFont:systemFont(12)];
    [searchUserLabel setTextAlignment:NSTextAlignmentCenter];
    [searchMoreContent addSubview:searchUserLabel];
    
    UIImageView *searchGroup = [[UIImageView alloc]initWithFrame:CGRectMake(25+33, 0, 25, 25)];
    [searchGroup setImage:[UIImage imageNamed:@"search_group"]];
    [searchMoreContent addSubview:searchGroup];
   
    UILabel *searchGroupLabel = [[UILabel alloc]initWithFrame:CGRectMake(25+33, 35, 25, 25)];
    [searchGroupLabel setText:@"群组"];
    [searchGroupLabel setTextColor:RGB(170, 170, 171)];
    [searchGroupLabel setFont:systemFont(12)];
    [searchGroupLabel setTextAlignment:NSTextAlignmentCenter];
    [searchMoreContent addSubview:searchGroupLabel];
    
    UIImageView *searchDepartment = [[UIImageView alloc]initWithFrame:CGRectMake((25+33)*2, 0, 25, 25)];
    [searchDepartment setImage:[UIImage imageNamed:@"search_department"]];
    [searchMoreContent addSubview:searchDepartment];
    
    UILabel *searchDepartmentLabel = [[UILabel alloc]initWithFrame:CGRectMake((25+33)*2, 35, 25, 25)];
    [searchDepartmentLabel setText:@"部门"];
    [searchDepartmentLabel setTextColor:RGB(170, 170, 171)];
    [searchDepartmentLabel setFont:systemFont(12)];
    [searchDepartmentLabel setTextAlignment:NSTextAlignmentCenter];
    [searchMoreContent addSubview:searchDepartmentLabel];
    
    UIImageView *searchChat = [[UIImageView alloc]initWithFrame:CGRectMake((25+33)*3, 0, 25, 25)];
    [searchChat setImage:[UIImage imageNamed:@"search_chat"]];
    [searchMoreContent addSubview:searchChat];
    
    UILabel *searchChatLabel = [[UILabel alloc]initWithFrame:CGRectMake((25+33)*3, 35, 25, 25)];
    [searchChatLabel setText:@"聊天"];
    [searchChatLabel setTextColor:RGB(170, 170, 171)];
    [searchChatLabel setFont:systemFont(12)];
    [searchChatLabel setTextAlignment:NSTextAlignmentCenter];
    [searchMoreContent addSubview:searchChatLabel];
}
- (void)enableControlsInView:(UIView *)view
{
    for (id subview in view.subviews) {
        if ([subview isKindOfClass:[UIControl class]]) {
            [subview setEnabled:YES];
        }
        [self enableControlsInView:subview];
    }
}
-(void)getMacLoginStatus{
    MTTUsersStatAPI *request = [MTTUsersStatAPI new];
    NSMutableArray *array = [NSMutableArray new];
    UInt32 uid = [MTTUserEntity localIDTopb:TheRuntime.user.objID];
    [array addObject:@(uid)];
    [request requestWithObject:array Completion:^(NSArray *response, NSError *error) {
        if(response){
            NSMutableArray *narray = [NSMutableArray arrayWithArray:response];
            if([narray[0][1] intValue]== UserStatTypeUserStatusOnline){
                self.isMacOnline = 1;
            }
            [self.tableView reloadData];
        }
    }];
}
-(NSMutableArray*)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
-(void)sortItems
{
    
    NSArray * sessionAray = [[SessionModule instance] getAllSessions];
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:sessionAray];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
    NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
    if (!self.items.count) {
        return;
    }
    NSArray * array0 = [NSArray arrayWithObject:sortDescriptor];
    NSArray * array1 = [NSArray arrayWithObject:sortFixed];
    if (!array0.count || !array1.count) {
        return;
    }
    [self.items sortUsingDescriptors:array0];
    [self.items sortUsingDescriptors:array1];
   
//    [self.items sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//    [self.items sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
    
    [self.allDataArr removeAllObjects];
    NSArray * array = self.items;
    [self.allDataArr addObjectsFromArray:array];
    
    self.teamModel?[self.allDataArr insertObject:self.teamModel atIndex:0]:0;
    if (self.groupModel)
    {
        NSString * firstSession = [[NSUserDefaults standardUserDefaults] objectForKey:@"FIRSTLOADSESSION"];
        if (!firstSession.intValue)
        {
            [self.allDataArr insertObject:self.groupModel atIndex:0];
        }
    }
    
    if (!self.allDataArr.count) {
        return;
    }
    NSArray * array2 = [NSArray arrayWithObject:sortDescriptor];
    NSArray * array3 = [NSArray arrayWithObject:sortFixed];
    if (!array2.count) {
        return;
    }
    if (!array3.count) {
        return;
    }
    
    
    [self.allDataArr sortUsingDescriptors:array2];
    [self.allDataArr sortUsingDescriptors:array3];
    [self.tableView reloadData];
}
#pragma mark  置顶和消息免打扰设置成功
-(void)refreshData
{
    [self setToolbarBadge:0];
    [self sortItems];
}
-(void)setToolbarBadge:(NSUInteger)count
{
    count += self.notificationCount.integerValue;
    if (count !=0)
    {
        if (count > 99)
        {
            [self.navigationController.tabBarItem setBadgeValue:@""];//99+
        }
        else
        {
            [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",count]];
        }
    }
    else
    {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [self.navigationController.tabBarItem setBadgeValue:nil];
    }
    
    NSUInteger unreadcount =  [[SessionModule instance]getAllUnreadMessageCount];
    if (!unreadcount) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
    
}
-(void)searchContact
{
}
-(void)getInfoAboutGroup
{
    NSDictionary * dictionary = @{@"action":@"get_groupMemCount",@"user_id":kShareModel.userId};
    NSString * urlStr = [NSString stringWithFormat:@"%@/msg/msgcount.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dictionary success:^(id json) {
        _groupInfo = json;
    } failure:^(NSError *error) {
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUInteger count = [[SessionModule instance] getAllUnreadMessageCount];
    [self setToolbarBadge:count];
    [self.tableView reloadData];
//    self.title=@"消息";//appname
    
    
    
    //请求群的申请通知
//    [self getInfoAboutGroup];
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDDReachabilityChangedNotification" object:nil];
//    });
}
#pragma mark 移除不存在的群组
-(void)removeNotExitGroup
{
    //请求不存在的群组的id
    NSArray * array = [[SessionModule instance] getAllSessions];
    NSString * sessionStr = nil;
    for (MTTSessionEntity * sesion in array)
    {
        if (sesion.sessionType == SessionTypeSessionTypeGroup)
        {
            if (sessionStr.length)
            {
                sessionStr = [NSString stringWithFormat:@"%@,%@",sessionStr,[sesion.sessionID componentsSeparatedByString:@"_"][1]];
            }
            else
            {
                sessionStr = [NSString stringWithFormat:@"%@",[sesion.sessionID componentsSeparatedByString:@"_"][1]];
            }
        }
    }
    NSDictionary * dic = @{@"action":@"groupIsDel",@"GroupID":sessionStr};
    NSString * urlStr = [NSString stringWithFormat:@"%@/msg/getmsg.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        NSString * unExitStr = json[@"List"];
        NSArray * unExitArray = [unExitStr componentsSeparatedByString:@","];
        for (NSString * sessionID in unExitArray)
        {
            if (sessionID.length)
            {
              [[SessionModule instance] removeSessionById:[NSString stringWithFormat:@"group_%@",sessionID] succecc:nil];
            }
        }
        [self sortItems];
    } failure:^(NSError *error) {
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(hideAppearHud) withObject:nil afterDelay:1];
    [super viewDidAppear:animated];
  //  [ChattingMainViewController shareInstance].module.MTTSessionEntity=nil;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);//(64, 0, 49, 0)
}
-(void)hideAppearHud
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UITableView DataSource
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }else{
        return self.allDataArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if(indexPath.section == 0)
    {
        if (self.isOffLine)
        {
            height = kHEIGHT(32);
        }
        else
        {
            height = 0;
        }
    }
    else
    {
        height = 72;
    }
    return height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {    //断网提示cell
            static NSString* cellIdentifier = @"UITableViewCellIdentifier";
            UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(18, (kHEIGHT(32)-20)/2, 20, 20)];
            [image setImage:[UIImage imageNamed:@"common_duanwangtishi"]];
            [cell.contentView addSubview:image];
            
            UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(image.right+8, 0, SCREEN_WIDTH-image.right-8-50, kHEIGHT(32))];
            textLabel.text = @"当前网络不可用,请检查网络设置。";
            textLabel.textColor = RGB(127, 127, 127);
            textLabel.font = kFONT(12);
            [cell.contentView addSubview:textLabel];
        
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, kHEIGHT(32)-0.5, SCREEN_WIDTH,0.5)];
        line.backgroundColor = RGB(235, 235, 235);
        [cell.contentView addSubview:line];
        
        UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-18-22, kHEIGHT(32)/2-11, 0, 0)];
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [cell.contentView addSubview:activity];
        activity.hidesWhenStopped = YES;
        self.isRelogin?[activity startAnimating]:[activity stopAnimating];
        CGPoint center = CGPointMake(SCREEN_WIDTH-20-11, kHEIGHT(32)/2);
        activity.center = center;
        cell.backgroundColor = RGB(255, 238, 238);
        cell.hidden = !self.isOffLine;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!self.isOffLine)
        {
            [cell.contentView removeAllSubviews];
        }

        return  cell;
//        MTTPCStatusCell* cell = (MTTPCStatusCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if (!cell)
//        {
//            cell = [[MTTPCStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        }
//        if(!self.isMacOnline){
//            [cell setHidden:YES];
//        }
//        return cell;
    }
    else
    {
        id objc = self.allDataArr[indexPath.row];
        if ([objc isKindOfClass:[groupNotificationModel class]] ||[objc isKindOfClass:[WPteamEntityModel class]]) {
            static NSString* cellIdentifier = @"inviteNoTableViewCellIdentifier";
            inviteNoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell = [[inviteNoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            if ([objc isKindOfClass:[WPteamEntityModel class]])
            {
                if ([_groupInfo[@"sys_count"] intValue])
                {
                    cell.unReadMessage.hidden = NO;
                }
                else
                {
                    cell.unReadMessage.hidden = YES;
                }
                [cell setGroupDictionary:_groupInfo isOr:NO];
                _numOfCount = [_groupInfo[@"sys_count"] intValue];
            }
            else
            {
                if ([_groupInfo[@"count"] intValue])
                {
                    cell.unReadMessage.hidden = NO;
                }
                else
                {
                    cell.unReadMessage.hidden = YES;
                }
                 [cell setGroupDictionary:_groupInfo isOr:YES];
                _numOfCount = [_groupInfo[@"count"] intValue];
            }
            return  cell;
        }
        else
        {
             MTTSessionEntity *session = (MTTSessionEntity*)objc;
            if (session.sessionType == SessionTypeSessionTypeGroup) {
                static NSString * cellIdentity = @"RecentGroupMessageCellIdentifier";
                RecentGroupMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
                if (!cell)
                {
                    cell = [[RecentGroupMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
                }
                UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
                view.backgroundColor=RGB(226, 226, 226);
                
                if(session.isFixedTop){
                    [cell setBackgroundColor:RGB(247, 247, 247)];
                }else{
                    [cell setBackgroundColor:[UIColor whiteColor]];
                }
                cell.selectedBackgroundView=view;
                [cell setShowSession:session];
                [self preLoadMessage:session];
                return  cell;
            }
            else
            {
                static NSString* cellIdentifier = @"MTTRecentUserCellIdentifier";
                RecentUserCell* cell = (RecentUserCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell)
                {
                    cell = [[RecentUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
                view.backgroundColor=RGB(226, 226, 226);
                if(session.isFixedTop){
                    [cell setBackgroundColor:RGB(247, 247, 247)];
                }else{
                    [cell setBackgroundColor:[UIColor whiteColor]];
                }
                cell.selectedBackgroundView=view;
                [cell setShowSession:session];
                [self preLoadMessage:session];
                return cell;
            }
        }
    }
}



#pragma mark  在当前界面收到消息
-(void)sessionUpdate:(MTTSessionEntity *)session Action:(SessionAction)action
{
//    [self removeNotExitGroup];
    if (!session) {
        return;
    }
    if (![self.items containsObject:session]) {
        [self.items insertObject:session atIndex:0];
    }
//    [self sortItems];
    [self notifiUpdate];
    [self.tableView reloadData];
    NSUInteger count = [[SessionModule instance] getAllUnreadMessageCount];
    [self setToolbarBadge:count];
}
-(void)notifiUpdate
{
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:[[SessionModule instance] getAllSessions]];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
    NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
    [self.items sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [self.items sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
    
    [self.allDataArr removeAllObjects];
    NSArray * array = self.items;
    [self.allDataArr addObjectsFromArray:array];
    self.teamModel?[self.allDataArr insertObject:self.teamModel atIndex:0]:0;
    
    if (self.groupModel)
    {
        NSString * firstsSession = [[NSUserDefaults standardUserDefaults] objectForKey:@"FIRSTLOADSESSION"];
        if (!firstsSession.intValue)
        {
            [self.allDataArr insertObject:self.groupModel atIndex:0];
        }
    }
    if (!self.allDataArr.count) {
        return;
    }
    [self.allDataArr sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [self.allDataArr sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
}
#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0){
//        chatNotiViewController * notifi = [[chatNotiViewController alloc]init];
//        [self.navigationController pushViewController:notifi animated:YES];
//        MTTPCLoginViewController *pcLogin = [MTTPCLoginViewController new];
//        [self presentViewController:pcLogin animated:YES completion:^{
//            
//        }];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        id objc = self.allDataArr[indexPath.row];
        if ([objc isKindOfClass:[groupNotificationModel class]])
        {   //群通知
            chatNotiViewController * notifi = [[chatNotiViewController alloc]init];
            [self.navigationController pushViewController:notifi animated:YES];
            self.notificationCount = @"0";
            self.numOfCount = 0;
            NSUInteger unreadcount =  [[SessionModule instance]getAllUnreadMessageCount];
            [self setToolbarBadge:unreadcount];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"badgageChange" object:nil];
        }
        else if ([objc isKindOfClass:[WPteamEntityModel class]])
        {
            WPInfoViewController * info = [[WPInfoViewController alloc]init];
            [self.navigationController pushViewController:info animated:YES];
        }
        else
        {
            //最近聊天信息页面
            MTTSessionEntity *session = (MTTSessionEntity*)objc;
            ChattingMainViewController *chat = [ChattingMainViewController shareInstance];
            chat.title = session.name;
            [chat showChattingContentForSession:session];
            [self.navigationController pushViewController:chat animated:YES];
        }
//        NSInteger row = [indexPath row];
//        MTTSessionEntity *session = self.items[row];
//        ChattingMainViewController *chat = [ChattingMainViewController shareInstance];
//        chat.title = session.name;
//        [chat showChattingContentForSession:session];
//        [self.navigationController pushViewController:chat animated:YES];
    }
}
#pragma mark - 删除当前行聊天内容,这里还要调删除服务器的删除,后期等有服务器的接口了再调
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MTTSessionEntity *session = self.allDataArr[indexPath.row];//self.items[row]
//    [self.allDataArr removeObjectAtIndex:indexPath.row];//self.items
//    [self.items removeObject:session];
//    [[SessionModule instance] removeSessionByServer:session];
//    [self setToolbarBadge:[[SessionModule instance]getAllUnreadMessageCount]];
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
//    if (self.items.count * 72 < SCREEN_HEIGHT-64-49-40) {
//        self.tableView.tableFooterView = [[UIView alloc]init];
//        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-40-self.items.count*72)];
//        view.backgroundColor = [UIColor whiteColor];
//        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//        line.backgroundColor = RGB(235, 235, 235);
//        [view addSubview:line];
//    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.allDataArr.count)
    {
        id objc = self.allDataArr[indexPath.row];
        if ([objc isKindOfClass:[groupNotificationModel class]] || [objc isKindOfClass:[WPteamEntityModel class]] || indexPath.section == 0)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id objc = self.allDataArr[indexPath.row];
    NSString * readStr = nil;
    if ([objc isKindOfClass:[MTTSessionEntity class]]) {
        MTTSessionEntity * session = (MTTSessionEntity*)objc;
        if (session.unReadMsgCount)
        {
            readStr = @"标为已读";
        }
        else
        {
         readStr = @"标为未读";
        }
    }
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:readStr handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"标记为已读或未读");
        id objc = self.allDataArr[indexPath.row];
        MTTSessionEntity * session = nil;
        if ([objc isKindOfClass:[MTTSessionEntity class]])
        {
            session = (MTTSessionEntity*)objc;
        }
        if ([action.title isEqualToString:@"标为未读"])
        {
            if (session.sessionID)
            {
                session.unReadMsgCount = 1;
                [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
                }];
                NSUInteger count = [[SessionModule instance] getAllUnreadMessageCount];
                [self setToolbarBadge:count];
                [self.tableView reloadData];
            }
        }
        else
        {
            MsgReadACKAPI* readACK = [[MsgReadACKAPI alloc] init];
            if(session.sessionID){
                [readACK requestWithObject:@[session.sessionID,@(session.lastMsgID),@(session.sessionType)] Completion:nil];
                session.unReadMsgCount=0;
                [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
                }];
                NSUInteger count = [[SessionModule instance] getAllUnreadMessageCount];
                [self setToolbarBadge:count];
                [self.tableView reloadData];
            }
        }
    }];
    action.backgroundColor = RGB(170,170, 170);
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        MTTSessionEntity *session = self.allDataArr[indexPath.row];//self.items[row]
        [self.allDataArr removeObjectAtIndex:indexPath.row];//self.items
        [self.items removeObject:session];
        [[SessionModule instance] removeSessionByServer:session];
        [self setToolbarBadge:[[SessionModule instance]getAllUnreadMessageCount]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        if (self.items.count * 72 < SCREEN_HEIGHT-64-49-40)
        {
            self.tableView.tableFooterView = [[UIView alloc]init];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-40-self.items.count*72)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            line.backgroundColor = RGB(235, 235, 235);
            [view addSubview:line];
        }
    }];
    NSArray * array = @[action1,action];
    return array;
}
#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSString* nick = [RuntimeStatus instance].user.nick;
    self.searchContent.searchKey = searchBar.text;
    // 原tableview不允许滚动
    self.tableView.scrollEnabled = NO;
    if(searchBar.text.length)
    {
        [self enableControlsInView:searchBar];
        // 显示空白view
        [self.searchPlaceholderView setHidden:YES];
        // 隐藏tabbar
        self.tabBarController.tabBar.hidden = YES;
    }
    else
    {
        // 显示取消按钮
        [self.searchBar setShowsCancelButton:YES animated:YES];
        // 显示空白view
        [self.searchPlaceholderView setHidden:NO];
        // 隐藏tabbar
        self.tabBarController.tabBar.hidden = YES;
    }
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)endSearch
{
    // 原tableview允许滚动
    self.tableView.scrollEnabled = YES;
    self.searchBar.text = @"";
    [self.searchPlaceholderView setHidden:YES];
    [self.searchTableView setHidden:YES];
    // 显示tabbar
    self.tabBarController.tabBar.hidden = NO;
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self endSearch];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length)
    {
        [self.searchPlaceholderView setHidden:YES];
        [self.searchTableView setHidden:NO];
        __weak RecentUsersViewController *weakSelf =self;
        [self.searchContent searchTextDidChanged:searchText Block:^(bool done) {
            [weakSelf.searchTableView reloadData];
        }];
    }else{
        [self.searchPlaceholderView setHidden:NO];
        [self.searchTableView setHidden:YES];
    }
}

#pragma mark -  SNotification

- (void)n_receiveLoginFailureNotification:(NSNotification*)notification
{
//    self.title = @"消息";
    self.titleView.titleString = @"消息";
}

- (void)n_receiveStartLoginNotification:(NSNotification*)notification
{
//    self.title = @"消息";//appname
    self.titleView.titleString = @"消息";
}

- (void)n_receiveLoginNotification:(NSNotification*)notification
{
//    self.title = @"消息";//appname
    self.titleView.titleString = @"消息";
    self.isOffLine = NO;
    [self.tableView reloadData];
    [self hideMyHUD];
    
}

-(void)n_receiveReLoginSuccessNotification
{
//    self.title = @"消息";//appname
    self.titleView.titleString = @"消息";
    self.isOffLine = NO;
    self.isRelogin = NO;
//    self.isChangeOfLine = YES;
//    [MBProgressHUD showMessage:@"" toView:self.view];
    [self.titleView.activity startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //重新登陆后需要重新获取未读session
        [[SessionModule instance] getHadUnreadMessageSession:^(NSUInteger count) {
//            dispatch_async(dispatch_get_main_queue(), ^{
                [self.items removeAllObjects];
                [self.items addObjectsFromArray:[[SessionModule instance] getAllSessions]];
            [self.titleView.activity stopAnimating];
//                [MBProgressHUD hideHUDForView:self.view];
                [self sortItems];
                NSUInteger unreadcount =  [[SessionModule instance]getAllUnreadMessageCount];
                [self setToolbarBadge:unreadcount];
//            });
//            [self.items removeAllObjects];
//            [self.items addObjectsFromArray:[[SessionModule instance] getAllSessions]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//              [MBProgressHUD hideHUDForView:self.view];
//              [self sortItems];
//            });
////            [self sortItems];
//            NSUInteger unreadcount =  [[SessionModule instance]getAllUnreadMessageCount];
//            [self setToolbarBadge:unreadcount];
        }];
#pragma mark从服务器获取session
//        [[SessionModule instance] getRecentSession:^(NSUInteger count) {
//            [self.items removeAllObjects];
//            [self.items addObjectsFromArray:[[SessionModule instance] getAllSessions]];
//            [self sortItems];
//            [self setToolbarBadge:0];
//        }];
    });
}

-(void)preLoadMessage:(MTTSessionEntity *)session
{
    [[MTTDatabaseUtil instance] getLastestMessageForSessionID:session.sessionID completion:^(MTTMessageEntity *message, NSError *error) {
        if (message) {
            if (message.msgID != session.lastMsgID ) {
                [[DDMessageModule shareInstance] getMessageFromServer:session.lastMsgID currentSession:session count:20 Block:^(NSMutableArray *array, NSError *error) {
                    //从服务器获取的未读数据插入到本地数据库
                    [[MTTDatabaseUtil instance] insertMessages:array success:^{
                    } failure:^(NSString *errorDescripe) {
                    }];
                }];
            }
        }else{
            if (session.lastMsgID !=0) {
                [[DDMessageModule shareInstance] getMessageFromServer:session.lastMsgID currentSession:session count:20 Block:^(NSMutableArray *array, NSError *error) {
                    [[MTTDatabaseUtil instance] insertMessages:array success:^{
                    } failure:^(NSString *errorDescripe) {
                    }];
                }];
            }
            else
            {
            }
        }
    }];
}
-(void)pcLoginNotification:(NSNotification*)notification
{
    if([[[notification object]objectForKey:@"loginStat"] intValue]== UserStatTypeUserStatusOffline){
        self.isMacOnline = 0;
    }else{
        self.isMacOnline = 1;
    }
    [self.tableView reloadData];
}
@end
