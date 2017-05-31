//
//  WPRecommendToFriendController.m
//  WP
//
//  Created by Kokia on 16/5/10.
//  Copyright © 2016年 WP. All rights reserved.
//  推荐给好友

#import "WPRecommendToFriendController.h"
#import "WPGetFriendListHttp.h"
#import "MCSearchViewController.h"
#import "WPPhoneBookFriendCell.h"
#import "TableViewIndex.h"

@interface WPRecommendToFriendController()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MCSearchViewControllerDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,strong)MCSearchViewController *searchViewController;
@property (nonatomic,weak)UITextField *searchViw;
@property (nonatomic,weak)UIView *searchBar;

@property (nonatomic,strong)NSMutableArray *searchData; //搜索过的数据

@property (nonatomic,assign,getter=isSearching)BOOL searching;

@property (strong,nonatomic) NSMutableArray *sectionTitle;

@end

@implementation WPRecommendToFriendController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    [self getFriendList];
    [self initNav];
    [self loadTableView];
    [self setupSearchBar];
    self.sectionTitle = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
    
    
}

- (MCSearchViewController *)searchViewController
{
    if (_searchViewController == nil) {
        _searchViewController = [[MCSearchViewController alloc] init];
        _searchViewController.delegate = self;
        
        //设置搜索控制器
        __weak WPRecommendToFriendController *weakSelf = self;
        __weak MCSearchViewController *weakSearch = _searchViewController;
        [_searchViewController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            WPPhoneBookFriendCell *cell = [WPPhoneBookFriendCell cellWithTableView:weakSelf.tableView];
            WPFriendListModel *model = weakSearch.resultSource[indexPath.row];
            cell.model = model;
            return cell;
        }];
        //设置搜索cell的高度
        [_searchViewController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        ///设置选中cell后的操作
        
        [_searchViewController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            
            WPFriendListModel *model = weakSearch.resultSource[indexPath.row];
            if (!model) {
                return;
            }
            
            //            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:weakSelf.districtModel.caName,@"districtName",model.raName ,@"communityName",model.raid,@"raid",nil];
            //            //创建通知
            //            NSNotification *notification =[NSNotification notificationWithName:@"YPSelectRegionNotification" object:nil userInfo:dict];
            //            //通过通知中心发送通知
            //            [[NSNotificationCenter defaultCenter] postNotification:notification];
            //            for (UIViewController *temp in weakSelf.navigationController.viewControllers) {
            //                if ([temp isKindOfClass:[YPAddAddressController class]]||[temp isKindOfClass:[YPEditAddressController class]]) {
            //                    weakSelf.navigationController.navigationBar.hidden=YES;
            //                    [weakSelf.navigationController popToViewController:temp animated:YES];
            //                }
            //            }
            //            
        }];
        
    }
    
    return _searchViewController;
    
}


#pragma mark - 数据相关
-(void)getFriendList{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPGetFriendListParam *param = [[WPGetFriendListParam alloc] init];
    param.action = @"GetFriend";
    param.username = model.username;
    param.password = model.password;
    param.user_id = userInfo[@"userid"];
    
    
    [WPGetFriendListHttp WPGetFriendListHttpWithParam:param success:^(WPGetFriendListResult *result) {
        if (result.status.intValue == 1) {
            [self.dataList removeAllObjects];
            self.dataList = [TableViewIndex transfer:result.list];
        
            for (int i = (int)self.dataList.count-1; i>=0; i--) {
                if ([self.dataList[i] count] == 0) {
                    [self.sectionTitle removeObjectAtIndex:i];
                    [self.dataList removeObjectAtIndex:i];
                }
            }
            [self.tableView reloadData];

//            [MBProgressHUD createHUD:result.info View:self.view];
        }else{
            [MBProgressHUD showError:result.info];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
    
}

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

#pragma mark - 好友类别
-(void)loadTableView{
    //设置tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 44) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor= RGBCOLOR(238, 238, 238);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = WP_Line_Color;
    self.tableView.rowHeight = [WPPhoneBookFriendCell cellHeight];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
    
    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    self.tableView.tableHeaderView = self.searchBar;
    
    //对于无数据的cell 不显示分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(6, 0, 0, 0));
    }];
    
    
}





#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPPhoneBookFriendCell *cell = [WPPhoneBookFriendCell cellWithTableView:tableView];
    cell.model = self.dataList[indexPath.section][indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//点击索引跳转到相应位置
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    if (![self.dataList[index] count]) {
        return 0;
        
    }else{
        
        [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
        return index;
    }
}

//分区标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.dataList count] == 0) {
        return nil;
    }else{
        return [self.sectionTitle objectAtIndex:section];
    }
}

//索引标题
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(20))];
    view.backgroundColor = RGB(235, 235, 235);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 28)];
    [label setTextColor:RGB(127, 127, 127)];
    [label setFont:[UIFont systemFontOfSize:kHEIGHT(10)]];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view.mas_left).with.offset(kHEIGHT(10));
    }];
    label.text = [self.sectionTitle objectAtIndex:section];
    label.textColor = [UIColor blackColor];
    label.font = kFONT(12);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHEIGHT(20);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
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
        NSString * str = [self.datas[i] nick_name];
        if([str rangeOfString:key].location !=NSNotFound){
            [self.searchViewController.resultSource removeAllObjects];
            [self.searchViewController.resultSource addObject:self.datas[i]];
            [self.searchViewController.tableView reloadData];
        }else{
        }
    }
}


-(NSArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

-(NSArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}


@end
