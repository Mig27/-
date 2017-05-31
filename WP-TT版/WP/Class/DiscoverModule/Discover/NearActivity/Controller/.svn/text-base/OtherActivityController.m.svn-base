//
//  OtherActivityController.m
//  WP
//
//  Created by 沈亮亮 on 15/10/10.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "OtherActivityController.h"
#import "UISelectMenu.h"
#import "IndustryModel.h"

#import "WPHttpTool.h"
#import "WPShareModel.h"
#import "NearActivityModel.h"
#import "MJRefresh.h"
#import "NearActivityCell.h"
#import "WPDataView.h"
#import "WPSelectButton.h"
#import "ActivityCreateController.h"
#import "ActivityDetailController.h"
#import "NewNearActivityCell.h"

@interface OtherActivityController ()<UISelectMenuDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIScrollView *mainScrol;
@property (nonatomic,assign) CGFloat headerHeight;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;
@property (nonatomic,strong) UIButton *button4;
@property (nonatomic,strong) WPSelectButton *button5;
@property (nonatomic,strong) WPSelectButton *button6;
@property (nonatomic,strong) WPSelectButton *button7;
@property (nonatomic,strong) WPSelectButton *button8;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,assign) NSInteger currentPage;//当前是第几页
@property (nonatomic,strong) NSString *type;
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

@property (nonatomic,strong) UISelectMenu *menu1;
@property (nonatomic,strong) UISelectMenu *menu2;
@property (nonatomic,strong) UISelectMenu *menu3;
@property (nonatomic,strong) UISelectMenu *menu4;
@property (nonatomic,strong) UIView *backView1;
@property (nonatomic,strong) UIView *backView2;
@property (nonatomic,strong) UIView *backView3;
@property (nonatomic,strong) UIView *backView4;
@property (nonatomic,strong) WPDataView *dataView; //时间选择器
@property (nonatomic,strong) NSMutableArray *buttons;


@property (nonatomic,strong) NSString *areaId; //区域
@property (nonatomic,strong) NSString *time;   //时间
@property (nonatomic,strong) NSString *fees;   //费用


@end

@implementation OtherActivityController
{
    NSInteger _page1;
    NSInteger _page2;
    NSInteger _page3;
    NSInteger _page4;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (SCREEN_WIDTH == 320) {
        self.headerHeight = 32;
    } else {
        self.headerHeight = 38;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _buttons = [NSMutableArray array];
    self.currentPage = 0;
//    self.title = self.titleStr;
    [self initNav];
    [self createHeader];
    [self initDataSource];
    [self createBottom];
//    [self table1];
    [self.table1.mj_header beginRefreshing];
}

- (void)initNav
{
    self.navigationController.navigationBar.tintColor = RGBColor(0, 0, 0);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"  style:UIBarButtonItemStylePlain  target:self  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}


- (void)rightBtnClick
{
    [_dataView hide];
    ActivityCreateController *create = [[ActivityCreateController alloc] init];
    create.title = @"创建活动";
    [self.navigationController pushViewController:create animated:YES];
}

// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_dataView hide];
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
    self.areaId = @"0";
    self.time = @"0";
    self.fees = @"0";
    
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
        _table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - _headerHeight - 64 - BOTTOMHEIGHT) style:UITableViewStyleGrouped];
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
        _table2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - _headerHeight - 64 - BOTTOMHEIGHT) style:UITableViewStyleGrouped];
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
        _table3 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - _headerHeight - 64 - BOTTOMHEIGHT) style:UITableViewStyleGrouped];
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
        _table4 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, SCREEN_HEIGHT - _headerHeight - 64 - BOTTOMHEIGHT) style:UITableViewStyleGrouped];
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

#pragma mark - 封装网络请求
- (void)requestWithPageIndex:(NSInteger)page andIsNear:(BOOL)isNear Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/game.ashx"];
//    NSLog(@"*****%@",url);
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
    params[@"areaId"] = self.areaId;
    params[@"time"] = self.time;
    params[@"fees"] = self.fees;
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
    NewNearActivityCell *cell = [NewNearActivityCell cellWithTableView:tableView];
    NearActivityListModel *model = self.datas[self.currentPage][indexPath.row];
    //    cell.titleLabel.text = model.title;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(98);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sid = [self.datas[self.currentPage][indexPath.row] sid];
    ActivityDetailController *detail = [[ActivityDetailController alloc] init];
    detail.game_id = sid;
    [self.navigationController pushViewController:detail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 创建顶部的筛选栏
- (void)createHeader{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _headerHeight)];
    [self.view addSubview:headView];
    headView.layer.borderWidth = 0.5;
    headView.layer.borderColor = RGB(178, 178, 178).CGColor;

    CGFloat width = SCREEN_WIDTH/4;
    NSArray *titles = @[@"全部",@"区域",@"时间",@"费用"];
    for (int i=0; i<4; i++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(width*i, 0, width, _headerHeight);
//        [btn setTitle:titles[i] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn setTitleColor:RGB(10, 110, 210) forState:UIControlStateSelected];
//        btn.titleLabel.font = [UIFont systemFontOfSize:14];
//        btn.tag = 10 + i;
//        [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateSelected];
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(14, width - 16, 14, 7)];
////        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, width - 22)];
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(9, 0, 9, 0)];
        WPSelectButton *btn = [[WPSelectButton alloc] initWithFrame:CGRectMake(width*i, 0, width, _headerHeight)];
        btn.title.text = titles[i];
        btn.image.image = [UIImage imageNamed:@"arrow_down"];
        
//        [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [headView addSubview:btn];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width*i, 0, width, _headerHeight);
        button.tag = 10 + i;
        [button addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttons addObject:button];
        [headView addSubview:button];
        
        btn.isSelected = button.isSelected;
        if (i != 0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width*i, (_headerHeight - 15)/2, 0.5, 15)];
            line.backgroundColor = RGB(226, 226, 226);
            [headView addSubview:line];
        }
        
        if (i==0) {
           self.button5 = btn;
        } else if (i==1) {
           self.button6 = btn;
        } else if (i == 2) {
          self.button7 = btn;
        } else if (i == 3) {
          self.button8 = btn;
        }
    }
//    [self.button5 setTitle:self.titleStr forState:UIControlStateNormal];
    
    self.mainScrol = [[UIScrollView alloc] initWithFrame:CGRectMake(0, headView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - _headerHeight - 64 - BOTTOMHEIGHT)];
//    self.mainScrol.backgroundColor = [UIColor cyanColor];
    self.mainScrol.contentSize = CGSizeMake(SCREEN_WIDTH*4, SCREEN_HEIGHT - _headerHeight - 64 - BOTTOMHEIGHT);
    self.mainScrol.pagingEnabled = YES;
    self.mainScrol.delegate = self;
//    self.mainScrol.backgroundColor = RGBColor(235, 235, 235);
//    self.mainScrol.backgroundColor = [UIColor whiteColor];
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

#pragma mark - 创建4种选择列表
- (UISelectMenu *)menu1
{
    if (!_menu1) {
        _menu1 = [[UISelectMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - _headerHeight)];
        _menu1.delegate = self;
        _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _headerHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
//        _backView1.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self.view addSubview:_backView1];
        
        [_backView1 addSubview:_menu1];
        __weak typeof(self) unself = self;
        _menu1.touchHide = ^(){
//            unself.backView1.hidden = YES;
            [unself hidden];
        };
    }
    
    return _menu1;
}

- (UISelectMenu *)menu2
{
    if (!_menu2) {
        _menu2 = [[UISelectMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - _headerHeight - 72)];
        _menu2.delegate = self;
        _backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _headerHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _backView2.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self.view addSubview:_backView2];
        
        [_backView2 addSubview:_menu2];
//        _backView2.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
//        [_backView2 addGestureRecognizer:tap];
        UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, _menu2.bottom, SCREEN_WIDTH, 72)];
        [cancel addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
        [_backView2 addSubview:cancel];
        
    }
    
    return _menu2;
}

- (UISelectMenu *)menu3
{
    if (!_menu3) {
        _menu3 = [[UISelectMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - _headerHeight)];
        _menu3.delegate = self;
        _backView3 = [[UIView alloc] initWithFrame:CGRectMake(0, _headerHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
//        _backView3.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self.view addSubview:_backView3];
        
        [_backView3 addSubview:_menu3];
        __weak typeof(self) unself = self;
        _menu3.touchHide = ^(){
//            unself.backView3.hidden = YES;
            [unself hidden];
            [unself.dataView hide];
        };

    }
    
    return _menu3;
}

- (UISelectMenu *)menu4
{
    if (!_menu4) {
        _menu4 = [[UISelectMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - _headerHeight)];
        _menu4.delegate = self;
        _backView4 = [[UIView alloc] initWithFrame:CGRectMake(0, _headerHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
//        _backView4.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self.view addSubview:_backView4];
        
        [_backView4 addSubview:_menu4];
        __weak typeof(self) unself = self;
        _menu4.touchHide = ^(){
//            unself.backView4.hidden = YES;
            [unself hidden];
        };
    }
    
    return _menu4;
}

- (WPDataView *)dataView
{
    if (!_dataView) {
        _dataView = [[WPDataView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216 - 30, SCREEN_WIDTH, 216 + 30)];
        __weak typeof(self) weakSelf = self;
        _dataView.getDateBlock = ^(NSString *dateStr){
            NSArray *array = [dateStr componentsSeparatedByString:@"-"];
            NSMutableArray *dateArr = [[NSMutableArray alloc] initWithArray:array];
            [dateArr removeObjectAtIndex:0];
            NSString *date = [dateArr componentsJoinedByString:@"."];
            weakSelf.button7.title.text = date;
//            [weakSelf.button7 setTitle:date forState:UIControlStateNormal];
            weakSelf.time = dateStr;
            [weakSelf refreshIsNeedEmpty:YES];
            [weakSelf hidden];
        };


    }
    return _dataView;
}

- (void)hidden{
    self.backView1.hidden = YES;
    self.backView2.hidden = YES;
    self.backView3.hidden = YES;
    self.backView4.hidden = YES;
    self.button5.selected = NO;
    self.button6.selected = NO;
    self.button7.selected = NO;
    self.button8.selected = NO;
    for (UIButton *button in _buttons) {
        button.selected = NO;
    }
}

- (void)selectBtnClick:(UIButton *)sender
{
    [_dataView hide];
    NSMutableArray *typeArr = [NSMutableArray array];
    NSMutableArray *timeArr = [NSMutableArray array];
    NSMutableArray *feeArr = [NSMutableArray array];
    NSArray *type = @[@"全部",@"求职·招聘",@"学习·讲座",@"论坛·峰会",@"户外·活动",@"相亲·聚会"];
    NSArray *time = @[@"不限",@"今天",@"近一周",@"近一月",@"手动选择日期"];
    NSArray *fee = @[@"全部",@"免费",@"收费"];
    for (int i = 0; i<type.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = type[i];
        model.industryID = [NSString stringWithFormat:@"%d",i];
        [typeArr addObject:model];
    }
    
    for (int i = 0; i<time.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = time[i];
        model.industryID = [NSString stringWithFormat:@"%d",i];
        [timeArr addObject:model];
    }
    
    for (int i = 0; i<fee.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = fee[i];
        model.industryID = [NSString stringWithFormat:@"%d",i];
        [feeArr addObject:model];
    }
    
    self.backView1.hidden = YES;
    self.backView2.hidden = YES;
    self.backView3.hidden = YES;
    self.backView4.hidden = YES;
    //     [self hidden];
    //    [_menu4 remove];
    if (sender.tag == 10) {
        //        self.button5.selected = YES;
        //        self.backView1.hidden = YES;
        //        self.backView2.hidden = YES;
        //        self.backView3.hidden = YES;
        //        self.backView3.hidden = YES;
        
        if (!sender.isSelected) {
            [self.menu1 setLocalData:typeArr];
            self.button5.selected = YES;
            _backView1.hidden = NO;
        } else {
            _backView1.hidden = YES;
            self.button5.selected = NO;
        }
        self.button6.selected = NO;
        self.button7.selected = NO;
        self.button8.selected = NO;
    } else if (sender.tag == 11) {
        self.button5.selected = NO;
        //        self.button6.selected = YES;
        //        self.backView1.hidden = YES;
        ////        self.backView2.hidden = YES;
        //        self.backView3.hidden = YES;
        //        self.backView3.hidden = YES;
        
        if (!sender.isSelected) {
            [self.menu2 setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            self.button6.selected = YES;
            _backView2.hidden = NO;
        } else {
            _backView2.hidden = YES;
            self.button6.selected = NO;
        }
        self.button7.selected = NO;
        self.button8.selected = NO;
    } else if (sender.tag == 12) {
        self.button5.selected = NO;
        self.button6.selected = NO;
        //        self.button7.selected = YES;
        //        self.backView1.hidden = YES;
        //        self.backView2.hidden = YES;
        ////        self.backView3.hidden = YES;
        //        self.backView3.hidden = YES;
        
        if (!sender.isSelected) {
            [self.menu3 setLocalData:timeArr];
            self.button7.selected = YES;
            _backView3.hidden = NO;
        } else {
            _backView3.hidden = YES;
            self.button7.selected = NO;
        }
        
        self.button8.selected = NO;
    } else if (sender.tag == 13) {
        self.button5.selected = NO;
        self.button6.selected = NO;
        self.button7.selected = NO;
        //        self.button8.selected = YES;
        //        self.backView1.hidden = YES;
        //        self.backView2.hidden = YES;
        //        self.backView3.hidden = YES;
        //        self.backView3.hidden = YES;
        
        if (!sender.isSelected) {
            [self.menu4 setLocalData:feeArr];
            self.button8.selected = YES;
            _backView4.hidden = NO;
        } else {
            _backView4.hidden = YES;
            self.button8.selected = NO;
        }
    }
//    sender.selected = !sender.selected;
    for (int i = 0; i<_buttons.count; i++) {
        UIButton *btn = _buttons[i];
        if (i == sender.tag - 10) {
            btn.selected = !btn.selected;
        } else {
            btn.selected = NO;
        }
    }
}

//- (void)selectBtnClick:(WPSelectButton *)sender
//{
//    NSMutableArray *typeArr = [NSMutableArray array];
//    NSMutableArray *timeArr = [NSMutableArray array];
//    NSMutableArray *feeArr = [NSMutableArray array];
//    NSArray *type = @[@"全部",@"就职招聘",@"学习讲座",@"论坛峰会",@"户外活动",@"相亲聚会"];
//    NSArray *time = @[@"不限",@"今天",@"近一周",@"近一月",@"手动选择日期"];
//    NSArray *fee = @[@"全部",@"免费",@"收费"];
//    for (int i = 0; i<type.count; i++) {
//        IndustryModel *model = [[IndustryModel alloc]init];
//        model.industryName = type[i];
//        model.industryID = [NSString stringWithFormat:@"%d",i];
//        [typeArr addObject:model];
//    }
//    
//    for (int i = 0; i<time.count; i++) {
//        IndustryModel *model = [[IndustryModel alloc]init];
//        model.industryName = time[i];
//        model.industryID = [NSString stringWithFormat:@"%d",i];
//        [timeArr addObject:model];
//    }
//    
//    for (int i = 0; i<fee.count; i++) {
//        IndustryModel *model = [[IndustryModel alloc]init];
//        model.industryName = fee[i];
//        model.industryID = [NSString stringWithFormat:@"%d",i];
//        [feeArr addObject:model];
//    }
//
//    self.backView1.hidden = YES;
//    self.backView2.hidden = YES;
//    self.backView3.hidden = YES;
//    self.backView4.hidden = YES;
////     [self hidden];
////    [_menu4 remove];
//    if (sender.tag == 10) {
////        self.button5.selected = YES;
////        self.backView1.hidden = YES;
////        self.backView2.hidden = YES;
////        self.backView3.hidden = YES;
////        self.backView3.hidden = YES;
//
//        if (!self.button5.isSelected) {
//            [self.menu1 setLocalData:typeArr];
//            _backView1.hidden = NO;
//        } else {
//            _backView1.hidden = YES;
//        }
//        self.button6.selected = NO;
//        self.button7.selected = NO;
//        self.button8.selected = NO;
//    } else if (sender.tag == 11) {
//        self.button5.selected = NO;
////        self.button6.selected = YES;
////        self.backView1.hidden = YES;
//////        self.backView2.hidden = YES;
////        self.backView3.hidden = YES;
////        self.backView3.hidden = YES;
//
//        if (!self.button6.isSelected) {
//            [self.menu2 setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
//            _backView2.hidden = NO;
//        } else {
//            _backView2.hidden = YES;
//        }
//        self.button7.selected = NO;
//        self.button8.selected = NO;
//    } else if (sender.tag == 12) {
//        self.button5.selected = NO;
//        self.button6.selected = NO;
////        self.button7.selected = YES;
////        self.backView1.hidden = YES;
////        self.backView2.hidden = YES;
//////        self.backView3.hidden = YES;
////        self.backView3.hidden = YES;
//
//        if (!self.button7.isSelected) {
//            [self.menu3 setLocalData:timeArr];
//            _backView3.hidden = NO;
//        } else {
//            _backView3.hidden = YES;
//        }
//
//        self.button8.selected = NO;
//    } else if (sender.tag == 13) {
//        self.button5.selected = NO;
//        self.button6.selected = NO;
//        self.button7.selected = NO;
////        self.button8.selected = YES;
////        self.backView1.hidden = YES;
////        self.backView2.hidden = YES;
////        self.backView3.hidden = YES;
////        self.backView3.hidden = YES;
//
//        if (!self.button8.isSelected) {
//            [self.menu4 setLocalData:feeArr];
//            _backView4.hidden = NO;
//        } else {
//            _backView4.hidden = YES;
//        }
//    }
//    sender.selected = !sender.selected;
//}

#pragma mark - UISelectDelegate
- (void)UISelectDelegate:(IndustryModel *)model selectMenu:(UISelectMenu *)menu
{
    if ([menu isEqual:_menu1]) { //活动类型
//        self.title = model.industryName;
        self.game_type = model.industryID;
        self.button5.title.text = model.industryName;
//        [self.button5 setTitle:model.industryName forState:UIControlStateNormal];
        [self refreshIsNeedEmpty:YES];
        [self hidden];
    } else if ([menu isEqual:_menu2]) { //区域
        self.button6.title.text = model.industryName;
//        [self.button6 setTitle:model.industryName forState:UIControlStateNormal];
        self.areaId = model.industryID;
        [self refreshIsNeedEmpty:YES];
        [self hidden];
    } else if ([menu isEqual:_menu3]) { //时间
        if (![model.industryName isEqualToString:@"不限"]) {
            if ([model.industryID isEqualToString:@"4"]) { //自己选时间
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [self dataView];
                _dataView.isNeedSecond = NO;
                [_dataView showInView:window];
            } else {
                self.button7.title.text = model.industryName;
//                [self.button7 setTitle:model.industryName forState:UIControlStateNormal];
                self.time = model.industryID;
                [self refreshIsNeedEmpty:YES];
                [_dataView hide];
                [self hidden];
            }
        } else {
            self.button7.title.text = @"时间";
//            [self.button7 setTitle:@"时间" forState:UIControlStateNormal];
            self.time = model.industryID;
            [self refreshIsNeedEmpty:YES];
            [self hidden];
        }
    } else if ([menu isEqual:_menu4]) { //费用
        [self hidden];
        self.fees = model.industryID;
        [self refreshIsNeedEmpty:YES];
        if (![model.industryName isEqualToString:@"全部"]) {
            self.button8.title.text = model.industryName;
//            [self.button8 setTitle:model.industryName forState:UIControlStateNormal];
        } else {
            self.button8.title.text = @"费用";
//            [self.button8 setTitle:@"费用" forState:UIControlStateNormal];
        }
    }
}


#pragma mark - 底部按钮的创建
- (void)createBottom
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.mainScrol.bottom, SCREEN_WIDTH, BOTTOMHEIGHT + 0.5)];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - BOTTOMHEIGHT - 0.5, SCREEN_WIDTH, 0.5)];
    view.backgroundColor = RGBColor(178, 178, 178);
    [self.view addSubview:view];
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, BOTTOMHEIGHT - 3, SCREEN_WIDTH/4, 3)];
    self.line.backgroundColor = RGBColor(10, 110, 210);
    [backView addSubview:self.line];
    
    CGFloat linwWidth = 0.5;
    CGFloat btnWidth = (SCREEN_WIDTH - 3)/4;
    NSArray *titles = @[@"最新",@"关注",@"好友",@"我的"];
    for (int i = 0; i<[titles count]; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((btnWidth + linwWidth)*i, 0, btnWidth, BOTTOMHEIGHT)];
        button.tag = i+1;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = kFONT(15);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        if (i != 3) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btnWidth*(i+1), (BOTTOMHEIGHT - 15)/2, linwWidth, 15)];
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
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , BOTTOMHEIGHT - 3, (SCREEN_WIDTH - 2)/3 + 3, 3);
        } else {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*(sender.tag - 1) , BOTTOMHEIGHT - 3, SCREEN_WIDTH/4, 3);
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
    [self refreshIsNeedEmpty:NO];
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
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , BOTTOMHEIGHT - 3, (SCREEN_WIDTH - 2)/3 + 3, 3);
        } else {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*self.currentPage , BOTTOMHEIGHT - 3, SCREEN_WIDTH/4, 3);
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
    [self refreshIsNeedEmpty:NO];
}

- (void)refreshIsNeedEmpty:(BOOL)isEmpty{
    if (isEmpty) {
        [self.tableViews[self.currentPage] setContentOffset:CGPointMake(0, 0) animated:NO];
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
    } else {
        if ([self.datas[self.currentPage] count] == 0) {
            [[self.tableViews[self.currentPage] mj_header] beginRefreshing];
        }
    }
}

- (void)delay
{
    for (NSMutableArray *data in self.datas) {
        [data removeAllObjects];
    }
    [[self.tableViews[self.currentPage] mj_header] beginRefreshing];
    
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
