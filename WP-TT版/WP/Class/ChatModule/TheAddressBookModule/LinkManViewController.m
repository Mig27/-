//
//  LinkManViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/12/22.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "LinkManViewController.h"

#import "WPHttpTool.h"
#import "WPShareModel.h"
#import "LinkManModel.h"
#import "LinkGroupModel.h"
#import "TableViewIndex.h"
#import "LinkmanCell.h"
#import "LinkGroupCell.h"
#import "WPAllSearchController.h"
#import "AddNewFriendController.h"
#import "InterestedViewController.h"
#import "LinkAddViewController.h"
#import "PersonalInfoViewController.h"
#import "WPMyGroupController.h"
#import "WPFriendListController.h"
#import "WPConcernNumberController.h"
#import "WPGetAddMeInfoHttp.h"
#import "WPAddMePersonCell.h"
#import "WPAddMePeopleCell.h"
#import "WPPhoneBookFriendSettingDetailController.h"
#import "WPGetFriendInfoHttp.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LinkmanInfoModel.h"
#import "MTTDatabaseUtil.h"
@interface LinkManViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>
{
    LinkmanCell *currentCell;
}
@property (nonatomic,strong) UIView *line;              // 标识line
@property (nonatomic,assign) NSInteger currentPage;     // 当前显示的是在第几页

@property (nonatomic,strong) NSMutableArray *data1;
@property (nonatomic,strong) NSMutableArray *datas;  //所有的数据

@property (nonatomic,strong) NSMutableArray *dataList; //加我为好友人的数据

@property (nonatomic,strong) UITableView *table1;

@property (nonatomic,strong) NSMutableArray *tableViews;  //所有的列表

@property (strong,nonatomic) NSMutableArray *sectionTitle1;
@property (strong,nonatomic) NSMutableArray *sectionTitles;

@property (strong, nonatomic) UISearchBar *searchBar1;

@property (nonatomic, strong) LinkManListModel *selectedModel;

@property (nonatomic, strong) WPGetFriendInfoResult *result;
@end

@implementation LinkManViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[MTTDatabaseUtil instance] getLinkMan:^(NSArray *array) {
        NSDictionary * dic = @{@"list":array};
        LinkManModel *model = [LinkManModel mj_objectWithKeyValues:dic];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:model.list];
        [self addMember:arr];
    }];
    
    
    
    [self getAddMeInfo];
    // 请求好友组数据；
    // 请求好友数据，并且转换为拼音索引；
    [self requireDataWithAciont:@"GetFriend" Success:^(NSArray *datas) {
        [self addMember:datas];
//        [self.data1 removeAllObjects];
//        self.data1 = [TableViewIndex transfer:datas];
//        self.sectionTitle1 = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
//        for (int i = (int)self.data1.count-1; i>=0; i--) {
//            if ([self.data1[i] count] == 0) {
//                [self.sectionTitle1 removeObjectAtIndex:i];
//                [self.data1 removeObjectAtIndex:i];
//            }
//        }
//        NSMutableArray *firstArr = [NSMutableArray array];
//        LinkManListModel *model = [[LinkManListModel alloc] init];
//        model.user_name = @"新的好友";
//        model.avatar = [UIImage imageNamed:@"linkman_1"];
//        
//        LinkManListModel *model1 = [[LinkManListModel alloc] init];
//        model1.user_name = @"我的群组";
//        model1.avatar = [UIImage imageNamed:@"txl_wodqunzu"];
//        
//        LinkManListModel *model2 = [[LinkManListModel alloc] init];
//        model2.user_name = @"好友类别";
//        model2.avatar = [UIImage imageNamed:@"txl_haoyouleibie"];
//        
//        LinkManListModel *model3 = [[LinkManListModel alloc] init];
//        model3.user_name = @"关注号";
//        model3.avatar = [UIImage imageNamed:@"txl_guanzhuhao"];
//        
//        [firstArr addObject:model];
//        [firstArr addObject:model1];
//        [firstArr addObject:model2];
//        [firstArr addObject:model3];
//        
//        [self.data1 insertObject:firstArr atIndex:0];
//        [self.sectionTitle1 insertObject:@"" atIndex:0];
//        [self.table1 reloadData];
    } Error:^(NSError *error) {
    }];
}
-(void)addMember:(NSArray*)datas
{
    [self.data1 removeAllObjects];
    self.data1 = [TableViewIndex transfer:datas];
    self.sectionTitle1 = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
    for (int i = (int)self.data1.count-1; i>=0; i--) {
        if ([self.data1[i] count] == 0) {
            [self.sectionTitle1 removeObjectAtIndex:i];
            [self.data1 removeObjectAtIndex:i];
        }
    }
    NSMutableArray *firstArr = [NSMutableArray array];
    LinkManListModel *model = [[LinkManListModel alloc] init];
    model.user_name = @"新的好友";
    model.avatar = [UIImage imageNamed:@"linkman_1"];
    
    LinkManListModel *model1 = [[LinkManListModel alloc] init];
    model1.user_name = @"我的群组";
    model1.avatar = [UIImage imageNamed:@"txl_wodqunzu"];
    
    LinkManListModel *model2 = [[LinkManListModel alloc] init];
    model2.user_name = @"好友类别";
    model2.avatar = [UIImage imageNamed:@"txl_haoyouleibie"];
    
    LinkManListModel *model3 = [[LinkManListModel alloc] init];
    model3.user_name = @"关注号";
    model3.avatar = [UIImage imageNamed:@"txl_guanzhuhao"];
    
    [firstArr addObject:model];
    [firstArr addObject:model1];
    [firstArr addObject:model2];
//    [firstArr addObject:model3];
    
    [self.data1 insertObject:firstArr atIndex:0];
    [self.sectionTitle1 insertObject:@"" atIndex:0];
    [self.table1 reloadData];
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    self.title = @"通讯录";
    self.currentPage = 0;
//    [self initDatasource];
// 请求好友组数据；
//    [self requireGroupDataSuccess:^(NSArray *datas) {
//        [self.table1 reloadData];
//    } Error:^(NSError *error) {
//    }];
    if ([self.table1 respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table1 setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.table1 respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.table1 setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)rightButtonClick
{
    NSLog(@"右按钮点击");
    LinkAddViewController *add = [[LinkAddViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)initDatasource
{
    self.data1 = [NSMutableArray array];
    self.datas = [[NSMutableArray alloc] initWithObjects:_data1,nil];
    self.sectionTitle1 = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
    
    self.sectionTitles = [[NSMutableArray alloc] initWithObjects:_sectionTitle1, nil];
    
//    [self table1];

}

- (UITableView *)table1
{
    if (_table1 == nil) {//64
        _table1 = [[UITableView alloc] initWithFrame:CGRectMake(64, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 44) style:UITableViewStylePlain];
        _table1.delegate = self;
        _table1.dataSource = self;
        
        _table1.tableFooterView = [[UIView alloc] init];
        _table1.sectionIndexColor = [UIColor blackColor];//
        [_table1 setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_table1 setSectionIndexColor:[UIColor darkGrayColor]];
        [_table1 setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
        _table1.tableHeaderView = self.searchBar1;
        _table1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.view addSubview:_table1];
        
        [_table1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
        }];
        
        // 请求好友数据，并且转换为拼音索引；
//        [self requireDataWithAciont:@"GetFriend" Success:^(NSArray *datas) {
//            [self.data1 removeAllObjects];
//            self.data1 = [TableViewIndex archive:datas];
//            self.sectionTitle1 = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
//            for (int i = (int)self.data1.count-1; i>=0; i--) {
//                if ([self.data1[i] count] == 0) {
//                    [self.sectionTitle1 removeObjectAtIndex:i];
//                    [self.data1 removeObjectAtIndex:i];
//                }
//            }
//            
//            NSMutableArray *firstArr = [NSMutableArray array];
//            LinkManListModel *model = [[LinkManListModel alloc] init];
//            model.user_name = @"新的好友";
//            model.avatar = [UIImage imageNamed:@"linkman_1"];
//            
//            LinkManListModel *model1 = [[LinkManListModel alloc] init];
//            model1.user_name = @"我的群组";
//            model1.avatar = [UIImage imageNamed:@"txl_wodqunzu"];
//            
//            LinkManListModel *model2 = [[LinkManListModel alloc] init];
//            model2.user_name = @"好友类别";
//            model2.avatar = [UIImage imageNamed:@"txl_haoyouleibie"];
//            
//            LinkManListModel *model3 = [[LinkManListModel alloc] init];
//            model3.user_name = @"关注号";
//            model3.avatar = [UIImage imageNamed:@"txl_guanzhuhao"];
//            
//            [firstArr addObject:model];
//            [firstArr addObject:model1];
//            [firstArr addObject:model2];
//            [firstArr addObject:model3];
//            
//
//            [self.data1 insertObject:firstArr atIndex:0];
//            [self.sectionTitle1 insertObject:@"" atIndex:0];
//            NSLog(@"11111%@",_data1);
//            [_table1 reloadData];
//        } Error:^(NSError *error) {
//            
//        }];
    }
    return _table1;
}

#pragma mark - 请求组数据
- (void)getAddMeInfo
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPGetAddMeInfoParam *param = [[WPGetAddMeInfoParam alloc] init];
    param.action = @"GetBeMyFriend";
    param.username = model.username;
    param.password = model.password;
    param.user_id = userInfo[@"userid"];
    [WPGetAddMeInfoHttp WPGetAddMeInfoHttpWithParam:param success:^(WPGetAddMeInfoResult *result) {
        if (result.status.intValue == 1) {
            [self.dataList removeAllObjects];
//            [self.data1 removeAllObjects];
            [self.dataList addObjectsFromArray:result.list];
            [self.table1 reloadData];
        }else{
            [self.dataList removeAllObjects];
//            [self.data1 removeAllObjects];
            [self.dataList addObjectsFromArray:result.list];
            [self.table1 reloadData];
        }
    } failure:^(NSError *error) {
//        [MBProgressHUD showError:@"网络不给力哦"];
    }];
}

- (void)requireGroupDataSuccess:(RequiredSuccessBlock)success Error:(RequiredErrorBlock)errors
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"GetGroup";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        LinkGroupModel *model = [LinkGroupModel mj_objectWithKeyValues:json];
        NSArray *arr1 = [[NSArray alloc] initWithArray:model.mycreated];
        NSArray *arr2 = [[NSArray alloc] initWithArray:model.myjoin];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:arr1,arr2, nil];
        success(arr);
        [self.table1 reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
    }];
}

#pragma mark - 长按处理
-(void)longPressCell:(UILongPressGestureRecognizer *)gestureRecognizer{
    // 判断长按状态
    if ([gestureRecognizer state]==UIGestureRecognizerStateBegan)
    {
        //必须设置为第一响应者
        currentCell = (LinkmanCell *)gestureRecognizer.view;
        NSIndexPath *indexPath = [self.table1 indexPathForCell:currentCell];
        self.selectedModel = self.data1[indexPath.section][indexPath.row];
        [currentCell becomeFirstResponder];
        currentCell.selected = YES;
        //得到菜单栏
        UIMenuController *menuController = [UIMenuController sharedMenuController];
//        [menuController setMenuVisible:NO];
        //设置菜单
        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"备注" action:@selector(menuItem:)];
        UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"好友类别" action:@selector(menuItem2:)];
        [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem2, nil]];
        //设置菜单栏位置
        [menuController setTargetRect:currentCell.frame inView:currentCell.superview];
        //显示菜单栏
        [menuController setMenuVisible:YES animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
    }
}

//ios开发中，默认是在同一时间只能有一个手势被执行，要实现多个手势同时进行，须实现
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)WillHideMenu:(id)sender
{
    currentCell.selected = NO;
}

//点击备注
-(void)menuItem:(id)sender
{
    WPPhoneBookFriendSettingDetailController *detail = [[WPPhoneBookFriendSettingDetailController alloc] init];
    detail.vcTitle = @"设置备注名称";
    detail.friendID = self.selectedModel.friend_id;
    detail.friendName = self.selectedModel.user_name;
    detail.TFContent = self.selectedModel.nick_name;
    [self.navigationController pushViewController:detail animated:YES];
}

//点击好友类别
-(void)menuItem2:(id)sender
{
    WPPhoneBookFriendSettingDetailController *detail = [[WPPhoneBookFriendSettingDetailController alloc] init];
    detail.vcTitle = @"设置好友类别";
    detail.friendName = self.selectedModel.nick_name == nil?self.selectedModel.user_name : self.selectedModel.nick_name;
    detail.friendID = self.selectedModel.friend_id;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)requireDataWithAciont:(NSString *)action Success:(RequiredSuccessBlock)success Error:(RequiredErrorBlock)errors
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/friend.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = action;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        [[MTTDatabaseUtil instance] deleteAllLinkMan];
        LinkManModel *model = [LinkManModel mj_objectWithKeyValues:json];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:model.list];
        success(arr);
        [[MTTDatabaseUtil instance] upDateLinkMan:json[@"list"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
        [[MTTDatabaseUtil instance] getLinkMan:^(NSArray *array) {
            NSDictionary * dic = @{@"list":array};
            LinkManModel *model = [LinkManModel mj_objectWithKeyValues:dic];
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:model.list];
            success(arr);
        }];
    }];
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataList.count >=1 && indexPath.section == 0  && indexPath.row == 0) {
        return kHEIGHT(72);
    }else{
        return kHEIGHT(50);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data1 count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data1[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //注册长按事件
    if (self.dataList.count >= 1 && indexPath.section ==0 && indexPath.row == 0) {
        if (self.dataList.count > 1) {
            WPAddMePeopleCell *cell = [WPAddMePeopleCell cellWithTableView:tableView];
            cell.dataList = self.dataList;
            return cell;
        }else{
            WPAddMePersonCell *cell = [WPAddMePersonCell cellWithTableView:tableView];
            cell.model = self.dataList[0];
            return cell;
        }
    }else{
        LinkmanCell *cell = [LinkmanCell cellWithTableView:tableView];
        cell.model = self.data1[indexPath.section][indexPath.row];
        if (indexPath.section != 0) {
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCell:)];
            [longPressGesture setDelegate:self];
            [cell addGestureRecognizer:longPressGesture];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                AddNewFriendController *add = [[AddNewFriendController alloc] init];
                NSString *friend_id = [[NSString alloc] init];
                if (self.dataList.count>0) {
                    add.isHaveFriend = @"1";
                    for (int i = 0; i<self.dataList.count; i++) {
                        if (self.dataList.count > 1) {
                            if (i == 0) {
                                friend_id = [self.dataList[i] user_id];
                            }else{
                                friend_id = [NSString stringWithFormat:@"%@,%@",friend_id ,[self.dataList[i] user_id]];
                            }
                        }else{   // 这里是单个转移
                            friend_id = [self.dataList[i] user_id];
                        }
                    }
                    add.friend_id = friend_id;
                }
                [self.navigationController pushViewController:add animated:YES];
            } else if (indexPath.row == 1){//我的群组
                WPMyGroupController *myGroup  = [[WPMyGroupController alloc] init];
                [self.navigationController pushViewController:myGroup animated:YES];
            } else if (indexPath.row == 2) {//好友类别
                WPFriendListController *friendList  = [[WPFriendListController alloc] init];
                [self.navigationController pushViewController:friendList animated:YES];
            } else if (indexPath.row == 3) {
                WPConcernNumberController *concernNum  = [[WPConcernNumberController alloc] init];
                [self.navigationController pushViewController:concernNum animated:YES];
            }
        } else {
            PersonalInfoViewController *personalInfo = [[PersonalInfoViewController alloc] init];
            LinkManListModel *model = self.data1[indexPath.section][indexPath.row];
            personalInfo.friendID = model.friend_id;
            personalInfo.comeFromVc = @"通讯录";
            personalInfo.personalinfoModel = model;
            personalInfo.title = @"好友资料";
            [self.navigationController pushViewController:personalInfo animated:YES];
        }
}

//点击索引跳转到相应位置
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        if (![self.data1[index] count]) {
            return 0;
        }else{
            [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            return index;
        }
}

//分区标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        if ([self.data1 count] == 0) {
            return nil;
        }else{
            return [self.sectionTitle1 objectAtIndex:section];
        }
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


//索引标题
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitle1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = RGB(235, 235, 235);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 28)];
        [view addSubview:label];
        label.text = [self.sectionTitle1 objectAtIndex:section];
        label.textColor = [UIColor blackColor];
        label.font = kFONT(12);
        return view;
}

- (UISearchBar *)searchBar1{
    if (!_searchBar1) {
        _searchBar1 = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar1.tintColor = [UIColor lightGrayColor];
        _searchBar1.backgroundColor = WPColor(235, 235, 235);
        _searchBar1.barStyle     = UIBarStyleDefault;
        _searchBar1.translucent  = YES;
        _searchBar1.placeholder = @"搜索";
        _searchBar1.delegate = self;
        [_searchBar1 sizeToFit];
        for (UIView *view in _searchBar1.subviews) {
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
    return _searchBar1;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    WPAllSearchController *search = [[WPAllSearchController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:search];
    [self presentViewController:navc animated:NO completion:nil];
    return NO;
}
//
//#pragma mark - 底部按钮的创建
//- (void)createUI
//{
//    self.mainScrol = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - BOTTOMHEIGHT)];
//    self.mainScrol.contentSize = CGSizeMake(SCREEN_WIDTH*4, SCREEN_HEIGHT - 64 - BOTTOMHEIGHT);
//    self.mainScrol.pagingEnabled = YES;
//    self.mainScrol.delegate = self;
//    //self.mainScrol.backgroundColor = RGB(235, 235, 235);
//    
//    self.mainScrol.backgroundColor = [UIColor redColor];
//    
//    
//    self.mainScrol.showsHorizontalScrollIndicator = NO;
//    self.mainScrol.showsVerticalScrollIndicator = NO;
//    [self.view addSubview:self.mainScrol];

//    for (int i=0; i<4; i++) {
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 200, SCREEN_WIDTH, 20)];
//        titleLabel.text = [NSString stringWithFormat:@"第%d页",i+1];
//        titleLabel.textColor = [UIColor redColor];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        [self.mainScrol addSubview:titleLabel];
//    }
//}

#pragma mark - 底部按钮的创建
//- (void)createBottom
//{
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.mainScrol.bottom, SCREEN_WIDTH, BOTTOMHEIGHT + 0.5)];
//    backView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:backView];
//    
//    // 上面的分割线
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT  - BOTTOMHEIGHT - 0.5, SCREEN_WIDTH, 0.5)];
//    view.backgroundColor = RGBColor(178, 178, 178);
//    [self.view addSubview:view];
//    
//    // 标识line
//    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, BOTTOMHEIGHT - 3, SCREEN_WIDTH/4, 3)];
//    self.line.backgroundColor = RGBColor(10, 110, 210);
//    [backView addSubview:self.line];
//    
//    CGFloat linwWidth = 0.5;
//    CGFloat btnWidth = (SCREEN_WIDTH - 3)/4;
//    
//    NSArray *titles = @[@"好友",@"关注",@"粉丝",@"群组"];
//    
//    for (int i = 0; i<[titles count]; i++) {
//        
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((btnWidth + linwWidth)*i, 0, btnWidth, BOTTOMHEIGHT)];
//        button.tag = i+1;
//        [button setTitle:titles[i] forState:UIControlStateNormal];
//        button.titleLabel.font = kFONT(15);
//        
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
//        
//        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [backView addSubview:button];
//        
//        if (i != 3) {
//            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btnWidth*(i+1), (BOTTOMHEIGHT - 15)/2, linwWidth, 15)];
//            line.backgroundColor = RGBColor(178, 178, 178);
//            [backView addSubview:line];
//        }
//        
//        if (i == 0) {
//            button.selected = YES;
//            self.button1 = button;
//        } else if (i == 1) {
//            self.button2 = button;
//        } else if (i == 2) {
//            self.button3 = button;
//        } else if (i == 3) {
//            self.button4 = button;
//        }
//    }
//    
//}

//#pragma mark 按钮点击事件
//- (void)btnClick:(UIButton *)sender
//{
//    //    [self keyBoardDismiss];
//    
//    self.currentPage = sender.tag - 1;
//    
//    //
//    [UIView animateWithDuration:0.3 animations:^{
//        if (self.currentPage == 3) {
//            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , BOTTOMHEIGHT - 3, (SCREEN_WIDTH - 2)/3 + 3, 3);
//        } else {
//            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*(sender.tag - 1) , BOTTOMHEIGHT - 3, SCREEN_WIDTH/4, 3);
//        }
//    }];
//    
//    self.mainScrol.contentOffset = CGPointMake(SCREEN_WIDTH * (sender.tag - 1), 0);
//    if (sender.tag == 1) {
//        self.button1.selected = YES;
//        self.button2.selected = NO;
//        self.button3.selected = NO;
//        self.button4.selected = NO;
//        [self table1];
//    }
////    else if (sender.tag == 2) {
////        self.button1.selected = NO;
////        self.button2.selected = YES;
////        self.button3.selected = NO;
////        self.button4.selected = NO;
////        [self table2];
////    } else if (sender.tag == 3) {
////        self.button1.selected = NO;
////        self.button2.selected = NO;
////        self.button3.selected = YES;
////        self.button4.selected = NO;
////        [self table3];
////    } else if (sender.tag == 4) {
////        self.button1.selected = NO;
////        self.button2.selected = NO;
////        self.button3.selected = NO;
////        self.button4.selected = YES;
////        [self table4];
////    }
////    [self refreshIsNeedEmpty:NO];
////    [self.tableViews[self.currentPage] reloadData];
//}

#pragma mark - scrollView delegate
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if ([scrollView isKindOfClass:[UITableView class]]) {
//        return;
//    }
//    
//    if ([scrollView isEqual:self.mainScrol]) {
//        NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
//        [self btnClickWithIndex:index];
//    }
//    
//}

//- (void)btnClickWithIndex:(NSInteger)index
//{
//    self.currentPage = index;
//    [UIView animateWithDuration:0.3 animations:^{
//        if (self.currentPage == 3) {
//            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , BOTTOMHEIGHT - 3, (SCREEN_WIDTH - 2)/3 + 3, 3);
//        } else {
//            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*self.currentPage , BOTTOMHEIGHT - 3, SCREEN_WIDTH/4, 3);
//        }
//    }];
//    
//    if (index == 0) {
//        self.button1.selected = YES;
//        self.button2.selected = NO;
//        self.button3.selected = NO;
//        self.button4.selected = NO;
//        [self table1];
//    } else if (index == 1) {
//        self.button1.selected = NO;
//        self.button2.selected = YES;
//        self.button3.selected = NO;
//        self.button4.selected = NO;
//        [self table2];
//    } else if (index == 2) {
//        self.button1.selected = NO;
//        self.button2.selected = NO;
//        self.button3.selected = YES;
//        self.button4.selected = NO;
//        [self table3];
//    } else if (index == 3) {
//        self.button1.selected = NO;
//        self.button2.selected = NO;
//        self.button3.selected = NO;
//        self.button4.selected = YES;
//        [self table4];
//    }
////    [self refreshIsNeedEmpty:NO];
////    [self.tableViews[self.currentPage] reloadData];
//}

-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

-(NSMutableArray *)data1{
    if (_data1 == nil) {
        _data1 = [NSMutableArray array];
    }
    return _data1;
}
@end
