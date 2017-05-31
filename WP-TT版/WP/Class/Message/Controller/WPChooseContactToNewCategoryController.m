//
//  WPChooseContactToNewCategoryController.m
//  WP
//
//  Created by Kokia on 16/5/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPChooseContactToNewCategoryController.h"
#import "WPGetContactListHttp.h"
#import "MCSearchViewController.h"
#import "WPPhoneBookContactCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LinkmanInfoModel.h"

#import "AddNewFriendController.h"
#import "WPGetFriendListHttp.h"
#import "TableViewIndex.h"
#import "WPGetContactListWithCategoryIDHttp.h"
#import "WPFriendListController.h"
#import "WPJoinInTypeHttp.h"
#import "WPHttpTool.h"

@interface WPChooseContactToNewCategoryController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchBarDelegate,UISearchDisplayDelegate,MCSearchViewControllerDelegate,UIAlertViewDelegate>{
      BOOL needSelect;
     NSString *types;// 要添加的id字符串
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,weak)UITextField *searchViw;

@property (nonatomic,strong)UIView *searchBar;

@property (nonatomic,strong)NSMutableArray *searchData; //搜索过的数据

@property (nonatomic,assign,getter=isSearching)BOOL searching;

@property (nonatomic,strong)MCSearchViewController *searchViewController;


@property (nonatomic, strong) NSMutableArray *linkmanDatasource; /**< 手机联系人 */

@property (nonatomic, strong) NSMutableArray *sectionTitle;

@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,strong) NSMutableArray *datas;


@property (nonatomic ,strong)UIView *editView;
@property (nonatomic ,strong)NSMutableArray *selectedArr;
@property (nonatomic ,strong)UISearchBar *search;

@property (nonatomic ,strong)UIButton *doneBtn;
@property (nonatomic ,assign)NSInteger countNum;

@property (nonatomic ,strong)UILabel *makeView;



@end


@implementation WPChooseContactToNewCategoryController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getFriendList];
}


- (MCSearchViewController *)searchViewController
{
    if (_searchViewController == nil) {
        _searchViewController = [[MCSearchViewController alloc] init];
        _searchViewController.delegate = self;
        
        //设置搜索控制器
        __weak WPChooseContactToNewCategoryController *weakSelf = self;
        __weak MCSearchViewController *weakSearch = _searchViewController;
        [_searchViewController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            WPPhoneBookContactCell *cell = [WPPhoneBookContactCell cellWithTableView:weakSelf.tableView];
            cell.contactModel = weakSearch.resultSource[indexPath.row];
            return cell;
        }];
        //设置搜索cell的高度
        [_searchViewController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return kHEIGHT(50);
        }];
        ///设置选中cell后的操作
        
        [_searchViewController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            
            WPPhoneBookContactModel *model = weakSearch.resultSource[indexPath.row];
            if (!model) {
                return;
            }
            
            }];
        
    }
    
    return _searchViewController;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(238, 238, 238);
    [self initNav];
    self.title = @"选择联系人";
    [self setupTableView];
    [self setupSearchBar];
    self.sectionTitle = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
    
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
    
    [self freshNavi];
}

-(void)freshNavi{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.makeView];
    UIButton *wan = [UIButton buttonWithType:UIButtonTypeCustom];
    [wan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    wan.titleLabel.textAlignment = NSTextAlignmentCenter;
    wan.titleLabel.font = kFONT(14);
    CGSize normalSize = [@"完成" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    wan.frame = CGRectMake(0, 0, normalSize.width, normalSize.height);
    [wan setTitle:@"完成" forState:UIControlStateNormal];
    self.doneBtn = wan;
    [wan addTarget:self action:@selector(rightBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    if (_countNum == 0) {
        [self.doneBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        self.doneBtn.enabled = NO;
    }else{
        [self.doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.doneBtn.enabled = YES;
    }
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:wan];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    negativeSpacer.width = -12;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightItem1,rightItem];
}


- (UILabel *)makeView{
    if (!_makeView) {
        UILabel *makeView = [[UILabel alloc] init];
        makeView.textColor = [UIColor whiteColor];
        makeView.textAlignment = NSTextAlignmentCenter;
        makeView.font = [UIFont systemFontOfSize:13];
        makeView.frame = CGRectMake(-20, 12, 20, 20);
        makeView.hidden = YES;
        makeView.layer.cornerRadius = makeView.frame.size.height / 2.0;
        makeView.clipsToBounds = YES;
        makeView.backgroundColor = RGB(0, 172, 255);
        self.makeView = makeView;
        
    }
    return _makeView;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
      NSString * userid = [NSString new];
       NSString * titleString = [alertView textFieldAtIndex:0].text;
        if (!titleString.length) {
            [MBProgressHUD createHUD:@"请填写备注名称" View:self.view];
            return;
        }
        else
        {
            
            for (WPPhoneBookContactDetailModel *model in self.datas) {
                if (model.selected) {
                    if (userid.length > 0) {  // 这里批量增加
                        userid = [NSString stringWithFormat:@"%@,%@",userid ,model.friend_id];
                    }else{   // 这里是单个添加
                        userid = model.friend_id;
                    }
                }
            }
        }
        
        NSDictionary * dic = @{@"action":@"addfriendstype",@"users_id":userid,@"type_name":titleString,@"user_id":kShareModel.userId};
        NSString * urlStr = [NSString stringWithFormat:@"%@/ios/speak_manage.ashx",IPADDRESS];
        [MBProgressHUD showMessage:@"" toView:self.view];
        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
            if ([json[@"status"] isEqualToString:@"1"]) {
                if (self.backSuccess) {
                    self.backSuccess(titleString,json[@"users_name"],json[@"type_id"],userid);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [MBProgressHUD createHUD:@"添加失败" View:self.view];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD createHUD:@"网络错误" View:self.view];
        }];
        
        
    }
}
-(void)rightBarButtonItemAction{
    if (self.isFromOpen)//从公开中选择
    {
        UIAlertView *customAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请备注名称，下次可直接使用。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
        customAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        customAlertView.delegate = self;
        [customAlertView show];
    }
    else if (self.isFromList)
    {
        for (WPPhoneBookContactDetailModel *model in self.datas) {
            if (model.selected) {
                if (self.userList.length > 0) {  // 这里批量增加
                    self.userList = [NSString stringWithFormat:@"%@,%@",self.userList ,model.friend_id];
                }else{   // 这里是单个添加
                    self.userList = model.friend_id;
                }
            }
        }
        
        NSDictionary * dic = @{@"action":@"updatetyoeinfo",@"typeid":self.typeID,@"user_id":kShareModel.userId,@"users_id":self.userList};
        NSString * urlStr = [NSString stringWithFormat:@"%@/ios/speak_manage.ashx",IPADDRESS];
        [MBProgressHUD showMessage:@"" toView:self.view];
        [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
            if ([json[@"status"] isEqualToString:@"1"]) {
                if (self.addSuccess) {
                    self.addSuccess();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [MBProgressHUD createHUD:@"添加失败" View:self.view];
            }
        } failure:^(NSError *error) {
           [MBProgressHUD createHUD:@"网络错误" View:self.view];
        }];
    }
    else
    {
        for (WPPhoneBookContactDetailModel *model in self.datas) {
            if (model.selected) {
                if (types.length > 0) {  // 这里批量增加
                    types = [NSString stringWithFormat:@"%@,%@",types ,model.friend_id];
                }else{   // 这里是单个添加
                    types = model.friend_id;
                }
            }
            
        }
        if (types) {  // 有添加数据 则跳转
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:types,@"types",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JoinInType" object:self userInfo:dict];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            return;  // 无数据转移  则什么都不做
            
        }
    }
//    for (WPPhoneBookContactDetailModel *model in self.datas) {
//        if (model.selected) {
//            if (types.length > 0) {  // 这里批量增加
//                types = [NSString stringWithFormat:@"%@,%@",types ,model.friend_id];
//            }else{   // 这里是单个添加
//                types = model.friend_id;
//            }
//        }
//        
//    }
//    if (types) {  // 有添加数据 则跳转
//        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:types,@"types",nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"JoinInType" object:self userInfo:dict];
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        return;  // 无数据转移  则什么都不做
//        
//    }
}

-(void)backToFromVC{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -  获取联系人列表
-(void)getFriendList{
    WPShareModel *model = [WPShareModel sharedModel];
    WPGetContactListWithCategoryIDParam *param = [[WPGetContactListWithCategoryIDParam alloc] init];
    param.action = @"GetFriendBytypeid";
    param.username = model.username;
    param.password = model.password;
    param.user_id = model.userId;
    param.typeid = @"0";
    [WPGetContactListWithCategoryIDHttp WPGetContactListWithCategoryIDHttpWithParam:param success:^(WPGetContactListWithCategoryIDResult *result) {
        if (result.status.intValue == 1) {
            [self.dataList removeAllObjects];
            [self.datas removeAllObjects];
            [self.datas addObjectsFromArray:result.list];
            self.dataList = [TableViewIndex transfer:self.datas];
            self.sectionTitle = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
            for (int i = (int)self.dataList.count-1; i>=0; i--) {
                if ([self.dataList[i] count] == 0) {
                    [self.sectionTitle removeObjectAtIndex:i];
                    [self.dataList removeObjectAtIndex:i];
                }
            }
            [self.tableView reloadData];
            [self freshNavi];
        }else{
            [MBProgressHUD showError:result.info];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
}



#pragma mark - 设置tableView
-(void)setupTableView{
    //设置tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 44) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
//    self.tableView.backgroundColor= RGBCOLOR(238, 238, 238);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = WP_Line_Color;
    
    //这里是替换右边索引的颜色和tablevIew一样
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
    [_tableView setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.tableView.tableHeaderView = self.searchBar;
    
    //对于无数据的cell 不显示分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(40, 0, 0, 0));
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

#pragma mark - 数据源,代理方法

/**
 *  每一行显示怎样的cell
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [tableView tableViewDisplayWitMsg:@"暂无手机联系人" ifNecessaryForRowCount:self.dataList.count];
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList[section] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPPhoneBookContactCell *cell = [WPPhoneBookContactCell cellWithTableView:self.tableView];
//    cell.contactModel = self.dataList[indexPath.section][indexPath.row];
    if (self.isFromList && self.userList.length)
    {
        [cell model:self.dataList[indexPath.section][indexPath.row] selected:self.userList];
    }
    else
    {
      cell.contactModel = self.dataList[indexPath.section][indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WPPhoneBookContactCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contactModel.selected = !cell.contactModel.selected;
    cell.button.selected = cell.contactModel.selected;
    if ([cell.contactModel.canSelect isEqualToString:@"1"]) {
        return;
    }
    if (cell.contactModel.selected == YES) {
        _countNum++;
    }else{
        _countNum--;
    }
    if (_countNum == 0 ) {
        _countNum = 0;
    }
    self.makeView.text = [NSString stringWithFormat:@"%ld",(long)_countNum];
    if (_countNum == 0) {
        self.makeView.hidden = YES;
        self.makeView.hidden = YES;
        [self.doneBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        self.doneBtn.enabled = NO;
    }else{
        self.makeView.hidden = NO;
        self.doneBtn.enabled = YES;
        [self.makeView setText:[NSString stringWithFormat:@"%ld",(long)_countNum]];
        [self.doneBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
    }
    
    [self addAnimationToCountBtn];
    
    
    [self.tableView reloadData];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)addAnimationToCountBtn{
    [self.makeView.layer removeAllAnimations];
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    [self.makeView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT(50);
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    if (![self.dataList[index] count]) {
        return 0;
        
    }else{
        
        [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        return index;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.dataList count] == 0) {
        return nil;
    }else{
        return [self.sectionTitle objectAtIndex:section];
    }
    
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.dataList.count == 0) {
        return nil;
    }
    return self.sectionTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = RGB(235, 235, 235);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 28)];
    [view addSubview:label];
    [label setTextColor:[UIColor grayColor]];
    [label setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    label.text = [self.sectionTitle objectAtIndex:section];
//    label.textColor = [UIColor blackColor];
    label.font = kFONT(12);
    return view;
    
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



#pragma mark - lazy load
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

-(NSArray *)linkmanDatasource{
    if (_linkmanDatasource == nil) {
        _linkmanDatasource = [NSMutableArray array];
    }
    return _linkmanDatasource;
}



@end
