//
//  NearActivityViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/10/8.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "NearActivityViewController.h"
#import "ListView.h"

#import "WPHttpTool.h"
#import "WPShareModel.h"
#import "NearActivityModel.h"
#import "MJRefresh.h"
#import "NearActivityCell.h"
#import "OtherActivityController.h"

@interface NearActivityViewController ()<UITextFieldDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UITabBarDelegate,UITableViewDataSource,UIScrollViewDelegate,UITableViewDelegate>

@property (nonatomic, strong) UISearchBar* searchBarTwo;
@property (nonatomic, strong) UISearchDisplayController *mySearchDisplayController;
@property (nonatomic,strong) UIScrollView *mainScrol;

@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;
@property (nonatomic,strong) UIButton *button4;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,assign) NSInteger currentPage;//当前是第几页
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *game_type;
@property (nonatomic,strong) NSMutableArray *game_types;//当前每个页面请求的类型

@property (nonatomic,strong) NSMutableArray *data1;
@property (nonatomic,strong) NSMutableArray *data2;
@property (nonatomic,strong) NSMutableArray *data3;
@property (nonatomic,strong) NSMutableArray *data4;
@property (nonatomic,strong) NSMutableArray *datas;  //所有的数据

@property (nonatomic,strong) UITableView *table1;
@property (nonatomic,strong) UITableView *table2;
@property (nonatomic,strong) UITableView *table3;
@property (nonatomic,strong) UITableView *table4;
@property (nonatomic,strong) NSMutableArray *tableViews;  //所有的列表

@end

@implementation NearActivityViewController
{
    NSInteger _page1;
    NSInteger _page2;
    NSInteger _page3;
    NSInteger _page4;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTranslucent:NO];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.currentPage = 0;
    [self.view setBackgroundColor:WPColor(235, 235, 235)];
    [self.view addSubview:self.searchBarTwo];
    [self createUI];
    [self initDataSource];
//    [self setsearchDisplayController];
    [self initNav];
    [self createBottom];
    [self.table1.mj_header beginRefreshing];
//    [self reloadData];
}

- (void)initNav
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

- (void)rightBtnClick
{
//    OtherActivityController *other = [[OtherActivityController alloc] init];
//    [self.navigationController pushViewController:other animated:YES];
}


#pragma mark - 初始化数据源
- (void)initDataSource
{
    _page1 = 1;
    _page2 = 1;
    _page3 = 1;
    _page4 = 1;
    self.game_type = @"0";
    self.type = @"0";
    
    self.data1 = [NSMutableArray array];
    self.data2 = [NSMutableArray array];
    self.data3 = [NSMutableArray array];
    self.data4 = [NSMutableArray array];
    self.datas = [[NSMutableArray alloc] initWithObjects:_data1,_data2,_data3,_data4,nil];
    self.tableViews = [[NSMutableArray alloc] initWithObjects:self.table1,self.table2,self.table3,self.table4,nil];
    self.game_types = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",nil];
}

- (UITableView *)table1
{
    if (_table1 == nil) {
        _table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 168 - 64) style:UITableViewStyleGrouped];
        _table1.delegate = self;
        _table1.dataSource = self;
        _table1.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table1.backgroundColor = RGB(235, 235, 235);
        [self.mainScrol addSubview:_table1];
        __weak typeof(self) unself = self;
        self.table1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.table1.mj_footer resetNoMoreData];
            _page1 = 1;
            [unself requestWithPageIndex:_page1 andIsNear:YES Success:^(NSArray *datas, int more) {
                [self.data1 removeAllObjects];
                [self.data1 addObjectsFromArray:datas];
                [_table1 reloadData];
            } Error:^(NSError *error) {

            }];
            [_table1.mj_header endRefreshing];
        }];
        
        self.table1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page1++;
            [unself requestWithPageIndex:_page1 andIsNear:YES Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.table1.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.data1 addObjectsFromArray:datas];
                }
                [unself.table1 reloadData];
            } Error:^(NSError *error) {
                _page1--;
            }];
            [_table1.mj_footer endRefreshing];
        }];

    }
    return _table1;
}

- (UITableView *)table2
{
    if (_table2 == nil) {
        _table2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 168 - 64) style:UITableViewStyleGrouped];
        _table2.delegate = self;
        _table2.dataSource = self;
        _table2.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table2.backgroundColor = RGB(235, 235, 235);
        [self.mainScrol addSubview:_table2];
        __weak typeof(self) unself = self;
        self.table2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.table2.mj_footer resetNoMoreData];
            _page2 = 1;
            [unself requestWithPageIndex:_page2 andIsNear:NO Success:^(NSArray *datas, int more) {
                [self.data2 removeAllObjects];
                [self.data2 addObjectsFromArray:datas];
                [_table2 reloadData];
            } Error:^(NSError *error) {
                
            }];
            [_table2.mj_header endRefreshing];
        }];
        
        self.table2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page2++;
            [unself requestWithPageIndex:_page2 andIsNear:NO Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.table2.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.data2 addObjectsFromArray:datas];
                }
                [unself.table2 reloadData];
            } Error:^(NSError *error) {
                _page2--;
            }];
            [_table2.mj_footer endRefreshing];
        }];
        
    }
    return _table2;
}

- (UITableView *)table3
{
    if (_table3 == nil) {
        _table3 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 168 - 64) style:UITableViewStyleGrouped];
        _table3.delegate = self;
        _table3.dataSource = self;
        _table3.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table3.backgroundColor = RGB(235, 235, 235);
        [self.mainScrol addSubview:_table3];
        __weak typeof(self) unself = self;
        self.table3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.table3.mj_footer resetNoMoreData];
            _page3 = 1;
            [unself requestWithPageIndex:_page3 andIsNear:NO Success:^(NSArray *datas, int more) {
                [self.data3 removeAllObjects];
                [self.data3 addObjectsFromArray:datas];
                [_table3 reloadData];
            } Error:^(NSError *error) {
                
            }];
            [_table3.mj_header endRefreshing];
        }];
        
        self.table3.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page3++;
            [unself requestWithPageIndex:_page3 andIsNear:NO Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.table3.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.data3 addObjectsFromArray:datas];
                }
                [unself.table3 reloadData];
            } Error:^(NSError *error) {
                _page3--;
            }];
            [_table3.mj_footer endRefreshing];
        }];
        
    }
    return _table3;
}

- (UITableView *)table4
{
    if (_table4 == nil) {
        _table4 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 168 - 64) style:UITableViewStyleGrouped];
        _table4.delegate = self;
        _table4.dataSource = self;
        _table4.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table4.backgroundColor = RGB(235, 235, 235);
        [self.mainScrol addSubview:_table4];
        __weak typeof(self) unself = self;
        self.table4.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.table4.mj_footer resetNoMoreData];
            _page4 = 1;
            [unself requestWithPageIndex:_page4 andIsNear:NO Success:^(NSArray *datas, int more) {
                [self.data4 removeAllObjects];
                [self.data4 addObjectsFromArray:datas];
                [_table4 reloadData];
            } Error:^(NSError *error) {
                
            }];
            [_table4.mj_header endRefreshing];
        }];
        
        self.table4.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page4++;
            [unself requestWithPageIndex:_page4 andIsNear:NO Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.table4.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.data4 addObjectsFromArray:datas];
                }
                [unself.table4 reloadData];
            } Error:^(NSError *error) {
                _page4--;
            }];
            [_table4.mj_footer endRefreshing];
        }];
        
    }
    return _table4;
}


//- (void)reloadData{
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *userInfo = model.dic;
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/game.ashx"];
//    NSLog(@"*****%@",url);
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page1];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"getlist";
//    params[@"page"] = page;
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = userInfo[@"userid"];
//    //    params[@"nick_name"] = userInfo[@"nick_name"];
//    //    params[@"longitude"] = [user objectForKey:@"longitude"];
//    //    params[@"latitude"] = [user objectForKey:@"latitude"];
//    params[@"longitude"] = @"";
//    params[@"latitude"] = @"";
//    params[@"game_type"] = @"0";
//    params[@"type"] = @"0";
//    NSLog(@"*****%@",params);
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@",json);
//    } failure:^(NSError *error) {
//        
//    }];
//
//}

- (void)requestWithPageIndex:(NSInteger)page andIsNear:(BOOL)isNear Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/game.ashx"];
    NSLog(@"*****%@",url);
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page1];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getlist";
    params[@"page"] = [NSString stringWithFormat:@"%ld",(long)page];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //是附近，添加经纬度
    if (isNear) {
        //    params[@"longitude"] = [user objectForKey:@"longitude"];
        //    params[@"latitude"] = [user objectForKey:@"latitude"];
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    }
    params[@"game_type"] = self.game_type;
    params[@"type"] = self.type;
    NSLog(@"*****%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        NearActivityModel *model = [NearActivityModel mj_objectWithKeyValues:json];
        NSArray *arr = [[NSArray alloc] initWithArray:model.GameList];
        success(arr,(int)arr.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
    }];

}

#pragma mark - tabelView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datas[self.currentPage] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearActivityCell *cell = [NearActivityCell cellWithTableView:tableView];
    NearActivityListModel *model = self.datas[self.currentPage][indexPath.row];
//    cell.titleLabel.text = model.title;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(UISearchBar *)searchBarTwo
{
    if (_searchBarTwo == nil) {
        self.searchBarTwo = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 4, SCREEN_WIDTH, SEARCHBARHEIGHT/2+12)];
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

- (void)createUI
{
    NSArray *titles = @[@"求职·招聘",@"学习·讲座",@"论坛·峰会",@"相亲·聚会",@"户外·活动"];
    NSArray *images = @[@"activity_apply",@"activity_study",@"activity_topic",@"activity_party",@"activity_outdoor"];
    ListView *list = [[ListView alloc] initWithFrame:CGRectMake(0, self.searchBarTwo.bottom + 4, SCREEN_WIDTH, 80)];
    list.titles = titles;
    list.images = images;
//    list.selectIndex = self.selectIndex;
    [list makeContain];
    list.buttonClick = ^(NSInteger index,NSString *title){
    NSLog(@"index: %ld ,title: %@",(long)index,title);
        OtherActivityController *other = [[OtherActivityController alloc] init];
        if (index == 0) {
            other.game_type = @"1";
        } else if (index == 1) {
            other.game_type = @"2";
        } else if (index == 2) {
            other.game_type = @"3";
        } else if (index == 3) {
            other.game_type = @"5";
        } else if (index == 4) {
            other.game_type = @"4";
        }
        other.titleStr = title;
        [self.navigationController pushViewController:other animated:YES];
//        [self refresh];
    };
    [self.view addSubview:list];
//    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 80.5, SCREEN_WIDTH, 0.5)];
//    line2.backgroundColor = RGB(178, 178, 178);
//    [self.view addSubview:line2];

    self.mainScrol = [[UIScrollView alloc] initWithFrame:CGRectMake(0, list.bottom + 6, SCREEN_WIDTH, SCREEN_HEIGHT - 168 - 64)];
    self.mainScrol.contentSize = CGSizeMake(SCREEN_WIDTH*4, SCREEN_HEIGHT - 168 - 64);
    self.mainScrol.pagingEnabled = YES;
    self.mainScrol.delegate = self;
    self.mainScrol.backgroundColor = RGBColor(235, 235, 235);
        self.mainScrol.backgroundColor = [UIColor whiteColor];
    self.mainScrol.showsHorizontalScrollIndicator = NO;
    self.mainScrol.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainScrol];
    for (int i = 0; i<4; i++) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 100, SCREEN_WIDTH, 20)];
        title.text = [NSString stringWithFormat:@"第%d页",i+1];
        title.textAlignment = NSTextAlignmentCenter;
        [self.mainScrol addSubview:title];
    }

}

#pragma mark - 底部按钮的创建
- (void)createBottom
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.mainScrol.bottom, SCREEN_WIDTH, 43.5)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    //    self.bottomScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 104, SCREEN_WIDTH , 41)];
    //    self.bottomScroll.contentSize = CGSizeMake(SCREEN_WIDTH*2, 40);
    //    //    self.bottomScroll.backgroundColor = [UIColor yellowColor];
    //    self.bottomScroll.alwaysBounceVertical = NO;
    //    self.bottomScroll.alwaysBounceHorizontal = YES;
    //    self.bottomScroll.pagingEnabled = YES;
    //    self.bottomScroll.showsHorizontalScrollIndicator = NO;
    //    self.bottomScroll.showsVerticalScrollIndicator = NO;
    //    self.bottomScroll.delegate = self;
    //    //    self.bottomScroll.layer.borderColor = RGBColor(226, 226, 226).CGColor;
    //    //    self.bottomScroll.layer.borderWidth = 1.0;
    //    [self.view addSubview:self.bottomScroll];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 107, SCREEN_WIDTH, 0.5)];
    view.backgroundColor = RGBColor(178, 178, 178);
    [self.view addSubview:view];
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH/4, 3)];
    self.line.backgroundColor = RGBColor(10, 110, 210);
    [backView addSubview:self.line];
    
    CGFloat linwWidth = 0.5;
    CGFloat btnWidth = (SCREEN_WIDTH - 3)/4;
    NSArray *titles = @[@"最新",@"关注",@"好友",@"我的"];
    for (int i = 0; i<[titles count]; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((btnWidth + linwWidth)*i, 0, btnWidth, 43)];
        button.tag = i+1;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        if (i != 3) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btnWidth*(i+1), 14, linwWidth, 15)];
            line.backgroundColor = RGBColor(178, 178, 178);
            [backView addSubview:line];
        }
        
        if (i == 0) {
            button.selected = YES;
            self.button1 = button;
        } else if (i == 1) {
            self.button2 = button;
        } else if (i == 2) {
            self.button3 = button;
        } else if (i == 3) {
            self.button4 = button;
        }
    }
    
}

//按钮点击事件
- (void)btnClick:(UIButton *)sender
{
    //    self.chatInputView.textView.text = nil;
    //    self.chatInputView.hidden = YES;
    //    [self p_hideBottomComponent];
    [self keyBoardDismiss];
    //    self.chatInputView = nil;
    //    if (self.isNeedDelloc > 0) {
    //        [self needDealloc];
    //        self.isNeedDelloc --;
    //    }
    
    self.currentPage = sender.tag - 1;
    [UIView animateWithDuration:0.3 animations:^{
        if (self.currentPage == 3) {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , 40, (SCREEN_WIDTH - 2)/3 + 3, 3);
        } else {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*(sender.tag - 1) , 40, SCREEN_WIDTH/4, 3);
        }
    }];
    
    self.mainScrol.contentOffset = CGPointMake(SCREEN_WIDTH * (sender.tag - 1), 0);
//    [self.mainScrol setContentOffset:CGPointMake(SCREEN_WIDTH * (sender.tag - 1), 0) animated:YES];
    if (sender.tag == 1) {
        self.button1.selected = YES;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = NO;
        self.type = @"0";
//        [self createData1];
    } else if (sender.tag == 2) {
        self.button1.selected = NO;
        self.button2.selected = YES;
        self.button3.selected = NO;
        self.button4.selected = NO;
        self.type = @"1";
//        [self createData2];
    } else if (sender.tag == 3) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = YES;
        self.button4.selected = NO;
        self.type = @"2";
//        [self createData3];
        
    } else if (sender.tag == 4) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = YES;
        self.type = @"3";
//        [self createData4];
        
    }
    [self refresh];
}

#pragma mark - 收起键盘
- (void)keyBoardDismiss
{
//    self.chatInputView.textView.text = nil;
//    self.chatInputView.hidden = YES;
//    [self p_hideBottomComponent];
//    self.isEditeNow = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    
    if ([scrollView isEqual:self.mainScrol]) {
        NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
        //        NSLog(@"*****%d",index);
        [self btnClickWithIndex:index];
    }
    
}

- (void)btnClickWithIndex:(NSInteger)index
{
    self.currentPage = index;
    [UIView animateWithDuration:0.3 animations:^{
        if (self.currentPage == 3) {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , 40, (SCREEN_WIDTH - 2)/3 + 3, 3);
        } else {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*self.currentPage , 40, SCREEN_WIDTH/4, 3);
        }
    }];
    
    if (index == 0) {
        self.button1.selected = YES;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = NO;
        self.type = @"0";
//        [self createData1];
    } else if (index == 1) {
        self.button1.selected = NO;
        self.button2.selected = YES;
        self.button3.selected = NO;
        self.button4.selected = NO;
        self.type = @"1";
//        [self createData2];
        
    } else if (index == 2) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = YES;
        self.button4.selected = NO;
        self.type = @"2";
//        [self createData3];
        
    } else if (index == 3) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = YES;
        self.type = @"3";
//        [self createData4];
        
    }
    [self refresh];
}

- (void)refresh
{
    if ([self.game_types[self.currentPage] isEqualToString:self.game_type] && [self.datas[self.currentPage] count]!=0 ) {
        return;
    } else {
        [self.game_types replaceObjectAtIndex:self.currentPage withObject:self.game_type];
        [self.tableViews[self.currentPage] setContentOffset:CGPointMake(0, 0) animated:NO];
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
    }
//    if ([self.datas[self.currentPage] count] == 0) {
//    }
}

- (void)delay
{
    [[self.tableViews[self.currentPage] mj_header] beginRefreshing];

}

//**************************************处理代理事件**********************************************//
//searchBar开始编辑时改变取消按钮的文字
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    _searchBarTwo.showsCancelButton = YES;
//    
//    NSArray *subViews;
//    
//    if (iOS7) {
//        subViews = [(_searchBarTwo.subviews[0]) subviews];
//    }
//    else {
//        subViews = _searchBarTwo.subviews;
//    }
//    for (id view in subViews) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            UIButton* cancelbutton = (UIButton* )view;
//            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
//            break;
//        }
//    }
//}
//
//-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
//        [UIView animateWithDuration:0.25 animations:^{
//            for (UIView *subview in self.view.subviews)
//                subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height - 20);
//        }];
//    }
//}
//
//-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        [UIView animateWithDuration:0.25 animations:^{
//            for (UIView *subview in self.view.subviews)
//                subview.transform = CGAffineTransformIdentity;
//        }];
//    }
//}
//
//
//-(void)setsearchDisplayController
//{
//    _mySearchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBarTwo contentsController:self];
//    //_mySearchDisplayController.displaysSearchBarInNavigationBar = NO;
//    _mySearchDisplayController.delegate = self;
////    _mySearchDisplayController.searchResultsDataSource = self;
////    _mySearchDisplayController.searchResultsDelegate = self;
//    
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField*)textField
//{
//    [textField resignFirstResponder];
//    [self.view endEditing:YES];
//    //  [textField resignFirstResponder];
//    return YES;
//}

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
