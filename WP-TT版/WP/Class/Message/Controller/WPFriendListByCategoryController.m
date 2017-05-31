//
//  WPFriendListByCategoryController.m
//  WP
//
//  Created by Kokia on 16/5/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPFriendListByCategoryController.h"
#import "WPChooseContactToNewCategoryController.h"
#import "MCSearchViewController.h"
#import "WPPhoneBookContactCell.h"
#import "WPGetContactListWithCategoryIDHttp.h"
#import "WPPhoneBookContactByCategoryCell.h"
#import "TableViewIndex.h"
#import "PersonalInfoViewController.h"
#import "WPPhoneBookContactDetailModel.h"
#import "WPFriendListController.h"
#import "WPJoinInTypeHttp.h"
#import "MTTDatabaseUtil.h"
@interface WPFriendListByCategoryController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MCSearchViewControllerDelegate,UISearchBarDelegate>{
    NSMutableArray *_searchResultArr;//搜索结果Arr
    BOOL transfer;
    BOOL selected;
    NSString *collectionid;
    NSString *NavTitle;
    
    NSString *types;// 要删除id字符串
    
    BOOL needSelect;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) NSMutableArray *datas;

@property (nonatomic,strong)MCSearchViewController *searchViewController;
@property (nonatomic,weak)UITextField *searchViw;
@property (nonatomic,weak)UIView *searchBar;

@property (nonatomic, strong) NSMutableArray *sectionTitle;

@property (nonatomic,strong)NSMutableArray *searchData; //搜索过的数据

@property (nonatomic,assign,getter=isSearching)BOOL searching;


@property (nonatomic ,strong)UIView *editView;
@property (nonatomic ,strong)NSMutableArray *selectedArr;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic ,strong) UIButton *editBtn;
@property (nonatomic ,strong) UIButton *selectedBtn;
@property (nonatomic ,strong) UIButton *deleteBtn;

@property (strong, nonatomic) UISearchBar *searchBar1;

@property (nonatomic ,assign) NSInteger countNum;

@end

@implementation WPFriendListByCategoryController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getBackToEdit];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self getContactListWithTypeid:self.typeId];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MTTDatabaseUtil instance] getFriendsCategoryDetail:self.typeId success:^(NSArray *array) {
        if (array.count) {
            NSDictionary * dic = @{@"list":array,@"status":@"1"};
            WPGetContactListWithCategoryIDResult *result = [WPGetContactListWithCategoryIDResult mj_objectWithKeyValues:dic];
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

        }
    }];
    
    
    
    self.title = self.categoryName;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNav];
    [self setupTableView];
//    [self setupSearchBar];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.sectionTitle = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];

    [self createEditView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JoinInTypeAction:) name:@"JoinInType" object:nil];
   
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


-(void)createEditView{
    self.editView = [[UIView alloc] init];
    self.editView.backgroundColor = [UIColor redColor];
    self.editView.layer.borderWidth = 0.5;
    self.editView.backgroundColor = [UIColor whiteColor];
    self.editView.layer.borderColor = RGBColor(178, 178, 178).CGColor;
    [self.view addSubview:_editView];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    
    self.selectedBtn = [[UIButton alloc] init];
    [self.selectedBtn setTitle:@"全选" forState:UIControlStateNormal];
    self.selectedBtn.titleLabel.font = kFONT(14);
    self.selectedBtn.hidden = YES;
    self.selectedBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -kHEIGHT(10), 0, 0);
    self.selectedBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.selectedBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
    [self.selectedBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editView addSubview:self.selectedBtn];
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editView.mas_left);
        make.height.bottom.equalTo(self.editView);
        make.width.equalTo(@80);
    }];
    
    
    
    CGSize normalSize = [@"字体" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = kFONT(14);
    self.deleteBtn.hidden = YES;
    [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editView addSubview:_deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editView.mas_right).with.offset(-kHEIGHT(10));
        make.height.bottom.equalTo(self.editView);
        make.width.equalTo(@(normalSize.width));
    }];
    
    CGSize normalSize1 = [@"字体" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    self.editBtn = [[UIButton alloc] init];
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = kFONT(14);
    self.editBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    if (_datas.count == 0) {
//        [self.editBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
//    }else{
//        [self.editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    }
    [self.editBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editView addSubview:_editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editView.mas_right).with.offset(-kHEIGHT(10));
        make.height.bottom.equalTo(self.editView);
        make.width.equalTo(@(normalSize1.width));
    }];
    

//    //选中计数按钮
//    UIButton *countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.countBtn = countBtn;
//    self.countBtn.backgroundColor = RGB(0, 172, 255);
//    self.countBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    self.countBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.countBtn.clipsToBounds = YES;
//    self.countBtn.hidden = YES;
//    self.countBtn.layer.cornerRadius = 10;
//    [self.countBtn setTitle:[NSString stringWithFormat:@"%lu",_countNum] forState:UIControlStateNormal];
//    [self.editView addSubview:self.countBtn];
//    [self.countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.deleteBtn.mas_left).with.offset(-3);
//        make.centerY.equalTo(self.deleteBtn);
//        make.width.height.equalTo(@20);
//    }];
//    
}


-(void)JoinInTypeAction:(NSNotification *)notice{
    NSString *type = notice.userInfo[@"types"];
    [self joinToTypeWithIds:type];
    [self getContactListWithTypeid:self.typeId];
}

-(void)popRefresh{
    [self getContactListWithTypeid:self.typeId];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}





#pragma mark -  点击右边按钮
- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    selected = !selected;
    if ([sender.title isEqualToString:@"转移"]) {
        [self transfer];
    }else{ // 正常跳转到下一个页面
        [self chooseContactToNewCategory];
    }
}


#pragma mark -  转移好友
- (void)transfer
{
    // 获取需要携带的转移信息
    for (WPPhoneBookContactDetailModel *model in self.datas) {
        if (model.selected) {
            if (types.length > 0) {  // 这里多选转移
                types = [NSString stringWithFormat:@"%@,%@",types ,model.friend_id];
            }else{   // 这里是单个转移
                types = model.friend_id;
            }
        }
        
    }
    if (types) {  // 有转移数据 则跳转类别页面
        WPFriendListController *category = [[WPFriendListController alloc] init];
        category.transferIDs = types;
        [self.navigationController pushViewController:category animated:YES];
    }else{
        return;  // 无数据转移  则什么都不做
        
    }

    
    // 实例化控制器跳转
    
}


#pragma mark -  更改title 0/n
- (void)selectedOfbuttonChanged
{
    int i = 0;
    for (WPPhoneBookContactDetailModel *model in self.selectedArr) {
        if (model.selected) {
            i++;
        }
    }
    self.title = [NSString stringWithFormat:@"%d/%ld",i,(unsigned long)self.selectedArr.count];
}


- (void)backToFromViewController:(UIButton *)sender
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"转移"]) {
         [self getBackToEdit];
        return;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -退回未编辑状态
- (void)getBackToEdit
{
    for (WPPhoneBookContactDetailModel *model in self.datas) {
        model.selected = NO;
        types = nil;
        [self.tableView reloadData];
    }
    self.title = self.categoryName;
    self.deleteBtn.hidden = YES;
    self.selectedBtn.hidden = YES;
    self.editBtn.hidden = NO;
    if (_datas.count == 0) {
        [self.editBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    }
    _countNum = 0;
    [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    self.deleteBtn.enabled = NO;
    needSelect = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collect"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
    transfer = NO;
}


#pragma mark -   点击删除和全选后的操作
- (void)buttonAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        if (self.datas.count == 0) {
            return;
        }
        needSelect = YES;
        self.selectedBtn.hidden = NO;
        self.deleteBtn.hidden = NO;
        self.editBtn.hidden = YES;
        [self.tableView reloadData];
        [self freshNav];
    }else if ([sender.titleLabel.text isEqualToString:@"全选"]){
        types = nil;
        for (WPPhoneBookContactDetailModel *model in self.datas) {
            model.selected = YES;
            [self.tableView reloadData];
            _countNum = self.datas.count;
        }
        self.deleteBtn.enabled = YES;
        [self.deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.title = [NSString stringWithFormat:@"%@(%ld/%lu)",self.categoryName,(long)_countNum,(unsigned long)self.datas.count];
        [sender setTitle:@"取消全选" forState:UIControlStateNormal];
        [self freshNav];
    }else if ([sender.titleLabel.text isEqualToString:@"取消全选"]){
        for (WPPhoneBookContactDetailModel *model in self.datas) {
            model.selected = NO;
            types = nil;
            _countNum = 0;
            [self.tableView reloadData];
        }
        self.deleteBtn.enabled = NO;
        [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        self.title = [NSString stringWithFormat:@"%@(%ld/%lu)",self.categoryName,(long)_countNum,(unsigned long)self.datas.count];
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        [self freshNav];
    }else {
        [self removeAction];
        [self freshNav];
    }
    
}


-(void)freshNav{
    if (_countNum == 0) {
        NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
        itemAttrs[NSFontAttributeName] = kFONT(14);
        itemAttrs[NSForegroundColorAttributeName] = RGB(127, 127, 127);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithTitle:@"转移" style:UIBarButtonItemStylePlain target:self  action:@selector(rightBarButtonItemAction:)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
        itemAttrs[NSFontAttributeName] = kFONT(14);
        itemAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithTitle:@"转移" style:UIBarButtonItemStylePlain target:self  action:@selector(rightBarButtonItemAction:)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }

}

#pragma mark - 删除操作
-(void)removeAction{
    for (WPPhoneBookContactDetailModel *model in self.datas) {
        if (model.selected) {
            if (types.length > 0) {  // 这里多选删除
                types = [NSString stringWithFormat:@"%@,%@",types ,model.friend_id];
            }else{   // 这里是单个删除
                types = model.friend_id;
            }
        }
        
    }
    if (types) {  // 如果删除数组里面有值提示这个提示框
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认将好友从该类别删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil] show];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"请至少选择一项" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        
    }
    

}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if ([alertView.message isEqualToString:@"确认将好友从该类别删除?"]) {
        if (buttonIndex == 1) {
            [self transferFriend:types];  //types就是要删除的ids
            
        }
    }
    [[alertView textFieldAtIndex:0] resignFirstResponder];
    
}




#pragma mark - 搜索控制器
- (MCSearchViewController *)searchViewController
{
    if (_searchViewController == nil) {
        _searchViewController = [[MCSearchViewController alloc] init];
        _searchViewController.delegate = self;
        
        //设置搜索控制器
        __weak WPFriendListByCategoryController *weakSelf = self;
        __weak MCSearchViewController *weakSearch = _searchViewController;
        [_searchViewController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            static NSString *cellId = @"WPPhoneBookContactByCategoryCell";
            WPPhoneBookContactByCategoryCell *cell = [[WPPhoneBookContactByCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.contactModel = weakSearch.resultSource[indexPath.row];
            return cell;
        }];
        //设置搜索cell的高度
        [_searchViewController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        ///设置选中cell后的操作
        
        [_searchViewController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            
            WPPhoneBookContactDetailModel *model = weakSearch.resultSource[indexPath.row];
            if (!model) {
                return;
            }
            PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
            personInfo.friendID = model.user_id;
            personInfo.skipType = @"cc";
            [weakSearch.navigationController pushViewController:personInfo animated:YES];
        }];
        
    }
    
    return _searchViewController;
    
}

#pragma mark -  获取联系人列表
-(void)getContactListWithTypeid:(NSString *)typeid{
    WPShareModel *model = [WPShareModel sharedModel];
    WPGetContactListWithCategoryIDParam *param = [[WPGetContactListWithCategoryIDParam alloc] init];
    param.action = @"GetFriendBytypeid";
    param.username = model.username;
    param.password = model.password;
    param.user_id = model.userId;
    param.typeid = typeid;
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
        }else{
            [MBProgressHUD showError:result.info];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
    
}

-(void)joinToTypeWithIds:(NSString *)Ids{
    WPShareModel *model = [WPShareModel sharedModel];
    WPJoinInTypeParam *param = [[WPJoinInTypeParam alloc] init];
    param.action = @"JoinInType";
    param.username = model.username;
    param.password = model.password;
    param.user_id = model.userId;
    param.typeid = self.typeId;
    param.friend_id = Ids;
    [WPJoinInTypeHttp WPJoinInTypeHttpWithParam:param success:^(WPJoinInTypeResult *result) {
        if (result.status.intValue == 1) {
//            [self getContactListWithTypeid:self.typeId];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:result.info];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
    
}

-(void)transferFriend:(NSString *)Ids{
    WPShareModel *model = [WPShareModel sharedModel];
    WPJoinInTypeParam *param = [[WPJoinInTypeParam alloc] init];
    param.action = @"JoinInType";
    param.username = model.username;
    param.password = model.password;
    param.user_id = model.userId;
    param.typeid = @"0";  //移出当前类别
    param.friend_id = Ids;
    [WPJoinInTypeHttp WPJoinInTypeHttpWithParam:param success:^(WPJoinInTypeResult *result) {
        if (result.status.intValue == 1) {
            types = nil;
            [self getBackToEdit];
            [self getContactListWithTypeid:self.typeId];
        }else{
            [MBProgressHUD showError:result.info];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
    
    
}



#pragma mark -  initNav
- (void)initNav{
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 22);
    [back addTarget:self action:@selector(backToFromViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
    imageV.image = [UIImage imageNamed:@"fanhui"];
    [back addSubview:imageV];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
    title.text = @"返回";
    title.font = kFONT(14);
    [back addSubview:title];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collect"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
}


-(void)chooseContactToNewCategory{
    WPChooseContactToNewCategoryController *chooseContact = [[WPChooseContactToNewCategoryController alloc] init];//self.backSuccess(titleString,json[@"users_name"],json[@"type_id"]);
    [self.navigationController pushViewController:chooseContact animated:YES];
}

#pragma mark - 设置tableView
-(void)setupTableView{
    //设置tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor= RGBCOLOR(238, 238, 238);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = WP_Line_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
//    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.tableView.tableHeaderView = self.searchBar1;
    
    //对于无数据的cell 不显示分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(40, 0, 0, 0));
//    }];
 
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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

#pragma mark - 数据源,代理方法

/**
 *  每一行显示怎样的cell
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [tableView tableViewDisplayWitMsg:@"暂无手机联系人" ifNecessaryForRowCount:self.dataList.count];
    if (self.dataList.count == 0) {
        self.editBtn.enabled = NO;
        [self.editBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    }else{
        self.editBtn.enabled = YES;
        [self.editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return  [self.dataList count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.dataList[section] count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"WPPhoneBookContactByCategoryCell";
    WPPhoneBookContactByCategoryCell *cell = [[WPPhoneBookContactByCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    if (needSelect) {
        cell.needSelect = needSelect;
    }
    cell.contactModel = self.dataList[indexPath.section][indexPath.row];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPPhoneBookContactByCategoryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"转移"]) {
        // 说明是在编辑状态
        cell.contactModel.selected = !cell.contactModel.selected;
        cell.button.selected = cell.contactModel.selected;
        
        //编辑状态下面还要对title进行处理self.dataList[indexPath.section][indexPath.row];
        if (cell.contactModel.selected == YES) {
            _countNum ++;
        }else{
            _countNum --;
        }
        if (_countNum < 0) {
            _countNum = 0;
        }
        if (_countNum == 0) {
            self.deleteBtn.enabled = NO;
            [self.deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        }else{
            self.deleteBtn.enabled = YES;
            [self.deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        NSInteger dataCount = 0;
        for (NSArray *arr in self.dataList) {
            dataCount += arr.count;
        }
        
        // 当不是全选操作的时候  单步多次全部选中  全选变取消全选  反之亦然
        if (_countNum== dataCount) {
            self.selectedBtn.hidden = NO;
            [self.selectedBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        }else if(_countNum == 0){
            [self.selectedBtn setTitle:@"全选" forState:UIControlStateNormal];
        }else{
            [self.selectedBtn setTitle:@"全选" forState:UIControlStateNormal];
        }

        [self freshNav];
        self.title = [NSString stringWithFormat:@"%@(%ld/%lu)",self.categoryName,(long)_countNum,(unsigned long)self.datas.count];
        
    }else{
        // 非编辑状态直接进入个人资料页面
        PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
        WPPhoneBookContactDetailModel *model = self.dataList[indexPath.section][indexPath.row];
        personInfo.friendID = model.friend_id;
        [self.navigationController pushViewController:personInfo animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 27)];
    [view addSubview:label];
    [label setTextColor:[UIColor grayColor]];
    [label setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    label.text = [self.sectionTitle objectAtIndex:section];
    label.font = kFONT(12);
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

-(NSMutableArray *)sectionTitle{
    if (_sectionTitle == nil) {
        _sectionTitle =  [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];

    }
    return _sectionTitle;
}


@end
