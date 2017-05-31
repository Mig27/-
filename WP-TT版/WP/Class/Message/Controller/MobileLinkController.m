//
//  MobileLinkController.m
//  WP
//
//  Created by 沈亮亮 on 15/12/29.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "MobileLinkController.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "LinkmanInfoModel.h"
#import "LinkMobileModel.h"
#import "TableViewIndex.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "WPAllSearchController.h"
#import "PersonalInfoViewController.h"
#import "LinkMobileCell.h"

#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>
#import "DDUserModule.h"
#import "CCAlertView.h"
#import "MCSearchViewController.h"
#import "WPAddNewFriendValidateController.h"
#import "WPAddNewFriendParam.h"
#import "WPAddNewFriendHttp.h"
#import "MTTSessionEntity.h"
#import "WPPhoneBookFriendSettingController.h"
#import "ChattingModule.h"
#import "MTTMessageEntity.h"
#import "MTTDatabaseUtil.h"
#import "DDMessageSendManager.h"
#import "MTTDatabaseUtil.h"
@interface MobileLinkController () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,MCSearchViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *sectionTitle;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *mobileData; /**< 手机联系人 */

@property (nonatomic,strong)MCSearchViewController *searchViewController;

@property (nonatomic,weak) UIView *searchBar;

@property (nonatomic,strong)NSMutableArray *searchData; //搜索过的数据

@property (nonatomic,assign,getter=isSearching)BOOL searching;


@property (nonatomic,assign) NSInteger auth; // 为1 说明没有权限

@property (nonatomic,strong) UIButton *addButton;

@property (nonatomic,copy) NSString *showOnce;

@property (nonatomic,copy) NSString *friendId;


@property (nonatomic,strong) NSIndexPath *ccindex;


@property (nonatomic, strong) NSMutableArray *dataSource2; //新的数据源

@property (nonatomic, strong) NSMutableArray *mobileArr;

@end

@implementation MobileLinkController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self address];
//    [self getAddressStatus];
//    [self requireData];
    
//    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchBar];
    self.title = @"手机联系人";
    self.view.backgroundColor = [UIColor whiteColor];
    [[MTTDatabaseUtil instance] getPhoneLinkMan:^(NSArray *array) {
        if (array.count) {
            NSDictionary * dic = @{@"list":array};
            LinkMobileModel *model = [LinkMobileModel mj_objectWithKeyValues:dic];
            [self.dataSource removeAllObjects];
            [self.datas removeAllObjects];
            [self.datas addObjectsFromArray:model.list];
            [self.dataSource addObjectsFromArray:[TableViewIndex archive:self.datas]];
            self.sectionTitle = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
            for (int i = (int)self.dataSource.count-1; i>=0; i--) {
                if ([self.dataSource[i] count] == 0) {
                    [self.sectionTitle removeObjectAtIndex:i];
                    [self.dataSource removeObjectAtIndex:i];
                }
            }
            [self.tableView reloadData];
        }
    }];
    self.mobileData = [NSMutableArray array];
    [self address];
    [self initDatasource];
    [self requireData];
    [self getAddressStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlyShowOneTimeWaitValidate:) name:@"onlyShowOneTimeWaitValidate" object:nil];
    
}

-(void)onlyShowOneTimeWaitValidate:(NSNotification *)noti{
    // 只有发送验证之后
    AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.mobileArr = appDelegate.mobileArr;
    self.friendId  = noti.userInfo[@"UserId"];
}

-(NSMutableArray *)dataSource2{
    if (_dataSource2 == nil) {
        _dataSource2 = [NSMutableArray array];
    }
    return _dataSource2;
}

- (void)deregisterNotificationHandlers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [self deregisterNotificationHandlers];
}


// 判断获取通讯录的权限状态
-(void)getAddressStatus{
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        self.auth = 1;
        [self.tableView reloadData];
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.auth = 1;
            // 更新界面
            [self.tableView reloadData];
        });
    }
   
}

- (void)initDatasource
{
    self.dataSource = [NSMutableArray array];
    self.sectionTitle = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
}

- (void)requireData
{
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (LinkmanInfoModel *model in self.mobileData) {
        NSDictionary *dic = @{ @"name" : model.name == nil ? @"" : model.name,
                               @"mobile" : model.telephone == nil ? @"" : model.telephone};
        [arr addObject:dic];
    }
    NSDictionary *jsonDic = @{@"mobileJson" : arr};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"GetMobileFans";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    params[@"mobileJson"] = jsonString;
    
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        
        
        LinkMobileModel *model = [LinkMobileModel mj_objectWithKeyValues:json];
        [self.dataSource removeAllObjects];
        [self.datas removeAllObjects];
        [self.datas addObjectsFromArray:model.list];
        [self.dataSource addObjectsFromArray:[TableViewIndex archive:self.datas]];
        
        NSArray * list = json[@"list"];
        if (list.count) {
            self.sectionTitle = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
            for (int i = (int)self.dataSource.count-1; i>=0; i--) {
                if ([self.dataSource[i] count] == 0) {
                    [self.sectionTitle removeObjectAtIndex:i];
                    [self.dataSource removeObjectAtIndex:i];
                }
            }
            [self.tableView reloadData];
            [[MTTDatabaseUtil instance] deletePhoneMan];
            [[MTTDatabaseUtil instance] upDatePhoneLinkMan:list];
        }
        else
        {
            [[MTTDatabaseUtil instance] getPhoneLinkMan:^(NSArray *array) {
                if (array.count) {
                    NSDictionary * dic = @{@"list":array};
                    LinkMobileModel *model = [LinkMobileModel mj_objectWithKeyValues:dic];
                    [self.dataSource removeAllObjects];
                    [self.datas removeAllObjects];
                    [self.datas addObjectsFromArray:model.list];
                    [self.dataSource addObjectsFromArray:[TableViewIndex archive:self.datas]];
                    self.sectionTitle = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
                    for (int i = (int)self.dataSource.count-1; i>=0; i--) {
                        if ([self.dataSource[i] count] == 0) {
                            [self.sectionTitle removeObjectAtIndex:i];
                            [self.dataSource removeObjectAtIndex:i];
                        }
                    }
                    [self.tableView reloadData];
                }
            }];
        }
//        self.sectionTitle = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
//        for (int i = (int)self.dataSource.count-1; i>=0; i--) {
//            if ([self.dataSource[i] count] == 0) {
//                [self.sectionTitle removeObjectAtIndex:i];
//                [self.dataSource removeObjectAtIndex:i];
//            }
//        }
//        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [[MTTDatabaseUtil instance] getPhoneLinkMan:^(NSArray *array) {
            if (array.count) {
                NSDictionary * dic = @{@"list":array};
                LinkMobileModel *model = [LinkMobileModel mj_objectWithKeyValues:dic];
                [self.dataSource removeAllObjects];
                [self.datas removeAllObjects];
                [self.datas addObjectsFromArray:model.list];
                [self.dataSource addObjectsFromArray:[TableViewIndex archive:self.datas]];
                self.sectionTitle = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
                for (int i = (int)self.dataSource.count-1; i>=0; i--) {
                    if ([self.dataSource[i] count] == 0) {
                        [self.sectionTitle removeObjectAtIndex:i];
                        [self.dataSource removeObjectAtIndex:i];
                    }
                }
                [self.tableView reloadData];
            }
        }];
       
    }];
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.sectionIndexColor = [UIColor blackColor];
        _tableView.rowHeight = [LinkMobileCell cellHeight];
        self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        self.tableView.tableHeaderView = self.searchBar;
        [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
        [self.view addSubview:self.tableView];
        
    }
    return _tableView;
}

#pragma mark - 设置SearchBa
-(void)setupSearchBar{
    UIView *searchBar = [[UIView alloc] init];
    searchBar.backgroundColor =  RGBCOLOR(245, 245, 245);
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    searchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
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
    
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.auth == 1) {
        [tableView tableViewDisplayWitMsg:@"请在iPhone的 “设置-隐私-通讯录” 选项中 ，允许微聘访问你的通讯录。" andAuthorization:1];
    }else{
        [tableView tableViewDisplayWitMsg:@"暂无手机联系人" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    LinkMobileCell *cell = [LinkMobileCell cellWithTableView:tableView];
    cell.isMobile = YES;
    cell.index = indexPath;
    LinkMobileListModel *model;
    if (self.friendId.length > 0) {
        for (int i = 0; i< self.dataSource.count; i++)
        {
            for (LinkMobileListModel *model in self.dataSource[i])
            {
                if ([self.friendId isEqualToString:model.user_id])
                {
                    NSUInteger index = [self.dataSource[i] indexOfObject:model];
                    NSIndexPath *ccindex = [NSIndexPath indexPathForRow:index inSection:i];
                    self.ccindex = ccindex;
                    LinkMobileListModel *newModel = model;
                    newModel.isatt = @"6";//6
                    self.dataSource2 = self.dataSource;
                    [_dataSource2[i] replaceObjectAtIndex:index withObject:newModel];
                }
            }
        }
         model = self.dataSource2[indexPath.section][indexPath.row];
    }
    else
    {
         model = self.dataSource[indexPath.section][indexPath.row];
    }
    cell.opertionAddBlock = ^(NSIndexPath *index,NSString *title){
        NSLog(@"点击");
        if ([title isEqualToString:@"添加"]) {
            //将好友信息添加到本地
            [[DDUserModule shareInstance] addNewFriend:model.user_id];
            
            [self isexitOfFriend:model.user_id success:^(id json) {
                NSDictionary * dic = (NSDictionary*)json;
                NSString * is_friend = dic[@"is_friend"];
                if (is_friend.intValue)//在对方好友列表中直接添加成功
                {
                    
                    LinkMobileListModel *model = self.dataSource[index.section][index.row];
                    model.isatt = @"0";
                    LinkMobileCell * cell = [self.tableView cellForRowAtIndexPath:index];
                    //更新数据库
                    [[MTTDatabaseUtil instance] deletePhoneMan];
                    [[MTTDatabaseUtil instance] upDatePhoneLinkMan:self.dataSource];
                    
                    
                    [cell.addButton setTitle:@"已添加" forState:UIControlStateNormal];
                    [cell.addButton setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
                    cell.addButton.enabled = NO;
                    cell.addButton.titleLabel.font = kFONT(12);
                    cell.addButton.layer.borderColor = [UIColor whiteColor].CGColor;
                    cell.addButton.layer.borderWidth = 0;
                    cell.addButton .backgroundColor = [UIColor whiteColor];
                    
                    
                    PersonalInfoViewController *personalInfo = [[PersonalInfoViewController alloc] init];
                    personalInfo.ccindex = indexPath;
                    LinkMobileListModel *model1 = self.dataSource[indexPath.section][indexPath.row];
                    personalInfo.friendID = model1.user_id;
                    personalInfo.newType = NewRelationshipTypeFriend;
                    [self.navigationController pushViewController:personalInfo animated:YES];

                    //发送消息从对方的数据库中删除黑名单
                    WPPhoneBookFriendSettingController * phoneBook = [[WPPhoneBookFriendSettingController alloc]init];
                    [phoneBook sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",model.user_id] and:@"3"];
                }
                else//不在对方好友列表中
                {
                    NSString * moshi = dic[@"moshi"];
                    if (moshi.intValue)//求职招聘模式
                    {
                        LinkMobileListModel *model = self.dataSource[index.section][index.row];
                        model.isatt = @"0";
                        
                        //更新数据库联系人
                        [[MTTDatabaseUtil instance] deletePhoneMan];
                        [[MTTDatabaseUtil instance] upDatePhoneLinkMan:self.dataSource];
                        
                        
                        LinkMobileCell * cell = [self.tableView cellForRowAtIndexPath:index];
                        [cell.addButton setTitle:@"已添加" forState:UIControlStateNormal];
                        [cell.addButton setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
                        cell.addButton.enabled = NO;
                        cell.addButton.titleLabel.font = kFONT(12);
                        cell.addButton.layer.borderColor = [UIColor whiteColor].CGColor;
                        cell.addButton.layer.borderWidth = 0;
                        cell.addButton .backgroundColor = [UIColor whiteColor];
                        
                        PersonalInfoViewController *personalInfo = [[PersonalInfoViewController alloc] init];
                        personalInfo.ccindex = indexPath;
                        LinkMobileListModel *model1 = self.dataSource[indexPath.section][indexPath.row];
                        personalInfo.friendID = model1.user_id;
                        personalInfo.newType = NewRelationshipTypeFriend;
                        [self.navigationController pushViewController:personalInfo animated:YES];
                        
                        //发送消息，从对方的数据库中删除黑名单
                        WPPhoneBookFriendSettingController * phoneBook = [[WPPhoneBookFriendSettingController alloc]init];
                        [phoneBook sendeMessageAboutRemove:[NSString stringWithFormat:@"user_%@",model.user_id] and:@"3"];
                        //发送消息告诉对方添加好友成功
                        [self sendeMessageToOther:model.user_id andUser:nil];
                    }
                    else//正常模式
                    {
                        WPAddNewFriendValidateController *addnew = [[WPAddNewFriendValidateController alloc] init];
                        LinkMobileListModel *model = self.dataSource[index.section][index.row];
                        addnew.index = index;
                        addnew.fuser_id = model.user_id;
                        addnew.friend_mobile = model.mobile;
                        addnew.comeFromVc = @"添加手机好友";
                        addnew.refreshState = ^(NSIndexPath*index){
                            LinkMobileListModel *model = self.dataSource[index.section][index.row];
                            model.isatt = @"6";
                            LinkMobileCell * cell1 = [self.tableView cellForRowAtIndexPath:index];
                            cell1.isMobile = YES;
                            cell1.model = model;
                            
                            //更新数据库联系人
                            [[MTTDatabaseUtil instance] deletePhoneMan];
                            [[MTTDatabaseUtil instance] upDatePhoneLinkMan:self.dataSource];
                        };
                        [self.navigationController pushViewController:addnew animated:YES];
                    }
                }
            } Failed:^(NSError *error) {
            }];
//            [self isExitOtherFriend:model.user_id success:^(id status) {
//                NSString * string = (NSString*)status;
//                if (string.intValue)//不在对方的好友列表中
//                {
//                    WPAddNewFriendValidateController *addnew = [[WPAddNewFriendValidateController alloc] init];
//                    addnew.index = index;
//                    addnew.fuser_id = model.user_id;
//                    addnew.friend_mobile = model.mobile;
//                    addnew.comeFromVc = @"添加手机好友";
//                    addnew.refreshState = ^(NSIndexPath*index){
//                        LinkMobileListModel *model = self.dataSource[index.section][index.row];
//                        model.isatt = @"6";
//                        LinkMobileCell * cell1 = [self.tableView cellForRowAtIndexPath:index];
//                        cell1.isMobile = YES;
//                        cell1.model = model;
////                        cell1.addButton.hidden = YES;
////                        cell1.valiLabel.text = @"等待验证";
//                    };
//                    [self.navigationController pushViewController:addnew animated:YES];
//                }
//                else
//                {
//                    __weak typeof(self) weakSelf = self;
//                    [self addFriendsanf:model.user_id andfriend_mobile:model.mobile success:^(id string) {
//                        LinkMobileListModel *model = weakSelf.dataSource[index.section][index.row];
//                        model.isatt = @"0";
//                        LinkMobileCell * cell = [weakSelf.tableView cellForRowAtIndexPath:index];
//                        [cell.addButton setTitle:@"已添加" forState:UIControlStateNormal];
//                        [cell.addButton setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
//                        cell.addButton.enabled = NO;
//                        cell.addButton.titleLabel.font = kFONT(12);
//                        cell.addButton.layer.borderColor = [UIColor whiteColor].CGColor;
//                        cell.addButton.layer.borderWidth = 0;
//                        cell.addButton .backgroundColor = [UIColor whiteColor];
//                        
//                        
//                        PersonalInfoViewController *personalInfo = [[PersonalInfoViewController alloc] init];
//                        personalInfo.ccindex = indexPath;
//                        LinkMobileListModel *model1 = weakSelf.dataSource[indexPath.section][indexPath.row];
//                        personalInfo.friendID = model1.user_id;
//                        personalInfo.newType = NewRelationshipTypeFriend;
//                        [weakSelf.navigationController pushViewController:personalInfo animated:YES];
//                    }];
//                }
//            } andFailed:^(NSError *error) {
//            }];
            
            
            
            //跳转到验证页面  成功的话则是更改按钮的文字为等待验证(直接刷新数据) 以及按钮状态为不可点击
//            WPAddNewFriendValidateController *addnew = [[WPAddNewFriendValidateController alloc] init];
//            addnew.fuser_id = model.user_id;
//            addnew.friend_mobile = model.mobile;
//            addnew.comeFromVc = @"添加手机好友";
//            [self.navigationController pushViewController:addnew animated:YES];
        } else {
        }
    };
    cell.model = model;
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
                                        @"to_id":[NSString stringWithFormat:@"%@",friendId],
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
-(void)isexitOfFriend:(NSString * )userId success:(void(^)(id))Success Failed:(void(^)(NSError*))failed
{
    [MBProgressHUD showMessage:@"" toView:self.view];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
        });
    } failure:^(NSError *error) {
        failed(error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD createHUD:@"网络错误,请稍后重试" View:self.view];
        });
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
-(void)isExitOtherFriend:(NSString*)friendId success:(void(^)(id))Success andFailed:(void(^)(NSError*))failed
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/friend.ashx",IPADDRESS];
    NSDictionary * dictionary = @{@"action":@"isFriend",
                                  @"username":kShareModel.username,
                                  @"password":kShareModel.password,
                                  @"user_id":kShareModel.userId,
                                  @"friend_id":friendId};
    [WPHttpTool postWithURL:urlStr params:dictionary success:^(id json) {
        Success(json[@"status"]);
    } failure:^(NSError *error) {
        failed(error);
    }];

}
- (void)attenteUserWith:(NSIndexPath *)indexPath
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/attention.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    LinkMobileListModel *attModel = self.dataSource[indexPath.section][indexPath.row];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"attentionSigh";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //params[@"nick_name"] = userInfo[@"nick_name"];
    params[@"by_user_id"] = attModel.user_id;
    params[@"by_nick_name"] = attModel.user_name;
//    NSLog(@"*****%@",url);
//    NSLog(@"#####%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
//        if ([json[@"status"] integerValue] == 1) {
            [self.dataSource removeAllObjects];
            NSMutableArray *arr = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
            self.sectionTitle = arr;
            [self requireData];
//        }
    } failure:^(NSError *error) {
        
    }];

}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    if (![self.dataSource[index] count]) {
        return 0;
        
    }else{
        
        [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        return index;
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.dataSource count] == 0) {
        return nil;
    }else{
        return [self.sectionTitle objectAtIndex:section];
    }

}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = RGB(235, 235, 235);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 28)];
    [view addSubview:label];
    label.text = [self.sectionTitle objectAtIndex:section];
    label.textColor = [UIColor blackColor];
    label.font = kFONT(12);
    return view;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PersonalInfoViewController *personalInfo = [[PersonalInfoViewController alloc] init];
    personalInfo.ccindex = indexPath;
    LinkMobileListModel *model = self.dataSource[indexPath.section][indexPath.row];
    personalInfo.friendID = model.user_id;
    if ([model.isatt isEqualToString:@"2"]) { //添加
        personalInfo.newType = NewRelationshipTypeStranger;
    }else if([model.isatt isEqualToString:@"1"]){ // 等待验证
        personalInfo.newType = NewRelationshipTypeWaitConfirm;
    }
    else if ([model.isatt isEqualToString:@"6"])
    {
      personalInfo.newType = NewRelationshipTypeWaitConfirm;
    }
    else{ // 0 好友
        personalInfo.newType = NewRelationshipTypeFriend;
    }
    personalInfo.comeFromVc = @"添加手机好友";
    LinkMobileCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    self.addButton = cell.addButton;
    personalInfo.refresh = ^(NSIndexPath*index){
     LinkMobileListModel *model = self.dataSource[indexPath.section][indexPath.row];
        model.isatt = @"2";
        LinkMobileCell * cell = [self.tableView cellForRowAtIndexPath:index];
        [cell.addButton setTitle:@"添加" forState:UIControlStateNormal];
        cell.addButton.titleLabel.font = kFONT(12);
        [cell.addButton setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        cell.addButton .backgroundColor = RGB(0, 172, 255);
        cell.addButton.layer.masksToBounds = YES;
        cell.addButton.layer.cornerRadius = 5;
        cell.addButton.layer.borderWidth = 0.5;
        cell.addButton.layer.borderColor = RGB(226, 226, 226).CGColor;
        cell.addButton.enabled = YES;
    };
    [self.navigationController pushViewController:personalInfo animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
        //        NSLog(@"%@",addressBook.name);
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
                        //                        NSLog(@"%@",addressBook.telephone);
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
        [self.mobileData addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
}


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
    for (int i = 0;i < self.datas.count; i ++) {
        NSString * str = [self.datas[i] mobileName];
        if([str rangeOfString:key].location !=NSNotFound){
            [self.searchViewController.resultSource removeAllObjects];
            [self.searchViewController.resultSource addObject:self.datas[i]];
            [self.searchViewController.tableView reloadData];
        }else{
        }
    }
}

#pragma mark - 搜索控制器
- (MCSearchViewController *)searchViewController
{
    if (_searchViewController == nil) {
        _searchViewController = [[MCSearchViewController alloc] init];
        _searchViewController.delegate = self;
        
        //设置搜索控制器
        __weak MobileLinkController *weakSelf = self;
        __weak MCSearchViewController *weakSearch = _searchViewController;
        [_searchViewController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            static NSString *cellId = @"LinkMobileCell";
            LinkMobileCell *cell = [[LinkMobileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.model = weakSearch.resultSource[indexPath.row];
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
            [weakSelf.navigationController pushViewController:personInfo animated:YES];
        }];
        
    }
    
    return _searchViewController;
    
}

-(NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}



@end
