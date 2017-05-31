//
//  DemandViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/8/26.
//  Copyright (c) 2015年 WP. All rights reserved.
// 奇葩需求

#import "DemandViewController.h"
#import "CHTumblrMenuView.h"
#import "BYListBar.h"
#import "BYArrow.h"
#import "BYDetailsList.h"
#import "BYDeleteBar.h"
#import "BYScroller.h"
#import "AreaView.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "DemandCell.h"
#import "UISelectCity.h"
#import "MenuView.h"
#import "MJRefresh.h"
#import "WFPopView.h"
#import "MBProgressHUD+MJ.h"
#import "TouchDownGestureRecognizer.h"
#import "EmotionsModule.h"
#import "RecordingView.h"
#import "AFHTTPRequestOperationManager.h"

#import "RecruitmentViewController.h"
#import "ApplyViewController.h"
#import "MakeFriendViewController.h"
#import "UniversalViewController.h"
#import "FreerideViewController.h"
#import "DemandPersonalController.h"
#import "DemandDetailViewController.h"
#import "ListView.h"

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

@interface DemandViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UISelectDelegate>

@property (nonatomic,strong) UIScrollView *mainScrol;

@property (nonatomic,strong) BYListBar *listBar;

@property (nonatomic,strong) BYDeleteBar *deleteBar;

@property (nonatomic,strong) BYDetailsList *detailsList;

@property (nonatomic,strong) BYArrow *arrow;

@property (nonatomic,strong) AreaView *area;

@property (nonatomic,strong) UISelectCity *city;

@property (nonatomic,assign) BOOL isWhite;

@property (nonatomic,strong) UIScrollView *bottomScroll;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;
@property (nonatomic,strong) UIButton *button4;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,assign) NSInteger currentPage; //当前显示的是在第几页
@property (nonatomic,strong) NSString *demand_type; //当前的请求类型
@property (nonatomic,strong) UIButton *selectArea;
@property (nonatomic,strong) NSString *area_id;   //选择区域id

@property (nonatomic,strong) UITableView *table1;
@property (nonatomic,strong) UITableView *table2;
@property (nonatomic,strong) UITableView *table3;
@property (nonatomic,strong) UITableView *table4;

@property (nonatomic,strong) NSMutableArray *dataSource1;
@property (nonatomic,strong) NSMutableArray *dataSource2;
@property (nonatomic,strong) NSMutableArray *dataSource3;
@property (nonatomic,strong) NSMutableArray *dataSource4;
@property (nonatomic,strong) NSMutableArray *dataSources; //请求的数据源

@property (nonatomic,strong) NSMutableArray *goodData1;
@property (nonatomic,strong) NSMutableArray *goodData2;
@property (nonatomic,strong) NSMutableArray *goodData3;
@property (nonatomic,strong) NSMutableArray *goodData4;
@property (nonatomic,strong) NSMutableArray *goodDatas;   //是否已报名


//@property (nonatomic,weak) MJRefreshFooterView *footer1;
//@property (nonatomic,weak) MJRefreshHeaderView *header1;
//@property (nonatomic,weak) MJRefreshFooterView *footer2;
//@property (nonatomic,weak) MJRefreshHeaderView *header2;
//@property (nonatomic,weak) MJRefreshFooterView *footer3;
//@property (nonatomic,weak) MJRefreshHeaderView *header3;
//@property (nonatomic,weak) MJRefreshFooterView *footer4;
//@property (nonatomic,weak) MJRefreshHeaderView *header4;

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *iconClickIndexPath; //头像点击的行数

- (void)p_clickThRecordButton:(UIButton*)button;
- (void)p_record:(UIButton*)button;
- (void)p_willCancelRecord:(UIButton*)button;
- (void)p_cancelRecord:(UIButton*)button;
- (void)p_sendRecord:(UIButton*)button;
- (void)p_endCancelRecord:(UIButton*)button;

- (void)p_hideBottomComponent;
- (void)p_tapOnTableView:(UIGestureRecognizer*)sender;

@end

@implementation DemandViewController
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(238.0, 238.0, 238.0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _page1 = 1;
    _page2 = 1;
    _page3 = 1;
    _page4 = 1;
    self.isWhite = NO;
    self.demand_type = @"0";
    [self initDataSource];
    [self createData1];
    [self createBottom];
    [self createUI];
    [self makeContent];
    [self initNav];
    [self notificationCenter];
    [self initialInput];
    [self createNotification];
}

- (void)initDataSource
{
    _page1 = 1;
    _page2 = 1;
    _page3 = 1;
    _page4 = 1;
    self.dataSource1 = [NSMutableArray array];
    self.dataSource2 = [NSMutableArray array];
    self.dataSource3 = [NSMutableArray array];
    self.dataSource4 = [NSMutableArray array];
    
    //所有的数据
    self.dataSources = [[NSMutableArray alloc] initWithObjects:_dataSource1,_dataSource2,_dataSource3,_dataSource4, nil];
    
    self.goodData1 = [NSMutableArray array];
    self.goodData2 = [NSMutableArray array];
    self.goodData3 = [NSMutableArray array];
    self.goodData4 = [NSMutableArray array];
    
    //是否已报名
    self.goodDatas = [[NSMutableArray alloc] initWithObjects:_goodData1,_goodData2,_goodData3,_goodData4, nil];

}

- (void)createNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"fefresh" object:nil];
}

- (void)refresh
{
    NSMutableArray *data = _dataSources[_currentPage];
    [data removeAllObjects];
    if (_currentPage == 0) {
        _page1 = 1;
        [self createData1];
    } else if (_currentPage == 1) {
        _page2 = 1;
        [self createData2];
    } else if (_currentPage == 2) {
        _page3 = 1;
        [self createData3];
    } else if (_currentPage == 3) {
        _page4 = 1;
        [self createData4];
    }
}

- (UITableView *)table1
{
    if (_table1 == nil) {
        _table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104 - 81) style:UITableViewStyleGrouped];
        self.table1.delegate = self;
        self.table1.dataSource = self;
        self.table1.backgroundColor = RGBColor(235, 235, 235);
        [self.mainScrol addSubview:self.table1];
        [_table1 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if ([_table1 respondsToSelector:@selector(setSeparatorInset:)]){
            [_table1 setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_table1 respondsToSelector:@selector(setLayoutMargins:)]){
            [_table1 setLayoutMargins:UIEdgeInsetsZero];
        }
        __weak __typeof(self) weakSelf = self;
        _table1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page1 = 1;
            [weakSelf createData1];
        }];
        
        _table1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page1++;
            [weakSelf createData1];
        }];
//        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
//        header.scrollView = self.table1;
//        header.delegate = self;
//        
//        //        [header beginRefreshing];
//        self.header1 = header;
//        
//        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
//        footer.scrollView = self.table1;
//        footer.delegate = self;
//        self.footer1 = footer;
    }
    return _table1;
}

- (UITableView *)table2
{
    if (_table2 == nil) {
        _table2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT - 104 - 81) style:UITableViewStyleGrouped];
        self.table2.delegate = self;
        self.table2.dataSource = self;
        self.table2.backgroundColor = RGBColor(235, 235, 235);
        [self.mainScrol addSubview:self.table2];
        [_table2 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if ([_table2 respondsToSelector:@selector(setSeparatorInset:)]){
            [_table2 setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_table2 respondsToSelector:@selector(setLayoutMargins:)]){
            [_table2 setLayoutMargins:UIEdgeInsetsZero];
        }
        __weak __typeof(self) weakSelf = self;
        _table2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page2 = 1;
            [weakSelf createData2];
        }];
        
        _table2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page2++;
            [weakSelf createData2];
        }];

//        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
//        header.scrollView = self.table2;
//        header.delegate = self;
//        
//        //        [header beginRefreshing];
//        self.header2 = header;
//        
//        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
//        footer.scrollView = self.table2;
//        footer.delegate = self;
//        self.footer2 = footer;
        
    }
    return _table2;
}

- (UITableView *)table3
{
    if (_table3 == nil) {
        _table3 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2,0, SCREEN_WIDTH, SCREEN_HEIGHT - 104 - 81) style:UITableViewStyleGrouped];
        self.table3.delegate = self;
        self.table3.dataSource = self;
        self.table3.backgroundColor = RGBColor(235, 235, 235);
        [self.mainScrol addSubview:self.table3];
        
        [_table3 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if ([_table3 respondsToSelector:@selector(setSeparatorInset:)]){
            [_table3 setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_table3 respondsToSelector:@selector(setLayoutMargins:)]){
            [_table3 setLayoutMargins:UIEdgeInsetsZero];
        }
        
        __weak __typeof(self) weakSelf = self;
        _table3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page3 = 1;
            [weakSelf createData3];
        }];
        
        _table3.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page3++;
            [weakSelf createData3];
        }];

//        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
//        header.scrollView = self.table3;
//        header.delegate = self;
//        
//        //        [header beginRefreshing];
//        self.header3 = header;
//        
//        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
//        footer.scrollView = self.table3;
//        footer.delegate = self;
//        self.footer3 = footer;
        
    }
    return _table3;
}

- (UITableView *)table4
{
    if (_table4 == nil) {
        _table4 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3,0, SCREEN_WIDTH, SCREEN_HEIGHT - 104 - 81) style:UITableViewStyleGrouped];
        self.table4.delegate = self;
        self.table4.dataSource = self;
        self.table4.backgroundColor = RGBColor(235, 235, 235);
        [self.mainScrol addSubview:self.table4];
        
        [_table4 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if ([_table4 respondsToSelector:@selector(setSeparatorInset:)]){
            [_table4 setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_table4 respondsToSelector:@selector(setLayoutMargins:)]){
            [_table4 setLayoutMargins:UIEdgeInsetsZero];
        }
        __weak __typeof(self) weakSelf = self;
        _table4.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page4 = 1;
            [weakSelf createData4];
        }];
        
        _table4.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page4++;
            [weakSelf createData4];
        }];

//        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
//        header.scrollView = self.table4;
//        header.delegate = self;
//        
//        //        [header beginRefreshing];
//        self.header4 = header;
//        
//        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
//        footer.scrollView = self.table4;
//        footer.delegate = self;
//        self.footer4 = footer;
        
    }
    return _table4;
}

//- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    if (refreshView == self.header1) {
//        _page1 = 1;
//        [self createData1];
//    } else if (refreshView == self.footer1) {
//        _page1++;
//        [self createData1];
//    } else if (refreshView == self.header2) {
//        _page2 = 1;
//        [self createData2];
//    } else if (refreshView == self.footer2) {
//        _page2++;
//        [self createData2];
//    } else if (refreshView == self.header3) {
//        _page3 = 1;
//        [self createData3];
//    } else if (refreshView == self.footer3) {
//        _page3++;
//        [self createData3];
//    } else if (refreshView == self.header4) {
//        _page4 = 1;
//        [self createData4];
//    } else if (refreshView == self.footer4) {
//        _page4++;
//        [self createData4];
//    }
//}


#pragma mark-设置cell的分割线的偏移量
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)refreshDataWithRemandType:(NSString *)remand_type
{
    if ([remand_type isEqualToString:@"全部"]) {
        self.demand_type = @"0";
    } else if ([remand_type isEqualToString:@"急招聘"]) {
        self.demand_type = @"1";
    } else if ([remand_type isEqualToString:@"急求职"]) {
        self.demand_type = @"2";
    } else if ([remand_type isEqualToString:@"交友"]) {
        self.demand_type = @"3";
    } else if ([remand_type isEqualToString:@"请吃饭"]) {
        self.demand_type = @"4";
    } else if ([remand_type isEqualToString:@"看电影"]) {
        self.demand_type = @"5";
    } else if ([remand_type isEqualToString:@"唱歌"]) {
        self.demand_type = @"6";
    } else if ([remand_type isEqualToString:@"户外"]) {
        self.demand_type = @"7";
    } else if ([remand_type isEqualToString:@"顺风车"]) {
        self.demand_type = @"8";
    } else if ([remand_type isEqualToString:@"自定义"]) {
        self.demand_type = @"9";
    } else if ([remand_type isEqualToString:@"人气"]) {
        self.demand_type = @"10";
    }
    
    if (self.currentPage == 0) {
        _page1 = 1;
        [self createData1];
    } else if (self.currentPage == 1) {
        _page2 = 1;
        [self createData2];
    } else if (self.currentPage == 2) {
        _page3 = 1;
        [self createData3];
    } else if (self.currentPage == 3) {
        _page4 = 1;
        [self createData4];
    }
}

- (void)createData1
{
    NSLog(@"界面1");
    if (_page1 == 1) {
        [_dataSource1 removeAllObjects];
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
    params[@"domand_type"] = self.demand_type;
    params[@"style"] = @"1";
    
    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
    //                          @"page" : page};
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table1.hidden = NO;
//        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_dataSource1 addObjectsFromArray:arr];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"isEntry"]];
            [_goodData1 addObject:is_good];
            //            NSString *comment = dic[@"speak_comment_content"];
            //            [_commentData1 addObject:comment];
        }
//        [_dataSources replaceObjectAtIndex:0 withObject:_dataSource1];
        [self table1];
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

- (void)createData2{
    NSLog(@"界面2");
    if (_page2 == 1) {
        [_dataSource2 removeAllObjects];
        [_goodData2 removeAllObjects];
//        [_commentData2 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
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
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    params[@"area_id"] = @"0";
    params[@"domand_type"] = self.demand_type;
    params[@"style"] = @"2";
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        _table2.hidden = NO;
//        NSLog(@"###%@",json);
        NSArray *arr = json[@"list"];
        [_dataSource2 addObjectsFromArray:arr];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"isEntry"]];
            [_goodData2 addObject:is_good];
            //            NSString *comment = dic[@"speak_comment_content"];
            //            [_commentData2 addObject:comment];
        }
//        [_dataSources replaceObjectAtIndex:1 withObject:_dataSource2];
        [self table2];
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
            [_table2.mj_footer endRefreshingWithNoMoreData];
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView2.hidden = NO;
        [_table2.mj_header endRefreshing];
        [_table2.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData3{
    NSLog(@"界面3");
    if (_page3 == 1) {
        [_dataSource3 removeAllObjects];
        [_goodData3 removeAllObjects];
//        [_commentData3 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
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
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    params[@"area_id"] = @"0";
    params[@"domand_type"] = self.demand_type;
    params[@"style"] = @"3";
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        //        NSLog(@"###%@",json);
        _table3.hidden = NO;
        NSArray *arr = json[@"list"];
        [_dataSource3 addObjectsFromArray:arr];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"isEntry"]];
            [_goodData3 addObject:is_good];
            //            NSString *comment = dic[@"speak_comment_content"];
            //            [_commentData3 addObject:comment];
        }
//        [_dataSources replaceObjectAtIndex:2 withObject:_dataSource3];
        [self table3];
        //        _reqErrorView3.hidden = YES;
        //        if (_data3.count == 0) {
        //            _noDataView3.hidden = NO;
        //            _headImageView3.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView3.hidden = YES;
        //            _headImageView3.userInteractionEnabled = YES;
        //        }
        [_table3.mj_header endRefreshing];
        [_table3.mj_footer endRefreshing];
        [self.table3 reloadData];
        if (arr.count == 0) {
            [_table3.mj_footer endRefreshingWithNoMoreData];
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView3.hidden = NO;
        [_table3.mj_header endRefreshing];
        [_table3.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}

- (void)createData4{
    NSLog(@"界面4");
    if (_page4 == 1) {
        [_dataSource4 removeAllObjects];
        [_goodData4 removeAllObjects];
//        [_commentData4 removeAllObjects];
    }
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSLog(@"*****%@",url);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page4];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"Wonderful";
    params[@"page"] = page;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    params[@"area_id"] = @"0";
    params[@"domand_type"] = self.demand_type;
    params[@"style"] = @"4";
    
    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
    //                          @"page" : page};
    NSLog(@"<<<<<<>>>>>%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        //        NSLog(@"###%@",json);
        _table4.hidden = NO;
        NSArray *arr = json[@"list"];
        [_dataSource4 addObjectsFromArray:arr];
        for (NSDictionary *dic in arr) {
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"isEntry"]];
            [_goodData4 addObject:is_good];
            //            NSString *comment = dic[@"speak_comment_content"];
            //            [_commentData4 addObject:comment];
        }
//        [_dataSources replaceObjectAtIndex:3 withObject:_dataSource4];
        [self table4];
        //        _reqErrorView4.hidden = YES;
        //        if (_data4.count == 0) {
        //            _noDataView4.hidden = NO;
        //            _headImageView4.userInteractionEnabled = NO;
        //        } else {
        //            _noDataView4.hidden = YES;
        //            _headImageView4.userInteractionEnabled = YES;
        //        }
        [_table4.mj_header endRefreshing];
        [_table4.mj_footer endRefreshing];
        [self.table4 reloadData];
        if (arr.count == 0) {
            [_table4.mj_footer endRefreshingWithNoMoreData];
            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
        }
    } failure:^(NSError *error) {
        //        _reqErrorView4.hidden = NO;
        [_table4.mj_header endRefreshing];
        [_table4.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
    
}



-(void)makeContent
{
    
    NSArray *images = @[@"dynamic_all",@"dynamic_hot",@"recruitment",@"jobs",@"friends",@"eat",@"film",@"sing",@"outdoor",@"remand_car",@"custom"];
    NSArray *titles = @[@"全部",@"人气",@"急招聘",@"急求职",@"交友",@"请吃饭",@"看电影",@"唱歌",@"户外",@"顺风车",@"自定义"];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = RGB(178, 178, 178);
    [self.view addSubview:line1];

    ListView *list = [[ListView alloc] initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, 80)];
    list.titles = titles;
    list.images = images;
    [list makeContain];
    list.buttonClick = ^(NSInteger index,NSString *title){
        [self refreshDataWithRemandType:title];
    };
    [self.view addSubview:list];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 80.5, SCREEN_WIDTH, 0.5)];
    line2.backgroundColor = RGB(178, 178, 178);
    [self.view addSubview:line2];

    
//    NSMutableArray *listTop = [[NSMutableArray alloc] initWithArray:@[@"全部",@"招聘",@"求职",@"交友",@"吃饭",@"电影",@"唱歌",@"户外",@"顺风车"]];
//    __weak typeof(self) unself = self;
//    
//    if (!self.detailsList) {
//        self.detailsList = [[BYDetailsList alloc] initWithFrame:CGRectMake(0, kListBarH-kScreenH, kScreenW, kScreenH-kListBarH)];
//        self.detailsList.listAll = [NSMutableArray arrayWithObjects:listTop, nil];
//        self.detailsList.longPressedBlock = ^(){
//            [unself.deleteBar sortBtnClick:unself.deleteBar.sortBtn];
//        };
//        self.detailsList.opertionFromItemBlock = ^(animateType type, NSString *itemName, int index){
//            [unself.listBar operationFromBlock:type itemName:itemName index:index];
//        };
//        [self.view addSubview:self.detailsList];
//    }
//    if (!self.area) {
//        self.area = [[AreaView alloc] initWithFrame:CGRectMake(0, kListBarH-kScreenH, kScreenW, kScreenH)];
//        [self.view addSubview:self.area];
//    }
//
//    
//    if (!self.listBar) {
//        self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0,0, kScreenW - kArrowW, kListBarH)];
//        self.listBar.visibleItemList = listTop;
//        self.listBar.arrowChange = ^(){
//            
//            if (unself.arrow.arrowBtnClick) {
//                
//                unself.arrow.arrowBtnClick();
//            }
//        };
//        self.listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
////            NSLog(@"%@",itemName);
//            [unself cityDismiss];
//            [unself refreshDataWithRemandType:itemName];
//            [unself.detailsList itemRespondFromListBarClickWithItemName:itemName];
//        };
//        [self.view addSubview:self.listBar];
//    }
//    
//    
////    UIButton *area = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,kArrowW, kListBarH)];
////    [area setTitle:@"区域" forState:UIControlStateNormal];
////    [area setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////    [area addTarget:self action:@selector(areaBtnClick) forControlEvents:UIControlEventTouchUpInside];
////    area.backgroundColor = [UIColor whiteColor];
////    area.titleLabel.font = [UIFont systemFontOfSize:13];
////    [self.view addSubview:area];
////    self.selectArea = area;
//    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kListBarH, SCREEN_WIDTH, 0.5)];
//    line.backgroundColor = RGBColor(178, 178, 178);
//    [self.view addSubview:line];
//    
//    if (!self.deleteBar) {
//        self.deleteBar = [[BYDeleteBar alloc] initWithFrame:self.listBar.frame];
//        [self.view addSubview:self.deleteBar];
//    }
//    
//    
//    if (!self.arrow) {
//        
//        self.arrow = [[BYArrow alloc] initWithFrame:CGRectMake(kScreenW-kArrowW, 0, kArrowW, kListBarH)];
//        self.arrow.arrowBtnClick = ^(){
//            [self cityDismiss];
//            _isWhite = !_isWhite;
////            [area setBackgroundColor:_isWhite ? RGBColor(238.0, 238.0, 238.0):[UIColor whiteColor]];
////            [area setTitle:_isWhite ? @"":@"区域" forState:UIControlStateNormal];
//            [self.arrow setBackgroundColor:_isWhite ? RGBColor(238.0, 238.0, 238.0):[UIColor whiteColor]];
//            if (_isWhite) {
//                line.hidden = YES;
//            } else {
//                line.hidden = NO;
//            }
//            unself.deleteBar.hidden = !unself.deleteBar.hidden;
//            [UIView animateWithDuration:kAnimationTime animations:^{
//                CGAffineTransform rotation = unself.arrow.imageView.transform;
//                unself.arrow.imageView.transform = CGAffineTransformRotate(rotation,M_PI);
//                unself.detailsList.transform = (unself.detailsList.frame.origin.y<0)?CGAffineTransformMakeTranslation(0, kScreenH):CGAffineTransformMakeTranslation(0, -kScreenH);
//            }];
//        };
//        [self.view addSubview:self.arrow];
//    }
}

- (void)initNav
{
    self.title = @"奇葩需求";
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

#pragma mark 右按钮点击事件
- (void)rightBtnClick
{
    [_operationView dismiss];
//    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
//    MenuItem *menuItem = [[MenuItem alloc] initWithTitle:@"急招聘" iconName:@"recruitment" glowColor:[UIColor grayColor] index:0];
//    [items addObject:menuItem];
//    
//    menuItem = [[MenuItem alloc] initWithTitle:@"急求职" iconName:@"jobs" glowColor:[UIColor colorWithRed:0.000 green:0.840 blue:0.000 alpha:1.000] index:0];
//    [items addObject:menuItem];
//    menuItem = [[MenuItem alloc] initWithTitle:@"交友" iconName:@"friends" glowColor:[UIColor colorWithRed:0.000 green:0.840 blue:0.000 alpha:1.000] index:0];
//    [items addObject:menuItem];
//    menuItem = [[MenuItem alloc] initWithTitle:@"请吃饭" iconName:@"eat" glowColor:[UIColor colorWithRed:0.000 green:0.840 blue:0.000 alpha:1.000] index:0];
//    [items addObject:menuItem];
//    menuItem = [[MenuItem alloc] initWithTitle:@"看电影" iconName:@"film" glowColor:[UIColor colorWithRed:0.000 green:0.840 blue:0.000 alpha:1.000] index:0];
//    [items addObject:menuItem];
//    menuItem = [[MenuItem alloc] initWithTitle:@"唱歌" iconName:@"sing" glowColor:[UIColor colorWithRed:0.000 green:0.840 blue:0.000 alpha:1.000] index:0];
//    [items addObject:menuItem];
//    menuItem = [[MenuItem alloc] initWithTitle:@"户外" iconName:@"outdoor" glowColor:[UIColor colorWithRed:0.000 green:0.840 blue:0.000 alpha:1.000] index:0];
//    [items addObject:menuItem];
//    menuItem = [[MenuItem alloc] initWithTitle:@"顺风车" iconName:@"remand_car" glowColor:[UIColor colorWithRed:0.000 green:0.840 blue:0.000 alpha:1.000] index:0];
//    [items addObject:menuItem];
//    menuItem = [[MenuItem alloc] initWithTitle:@"自定义" iconName:@"custom" glowColor:[UIColor colorWithRed:0.000 green:0.840 blue:0.000 alpha:1.000] index:0];
//    [items addObject:menuItem];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    MenuView *centerButton = [[MenuView alloc] initWithFrame:window.bounds items:items];
//    centerButton.didSelectedItemCompletion = ^(MenuItem *selectedItem) {
//        NSLog(@"%lu",(unsigned long)selectedItem.index);
//        NSLog(@"%@",selectedItem.title);
//        if (selectedItem.index == 0 && [selectedItem.title isEqualToString:@"急招聘"]) {
//            RecruitmentViewController *recruite = [[RecruitmentViewController alloc] init];
//            [self.navigationController pushViewController:recruite animated:YES];
//        } else if (selectedItem.index == 1) {
//            ApplyViewController *apply = [[ApplyViewController alloc] init];
//            [self.navigationController pushViewController:apply animated:YES];
//        } else if (selectedItem.index == 2) {
//            MakeFriendViewController *make = [[MakeFriendViewController alloc] init];
//            [self.navigationController pushViewController:make animated:YES];
//        } else if (selectedItem.index == 3) {
//            UniversalViewController *universal = [[UniversalViewController alloc] init];
//            universal.type = PublishTypeEat;
//            [self.navigationController pushViewController:universal animated:YES];
//        } else if (selectedItem.index == 4) {
//            UniversalViewController *universal = [[UniversalViewController alloc] init];
//            universal.type = PublishTypeFilm;
//            [self.navigationController pushViewController:universal animated:YES];
//        } else if (selectedItem.index == 5) {
//            UniversalViewController *universal = [[UniversalViewController alloc] init];
//            universal.type = PublishTypeSing;
//            [self.navigationController pushViewController:universal animated:YES];
//        } else if (selectedItem.index == 6) {
//            UniversalViewController *universal = [[UniversalViewController alloc] init];
//            universal.type = PublishTypeOutdoor;
//            [self.navigationController pushViewController:universal animated:YES];
//        } else if (selectedItem.index == 7) {
//            FreerideViewController *freeride = [[FreerideViewController alloc] init];
//            [self.navigationController pushViewController:freeride animated:YES];
//        } else if (selectedItem.index == 8) {
//            UniversalViewController *universal = [[UniversalViewController alloc] init];
//            universal.type = PublishTypeCustom;
//            [self.navigationController pushViewController:universal animated:YES];
//        }
//    };
//    [centerButton showMenuAtView:window];

    RecruitmentViewController *recruite = [[RecruitmentViewController alloc] init];
    [self.navigationController pushViewController:recruite animated:YES];

//    [self cityDismiss];
//    CHTumblrMenuView* menuView = [[CHTumblrMenuView alloc] init];
//    [menuView addMenuItemWithTitle:@"急招聘"
//                           andIcon:[UIImage imageNamed:@"recruitment"]
//                  andSelectedBlock:^{
//                      RecruitmentViewController *recruite = [[RecruitmentViewController alloc] init];
//                      [self.navigationController pushViewController:recruite animated:YES];
//                  }];
//    [menuView addMenuItemWithTitle:@"急求职"
//                           andIcon:[UIImage imageNamed:@"jobs"]
//                  andSelectedBlock:^{
//                      ApplyViewController *apply = [[ApplyViewController alloc] init];
//                      [self.navigationController pushViewController:apply animated:YES];
//                  }];
//    [menuView addMenuItemWithTitle:@"交友"
//                           andIcon:[UIImage imageNamed:@"friends"]
//                  andSelectedBlock:^{
//                      MakeFriendViewController *make = [[MakeFriendViewController alloc] init];
//                      [self.navigationController pushViewController:make animated:YES];
//                  }];
//    [menuView addMenuItemWithTitle:@"请吃饭"
//                           andIcon:[UIImage imageNamed:@"eat"]
//                  andSelectedBlock:^{
//                      UniversalViewController *universal = [[UniversalViewController alloc] init];
//                      universal.type = PublishTypeEat;
//                      [self.navigationController pushViewController:universal animated:YES];
//                  }];
//    [menuView addMenuItemWithTitle:@"看电影"
//                           andIcon:[UIImage imageNamed:@"film"]
//                  andSelectedBlock:^{
//                      UniversalViewController *universal = [[UniversalViewController alloc] init];
//                      universal.type = PublishTypeFilm;
//                      [self.navigationController pushViewController:universal animated:YES];
//
//                  }];
//    [menuView addMenuItemWithTitle:@"唱歌"
//                           andIcon:[UIImage imageNamed:@"sing"]
//                  andSelectedBlock:^{
//                      UniversalViewController *universal = [[UniversalViewController alloc] init];
//                      universal.type = PublishTypeSing;
//                      [self.navigationController pushViewController:universal animated:YES];
//                  }];
//    
//    [menuView addMenuItemWithTitle:@"户外"
//                           andIcon:[UIImage imageNamed:@"outdoor"]
//                  andSelectedBlock:^{
//                      UniversalViewController *universal = [[UniversalViewController alloc] init];
//                      universal.type = PublishTypeOutdoor;
//                      [self.navigationController pushViewController:universal animated:YES];
//                  }];
//    
//    [menuView addMenuItemWithTitle:@"顺风车"
//                           andIcon:[UIImage imageNamed:@"remand_car"]
//                  andSelectedBlock:^{
//                      FreerideViewController *freeride = [[FreerideViewController alloc] init];
//                      [self.navigationController pushViewController:freeride animated:YES];
//                  }];
//    
//    [menuView addMenuItemWithTitle:@"自定义"
//                           andIcon:[UIImage imageNamed:@"custom"]
//                  andSelectedBlock:^{
//                      UniversalViewController *universal = [[UniversalViewController alloc] init];
//                      universal.type = PublishTypeCustom;
//                      [self.navigationController pushViewController:universal animated:YES];
//                  }];
//    
//    
//    [menuView show];
}

- (UISelectCity *)city
{
    if (_city == nil) {
        _city = [[UISelectCity alloc] initWithFrame:CGRectMake(0, kListBarH + 1, SCREEN_WIDTH, SCREEN_HEIGHT - 104 - kListBarH + 40)];
        _city.delegate = self;
        [self.view addSubview:_city];
    }
    return _city;
}

- (void)createUI
{
    self.mainScrol = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 81, SCREEN_WIDTH, SCREEN_HEIGHT - 104 - 81)];
    self.mainScrol.contentSize = CGSizeMake(SCREEN_WIDTH*4, SCREEN_HEIGHT - 104 - 81);
    self.mainScrol.pagingEnabled = YES;
    self.mainScrol.delegate = self;
    //    self.mainScrol.backgroundColor = [UIColor cyanColor];
    self.mainScrol.showsHorizontalScrollIndicator = NO;
    self.mainScrol.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainScrol];
    for (int i = 0; i<4; i++) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104 - kListBarH)];
        view.image = [UIImage imageNamed:@"backgroundImage"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        [self.mainScrol addSubview:view];
//        if (i == 0) {
//            view.backgroundColor = [UIColor redColor];
//        } else if (i == 1) {
//            view.backgroundColor = [UIColor orangeColor];
//        } else if (i == 2) {
//            view.backgroundColor = [UIColor yellowColor];
//        } else {
//            view.backgroundColor = [UIColor greenColor];
//        }
    }
    
}

- (void)areaBtnClick
{
    NSLog(@"区域");
//    __weak typeof(self) unself = self;
//    [UIView animateWithDuration:0.4 animations:^{
//        unself.area.transform = (unself.area.frame.origin.y<0)?CGAffineTransformMakeTranslation(0, kScreenH):CGAffineTransformMakeTranslation(0, -kScreenH);
//        
////        unself.area.frame = CGRectMake(0, kListBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kListBarH);
//    }];

    [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
}

- (void)UISelectDelegate:(IndustryModel *)model
{
    NSLog(@"%@",model.industryName);
    [self.selectArea setTitle:model.industryName forState:UIControlStateNormal];
    self.area_id = model.industryID;
    [self cityDismiss];
}

- (void)cityDismiss
{
    [_city remove];
    _city = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSources[self.currentPage] count];
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
    return cell;
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
    [self.navigationController pushViewController:personal animated:YES];
}

//垃圾桶点击事件
- (void)dustbinClick:(UIButton *)btn{
    DemandCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        cell = (DemandCell *)[[btn superview] superview];
    } else {
        cell = (DemandCell *)[[[btn superview] superview] superview];
    }
    NSDictionary *dic = [NSDictionary dictionary];
    UITableView *tableView;
    if (self.currentPage == 0) {
        NSIndexPath * path = [self.table1 indexPathForCell:cell];
        dic = self.dataSource1[path.row];
        tableView = _table1;
    } else if (self.currentPage == 1) {
        NSIndexPath * path = [self.table2 indexPathForCell:cell];
        dic = self.dataSource2[path.row];
        tableView = _table2;
    }else if (self.currentPage == 2) {
        NSIndexPath * path = [self.table3 indexPathForCell:cell];
        dic = self.dataSource3[path.row];
        tableView = _table3;
    }else if (self.currentPage == 3) {
        NSIndexPath * path = [self.table4 indexPathForCell:cell];
        dic = self.dataSource4[path.row];
        tableView = _table4;
    }
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/wonderful_demand.ashx"];
    NSLog(@"####%@",url);
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"DeleteWonderful";
    params[@"domandId"] = [NSString stringWithFormat:@"%@",dic[@"domandId"]];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    
    NSLog(@"****%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json[@"info"]);
        if ([json[@"status"] integerValue] == 0) {
            [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
            [_dataSources[self.currentPage] removeObjectAtIndex:btn.tag - 1];
            [tableView reloadData];
        } else {
            [MBProgressHUD showError:json[@"info"] toView:self.view];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


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
    UITableView *table;
    if (self.currentPage == 0) {
        NSIndexPath * path = [self.table1 indexPathForCell:cell];
        dic = self.dataSource1[path.row];
        table = _table1;
    } else if (self.currentPage == 1) {
        NSIndexPath * path = [self.table2 indexPathForCell:cell];
        dic = self.dataSource2[path.row];
        table = _table2;
    }else if (self.currentPage == 2) {
        NSIndexPath * path = [self.table3 indexPathForCell:cell];
        dic = self.dataSource3[path.row];
        table = _table3;
    }else if (self.currentPage == 3) {
        NSIndexPath * path = [self.table4 indexPathForCell:cell];
        dic = self.dataSource4[path.row];
        table = _table4;
    }
        
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
            [table reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
}

- (void)updateCommentCount{
    NSMutableArray *data = _dataSources[self.currentPage];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:data[_selectedIndexPath.row]];
    NSInteger count = [dic[@"commentCount"] integerValue];
    count++;
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"commentCount"];
    [data replaceObjectAtIndex:_selectedIndexPath.row withObject:dic];
    UITableView *table;
    if (self.currentPage == 0) {
        table = _table1;
    } else if (self.currentPage == 1) {
        table = _table2;
    } else if (self.currentPage == 2) {
        table = _table3;
    } else if (self.currentPage == 3) {
        table = _table4;
    }
    [table reloadData];
}

- (void)updateCommentCoutAndApplyCountWith:(NSString *)demandId
{
    UITableView *table;
    if (self.currentPage == 0) {
        table = _table1;
    } else if (self.currentPage == 1) {
        table = _table2;
    } else if (self.currentPage == 2) {
        table = _table3;
    } else if (self.currentPage == 3) {
        table = _table4;
    }
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
    
    UITableView *table;
    NSMutableArray *goodData;
    if (self.currentPage == 0) {
        table = _table1;
        goodData = _goodData1;
    } else if (self.currentPage == 1) {
        table = _table2;
        goodData = _goodData2;
    } else if (self.currentPage == 2) {
        table = _table3;
        goodData = _goodData3;
    } else if (self.currentPage == 3) {
        table = _table4;
        goodData = _goodData4;
    }
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


- (void)addLike
{
    UITableView *table;
    NSMutableArray *goodData;
    NSMutableArray *data = _dataSources[self.currentPage];
    if (self.currentPage == 0) {
        table = _table1;
        goodData = _goodData1;
    } else if (self.currentPage == 1) {
        table = _table2;
        goodData = _goodData2;
    } else if (self.currentPage == 2) {
        table = _table3;
        goodData = _goodData3;
    } else if (self.currentPage == 3) {
        table = _table4;
        goodData = _goodData4;
    }
    DemandCell *cell = (DemandCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
    cell.functionBtn.selected = NO;
    NSLog(@"%ld",(long)_selectedIndexPath.row);
    NSString *is_good = goodData[_selectedIndexPath.row];
    NSLog(@"====%@",is_good);
    //__block NSInteger count = [cell.praiseLabel.text integerValue];
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data[_selectedIndexPath.row]];
    params[@"action"] = @"ClickEntry";
    params[@"domandId"] = dic[@"domandId"];
    params[@"user_id"] = userInfo[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"user_id"] = @"108";
    //    params[@"nick_name"] = @"Jack";
//    params[@"is_type"] = @"1";
//    params[@"wp_speak_click_type"] = @"1";
//    params[@"odd_domand_id"] = @"0";
//    if ([is_good isEqualToString:@"0"]) {
//        params[@"wp_speak_click_state"] = @"0";
//    } else {
//        params[@"wp_speak_click_state"] = @"1";
//    }
    
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


- (void)replyMessage:(WPButton *)sender{
    self.chatInputView.hidden = NO;
    [self.chatInputView.textView becomeFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = @"测试高度:";
    CGSize normalSize = [str sizeWithFont:[UIFont systemFontOfSize:14]];
    CGSize addresSize = [str sizeWithFont:[UIFont systemFontOfSize:12]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)createBottom
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 107, SCREEN_WIDTH, 43)];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 104, SCREEN_WIDTH, 0.5)];
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
    //    self.chatInputView = nil;
    //    if (self.isNeedDelloc > 0) {
    //        [self needDealloc];
    //        self.isNeedDelloc --;
    //    }
    
    self.currentPage = sender.tag - 1;
    if (self.currentPage == 3) {
        self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , 40, (SCREEN_WIDTH - 2)/3 + 3, 3);
    } else {
    self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*(sender.tag - 1) , 40, SCREEN_WIDTH/4, 3);
    }
    self.mainScrol.contentOffset = CGPointMake(SCREEN_WIDTH * (sender.tag - 1), 0);
    if (sender.tag == 1) {
        self.button1.selected = YES;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = NO;
        [self createData1];
    } else if (sender.tag == 2) {
        self.button1.selected = NO;
        self.button2.selected = YES;
        self.button3.selected = NO;
        self.button4.selected = NO;
        [self createData2];
    } else if (sender.tag == 3) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = YES;
        self.button4.selected = NO;
        [self createData3];
        
    } else if (sender.tag == 4) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = YES;
        [self createData4];
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_operationView dismiss];
    [self keyBoadrDismiss];
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
    //    [UIView animateWithDuration:0.2 animations:^{
    if (self.currentPage == 3) {
        self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*3 , 40, (SCREEN_WIDTH - 2)/3 + 3, 3);
    } else {
        self.line.frame = CGRectMake((SCREEN_WIDTH - 3)/4*self.currentPage , 40, SCREEN_WIDTH/4, 3);
    }
    //    }];
    
    if (index == 0) {
        self.button1.selected = YES;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = NO;
        [self createData1];
    } else if (index == 1) {
        self.button1.selected = NO;
        self.button2.selected = YES;
        self.button3.selected = NO;
        self.button4.selected = NO;
        [self createData2];
        
    } else if (index == 2) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = YES;
        self.button4.selected = NO;
        [self createData3];
        
    } else if (index == 3) {
        self.button1.selected = NO;
        self.button2.selected = NO;
        self.button3.selected = NO;
        self.button4.selected = YES;
        [self createData4];
        
    }
    
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
    __weak DemandViewController* weakSelf = self;
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
////            [self updateCommentCount];
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
