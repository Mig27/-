//
//  NewJobViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/9/24.
//  Copyright (c) 2015年 WP. All rights reserved.
//  工作圈第三版

#import "NewJobViewController.h"
#import "BYListBar.h"
#import "BYArrow.h"
#import "BYDetailsList.h"
#import "BYDeleteBar.h"
#import "BYScroller.h"
#import "WPShareModel.h"
#import "WorkTableViewCell.h"
#import "MJRefresh.h"
#import "WFPopView.h"
#import "TouchDownGestureRecognizer.h"
#import "EmotionsModule.h"
#import "RecordingView.h"


#import "WriteViewController.h"
#import "WPJobDetailViewController.h"
#import "PersonalHomepageController.h"
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

@interface NewJobViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

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
@property (nonatomic,strong) UITableView *table11;
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
@property (nonatomic,strong) NSMutableArray *data11;
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
@property (nonatomic,strong) NSMutableArray *goodData11;
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

@implementation NewJobViewController
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
    NSInteger _page11;

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
    self.speak_type = @"9";
    self.state = @"1";
    self.isWhite = NO;
    self.isChange = NO;
    self.isLoad = NO;
    self.isMore = NO;
    self.isEditeNow = NO;
    [self createBottom];
    [self makeContent];
//    [self table1];
//    [self.table1.mj_header beginRefreshing];
    [self createData1];
//    [self test];
    [self notificationCenter];
    [self initialInput];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[NewJobViewController class]];
}

- (void)initNav{
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
//    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"smll_camera"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

#pragma mark - 发布按钮点击事件
- (void)rightBtnClick{
    WriteViewController *write = [[WriteViewController alloc] init];
    write.refreshData = ^(NSString *topic){
        [self updateBottomBtn];
        for (int i = 0; i < self.lastestItems.count; i++) {
            NSString *item = self.lastestItems[i];
            if ([item isEqualToString:topic]) {
//                NSLog(@"11111111%d",i);
//                NSLog(@"22222222%@",self.dataSources[i]);
                NSMutableArray *data = self.dataSources[i];
                if (data.count >0) {
                    [self.dataSources[i] removeAllObjects];
                    self.isHaveData = YES;
                    [self reloadDataWith:i style:topic];
                }
//                NSLog(@"333333333%@",self.dataSources[i]);
                self.currentPage = i;
                self.selectItem = topic;
                [self.listBar itemClick:self.listBar.btnLists[[self.listBar findIndexOfListsWithTitle:topic]]];
//                [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*i, 0) animated:YES];
//                [self reloadDataWith:i style:topic];
            }
        }
    };
    write.myTitle = @"创建";
    //    write.comment_type = @"1";
    write.is_dynamic = YES;
    [self.navigationController pushViewController:write animated:YES];

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
    _page11 = 1;
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
    self.data11 = [NSMutableArray array];
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
    _goodData11 = [NSMutableArray array];

    self.dataSources = [[NSMutableArray alloc] initWithObjects:self.data1,self.data2,self.data3,self.data4,self.data5,self.data6,self.data7,self.data8,self.data9,self.data10,self.data11 ,nil];
    self.tableViews = [[NSMutableArray alloc] initWithObjects:self.table1,self.table2,self.table3,self.table4,self.table5,self.table6,self.table7,self.table8,self.table9,self.table10,self.table11 ,nil];
    self.goodDatas = [NSMutableArray arrayWithObjects:_goodData1,_goodData2,_goodData3,_goodData4,_goodData5,_goodData6,_goodData7,_goodData8,_goodData9,_goodData10,_goodData11, nil];
    self.states = [[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
}

- (void)test{
    [self table1];
    [self table2];
    [self table3];
    [self table4];
    [self table5];
    [self table6];
    [self table7];
    [self table8];
    [self table9];
    [self table10];
    [self table11];

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

- (UITableView *)table11{
    if (_table11 == nil) {
        self.table11 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*10, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 107 - kListBarH) style:UITableViewStyleGrouped];
        self.table11.delegate = self;
        self.table11.dataSource = self;
        self.table11.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.table11.backgroundColor = RGB(235, 235, 235);
        __weak __typeof(self) weakSelf = self;
        _table11.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page11 = 1;
            [weakSelf createData11];
        }];
        
        _table11.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page11++;
            [weakSelf createData11];
        }];
        [self.scrollView addSubview:self.table11];
    }
    return _table11;
}

#pragma mark - 数据请求
- (void)createData1{
    NSLog(@"界面1");
    if (_page1 == 1) {
        [_data1 removeAllObjects];
//        [_goodData1 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page1];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    if ([self.state isEqualToString:@"1"]) {
        //    params[@"longitude"] = [user objectForKey:@"longitude"];
        //    params[@"latitude"] = [user objectForKey:@"latitude"];
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    }
    params[@"state"] = self.state;
    params[@"speak_type"] = self.speak_type;
    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
    //                          @"page" : page};
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table1.hidden = NO;
        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data1 addObjectsFromArray:arr];
//        [_datas replaceObjectAtIndex:0 withObject:_data1];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
            [_goodData1 addObject:is_good];
        }
//                [self table1];
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
        _page1--;
        [_table1.mj_header endRefreshing];
        [_table1.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData2{
    NSLog(@"界面2");
    if (_page2 == 1) {
        [_data2 removeAllObjects];
//        [_goodData2 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page2];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    if ([self.state isEqualToString:@"1"]) {
        //    params[@"longitude"] = [user objectForKey:@"longitude"];
        //    params[@"latitude"] = [user objectForKey:@"latitude"];
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    }
    params[@"state"] = self.state;
    params[@"speak_type"] = self.speak_type;
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table2.hidden = NO;
        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data2 addObjectsFromArray:arr];
//        [_datas replaceObjectAtIndex:1 withObject:_data2];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
            [_goodData2 addObject:is_good];
        }
//        [self table2];
//        _reqErrorView2.hidden = YES;
//        if (_data2.count == 0) {
//            _noDataView2.hidden = NO;
//            _headImageView2.userInteractionEnabled = NO;
//        } else {
//            _noDataView2.hidden = YES;
//            _headImageView2.userInteractionEnabled = YES;
//        }
        [_table2.mj_header endRefreshing];
        [_table2.mj_footer endRefreshing];
        [self.table2 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table2.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
//        _reqErrorView2.hidden = NO;
        _page2--;
        [_table2.mj_header endRefreshing];
        [_table2.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData3{
    NSLog(@"界面2");
    if (_page3 == 1) {
        [_data3 removeAllObjects];
        //        [_goodData2 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page3];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    if ([self.state isEqualToString:@"1"]) {
        //    params[@"longitude"] = [user objectForKey:@"longitude"];
        //    params[@"latitude"] = [user objectForKey:@"latitude"];
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    }
    params[@"state"] = self.state;
    params[@"speak_type"] = self.speak_type;
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table3.hidden = NO;
        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data3 addObjectsFromArray:arr];
        //        [_datas replaceObjectAtIndex:1 withObject:_data2];
                for (NSDictionary *dic in arr) {
                    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                    [_goodData3 addObject:is_good];
                }
        //        [self table2];
        //        _reqErrorView2.hidden = YES;
        //        if (_data2.count == 0) {
        //            _noDataView2.hidden = NO;
        //            _headImageView2.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView2.hidden = YES;
        //            _headImageView2.userInteractionEnabled = YES;
        //        }
                [_table3.mj_header endRefreshing];
                [_table3.mj_footer endRefreshing];
        [self.table3 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
        [_table3.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView2.hidden = NO;
        _page3--;
        [_table3.mj_header endRefreshing];
        [_table3.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData4{
    NSLog(@"界面2");
    if (_page4 == 1) {
        [_data4 removeAllObjects];
        //        [_goodData2 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page4];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    if ([self.state isEqualToString:@"1"]) {
        //    params[@"longitude"] = [user objectForKey:@"longitude"];
        //    params[@"latitude"] = [user objectForKey:@"latitude"];
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    }
    params[@"state"] = self.state;
    params[@"speak_type"] = self.speak_type;
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table4.hidden = NO;
        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data4 addObjectsFromArray:arr];
        //        [_datas replaceObjectAtIndex:1 withObject:_data2];
                for (NSDictionary *dic in arr) {
                    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                    [_goodData4 addObject:is_good];
                }
        //        [self table2];
        //        _reqErrorView2.hidden = YES;
        //        if (_data2.count == 0) {
        //            _noDataView2.hidden = NO;
        //            _headImageView2.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView2.hidden = YES;
        //            _headImageView2.userInteractionEnabled = YES;
        //        }
        [_table4.mj_header endRefreshing];
        [_table4.mj_footer endRefreshing];
        [self.table4 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table4.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView2.hidden = NO;
        _page4--;
        [_table4.mj_header endRefreshing];
        [_table4.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData5{
    NSLog(@"界面2");
    if (_page5 == 1) {
        [_data5 removeAllObjects];
        //        [_goodData2 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page5];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    if ([self.state isEqualToString:@"1"]) {
        //    params[@"longitude"] = [user objectForKey:@"longitude"];
        //    params[@"latitude"] = [user objectForKey:@"latitude"];
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    }
    params[@"state"] = self.state;
    params[@"speak_type"] = self.speak_type;
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table5.hidden = NO;
        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data5 addObjectsFromArray:arr];
        //        [_datas replaceObjectAtIndex:1 withObject:_data2];
                for (NSDictionary *dic in arr) {
                    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                    [_goodData5 addObject:is_good];
                }
        //        [self table2];
        //        _reqErrorView2.hidden = YES;
        //        if (_data2.count == 0) {
        //            _noDataView2.hidden = NO;
        //            _headImageView2.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView2.hidden = YES;
        //            _headImageView2.userInteractionEnabled = YES;
        //        }
        [_table5.mj_header endRefreshing];
        [_table5.mj_footer endRefreshing];
        [self.table5 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table5.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView2.hidden = NO;
        _page5--;
        [_table5.mj_header endRefreshing];
        [_table5.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData6{
    NSLog(@"界面2");
    if (_page6 == 1) {
        [_data6 removeAllObjects];
        //        [_goodData2 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page6];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    if ([self.state isEqualToString:@"1"]) {
        //    params[@"longitude"] = [user objectForKey:@"longitude"];
        //    params[@"latitude"] = [user objectForKey:@"latitude"];
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    }
    params[@"state"] = self.state;
    params[@"speak_type"] = self.speak_type;
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table6.hidden = NO;
        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data6 addObjectsFromArray:arr];
        //        [_datas replaceObjectAtIndex:1 withObject:_data2];
                for (NSDictionary *dic in arr) {
                    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                    [_goodData6 addObject:is_good];
                }
        //        [self table2];
        //        _reqErrorView2.hidden = YES;
        //        if (_data2.count == 0) {
        //            _noDataView2.hidden = NO;
        //            _headImageView2.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView2.hidden = YES;
        //            _headImageView2.userInteractionEnabled = YES;
        //        }
        [_table6.mj_header endRefreshing];
        [_table6.mj_footer endRefreshing];
        [self.table6 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table6.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView2.hidden = NO;
        _page6--;
        [_table6.mj_header endRefreshing];
        [_table6.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData7{
    NSLog(@"界面2");
    if (_page7 == 1) {
        [_data7 removeAllObjects];
        //        [_goodData2 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page7];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    if ([self.state isEqualToString:@"1"]) {
        //    params[@"longitude"] = [user objectForKey:@"longitude"];
        //    params[@"latitude"] = [user objectForKey:@"latitude"];
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    }
    params[@"state"] = self.state;
    params[@"speak_type"] = self.speak_type;
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table7.hidden = NO;
        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data7 addObjectsFromArray:arr];
        //        [_datas replaceObjectAtIndex:1 withObject:_data2];
                for (NSDictionary *dic in arr) {
                    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                    [_goodData7 addObject:is_good];
                }
        //        [self table2];
        //        _reqErrorView2.hidden = YES;
        //        if (_data2.count == 0) {
        //            _noDataView2.hidden = NO;
        //            _headImageView2.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView2.hidden = YES;
        //            _headImageView2.userInteractionEnabled = YES;
        //        }
        [_table7.mj_header endRefreshing];
        [_table7.mj_footer endRefreshing];
        [self.table7 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table7.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView2.hidden = NO;
        _page7--;
        [_table7.mj_header endRefreshing];
        [_table7.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData8{
    NSLog(@"界面2");
    if (_page8 == 1) {
        [_data8 removeAllObjects];
        //        [_goodData2 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page8];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    if ([self.state isEqualToString:@"1"]) {
        //    params[@"longitude"] = [user objectForKey:@"longitude"];
        //    params[@"latitude"] = [user objectForKey:@"latitude"];
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    }
    params[@"state"] = self.state;
    params[@"speak_type"] = self.speak_type;
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table8.hidden = NO;
        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data8 addObjectsFromArray:arr];
        //        [_datas replaceObjectAtIndex:1 withObject:_data2];
                for (NSDictionary *dic in arr) {
                    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                    [_goodData8 addObject:is_good];
                }
        //        [self table2];
        //        _reqErrorView2.hidden = YES;
        //        if (_data2.count == 0) {
        //            _noDataView2.hidden = NO;
        //            _headImageView2.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView2.hidden = YES;
        //            _headImageView2.userInteractionEnabled = YES;
        //        }
        [_table8.mj_header endRefreshing];
        [_table8.mj_footer endRefreshing];
        [self.table8 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table8.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView2.hidden = NO;
        _page8--;
        [_table8.mj_header endRefreshing];
        [_table8.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData9{
    NSLog(@"界面2");
    if (_page9 == 1) {
        [_data9 removeAllObjects];
        //        [_goodData2 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page9];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    if ([self.state isEqualToString:@"1"]) {
        //    params[@"longitude"] = [user objectForKey:@"longitude"];
        //    params[@"latitude"] = [user objectForKey:@"latitude"];
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    }
    params[@"state"] = self.state;
    params[@"speak_type"] = self.speak_type;
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table9.hidden = NO;
        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data9 addObjectsFromArray:arr];
        //        [_datas replaceObjectAtIndex:1 withObject:_data2];
                for (NSDictionary *dic in arr) {
                    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                    [_goodData9 addObject:is_good];
                }
        //        [self table2];
        //        _reqErrorView2.hidden = YES;
        //        if (_data2.count == 0) {
        //            _noDataView2.hidden = NO;
        //            _headImageView2.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView2.hidden = YES;
        //            _headImageView2.userInteractionEnabled = YES;
        //        }
        [_table9.mj_header endRefreshing];
        [_table9.mj_footer endRefreshing];
        [self.table9 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table9.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView2.hidden = NO;
        _page9--;
        [_table9.mj_header endRefreshing];
        [_table9.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData10{
    NSLog(@"界面2");
    if (_page10 == 1) {
        [_data10 removeAllObjects];
        //        [_goodData2 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page10];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    if ([self.state isEqualToString:@"1"]) {
        //    params[@"longitude"] = [user objectForKey:@"longitude"];
        //    params[@"latitude"] = [user objectForKey:@"latitude"];
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    }
    params[@"state"] = self.state;
    params[@"speak_type"] = self.speak_type;
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table10.hidden = NO;
        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data10 addObjectsFromArray:arr];
        //        [_datas replaceObjectAtIndex:1 withObject:_data2];
                for (NSDictionary *dic in arr) {
                    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                    [_goodData10 addObject:is_good];
                }
        //        [self table2];
        //        _reqErrorView2.hidden = YES;
        //        if (_data2.count == 0) {
        //            _noDataView2.hidden = NO;
        //            _headImageView2.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView2.hidden = YES;
        //            _headImageView2.userInteractionEnabled = YES;
        //        }
        [_table10.mj_header endRefreshing];
        [_table10.mj_footer endRefreshing];
        [self.table10 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table10.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView2.hidden = NO;
        _page10--;
        [_table10.mj_header endRefreshing];
        [_table10.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData11{
    NSLog(@"界面2");
    if (_page11 == 1) {
        [_data11 removeAllObjects];
        //        [_goodData2 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page11];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = page;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    if ([self.state isEqualToString:@"1"]) {
        //    params[@"longitude"] = [user objectForKey:@"longitude"];
        //    params[@"latitude"] = [user objectForKey:@"latitude"];
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    }
    params[@"state"] = self.state;
    params[@"speak_type"] = self.speak_type;
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table11.hidden = NO;
        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_data11 addObjectsFromArray:arr];
        //        [_datas replaceObjectAtIndex:1 withObject:_data2];
                for (NSDictionary *dic in arr) {
                    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                    [_goodData11 addObject:is_good];
                }
        //        [self table2];
        //        _reqErrorView2.hidden = YES;
        //        if (_data2.count == 0) {
        //            _noDataView2.hidden = NO;
        //            _headImageView2.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView2.hidden = YES;
        //            _headImageView2.userInteractionEnabled = YES;
        //        }
        [_table11.mj_header endRefreshing];
        [_table11.mj_footer endRefreshing];
        [self.table11 reloadData];
        if (arr.count == 0) {
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
            [_table11.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView2.hidden = NO;
        _page11--;
        [_table11.mj_header endRefreshing];
        [_table11.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}


#pragma mark tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSources[self.currentPage] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *data = _dataSources[self.currentPage];
    static NSString *cellId = @"cellId";
    WorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WorkTableViewCell alloc] init];
//        if (self.reqJobType == JobTypeDynamic) {
//            cell.cellType = CellLayoutTypeSpecial;
//        } else {
//            cell.cellType = CellLayoutTypeNormal;
//        }
        //            cell = [[WorkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWorkCellId];
        cell.type = WorkCellTypeNormal;
    }
    cell.isDetail = NO;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    if (data.count != 0) {
        NSDictionary *dicInfo = data[indexPath.row];
        [cell confineCellwithData:dicInfo];
        cell.dustbinBtn.tag = indexPath.row + 1;
        [cell.dustbinBtn addTarget:self action:@selector(dustbinClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.attentionBtn.tag = indexPath.row + 1;
        [cell.attentionBtn addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.functionBtn.appendIndexPath = indexPath;
        [cell.functionBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.iconBtn.appendIndexPath = indexPath;
        [cell.iconBtn addTarget:self action:@selector(checkPersonalHomePage:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
//        cell.nickName.appendIndexPath = indexPath;
        [cell.nickName addGestureRecognizer:tap];
        
        
    }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *data = _dataSources[self.currentPage];
    NSDictionary *dic;
    if (data.count>0) {
        dic = data[indexPath.row];
    }
    NSInteger count = [dic[@"imgCount"] integerValue];
    NSInteger videoCount = [dic[@"videoCount"] integerValue];
    
    NSString *description = dic[@"speak_comment_content"];
    //    NSArray *descrip1 = [description componentsSeparatedByString:@"#"];
    //    NSString *description1 = [descrip1 componentsJoinedByString:@"\""];
    NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
    NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
    NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
    
    NSString *speak_comment_state = dic[@"speak_comment_state"];
    NSString *lastDestription = [NSString stringWithFormat:@"#%@ %@",speak_comment_state,description3];
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    CGFloat descriptionLabelHeight;//内容的显示高度
    if ([dic[@"speak_comment_content"] length] == 0) {
        descriptionLabelHeight = 0;
    } else {
        descriptionLabelHeight = [self sizeWithString:lastDestription fontSize:FUCKFONT(14)].height;
        if (descriptionLabelHeight > normalSize.height *6) {
            descriptionLabelHeight = normalSize.height *6;
            self.isMore = YES;
        } else {
            self.isMore = NO;
            descriptionLabelHeight = descriptionLabelHeight;
        }
    }
    CGFloat photosHeight;//定义照片的高度
    CGFloat photoWidth;
    CGFloat videoWidth;
    if (SCREEN_WIDTH == 320) {
        photoWidth = 74;
        videoWidth = 140;
    } else if (SCREEN_WIDTH == 375) {
        photoWidth = 79;
        videoWidth = 164;
    } else {
        photoWidth = 86;
        videoWidth = 172;
    }
    if (videoCount == 1) {
        NSLog(@"controller 有视频");
        photosHeight = videoWidth;
    } else {
        if (count == 0) {
            photosHeight = 0;
        } else if (count >= 1 && count <= 3) {
            photosHeight = photoWidth;
        } else if (count >= 4 && count <= 6) {
            photosHeight = photoWidth*2 + 3;
        } else {
            photosHeight = photoWidth*3 + 6;
        }
    }
    
    CGFloat cellHeight;
    if ([dic[@"address"] length] == 0) {
        if ([dic[@"original_photos"] count] == 0) {
            if (self.isMore) {
                cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + kHEIGHT(25) + normalSize.height + 10 + 6;
            } else {
                cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + kHEIGHT(25) + 6;
            }
        } else {
            if ([dic[@"speak_comment_content"] length] == 0) {
                cellHeight = 10 + kHEIGHT(37) + 10 + photosHeight + 10 + kHEIGHT(25) + 6;
            } else {
                if (self.isMore) {
                    cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + photosHeight + 10 + kHEIGHT(25) + normalSize.height + 10 + 6;
                } else {
                    cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + photosHeight + 10 + kHEIGHT(25) + 6;
                }
            }
        }
    } else {
        if ([dic[@"original_photos"] count] == 0) {
            if (self.isMore) {
                cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + 15 + 10 + kHEIGHT(25) + normalSize.height + 10 + 6;
            } else {
                cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + 15 + 10 + kHEIGHT(25) + 6;
            }
        } else {
            if ([dic[@"speak_comment_content"] length] == 0) {
                cellHeight = 10 + kHEIGHT(37) + 10 + photosHeight + 10 + 15 + 10 + kHEIGHT(25) + 6;
            } else {
                if (self.isMore) {
                    cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + 10 + kHEIGHT(25) + normalSize.height + 10 + 6;
                } else {
                    cellHeight = 10 + kHEIGHT(37) + 10 + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + 10 + kHEIGHT(25) + 6;
                }
            }
        }
    }
    
    return cellHeight;
//    return 44;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_operationView dismiss];
    if (self.isEditeNow) {
        [self keyBoardDismiss];
    } else {
        WPJobDetailViewController *detail = [[WPJobDetailViewController alloc] init];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:_dataSources[self.currentPage][indexPath.row]];
        //    detail.userInfo = dic;
        detail.info = dic;
        detail.is_good = [_goodDatas[self.currentPage][indexPath.row] boolValue];
        [self.navigationController pushViewController:detail animated:YES];
    }

}

#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


#pragma mark - 进入个人主页

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
    PersonalHomepageController *personal = [[PersonalHomepageController alloc] init];
    personal.str = dic[@"nick_name"];
    NSLog(@"%@====%@",usersid,sid);
    if ([usersid isEqualToString:sid]) {
        personal.is_myself = YES;
//        personal.delegate = self;
    } else {
        personal.is_myself = NO;
    }
    personal.sid = sid;
    personal.speak_type = self.speak_type;
    [self.navigationController pushViewController:personal animated:YES];
}

- (void)delayWithObj:(WPNicknameLabel *)nickName
{
    nickName.backgroundColor = [UIColor whiteColor];
}

- (void)checkPersonalHomePage:(WPButton *)sender
{
    [self keyBoardDismiss];
    self.iconClickIndexPath = sender.appendIndexPath;
    //    NSLog(@"***%ld",self.iconClickIndexPath.row);
    NSDictionary *dic = _dataSources[self.currentPage][_iconClickIndexPath.row];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    NSString *sid = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
    PersonalHomepageController *personal = [[PersonalHomepageController alloc] init];
    personal.str = dic[@"nick_name"];
//    NSLog(@"%@====%@",usersid,sid);
    if ([usersid isEqualToString:sid]) {
        personal.is_myself = YES;
//        personal.delegate = self;
    } else {
        personal.is_myself = NO;
    }
    personal.sid = sid;
    personal.speak_type = self.speak_type;
    [self.navigationController pushViewController:personal animated:YES];
}

#pragma mark - 点赞和评论

- (void)replyAction:(WPButton *)sender
{
    //    self.chatInputView.textView.text = nil;
    //    self.chatInputView.hidden = YES;
    //    [self p_hideBottomComponent];
//    [self keyBoardDismiss];
    if (sender.isSelected == YES) {
        sender.selected = NO;
    } else {
        sender.selected = YES;
    }
    
//    UITableView *table;
//    NSMutableArray *goodData;
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
    //    else if (self.currentPage == 4) {
    //        table = _table5;
    //        goodData = _goodData5;
    //    } else if (self.currentPage == 5) {
    //        table = _table6;
    //        goodData = _goodData6;
    //    }
    UITableView *table = self.tableViews[self.currentPage];
    NSMutableArray *goodData = self.goodDatas[self.currentPage];
    CGRect rectInTableView = [table rectForRowAtIndexPath:sender.appendIndexPath];
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y + 2;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame) - 6, origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = sender.appendIndexPath;
    //    YMTextData *ym = [_tableDataSource objectAtIndex:_selectedIndexPath.row];
    BOOL isFavour;
    NSString *is_good = goodData[_selectedIndexPath.row];
//    NSLog(@"====%@",is_good);
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
        _operationView.rightType = WFRightButtonTypePraise;
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

- (void)addLike
{
    UITableView *table = self.tableViews[self.currentPage];
    NSMutableArray *goodData = self.goodDatas[self.currentPage];
    NSMutableArray *data = self.dataSources[self.currentPage];
//    if (self.currentPage == 0) {
//        table = _table1;
//        goodData = _goodData1;
//        data = _data1;
//    } else if (self.currentPage == 1) {
//        table = _table2;
//        goodData = _goodData2;
//        data = _data2;
//    } else if (self.currentPage == 2) {
//        table = _table3;
//        goodData = _goodData3;
//        data = _data3;
//    } else if (self.currentPage == 3) {
//        table = _table4;
//        goodData = _goodData4;
//        data = _data4;
//    }
    //    else if (self.currentPage == 4) {
    //        table = _table5;
    //        goodData = _goodData5;
    //        data = _data5;
    //    } else if (self.currentPage == 5) {
    //        table = _table6;
    //        goodData = _goodData6;
    //        data = _data6;
    //    }
    WorkTableViewCell *cell = (WorkTableViewCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
    cell.functionBtn.selected = NO;
    NSLog(@"%ld",(long)_selectedIndexPath.row);
    NSString *is_good = goodData[_selectedIndexPath.row];
//    NSLog(@"====%@",is_good);
//    __block NSInteger count = [cell.praiseLabel.text integerValue];
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data[_selectedIndexPath.row]];
    params[@"action"] = @"prise";
    params[@"speak_trends_id"] = dic[@"sid"];
    params[@"user_id"] = userInfo[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"user_id"] = @"108";
    //    params[@"nick_name"] = @"Jack";
    params[@"is_type"] = @"1";
    params[@"wp_speak_click_type"] = @"1";
    params[@"odd_domand_id"] = @"0";
    if ([is_good isEqualToString:@"0"]) {
        params[@"wp_speak_click_state"] = @"0";
    } else {
        params[@"wp_speak_click_state"] = @"1";
    }
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alert show];
        
        if ([is_good isEqualToString:@"0"]) {
            //            count ++;
            //            [dic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"speak_praise_count"];
            [goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"1"];
            //            [_datas[self.currentPage] replaceObjectAtIndex:_selectedIndexPath.row withObject:dic];
            
        } else {
            //            count --;
            //            [dic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"speak_praise_count"];
            [goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"0"];
            //            [_datas[self.currentPage] replaceObjectAtIndex:_selectedIndexPath.row withObject:dic];
        }
        //        cell.praiseLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
        //        [table reloadData];
        [self updateCommentAndPraiseCount];
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
}

- (void)replyMessage:(WPButton *)sender
{
    self.chatInputView.hidden = NO;
    self.isEditeNow = YES;
    [self.chatInputView.textView becomeFirstResponder];
}

//更新点赞和评论的数据
- (void)updateCommentAndPraiseCount
{
    UITableView *table = self.tableViews[self.currentPage];
//    if (self.currentPage == 0) {
//        table = _table1;
//    } else if (self.currentPage == 1) {
//        table = _table2;
//    } else if (self.currentPage == 2) {
//        table = _table3;
//    } else if (self.currentPage == 3) {
//        table = _table4;
//    }
    WorkTableViewCell *cell = (WorkTableViewCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getsum";
    params[@"speak_trends_id"] = _dataSources[self.currentPage][_selectedIndexPath.row][@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    NSLog(@"######%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"*****%@",json);
        if ([json[@"state"] integerValue] == 0) {
            cell.commentLabel.text = json[@"discuss"];
            cell.praiseLabel.text = json[@"click"];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error.description);
    }];
    
}


#pragma mark - 删除和关注

//删除
- (void)dustbinClick:(UIButton *)btn{
    //    self.chatInputView.textView.text = nil;
    //    self.chatInputView.hidden = YES;
    //    [self p_hideBottomComponent];
    [self keyBoardDismiss];
    WorkTableViewCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        cell = (WorkTableViewCell *)[[btn superview] superview];
    } else {
        cell = (WorkTableViewCell *)[[[btn superview] superview] superview];
    }
    NSDictionary *dic = [NSDictionary dictionary];
//    if (self.currentPage == 0) {
//        NSIndexPath * path = [self.table1 indexPathForCell:cell];
//        dic = self.data1[path.row];
//    } else if (self.currentPage == 1) {
//        NSIndexPath * path = [self.table2 indexPathForCell:cell];
//        dic = self.data2[path.row];
//    }else if (self.currentPage == 2) {
//        NSIndexPath * path = [self.table3 indexPathForCell:cell];
//        dic = self.data3[path.row];
//    }else if (self.currentPage == 3) {
//        NSIndexPath * path = [self.table4 indexPathForCell:cell];
//        dic = self.data4[path.row];
//    }else if (self.currentPage == 4) {
//        NSIndexPath * path = [self.table5 indexPathForCell:cell];
//        dic = self.data5[path.row];
//    }else if (self.currentPage == 5) {
//        NSIndexPath * path = [self.table6 indexPathForCell:cell];
//        dic = self.data6[path.row];
//    }
    NSIndexPath *path = [self.tableViews[self.currentPage] indexPathForCell:cell];
    dic = self.dataSources[self.currentPage][path.row];
    
    
    //    NSLog(@"####%@",url);
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"deleteDynamic";
    params[@"speakid"] = [NSString stringWithFormat:@"%@",dic[@"sid"]];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    
    NSInteger count = [dic[@"original_photos"] count];
    if (count > 0) {
        NSArray *arr = dic[@"original_photos"];
        NSMutableArray *adress = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            NSString *str = dic[@"media_address"];
            [adress addObject:str];
        }
        NSString *img_address = [adress componentsJoinedByString:@"|"];
        params[@"img_address"] = img_address;
        
    }
    
    self.deletParams = params;
    self.deletIndex = btn.tag - 1;
    
    //    NSLog(@"****%@",params);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该条说说吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
    
    //    [self.data1 removeObjectAtIndex:btn.tag - 1];
    //    [self.table1 reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    NSLog(@"%d",buttonIndex);
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            NSLog(@"取消");
        } else {
//            UITableView *table;
//            if (self.currentPage == 0) {
//                table = _table1;
//            } else if (self.currentPage == 1) {
//                table = _table2;
//            } else if (self.currentPage == 2) {
//                table = _table3;
//            } else if (self.currentPage == 3) {
//                table = _table4;
//            }
            NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
            [WPHttpTool postWithURL:url params:self.deletParams success:^(id json) {
                //                NSLog(@"%@---%@",json,json[@"info"]);
                if ([json[@"status"] integerValue] == 0) {
                    [MBProgressHUD showSuccess:@"删除成功"];
                    [self.dataSources[self.currentPage] removeObjectAtIndex:self.deletIndex];
                    [self.tableViews[self.currentPage] reloadData];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
                [MBProgressHUD showError:@"删除失败"];
            }];
            
        }
    }
}

//关注
- (void)attentionClick:(UIButton *)sender
{
    NSLog(@"关注");
    //    self.chatInputView.textView.text = nil;
    //    self.chatInputView.hidden = YES;
    //    [self p_hideBottomComponent];
    [self keyBoardDismiss];
    WorkTableViewCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        cell = (WorkTableViewCell *)[[sender superview] superview];
    } else {
        cell = (WorkTableViewCell *)[[[sender superview] superview] superview];
    }
    NSDictionary *dic = [NSDictionary dictionary];
//    UITableView *table;
//    if (self.currentPage == 0) {
//        NSIndexPath * path = [self.table1 indexPathForCell:cell];
//        dic = self.data1[path.row];
//        table = _table1;
//    } else if (self.currentPage == 1) {
//        NSIndexPath * path = [self.table2 indexPathForCell:cell];
//        dic = self.data2[path.row];
//        table = _table2;
//    }else if (self.currentPage == 2) {
//        NSIndexPath * path = [self.table3 indexPathForCell:cell];
//        dic = self.data3[path.row];
//        table = _table3;
//    }else if (self.currentPage == 3) {
//        NSIndexPath * path = [self.table4 indexPathForCell:cell];
//        dic = self.data4[path.row];
//        table = _table4;
//    }else if (self.currentPage == 4) {
//        NSIndexPath * path = [self.table5 indexPathForCell:cell];
//        dic = self.data5[path.row];
//        table = _table5;
//    }else if (self.currentPage == 5) {
//        NSIndexPath * path = [self.table6 indexPathForCell:cell];
//        dic = self.data6[path.row];
//        table = _table6;
//    }
    
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
    params[@"by_nick_name"] = dic[@"nick_name"];
    //    NSString *attention_state = [NSString stringWithFormat:@"%@",dic[@"attention_state"]];
    //    if ([attention_state isEqualToString:@"2"] || [attention_state isEqualToString:@"0"]) {
    //        params[@"attention_state"] = @"2";
    //    } else {
    //        params[@"attention_state"] = @"3";
    //    }
    
    NSLog(@"*****%@",url);
    NSLog(@"#####%@",params);
    
    NSString *nick_name = dic[@"user_id"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@===%@",json[@"info"],json);
        if ([json[@"status"] integerValue] == 1) {
            NSMutableArray *data = _dataSources[self.currentPage];
            for (int i=0; i<data.count; i++) {
                NSDictionary *dict = data[i];
                NSString *nick = dict[@"user_id"];
                NSString *attention = [NSString stringWithFormat:@"%@",dict[@"attention_state"]];
                if ([nick isEqualToString:nick_name]) {
                    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithDictionary:dict];
                    if ([attention isEqualToString:@"0"]) {
                        [newDic setObject:@"1" forKey:@"attention_state"];
                    } else if([attention isEqualToString:@"1"]){
                        [newDic setObject:@"0" forKey:@"attention_state"];
                    } else if ([attention isEqualToString:@"2"]) {
                        [newDic setObject:@"3" forKey:@"attention_state"];
                    } else if ([attention isEqualToString:@"3"]) {
                        [newDic setObject:@"2" forKey:@"attention_state"];
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


#pragma mark - 创建顶部菜单
-(void)makeContent
{
//    NSString *homepath =NSHomeDirectory();
//    NSString *path = [homepath stringByAppendingPathComponent:@"record.text"];
    
    NSString*documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
    NSString*newFielPath = [documentsPath stringByAppendingPathComponent:@"aa.txt"];
    
    NSMutableArray *listTop = [NSMutableArray arrayWithContentsOfFile:newFielPath];
    if (listTop == NULL) {
        NSLog(@"list is empty");
        listTop = [[NSMutableArray alloc] initWithArray:@[@"全部",@"人气",@"话题",@"职场正能量",@"职场吐槽",@"管理智慧",@"创业心得",@"职场心理学",@"情感心语",@"经营智慧",@"企业管理"]];
    }
    //    NSMutableArray *listTop = [[NSMutableArray alloc] initWithArray:@[@"职场说说",@"职场正能量",@"职场吐槽",@"管理智慧",@"创业心得",@"职场心理学",@"情感心语"]];
    _items = [[NSMutableArray alloc] initWithArray:listTop];
    _lastestItems = [[NSMutableArray alloc] initWithArray:listTop];
    __weak typeof(self) unself = self;
    //    _items = [NSArray array];
    if (!self.detailsList) {
        self.detailsList = [[BYDetailsList alloc] initWithFrame:CGRectMake(0, kListBarH-kScreenH, kScreenW, kScreenH-kListBarH)];
        self.detailsList.listAll = [NSMutableArray arrayWithObjects:listTop, nil];
        self.detailsList.longPressedBlock = ^(){
            [unself.deleteBar sortBtnClick:unself.deleteBar.sortBtn];
        };
        self.detailsList.opertionFromItemBlock = ^(animateType type, NSString *itemName, int index){
            unself.lastestItems = unself.detailsList.listAll[0];
//            for (NSString *str in unself.lastestItems) {
//                NSLog(@"^^^^^%@",str);
//            }
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
            NSLog(@"#####%@",unself.selectItem);
            NSLog(@"1111********%ld",(long)unself.currentPage);
//            [unself updateBottomBtn];
            [unself reloadDataWith:itemIndex style:itemName];
            [unself.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*itemIndex, 0) animated:YES];
            [unself.detailsList itemRespondFromListBarClickWithItemName:itemName];
        };
        [self.view addSubview:self.listBar];
    }
    
    
    //    UIButton *area = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,kArrowW, kListBarH)];
    //    [area setTitle:@"区域" forState:UIControlStateNormal];
    //    [area setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [area addTarget:self action:@selector(areaBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    area.backgroundColor = [UIColor whiteColor];
    //    area.titleLabel.font = [UIFont systemFontOfSize:13];
    //    [self.view addSubview:area];
    //    self.selectArea = area;
    
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
    NSString *newFielPath = [documentsPath stringByAppendingPathComponent:@"aa.txt"];
//    NSError *error =nil;
    BOOL isSucceed = [data writeToFile:newFielPath atomically:YES];
    if (isSucceed) {
        NSLog(@"write success");
    }
}

- (void)createUI
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kListBarH, SCREEN_WIDTH, SCREEN_HEIGHT - 107 - kListBarH)];
//    _scrollView.backgroundColor = RGB(235, 235, 235);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*11, SCREEN_HEIGHT - 107 - kListBarH);
    
    [self.view addSubview:_scrollView];
//    [self test];
//    for (int i = 0; i<11; i++) {
//        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 100, SCREEN_WIDTH, 25)];
//        title.text = [NSString stringWithFormat:@"第%d页",i + 1];
//        title.textAlignment = NSTextAlignmentCenter;
//        title.textColor = [UIColor blackColor];
//        title.font = [UIFont systemFontOfSize:20];
//        [_scrollView addSubview:title];
//    }
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
    //    self.chatInputView.textView.text = nil;
    //    self.chatInputView.hidden = YES;
    //    [self p_hideBottomComponent];
//    [self keyBoardDismiss];
    //    self.chatInputView = nil;
    //    if (self.isNeedDelloc > 0) {
    //        [self needDealloc];
    //        self.isNeedDelloc --;
    //    }
    
    [UIView animateWithDuration:0.3 animations:^{
        if (sender.tag == 4) {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , 40, (SCREEN_WIDTH - 2)/3 + 3, 3);
        } else {
            self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*(sender.tag - 1) , 40, SCREEN_WIDTH/4, 3);
        }
    }];
        //    [self.mainScrol setContentOffset:CGPointMake(SCREEN_WIDTH * (sender.tag - 1), 0) animated:YES];
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
        self.state = @"3";
        self.isBottomClick = YES;
    } else if (sender.tag == 3) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = YES;
        self.button4.selected = NO;
        self.state = @"2";
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
//    [self.dataSources[self.currentPage] removeAllObjects];
    [self reloadDataWith:self.currentPage style:self.selectItem];
    
}


- (void)upDateScroll
{
//    for (NSString *str in self.lastestItems) {
//        NSLog(@"******%@",str);
//    }
//    for (NSString *str in self.items) {
//        NSLog(@"#######%@",str);
//    }
//    NSLog(@"======%@",self.selectItem);
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
                for (NSMutableArray *data in self.dataSources) {
                    [data removeAllObjects];
                }
                for (UITableView *table in self.tableViews) {
                    [table reloadData];
                }
                [self reloadDataWith:self.currentPage style:self.selectItem];
                [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*i, 0) animated:YES];
            }
        }
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

- (void)reloadDataWith:(NSInteger)index style:(NSString *)speak_type
{
    
    NSLog(@"第%ld页====%@",index+1,speak_type);
    //如果当前已有数据，return
    
    if ([speak_type isEqualToString:@"全部"]) {
        self.speak_type = @"9";
    } else if ([speak_type isEqualToString:@"人气"]){
        self.speak_type = @"10";
    }else if ([speak_type isEqualToString:@"话题"]){
        self.speak_type = @"1";
    }else if ([speak_type isEqualToString:@"职场正能量"]){
        self.speak_type = @"3";
    }else if ([speak_type isEqualToString:@"职场吐槽"]){
        self.speak_type = @"4";
    }else if ([speak_type isEqualToString:@"职场心理学"]){
        self.speak_type = @"5";
    }else if ([speak_type isEqualToString:@"管理智慧"]){
        self.speak_type = @"6";
    }else if ([speak_type isEqualToString:@"创业心得"]){
        self.speak_type = @"7";
    }else if ([speak_type isEqualToString:@"情感心语"]){
        self.speak_type = @"8";
    }else if ([speak_type isEqualToString:@"经营智慧"]){
        self.speak_type = @"11";
    }else if ([speak_type isEqualToString:@"企业管理"]){
        self.speak_type = @"12";
    }
//    NSString *state = self.states[self.currentPage];
//    if (![state isEqualToString:self.state]) {
//        [self.dataSources[self.currentPage] removeAllObjects];
//        //        [self.tableViews[self.currentPage] reloadData];
//        [self.states replaceObjectAtIndex:self.currentPage withObject:self.state];
//    }
//    
//    NSMutableArray *data = _dataSources[index];
//    if (data.count>0) {
//        return;
//    }

    [self.tableViews[self.currentPage] setContentOffset:CGPointMake(0, 0) animated:NO];
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
//    if (index == 0) {
//        _page1 = 1;
//        [self createData1];
//    } else if (index == 1) {
//        _page2 = 1;
//        [self createData2];
//    } else if (index == 2) {
//        _page3 = 1;
//        [self createData3];
//    } else if (index == 3) {
//        _page4 = 1;
//        [self createData4];
//    } else if (index == 4) {
//        _page5 = 1;
//        [self createData5];
//    } else if (index == 5) {
//        _page6 = 1;
//        [self createData6];
//    } else if (index == 6) {
//        _page7 = 1;
//        [self createData7];
//    } else if (index == 7) {
//        _page8 = 1;
//        [self createData8];
//    } else if (index == 8) {
//        _page9 = 1;
//        [self createData9];
//    } else if (index == 9) {
//        _page10 = 1;
//        [self createData10];
//    } else if (index == 10) {
//        _page11 = 1;
//        [self createData11];
//    }
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
//    if (self.currentPage == 0) {
//        _page1 = 1;
////        [self createData1];
//    } else if (self.currentPage == 1) {
//        _page2 = 1;
////        [self createData2];
//    } else if (self.currentPage == 2) {
//        _page3 = 1;
////        [self createData3];
//    } else if (self.currentPage == 3) {
//        _page4 = 1;
////        [self createData4];
//    } else if (self.currentPage == 4) {
//        _page5 = 1;
////        [self createData5];
//    } else if (self.currentPage == 5) {
//        _page6 = 1;
////        [self createData6];
//    } else if (self.currentPage == 6) {
//        _page7 = 1;
////        [self createData7];
//    } else if (self.currentPage == 7) {
//        _page8 = 1;
////        [self createData8];
//    } else if (self.currentPage == 8) {
//        _page9 = 1;
////        [self createData9];
//    } else if (self.currentPage == 9) {
//        _page10 = 1;
////        [self createData10];
//    } else if (self.currentPage == 10) {
//        _page11 = 1;
////        [self createData11];
//    }

}

#pragma mark - scrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_operationView dismiss];
    [self keyBoardDismiss];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //    for (NSString *str in self.items) {
    //        NSLog(@"######%@",str[0]);
    //    }
    //    NSLog(@"#####%@---%@",self.items[0],self.items);
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    
    if ([scrollView isEqual:self.scrollView]) {
        int index = scrollView.contentOffset.x/SCREEN_WIDTH;
        self.currentPage = index;
//        NSLog(@"33333********%ld",(long)self.currentPage);
        //        [self.listBar operationFromBlock:topViewClick itemName:self.items[index] index:index];
        [self.listBar itemClick:self.listBar.btnLists[[self.listBar findIndexOfListsWithTitle:self.items[index]]]];
    }
    
}

#pragma mark - 关于键盘的输入以及语音

//- (void)commentWithInfo:(NSDictionary *)dic{
//    NSLog(@"我是谁");
//    [self chatInputView];
//    //    self.chatInputView.hidden = NO;
//    [self.chatInputView.textView becomeFirstResponder];
//}
- (void)keyBoardDismiss{
    self.chatInputView.textView.text = nil;
    self.chatInputView.hidden = YES;
    [self p_hideBottomComponent];
    self.isEditeNow = NO;
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
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(checkPersonalPage:)
    //                                                 name:@"dynamicJump"
    //                                               object:nil];
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
    __weak NewJobViewController* weakSelf = self;
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
    NSMutableArray *data = _dataSources[self.currentPage];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *dic = data[_selectedIndexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"replySpeak";
    params[@"speak_id"] = dic[@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = myDic[@"userid"];
    //    params[@"nick_name"] = myDic[@"nick_name"];
    params[@"by_nick_name"] = dic[@"nick_name"];
    params[@"speak_comment_content"] = self.chatInputView.textView.text;
    params[@"speak_reply"] = @"0";
    NSLog(@"****%@",params);
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"####%@",url);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        if ([json[@"status"] integerValue] == 1) {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
            //            [self updateCommentCount];
            [self updateCommentAndPraiseCount];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
    //    self.chatInputView.textView.text = nil;
    //    self.chatInputView.hidden = YES;
    //    [self p_hideBottomComponent];
    [self keyBoardDismiss];
    //    self.chatInputView = nil;
    //    if (self.isNeedDelloc > 0) {
    //        [self needDealloc];
    //        self.isNeedDelloc --;
    //    }
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
//    params[@"action"] = @"replySpeak";
//    params[@"speak_id"] = dic[@"sid"];
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = myDic[@"userid"];
//    //    params[@"nick_name"] = myDic[@"nick_name"];
//    params[@"by_nick_name"] = dic[@"nick_name"];
//    //    params[@"speak_comment_content"] = self.chatInputView.textView.text;
//    params[@"speak_reply"] = @"0";
//    NSData *audioData = [NSData dataWithContentsOfFile:file];
//    //    NSLog(@"****%@",params);
//    //    NSLog(@"===%@",audioData);
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    //    NSLog(@"####%@",url);
//    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
//    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manage POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:audioData name:@"speak_comment_content" fileName:@"speak_comment_content.mp3" mimeType:@"audio/mpeg3"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"*****%@",dict[@"info"]);
//        if ([dict[@"status"] integerValue] == 1) {
//            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:dict[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            //            [alert show];
//            //            [self updateCommentCount];
//            [self updateCommentAndPraiseCount];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error: %@",error);
//    }];
//    [self.chatInputView willBeginInput];
//    _chatInputView.hidden = YES;
//    self.isEditeNow = NO;
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
    NSMutableArray *data = _dataSources[self.currentPage];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *dic = data[_selectedIndexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"replySpeak";
    params[@"speak_id"] = dic[@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = myDic[@"userid"];
    //    params[@"nick_name"] = myDic[@"nick_name"];
    params[@"by_nick_name"] = dic[@"nick_name"];
    params[@"speak_comment_content"] = self.chatInputView.textView.text;
    params[@"speak_reply"] = @"0";
    NSLog(@"****%@",params);
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSLog(@"####%@",url);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        if ([json[@"status"] integerValue] == 1) {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
            //            [self updateCommentCount];
            [self updateCommentAndPraiseCount];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    //    self.chatInputView.textView.text = nil;
    //    self.chatInputView.hidden = YES;
    //    [self p_hideBottomComponent];
    [self keyBoardDismiss];
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

- (void)dealloc
{
    //注销观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"_inputViewY"];
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
