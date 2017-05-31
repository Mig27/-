//
//  WPDynamicGroupViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/4/13.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPDynamicGroupViewController.h"
#import "WPSelectButton.h"
#import "RSButtonMenu.h"
#import "JobGroupModel.h"
#import "WPGroupCell.h"

#import "WPAllSearchController.h"
#import "WPGroupCreateViewController.h"
#import "WPGroupInformationViewController.h"


@interface WPDynamicGroupViewController ()<UISearchBarDelegate,RSButtonMenuDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic,strong) NSMutableArray *buttons;

/**附近，行业 */
@property (nonatomic,strong) WPSelectButton *button5;
@property (nonatomic,strong) WPSelectButton *button6;

@property (nonatomic,strong) RSButtonMenu *buttonMenu1;
@property (nonatomic,strong) RSButtonMenu *buttonMenu2;

@property (nonatomic,strong) UIView *backView1;
@property (nonatomic,strong) UIView *backView2;

@property (nonatomic,assign) NSUInteger index1;

@property (nonatomic,assign) NSUInteger index2;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *dataSource2;

@property (nonatomic, strong) NSMutableArray *myCreate;
@property (nonatomic, strong) NSMutableArray *myAdd;

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *industryId;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *tableView2;

@property (nonatomic,assign) NSUInteger page;
@property (nonatomic,assign) BOOL isFirst;

@end

@implementation WPDynamicGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = NO;
    // Do any additional setup after loading the view.
    [self initDataSource];
    [self initNav];
    [self.view addSubview:self.headView];
//    [self loadData];
    [self.tableView.mj_header beginRefreshing];
    [self tableView2];
    self.tableView2.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(updateInfo)
                                          name:@"groupDataUpdate"
                                          object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOrDeleteSuccessRefreshData) name:@"groupUpdate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOrDeleteSuccessRefreshData) name:@"deletegroupUpdate" object:nil];
}
-(void)addOrDeleteSuccessRefreshData
{
    
    
    _page = 1;
    [self requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
//        [_tableView.mj_header endRefreshing];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:datas];
        [_tableView reloadData];
    } Error:^(NSError *error) {
//        [_tableView.mj_header endRefreshing];
    }];

    
    
    
//    [self.tableView.mj_header beginRefreshing];
}
- (void)initNav
{
    self.view.backgroundColor = BackGroundColor;
    self.title = @"职场群组";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

#pragma mark - 初始化数据源
- (void)initDataSource
{
    self.buttons = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    self.dataSource2 = [NSMutableArray array];
    self.myCreate = [NSMutableArray array];
    self.myAdd = [NSMutableArray array];
    self.index2 = 0;
    self.index1 = 0;
    self.action = @"is_near";
    self.industryId = @"1";
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"groupDataUpdate" object:nil];
}

- (void)updateInfo
{
    if ([self.action isEqualToString:@"is_near"]) {
        self.tableView2.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
    } else {
        self.tableView.hidden = YES;
        self.tableView2.hidden = NO;
//      [self.tableView2.mj_header beginRefreshing];
        
        _page = 1;
        [self requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
            [_tableView2 setContentOffset:CGPointMake(0, 0)];
            [self.myCreate removeAllObjects];
            [self.myAdd removeAllObjects];
            for (JobGroupListModel *model in datas) {
                if ([model.gtype isEqualToString:@"1"]) {
                    [self.myCreate addObject:model];
                } else {
                    [self.myAdd addObject:model];
                }
            }
            [self.dataSource2 removeAllObjects];
            [self.dataSource2 addObject:self.myCreate];
            [self.dataSource2 addObject:self.myAdd];
            [_tableView2 reloadData];
        } Error:^(NSError *error) {
        }];
    }
}

- (void)rightBtnClick
{
    WPGroupCreateViewController *create = [[WPGroupCreateViewController alloc] init];
    create.createSuccessBlock = ^(){
        if ([self.action isEqualToString:@"is_near"]) {
            self.tableView2.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
            [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
        } else {
            self.tableView.hidden = YES;
            self.tableView2.hidden = NO;
            [self.tableView2.mj_header beginRefreshing];
        }
    };
    [self.navigationController pushViewController:create animated:YES];
}

- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SEARCHBARHEIGHT + kHEIGHT(32))];
        _headView.backgroundColor = [UIColor whiteColor];
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SEARCHBARHEIGHT)];
        searchBar.delegate = self;
        searchBar.placeholder = @"搜索";
        searchBar.tintColor = [UIColor lightGrayColor];
        searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        searchBar.keyboardType = UIKeyboardTypeDefault;
        searchBar.backgroundColor = WPColor(235, 235, 235);
        
        for (UIView* view in searchBar.subviews) {
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
        [_headView addSubview:searchBar];
        
        UIView *ledgement = [UIView new];
        ledgement.backgroundColor = RGB(226, 226, 226);
        [_headView addSubview:ledgement];
        
        [ledgement mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headView.mas_bottom).offset(-0.5);
            make.left.right.equalTo(_headView);
            make.height.equalTo(@(0.5));
        }];
        
        CGFloat width = SCREEN_WIDTH/2;
        NSArray *titles = @[@"附近",@"行业"];
        
        for (int i=0; i<titles.count; i++) {
            WPSelectButton *btn = [[WPSelectButton alloc] initWithFrame:CGRectMake(width*i, searchBar.bottom, width, kHEIGHT(32))];
            [btn setLabelText:titles[i]];
            btn.image.image = [UIImage imageNamed:@"arrow_down"];
            
            [_headView addSubview:btn];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(width*i, searchBar.bottom, width, kHEIGHT(32));
            button.tag = 10 + i;
            [button addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_buttons addObject:button];
            
            [_headView addSubview:button];
            
            btn.isSelected = button.isSelected;
            
            if (i != 0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width*i,SEARCHBARHEIGHT + (kHEIGHT(32) - 15)/2, 0.5, 15)];
                line.backgroundColor = RGB(226, 226, 226);
                [_headView addSubview:line];
            }
            
            if (i==0) {
                self.button5 = btn;
            } else if (i==1) {
                self.button6 = btn;
            }
        }
    }
    return _headView;
}

#pragma mark - 封装网络请求
- (void)requestWithPageIndex:(NSInteger)page andIsNear:(BOOL)isNear Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
    NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = self.action;
//        params[@"action"] = @"MyGroup";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    params[@"industryId"] = self.industryId;
    if (isNear) {
        params[@"page"] = [NSString stringWithFormat:@"%ld",(long)page];
        params[@"longitude"] = longitude;
        params[@"latitude"] = latitude;
    } else {
        params[@"keyWords"] = @"";
    }
    if (!self.isFirst) {
        self.isFirst = YES;
        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    }
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",json);
        JobGroupModel *model = [JobGroupModel mj_objectWithKeyValues:json];
//        NSArray *arr = [[NSArray alloc] initWithArray:json[@"list"]];
        success(model.list,(int)model.list.count);
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD createHUD:@"网络错误" View:self.view];
        NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
    }];
    
}

- (void)loadData
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group.ashx"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = self.action;
//    params[@"action"] = @"MyGroup";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    params[@"industryId"] = self.industryId;
//    if (isNear) {
    params[@"page"] = @"1";
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
//    } else {
//        params[@"keyWords"] = @"";
//    }
    NSLog(@"***%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
    }];

}

#pragma mark tableView
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = [WPGroupCell rowHeight];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        
//        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//        }
//        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
//        }
        
        __weak typeof(self) unself = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableView.mj_footer resetNoMoreData];
            _page = 1;
            [unself requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
                [_tableView.mj_header endRefreshing];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:datas];
                [_tableView reloadData];
            } Error:^(NSError *error) {
                [_tableView.mj_header endRefreshing];
            }];
        }];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [unself requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
                [_tableView.mj_footer endRefreshing];
                if (more == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.dataSource addObjectsFromArray:datas];
                }
                [unself.tableView reloadData];
            } Error:^(NSError *error) {
                [_tableView.mj_footer endRefreshing];
                _page--;
            }];
        }];
        
    }
    
    return _tableView;
}

#pragma mark tableView
- (UITableView *)tableView2
{
   
    if (_tableView2 == nil) {
        _tableView2 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.rowHeight = [WPGroupCell rowHeight];
        _tableView2.backgroundColor = [UIColor whiteColor];
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView2];
        [_tableView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        if ([_tableView2 respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView2 setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([_tableView2 respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView2 setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        __weak typeof(self) unself = self;
        self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableView2.mj_footer resetNoMoreData];
            _page = 1;
            [unself requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
                [_tableView2 setContentOffset:CGPointMake(0, 0)];
                [_tableView2.mj_header endRefreshing];
                [self.myCreate removeAllObjects];
                [self.myAdd removeAllObjects];
                for (JobGroupListModel *model in datas) {
                    if ([model.gtype isEqualToString:@"1"]) {
                        [self.myCreate addObject:model];
                    } else {
                        [self.myAdd addObject:model];
                    }
                }
                [self.dataSource2 removeAllObjects];
                [self.dataSource2 addObject:self.myCreate];
                [self.dataSource2 addObject:self.myAdd];
                [_tableView2 reloadData];
            } Error:^(NSError *error) {
                [_tableView2.mj_header endRefreshing];
            }];
        }];
        
    }
    
    return _tableView2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataSource2.count == 0 && tableView == _tableView2) {
        return 0;
    }
    if (tableView == _tableView) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource2.count == 0 && tableView == _tableView2) {
        return 0;
    }
    if (tableView == _tableView) {
        return self.dataSource.count;
    } else {
        return [self.dataSource2[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        WPGroupCell *cell = [WPGroupCell cellWithTableView:tableView];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    } else {
        WPGroupCell *cell = [WPGroupCell cellWithTableView:tableView];
        cell.model = self.dataSource2[indexPath.section][indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return 0.01;
    } else {
        if ([self.dataSource2[section] count] == 0) {
            return 0.01;
        } else {
            return kHEIGHT(20);
        }
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(20))];
    view.backgroundColor = RGB(235, 235, 235);
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), 0, SCREEN_WIDTH - 20, kHEIGHT(20))];
    headLabel.textColor = RGB(127, 127, 127);
    headLabel.font = kFONT(12);
    [view addSubview:headLabel];
        if (section == 0) {
            headLabel.text = @"我创建的群";
        } else {
            headLabel.text = @"我加入的群";
        }
    if ([self.dataSource2[section] count] == 0) {
        return nil;
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPGroupInformationViewController *information = [[WPGroupInformationViewController alloc] init];
    JobGroupListModel *model = [[JobGroupListModel alloc] init];
    information.isFromZhiChang = YES;
    if (tableView == _tableView) {
        model = self.dataSource[indexPath.row];
    } else {
        model = self.dataSource2[indexPath.section][indexPath.row];
    }
    information.joinSuccees= ^(NSIndexPath*index){
        JobGroupListModel *model = [[JobGroupListModel alloc] init];
        if (tableView == _tableView) {
            model = self.dataSource[indexPath.row];
        } else {
            model = self.dataSource2[indexPath.section][indexPath.row];
        }
        model.gtype = @"1";
    };
    information.titleStr = model.group_name;
    information.group_id = model.g_id;
    information.groupId = model.group_id;
    information.gtype = model.gtype;
    information.index = indexPath;
    [self.navigationController pushViewController:information animated:YES];
}

#pragma mark 筛选框 按钮点击
- (void)selectBtnClick:(UIButton *)sender
{
    NSMutableArray *timeArr = [NSMutableArray array];
    
    // 最新
    NSArray *time = @[@"附近群组",@"我的群组"];
    
    // to do
    
    for (int i = 0; i<time.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = time[i];
        model.industryID = [NSString stringWithFormat:@"%d",i + 1];
        [timeArr addObject:model];
    }
    
    self.backView1.hidden = YES;
    self.backView2.hidden = YES;
    if (sender.tag == 10) {//点击附近
        if (!sender.isSelected) {//
            [self.buttonMenu1 setLocalType:timeArr andSelectIndex:self.index1];
            self.button5.selected = YES;
            _backView1.hidden = NO;
        } else {
            _backView1.hidden = YES;
            self.button5.selected = NO;
        }
        self.button6.selected = NO;
    } else if(sender.tag == 11){//点击行业
        self.button5.selected = NO;
        if (!sender.isSelected) {
            self.buttonMenu2.isFromGroup = YES;
            [self.buttonMenu2 newSetUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getIndustry",@"fatherid":@"0"}selectedIndex:self.index2];
            self.button6.selected = YES;
            _backView2.hidden = NO;
        } else {
            _backView2.hidden = YES;
            self.button6.selected = NO;
        }
        
    }
    
    for (int i = 0; i<_buttons.count; i++) {
        UIButton *btn = _buttons[i];
        if (i == sender.tag - 10) {
            btn.selected = !btn.selected;
        } else {
            btn.selected = NO;
        }
    }
    
}

- (RSButtonMenu *)buttonMenu1
{
    if (!_buttonMenu1) {
        _buttonMenu1 = [[RSButtonMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - kHEIGHT(32))];
        
        _buttonMenu1.delegate = self;
        _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(32) + 64 + SEARCHBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - SEARCHBARHEIGHT)];
        _backView1.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_backView1];
        
        [_backView1 addSubview:_buttonMenu1];
        
        __weak typeof(self) unself = self;
        _buttonMenu1.touchHide = ^(){
            [unself hidden];
        };
        
    }
    return _buttonMenu1;
}

- (RSButtonMenu *)buttonMenu2
{
    if (!_buttonMenu2) {
        _buttonMenu2 = [[RSButtonMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _buttonMenu2.delegate = self;
        _backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(32) + 64 + SEARCHBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - SEARCHBARHEIGHT)];
        _backView2.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_backView2];
        [_backView2 addSubview:_buttonMenu2];
        __weak typeof(self) unself = self;
        _buttonMenu2.touchHide = ^(){
            [unself hidden];
        };
    }
    return _buttonMenu2;
}

- (void)hidden{
    self.backView1.hidden = YES;
    self.backView2.hidden = YES;
    self.button5.selected = NO;
    self.button6.selected = NO;
    for (UIButton *button in _buttons) {
        button.selected = NO;
    }
}

#pragma mark - RSButtonMenuDelegate
- (void)RSButtonMenuDelegate:(id)model selectMenu:(RSButtonMenu *)menu selectIndex:(NSInteger)index
{
    if ([menu isEqual:_buttonMenu1]) {
        IndustryModel *new = (IndustryModel *)model;
        [self.button5 setLabelText:[new.industryName substringToIndex:new.industryName.length - 2]];
        if ([new.industryID isEqualToString:@"1"]) {
            self.action = @"is_near";
        } else {
            self.action = @"MyGroup";
        }
        self.index1 = index;
    } else {
        IndustryModel *new = (IndustryModel *)model;
        [self.button6 setLabelText:new.industryName];
        self.industryId = new.industryID;
        self.index2 = index;
        if ([new.industryID isEqualToString:@"1"]) {
            [self.button6 setLabelText:@"行业"];
        }
    }
    if ([self.action isEqualToString:@"is_near"]) {
        self.tableView2.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
    } else {
        self.tableView.hidden = YES;
        self.tableView2.hidden = NO;
        [self.tableView2 setContentOffset:CGPointMake(0, 0) animated:NO];
//        [self.tableView2.mj_header beginRefreshing];
        [self requstTableview2];
    }
    [self hidden];
}

- (void)delay
{
//        [self.tableView.mj_header beginRefreshing];
    [self requstTableview];
}
-(void)requstTableview
{
    _page = 1;
    [self requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:datas];
        [_tableView reloadData];
    } Error:^(NSError *error) {
    }];
}
-(void)requstTableview2
{
    _page = 1;
    [self requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
        [self.myCreate removeAllObjects];
        [self.myAdd removeAllObjects];
        for (JobGroupListModel *model in datas) {
            if ([model.gtype isEqualToString:@"1"]) {
                [self.myCreate addObject:model];
            } else {
                [self.myAdd addObject:model];
            }
        }
        [self.dataSource2 removeAllObjects];
        [self.dataSource2 addObject:self.myCreate];
        [self.dataSource2 addObject:self.myAdd];
        [_tableView2 reloadData];
    } Error:^(NSError *error) {
    }];
}

#pragma mark - UISerachBar Deleagte
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    WPAllSearchController *search = [[WPAllSearchController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:search];
    [self presentViewController:navc animated:NO completion:nil];
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
