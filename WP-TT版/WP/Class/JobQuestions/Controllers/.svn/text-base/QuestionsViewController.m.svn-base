//
//  QuestionsViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/7/8.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "QuestionsViewController.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "QuestionCell.h"
#import "WFPopView.h"
#import "MJRefresh.h"
#import "AFHTTPRequestOperationManager.h"

#import "WriteViewController.h"
#import "WPDetailControllerThree.h"
#import "PersonalHomepageController.h"

@interface QuestionsViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic,strong) UIScrollView *mainScrol;
@property (nonatomic,strong) UIScrollView *bottomScroll;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;
@property (nonatomic,strong) UIButton *button4;
@property (nonatomic,strong) UIButton *button5;
@property (nonatomic,strong) UIButton *button6;
@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong) UITableView *table1;
@property (nonatomic,strong) UITableView *table2;
@property (nonatomic,strong) UITableView *table3;
@property (nonatomic,strong) UITableView *table4;
@property (nonatomic,strong) UITableView *table5;
@property (nonatomic,strong) UITableView *table6;

@property(nonatomic, strong) UISearchBar *searchBar1;
@property(nonatomic, strong) UISearchBar *searchBar2;
@property(nonatomic, strong) UISearchBar *searchBar3;
@property(nonatomic, strong) UISearchBar *searchBar4;
@property(nonatomic, strong) UISearchBar *searchBar5;
@property(nonatomic, strong) UISearchBar *searchBar6;

//@property (nonatomic,weak) MJRefreshFooterView *footer1;
//@property (nonatomic,weak) MJRefreshHeaderView *header1;
//@property (nonatomic,weak) MJRefreshFooterView *footer2;
//@property (nonatomic,weak) MJRefreshHeaderView *header2;
//@property (nonatomic,weak) MJRefreshFooterView *footer3;
//@property (nonatomic,weak) MJRefreshHeaderView *header3;
//@property (nonatomic,weak) MJRefreshFooterView *footer4;
//@property (nonatomic,weak) MJRefreshHeaderView *header4;
//@property (nonatomic,weak) MJRefreshFooterView *footer5;
//@property (nonatomic,weak) MJRefreshHeaderView *header5;
//@property (nonatomic,weak) MJRefreshFooterView *footer6;
//@property (nonatomic,weak) MJRefreshHeaderView *header6;

@property(nonatomic, strong) UISearchDisplayController *SearchDisplayController1;
@property(nonatomic, strong) UISearchDisplayController *SearchDisplayController2;
@property(nonatomic, strong) UISearchDisplayController *SearchDisplayController3;
@property(nonatomic, strong) UISearchDisplayController *SearchDisplayController4;
@property(nonatomic, strong) UISearchDisplayController *SearchDisplayController5;
@property(nonatomic, strong) UISearchDisplayController *SearchDisplayController6;

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableArray *dataSource1;
@property (nonatomic,strong) NSMutableArray *dataSource2;
@property (nonatomic,strong) NSMutableArray *dataSource3;
@property (nonatomic,strong) NSMutableArray *dataSource4;
@property (nonatomic,strong) NSMutableArray *dataSource5;
@property (nonatomic,strong) NSMutableArray *dataSource6;
@property (nonatomic,strong) NSMutableArray *dataSources;

@property (nonatomic,strong) NSMutableArray *commentData1;
@property (nonatomic,strong) NSMutableArray *commentData2;
@property (nonatomic,strong) NSMutableArray *commentData3;
@property (nonatomic,strong) NSMutableArray *commentData4;
@property (nonatomic,strong) NSMutableArray *commentData5;
@property (nonatomic,strong) NSMutableArray *commentData6;
@property (nonatomic,strong) NSMutableArray *commentDatas;

@property (nonatomic,strong) NSMutableArray *goodData1;
@property (nonatomic,strong) NSMutableArray *goodData2;
@property (nonatomic,strong) NSMutableArray *goodData3;
@property (nonatomic,strong) NSMutableArray *goodData4;
@property (nonatomic,strong) NSMutableArray *goodData5;
@property (nonatomic,strong) NSMutableArray *goodData6;
@property (nonatomic,strong) NSMutableArray *goodDatas;

@property (nonatomic,strong) NSMutableArray *result;      //搜索的结果
@property (nonatomic,assign) BOOL isSearch;               //是否显示搜索



@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *iconClickIndexPath; //头像点击的行数


@end

@implementation QuestionsViewController
{
    NSInteger _page1;
    NSInteger _page2;
    NSInteger _page3;
    NSInteger _page4;
    NSInteger _page5;
    NSInteger _page6;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
//    _page1 = 1;
//    _page2 = 1;
//    _page3 = 1;
//    _page4 = 1;
//    _page5 = 1;
//    _page6 = 1;
//    
//    self.dataSource1 = [NSMutableArray array];
//    self.dataSource2 = [NSMutableArray array];
//    self.dataSource3 = [NSMutableArray array];
//    self.dataSource4 = [NSMutableArray array];
//    self.dataSource5 = [NSMutableArray array];
//    self.dataSource6 = [NSMutableArray array];
//    
//    //所有的数据
//    self.dataSources = [[NSMutableArray alloc] initWithObjects:_dataSource1,_dataSource2,_dataSource3,_dataSource4,_dataSource5,_dataSource6, nil];
//    
//    self.goodData1 = [NSMutableArray array];
//    self.goodData2 = [NSMutableArray array];
//    self.goodData3 = [NSMutableArray array];
//    self.goodData4 = [NSMutableArray array];
//    self.goodData5 = [NSMutableArray array];
//    self.goodData6 = [NSMutableArray array];
//    
//    self.goodDatas = [[NSMutableArray alloc] initWithObjects:_goodData1,_goodData2,_goodData3,_goodData4,_goodData5,_goodData6, nil];
//    
//    
//    self.commentData1 = [NSMutableArray array];
//    self.commentData2 = [NSMutableArray array];
//    self.commentData3 = [NSMutableArray array];
//    self.commentData4 = [NSMutableArray array];
//    self.commentData5 = [NSMutableArray array];
//    self.commentData6 = [NSMutableArray array];
//    
//    self.commentDatas = [[NSMutableArray alloc] initWithObjects:_commentData1,_commentData2,_commentData3,_commentData4,_commentData5,_commentData6, nil];
//    
//    self.result = [NSMutableArray array];
//    self.isSearch = NO;
//    
//    [self createNav];
//    [self createUI];
//    [self createBottom];
//    
//    [self createData1];
    
}

//- (void)createNav{
//    self.title = @"职场问答";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提问" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
//}
//
//- (void)rightBtnClick
//{
//    NSLog(@"提问");
//    WriteViewController *write = [[WriteViewController alloc] init];
//    write.type = WriteTypeQuestion;
//    write.myTitle = @"提问";
////    write.comment_type = @"2";
//    [self.navigationController pushViewController:write animated:YES];
//}
//
//- (UITableView *)table1
//{
//    if (_table1 == nil) {
//        _table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
//        self.table1.delegate = self;
//        self.table1.dataSource = self;
//        self.table1.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.searchBar1 = [[UISearchBar alloc] initWithFrame:CGRectZero];
//        self.searchBar1.tintColor = [UIColor lightGrayColor];
//        self.searchBar1.backgroundColor = WPColor(235, 235, 235);
//        self.searchBar1.barStyle     = UIBarStyleDefault;
//        self.searchBar1.translucent  = YES;
//        self.searchBar1.placeholder = @"搜索";
//        self.searchBar1.delegate = self;
//        
//        [self.searchBar1 sizeToFit];
//        self.SearchDisplayController1 = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar1 contentsController:self];
//        self.searchDisplayController.searchResultsDataSource = self;
//        self.searchDisplayController.searchResultsDelegate = self;
//        self.searchDisplayController.delegate = self;
//        
//        _table1.tableHeaderView = self.searchBar1;
//        [self.mainScrol addSubview:self.table1];
//        
////        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
////        header.scrollView = self.table1;
////        header.delegate = self;
////        
////        //        [header beginRefreshing];
////        self.header1 = header;
////        
////        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
////        footer.scrollView = self.table1;
////        footer.delegate = self;
////        self.footer1 = footer;
//    }
//    return _table1;
//}
//
//- (UITableView *)table2
//{
//    if (_table2 == nil) {
//        _table2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
//        self.table2.delegate = self;
//        self.table2.dataSource = self;
//        self.table2.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.searchBar2 = [[UISearchBar alloc] initWithFrame:CGRectZero];
//        self.searchBar2.placeholder = @"搜索";
//        self.searchBar2.tintColor = [UIColor lightGrayColor];
//        self.searchBar2.backgroundColor = WPColor(235, 235, 235);
//        self.searchBar2.delegate = self;
//        
//        [self.searchBar2 sizeToFit];
//        self.SearchDisplayController2 = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar2 contentsController:self];
//        self.searchDisplayController.searchResultsDataSource = self;
//        self.searchDisplayController.searchResultsDelegate = self;
//        self.searchDisplayController.delegate = self;
//        
//        _table2.tableHeaderView = self.searchBar2;
//        [self.mainScrol addSubview:self.table2];
//        
////        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
////        header.scrollView = self.table2;
////        header.delegate = self;
////        
////        //        [header beginRefreshing];
////        self.header2 = header;
////        
////        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
////        footer.scrollView = self.table2;
////        footer.delegate = self;
////        self.footer2 = footer;
//
//    }
//    return _table2;
//}
//
//- (UITableView *)table3
//{
//    if (_table3 == nil) {
//        _table3 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
//        self.table3.delegate = self;
//        self.table3.dataSource = self;
//        self.table3.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.searchBar3 = [[UISearchBar alloc] initWithFrame:CGRectZero];
//        self.searchBar3.tintColor = [UIColor lightGrayColor];
//        self.searchBar3.backgroundColor = WPColor(235, 235, 235);
//        self.searchBar3.placeholder = @"搜索";
//        self.searchBar3.delegate = self;
//        
//        [self.searchBar3 sizeToFit];
//        self.SearchDisplayController3 = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar3 contentsController:self];
//        self.searchDisplayController.searchResultsDataSource = self;
//        self.searchDisplayController.searchResultsDelegate = self;
//        self.searchDisplayController.delegate = self;
//        
//        _table3.tableHeaderView = self.searchBar3;
//        [self.mainScrol addSubview:self.table3];
//        
////        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
////        header.scrollView = self.table3;
////        header.delegate = self;
////        
////        //        [header beginRefreshing];
////        self.header3 = header;
////        
////        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
////        footer.scrollView = self.table3;
////        footer.delegate = self;
////        self.footer3 = footer;
//
//    }
//    return _table3;
//}
//
//- (UITableView *)table4
//{
//    if (_table4 == nil) {
//        _table4 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
//        self.table4.delegate = self;
//        self.table4.dataSource = self;
//        self.table4.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.searchBar4 = [[UISearchBar alloc] initWithFrame:CGRectZero];
//        self.searchBar4.placeholder = @"搜索";
//        self.searchBar4.tintColor = [UIColor lightGrayColor];
//        self.searchBar4.backgroundColor = WPColor(235, 235, 235);
//        self.searchBar4.delegate = self;
//        
//        [self.searchBar4 sizeToFit];
//        self.SearchDisplayController4 = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar4 contentsController:self];
//        self.searchDisplayController.searchResultsDataSource = self;
//        self.searchDisplayController.searchResultsDelegate = self;
//        self.searchDisplayController.delegate = self;
//        
//        _table4.tableHeaderView = self.searchBar4;
//        [self.mainScrol addSubview:self.table4];
//        
////        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
////        header.scrollView = self.table4;
////        header.delegate = self;
////        
////        //        [header beginRefreshing];
////        self.header4 = header;
////        
////        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
////        footer.scrollView = self.table4;
////        footer.delegate = self;
////        self.footer4 = footer;
//
//    }
//    return _table4;
//}
//
//- (UITableView *)table5
//{
//    if (_table5 == nil) {
//        _table5 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*4,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
//        self.table5.delegate = self;
//        self.table5.dataSource = self;
//        self.table5.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.searchBar5 = [[UISearchBar alloc] initWithFrame:CGRectZero];
//        self.searchBar5.placeholder = @"搜索";
//        self.searchBar5.tintColor = [UIColor lightGrayColor];
//        self.searchBar5.backgroundColor = WPColor(235, 235, 235);
//        self.searchBar5.delegate = self;
//        
//        [self.searchBar5 sizeToFit];
//        self.SearchDisplayController5 = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar5 contentsController:self];
//        self.searchDisplayController.searchResultsDataSource = self;
//        self.searchDisplayController.searchResultsDelegate = self;
//        self.searchDisplayController.delegate = self;
//        
//        _table5.tableHeaderView = self.searchBar5;
//        [self.mainScrol addSubview:self.table5];
//        
////        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
////        header.scrollView = self.table5;
////        header.delegate = self;
////        
////        //        [header beginRefreshing];
////        self.header5 = header;
////        
////        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
////        footer.scrollView = self.table5;
////        footer.delegate = self;
////        self.footer5 = footer;
//
//    }
//    return _table5;
//}
//
//- (UITableView *)table6
//{
//    if (_table6 == nil) {
//        _table6 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*5,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
//        self.table6.delegate = self;
//        self.table6.dataSource = self;
//        self.table6.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.searchBar6 = [[UISearchBar alloc] initWithFrame:CGRectZero];
//        self.searchBar6.placeholder = @"搜索";
//        self.searchBar6.tintColor = [UIColor lightGrayColor];
//        self.searchBar6.backgroundColor = WPColor(235, 235, 235);
//        self.searchBar6.delegate = self;
//        
//        [self.searchBar6 sizeToFit];
//        self.SearchDisplayController6 = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar6 contentsController:self];
//        self.searchDisplayController.searchResultsDataSource = self;
//        self.searchDisplayController.searchResultsDelegate = self;
//        self.searchDisplayController.delegate = self;
//        
//        _table6.tableHeaderView = self.searchBar6;
//        [self.mainScrol addSubview:self.table6];
//        
////        MJRefreshHeaderView *header = [MJRefreshHeaderView header];
////        header.scrollView = self.table6;
////        header.delegate = self;
////        
////        //        [header beginRefreshing];
////        self.header6 = header;
////        
////        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
////        footer.scrollView = self.table6;
////        footer.delegate = self;
////        self.footer6 = footer;
//
//    }
//    return _table6;
//}
//
////- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
////{
////    if (refreshView == self.header1) {
////        _page1 = 1;
////        [self createData1];
////    } else if (refreshView == self.footer1) {
////        _page1++;
////        [self createData1];
////    } else if (refreshView == self.header2) {
////        _page2 = 1;
////        [self createData2];
////    } else if (refreshView == self.footer2) {
////        _page2++;
////        [self createData2];
////    } else if (refreshView == self.header3) {
////        _page3 = 1;
////        [self createData3];
////    } else if (refreshView == self.footer3) {
////        _page3++;
////        [self createData3];
////    } else if (refreshView == self.header4) {
////        _page4 = 1;
////        [self createData4];
////    } else if (refreshView == self.footer4) {
////        _page4++;
////        [self createData4];
////    } else if (refreshView == self.header5) {
////        _page5 = 1;
////        [self createData5];
////    } else if (refreshView == self.footer5) {
////        _page5++;
////        [self createData5];
////    } else if (refreshView == self.header6) {
////        _page6 = 1;
////        [self createData6];
////    } else if (refreshView == self.footer6) {
////        _page6++;
////        [self createData6];
////    }
////    
////}
//
//- (void)searchDataWith:(NSString *)keyword
//{
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *userInfo = model.dic;
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    NSLog(@"*****%@",url);
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page1];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"select";
//    params[@"page"] = page;
//    params[@"strKey"] = keyword;
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = userInfo[@"userid"];
//    //    params[@"nick_name"] = userInfo[@"nick_name"];
//    params[@"longitude"] = [user objectForKey:@"longitude"];
//    params[@"latitude"] = [user objectForKey:@"latitude"];
//    params[@"state"] = @"1";
//    params[@"speak_type"] = @"2";
//    
//    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
//    //                          @"page" : page};
//    NSLog(@"<<<<<<>>>>>%@",params);
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"###%@",json);
//        NSArray *arr = json[@"list"];
//        [_result addObjectsFromArray:arr];
//        [self.SearchDisplayController1.searchResultsTableView reloadData];
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//
//    
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    NSLog(@"搜索");
//    self.isSearch = YES;
//    [self searchDataWith:searchBar.text];
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    self.isSearch = NO;
//    NSLog(@"取消");
//}
//
//- (void)createData1
//{
//    NSLog(@"界面1");
//    if (_page1 == 1) {
//        [_dataSource1 removeAllObjects];
//        [_goodData1 removeAllObjects];
//        [_commentData1 removeAllObjects];
//    }
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *userInfo = model.dic;
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    NSLog(@"*****%@",url);
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page1];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"getSpeakionList";
//    params[@"page"] = page;
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = userInfo[@"userid"];
//    //    params[@"nick_name"] = userInfo[@"nick_name"];
////    params[@"longitude"] = [user objectForKey:@"longitude"];
////    params[@"latitude"] = [user objectForKey:@"latitude"];
//    params[@"longitude"] = @"";
//    params[@"latitude"] = @"";
//    params[@"state"] = @"1";
//    params[@"speak_type"] = @"2";
//    
//    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
//    //                          @"page" : page};
//    NSLog(@"<<<<<<>>>>>%@",params);
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        _table1.hidden = NO;
//        NSLog(@"###%@",json);
//        NSArray *arr = json[@"list"];
//        [_dataSource1 addObjectsFromArray:arr];
//        for (NSDictionary *dic in arr) {
//            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
//            [_goodData1 addObject:is_good];
////            NSString *comment = dic[@"speak_comment_content"];
////            [_commentData1 addObject:comment];
//        }
//        [_dataSources replaceObjectAtIndex:0 withObject:_dataSource1];
//        [self table1];
////        _reqErrorView1.hidden = YES;
////        //        [_reqErrorView1 removeFromSuperview];
////        if (_data1.count == 0) {
////            _noDataView1.hidden = NO;
////            _headImageView1.userInteractionEnabled = NO;
////        } else {
////            _noDataView1.hidden = YES;
////            _headImageView1.userInteractionEnabled = YES;
////        }
////        [self.header1 endRefreshing];
////        [self.footer1 endRefreshing];
//        [self.table1 reloadData];
//        if (arr.count == 0) {
//            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
//        }
//    } failure:^(NSError *error) {
////        _reqErrorView1.hidden = NO;
////        [self.header1 endRefreshing];
////        [self.footer1 endRefreshing];
//        NSLog(@"%@",error);
//    }];
//
//}
//
//- (void)createData2{
//    NSLog(@"界面2");
//    if (_page2 == 1) {
//        [_dataSource2 removeAllObjects];
//        [_goodData2 removeAllObjects];
//        [_commentData2 removeAllObjects];
//    }
//    WPShareModel *model = [WPShareModel sharedModel];
//    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *userInfo = model.dic;
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    NSLog(@"*****%@",url);
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page2];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"getSpeakionList";
//    params[@"page"] = page;
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = userInfo[@"userid"];
//    //    params[@"nick_name"] = userInfo[@"nick_name"];
//    params[@"state"] = @"3";
//    params[@"speak_type"] = @"2";
//    NSLog(@"<<<<<<>>>>>%@",params);
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        _table2.hidden = NO;
//        NSLog(@"###%@",json);
//        NSArray *arr = json[@"list"];
//        [_dataSource2 addObjectsFromArray:arr];
//        for (NSDictionary *dic in arr) {
//            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
//            [_goodData2 addObject:is_good];
////            NSString *comment = dic[@"speak_comment_content"];
////            [_commentData2 addObject:comment];
//        }
//        [_dataSources replaceObjectAtIndex:1 withObject:_dataSource2];
//        [self table2];
////        _reqErrorView2.hidden = YES;
////        if (_data2.count == 0) {
////            _noDataView2.hidden = NO;
////            _headImageView2.userInteractionEnabled = NO;
////        } else {
////            _noDataView2.hidden = YES;
////            _headImageView2.userInteractionEnabled = YES;
////        }
////        [self.header2 endRefreshing];
////        [self.footer2 endRefreshing];
//        [self.table2 reloadData];
//        if (arr.count == 0) {
//            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
//        }
//    } failure:^(NSError *error) {
////        _reqErrorView2.hidden = NO;
////        [self.header2 endRefreshing];
////        [self.footer2 endRefreshing];
//        NSLog(@"%@",error);
//    }];
//    
//}
//
//- (void)createData3{
//    NSLog(@"界面3");
//    if (_page3 == 1) {
//        [_dataSource3 removeAllObjects];
//        [_goodData3 removeAllObjects];
//        [_commentData3 removeAllObjects];
//    }
//    WPShareModel *model = [WPShareModel sharedModel];
//    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *userInfo = model.dic;
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    NSLog(@"*****%@",url);
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page3];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"getSpeakionList";
//    params[@"page"] = page;
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = userInfo[@"userid"];
//    //    params[@"nick_name"] = userInfo[@"nick_name"];
//    //    params[@"longitude"] = [user objectForKey:@"longitude"];
//    //    params[@"latitude"] = [user objectForKey:@"latitude"];
//    params[@"state"] = @"2";
//    params[@"speak_type"] = @"2";
//    NSLog(@"<<<<<<>>>>>%@",params);
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        //        NSLog(@"###%@",json);
//        _table3.hidden = NO;
//        NSArray *arr = json[@"list"];
//        [_dataSource3 addObjectsFromArray:arr];
//        for (NSDictionary *dic in arr) {
//            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
//            [_goodData3 addObject:is_good];
////            NSString *comment = dic[@"speak_comment_content"];
////            [_commentData3 addObject:comment];
//        }
//        [_dataSources replaceObjectAtIndex:2 withObject:_dataSource3];
//        [self table3];
////        _reqErrorView3.hidden = YES;
////        if (_data3.count == 0) {
////            _noDataView3.hidden = NO;
////            _headImageView3.userInteractionEnabled = NO;
////        } else {
////            _noDataView3.hidden = YES;
////            _headImageView3.userInteractionEnabled = YES;
////        }
////        [self.header3 endRefreshing];
////        [self.footer3 endRefreshing];
//        [self.table3 reloadData];
//        if (arr.count == 0) {
//            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
//        }
//    } failure:^(NSError *error) {
////        _reqErrorView3.hidden = NO;
////        [self.header3 endRefreshing];
////        [self.footer3 endRefreshing];
//        NSLog(@"%@",error);
//    }];
//    
//}
//
//- (void)createData4{
//    NSLog(@"界面4");
//    if (_page4 == 1) {
//        [_dataSource4 removeAllObjects];
//        [_goodData4 removeAllObjects];
//        [_commentData4 removeAllObjects];
//    }
//    WPShareModel *model = [WPShareModel sharedModel];
//    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *userInfo = model.dic;
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    NSLog(@"*****%@",url);
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page4];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"getSpeakionList";
//    params[@"page"] = page;
//    params[@"user_id"] = userInfo[@"userid"];
//    //    params[@"nick_name"] = userInfo[@"nick_name"];
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    //    params[@"longitude"] = [user objectForKey:@"longitude"];
//    //    params[@"latitude"] = [user objectForKey:@"latitude"];
//    params[@"state"] = @"5";
//    params[@"speak_type"] = @"2";
//    
//    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
//    //                          @"page" : page};
//    NSLog(@"<<<<<<>>>>>%@",params);
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        //        NSLog(@"###%@",json);
//        _table4.hidden = NO;
//        NSArray *arr = json[@"list"];
//        [_dataSource4 addObjectsFromArray:arr];
//        for (NSDictionary *dic in arr) {
//            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
//            [_goodData4 addObject:is_good];
////            NSString *comment = dic[@"speak_comment_content"];
////            [_commentData4 addObject:comment];
//        }
//        [_dataSources replaceObjectAtIndex:3 withObject:_dataSource4];
//        [self table4];
////        _reqErrorView4.hidden = YES;
////        if (_data4.count == 0) {
////            _noDataView4.hidden = NO;
////            _headImageView4.userInteractionEnabled = NO;
////        } else {
////            _noDataView4.hidden = YES;
////            _headImageView4.userInteractionEnabled = YES;
////        }
////        [self.header4 endRefreshing];
////        [self.footer4 endRefreshing];
//        [self.table4 reloadData];
//        if (arr.count == 0) {
//            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
//        }
//    } failure:^(NSError *error) {
////        _reqErrorView4.hidden = NO;
////        [self.header4 endRefreshing];
////        [self.footer4 endRefreshing];
//        NSLog(@"%@",error);
//    }];
//    
//}
//
//- (void)createData5{
//    NSLog(@"界面5");
//    if (_page5 == 1) {
//        [_dataSource5 removeAllObjects];
//        [_goodData5 removeAllObjects];
//        [_commentData5 removeAllObjects];
//    }
//    WPShareModel *model = [WPShareModel sharedModel];
//    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *userInfo = model.dic;
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    NSLog(@"*****%@",url);
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page5];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"getSpeakionList";
//    params[@"page"] = page;
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    
//    params[@"user_id"] = userInfo[@"userid"];
//    //    params[@"nick_name"] = userInfo[@"nick_name"];
//    //    params[@"longitude"] = [user objectForKey:@"longitude"];
//    //    params[@"latitude"] = [user objectForKey:@"latitude"];
//    params[@"state"] = @"6";
//    params[@"speak_type"] = @"2";
//    
//    NSLog(@"<<<<<<>>>>>%@",params);
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        //        NSLog(@"###%@",json);
//        _table5.hidden = NO;
//        NSArray *arr = json[@"list"];
//        [_dataSource5 addObjectsFromArray:arr];
//        for (NSDictionary *dic in arr) {
//            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
//            [_goodData5 addObject:is_good];
////            NSString *comment = dic[@"speak_comment_content"];
////            [_commentData5 addObject:comment];
//        }
//        [_dataSources replaceObjectAtIndex:4 withObject:_dataSource5];
//        [self table5];
////        _reqErrorView5.hidden = YES;
////        if (_data5.count == 0) {
////            _noDataView5.hidden = NO;
////            _headImageView5.userInteractionEnabled = NO;
////        } else {
////            _noDataView5.hidden = YES;
////            _headImageView5.userInteractionEnabled = YES;
////        }
////        [self.header5 endRefreshing];
////        [self.footer5 endRefreshing];
//        [self.table5 reloadData];
//        if (arr.count == 0) {
//            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
//        }
//    } failure:^(NSError *error) {
////        _reqErrorView5.hidden = NO;
////        [self.header5 endRefreshing];
////        [self.footer5 endRefreshing];
//        NSLog(@"%@",error);
//    }];
//    
//}
//
//- (void)createData6{
//    NSLog(@"界面6");
//    if (_page6 == 1) {
//        [_dataSource6 removeAllObjects];
//        [_goodData6 removeAllObjects];
//        [_commentData6 removeAllObjects];
//    }
//    WPShareModel *model = [WPShareModel sharedModel];
//    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *userInfo = model.dic;
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    NSLog(@"*****%@",url);
//    NSString *page = [NSString stringWithFormat:@"%ld",(long)_page6];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"getSpeakionList";
//    params[@"page"] = page;
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = userInfo[@"userid"];
//    //    params[@"nick_name"] = userInfo[@"nick_name"];
//    //    params[@"longitude"] = [user objectForKey:@"longitude"];
//    //    params[@"latitude"] = [user objectForKey:@"latitude"];
//    params[@"state"] = @"4";
//    params[@"speak_type"] = @"2";
//    
//    //    NSDictionary *dic = @{@"action":@"getSpeakionList",
//    //                          @"page" : page};
//    NSLog(@"<<<<<<>>>>>%@",params);
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"###%@",json);
//        _table6.hidden = NO;
//        NSArray *arr = json[@"list"];
//        [_dataSource6 addObjectsFromArray:arr];
//        for (NSDictionary *dic in arr) {
//            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
//            [_goodData6 addObject:is_good];
////            NSString *comment = dic[@"speak_comment_content"];
////            [_commentData6 addObject:comment];
//        }
//        [_dataSources replaceObjectAtIndex:5 withObject:_dataSource6];
//        [self table6];
////        _reqErrorView6.hidden = YES;
////        if (_data6.count == 0) {
////            _headImageView6.userInteractionEnabled = NO;
////            _noDataView6.hidden = NO;
////        } else {
////            _headImageView6.userInteractionEnabled = YES;
////            _noDataView6.hidden = YES;
////        }
////        [self.header6 endRefreshing];
////        [self.footer6 endRefreshing];
//        [self.table6 reloadData];
//        if (arr.count == 0) {
//            //            [MBProgressHUD showSuccess:@"没有更多数据" toView:self.view];
//        }
//    } failure:^(NSError *error) {
////        _reqErrorView6.hidden = NO;
////        [self.header6 endRefreshing];
////        [self.footer6 endRefreshing];
//        NSLog(@"%@",error);
//    }];
//    
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    UITableView *table;
//    if (self.currentPage == 0) {
//        table = _table1;
//    } else if (self.currentPage == 1) {
//        table = _table2;
//    } else if (self.currentPage == 2) {
//        table = _table3;
//    } else if (self.currentPage == 3) {
//        table = _table4;
//    } else if (self.currentPage == 4) {
//        table = _table5;
//    } else if (self.currentPage == 5) {
//        table = _table6;
//    }
//
//    if (tableView != table) {
//        return _result.count;
//    } else {
//        return [_dataSources[self.currentPage] count];
//    }
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableView *table;
//    if (self.currentPage == 0) {
//        table = _table1;
//    } else if (self.currentPage == 1) {
//        table = _table2;
//    } else if (self.currentPage == 2) {
//        table = _table3;
//    } else if (self.currentPage == 3) {
//        table = _table4;
//    } else if (self.currentPage == 4) {
//        table = _table5;
//    } else if (self.currentPage == 5) {
//        table = _table6;
//    }
//    if (tableView != table) {
//        static NSString *cellId = @"QuestionCellID";
//        QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        if (!cell) {
//            cell = [[QuestionCell alloc] init];
//            cell.type = QuestionCellTypeNormal;
//            //            cell = [[WorkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWorkCellId];
//        }
////        NSMutableArray *data = _dataSources[self.currentPage];
//        if (_result.count != 0) {
//            NSDictionary *dicInfo = _result[indexPath.row];
//            [cell confineCellwithData:dicInfo];
////            cell.dustbinBtn.tag = indexPath.row + 1;
////            [cell.dustbinBtn addTarget:self action:@selector(dustbinClick:) forControlEvents:UIControlEventTouchUpInside];
////            cell.attentionBtn.tag = indexPath.row + 1;
////            [cell.attentionBtn addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
////            cell.functionBtn.appendIndexPath = indexPath;
////            [cell.functionBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
////            cell.iconBtn.appendIndexPath = indexPath;
////            [cell.iconBtn addTarget:self action:@selector(checkPersonalHomePage:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        
//        cell.selectionStyle = UITableViewCellAccessoryNone;
//        return cell;
//    } else {
//        static NSString *cellId = @"QuestionCell";
//        QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        if (!cell) {
//            cell = [[QuestionCell alloc] init];
//            cell.type = QuestionCellTypeNormal;
//            //            cell = [[WorkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWorkCellId];
//        }
//        NSMutableArray *data = _dataSources[self.currentPage];
//        if (data.count != 0) {
//            NSDictionary *dicInfo = data[indexPath.row];
//            [cell confineCellwithData:dicInfo];
//            cell.dustbinBtn.tag = indexPath.row + 1;
//            [cell.dustbinBtn addTarget:self action:@selector(dustbinClick:) forControlEvents:UIControlEventTouchUpInside];
//            cell.attentionBtn.tag = indexPath.row + 1;
//            [cell.attentionBtn addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
//            cell.functionBtn.appendIndexPath = indexPath;
//            [cell.functionBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
//            cell.iconBtn.appendIndexPath = indexPath;
//            [cell.iconBtn addTarget:self action:@selector(checkPersonalHomePage:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        
//        cell.selectionStyle = UITableViewCellAccessoryNone;
//        return cell;
//
//    }
//}
//
//- (void)checkPersonalHomePage:(WPButton *)sender
//{
//    self.iconClickIndexPath = sender.appendIndexPath;
//    NSDictionary *dic = _dataSources[self.currentPage][_iconClickIndexPath.row];
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *userInfo = model.dic;
//    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
//    NSString *sid = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
//    PersonalHomepageController *personal = [[PersonalHomepageController alloc] init];
//    personal.str = dic[@"nick_name"];
//    NSLog(@"%@====%@",usersid,sid);
//    if ([usersid isEqualToString:sid]) {
//        personal.is_myself = YES;
////        personal.delegate = self;
//    } else {
//        personal.is_myself = NO;
//    }
//    personal.sid = sid;
//    [self.navigationController pushViewController:personal animated:YES];
//}
//
////垃圾桶点击事件
//- (void)dustbinClick:(UIButton *)btn{
//    QuestionCell *cell;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        cell = (QuestionCell *)[[btn superview] superview];
//    } else {
//        cell = (QuestionCell *)[[[btn superview] superview] superview];
//    }
//    NSDictionary *dic = [NSDictionary dictionary];
//    UITableView *tableView;
//    if (self.currentPage == 0) {
//        NSIndexPath * path = [self.table1 indexPathForCell:cell];
//        dic = self.dataSource1[path.row];
//        tableView = _table1;
//    } else if (self.currentPage == 1) {
//        NSIndexPath * path = [self.table2 indexPathForCell:cell];
//        dic = self.dataSource2[path.row];
//        tableView = _table2;
//    }else if (self.currentPage == 2) {
//        NSIndexPath * path = [self.table3 indexPathForCell:cell];
//        dic = self.dataSource3[path.row];
//        tableView = _table3;
//    }else if (self.currentPage == 3) {
//        NSIndexPath * path = [self.table4 indexPathForCell:cell];
//        dic = self.dataSource4[path.row];
//        tableView = _table4;
//    }else if (self.currentPage == 4) {
//        NSIndexPath * path = [self.table5 indexPathForCell:cell];
//        dic = self.dataSource5[path.row];
//        tableView = _table5;
//    }else if (self.currentPage == 5) {
//        NSIndexPath * path = [self.table6 indexPathForCell:cell];
//        dic = self.dataSource6[path.row];
//        tableView = _table6;
//    }
//    
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    NSLog(@"####%@",url);
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *userInfo = model.dic;
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"deleteDynamic";
//    params[@"speakid"] = [NSString stringWithFormat:@"%@",dic[@"sid"]];
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"user_id"] = userInfo[@"userid"];
//    //    params[@"nick_name"] = userInfo[@"nick_name"];
//    
//    NSInteger count = [dic[@"original_photos"] count];
//    if (count > 0) {
//        NSArray *arr = dic[@"original_photos"];
//        NSMutableArray *adress = [NSMutableArray array];
//        for (NSDictionary *dic in arr) {
//            NSString *str = dic[@"media_address"];
//            [adress addObject:str];
//        }
//        NSString *img_address = [adress componentsJoinedByString:@"|"];
//        params[@"img_address"] = img_address;
//        
//    }
//    
//    NSLog(@"****%@",params);
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@",json[@"info"]);
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//    
//    [_dataSources[self.currentPage] removeObjectAtIndex:btn.tag - 1];
//    [tableView reloadData];
//}
//

//- (void)attentionClick:(UIButton *)sender
//{
//    NSLog(@"关注");
//    QuestionCell *cell;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        cell = (QuestionCell *)[[sender superview] superview];
//    } else {
//        cell = (QuestionCell *)[[[sender superview] superview] superview];
//    }
//    NSDictionary *dic = [NSDictionary dictionary];
//    UITableView *table;
//    if (self.currentPage == 0) {
//        NSIndexPath * path = [self.table1 indexPathForCell:cell];
//        dic = self.dataSource1[path.row];
//        table = _table1;
//    } else if (self.currentPage == 1) {
//        NSIndexPath * path = [self.table2 indexPathForCell:cell];
//        dic = self.dataSource2[path.row];
//        table = _table2;
//    }else if (self.currentPage == 2) {
//        NSIndexPath * path = [self.table3 indexPathForCell:cell];
//        dic = self.dataSource3[path.row];
//        table = _table3;
//    }else if (self.currentPage == 3) {
//        NSIndexPath * path = [self.table4 indexPathForCell:cell];
//        dic = self.dataSource4[path.row];
//        table = _table4;
//    }else if (self.currentPage == 4) {
//        NSIndexPath * path = [self.table5 indexPathForCell:cell];
//        dic = self.dataSource5[path.row];
//        table = _table5;
//    }else if (self.currentPage == 5) {
//        NSIndexPath * path = [self.table6 indexPathForCell:cell];
//        dic = self.dataSource6[path.row];
//        table = _table6;
//    }
//    
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/attention.ashx"];
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *userInfo = model.dic;
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"attentionSigh";
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    
//    params[@"user_id"] = userInfo[@"userid"];
//    //    params[@"nick_name"] = userInfo[@"nick_name"];
//    params[@"by_user_id"] = dic[@"user_id"];
//    params[@"by_nick_name"] = dic[@"nick_name"];
//    //    NSString *attention_state = [NSString stringWithFormat:@"%@",dic[@"attention_state"]];
//    //    if ([attention_state isEqualToString:@"2"] || [attention_state isEqualToString:@"0"]) {
//    //        params[@"attention_state"] = @"2";
//    //    } else {
//    //        params[@"attention_state"] = @"3";
//    //    }
//    
//    NSLog(@"*****%@",url);
//    NSLog(@"#####%@",params);
//    
//    NSString *nick_name = dic[@"nick_name"];
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"json: %@===%@",json[@"info"],json);
//        if ([json[@"status"] integerValue] == 1) {
//            NSMutableArray *data = _dataSources[self.currentPage];
//            for (int i=0; i<data.count; i++) {
//                NSDictionary *dict = data[i];
//                NSString *nick = dict[@"nick_name"];
//                NSString *attention = [NSString stringWithFormat:@"%@",dict[@"attention_state"]];
//                if ([nick isEqualToString:nick_name]) {
//                    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithDictionary:dict];
//                    if ([attention isEqualToString:@"0"]) {
//                        [newDic setObject:@"1" forKey:@"attention_state"];
//                    } else if([attention isEqualToString:@"1"]){
//                        [newDic setObject:@"0" forKey:@"attention_state"];
//                    } else if ([attention isEqualToString:@"2"]) {
//                        [newDic setObject:@"3" forKey:@"attention_state"];
//                    } else if ([attention isEqualToString:@"3"]) {
//                        [newDic setObject:@"2" forKey:@"attention_state"];
//                    }
//                    [data replaceObjectAtIndex:i withObject:newDic];
//                }
//            }
//            [table reloadData];
//        }
//        
//    } failure:^(NSError *error) {
//        NSLog(@"error: %@",error);
//    }];
//    
//}
//
//- (void)replyAction:(WPButton *)sender
//{
////    self.chatInputView.textView.text = nil;
////    self.chatInputView.hidden = YES;
////    [self p_hideBottomComponent];
//    
//    if (sender.isSelected == YES) {
//        sender.selected = NO;
//    } else {
//        sender.selected = YES;
//    }
//    
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
//    } else if (self.currentPage == 4) {
//        table = _table5;
//        goodData = _goodData5;
//    } else if (self.currentPage == 5) {
//        table = _table6;
//        goodData = _goodData6;
//    }
//    CGRect rectInTableView = [table rectForRowAtIndexPath:sender.appendIndexPath];
//    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
//    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame) - 6, origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
//    if (self.operationView.shouldShowed) {
//        [self.operationView dismiss];
//        return;
//    }
//    _selectedIndexPath = sender.appendIndexPath;
//    BOOL isFavour;
//    NSString *is_good = goodData[_selectedIndexPath.row];
//    NSLog(@"====%@",is_good);
//    if ([is_good isEqualToString:@"0"]) {
//        isFavour = NO;
//    } else {
//        isFavour = YES;
//    }
//    [self.operationView showAtView:table rect:targetRect isFavour:isFavour];
//    
//}
//
//- (WFPopView *)operationView {
//    if (!_operationView) {
//        _operationView = [WFPopView initailzerWFOperationView];
//        _operationView.rightType = WFRightButtonTypeAnswer;
//        [_operationView updateImage];
//        __weak __typeof(self)weakSelf = self;
//        _operationView.didSelectedOperationCompletion = ^(WFOperationType operationType) {
//            switch (operationType) {
//                case WFOperationTypeLike:
//                    [weakSelf addLike];
//                    break;
//                case WFOperationTypeReply:
//                    [weakSelf replyMessage: nil];
//                    break;
//                default:
//                    break;
//            }
//        };
//    }
//    return _operationView;
//}
//
//- (void)addLike
//{
//    UITableView *table;
//    NSMutableArray *goodData;
//    NSMutableArray *data = _dataSources[self.currentPage];
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
//    } else if (self.currentPage == 4) {
//        table = _table5;
//        goodData = _goodData5;
//    } else if (self.currentPage == 5) {
//        table = _table6;
//        goodData = _goodData6;
//    }
//   QuestionCell *cell = (QuestionCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
//    cell.functionBtn.selected = NO;
//    NSLog(@"%ld",(long)_selectedIndexPath.row);
//    NSString *is_good = goodData[_selectedIndexPath.row];
//    NSLog(@"====%@",is_good);
//    __block NSInteger count = [cell.praiseLabel.text integerValue];
//    
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *userInfo = model.dic;
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data[_selectedIndexPath.row]];
//    params[@"action"] = @"prise";
//    params[@"speak_trends_id"] = dic[@"sid"];
//    params[@"user_id"] = userInfo[@"userid"];
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    //    params[@"nick_name"] = userInfo[@"nick_name"];
//    //    params[@"user_id"] = @"108";
//    //    params[@"nick_name"] = @"Jack";
//    params[@"is_type"] = @"1";
//    params[@"wp_speak_click_type"] = @"1";
//    params[@"odd_domand_id"] = @"0";
//    if ([is_good isEqualToString:@"0"]) {
//        params[@"wp_speak_click_state"] = @"0";
//    } else {
//        params[@"wp_speak_click_state"] = @"1";
//    }
//    
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"json: %@",json);
//        
//        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        //        [alert show];
//        
//        if ([is_good isEqualToString:@"0"]) {
//            count ++;
//            [dic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"speak_praise_count"];
//            [goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"1"];
//            [_dataSources[self.currentPage] replaceObjectAtIndex:_selectedIndexPath.row withObject:dic];
//            
//        } else {
//            count --;
//            [dic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"speak_praise_count"];
//            [goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"0"];
//            [_dataSources[self.currentPage] replaceObjectAtIndex:_selectedIndexPath.row withObject:dic];
//        }
//        cell.praiseLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
//        [table reloadData];
//    } failure:^(NSError *error) {
//        NSLog(@"error: %@",error);
//    }];
//
//}
//
//- (void)replyMessage:(WPButton *)sender
//{
//    WriteViewController *write = [[WriteViewController alloc] init];
//    write.type = WriteTypeAnswer;
//    write.myTitle = @"回答";
//    NSDictionary *dic = _dataSources[self.currentPage][_selectedIndexPath.row];
//    write.ask_id = dic[@"sid"];
//    [self.navigationController pushViewController:write animated:YES];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableView *table;
//    if (self.currentPage == 0) {
//        table = _table1;
//    } else if (self.currentPage == 1) {
//        table = _table2;
//    } else if (self.currentPage == 2) {
//        table = _table3;
//    } else if (self.currentPage == 3) {
//        table = _table4;
//    } else if (self.currentPage == 4) {
//        table = _table5;
//    } else if (self.currentPage == 5) {
//        table = _table6;
//    }
//    if (self.isSearch && tableView != table) {
//        NSMutableArray *data = _result;
//        NSDictionary *dic;
//        if (data.count>0) {
//            dic = data[indexPath.row];
//        }
//        NSInteger count = [dic[@"imgCount"] integerValue];
//        NSInteger videoCount = [dic[@"videoCount"] integerValue];
//        
//        CGFloat descriptionLabelHeight;//内容的显示高度
//        if ([dic[@"speak_comment_content"] length] == 0) {
//            descriptionLabelHeight = 0;
//        } else {
//            descriptionLabelHeight = [self sizeWithString:dic[@"speak_comment_content"] fontSize:14].height;
//            if (descriptionLabelHeight > 16.702 *6) {
//                descriptionLabelHeight = 16.702 *6;
//            } else {
//                descriptionLabelHeight = descriptionLabelHeight;
//            }
//        }
//        CGFloat photosHeight;//定义照片的高度
//        
//        if (videoCount == 1) {
//            NSLog(@"controller 有视频");
//            photosHeight = 76;
//        } else {
//            if (count == 0) {
//                photosHeight = 0;
//            } else if (count >= 1 && count <= 3) {
//                photosHeight = 76;
//            } else if (count >= 4 && count <= 6) {
//                photosHeight = 76*2 + 3;
//            } else {
//                photosHeight = 76*3 + 6;
//            }
//        }
//        
//        CGFloat cellHeight;
//        if ([dic[@"address"] length] == 0) {
//            if ([dic[@"original_photos"] count] == 0) {
//                cellHeight = descriptionLabelHeight + photosHeight  + 131 - 9 - 27 + 6;
//            } else {
//                cellHeight = descriptionLabelHeight + photosHeight  + 131 - 9 - 22 + 6 + 2;
//            }
//        } else {
//            cellHeight = descriptionLabelHeight + photosHeight  + 131 - 9 + 6;
//        }
//        
//        NSLog(@"******%f",cellHeight);
//        return cellHeight;
//    } else {  // 不是搜索的界面
//        NSMutableArray *data = _dataSources[self.currentPage];
//        NSDictionary *dic;
//        if (data.count>0) {
//            dic = data[indexPath.row];
//        }
//        NSInteger count = [dic[@"imgCount"] integerValue];
//        NSInteger videoCount = [dic[@"videoCount"] integerValue];
//        
//        CGFloat descriptionLabelHeight;//内容的显示高度
//        if ([dic[@"speak_comment_content"] length] == 0) {
//            descriptionLabelHeight = 0;
//        } else {
//            descriptionLabelHeight = [self sizeWithString:dic[@"speak_comment_content"] fontSize:14].height;
//            if (descriptionLabelHeight > 16.702 *6) {
//                descriptionLabelHeight = 16.702 *6;
//            } else {
//                descriptionLabelHeight = descriptionLabelHeight;
//            }
//        }
//        CGFloat photosHeight;//定义照片的高度
//        
//        if (videoCount == 1) {
//            NSLog(@"controller 有视频");
//            photosHeight = 76;
//        } else {
//            if (count == 0) {
//                photosHeight = 0;
//            } else if (count >= 1 && count <= 3) {
//                photosHeight = 76;
//            } else if (count >= 4 && count <= 6) {
//                photosHeight = 76*2 + 3;
//            } else {
//                photosHeight = 76*3 + 6;
//            }
//        }
//        
//        CGFloat cellHeight;
//        if ([dic[@"address"] length] == 0) {
//            if ([dic[@"original_photos"] count] == 0) {
//                cellHeight = descriptionLabelHeight + photosHeight  + 131 - 9 - 27 + 6;
//            } else {
//                cellHeight = descriptionLabelHeight + photosHeight  + 131 - 9 - 22 + 6 + 2;
//            }
//        } else {
//            cellHeight = descriptionLabelHeight + photosHeight  + 131 - 9 + 6;
//        }
//        
//        
//        return cellHeight;
//        NSLog(@"*****%f",cellHeight);
//
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.01;
//}
//
////点击cell跳转到详情
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [_operationView dismiss];
//    UITableView *table;
//    if (self.currentPage == 0) {
//        table = _table1;
//    } else if (self.currentPage == 1) {
//        table = _table2;
//    } else if (self.currentPage == 2) {
//        table = _table3;
//    } else if (self.currentPage == 3) {
//        table = _table4;
//    } else if (self.currentPage == 4) {
//        table = _table5;
//    } else if (self.currentPage == 5) {
//        table = _table6;
//    }
//    
//    QuestionCell *cell = (QuestionCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
//    cell.functionBtn.selected = NO;
//    
//    WPDetailControllerThree *detail = [[WPDetailControllerThree alloc] init];
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:_dataSources[self.currentPage][indexPath.row]];
//    detail.userInfo = dic;
//    detail.type = DetailTypeQuestion;
//    NSLog(@"*******%@",_goodDatas[self.currentPage][indexPath.row]);
//    detail.is_good = [_goodDatas[self.currentPage][indexPath.row] boolValue];
//    [self.navigationController pushViewController:detail animated:YES];
//
//}
//#pragma mark - 获取string的size
//- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
//{
//    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
//    
//    return size;
//}
//
//
//- (void)createUI
//{
//    self.mainScrol = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
//    self.mainScrol.contentSize = CGSizeMake(SCREEN_WIDTH*6, SCREEN_HEIGHT - 104);
//    self.mainScrol.pagingEnabled = YES;
//    self.mainScrol.delegate = self;
//    //    self.mainScrol.backgroundColor = [UIColor cyanColor];
//    self.mainScrol.showsHorizontalScrollIndicator = NO;
//    self.mainScrol.showsVerticalScrollIndicator = NO;
//    [self.view addSubview:self.mainScrol];
//    for (int i = 0; i<6; i++) {
//        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
//        view.image = [UIImage imageNamed:@"backgroundImage"];
//        view.contentMode = UIViewContentModeScaleAspectFill;
//        [self.mainScrol addSubview:view];
//    }
//    
//}
//
//- (void)createBottom
//{
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
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 104, SCREEN_WIDTH, 0.5)];
//    view.backgroundColor = RGBColor(178, 178, 178);
//    [self.view addSubview:view];
//    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 37, SCREEN_WIDTH/3, 3)];
//    self.line.backgroundColor = RGBColor(10, 110, 210);
//    [self.bottomScroll addSubview:self.line];
//    
//    CGFloat linwWidth = 0.5;
//    CGFloat btnWidth = (SCREEN_WIDTH - 2)/3;
//    NSArray *titles = @[@"附近",@"关注",@"好友",@"粉丝",@"推荐",@"我的"];
//    for (int i = 0; i<6; i++) {
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth*i, 0, btnWidth, 40)];
//        button.tag = i+1;
//        [button setTitle:titles[i] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitleColor:RGBColor(10, 110, 210) forState:UIControlStateSelected];
//        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.bottomScroll addSubview:button];
//        if (i != 5 && i != 2) {
//            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btnWidth*(i+1), 0, linwWidth, 40)];
//            line.backgroundColor = RGBColor(178, 178, 178);
//            [self.bottomScroll addSubview:line];
//        } else if (i == 2) {
//            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btnWidth*(i+1), 0, linwWidth, 40)];
//            line.backgroundColor = RGBColor(178, 178, 178);
//            [self.bottomScroll addSubview:line];
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
//        } else if (i == 4) {
//            self.button5 = button;
//        } else {
//            self.button6 = button;
//        }
//    }
//    
//}
//
//
//
////按钮点击事件
//- (void)btnClick:(UIButton *)sender
//{
////    self.chatInputView.textView.text = nil;
////    self.chatInputView.hidden = YES;
////    [self p_hideBottomComponent];
//    //    self.chatInputView = nil;
//    //    if (self.isNeedDelloc > 0) {
//    //        [self needDealloc];
//    //        self.isNeedDelloc --;
//    //    }
//    
//    self.currentPage = sender.tag - 1;
//    if (self.currentPage == 5) {
//        self.line.frame = CGRectMake((SCREEN_WIDTH - 2)/3*5 , 37, (SCREEN_WIDTH - 2)/3 + 7, 3);
//    } else {
//        self.line.frame = CGRectMake((SCREEN_WIDTH - 2)/3*(sender.tag - 1) , 37, (SCREEN_WIDTH - 2)/3, 3);
//    }
//    self.mainScrol.contentOffset = CGPointMake(SCREEN_WIDTH * (sender.tag - 1), 0);
//    if (sender.tag == 1) {
//        self.button1.selected = YES;
//        self.button2.selected = NO;
//        self.button3.selected = NO;
//        self.button4.selected = NO;
//        self.button5.selected = NO;
//        self.button6.selected = NO;
//        [self createData1];
//    } else if (sender.tag == 2) {
//        self.button1.selected = NO;
//        self.button2.selected = YES;
//        self.button3.selected = NO;
//        self.button4.selected = NO;
//        self.button5.selected = NO;
//        self.button6.selected = NO;
//        [self createData2];
//    } else if (sender.tag == 3) {
//        self.button1.selected = NO;
//        self.button2.selected = NO;
//        self.button3.selected = YES;
//        self.button4.selected = NO;
//        self.button5.selected = NO;
//        self.button6.selected = NO;
//        [self createData3];
//        
//    } else if (sender.tag == 4) {
//        self.button1.selected = NO;
//        self.button2.selected = NO;
//        self.button3.selected = NO;
//        self.button4.selected = YES;
//        self.button5.selected = NO;
//        self.button6.selected = NO;
//        [self createData4];
//        
//    } else if (sender.tag == 5) {
//        self.button1.selected = NO;
//        self.button2.selected = NO;
//        self.button3.selected = NO;
//        self.button4.selected = NO;
//        self.button5.selected = YES;
//        self.button6.selected = NO;
//        [self createData5];
//        
//    } else {
//        self.button1.selected = NO;
//        self.button2.selected = NO;
//        self.button3.selected = NO;
//        self.button4.selected = NO;
//        self.button5.selected = NO;
//        self.button6.selected = YES;
//        [self createData6];
//        
//    }
//}
//
//- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
//{
////    self.searchDataSources = [NSMutableArray array];
//}
//
//- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
//{
////    self.searchDataSources = nil;
//}
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
////    self.searchDataSources = [self.searchDataSources filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchString]];
//    
//    return YES;
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [_operationView dismiss];
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if ([scrollView isKindOfClass:[UITableView class]]) {
//        return;
//    }
//    
//    if ([scrollView isEqual:self.mainScrol]) {
//        NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
//        NSLog(@"*****%ld",(long)index);
//        [self btnClickWithIndex:index];
//    }
//    
//}
//
//- (void)btnClickWithIndex:(NSInteger)index
//{
//    self.currentPage = index;
//    if (index >2 && self.bottomScroll.contentOffset.x == 0) {
//        //        [self.bottomScroll scrollRectToVisible:CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT - 104, SCREEN_WIDTH, 40) animated:YES];
//        self.bottomScroll.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
//    }
//    
//    if (index <=2 && self.bottomScroll.contentOffset.x == SCREEN_WIDTH) {
//        self.bottomScroll.contentOffset = CGPointMake(0, 0);
//    }
//    
//    //    [UIView animateWithDuration:0.2 animations:^{
//    self.line.frame = CGRectMake((SCREEN_WIDTH - 2)/3*index , 37, (SCREEN_WIDTH - 2)/3, 3);
//    //    }];
//    
//    if (index == 0) {
//        self.button1.selected = YES;
//        self.button2.selected = NO;
//        self.button3.selected = NO;
//        self.button4.selected = NO;
//        self.button5.selected = NO;
//        self.button6.selected = NO;
//        [self createData1];
//    } else if (index == 1) {
//        self.button1.selected = NO;
//        self.button2.selected = YES;
//        self.button3.selected = NO;
//        self.button4.selected = NO;
//        self.button5.selected = NO;
//        self.button6.selected = NO;
//        [self createData2];
//        
//    } else if (index == 2) {
//        self.button1.selected = NO;
//        self.button2.selected = NO;
//        self.button3.selected = YES;
//        self.button4.selected = NO;
//        self.button5.selected = NO;
//        self.button6.selected = NO;
//        [self createData3];
//        
//    } else if (index == 3) {
//        self.button1.selected = NO;
//        self.button2.selected = NO;
//        self.button3.selected = NO;
//        self.button4.selected = YES;
//        self.button5.selected = NO;
//        self.button6.selected = NO;
//        [self createData4];
//        
//    } else if (index == 4) {
//        self.button1.selected = NO;
//        self.button2.selected = NO;
//        self.button3.selected = NO;
//        self.button4.selected = NO;
//        self.button5.selected = YES;
//        self.button6.selected = NO;
//        [self createData5];
//        
//    } else {
//        self.button1.selected = NO;
//        self.button2.selected = NO;
//        self.button3.selected = NO;
//        self.button4.selected = NO;
//        self.button5.selected = NO;
//        self.button6.selected = YES;
//        [self createData6];
//    }
//    
//}
//
//- (void)dealloc
//{
////    [self.header1 free];
////    [self.footer1 free];
////    [self.header2 free];
////    [self.footer2 free];
////    [self.header3 free];
////    [self.footer3 free];
////    [self.header4 free];
////    [self.footer4 free];
////    [self.header5 free];
////    [self.footer5 free];
////    [self.header6 free];
////    [self.footer6 free];
//    //注销观察者
////    [[NSNotificationCenter defaultCenter] removeObserver:self];
////    [self removeObserver:self forKeyPath:@"_inputViewY"];
//    
//}
//

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
