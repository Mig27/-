//
//  NewDemandViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/9/23.
//  Copyright (c) 2015年 WP. All rights reserved.
//  奇葩需求

#import "NewDemandViewController.h"
#import "BYListBar.h"
#import "BYArrow.h"
#import "BYDetailsList.h"
#import "BYDeleteBar.h"
#import "BYScroller.h"
#import "WPShareModel.h"
#import "WFPopView.h"
#import "DemandModel.h"
#import "DemandCell.h"

#import "MBProgressHUD+MJ.h"
#import "TouchDownGestureRecognizer.h"
#import "EmotionsModule.h"
#import "RecordingView.h"

#import "RecruitmentViewController.h"
#import "DemandDetailViewController.h"
#import "DemandPersonalController.h"
#import "IQKeyboardManager.h"

typedef NS_ENUM(NSUInteger, DDBottomShowComponent)
{
    DDInputViewUp                       = 1,
    DDShowKeyboard                      = 1 << 1,
    DDShowEmotion                       = 1 << 2,
    DDShowUtility                       = 1 << 3
};

typedef NS_ENUM(NSUInteger, DDBottomHiddComponent)
{
    DDInputViewDown                     = 14,
    DDHideKeyboard                      = 13,
    DDHideEmotion                       = 11,
    DDHideUtility                       = 7
};
//

typedef NS_ENUM(NSUInteger, DDInputType)
{
    DDVoiceInput,
    DDTextInput
};

typedef NS_ENUM(NSUInteger, PanelStatus)
{
    VoiceStatus,
    TextInputStatus,
    EmotionStatus,
    ImageStatus
};
#define NAVBAR_HEIGHT 64.f
#define DDCOMPONENT_BOTTOM          CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT), SCREEN_WIDTH, 216)
#define DDINPUT_BOTTOM_FRAME        CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) - self.chatInputView.frame.size.height,SCREEN_WIDTH,self.chatInputView.frame.size.height)
#define DDINPUT_HEIGHT              self.chatInputView.frame.size.height
#define DDINPUT_TOP_FRAME           CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) - self.chatInputView.frame.size.height - 216, SCREEN_WIDTH, self.chatInputView.frame.size.height)
#define DDUTILITY_FRAME             CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT)  -216, SCREEN_WIDTH, 216)
#define DDEMOTION_FRAME             CGRectMake(0, (SCREEN_HEIGHT - NAVBAR_HEIGHT) -216, SCREEN_WIDTH, 216)

@interface NewDemandViewController ()<UIScrollViewDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BYListBar *listBar;
@property (nonatomic,strong) BYDeleteBar *deleteBar;
@property (nonatomic,strong) BYDetailsList *detailsList;
@property (nonatomic,strong) BYArrow *arrow;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *items;         //原本的顺序
@property (nonatomic,strong) NSMutableArray *lastestItems;  //最新的循序
@property (nonatomic,strong) NSString *selectItem;
@property (nonatomic,assign) BOOL isWhite;
@property (nonatomic,assign) BOOL isLoad;   //是否请求数据
@property (nonatomic,assign) BOOL isChange; //是否改变
@property (nonatomic,assign) NSInteger currentPage; //当前第几页
@property (nonatomic,assign) NSInteger lastPage;    //滚动前上一次的页码
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;
@property (nonatomic,strong) UIButton *button4;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,assign) BOOL isBottomClick;   //底部的除最新外的其他按钮是否被点击
@property (nonatomic,assign) BOOL isHaveData;      //是否有数据

@property (nonatomic,strong) UITableView *table1;
@property (nonatomic,strong) UITableView *table2;
@property (nonatomic,strong) UITableView *table3;
@property (nonatomic,strong) UITableView *table4;
@property (nonatomic,strong) UITableView *table5;
@property (nonatomic,strong) UITableView *table6;
@property (nonatomic,strong) UITableView *table7;
@property (nonatomic,strong) UITableView *table8;
@property (nonatomic,strong) UITableView *table9;
@property (nonatomic,strong) UITableView *table10;
@property (nonatomic,strong) NSMutableArray *tableViews; //用来存放所有的tableView;

@property (nonatomic,strong) NSMutableArray *data1;
@property (nonatomic,strong) NSMutableArray *data2;
@property (nonatomic,strong) NSMutableArray *data3;
@property (nonatomic,strong) NSMutableArray *data4;
@property (nonatomic,strong) NSMutableArray *data5;
@property (nonatomic,strong) NSMutableArray *data6;
@property (nonatomic,strong) NSMutableArray *data7;
@property (nonatomic,strong) NSMutableArray *data8;
@property (nonatomic,strong) NSMutableArray *data9;
@property (nonatomic,strong) NSMutableArray *data10;
@property (nonatomic,strong) NSMutableArray *dataSources;  //用来存放所有的数据源

@property (nonatomic,strong) NSMutableArray *goodData1;
@property (nonatomic,strong) NSMutableArray *goodData2;
@property (nonatomic,strong) NSMutableArray *goodData3;
@property (nonatomic,strong) NSMutableArray *goodData4;
@property (nonatomic,strong) NSMutableArray *goodData5;
@property (nonatomic,strong) NSMutableArray *goodData6;
@property (nonatomic,strong) NSMutableArray *goodData7;
@property (nonatomic,strong) NSMutableArray *goodData8;
@property (nonatomic,strong) NSMutableArray *goodData9;
@property (nonatomic,strong) NSMutableArray *goodData10;
@property (nonatomic,strong) NSMutableArray *goodDatas;   //用来存放所以的是否已赞

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *iconClickIndexPath; //头像点击的行数

@property (nonatomic,strong) NSString *speak_type;   //说说的类型
@property (nonatomic,strong) NSString *state;        //说说的状态
@property (nonatomic,strong) NSMutableArray *states; //标记所有页面的状态
@property (nonatomic,assign) BOOL isMore;            //是否有显示更多
@property (nonatomic,assign) BOOL isEditeNow;        //当前是否处于正在编辑状态
@property (nonatomic,strong) NSMutableDictionary *deletParams;   //所要删除说说的参数
@property (nonatomic,assign) NSInteger deletIndex;               //所要删除说说的位置

- (void)p_clickThRecordButton:(UIButton*)button;
- (void)p_record:(UIButton*)button;
- (void)p_willCancelRecord:(UIButton*)button;
- (void)p_cancelRecord:(UIButton*)button;
- (void)p_sendRecord:(UIButton*)button;
- (void)p_endCancelRecord:(UIButton*)button;

- (void)p_hideBottomComponent;
- (void)p_tapOnTableView:(UIGestureRecognizer*)sender;

@end

@implementation NewDemandViewController
{
    TouchDownGestureRecognizer* _touchDownGestureRecognizer;
    DDBottomShowComponent _bottomShowComponent;
    UIButton *_recordButton;
    float _inputViewY;
    NSString* _currentInputContent;

    NSInteger _page1;
    NSInteger _page2;
    NSInteger _page3;
    NSInteger _page4;
    NSInteger _page5;
    NSInteger _page6;
    NSInteger _page7;
    NSInteger _page8;
    NSInteger _page9;
    NSInteger _page10;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNav];
    [self createUI];
    [self initDatasources];
    self.currentPage = 0;
    self.lastPage = 0;
    self.isBottomClick = NO;
    self.selectItem = @"全部";
    self.speak_type = @"0";
    self.state = @"1";
    self.isWhite = NO;
    self.isChange = NO;
    self.isLoad = NO;
    self.isMore = NO;
    self.isEditeNow = NO;
    [self createBottom];
    [self makeContent];
    [self createData1];
    [self notificationCenter];
    [self initialInput];
    [self createNotification];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[NewDemandViewController class]];
}

- (void)initNav
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"  style:UIBarButtonItemStylePlain  target:self  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

- (void)createNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"fefresh" object:nil];
}

- (void)refresh:(NSNotification *)notification
{
    NSString *topic = notification.userInfo[@"title"];
//    NSLog(@"#####%@----%@",topic,notification.userInfo);
    [self updateBottomBtn];
    for (int i = 0; i < self.lastestItems.count; i++) {
        NSString *item = self.lastestItems[i];
//        NSLog(@"11111%@",item);
        if ([item isEqualToString:topic]) {
            NSMutableArray *data = self.dataSources[i];
            if (data.count >0) {
                [self.dataSources[i] removeAllObjects];
                self.isHaveData = YES;
                [self reloadDataWith:i style:topic];
            }
            self.currentPage = i;
            self.selectItem = topic;
            [self.listBar itemClick:self.listBar.btnLists[[self.listBar findIndexOfListsWithTitle:topic]]];
            //                [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*i, 0) animated:YES];
            //                [self reloadDataWith:i style:topic];
        }
    }
    
}

- (void)rightBtnClick
{
    RecruitmentViewController *recruite = [[RecruitmentViewController alloc] init];
    [self.navigationController pushViewController:recruite animated:YES];
}

- (void)initDatasources
{
    _page1 = 1;
    _page2 = 1;
    _page3 = 1;
    _page4 = 1;
    _page5 = 1;
    _page6 = 1;
    _page7 = 1;
    _page8 = 1;
    _page9 = 1;
    _page10 = 1;
//    _page11 = 1;
    self.data1 = [NSMutableArray array];
    self.data2 = [NSMutableArray array];
    self.data3 = [NSMutableArray array];
    self.data4 = [NSMutableArray array];
    self.data5 = [NSMutableArray array];
    self.data6 = [NSMutableArray array];
    self.data7 = [NSMutableArray array];
    self.data8 = [NSMutableArray array];
    self.data9 = [NSMutableArray array];
    self.data10 = [NSMutableArray array];
//    self.data11 = [NSMutableArray array];
    _goodData1 = [NSMutableArray array];
    _goodData2 = [NSMutableArray array];
    _goodData3 = [NSMutableArray array];
    _goodData4 = [NSMutableArray array];
    _goodData5 = [NSMutableArray array];
    _goodData6 = [NSMutableArray array];
    _goodData7 = [NSMutableArray array];
    _goodData8 = [NSMutableArray array];
    _goodData9 = [NSMutableArray array];
    _goodData10 = [NSMutableArray array];
//    _goodData11 = [NSMutableArray array];
    
    self.dataSources = [[NSMutableArray alloc] initWithObjects:self.data1,self.data2,self.data3,self.data4,self.data5,self.data6,self.data7,self.data8,self.data9,self.data10,nil];
    self.tableViews = [[NSMutableArray alloc] initWithObjects:self.table1,self.table2,self.table3,self.table4,self.table5,self.table6,self.table7,self.table8,self.table9,self.table10,nil];
    self.goodDatas = [NSMutableArray arrayWithObjects:_goodData1,_goodData2,_goodData3,_goodData4,_goodData5,_goodData6,_goodData7,_goodData8,_goodData9,_goodData10,nil];
    self.states = [[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",nil];
}

#pragma mark - 懒加载创建所有的列表
- (UITableView *)table1{
    if (_table1 == nil) {
        self.table1 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107 - kListBarH) style:UITableViewStyleGrouped];
        self.table1.delegate = self;
        self.table1.dataSource = self;
        self.table1.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.table1.backgroundColor = RGB(235, 235, 235);
        __weak __typeof(self) weakSelf = self;
        _table1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page1 = 1;
            [weakSelf createData1];
        }];
        
        _table1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page1++;
            [weakSelf createData1];
        }];
        [self.scrollView addSubview:self.table1];
    }
    
    return _table1;
}

- (UITableView *)table2{
    if (_table2 == nil) {
        self.table2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*1, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107 - kListBarH) style:UITableViewStyleGrouped];
        self.table2.delegate = self;
        self.table2.dataSource = self;
        self.table2.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.table2.backgroundColor = RGB(235, 235, 235);
        __weak __typeof(self) weakSelf = self;
        _table2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page2 = 1;
            [weakSelf createData2];
        }];
        
        _table2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page2++;
            [weakSelf createData2];
        }];
        [self.scrollView addSubview:self.table2];
    }
    return _table2;
}

- (UITableView *)table3{
    if (_table3 == nil) {
        self.table3 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107 - kListBarH) style:UITableViewStyleGrouped];
        self.table3.delegate = self;
        self.table3.dataSource = self;
        self.table3.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.table3.backgroundColor = RGB(235, 235, 235);
        __weak __typeof(self) weakSelf = self;
        _table3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page3 = 1;
            [weakSelf createData3];
        }];
        
        _table3.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page3++;
            [weakSelf createData3];
        }];
        
        [self.scrollView addSubview:self.table3];
    }
    return _table3;
}

- (UITableView *)table4{
    if (_table4 == nil) {
        self.table4 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107 - kListBarH) style:UITableViewStyleGrouped];
        self.table4.delegate = self;
        self.table4.dataSource = self;
        self.table4.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.table4.backgroundColor = RGB(235, 235, 235);
        __weak __typeof(self) weakSelf = self;
        _table4.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page4 = 1;
            [weakSelf createData4];
        }];
        
        _table4.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page4++;
            [weakSelf createData4];
        }];
        
        [self.scrollView addSubview:self.table4];
    }
    return _table4;
}

- (UITableView *)table5{
    if (_table5 == nil) {
        self.table5 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*4, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107 - kListBarH) style:UITableViewStyleGrouped];
        self.table5.delegate = self;
        self.table5.dataSource = self;
        self.table5.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.table5.backgroundColor = RGB(235, 235, 235);
        //        self.table5.backgroundColor = [UIColor whiteColor];
        __weak __typeof(self) weakSelf = self;
        _table5.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page5 = 1;
            [weakSelf createData5];
        }];
        
        _table5.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page5++;
            [weakSelf createData5];
        }];
        
        [self.scrollView addSubview:self.table5];
    }
    return _table5;
}

- (UITableView *)table6{
    if (_table6 == nil) {
        self.table6 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*5, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107 - kListBarH) style:UITableViewStyleGrouped];
        self.table6.delegate = self;
        self.table6.dataSource = self;
        self.table6.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.table6.backgroundColor = RGB(235, 235, 235);
        __weak __typeof(self) weakSelf = self;
        _table6.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page6 = 1;
            [weakSelf createData6];
        }];
        
        _table6.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page6++;
            [weakSelf createData6];
        }];
        [self.scrollView addSubview:self.table6];
    }
    return _table6;
}

- (UITableView *)table7{
    if (_table7 == nil) {
        self.table7 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*6, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107 - kListBarH) style:UITableViewStyleGrouped];
        self.table7.delegate = self;
        self.table7.dataSource = self;
        self.table7.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.table7.backgroundColor = RGB(235, 235, 235);
        __weak __typeof(self) weakSelf = self;
        _table7.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page7 = 1;
            [weakSelf createData7];
        }];
        
        _table7.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page7++;
            [weakSelf createData7];
        }];
        [self.scrollView addSubview:self.table7];
    }
    return _table7;
}

- (UITableView *)table8{
    if (_table8 == nil) {
        self.table8 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*7, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107 - kListBarH) style:UITableViewStyleGrouped];
        self.table8.delegate = self;
        self.table8.dataSource = self;
        self.table8.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.table8.backgroundColor = RGB(235, 235, 235);
        __weak __typeof(self) weakSelf = self;
        _table8.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page8 = 1;
            [weakSelf createData8];
        }];
        
        _table8.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page8++;
            [weakSelf createData8];
        }];
        [self.scrollView addSubview:self.table8];
    }
    return _table8;
}

- (UITableView *)table9{
    if (_table9 == nil) {
        self.table9 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*8, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107 - kListBarH) style:UITableViewStyleGrouped];
        self.table9.delegate = self;
        self.table9.dataSource = self;
        self.table9.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.table9.backgroundColor = RGB(235, 235, 235);
        __weak __typeof(self) weakSelf = self;
        _table9.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page9 = 1;
            [weakSelf createData9];
        }];
        
        _table9.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page9++;
            [weakSelf createData9];
        }];
        
        [self.scrollView addSubview:self.table9];
    }
    return _table9;
}

- (UITableView *)table10{
    if (_table10 == nil) {
        self.table10 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*9, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107 - kListBarH) style:UITableViewStyleGrouped];
        self.table10.delegate = self;
        self.table10.dataSource = self;
        self.table10.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.table10.backgroundColor = RGB(235, 235, 235);
        __weak __typeof(self) weakSelf = self;
        _table10.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page10 = 1;
            [weakSelf createData10];
        }];
        
        _table10.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page10++;
            [weakSelf createData10];
        }];
        [self.scrollView addSubview:self.table10];
    }
    return _table10;
}

- (void)createData1
{
    NSLog(@"界面1");
    if (_page1 == 1) {
        [_data1 removeAllObjects];
        [_goodData1 removeAllObjects];
        //        [_commentData1 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page1];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"Wonderful";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"longitude"] = [user objectForKey:@"longitude"];
    //    params[@"latitude"] = [user objectForKey:@"latitude"];
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    
    params[@"area_id"] = @"0";
    params[@"domand_type"] = self.speak_type;
    params[@"style"] = self.state;
    
    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
    //                          @"page" : page};
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table1.hidden = NO;
        //        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data1 addObjectsFromArray:arr];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"isEntry"]];
            [_goodData1 addObject:is_good];
            //            NSString *comment = dic[@"speak_comment_content"];
            //            [_commentData1 addObject:comment];
        }
        //        [_dataSources replaceObjectAtIndex:0 withObject:_dataSource1];
//        [self table1];
        //        _reqErrorView1.hidden = YES;
        //        //        [_reqErrorView1 removeFromSuperview];
        //        if (_data1.count == 0) {
        //            _noDataView1.hidden = NO;
        //            _headImageView1.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView1.hidden = YES;
        //            _headImageView1.userInteractionEnabled = YES;
        //        }
        [_table1.mj_header endRefreshing];
        [_table1.mj_footer endRefreshing];
        [self.table1 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table1.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView1.hidden = NO;
        [_table1.mj_header endRefreshing];
        [_table1.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData2
{
    NSLog(@"界面2");
    if (_page2 == 1) {
        [_data2 removeAllObjects];
        [_goodData2 removeAllObjects];
        //        [_commentData1 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page2];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"Wonderful";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"longitude"] = [user objectForKey:@"longitude"];
    //    params[@"latitude"] = [user objectForKey:@"latitude"];
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    
    params[@"area_id"] = @"0";
    params[@"domand_type"] = self.speak_type;
    params[@"style"] = self.state;
    
    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
    //                          @"page" : page};
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table2.hidden = NO;
                NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data2 addObjectsFromArray:arr];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"isEntry"]];
            [_goodData2 addObject:is_good];
            //            NSString *comment = dic[@"speak_comment_content"];
            //            [_commentData1 addObject:comment];
        }
        //        [_dataSources replaceObjectAtIndex:0 withObject:_dataSource1];
        //        [self table1];
        //        _reqErrorView1.hidden = YES;
        //        //        [_reqErrorView1 removeFromSuperview];
        //        if (_data1.count == 0) {
        //            _noDataView1.hidden = NO;
        //            _headImageView1.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView1.hidden = YES;
        //            _headImageView1.userInteractionEnabled = YES;
        //        }
        [_table2.mj_header endRefreshing];
        [_table2.mj_footer endRefreshing];
        [self.table2 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table2.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView1.hidden = NO;
        [_table2.mj_header endRefreshing];
        [_table2.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData3
{
    NSLog(@"界面1");
    if (_page3 == 1) {
        [_data3 removeAllObjects];
        [_goodData3 removeAllObjects];
        //        [_commentData1 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page3];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"Wonderful";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"longitude"] = [user objectForKey:@"longitude"];
    //    params[@"latitude"] = [user objectForKey:@"latitude"];
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    
    params[@"area_id"] = @"0";
    params[@"domand_type"] = self.speak_type;
    params[@"style"] = self.state;
    
    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
    //                          @"page" : page};
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table3.hidden = NO;
        //        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data3 addObjectsFromArray:arr];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"isEntry"]];
            [_goodData3 addObject:is_good];
            //            NSString *comment = dic[@"speak_comment_content"];
            //            [_commentData1 addObject:comment];
        }
        //        [_dataSources replaceObjectAtIndex:0 withObject:_dataSource1];
        //        [self table1];
        //        _reqErrorView1.hidden = YES;
        //        //        [_reqErrorView1 removeFromSuperview];
        //        if (_data1.count == 0) {
        //            _noDataView1.hidden = NO;
        //            _headImageView1.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView1.hidden = YES;
        //            _headImageView1.userInteractionEnabled = YES;
        //        }
        [_table3.mj_header endRefreshing];
        [_table3.mj_footer endRefreshing];
        [self.table3 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table3.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView1.hidden = NO;
        [_table3.mj_header endRefreshing];
        [_table3.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData4
{
    NSLog(@"界面1");
    if (_page4 == 1) {
        [_data4 removeAllObjects];
        [_goodData4 removeAllObjects];
        //        [_commentData1 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page4];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"Wonderful";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"longitude"] = [user objectForKey:@"longitude"];
    //    params[@"latitude"] = [user objectForKey:@"latitude"];
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    
    params[@"area_id"] = @"0";
    params[@"domand_type"] = self.speak_type;
    params[@"style"] = self.state;
    
    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
    //                          @"page" : page};
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table4.hidden = NO;
        //        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data4 addObjectsFromArray:arr];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"isEntry"]];
            [_goodData4 addObject:is_good];
            //            NSString *comment = dic[@"speak_comment_content"];
            //            [_commentData1 addObject:comment];
        }
        //        [_dataSources replaceObjectAtIndex:0 withObject:_dataSource1];
        //        [self table1];
        //        _reqErrorView1.hidden = YES;
        //        //        [_reqErrorView1 removeFromSuperview];
        //        if (_data1.count == 0) {
        //            _noDataView1.hidden = NO;
        //            _headImageView1.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView1.hidden = YES;
        //            _headImageView1.userInteractionEnabled = YES;
        //        }
        [_table4.mj_header endRefreshing];
        [_table4.mj_footer endRefreshing];
        [self.table4 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table4.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView1.hidden = NO;
        [_table4.mj_header endRefreshing];
        [_table4.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData5
{
    NSLog(@"界面1");
    if (_page5 == 1) {
        [_data5 removeAllObjects];
        [_goodData5 removeAllObjects];
        //        [_commentData1 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page5];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"Wonderful";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"longitude"] = [user objectForKey:@"longitude"];
    //    params[@"latitude"] = [user objectForKey:@"latitude"];
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    
    params[@"area_id"] = @"0";
    params[@"domand_type"] = self.speak_type;
    params[@"style"] = self.state;
    
    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
    //                          @"page" : page};
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table5.hidden = NO;
        //        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data5 addObjectsFromArray:arr];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"isEntry"]];
            [_goodData5 addObject:is_good];
            //            NSString *comment = dic[@"speak_comment_content"];
            //            [_commentData1 addObject:comment];
        }
        //        [_dataSources replaceObjectAtIndex:0 withObject:_dataSource1];
        //        [self table1];
        //        _reqErrorView1.hidden = YES;
        //        //        [_reqErrorView1 removeFromSuperview];
        //        if (_data1.count == 0) {
        //            _noDataView1.hidden = NO;
        //            _headImageView1.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView1.hidden = YES;
        //            _headImageView1.userInteractionEnabled = YES;
        //        }
        [_table5.mj_header endRefreshing];
        [_table5.mj_footer endRefreshing];
        [self.table5 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table5.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView1.hidden = NO;
        [_table5.mj_header endRefreshing];
        [_table5.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData6
{
    NSLog(@"界面1");
    if (_page6 == 1) {
        [_data6 removeAllObjects];
        [_goodData6 removeAllObjects];
        //        [_commentData1 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page6];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"Wonderful";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"longitude"] = [user objectForKey:@"longitude"];
    //    params[@"latitude"] = [user objectForKey:@"latitude"];
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    
    params[@"area_id"] = @"0";
    params[@"domand_type"] = self.speak_type;
    params[@"style"] = self.state;
    
    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
    //                          @"page" : page};
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table6.hidden = NO;
        //        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data6 addObjectsFromArray:arr];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"isEntry"]];
            [_goodData6 addObject:is_good];
            //            NSString *comment = dic[@"speak_comment_content"];
            //            [_commentData1 addObject:comment];
        }
        //        [_dataSources replaceObjectAtIndex:0 withObject:_dataSource1];
        //        [self table1];
        //        _reqErrorView1.hidden = YES;
        //        //        [_reqErrorView1 removeFromSuperview];
        //        if (_data1.count == 0) {
        //            _noDataView1.hidden = NO;
        //            _headImageView1.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView1.hidden = YES;
        //            _headImageView1.userInteractionEnabled = YES;
        //        }
        [_table6.mj_header endRefreshing];
        [_table6.mj_footer endRefreshing];
        [self.table6 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table6.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView1.hidden = NO;
        [_table6.mj_header endRefreshing];
        [_table6.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData7
{
    NSLog(@"界面1");
    if (_page7 == 1) {
        [_data7 removeAllObjects];
        [_goodData7 removeAllObjects];
        //        [_commentData1 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page7];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"Wonderful";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"longitude"] = [user objectForKey:@"longitude"];
    //    params[@"latitude"] = [user objectForKey:@"latitude"];
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    
    params[@"area_id"] = @"0";
    params[@"domand_type"] = self.speak_type;
    params[@"style"] = self.state;
    
    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
    //                          @"page" : page};
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table7.hidden = NO;
        //        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data7 addObjectsFromArray:arr];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"isEntry"]];
            [_goodData7 addObject:is_good];
            //            NSString *comment = dic[@"speak_comment_content"];
            //            [_commentData1 addObject:comment];
        }
        //        [_dataSources replaceObjectAtIndex:0 withObject:_dataSource1];
        //        [self table1];
        //        _reqErrorView1.hidden = YES;
        //        //        [_reqErrorView1 removeFromSuperview];
        //        if (_data1.count == 0) {
        //            _noDataView1.hidden = NO;
        //            _headImageView1.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView1.hidden = YES;
        //            _headImageView1.userInteractionEnabled = YES;
        //        }
        [_table7.mj_header endRefreshing];
        [_table7.mj_footer endRefreshing];
        [self.table7 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table7.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView1.hidden = NO;
        [_table7.mj_header endRefreshing];
        [_table7.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData8
{
    NSLog(@"界面1");
    if (_page8 == 1) {
        [_data8 removeAllObjects];
        [_goodData8 removeAllObjects];
        //        [_commentData1 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page8];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"Wonderful";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"longitude"] = [user objectForKey:@"longitude"];
    //    params[@"latitude"] = [user objectForKey:@"latitude"];
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    
    params[@"area_id"] = @"0";
    params[@"domand_type"] = self.speak_type;
    params[@"style"] = self.state;
    
    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
    //                          @"page" : page};
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table8.hidden = NO;
        //        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data8 addObjectsFromArray:arr];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"isEntry"]];
            [_goodData8 addObject:is_good];
            //            NSString *comment = dic[@"speak_comment_content"];
            //            [_commentData1 addObject:comment];
        }
        //        [_dataSources replaceObjectAtIndex:0 withObject:_dataSource1];
        //        [self table1];
        //        _reqErrorView1.hidden = YES;
        //        //        [_reqErrorView1 removeFromSuperview];
        //        if (_data1.count == 0) {
        //            _noDataView1.hidden = NO;
        //            _headImageView1.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView1.hidden = YES;
        //            _headImageView1.userInteractionEnabled = YES;
        //        }
        [_table8.mj_header endRefreshing];
        [_table8.mj_footer endRefreshing];
        [self.table8 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table8.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView1.hidden = NO;
        [_table8.mj_header endRefreshing];
        [_table8.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData9
{
    NSLog(@"界面1");
    if (_page9 == 1) {
        [_data9 removeAllObjects];
        [_goodData9 removeAllObjects];
        //        [_commentData1 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page9];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"Wonderful";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"longitude"] = [user objectForKey:@"longitude"];
    //    params[@"latitude"] = [user objectForKey:@"latitude"];
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    
    params[@"area_id"] = @"0";
    params[@"domand_type"] = self.speak_type;
    params[@"style"] = self.state;
    
    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
    //                          @"page" : page};
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table9.hidden = NO;
        //        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data9 addObjectsFromArray:arr];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"isEntry"]];
            [_goodData9 addObject:is_good];
            //            NSString *comment = dic[@"speak_comment_content"];
            //            [_commentData1 addObject:comment];
        }
        //        [_dataSources replaceObjectAtIndex:0 withObject:_dataSource1];
        //        [self table1];
        //        _reqErrorView1.hidden = YES;
        //        //        [_reqErrorView1 removeFromSuperview];
        //        if (_data1.count == 0) {
        //            _noDataView1.hidden = NO;
        //            _headImageView1.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView1.hidden = YES;
        //            _headImageView1.userInteractionEnabled = YES;
        //        }
        [_table9.mj_header endRefreshing];
        [_table9.mj_footer endRefreshing];
        [self.table9 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table9.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView1.hidden = NO;
        [_table9.mj_header endRefreshing];
        [_table9.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData10
{
    NSLog(@"界面1");
    if (_page10 == 1) {
        [_data10 removeAllObjects];
        [_goodData10 removeAllObjects];
        //        [_commentData1 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page10];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"Wonderful";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"longitude"] = [user objectForKey:@"longitude"];
    //    params[@"latitude"] = [user objectForKey:@"latitude"];
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    
    params[@"area_id"] = @"0";
    params[@"domand_type"] = self.speak_type;
    params[@"style"] = self.state;
    
    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
    //                          @"page" : page};
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table10.hidden = NO;
        //        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data10 addObjectsFromArray:arr];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"isEntry"]];
            [_goodData10 addObject:is_good];
            //            NSString *comment = dic[@"speak_comment_content"];
            //            [_commentData1 addObject:comment];
        }
        //        [_dataSources replaceObjectAtIndex:0 withObject:_dataSource1];
        //        [self table1];
        //        _reqErrorView1.hidden = YES;
        //        //        [_reqErrorView1 removeFromSuperview];
        //        if (_data1.count == 0) {
        //            _noDataView1.hidden = NO;
        //            _headImageView1.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView1.hidden = YES;
        //            _headImageView1.userInteractionEnabled = YES;
        //        }
        [_table10.mj_header endRefreshing];
        [_table10.mj_footer endRefreshing];
        [self.table10 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table10.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView1.hidden = NO;
        [_table10.mj_header endRefreshing];
        [_table10.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSources[self.currentPage] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    DemandCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[DemandCell alloc] init];
    }
    
    NSDictionary *dic = _dataSources[self.currentPage][indexPath.row];
    [cell confineCellwithData:dic];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.functionBtn.appendIndexPath = indexPath;
    [cell.functionBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.dustbinBtn.tag = indexPath.row + 1;
    [cell.dustbinBtn addTarget:self action:@selector(dustbinClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.attentionBtn.tag = indexPath.row + 1;
    [cell.attentionBtn addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.iconBtn.appendIndexPath = indexPath;
    [cell.iconBtn addTarget:self action:@selector(checkPersonalHomePage:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    cell.nickName.appendIndexPath = indexPath;
    [cell.nickName addGestureRecognizer:tap];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = @"测试高度:";
    CGSize normalSize = [str sizeWithAttributes:@{NSFontAttributeName:GetFont(14)}];
    CGSize addresSize = [str sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    NSDictionary *dic = _dataSources[self.currentPage][indexPath.row];
    NSInteger count = [dic[@"Photo"] count];
    CGFloat cellHeight;
    if (count>0) {
        cellHeight = 60 + 7*normalSize.height + 6*8 + 8 + 76 + 10 + addresSize.height + 10 + 26 + 6;
    } else {
        cellHeight = 60 + 7*normalSize.height + 6*8 + 10 + addresSize.height + 10 + 26 + 6;
    }
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_operationView dismiss];
    [self keyBoadrDismiss];
    NSDictionary *dic = self.dataSources[self.currentPage][indexPath.row];
    DemandDetailViewController *detail = [[DemandDetailViewController alloc] init];
    detail.domand_id = dic[@"domandId"];
    detail.user_id = dic[@"user_id"];
    detail.info = dic;
    detail.is_good = [_goodDatas[self.currentPage][indexPath.row] boolValue];
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - 进入个人主页

- (void)checkPersonalHomePage:(WPButton *)sender
{
    self.iconClickIndexPath = sender.appendIndexPath;
    NSDictionary *dic = _dataSources[self.currentPage][_iconClickIndexPath.row];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    NSString *sid = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
    DemandPersonalController *personal = [[DemandPersonalController alloc] init];
    personal.str = dic[@"user_name"];
    NSLog(@"%@====%@",usersid,sid);
    if ([usersid isEqualToString:sid]) {
        personal.is_myself = YES;
        //        personal.delegate = self;
    } else {
        personal.is_myself = NO;
    }
    personal.sid = sid;
    personal.style = self.speak_type;
    [self.navigationController pushViewController:personal animated:YES];
}

- (void)longPressToDo:(UITapGestureRecognizer *)tap
{
    WPNicknameLabel *nickName = (WPNicknameLabel *)tap.self.view;
    //    NSLog(@"********%d",nickName.appendIndexPath.row);
    nickName.backgroundColor = RGB(226, 226, 226);
    [self performSelector:@selector(delayWithObj:) withObject:nickName afterDelay:0.2];
    NSDictionary *dic = _dataSources[self.currentPage][nickName.appendIndexPath.row];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    NSString *sid = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
    DemandPersonalController *personal = [[DemandPersonalController alloc] init];
    personal.str = dic[@"user_name"];
    NSLog(@"%@====%@",usersid,sid);
    if ([usersid isEqualToString:sid]) {
        personal.is_myself = YES;
        //        personal.delegate = self;
    } else {
        personal.is_myself = NO;
    }
    personal.sid = sid;
    personal.style = self.speak_type;
    [self.navigationController pushViewController:personal animated:YES];    
}

- (void)delayWithObj:(WPNicknameLabel *)nickName
{
    nickName.backgroundColor = [UIColor whiteColor];
}


#pragma mark - 报名和评论
- (void)replyAction:(WPButton *)sender
{
    //    self.chatInputView.textView.text = nil;
    //    self.chatInputView.hidden = YES;
    //    [self p_hideBottomComponent];
    
    if (sender.isSelected == YES) {
        sender.selected = NO;
    } else {
        sender.selected = YES;
    }
    
    UITableView *table = self.tableViews[self.currentPage];
    NSMutableArray *goodData = self.goodDatas[self.currentPage];
//    if (self.currentPage == 0) {
//        table = _table1;
//        goodData = _goodData1;
//    } else if (self.currentPage == 1) {
//        table = _table2;
//        goodData = _goodData2;
//    } else if (self.currentPage == 2) {
//        table = _table3;
//        goodData = _goodData3;
//    } else if (self.currentPage == 3) {
//        table = _table4;
//        goodData = _goodData4;
//    }
    CGRect rectInTableView = [table rectForRowAtIndexPath:sender.appendIndexPath];
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame) - 6, origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = sender.appendIndexPath;
    BOOL isFavour;
    NSString *is_good = goodData[_selectedIndexPath.row];
    NSLog(@"====%@",is_good);
    if ([is_good isEqualToString:@"0"]) {
        isFavour = NO;
    } else {
        isFavour = YES;
    }
    [self.operationView showAtView:table rect:targetRect isFavour:isFavour];
    
}

- (WFPopView *)operationView {
    if (!_operationView) {
        _operationView = [WFPopView initailzerWFOperationView];
        _operationView.rightType = WFRightButtonTypeSpecial;
        [_operationView updateImage];
        __weak __typeof(self)weakSelf = self;
        _operationView.didSelectedOperationCompletion = ^(WFOperationType operationType) {
            switch (operationType) {
                case WFOperationTypeLike:
                    [weakSelf addLike];
                    break;
                case WFOperationTypeReply:
                    [weakSelf replyMessage: nil];
                    break;
                default:
                    break;
            }
        };
    }
    return _operationView;
}

//报名
- (void)addLike
{
    UITableView *table = self.tableViews[self.currentPage];
    NSMutableArray *goodData = self.goodDatas[self.currentPage];
    NSMutableArray *data = _dataSources[self.currentPage];
//    if (self.currentPage == 0) {
//        table = _table1;
//        goodData = _goodData1;
//    } else if (self.currentPage == 1) {
//        table = _table2;
//        goodData = _goodData2;
//    } else if (self.currentPage == 2) {
//        table = _table3;
//        goodData = _goodData3;
//    } else if (self.currentPage == 3) {
//        table = _table4;
//        goodData = _goodData4;
//    }
    DemandCell *cell = (DemandCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
    cell.functionBtn.selected = NO;
    NSLog(@"%ld",(long)_selectedIndexPath.row);
    NSString *is_good = goodData[_selectedIndexPath.row];
    NSLog(@"====%@",is_good);
//    __block NSInteger count = [cell.praiseLabel.text integerValue];
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data[_selectedIndexPath.row]];
    params[@"action"] = @"ClickEntry";
    params[@"domandId"] = dic[@"domandId"];
    params[@"user_id"] = userInfo[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alert show];
        if ([json[@"status"] integerValue] == 0) {
            [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
            if ([is_good isEqualToString:@"0"]) {
                //                count ++;
                //                [dic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"entryCount"];
                [goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"1"];
                //                [_dataSources[self.currentPage] replaceObjectAtIndex:_selectedIndexPath.row withObject:dic];
                
            } else {
                //                count --;
                //                [dic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"entryCount"];
                [goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"0"];
                //                [_dataSources[self.currentPage] replaceObjectAtIndex:_selectedIndexPath.row withObject:dic];
            }
            //            cell.praiseLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
            //            [table reloadData];
            [self updateCommentCoutAndApplyCountWith:nil];
        } else {
            [MBProgressHUD showError:json[@"info"] toView:self.view];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
        [MBProgressHUD alertView:@"操作失败" Message:error.localizedDescription];
    }];
    
}

//评论
- (void)replyMessage:(WPButton *)sender{
    self.chatInputView.hidden = NO;
    [self.chatInputView.textView becomeFirstResponder];
    self.isEditeNow = YES;
}

//更新评论和报名数
- (void)updateCommentCoutAndApplyCountWith:(NSString *)demandId
{
    UITableView *table = self.tableViews[self.currentPage];
    DemandCell *cell = (DemandCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"WonderfulCount";
    params[@"domandId"] = _dataSources[self.currentPage][_selectedIndexPath.row][@"domandId"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"status"] integerValue] == 0) {
            cell.commentLabel.text = json[@"commentCount"];
            cell.praiseLabel.text = json[@"entryCount"];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error.debugDescription);
    }];
    
}

#pragma mark - 删除和关注
//垃圾桶点击事件
- (void)dustbinClick:(UIButton *)btn{
    DemandCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        cell = (DemandCell *)[[btn superview] superview];
    } else {
        cell = (DemandCell *)[[[btn superview] superview] superview];
    }
    NSDictionary *dic = [NSDictionary dictionary];
    NSIndexPath *path = [self.tableViews[self.currentPage] indexPathForCell:cell];
    dic = self.dataSources[self.currentPage][path.row];
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"DeleteWonderful";
    params[@"domandId"] = [NSString stringWithFormat:@"%@",dic[@"domandId"]];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    
    self.deletParams = params;
    self.deletIndex = btn.tag - 1;
    
    //    NSLog(@"****%@",params);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该条说说吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
    
//    NSLog(@"****%@",params);
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    NSLog(@"%d",buttonIndex);
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            NSLog(@"取消");
        } else {
            NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
            [WPHttpTool postWithURL:url params:self.deletParams success:^(id json) {
                NSLog(@"%@",json[@"info"]);
                if ([json[@"status"] integerValue] == 0) {
                    [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
                    [_dataSources[self.currentPage] removeObjectAtIndex:self.deletIndex];
                    [self.tableViews[self.currentPage] reloadData];
                } else {
                    [MBProgressHUD showError:json[@"info"] toView:self.view];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
            
        }
    }
}

//关注
- (void)attentionClick:(UIButton *)sender
{
    NSLog(@"关注");
    DemandCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        cell = (DemandCell *)[[sender superview] superview];
    } else {
        cell = (DemandCell *)[[[sender superview] superview] superview];
    }
    NSDictionary *dic = [NSDictionary dictionary];
    NSIndexPath *path = [self.tableViews[self.currentPage] indexPathForCell:cell];
    dic = self.dataSources[self.currentPage][path.row];
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/attention.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"attentionSigh";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    params[@"by_user_id"] = dic[@"user_id"];
    params[@"by_nick_name"] = dic[@"user_name"];
    
    NSLog(@"*****%@",url);
    NSLog(@"#####%@",params);
    
    NSString *nick_name = dic[@"user_name"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@===%@",json[@"info"],json);
        if ([json[@"status"] integerValue] == 1) {
            NSMutableArray *data = _dataSources[self.currentPage];
            for (int i=0; i<data.count; i++) {
                NSDictionary *dict = data[i];
                NSString *nick = dict[@"user_name"];
                NSString *attention = [NSString stringWithFormat:@"%@",dict[@"isAttent"]];
                if ([nick isEqualToString:nick_name]) {
                    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithDictionary:dict];
                    if ([attention isEqualToString:@"0"]) {
                        [newDic setObject:@"1" forKey:@"isAttent"];
                    } else if([attention isEqualToString:@"1"]){
                        [newDic setObject:@"0" forKey:@"isAttent"];
                    } else if ([attention isEqualToString:@"2"]) {
                        [newDic setObject:@"3" forKey:@"isAttent"];
                    } else if ([attention isEqualToString:@"3"]) {
                        [newDic setObject:@"2" forKey:@"isAttent"];
                    }
                    [data replaceObjectAtIndex:i withObject:newDic];
                }
            }
            [self.tableViews[self.currentPage] reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
}


-(void)makeContent
{
 
    NSString*documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
    NSString*newFielPath = [documentsPath stringByAppendingPathComponent:@"bb.txt"];
    
    NSMutableArray *listTop = [NSMutableArray arrayWithContentsOfFile:newFielPath];
    
    if (listTop == NULL) {
        NSLog(@"list is empty");
        listTop = [[NSMutableArray alloc] initWithArray:@[@"全部",@"人气",@"急招聘",@"急求职",@"交友",@"请吃饭",@"看电影",@"唱歌",@"户外",@"顺风车"]];
    }
//    NSMutableArray *listTop = [[NSMutableArray alloc] initWithArray:@[@"职场说说",@"职场正能量",@"职场吐槽",@"管理智慧",@"创业心得",@"职场心理学",@"情感心语"]];
    _items = [[NSMutableArray alloc] initWithArray:listTop];
    _lastestItems = [[NSMutableArray alloc] initWithArray:listTop];
    __weak typeof(self) unself = self;
//    _items = listTop;
//    _items = [NSArray array];
    if (!self.detailsList) {
        self.detailsList = [[BYDetailsList alloc] initWithFrame:CGRectMake(0, kListBarH-kScreenH, kScreenW, kScreenH-kListBarH)];
        self.detailsList.listAll = [NSMutableArray arrayWithObjects:listTop, nil];
        self.detailsList.longPressedBlock = ^(){
            [unself.deleteBar sortBtnClick:unself.deleteBar.sortBtn];
        };
        self.detailsList.opertionFromItemBlock = ^(animateType type, NSString *itemName, int index){
            unself.lastestItems = unself.detailsList.listAll[0];
//            if (type != topViewClick) {
//                [unself upDateScroll];
//            }
//            NSLog(@"******%@",unself.items);
//            NSLog(@"****%d",index);
//            if (index != 0) {
//                [unself.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0) animated:YES];
//            }
            [unself.listBar operationFromBlock:type itemName:itemName index:index];
        };
        [self.view addSubview:self.detailsList];
    }
//    if (!self.area) {
//        self.area = [[AreaView alloc] initWithFrame:CGRectMake(0, kListBarH-kScreenH, kScreenW, kScreenH)];
//        [self.view addSubview:self.area];
//    }
    
    
    if (!self.listBar) {
        self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0,0, kScreenW, kListBarH)];
        self.listBar.visibleItemList = listTop;
        self.listBar.arrowChange = ^(){
            
            if (unself.arrow.arrowBtnClick) {
                
                unself.arrow.arrowBtnClick();
            }
        };
        self.listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
            //            NSLog(@"%@",itemName);
//            [unself cityDismiss];
//            [unself refreshDataWithRemandType:itemName];
//            NSLog(@"#######%d",itemIndex);
            unself.selectItem = itemName;
            unself.currentPage = itemIndex;
            
            [unself reloadDataWith:itemIndex style:itemName];
            [unself.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*itemIndex, 0) animated:YES];
            [unself.detailsList itemRespondFromListBarClickWithItemName:itemName];
        };
        [self.view addSubview:self.listBar];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kListBarH, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGBColor(178, 178, 178);
    [self.view addSubview:line];
    
    if (!self.deleteBar) {
        self.deleteBar = [[BYDeleteBar alloc] initWithFrame:self.listBar.frame];
        [self.view addSubview:self.deleteBar];
    }
    
    
    if (!self.arrow) {
        
        self.arrow = [[BYArrow alloc] initWithFrame:CGRectMake(kScreenW-kArrowW, 0, kArrowW, kListBarH)];
        self.arrow.arrowBtnClick = ^(){
            //            [self cityDismiss];
            _isWhite = !_isWhite;
            _isLoad = !_isLoad;
            //            [area setBackgroundColor:_isWhite ? RGBColor(238.0, 238.0, 238.0):[UIColor whiteColor]];
            //            [area setTitle:_isWhite ? @"":@"区域" forState:UIControlStateNormal];
            [unself.arrow setBackgroundColor:unself.isWhite ? RGBColor(238.0, 238.0, 238.0):[UIColor whiteColor]];
            if (unself.isWhite) {
                line.hidden = YES;
            } else {
                line.hidden = NO;
            }
            if (unself.isLoad) {
                NSLog(@"下拉状态");
            } else {
                [unself upDateScroll];
            }
            unself.deleteBar.hidden = !unself.deleteBar.hidden;
            [UIView animateWithDuration:kAnimationTime animations:^{
                CGAffineTransform rotation = unself.arrow.imageView.transform;
                unself.arrow.imageView.transform = CGAffineTransformRotate(rotation,M_PI);
                unself.detailsList.transform = (unself.detailsList.frame.origin.y<0)?CGAffineTransformMakeTranslation(0, kScreenH):CGAffineTransformMakeTranslation(0, -kScreenH);
            }];
        };
        [self.view addSubview:self.arrow];
    }
}

- (void)writeFileWith:(NSMutableArray *)data
{
    
    NSString*documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
    NSString *newFielPath = [documentsPath stringByAppendingPathComponent:@"bb.txt"];
    //    NSError *error =nil;
    BOOL isSucceed = [data writeToFile:newFielPath atomically:YES];
    if (isSucceed) {
        NSLog(@"write success");
    }
}

//底部按钮移到最新
- (void)updateBottomBtn
{
    //    if (self.isBottomClick) {
    //        [self.dataSources[self.lastPage] removeAllObjects];
    //    }
    self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*0 , 40, SCREEN_WIDTH/4, 3);
    self.button1.selected = YES;
    self.button2.selected = NO;
    self.button3.selected = NO;
    self.button4.selected = NO;
    self.state = @"1";
    self.isBottomClick = NO;
}

- (void)upDateScroll
{
//        for (NSString *str in self.lastestItems) {
//            NSLog(@"******%@",str);
//        }
//        for (NSString *str in self.items) {
//            NSLog(@"#######%@",str);
//        }
//        NSLog(@"======%@",self.selectItem);
    if ([self.lastestItems isEqualToArray:self.items]) {
        _isChange = NO;
    } else {
        _isChange = YES;
        [self writeFileWith:self.lastestItems];
    }
    _items = [[NSMutableArray alloc] initWithArray:_lastestItems];
    //    NSLog(@"#######%@",self.selectItem);
    if (_isChange) {
        for (int i=0; i<self.lastestItems.count; i ++) {
            NSString *item = self.lastestItems[i];
            if ([item isEqualToString:self.selectItem]) {
                self.currentPage = i;
                //                NSLog(@"22222********%ld",(long)self.currentPage);
                //                [self updateBottomBtn];
//                for (NSMutableArray *data in self.dataSources) {
//                    [data removeAllObjects];
//                }
//                for (UITableView *table in self.tableViews) {
//                    [table reloadData];
//                }
                [self reloadDataWith:self.currentPage style:self.selectItem];
                [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*i, 0) animated:YES];
            }
        }
    }
}

- (void)reloadDataWith:(NSInteger)index style:(NSString *)speak_type
{
    NSLog(@"第%ld页====%@",index+1,speak_type);
    if ([speak_type isEqualToString:@"全部"]) {
        self.speak_type = @"0";
    } else if ([speak_type isEqualToString:@"急招聘"]) {
        self.speak_type = @"1";
    } else if ([speak_type isEqualToString:@"急求职"]) {
        self.speak_type = @"2";
    } else if ([speak_type isEqualToString:@"交友"]) {
        self.speak_type = @"3";
    } else if ([speak_type isEqualToString:@"请吃饭"]) {
        self.speak_type = @"4";
    } else if ([speak_type isEqualToString:@"看电影"]) {
        self.speak_type = @"5";
    } else if ([speak_type isEqualToString:@"唱歌"]) {
        self.speak_type = @"6";
    } else if ([speak_type isEqualToString:@"户外"]) {
        self.speak_type = @"7";
    } else if ([speak_type isEqualToString:@"顺风车"]) {
        self.speak_type = @"8";
    } else if ([speak_type isEqualToString:@"自定义"]) {
        self.speak_type = @"9";
    } else if ([speak_type isEqualToString:@"人气"]) {
        self.speak_type = @"10";
    }

    [self.tableViews[self.currentPage] setContentOffset:CGPointMake(0, 0) animated:NO];
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
}

- (void)delay{
    NSString *state = self.states[self.currentPage];
    if (![state isEqualToString:self.state]) {
        [self.dataSources[self.currentPage] removeAllObjects];
        //        [self.tableViews[self.currentPage] reloadData];
        [self.states replaceObjectAtIndex:self.currentPage withObject:self.state];
    }
    
    NSMutableArray *data = _dataSources[self.currentPage];
    if (data.count>0) {
        return;
    }
    [[self.tableViews[self.currentPage] mj_header] beginRefreshing];
}

- (void)createUI
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kListBarH, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - kListBarH - 43)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*10, SCREEN_HEIGHT - 64 - kListBarH-43);
    
    [self.view addSubview:_scrollView];
    for (int i = 0; i<10; i++) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 100, SCREEN_WIDTH, 25)];
        title.text = [NSString stringWithFormat:@"第%d页",i + 1];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor blackColor];
        title.font = [UIFont systemFontOfSize:20];
        [_scrollView addSubview:title];
    }
}

#pragma mark - 创建底部按钮
- (void)createBottom
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 107, SCREEN_WIDTH, 43.5)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
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
    
    [UIView animateWithDuration:0.3 animations:^{
        if (sender.tag == 4) {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , 40, (SCREEN_WIDTH - 2)/3 + 3, 3);
        } else {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*(sender.tag - 1) , 40, SCREEN_WIDTH/4, 3);
        }
    }];
    if (sender.tag == 1) {
        self.button1.selected = YES;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = NO;
        self.state = @"1";
        self.isBottomClick = NO;
    } else if (sender.tag == 2) {
        self.button1.selected = NO;
        self.button2.selected = YES;
        self.button3.selected = NO;
        self.button4.selected = NO;
        self.state = @"2";
        self.isBottomClick = YES;
    } else if (sender.tag == 3) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = YES;
        self.button4.selected = NO;
        self.state = @"3";
        self.isBottomClick = YES;
    } else if (sender.tag == 4) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = YES;
        self.state = @"4";
        self.isBottomClick = YES;
    }
    self.lastPage = self.currentPage;
    [self reloadDataWith:self.currentPage style:self.selectItem];
    
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    
    if ([scrollView isEqual:self.scrollView]) {
        int index = scrollView.contentOffset.x/SCREEN_WIDTH;
        [self.listBar itemClick:self.listBar.btnLists[[self.listBar findIndexOfListsWithTitle:self.items[index]]]];
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_operationView dismiss];
    [self keyBoadrDismiss];
}

#pragma  mark - PrivateAPI
- (void)p_hideBottomComponent
{
    _bottomShowComponent = _bottomShowComponent * 0;
    [self.chatInputView.textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.ddUtility.view.frame = DDCOMPONENT_BOTTOM;
        self.emotions.view.frame = DDCOMPONENT_BOTTOM;
        self.chatInputView.frame = DDINPUT_BOTTOM_FRAME;
    }];
    NSLog(@"%f",self.chatInputView.frame.origin.y);
    [self setValue:@(self.chatInputView.frame.origin.y) forKeyPath:@"_inputViewY"];
}

//注册观察中心
-(void)notificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillShowKeyboard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboard:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)initialInput
{
    CGRect inputFrame = CGRectMake(0, SCREEN_HEIGHT - 108,SCREEN_WIDTH,44.0f);
    self.chatInputView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    [self.chatInputView setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]];
    [self.view addSubview:self.chatInputView];
    [self.view bringSubviewToFront:self.chatInputView];
    [self.chatInputView.emotionbutton addTarget:self
                                         action:@selector(showEmotions:)
                               forControlEvents:UIControlEventTouchUpInside];
    
    [self.chatInputView.showUtilitysbutton addTarget:self
                                              action:@selector(showUtilitys:)
                                    forControlEvents:UIControlEventTouchDown];
    
    [self.chatInputView.voiceButton addTarget:self
                                       action:@selector(p_clickThRecordButton:)
                             forControlEvents:UIControlEventTouchUpInside];
//    [self.chatInputView.anotherSendBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _touchDownGestureRecognizer = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:nil];
    __weak NewDemandViewController* weakSelf = self;
    _touchDownGestureRecognizer.touchDown = ^{
        [weakSelf p_record:nil];
    };
    
    _touchDownGestureRecognizer.moveInside = ^{
        [weakSelf p_endCancelRecord:nil];
    };
    
    _touchDownGestureRecognizer.moveOutside = ^{
        [weakSelf p_willCancelRecord:nil];
    };
    
    _touchDownGestureRecognizer.touchEnd = ^(BOOL inside){
        if (inside)
        {
            [weakSelf p_sendRecord:nil];
        }
        else
        {
            [weakSelf p_cancelRecord:nil];
        }
    };
    [self.chatInputView.recordButton addGestureRecognizer:_touchDownGestureRecognizer];
    _recordingView = [[RecordingView alloc] initWithState:DDShowVolumnState];
    [_recordingView setHidden:YES];
    [_recordingView setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    [self addObserver:self forKeyPath:@"_inputViewY" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    self.chatInputView.hidden = YES;
}

- (void)keyBoadrDismiss
{
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
    self.isEditeNow = NO;
}

//- (JSMessageInputView *)chatInputView{
//    if (_chatInputView == nil) {
//        NSLog(@"创建");
//        CGRect inputFrame = CGRectMake(0, SCREEN_HEIGHT - 44.0f - 64.f,SCREEN_WIDTH,44.0f);
//        self.chatInputView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
//        [self.chatInputView setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]];
//        [self.view addSubview:self.chatInputView];
//        [self.chatInputView.emotionbutton addTarget:self
//                                             action:@selector(showEmotions:)
//                                   forControlEvents:UIControlEventTouchUpInside];
//
//        [self.chatInputView.showUtilitysbutton addTarget:self
//                                                  action:@selector(showUtilitys:)
//                                        forControlEvents:UIControlEventTouchDown];
//
//        [self.chatInputView.voiceButton addTarget:self
//                                           action:@selector(p_clickThRecordButton:)
//                                 forControlEvents:UIControlEventTouchUpInside];
//        [self.chatInputView.anotherSendBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.chatInputView.recordButton addGestureRecognizer:_touchDownGestureRecognizer];
//        _recordingView = [[RecordingView alloc] initWithState:DDShowVolumnState];
//        [_recordingView setHidden:YES];
//        [_recordingView setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
//        [self addObserver:self forKeyPath:@"_inputViewY" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//        //        self.chatInputView.hidden = YES;
//
//    }
//    return _chatInputView;
//}

//评论
- (void)commentClick:(UIButton *)sender
{
    if (self.chatInputView.textView.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"评论内容不能为空的哦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSLog(@"*****%@",self.chatInputView.textView.text);
    //    NSMutableArray *data = _dataSources[self.currentPage];
    //    WPShareModel *model = [WPShareModel sharedModel];
    //    NSMutableDictionary *myDic = model.dic;
    //    NSMutableDictionary *dic = data[_selectedIndexPath.row];
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"action"] = @"replySpeak";
    //    params[@"speak_id"] = dic[@"sid"];
    //    params[@"username"] = model.username;
    //    params[@"password"] = model.password;
    //    params[@"user_id"] = myDic[@"userid"];
    //    //    params[@"nick_name"] = myDic[@"nick_name"];
    //    params[@"by_nick_name"] = dic[@"nick_name"];
    //    params[@"speak_comment_content"] = self.chatInputView.textView.text;
    //    params[@"speak_reply"] = @"0";
    //    NSLog(@"****%@",params);
    //    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    //    NSLog(@"####%@",url);
    //    [WPHttpTool postWithURL:url params:params success:^(id json) {
    //        NSLog(@"json: %@",json);
    //        if ([json[@"status"] integerValue] == 1) {
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //            [alert show];
    //            [self updateCommentCount];
    //        }
    //    } failure:^(NSError *error) {
    //        NSLog(@"error: %@",error);
    //    }];
    //
    //    self.chatInputView.textView.text = nil;
    //    self.chatInputView.hidden = YES;
    //    [self p_hideBottomComponent];
    [self commentTheReq];
    [self keyBoadrDismiss];
}

- (void)commentTheReq
{
    NSMutableArray *data = _dataSources[self.currentPage];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *dic = data[_selectedIndexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"AddComment";
    params[@"domandId"] = dic[@"domandId"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = myDic[@"userid"];
    //    params[@"nick_name"] = myDic[@"nick_name"];
    params[@"commentContent"] = self.chatInputView.textView.text;
    params[@"Replay_commentID"] = @"";
    params[@"replay_user_id"] = @"";
    NSLog(@"****%@",params);
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSLog(@"####%@",url);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        if ([json[@"status"] integerValue] == 0) {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
            [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
            //            [self updateCommentCount];
            [self updateCommentCoutAndApplyCountWith:nil];
        } else {
            [MBProgressHUD showMessage:json[@"info"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
        [MBProgressHUD showError:error.localizedDescription toView:self.view];
    }];
    
}

- (void)showEmotions:(UIButton *)sender
{
    NSLog(@"表情");
    if (self.chatInputView.emotionbutton.isSelected == NO) {
        self.chatInputView.emotionbutton.selected = YES;
        [_recordButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
        _recordButton.tag = DDVoiceInput;
        [self.chatInputView willBeginInput];
        if ([_currentInputContent length] > 0)
        {
            [self.chatInputView.textView setText:_currentInputContent];
        }
        
        if (self.emotions == nil) {
            self.emotions = [EmotionsViewController new];
            [self.emotions.view setBackgroundColor:[UIColor darkGrayColor]];
            self.emotions.view.frame=DDCOMPONENT_BOTTOM;
            self.emotions.delegate = self;
            [self.view addSubview:self.emotions.view];
        }
        if (_bottomShowComponent & DDShowKeyboard)
        {
            //显示的是键盘,这是需要隐藏键盘，显示表情，不需要动画
            _bottomShowComponent = (_bottomShowComponent & 0) | DDShowEmotion;
            [self.chatInputView.textView resignFirstResponder];
            [self.emotions.view setFrame:DDEMOTION_FRAME];
            [self.ddUtility.view setFrame:DDCOMPONENT_BOTTOM];
        }
        else if (_bottomShowComponent & DDShowEmotion)
        {
            //表情面板本来就是显示的,这时需要隐藏所有底部界面
            [self.chatInputView.textView resignFirstResponder];
            _bottomShowComponent = _bottomShowComponent & DDHideEmotion;
        }
        //    else if (_bottomShowComponent & DDShowUtility)
        //    {
        //        //显示的是插件，这时需要隐藏插件，显示表情
        //        [self.ddUtility.view setFrame:DDCOMPONENT_BOTTOM];
        //        [self.emotions.view setFrame:DDEMOTION_FRAME];
        //        _bottomShowComponent = (_bottomShowComponent & DDHideUtility) | DDShowEmotion;
        //    }
        else
        {
            //这是什么都没有显示，需用动画显示表情
            _bottomShowComponent = _bottomShowComponent | DDShowEmotion;
            [UIView animateWithDuration:0.25 animations:^{
                [self.emotions.view setFrame:DDEMOTION_FRAME];
                [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
            }];
            [self setValue:@(DDINPUT_TOP_FRAME.origin.y) forKeyPath:@"_inputViewY"];
        }
        [self.chatInputView.voiceButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
        self.chatInputView.voiceButton.tag = DDVoiceInput;
    } else {
        self.chatInputView.emotionbutton.selected = NO;
        [self.chatInputView.voiceButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
        self.chatInputView.voiceButton.tag = DDVoiceInput;
        //        [self.chatInputView willBeginInput];
        [self.chatInputView.textView becomeFirstResponder];
    }
    
}

- (void)showUtilitys:(UIButton *)sender
{
    [_recordButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
    _recordButton.tag = DDVoiceInput;
    [self.chatInputView willBeginInput];
    if ([_currentInputContent length] > 0)
    {
        [self.chatInputView.textView setText:_currentInputContent];
    }
    
    if (self.ddUtility == nil)
    {
        self.ddUtility = [ChatUtilityViewController new];
        self.ddUtility.delegate = self;
        [self addChildViewController:self.ddUtility];
        self.ddUtility.view.frame=CGRectMake(0, self.view.frame.size.height,self.view.frame.size.width , 280);
        [self.view addSubview:self.ddUtility.view];
    }
    
    if (_bottomShowComponent & DDShowKeyboard)
    {
        //显示的是键盘,这是需要隐藏键盘，显示插件，不需要动画
        _bottomShowComponent = (_bottomShowComponent & 0) | DDShowUtility;
        [self.chatInputView.textView resignFirstResponder];
        [self.ddUtility.view setFrame:DDUTILITY_FRAME];
        [self.emotions.view setFrame:DDCOMPONENT_BOTTOM];
    }
    else if (_bottomShowComponent & DDShowUtility)
    {
        //插件面板本来就是显示的,这时需要隐藏所有底部界面
        //        [self p_hideBottomComponent];
        [self.chatInputView.textView becomeFirstResponder];
        _bottomShowComponent = _bottomShowComponent & DDHideUtility;
    }
    else if (_bottomShowComponent & DDShowEmotion)
    {
        //显示的是表情，这时需要隐藏表情，显示插件
        [self.emotions.view setFrame:DDCOMPONENT_BOTTOM];
        [self.ddUtility.view setFrame:DDUTILITY_FRAME];
        _bottomShowComponent = (_bottomShowComponent & DDHideEmotion) | DDShowUtility;
    }
    else
    {
        //这是什么都没有显示，需用动画显示插件
        _bottomShowComponent = _bottomShowComponent | DDShowUtility;
        [UIView animateWithDuration:0.25 animations:^{
            [self.ddUtility.view setFrame:DDUTILITY_FRAME];
            [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(DDINPUT_TOP_FRAME.origin.y) forKeyPath:@"_inputViewY"];
        
    }
    
}

- (void)p_clickThRecordButton:(UIButton *)button
{
    switch (button.tag) {
        case DDVoiceInput:
            //开始录音
            [self p_hideBottomComponent];
            [button setImage:[UIImage imageNamed:@"dd_input_normal"] forState:UIControlStateNormal];
            button.tag = DDTextInput;
            [self.chatInputView willBeginRecord];
            [self.chatInputView.textView resignFirstResponder];
            _currentInputContent = self.chatInputView.textView.text;
            if ([_currentInputContent length] > 0)
            {
                [self.chatInputView.textView setText:nil];
            }
            break;
        case DDTextInput:
            //开始输入文字
            [button setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
            button.tag = DDVoiceInput;
            [self.chatInputView willBeginInput];
            if ([_currentInputContent length] > 0)
            {
                [self.chatInputView.textView setText:_currentInputContent];
            }
            [self.chatInputView.textView becomeFirstResponder];
            break;
    }
    
}

- (void)p_record:(UIButton*)button
{
    [self.chatInputView.recordButton setHighlighted:YES];
    if (![[self.view subviews] containsObject:_recordingView])
    {
        [self.view addSubview:_recordingView];
    }
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:DDShowVolumnState];
    [[RecorderManager sharedManager] setDelegate:self];
    [[RecorderManager sharedManager] startRecording];
    NSLog(@"record");
}
- (void)p_endCancelRecord:(UIButton*)button
{
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:DDShowVolumnState];
}
- (void)p_willCancelRecord:(UIButton*)button
{
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:DDShowCancelSendState];
    NSLog(@"will cancel record");
}
//发送语音
- (void)p_sendRecord:(UIButton*)button
{
//    [self.chatInputView.recordButton setHighlighted:NO];
//    [[RecorderManager sharedManager] stopRecording];
//    NSLog(@"send record");
//    NSString *file = [RecorderManager sharedManager].fileAdress;
//    NSLog(@"#####%@",file);
//    [_chatInputView.voiceButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
//    _chatInputView.voiceButton.tag = DDVoiceInput;
//    
//    NSMutableArray *data = _dataSources[self.currentPage];
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *myDic = model.dic;
//    NSMutableDictionary *dic = data[_selectedIndexPath.row];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"AddComment";
//    params[@"domandId"] = dic[@"domandId"];
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = myDic[@"userid"];
//    //    params[@"nick_name"] = myDic[@"nick_name"];
//    params[@"commentContent"] = @"";
//    params[@"Replay_commentID"] = @"";
//    params[@"replay_user_id"] = @"";
//    NSLog(@"****%@",params);
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
//    NSData *audioData = [NSData dataWithContentsOfFile:file];
//    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
//    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manage POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:audioData name:@"speak_comment_content" fileName:@"speak_comment_content.mp3" mimeType:@"audio/mpeg3"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"*****%@",json[@"info"]);
//        if ([json[@"status"] integerValue] == 0) {
//            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            //            [alert show];
//            [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
//            //            [self updateCommentCount];
//            [self updateCommentCoutAndApplyCountWith:nil];
//        } else {
//            [MBProgressHUD showMessage:json[@"info"]];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error: %@",error);
//        [MBProgressHUD showError:error.localizedDescription toView:self.view];
//    }];
//    [self keyBoadrDismiss];
    //    [self.chatInputView willBeginInput];
    //    _chatInputView.hidden = YES;
    //    _chatInputView = nil;
    //    if (self.isNeedDelloc > 0) {
    //        [self needDealloc];
    //        self.isNeedDelloc --;
    //    }
}
- (void)p_cancelRecord:(UIButton*)button
{
    [self.chatInputView.recordButton setHighlighted:NO];
    [_recordingView setHidden:YES];
    [[RecorderManager sharedManager] cancelRecording];
    NSLog(@"cancel record");
}
#pragma mark - KeyBoardNotification
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    CGRect keyboardRect;
    keyboardRect = [(notification.userInfo)[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    _bottomShowComponent = _bottomShowComponent | DDShowKeyboard;
    //什么都没有显示
    [UIView animateWithDuration:0.25 animations:^{
        [self.chatInputView setFrame:CGRectMake(0, keyboardRect.origin.y - DDINPUT_HEIGHT, self.view.frame.size.width, DDINPUT_HEIGHT)];
    }];
    [self setValue:@(keyboardRect.origin.y - DDINPUT_HEIGHT) forKeyPath:@"_inputViewY"];
    
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    CGRect keyboardRect;
    keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    _bottomShowComponent = _bottomShowComponent & DDHideKeyboard;
    if (_bottomShowComponent & DDShowUtility)
    {
        //显示的是插件
        [UIView animateWithDuration:0.25 animations:^{
            [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(self.chatInputView.frame.origin.y) forKeyPath:@"_inputViewY"];
    }
    else if (_bottomShowComponent & DDShowEmotion)
    {
        //显示的是表情
        [UIView animateWithDuration:0.25 animations:^{
            [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(self.chatInputView.frame.origin.y) forKeyPath:@"_inputViewY"];
        
    }
    else
    {
        [self p_hideBottomComponent];
    }
}
#pragma mark - Text view delegatef

- (void)viewheightChanged:(float)height
{
    [self setValue:@(self.chatInputView.frame.origin.y) forKeyPath:@"_inputViewY"];
}
- (void)textViewEnterSend
{
    if (self.chatInputView.textView.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"评论不能为空的哦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //发送消息
    NSString* text = [self.chatInputView.textView text];
    
    NSString* parten = @"\\s";
    NSRegularExpression* reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:nil];
    NSString* checkoutText = [reg stringByReplacingMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length]) withTemplate:@""];
    if ([checkoutText length] == 0)
    {
        return;
    }
    NSLog(@"发送消息：%@",self.chatInputView.textView.text);
    [self commentTheReq];
    [self keyBoadrDismiss];
    //    NSMutableArray *data = _datas[self.currentPage];
    //    WPShareModel *model = [WPShareModel sharedModel];
    //    NSMutableDictionary *myDic = model.dic;
    //    NSMutableDictionary *dic = data[_selectedIndexPath.row];
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"action"] = @"replySpeak";
    //    params[@"speak_id"] = dic[@"sid"];
    //    params[@"username"] = model.username;
    //    params[@"password"] = model.password;
    //    params[@"user_id"] = myDic[@"userid"];
    //    //    params[@"nick_name"] = myDic[@"nick_name"];
    //    params[@"by_nick_name"] = dic[@"nick_name"];
    //    params[@"speak_comment_content"] = self.chatInputView.textView.text;
    //    params[@"speak_reply"] = @"0";
    //    NSLog(@"****%@",params);
    //    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    //    NSLog(@"####%@",url);
    //    [WPHttpTool postWithURL:url params:params success:^(id json) {
    //        NSLog(@"json: %@",json);
    //        if ([json[@"status"] integerValue] == 1) {
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //            [alert show];
    //            [self updateCommentCount];
    //        }
    //    } failure:^(NSError *error) {
    //        NSLog(@"error: %@",error);
    //    }];
    //    self.chatInputView.textView.text = nil;
    //    self.chatInputView.hidden = YES;
    //    [self p_hideBottomComponent];
    //    self.chatInputView = nil;
    //    if (self.isNeedDelloc > 0) {
    //        [self needDealloc];
    //        self.isNeedDelloc --;
    //    }
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"_inputViewY"])
    {
        //            [self p_unableLoadFunction];
        [UIView animateWithDuration:0.25 animations:^{
            if (_bottomShowComponent & DDShowEmotion)
            {
                CGRect frame = self.emotions.view.frame;
                frame.origin.y = self.chatInputView.bottom;
                self.emotions.view.frame = frame;
            }
            if (_bottomShowComponent & DDShowUtility)
            {
                CGRect frame = self.ddUtility.view.frame;
                frame.origin.y = self.chatInputView.bottom;
                self.ddUtility.view.frame = frame;
            }
            
        } completion:^(BOOL finished) {
            //                [self p_enableLoadFunction];
        }];
    }
    
}
- (void)p_tapOnTableView:(UIGestureRecognizer*)sender
{
    if (_bottomShowComponent)
    {
        [self p_hideBottomComponent];
    }
}

#pragma mark - EmotionsViewController Delegate
- (void)emotionViewClickSendButton
{
    [self textViewEnterSend];
}
-(void)insertEmojiFace:(NSString *)string
{
    NSMutableString* content = [NSMutableString stringWithString:self.chatInputView.textView.text];
    [content appendString:string];
    [self.chatInputView.textView setText:content];
}
-(void)deleteEmojiFace
{
    EmotionsModule* emotionModule = [EmotionsModule shareInstance];
    NSString* toDeleteString = nil;
    if (self.chatInputView.textView.text.length == 0)
    {
        return;
    }
    if (self.chatInputView.textView.text.length == 1)
    {
        self.chatInputView.textView.text = @"";
    }
    else
    {
        toDeleteString = [self.chatInputView.textView.text substringFromIndex:self.chatInputView.textView.text.length - 1];
        int length = [emotionModule.emotionLength[toDeleteString] intValue];
        if (length == 0)
        {
            toDeleteString = [self.chatInputView.textView.text substringFromIndex:self.chatInputView.textView.text.length - 2];
            length = [emotionModule.emotionLength[toDeleteString] intValue];
        }
        length = length == 0 ? 1 : length;
        self.chatInputView.textView.text = [self.chatInputView.textView.text substringToIndex:self.chatInputView.textView.text.length - length];
    }
    
}
#pragma Recording Delegate
- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval
{
    NSMutableData* muData = [[NSMutableData alloc] init];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    int length = [RecorderManager sharedManager].recordedTimeInterval;
    if (length < 1 )
    {
        NSLog(@"录音时间太短");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_recordingView setHidden:NO];
            [_recordingView setRecordingState:DDShowRecordTimeTooShort];
        });
        return;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_recordingView setHidden:YES];
        });
    }
    int8_t ch[4];
    for(int32_t i = 0;i<4;i++){
        ch[i] = ((length >> ((3 - i)*8)) & 0x0ff);
    }
    [muData appendBytes:ch length:4];
    [muData appendData:data];
    /**
     *  muData ->  voice data
     *
     *  length  ->  voice Length
     */
    
}
- (void)recordingTimeout
{
    
}
/**
 *  录音机停止采集声音
 */
- (void)recordingStopped
{
    
}
- (void)recordingFailed:(NSString *)failureInfoString
{
    
}
- (void)levelMeterChanged:(float)levelMeter
{
    [_recordingView setVolume:levelMeter];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(DDINPUT_BOTTOM_FRAME, location))
    {
        return NO;
    }
    return YES;
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if ([gestureRecognizer.view isEqual:_tableView])
//    {
//        return YES;
//    }
//    return NO;
//}
#pragma mark -
- (void)playingStoped
{
    
}

//释放刷新控件
- (void)dealloc
{
    //注销观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"_inputViewY"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fefresh" object:nil];
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
