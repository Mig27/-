    //
//  WPNearController.m
//  WP
//
//  Created by Asuna on 15/5/20.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPNearController.h"
#import "WPInterviewController.h"
#import "WPSearchBar.h"
#import "WPRecruitTCell.h"
#import "WPInterViewTCell.h"
#import "WPInterviewCell.h"
#import "WPRecruitCell.h"
#import "WPActionSheet.h"
#import "UISelectCity.h"
#import "WPInterviewModel.h"
#import "SPSelectView.h"
#import "MJRefresh.h"
#import "WPUserListModel.h"
#import "UITableView+EmptyData.h"
#import "UICollectionView+EmptyData.h"

#import "WPPeopleConnectionViewController.h"
#import "NearInterViewController.h"
#import "WPRecruitController.h"
#import "WPAllSearchController.h"
#import "FDActionSheet.h"
#import "WPRecruitApplyController.h"
#import "WPInterviewApplyController.h"
#import "YYShareManager.h"
#import "RecentPersonController.h"

@interface WPNearController () <UITextFieldDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITabBarDelegate, UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UISelectDelegate,WPInterviewControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSMutableArray *interviewArr;/**< 求职 */
//@property (nonatomic, strong) NSMutableArray *RecruiListArr;/**< 招聘 */

@property (nonatomic, strong) NSMutableArray *interviewArr1;/**< 求职 */
//@property (nonatomic, strong) NSMutableArray *RecruiListArr1;/**< 招聘 */

@property (nonatomic, strong) NSMutableArray *interviewArr2;/**< 求职 */
//@property (nonatomic, strong) NSMutableArray *RecruiListArr2;/**< 招聘 */

@property (nonatomic, strong) NSMutableArray *interviewArr3;/**< 求职 */
//@property (nonatomic, strong) NSMutableArray *RecruiListArr3;/**< 招聘 */

@property (nonatomic, strong) NSMutableArray *interviewArr4;/**< 求职 */
//@property (nonatomic, strong) NSMutableArray *RecruiListArr4;/**< 招聘 */

@property (nonatomic, strong) UITableView* tableView;/**< 列表显示 */
@property (nonatomic, strong) UICollectionView *collectionView;/**< 图片显示 */

@property (nonatomic, strong) UITableView* tableView1;/**< 列表显示 */
@property (nonatomic, strong) UICollectionView *collectionView1;/**< 图片显示 */

@property (nonatomic, strong) UITableView* tableView2;/**< 列表显示 */
@property (nonatomic, strong) UICollectionView *collectionView2;/**< 图片显示 */

@property (nonatomic, strong) UITableView* tableView3;/**< 列表显示 */
@property (nonatomic, strong) UICollectionView *collectionView3;/**< 图片显示 */

@property (nonatomic, strong) UITableView* tableView4;/**< 列表显示 */
@property (nonatomic, strong) UICollectionView *collectionView4;/**< 图片显示 */

@property (nonatomic, strong) UIView *searchView;

//@property (nonatomic, strong) UISearchDisplayController* mySearchDisplayController;/**< 搜索控制器 */

@property (nonatomic, strong) UISearchBar* searchBarTwo;/**< 搜索框 */
@property (nonatomic, strong) UIView* bottomInHeaderView;/**< 头视图底部视图 */

@property (nonatomic, strong) UIScrollView* scrollViewFirst;/**< 分类滚动条 */
@property (nonatomic, strong) UIButton* buttonArea;/**< 地区选择 */

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIView *selectBlackView;/**< 筛选框在下面加一个半透明的背景 */
@property (nonatomic, strong) UIView *rightBlackView; /**< 点击创建的时候在TabBar上加一个半透明背景 */

@property (nonatomic, strong) UIView *bottomView;
@property (strong, nonatomic) UIView *indicatorView;

@property (nonatomic, strong) UIView *editBottomView;

@property (nonatomic, strong) UIButton* selectedButton;/**< 分类选中Button */

@property (nonatomic, strong) UISelectCity *city;/**< 筛选框 */

//@property (nonatomic, strong) WPActionSheet *actionSheet;

//@property (nonatomic, assign) BOOL isRecruit;/**< 招聘or求助 */

@property (nonatomic, strong) NearCategoryModel *model;/**< 请求数据类型Model */

@property (nonatomic, assign) NSInteger categoryCount; /**< 分类标志位 */

@property (nonatomic, assign) int pageNumber;/**< 请求的页数 */
@property (nonatomic, assign) int pageNumber1;/**< 请求的页数 */
@property (nonatomic, assign) int pageNumber2;/**< 请求的页数 */
@property (nonatomic, assign) int pageNumber3;/**< 请求的页数 */
@property (nonatomic, assign) int pageNumber4;/**< 请求的页数 */

@property (nonatomic, strong) SPRecuilistModel *recModel;
@property (nonatomic, strong) WPUserListModel *userModel;

@property (nonatomic, assign) NSInteger bottomType;

@property (nonatomic, strong) WPInterviewListModel *selectedModel;

@property (strong, nonatomic) NSMutableArray *selectedArray;

@property (assign, nonatomic) BOOL collectionViewEditing;

@end

@implementation WPNearController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.navigationController.navigationBar setTranslucent:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.edgesForExtendedLayout = UIRectEdgeAll;/**<  边缘延伸布局 */
    //_isRecruit = YES;/**< 默认为求职 */
    _categoryCount = 0;
    _pageNumber = 1;
    _pageNumber1 = 1;
    _pageNumber2 = 1;
    _pageNumber3 = 1;
    _pageNumber4 = 1;
    _bottomType = 0;
    
    _collectionViewEditing = NO;

    [self.scrollView addSubview:self.collectionView];
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.collectionView1];
    [self.scrollView addSubview:self.tableView1];
    [self.scrollView addSubview:self.collectionView2];
    [self.scrollView addSubview:self.tableView2];
    [self.scrollView addSubview:self.collectionView3];
    [self.scrollView addSubview:self.tableView3];
    
    [self.view addSubview:self.searchBarTwo];

    [self.view addSubview:self.bottomInHeaderView];
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.indicatorView];
    
    [self.view addSubview:self.editBottomView];
    
    [self.bottomInHeaderView addSubview:self.buttonArea];
    [self.bottomInHeaderView addSubview:self.scrollViewFirst];
//    [self.bottomInHeaderView addSubview:self.imageView];
//    self.bottomInHeaderView.backgroundColor = [UIColor redColor];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bottomInHeaderView.height-0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(226, 226, 226);
    [self.bottomInHeaderView addSubview:line];

    [self setUpGesture];
    [self setNavbarItem];
//    [self setsearchDisplayController];
    
    _model = [[NearCategoryModel alloc]init];
    _model.action = @"Interview";
    _model.areaID = @"";
    _model.industryID = @"";
    _model.Position = @"";
    _model.Sex = @"1";
    _model.Wage = @"1";
    _model.Experience = @"1";
    _model.education = @"";
    _model.Welfare = @"1";
    _model.age = @"";
    [self refreshWithIndex:1];
    [self getDefaultCompany];
    [self getDefaultResume];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WPInterviewControllerDelegate) name:@"kNotificationRefreshLsit" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WPInterviewControllerDelegate) name:@"kNotificationDeleteResume" object:nil];
}

#pragma mark - 初始化数组
- (WPInterviewListModel *)selectedModel{
    if (!_selectedModel) {
        _selectedModel = [[WPInterviewListModel alloc]init];
    }
    return _selectedModel;
}

- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc]init];
    }
    return _selectedArray;
}

-(NSMutableArray *)interviewArr
{
    if (!_interviewArr) {
        
        _interviewArr = [[NSMutableArray alloc]init];
    }
    return _interviewArr;
}

//-(NSMutableArray *)RecruiListArr
//{
    //if (!_RecruiListArr) {
        //_RecruiListArr = [[NSMutableArray alloc]init];
    //}
    //return _RecruiListArr;
//}

-(NSMutableArray *)interviewArr1
{
    if (!_interviewArr1) {
        
        _interviewArr1 = [[NSMutableArray alloc]init];
    }
    return _interviewArr1;
}

//-(NSMutableArray *)RecruiListArr1
//{
    //if (!_RecruiListArr1) {
        //_RecruiListArr1 = [[NSMutableArray alloc]init];
    //}
    //return _RecruiListArr1;
//}

-(NSMutableArray *)interviewArr2
{
    if (!_interviewArr2) {
        
        _interviewArr2 = [[NSMutableArray alloc]init];
    }
    return _interviewArr2;
}

//-(NSMutableArray *)RecruiListArr2
//{
    //if (!_RecruiListArr2) {
        //_RecruiListArr2 = [[NSMutableArray alloc]init];
    //}
    //return _RecruiListArr2;
//}

-(NSMutableArray *)interviewArr3
{
    if (!_interviewArr3) {
        
        _interviewArr3 = [[NSMutableArray alloc]init];
    }
    return _interviewArr3;
}

//-(NSMutableArray *)RecruiListArr3
//{
    //if (!_RecruiListArr3) {
        //_RecruiListArr3 = [[NSMutableArray alloc]init];
    //}
    //return _RecruiListArr3;
//}

#pragma mark - 初始化子视图
- (void)setUpGesture/**< 设置点击取消手势 */
{
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)setNavbarItem/**< 初始化导航栏 */
{
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(0, 0, 50, 22);
//    leftButton.titleLabel.font = GetFont(15);
//    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
//    [leftButton setTitle:@"招聘" forState:UIControlStateNormal];
//    [leftButton setTitle:@"求职" forState:UIControlStateSelected];
//    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(leftBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 8, 10, 6)];
//    imageView.image = [UIImage imageNamed:@"qiehuanjiantou"];
//    [leftButton addSubview:imageView];
//    
//    UIBarButtonItem* leftOne = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = leftOne;
    
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button1.frame = CGRectMake(0, 0, 35, 22);
    _button1.titleLabel.font = kFONT(14);
    [_button1 setTitle:@"创建" forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_button1 addTarget:self action:@selector(rightBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:_button1];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0, 22, 22);
    [_button setImage:[UIImage imageNamed:@"qiehuanliebiao"] forState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:@"tupianmushi"] forState:UIControlStateSelected];
    [_button addTarget:self action:@selector(switchPhotoStyle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem2 = [[UIBarButtonItem alloc]initWithCustomView:_button];
    NSArray *rightBars = @[rightBarItem,rightBarItem2];
    self.navigationItem.rightBarButtonItems= rightBars;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HEADVIEWHEIGHT+64, SCREEN_WIDTH, SCREEN_HEIGHT-HEADVIEWHEIGHT-64-49)];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*4, SCREEN_HEIGHT-HEADVIEWHEIGHT-BOTTOMHEIGHT-64);
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
    
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

#pragma mark - Table+Collection 0
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        // 分隔线
        
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-HEADVIEWHEIGHT-BOTTOMHEIGHT-64);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.tableView.separatorColor = WPColor(226, 226, 226);
        self.tableView.rowHeight = [WPRecruitTCell rowHeight];
        self.tableView.tableFooterView = [[UIView alloc]init];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.hidden = NO;
        __weak typeof(self) unself = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableView.mj_footer resetNoMoreData];
            [unself.collectionView.mj_footer resetNoMoreData];
            _pageNumber = 1;
            
            [unself requestWithPageIndex:_pageNumber Success:^(NSArray *datas, int more) {
                //if (_isRecruit) {
                    //[unself.RecruiListArr removeAllObjects];
                    //[unself.RecruiListArr addObjectsFromArray:datas];
                    //[unself.tableView reloadData];
                    //[unself.collectionView reloadData];
                    //if (unself.RecruiListArr.count == 0) {
////                        [MBProgressHUD createHUD:@"没有招聘信息" View:self.view];
                    //}
                //}else{
                    [unself.interviewArr removeAllObjects];
                    [unself.interviewArr addObjectsFromArray:datas];
                    [unself.tableView reloadData];
                    [unself.collectionView reloadData];
                    if (unself.interviewArr.count == 0) {
//                        [MBProgressHUD createHUD:@"没有求职信息" View:self.view];
                    }
                //}
            } Error:^(NSError *error) {
            }];
            [self.tableView.mj_header endRefreshing];
        }];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
           
            _pageNumber++;
            [unself requestWithPageIndex:_pageNumber Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //if (_isRecruit) {
                        //[unself.RecruiListArr addObjectsFromArray:datas];
                    //}else{
                        [unself.interviewArr addObjectsFromArray:datas];
                    //}
                    [unself.tableView reloadData];
                    [unself.collectionView reloadData];
                }
            } Error:^(NSError *error) {
                _pageNumber--;
            }];
            [unself.tableView.mj_footer endRefreshing];
        }];
        
    }
    return _tableView;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [_collectionView setCollectionViewLayout:flowLayout];
        
        int width = 0;
        if (SCREEN_WIDTH == 320) {
            width = 320;
        }
        if (SCREEN_WIDTH == 375) {
            width = 376;
        }
        if (SCREEN_WIDTH == 414) {
            width = 416;
        }
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, width, SCREEN_HEIGHT-HEADVIEWHEIGHT-BOTTOMHEIGHT-64) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = WPColor(255, 255, 255);
//        _collectionView.backgroundColor = [UIColor redColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[WPInterviewCell class] forCellWithReuseIdentifier:@"WPInterviewCell"];
        [_collectionView registerClass:[WPRecruitCell class] forCellWithReuseIdentifier:@"WPRecruitCell"];
        _collectionView.hidden = YES;
        __weak __typeof(self) unself = self;
        
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.collectionView.mj_footer resetNoMoreData];
            [unself.tableView.mj_footer resetNoMoreData];
            _pageNumber = 1;
            [unself requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                //if (_isRecruit) {
                    //[unself.RecruiListArr removeAllObjects];
                    //[unself.RecruiListArr addObjectsFromArray:datas];
                    //[unself.collectionView reloadData];
                    //[unself.tableView reloadData];
                    //if (unself.RecruiListArr.count == 0) {
////                        [MBProgressHUD createHUD:@"没有招聘信息" View:self.view];
                    //}
                //}else{
                    [unself.interviewArr removeAllObjects];
                    [unself.interviewArr addObjectsFromArray:datas];
                    [unself.collectionView reloadData];
                    [unself.tableView reloadData];
                    if (unself.interviewArr.count == 0) {
//                        [MBProgressHUD createHUD:@"没有求职信息" View:self.view];
                    //}
                }
                
            } Error:^(NSError *error) {
            }];
            [self.collectionView.mj_header endRefreshing];
        }];
        
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pageNumber++;
            [unself requestWithPageIndex:_pageNumber Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //if (_isRecruit) {
                        //[unself.RecruiListArr addObjectsFromArray:datas];
                    //}else{
                        [unself.interviewArr addObjectsFromArray:datas];
                    //}
                    [unself.collectionView reloadData];
                    [unself.tableView reloadData];
                }
            } Error:^(NSError *error) {
                _pageNumber--;
            }];
            [unself.collectionView.mj_footer endRefreshing];
        }];
    }
    return _collectionView;
}
#pragma mark - Table+Collection 1
- (UITableView*)tableView1
{
    if (_tableView1 == nil) {
        _tableView1 = [[UITableView alloc] init];
        // 分隔线
        
        self.tableView1.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-HEADVIEWHEIGHT-BOTTOMHEIGHT-64);
        self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.tableView1.separatorColor = WPColor(226, 226, 226);
        self.tableView1.rowHeight = [WPRecruitTCell rowHeight];
        self.tableView1.tableFooterView = [[UIView alloc]init];
        self.tableView1.showsVerticalScrollIndicator = NO;
        self.tableView1.delegate = self;
        self.tableView1.dataSource = self;
        self.tableView1.hidden = NO;
        __weak typeof(self) unself = self;
        self.tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableView1.mj_footer resetNoMoreData];
            [unself.collectionView1.mj_footer resetNoMoreData];
            _pageNumber1 = 1;
            [unself requestWithPageIndex:_pageNumber1 Success:^(NSArray *datas, int more) {
                //if (_isRecruit) {
                    //[unself.RecruiListArr1 removeAllObjects];
                    //[unself.RecruiListArr1 addObjectsFromArray:datas];
                    //[unself.tableView1 reloadData];
                    //[unself.collectionView1 reloadData];
                    //if (unself.RecruiListArr1.count == 0) {
////                        [MBProgressHUD createHUD:@"没有招聘信息" View:self.view];
                    //}
                //}else{
                    [unself.interviewArr1 removeAllObjects];
                    [unself.interviewArr1 addObjectsFromArray:datas];
                    [unself.tableView1 reloadData];
                    [unself.collectionView1 reloadData];
                    if (unself.interviewArr1.count == 0) {
//                        [MBProgressHUD createHUD:@"没有求职信息" View:self.view];
                    }
                //}
                
            } Error:^(NSError *error) {
            }];
            [self.tableView1.mj_header endRefreshing];
        }];
        
        self.tableView1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            _pageNumber1++;
            [unself requestWithPageIndex:_pageNumber1 Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView1.mj_footer endRefreshingWithNoMoreData];
                    [self.collectionView1.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //if (_isRecruit) {
                        //[unself.RecruiListArr1 addObjectsFromArray:datas];
                    //}else{
                        [unself.interviewArr1 addObjectsFromArray:datas];
                    //}
                    [unself.tableView1 reloadData];
                    [unself.collectionView1 reloadData];
                }
            } Error:^(NSError *error) {
                _pageNumber1--;
            }];
            [unself.tableView1.mj_footer endRefreshing];
        }];
        
    }
    return _tableView1;
}

-(UICollectionView *)collectionView1
{
    if (!_collectionView1) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [_collectionView1 setCollectionViewLayout:flowLayout];
        
        int width = 0;
        if (SCREEN_WIDTH == 320) {
            width = 320;
        }
        if (SCREEN_WIDTH == 375) {
            width = 376;
        }
        if (SCREEN_WIDTH == 414) {
            width = 416;
        }
        
        _collectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, width, SCREEN_HEIGHT-HEADVIEWHEIGHT-BOTTOMHEIGHT-64) collectionViewLayout:flowLayout];
        _collectionView1.backgroundColor = WPColor(255, 255, 255);
        _collectionView1.showsHorizontalScrollIndicator = NO;
        _collectionView1.delegate = self;
        _collectionView1.dataSource = self;
        [_collectionView1 registerClass:[WPInterviewCell class] forCellWithReuseIdentifier:@"WPInterviewCell"];
        [_collectionView1 registerClass:[WPRecruitCell class] forCellWithReuseIdentifier:@"WPRecruitCell"];
        _collectionView1.hidden = YES;
        __weak __typeof(self) unself = self;
        
        self.collectionView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.collectionView1.mj_footer resetNoMoreData];
            [unself.tableView1.mj_footer resetNoMoreData];
            _pageNumber1 = 1;
            [unself requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                //if (_isRecruit) {
                    //[unself.RecruiListArr1 removeAllObjects];
                    //[unself.RecruiListArr1 addObjectsFromArray:datas];
                    //[unself.collectionView1 reloadData];
                    //[unself.tableView1 reloadData];
                    //if (unself.RecruiListArr1.count == 0) {
////                        [MBProgressHUD createHUD:@"没有招聘信息" View:self.view];
                    //}
                //}else{
                    [unself.interviewArr1 removeAllObjects];
                    [unself.interviewArr1 addObjectsFromArray:datas];
                    [unself.collectionView1 reloadData];
                    [unself.tableView1 reloadData];
                    if (unself.interviewArr1.count == 0) {
//                        [MBProgressHUD createHUD:@"没有求职信息" View:self.view];
                    }
                //}
            } Error:^(NSError *error) {
            }];
            [self.collectionView1.mj_header endRefreshing];
        }];
        
        self.collectionView1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pageNumber1++;
            [unself requestWithPageIndex:_pageNumber1 Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView1.mj_footer endRefreshingWithNoMoreData];
                    [self.collectionView1.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //if (_isRecruit) {
                        //[unself.RecruiListArr1 addObjectsFromArray:datas];
                    //}else{
                        [unself.interviewArr1 addObjectsFromArray:datas];
                    //}
                    [unself.collectionView1 reloadData];
                    [unself.tableView1 reloadData];
                }
            } Error:^(NSError *error) {
                _pageNumber1--;
            }];
            [unself.collectionView1.mj_footer endRefreshing];
        }];
    }
    return _collectionView1;
}

#pragma mark - Table+Collection 2
- (UITableView*)tableView2
{
    if (_tableView2 == nil) {
        _tableView2 = [[UITableView alloc] init];
        // 分隔线
        
        self.tableView2.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-HEADVIEWHEIGHT-BOTTOMHEIGHT-64);
        self.tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView2.rowHeight = [WPRecruitTCell rowHeight];
        self.tableView2.tableFooterView = [[UIView alloc]init];
        self.tableView2.showsVerticalScrollIndicator = NO;
        self.tableView2.delegate = self;
        self.tableView2.dataSource = self;
        self.tableView2.hidden = NO;
        __weak typeof(self) unself = self;
        self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableView2.mj_footer resetNoMoreData];
            [unself.collectionView2.mj_footer resetNoMoreData];
            _pageNumber2 = 1;
            [unself requestWithPageIndex:_pageNumber2 Success:^(NSArray *datas, int more) {
                //if (_isRecruit) {
                    //[unself.RecruiListArr2 removeAllObjects];
                    //[unself.RecruiListArr2 addObjectsFromArray:datas];
                    //[unself.tableView2 reloadData];
                    //[unself.collectionView2 reloadData];
                    //if (unself.RecruiListArr2.count == 0) {
////                        [MBProgressHUD createHUD:@"没有招聘信息" View:self.view];
                    //}
                //}else{
                    [unself.interviewArr2 removeAllObjects];
                    [unself.interviewArr2 addObjectsFromArray:datas];
                    [unself.tableView2 reloadData];
                    [unself.collectionView2 reloadData];
                    if (unself.interviewArr2.count == 0) {
//                        [MBProgressHUD createHUD:@"没有求职信息" View:self.view];
                    }
                //}
            } Error:^(NSError *error) {
            }];
            [self.tableView2.mj_header endRefreshing];
        }];
        
        self.tableView2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            _pageNumber2++;
            [unself requestWithPageIndex:_pageNumber2 Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView2.mj_footer endRefreshingWithNoMoreData];
                    [self.collectionView2.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //if (_isRecruit) {
                        //[unself.RecruiListArr2 addObjectsFromArray:datas];
                    //}else{
                        [unself.interviewArr2 addObjectsFromArray:datas];
                    //}
                    [unself.tableView2 reloadData];
                    [unself.collectionView2 reloadData];
                }
            } Error:^(NSError *error) {
                _pageNumber2--;
            }];
            [unself.tableView2.mj_footer endRefreshing];
        }];
        
    }
    return _tableView2;
}

-(UICollectionView *)collectionView2
{
    if (!_collectionView2) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [_collectionView2 setCollectionViewLayout:flowLayout];
        
        int width = 0;
        if (SCREEN_WIDTH == 320) {
            width = 320;
        }
        if (SCREEN_WIDTH == 375) {
            width = 376;
        }
        if (SCREEN_WIDTH == 414) {
            width = 416;
        }
        
        _collectionView2 = [[UICollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, width, SCREEN_HEIGHT-HEADVIEWHEIGHT-BOTTOMHEIGHT-64) collectionViewLayout:flowLayout];
        _collectionView2.backgroundColor = WPColor(255, 255, 255);
        _collectionView2.showsHorizontalScrollIndicator = NO;
        _collectionView2.delegate = self;
        _collectionView2.dataSource = self;
        [_collectionView2 registerClass:[WPInterviewCell class] forCellWithReuseIdentifier:@"WPInterviewCell"];
        [_collectionView2 registerClass:[WPRecruitCell class] forCellWithReuseIdentifier:@"WPRecruitCell"];
        _collectionView2.hidden = YES;
        __weak __typeof(self) unself = self;
        
        self.collectionView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.collectionView2.mj_footer resetNoMoreData];
            [unself.tableView2.mj_footer resetNoMoreData];
            _pageNumber2 = 1;
            [unself requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                //if (_isRecruit) {
                    //[unself.RecruiListArr2 removeAllObjects];
                    //[unself.RecruiListArr2 addObjectsFromArray:datas];
                    //[unself.collectionView2 reloadData];
                    //[unself.tableView2 reloadData];
                    //if (unself.RecruiListArr2.count == 0) {
////                        [MBProgressHUD createHUD:@"没有招聘信息" View:self.view];
                    //}
                //}else{
                    [unself.interviewArr2 removeAllObjects];
                    [unself.interviewArr2 addObjectsFromArray:datas];
                    [unself.collectionView2 reloadData];
                    [unself.tableView2 reloadData];
                    if (unself.interviewArr2.count == 0) {
//                        [MBProgressHUD createHUD:@"没有求职信息" View:self.view];
                    }
                //}
            } Error:^(NSError *error) {
            }];
            [self.collectionView2.mj_header endRefreshing];
        }];
        
        self.collectionView2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pageNumber2++;
            [unself requestWithPageIndex:_pageNumber2 Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView2.mj_footer endRefreshingWithNoMoreData];
                    [self.collectionView2.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //if (_isRecruit) {
                        //[unself.RecruiListArr2 addObjectsFromArray:datas];
                    //}else{
                        [unself.interviewArr2 addObjectsFromArray:datas];
                    //}
                    [unself.collectionView2 reloadData];
                    [unself.tableView2 reloadData];
                }
            } Error:^(NSError *error) {
                _pageNumber2--;
            }];
            [unself.collectionView2.mj_footer endRefreshing];
        }];
    }
    return _collectionView2;
}


#pragma mark - Table+Collection 3
- (UITableView*)tableView3
{
    if (_tableView3 == nil) {
        _tableView3 = [[UITableView alloc] init];
        // 分隔线
        
        self.tableView3.frame = CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, SCREEN_HEIGHT-HEADVIEWHEIGHT-BOTTOMHEIGHT-64);
        self.tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.tableView3.separatorColor = WPColor(226, 226, 226);
        self.tableView3.rowHeight = [WPRecruitTCell rowHeight];
        self.tableView3.tableFooterView = [[UIView alloc]init];
        self.tableView3.showsVerticalScrollIndicator = NO;
        self.tableView3.delegate = self;
        self.tableView3.dataSource = self;
        self.tableView3.hidden = NO;
        __weak typeof(self) unself = self;
        self.tableView3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableView3.mj_footer resetNoMoreData];
            [unself.collectionView3.mj_footer resetNoMoreData];
            _pageNumber3 = 1;
            [unself requestWithPageIndex:_pageNumber3 Success:^(NSArray *datas, int more) {
                //if (_isRecruit) {
                    //[unself.RecruiListArr3 removeAllObjects];
                    //[unself.RecruiListArr3 addObjectsFromArray:datas];
                    //[unself.tableView3 reloadData];
                    //[unself.collectionView3 reloadData];
                    //if (unself.RecruiListArr3.count == 0) {
////                        [MBProgressHUD createHUD:@"没有招聘信息" View:self.view];
                    //}
                //}else{
                    [unself.interviewArr3 removeAllObjects];
                    [unself.interviewArr3 addObjectsFromArray:datas];
                    [unself.tableView3 reloadData];
                    [unself.collectionView3 reloadData];
                    if (unself.interviewArr3.count == 0) {
//                        [MBProgressHUD createHUD:@"没有求职信息" View:self.view];
                    //}
                }
            } Error:^(NSError *error) {
            }];
            [self.tableView3.mj_header endRefreshing];
        }];
        
        self.tableView3.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            _pageNumber3++;
            [unself requestWithPageIndex:_pageNumber3 Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView3.mj_footer endRefreshingWithNoMoreData];
                    [self.collectionView3.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //if (_isRecruit) {
                        //[unself.RecruiListArr3 addObjectsFromArray:datas];
                    //}else{
                        [unself.interviewArr3 addObjectsFromArray:datas];
                    //}
                    [unself.tableView3 reloadData];
                    [unself.collectionView3 reloadData];
                }
            } Error:^(NSError *error) {
                _pageNumber3--;
            }];
            [unself.tableView3.mj_footer endRefreshing];
        }];
        
    }
    return _tableView3;
}

-(UICollectionView *)collectionView3
{
    if (!_collectionView3) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [_collectionView3 setCollectionViewLayout:flowLayout];
        
        int width = 0;
        if (SCREEN_WIDTH == 320) {
            width = 320;
        }
        if (SCREEN_WIDTH == 375) {
            width = 376;
        }
        if (SCREEN_WIDTH == 414) {
            width = 416;
        }
        
        _collectionView3 = [[UICollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, width, SCREEN_HEIGHT-HEADVIEWHEIGHT-BOTTOMHEIGHT-64) collectionViewLayout:flowLayout];
        _collectionView3.backgroundColor = WPColor(255, 255, 255);
        _collectionView3.showsHorizontalScrollIndicator = NO;
        _collectionView3.delegate = self;
        _collectionView3.dataSource = self;
        [_collectionView3 registerClass:[WPInterviewCell class] forCellWithReuseIdentifier:@"WPInterviewCell"];
        [_collectionView3 registerClass:[WPRecruitCell class] forCellWithReuseIdentifier:@"WPRecruitCell"];
        _collectionView3.hidden = YES;
        __weak __typeof(self) unself = self;
        
        self.collectionView3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.collectionView3.mj_footer resetNoMoreData];
            [unself.tableView3.mj_footer resetNoMoreData];
            _pageNumber3 = 1;
            [unself requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                //if (_isRecruit) {
                    //[unself.RecruiListArr3 removeAllObjects];
                    //[unself.RecruiListArr3 addObjectsFromArray:datas];
                    //[unself.collectionView3 reloadData];
                    //[unself.tableView3 reloadData];
                    //if (unself.RecruiListArr3.count == 0) {
////                        [MBProgressHUD createHUD:@"没有招聘信息" View:self.view];
                    //}
                //}else{
                    [unself.interviewArr3 removeAllObjects];
                    [unself.interviewArr3 addObjectsFromArray:datas];
                    [unself.collectionView3 reloadData];
                    [unself.tableView3 reloadData];
                    if (unself.interviewArr3.count == 0) {
//                        [MBProgressHUD createHUD:@"没有求职信息" View:self.view];
                    //}
                }
            } Error:^(NSError *error) {
            }];
            [self.collectionView3.mj_header endRefreshing];
        }];
        
        self.collectionView3.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pageNumber3++;
            [unself requestWithPageIndex:_pageNumber3 Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView3.mj_footer endRefreshingWithNoMoreData];
                    [self.collectionView3.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //if (_isRecruit) {
                        //[unself.RecruiListArr3 addObjectsFromArray:datas];
                    //}else{
                        [unself.interviewArr3 addObjectsFromArray:datas];
                    //}
                    [unself.collectionView3 reloadData];
                    [unself.tableView3 reloadData];
                }
            } Error:^(NSError *error) {
                _pageNumber3--;
            }];
            [unself.collectionView3.mj_footer endRefreshing];
        }];
    }
    return _collectionView3;
}

#pragma mark - Table+Collection 4
- (UITableView*)tableView4
{
    if (_tableView4 == nil) {
        _tableView4 = [[UITableView alloc] init];
        // 分隔线
        
        self.tableView4.frame = CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, SCREEN_HEIGHT-HEADVIEWHEIGHT-BOTTOMHEIGHT-64);
        self.tableView4.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.tableView4.separatorColor = WPColor(226, 226, 226);
        self.tableView4.rowHeight = [WPRecruitTCell rowHeight];
        self.tableView4.tableFooterView = [[UIView alloc]init];
        self.tableView4.showsVerticalScrollIndicator = NO;
        self.tableView4.delegate = self;
        self.tableView4.dataSource = self;
        self.tableView4.hidden = NO;
        __weak typeof(self) unself = self;
        self.tableView4.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.tableView4.mj_footer resetNoMoreData];
            [unself.collectionView4.mj_footer resetNoMoreData];
            _pageNumber4 = 1;
            [unself requestWithPageIndex:_pageNumber4 Success:^(NSArray *datas, int more) {
                //if (_isRecruit) {
                    //[unself.RecruiListArr4 removeAllObjects];
                    //[unself.RecruiListArr4 addObjectsFromArray:datas];
                    //[unself.tableView4 reloadData];
                    //[unself.collectionView4 reloadData];
                    //if (unself.RecruiListArr4.count == 0) {
////                        [MBProgressHUD createHUD:@"没有招聘信息" View:self.view];
                    //}
                //}else{
                    [unself.interviewArr4 removeAllObjects];
                    [unself.interviewArr4 addObjectsFromArray:datas];
                    [unself.tableView4 reloadData];
                    [unself.collectionView4 reloadData];
                    if (unself.interviewArr4.count == 0) {
//                        [MBProgressHUD createHUD:@"没有求职信息" View:self.view];
                    }
                //}
            } Error:^(NSError *error) {
            }];
            [self.tableView4.mj_header endRefreshing];
        }];
        
        self.tableView4.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            _pageNumber4++;
            [unself requestWithPageIndex:_pageNumber4 Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView4.mj_footer endRefreshingWithNoMoreData];
                    [self.collectionView4.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //if (_isRecruit) {
                        //[unself.RecruiListArr4 addObjectsFromArray:datas];
                    //}else{
                        [unself.interviewArr4 addObjectsFromArray:datas];
                    //}
                    [unself.tableView4 reloadData];
                    [unself.collectionView4 reloadData];
                }
            } Error:^(NSError *error) {
                _pageNumber4--;
            }];
            [unself.tableView4.mj_footer endRefreshing];
        }];
        
    }
    return _tableView4;
}

-(UICollectionView *)collectionView4
{
    if (!_collectionView4) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [_collectionView4 setCollectionViewLayout:flowLayout];
        
        int width = 0;
        if (SCREEN_WIDTH == 320) {
            width = 320;
        }
        if (SCREEN_WIDTH == 375) {
            width = 376;
        }
        if (SCREEN_WIDTH == 414) {
            width = 416;
        }
        
        _collectionView4 = [[UICollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, width, SCREEN_HEIGHT-HEADVIEWHEIGHT-BOTTOMHEIGHT-64) collectionViewLayout:flowLayout];
        _collectionView4.backgroundColor = WPColor(255, 255, 255);
        _collectionView4.showsHorizontalScrollIndicator = NO;
        _collectionView4.delegate = self;
        _collectionView4.dataSource = self;
        [_collectionView4 registerClass:[WPInterviewCell class] forCellWithReuseIdentifier:@"WPInterviewCell"];
        [_collectionView4 registerClass:[WPRecruitCell class] forCellWithReuseIdentifier:@"WPRecruitCell"];
        _collectionView4.hidden = YES;
        __weak __typeof(self) unself = self;
        
        self.collectionView4.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.collectionView4.mj_footer resetNoMoreData];
            [unself.tableView4.mj_footer resetNoMoreData];
            _pageNumber4 = 1;
            [unself requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                //if (_isRecruit) {
                    //[unself.RecruiListArr4 removeAllObjects];
                    //[unself.RecruiListArr4 addObjectsFromArray:datas];
                    //[unself.tableView4 reloadData];
                    //[unself.collectionView4 reloadData];
                    //if (unself.RecruiListArr4.count == 0) {
////                        [MBProgressHUD createHUD:@"没有招聘信息" View:self.view];
                    //}
                //}else{
                    [unself.interviewArr4 removeAllObjects];
                    [unself.interviewArr4 addObjectsFromArray:datas];
                    [unself.tableView4 reloadData];
                    [unself.collectionView4 reloadData];
                    if (unself.interviewArr4.count == 0) {
//                        [MBProgressHUD createHUD:@"没有求职信息" View:self.view];
                    }
                //}
            } Error:^(NSError *error) {
            }];
            [self.collectionView4.mj_header endRefreshing];
        }];
        
        self.collectionView4.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pageNumber4++;
            [unself requestWithPageIndex:_pageNumber4 Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView4.mj_footer endRefreshingWithNoMoreData];
                    [self.collectionView4.mj_footer endRefreshingWithNoMoreData];
                }else{
                    //if (_isRecruit) {
                        //[unself.RecruiListArr4 addObjectsFromArray:datas];
                    //}else{
                        [unself.interviewArr4 addObjectsFromArray:datas];
                    //}
                    [unself.collectionView4 reloadData];
                    [unself.tableView4 reloadData];
                }
            } Error:^(NSError *error) {
                _pageNumber4--;
            }];
            [unself.collectionView4.mj_footer endRefreshing];
        }];
    }
    return _collectionView4;
}

- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _searchView.backgroundColor = RGBA(0, 0, 0, 0.3);
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        view.backgroundColor = [UIColor whiteColor];
        [_searchView addSubview:view];
        
        UISearchBar *search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
        search.delegate = self;
        search.placeholder = @"搜索";
        search.keyboardType = UIKeyboardTypeDefault;
        [_searchView addSubview:search];
    }
    return _searchView;
}

- (UISearchBar*)searchBarTwo
{
    if (_searchBarTwo == nil) {
        self.searchBarTwo = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SEARCHBARHEIGHT)];
        self.searchBarTwo.delegate = self;
        self.searchBarTwo.placeholder = @"搜索";
        self.searchBarTwo.tintColor = [UIColor lightGrayColor];
        self.searchBarTwo.autocorrectionType = UITextAutocorrectionTypeNo;
        self.searchBarTwo.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.searchBarTwo.keyboardType = UIKeyboardTypeDefault;
        self.searchBarTwo.backgroundColor = WPColor(235, 235, 235);
        
        for (UIView* view in self.searchBarTwo.subviews) {
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

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    WPAllSearchController *search = [[WPAllSearchController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:search];
    [self presentViewController:navc animated:NO completion:nil];
    return NO;
}

- (UIView*)bottomInHeaderView
{
    if (_bottomInHeaderView == nil) {
        _bottomInHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, SEARCHBARHEIGHT+64, SCREEN_WIDTH, BOTTOMINHEADVIEWHEIGHT)];
    }
    return _bottomInHeaderView;
}

- (UIButton*)buttonArea
{
    if (_buttonArea == nil) {
        _buttonArea = [[UIButton alloc] init];
        [_buttonArea setFrame:CGRectMake(0, 0, IBUTTONXPOSITION, BOTTOMINHEADVIEWHEIGHT)];
        [_buttonArea setTitle:@"区域" forState:UIControlStateNormal];
        
        // 字体大小
        _buttonArea.titleLabel.font = kFONT(14);
        _buttonArea.tag = 19;
        [_buttonArea setBackgroundColor:[UIColor whiteColor]];
        // 文字颜色
        [_buttonArea setTitleColor:IWTabBarButtonTitleColor forState:UIControlStateNormal];
        [_buttonArea setTitleColor:IWTabBarButtonTitleSelectedColor forState:UIControlStateSelected];
        [_buttonArea setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, _buttonArea.width/2-15)];
        [_buttonArea setBackgroundImage:[UIImage resizedImageWithName:@"discover_button"] forState:UIControlStateHighlighted];
        [_buttonArea addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    }
    return _buttonArea;
}

- (UIScrollView*)scrollViewFirst
{
    if (_scrollViewFirst == nil) {
        //2.设置uiscrollview
        _scrollViewFirst = [[UIScrollView alloc] initWithFrame:CGRectMake(IBUTTONXPOSITION, 0, SCREEN_WIDTH - IBUTTONXPOSITION, BOTTOMINHEADVIEWHEIGHT)];
        _scrollViewFirst.backgroundColor = [UIColor whiteColor];
        [_scrollViewFirst setShowsHorizontalScrollIndicator:NO];
        [_scrollViewFirst setShowsVerticalScrollIndicator:NO];
        [_scrollViewFirst setBounces:YES];
        
        NSArray* arrayButtonName = @[@"行业", @"职称", @"工资", @"经验",@"学历",@"福利",@"年龄", @"性别"];
        _scrollViewFirst.contentSize = CGSizeMake(arrayButtonName.count * IBUTTONXPOSITION, BOTTOMINHEADVIEWHEIGHT);
        
        for (int i = 0; i < arrayButtonName.count; ++i) {
            UIButton* button = [[UIButton alloc] init];
            [button setFrame:CGRectMake(i * IBUTTONXPOSITION, 0, IBUTTONXPOSITION, BOTTOMINHEADVIEWHEIGHT)];
            [button setTitle:arrayButtonName[i] forState:UIControlStateNormal];
            
            // 字体大小
            button.titleLabel.font = kFONT(14);
            button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [button setBackgroundColor:[UIColor whiteColor]];
            
            // 文字颜色
            [button setTitleColor:IWTabBarButtonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:WPColor(15, 87, 199) forState:UIControlStateSelected];
//            [button setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, IBUTTONXPOSITION/2-10)];
            [button setBackgroundImage:[UIImage resizedImageWithName:@"discover_button"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
            [button setTag:10+i];
            [_scrollViewFirst addSubview:button];
        }
    }
    return _scrollViewFirst;
}

- (UIImageView*)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, BOTTOMINHEADVIEWHEIGHT, SCREEN_WIDTH, 1)];
        _imageView.image = [UIImage imageNamed:@"near_line"];
    }
    return _imageView;
}

//- (void)setsearchDisplayController
//{
//    _mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBarTwo contentsController:self];
//    _mySearchDisplayController.delegate = self;
//    _mySearchDisplayController.searchResultsDataSource = self;
//    _mySearchDisplayController.searchResultsDelegate = self;
//}

- (UISelectCity *)city
{
    if (!_city) {
        
        _city = [[UISelectCity alloc]initWithFrame:CGRectMake(0, 64+HEADVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64-HEADVIEWHEIGHT)];
        _city.delegate = self;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        UIView *subView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+40)];
        subView1.tag = 1000;
        subView1.backgroundColor = RGBA(0, 0, 0, 0);
        [window addSubview:subView1];
        
//        _selectBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+80, SCREEN_WIDTH, SCREEN_HEIGHT-64-80)];
//        [window addSubview:_selectBlackView];
//        UIView *subView2 = [[UIView alloc]initWithFrame:CGRectMake(0, _selectBlackView.height-72, SCREEN_WIDTH, 72)];
//        subView2.backgroundColor = RGBA(0, 0, 0, 0.5);
//        subView2.tag = 1001;
//        [_selectBlackView addSubview:subView2];
        
        __weak typeof(self) unself = self;
        _city.touchHide =^(){
            [unself touchHide:nil];
        };
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]init];
        [tap1 addTarget:self action:@selector(touchHide:)];
        [subView1 addGestureRecognizer:tap1];
        
//        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]init];
//        [tap2 addTarget:self action:@selector(touchHide:)];
//        [subView2 addGestureRecognizer:tap2];
        
        [window addSubview:_city];
    }
    return _city;
}

//-(WPActionSheet *)actionSheet
//{
    //if (!_actionSheet) {
       //_actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"招聘简历",@"求职简历"] imageNames:nil top:64];
        //__weak typeof(self) unself = self;
        //_actionSheet.touchToHide = ^(){
            //[unself hideRightBlack];
        //};
    //}
    //return _actionSheet;
//}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, BOTTOMHEIGHT)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        NSArray *arr = @[@"最新",@"关注",@"好友",@"我的"];
        for (int i = 0; i < 4; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, BOTTOMHEIGHT);
            [button setTitle:arr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:RGB(10, 110, 210) forState:UIControlStateSelected];
            button.titleLabel.font = kFONT(15);
            button.tag = 30+i;
            i == 0?button.selected = YES:0;
            if (i!=3) {
                UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*SCREEN_WIDTH/4-0.5, BOTTOMHEIGHT/2-7.5, 0.5, 15)];
                line.backgroundColor = RGB(178, 178, 178);
                [_bottomView addSubview:line];
            }
            [button addTarget:self action:@selector(bottomExampleClick:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:button];
        }
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomView addSubview:line];
    }
    return _bottomView;
}

- (UIView *)editBottomView{
    if (!_editBottomView) {
        _editBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, BOTTOMHEIGHT)];
        _editBottomView.backgroundColor = [UIColor whiteColor];
        
        NSArray *arr = @[@"抢",@"收藏",@"分享"];
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, BOTTOMHEIGHT);
            [button setTitle:arr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
            button.titleLabel.font = kFONT(15);
            button.tag = 40+i;
            if (i!=2) {
                UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*SCREEN_WIDTH/3-0.5, BOTTOMHEIGHT/2-7.5, 0.5, 15)];
                line.backgroundColor = RGB(178, 178, 178);
                [_editBottomView addSubview:line];
            }
            [button addTarget:self action:@selector(editBottomClick:) forControlEvents:UIControlEventTouchUpInside];
            [_editBottomView addSubview:button];
        }
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_editBottomView addSubview:line];
        
        _editBottomView.hidden = YES;
    }
    return _editBottomView;
}

- (void)editBottomClick:(UIButton *)sender{
    
    NSString *str = @"";
    for (WPInterviewListModel *model in self.selectedArray) {
        str = [NSString stringWithFormat:@"%@%@%@",str,model.jobId,SEPARATOR];
    }
    
    if (sender.tag == 40) {
        if (self.selectedArray.count == 0) {
            [SPAlert alertControllerWithTitle:@"提示" message:@"请至少选择一个简历！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
        }else{
            WPInterviewApplyController *apply = [[WPInterviewApplyController alloc] init];
            apply.sid = str;
            [self.navigationController pushViewController:apply animated:YES];
        }
    }
    
    if (sender.tag == 41) {
        
        if (self.selectedArray.count == 0) {
            [SPAlert alertControllerWithTitle:@"提示" message:@"请至少选择一个简历！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
        }else{
            NSString *url  = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
            
            NSDictionary *dic = @{@"action":@"ResumeCollect",
                                  @"user_id":kShareModel.userId,
                                  @"username":kShareModel.username,
                                  @"password":kShareModel.password,
                                  @"resume_id":str};
            
            [WPHttpTool postWithURL:url params:dic success:^(id json) {
                [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
            } failure:^(NSError *error) {
                NSLog(@"%@",error.localizedDescription);
            }];
        }
    }
    if (sender.tag == 42) {
        if (self.selectedArray.count == 0) {
            [SPAlert alertControllerWithTitle:@"提示" message:@"请至少选择一个简历！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
        }
        
//        if (self.selectedArray.count != 0) {
//            [YYShareManager shareWithTitle:@"这是title" url:@"" action:^(YYShareManagerType type) {
//                if (type == YYShareManagerTypeWeiPinFriends) {
//                    RecentPersonController *recent = [[RecentPersonController alloc]init];
//                    recent.shareArray = self.selectedArray;
//                    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:recent];
//                    [self presentViewController:navc animated:YES completion:nil];
//                }
//                if (type == YYShareManagerTypeWorkLines) {
//                    
//                }
//            } status:^(UMSResponseCode status) {
//                if (status == UMSResponseCodeSuccess) {
//                    [self backToFromViewController:nil];
//                }
//            }];
//        }
    }
}

- (UIView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-3, SCREEN_WIDTH/4, 3)];
        _indicatorView.backgroundColor = RGB(10, 110, 210);
    }
    return _indicatorView;
}

-(UIView *)rightBlackView
{
    if (!_rightBlackView) {
        _rightBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _rightBlackView.backgroundColor = RGBA(0, 0, 0, 0);
        _rightBlackView.hidden = YES;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_rightBlackView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightBlackViewHide:)];
        [_rightBlackView addGestureRecognizer:tap1];
    }
    return _rightBlackView;
}

-(void)rightBlackViewHide:(UITapGestureRecognizer *)tap
{
    [self hideRightBlack];
    //[_actionSheet hideFromView:self.view];
}

-(void)showRightBlack
{
    self.rightBlackView.hidden = NO;
//    self.rightBlackView.backgroundColor = [UIColor clearColor];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.rightBlackView.backgroundColor = RGBA(0, 0, 0, 0.5);
//    }];
}

-(void)hideRightBlack
{
    self.rightBlackView.hidden = YES;
//    self.rightBlackView.backgroundColor = RGBA(0, 0, 0, 0.5);
//    [UIView animateWithDuration:0.3 animations:^{
//        self.rightBlackView.backgroundColor = [UIColor clearColor];
//    }];
//    [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
}

//-(void)delay
//{
//    self.rightBlackView.hidden = YES;
//}
#pragma mark - 网络请求
-(void)requestWithPageIndex:(int)pageIndex Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
//    NSString *actionStr;
    //if ([_model.action isEqualToString:@"EnterpriseRecruitment"]) {
        //_isRecruit = YES;
    //}else{
        //_isRecruit = NO;
    //}
    NSString *state;
    switch (_bottomType) {
        case 0:
            state = @"1";
            break;
        case 1:
            state = @"3";
            break;
        case 2:
            state = @"2";
            break;
        case 3:
            state = @"4";
            break;
        default:
            break;
    }
    WPShareModel *model = [WPShareModel sharedModel];
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    NSDictionary *params = @{@"action":_model.action,
                             @"state":state,
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.dic[@"userid"],
                             @"keyWords":@"",
                             @"areaID":_model.areaID,
                             @"Industry":_model.industryID,
                             @"Position":_model.Position,
                             @"Sex":_model.Sex,
                             @"Wage":_model.Wage,
                             @"Experience":_model.Experience,
                             @"Demand":@"1",
                             @"education":_model.education,
                             @"Welfare":_model.Welfare,
                             @"age":_model.age,
                             @"page":[NSString stringWithFormat:@"%d",pageIndex]};
    [WPHttpTool postWithURL:str params:params success:^(id json) {

        //if (_isRecruit) {/**< 招聘 */
            //WPRecruitModel *recruitModel = [WPRecruitModel objectWithKeyValues:json];
            //NSArray *arr = [[NSArray alloc]initWithArray:recruitModel.list];
            //success(arr,(int)arr.count);
        //}else{/**< 求职 */
            WPInterviewModel *recruitModel = [WPInterviewModel mj_objectWithKeyValues:json];
            NSArray *arr = [[NSArray alloc]initWithArray:recruitModel.list];
            for (WPInterviewListModel *listModel in arr) {
                listModel.isSelected = NO;
            }
            success(arr,(int)arr.count);
        //}
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
    }];
}

-(void)getDefaultCompany
{
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/enterprise.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"defaultinfo",
                             @"user_id":model.dic[@"userid"],
                             @"username":model.username,
                             @"password":model.password
                             };
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        _recModel = [SPRecuilistModel mj_objectWithKeyValues:json];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)getDefaultResume
{
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetDefaultResume",
                             @"user_id":model.dic[@"userid"],
                             @"username":model.username,
                             @"password":model.password
                             };
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        _userModel = [WPUserListModel mj_objectWithKeyValues:json];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)refreshWithIndex:(int)index
{
    switch (_bottomType) {
        case 0:
            [self.tableView reloadData];
            [self.collectionView reloadData];
            if (!self.tableView.hidden) {
                [self.tableView.mj_header beginRefreshing];
            }else{
                [self.collectionView.mj_header beginRefreshing];
            }
            break;
        case 1:
            [self.tableView1 reloadData];
            [self.collectionView1 reloadData];
            if (!self.tableView1.hidden) {
                [self.tableView1.mj_header beginRefreshing];
            }else{
                [self.collectionView1.mj_header beginRefreshing];
            }
            break;
        case 2:
            [self.tableView2 reloadData];
            [self.collectionView2 reloadData];
            if (!self.tableView2.hidden) {
                [self.tableView2.mj_header beginRefreshing];
            }else{
                [self.collectionView2.mj_header beginRefreshing];
            }
            break;
        case 3:
            [self.tableView3 reloadData];
            [self.collectionView3 reloadData];
            if (!self.tableView3.hidden) {
                [self.tableView3.mj_header beginRefreshing];
            }else{
                [self.collectionView3.mj_header beginRefreshing];
            }
            break;
        default:
            break;
    }
//    [self.tableView.mj_header beginRefreshing];
//    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Actions
- (void)backToFromViewController:(UIButton *)sender{
    
    if (self.tableView.editing|self.tableView1.editing|self.tableView2.editing|self.tableView3.editing) {
        self.tableView.editing = NO;
        self.tableView1.editing = NO;
        self.tableView2.editing = NO;
        self.tableView3.editing = NO;
        self.editBottomView.hidden = YES;
        self.scrollView.scrollEnabled = YES;
        _button.hidden = NO;
        _button1.hidden = NO;
        
        _collectionViewEditing = NO;
        switch (_bottomType) {
            case 0:
                [self.collectionView reloadData];
                break;
            case 1:
                [self.collectionView1 reloadData];
                break;
            case 2:
                [self.collectionView2 reloadData];
                break;
            default:
                break;
        }
        
        [self.selectedArray removeAllObjects];
        
    }else{
        [self.city removeFromSuperview];
        UIView *view = [WINDOW viewWithTag:1000];
        [view removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//-(void)leftBarButtonItemClick:(UIButton *)sender/**< 左按钮 */
//{
    //sender.selected = !sender.selected;
    //_isRecruit = !_isRecruit;
    //[self.RecruiListArr removeAllObjects];
    //[self.interviewArr removeAllObjects];
    //[self.tableView.mj_header beginRefreshing];
    //[self.collectionView.mj_header beginRefreshing];
//}

-(void)rightBarButtonItemClick:(UIButton *)sender/**< 右按钮创建 */
{
//    if(self.actionSheet.frame.origin.y < 0&&sender.selected){
//        sender.selected = !sender.selected;
//    }
//    sender.selected = !sender.selected;
//    if(sender.selected){
//        [self.actionSheet showInView:self.view];
//        [self showRightBlack];
//    }else{
//        [self.actionSheet hideFromView:self.view];
//        [self hideRightBlack];
//    }
    NSLog(@"求职简历");
    
    WPInterviewController *interview = [[WPInterviewController alloc]init];
    interview.title = @"求职简历";
    interview.delegate = self;
    if (![_userModel.resumeUserId isEqualToString:@"0"]) {
        interview.model = _userModel;
    }
    [self.navigationController pushViewController:interview animated:YES];
}

-(void)switchPhotoStyle:(UIButton *)sender/**< 右按钮切换 */
{
    sender.selected = !sender.selected;
    if (sender.selected) {
//        [self.view bringSubviewToFront:self.collectionView];
        self.collectionView.hidden = NO;
        self.tableView.hidden = YES;
        self.collectionView1.hidden = NO;
        self.tableView1.hidden = YES;
        self.collectionView2.hidden = NO;
        self.tableView2.hidden = YES;
        self.collectionView3.hidden = NO;
        self.tableView3.hidden = YES;
    }else{
//        [self.view bringSubviewToFront:self.tableView];
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
        self.tableView1.hidden = NO;
        self.collectionView1.hidden = YES;
        self.tableView2.hidden = NO;
        self.collectionView2.hidden = YES;
        self.tableView3.hidden = NO;
        self.collectionView3.hidden = YES;
    }
}

- (void)buttonClick:(UIButton*)sender/**< 选中的分类 */
{
    sender.selected = !sender.selected;
    
    if(sender.selected){
        if(_selectedButton == sender){
            UIView *view1 = [WINDOW viewWithTag:1000];
            _selectedButton = nil;
            view1.hidden = YES;
            [self.city remove];
        }else{
            _selectedButton.selected = !_selectedButton.selected;
            self.selectedButton = sender;
            UIView *view1 = [WINDOW viewWithTag:1000];
            view1.hidden = NO;
            _categoryCount = sender.tag;
            
            NSMutableArray *interViewArr = [[NSMutableArray alloc]init];
            NSMutableArray *WageArr = [[NSMutableArray alloc]init];
            NSMutableArray *ExperienceArr = [[NSMutableArray alloc]init];
            NSMutableArray *educationArr = [[NSMutableArray alloc]init];
            NSMutableArray *WelfareArr = [[NSMutableArray alloc]init];
            NSMutableArray *ageArr = [[NSMutableArray alloc]init];
            NSMutableArray *sexArr = [[NSMutableArray alloc]init];
            
            NSArray *interView = @[@"招聘",@"求职"];
            NSArray *interView2 = @[@"EnterpriseRecruitment",@"Interview"];
            NSArray *Wage = @[@"面议",@"1000以下",@"1000-2000",@"2000-3000",@"3000-5000",@"5000-8000",@"8000-12000",@"12000-20000",@"20000以上"];
            NSArray *Experience = @[@"不限",@"一年以下",@"1-2年",@"3-5年",@"6-8年",@"8-10年",@"10年以上"];
            NSArray *education = @[@"不限",@"高中",@"技校",@"中专",@"大专",@"本科",@"硕士",@"博士"];
            NSArray *Welfare = @[@"不限",@"五险一金",@"包吃包住",@"年底双薪",@"周末双休",@"交通补助",@"加班补助"];
            NSArray *age = @[@"不限",@"16-20岁",@"21-25岁",@"26-30岁",@"31-40岁",@"40岁以上"];
            NSArray *sex = @[@"不限",@"男",@"女"];
            for (int i = 0; i < interView.count; i++) {
                IndustryModel *model = [[IndustryModel alloc]init];
                model.industryName = interView[i];
                model.industryID = interView2[i];
                [interViewArr addObject:model];
            }
            for (int i = 0; i < Wage.count; i++) {
                IndustryModel *model = [[IndustryModel alloc]init];
                model.industryName = Wage[i];
                model.industryID = [NSString stringWithFormat:@"%d",i+1];
                [WageArr addObject:model];
            }
            for (int i = 0; i < Experience.count; i++) {
                IndustryModel *model = [[IndustryModel alloc]init];
                model.industryName = Experience[i];
                model.industryID = [NSString stringWithFormat:@"%d",i+1];
                [ExperienceArr addObject:model];
            }
            for (int i = 0; i < education.count; i++) {
                IndustryModel *model = [[IndustryModel alloc]init];
                model.industryName = education[i];
                model.industryID = [NSString stringWithFormat:@"%d",i+1];
                [educationArr addObject:model];
            }
            for (int i = 0; i < Welfare.count; i++) {
                IndustryModel *model = [[IndustryModel alloc]init];
                model.industryName = Welfare[i];
                model.industryID = [NSString stringWithFormat:@"%d",i+1];
                [WelfareArr addObject:model];
            }
            for (int i = 0; i < age.count; i++) {
                IndustryModel *model = [[IndustryModel alloc]init];
                model.industryName = age[i];
                model.industryID = [NSString stringWithFormat:@"%d",i+1];
                [ageArr addObject:model];
            }
            for (int i = 0; i < sex.count; i++) {
                IndustryModel *model = [[IndustryModel alloc]init];
                model.industryName = sex[i];
                model.industryID = [NSString stringWithFormat:@"%d",i+1];
                [sexArr addObject:model];
            }
            switch (sender.tag-10) {
                    //        case 0:
                    //            [self cleanAll];
                    //            break;
                    //        case 0:
                    //            [self.city setLocalData:interViewArr];
                    //            break;
                case 0:/**< 行业 */
                    self.city.isArea = NO;
                    self.city.isIndusty = YES;
                    [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getIndustry",@"fatherid":@"0"}];
                    break;
                case 1:/**< 职位 */
                    self.city.isArea = NO;
                    self.city.isIndusty = NO;
                    [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getPosition",@"fatherid":@"0"}];
                    break;
                case 2:/**< 工资 */
                    [self.city setLocalData:WageArr];
                    break;
                case 3:/**< 经验 */
                    [self.city setLocalData:ExperienceArr];
                    break;
                case 4:/**< 学历 */
                    [self.city setLocalData:educationArr];
                    break;
                case 5:/**< 福利 */
                    [self.city setLocalData:WelfareArr];
                    break;
                case 6:/**< 年龄 */
                    [self.city setLocalData:ageArr];
                    break;
                case 7:/**< 性别 */
                    [self.city setLocalData:sexArr];
                    break;
                case 9:/**< 地区 */
                    self.city.isArea = YES;
                    self.city.isIndusty = NO;
                    [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
                    break;
                default:
                    break;
            }
        }
    }else{
        UIView *view1 = [WINDOW viewWithTag:1000];
        _selectedButton = nil;
        view1.hidden = YES;
        [self.city remove];
    }
}

//-(void)cleanAll
//{
//    _selectBlackView.hidden = YES;
//    _model.action = @"EnterpriseRecruitment";
//    _model.areaID = @"";
//    _model.industryID = @"";
//    _model.Position = @"";
//    _model.Sex = @"1";
//    _model.Wage = @"1";
//    _model.Experience = @"1";
//    _model.Demand = @"1";
//    _model.Welfare = @"1";
//    [self refreshWithIndex:1];
//    NSArray* arrayButtonName = @[ @"全部",@"招聘", @"行业", @"职称", @"性别", @"工资", @"经验",@"需求",@"福利"];
//    for (int i = 1; i < arrayButtonName.count; i++) {
//        UIButton *button = (UIButton *) [self.view viewWithTag:10+i];
//        [button setTitle:arrayButtonName[i] forState:UIControlStateNormal];
//    }
//}

- (void)dismissKeyBoard/**< 键盘消失 */
{
    [self.view endEditing:YES];
}

- (void)chooseAreaClick:(UIButton *)sender
{
    if (!sender.selected) {
        [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
//        _selectBlackView.hidden = NO;
        UIView *view1 = [WINDOW viewWithTag:1000];
        view1.hidden = NO;
//        UIView *view2 = [WINDOW viewWithTag:1001];
//        .hidden = NO;
        _categoryCount = 19;
    }else{
        [self.city remove];
    }
    sender.selected = !sender.selected;
}

-(void)bottomExampleClick:(UIButton *)sender
{
    for (int i = 0; i < 4; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i+30];
        button.selected = NO;
    }
    sender.selected = YES;
    _bottomType = sender.tag-30;
    [self.scrollView setContentOffset:CGPointMake((sender.tag-30)*SCREEN_WIDTH, 0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.indicatorView.left = (sender.tag-30)*SCREEN_WIDTH/4;
    }];
    switch (_bottomType) {
        case 0:
            //if (_isRecruit) {
                //if (self.RecruiListArr.count == 0) {
                    //[self refreshWithIndex:1];
                //}
            //}else{
                if (self.interviewArr.count == 0) {
                    [self refreshWithIndex:1];
                }
            //}
            break;
        case 1:
            //if (_isRecruit) {
                //if (self.RecruiListArr1.count == 0) {
                    //[self refreshWithIndex:1];
                //}
            //}else{
                if (self.interviewArr1.count == 0) {
                    [self refreshWithIndex:1];
                }
            //}
            break;
        case 2:
            //if (_isRecruit) {
                //if (self.RecruiListArr2.count == 0) {
                    //[self refreshWithIndex:1];
                //}
            //}else{
                if (self.interviewArr2.count == 0) {
                    [self refreshWithIndex:1];
                }
            //}
            break;
        case 3:
            //if (_isRecruit) {
                //if (self.RecruiListArr3.count == 0) {
                    //[self refreshWithIndex:1];
                //}
            //}else{
                if (self.interviewArr3.count == 0) {
                    [self refreshWithIndex:1];
                }
            //}
            break;
        default:
            break;
    }
}

#pragma mark - SearchBar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.searchBarTwo resignFirstResponder];
}
//- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar/**< searchBar开始编辑时改变取消按钮的文字 */
//{
//    _searchBarTwo.showsCancelButton = YES;
//    
//    NSArray* subViews;
//
//    if (iOS7) {
//        subViews = [(_searchBarTwo.subviews[0])subviews];
//    }
//    else {
//        subViews = _searchBarTwo.subviews;
//    }
//    for (id view in subViews) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            UIButton* cancelbutton = (UIButton*)view;
//            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
//            break;
//        }
//    }
//}
//
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar*)searchBar
//{
//    //準備搜尋前，把上面調整的TableView調整回全屏幕的狀態
//    self.navigationController.navigationBarHidden = YES;
//
//    CGFloat xPos = searchBar.frame.origin.x;
//    CGFloat yPos = searchBar.frame.origin.y;
//    CGFloat width = searchBar.frame.size.width;
//    CGFloat height = searchBar.frame.size.height;
//    searchBar.frame = CGRectMake(xPos, yPos + 20, width, height);
//
//    CGFloat xPos1 = self.bottomInHeaderView.frame.origin.x;
//    CGFloat yPos1 = self.bottomInHeaderView.frame.origin.y;
//    CGFloat width1 = self.bottomInHeaderView.frame.size.width;
//    CGFloat height1 = self.bottomInHeaderView.frame.size.height;
//    self.bottomInHeaderView.frame = CGRectMake(xPos1, yPos1 + 25, width1, height1);
//
//    return YES;
//}
//
//- (BOOL)searchBarShouldEndEditing:(UISearchBar*)searchBar
//{
//    self.navigationController.navigationBarHidden = NO;
//
//    CGFloat xPos = searchBar.frame.origin.x;
//    CGFloat yPos = searchBar.frame.origin.y;
//    CGFloat width = searchBar.frame.size.width;
//    CGFloat height = searchBar.frame.size.height;
//    searchBar.frame = CGRectMake(xPos, yPos - 20, width, height);
//
//    CGFloat xPos1 = self.bottomInHeaderView.frame.origin.x;
//    CGFloat yPos1 = self.bottomInHeaderView.frame.origin.y;
//    CGFloat width1 = self.bottomInHeaderView.frame.size.width;
//    CGFloat height1 = self.bottomInHeaderView.frame.size.height;
//    self.bottomInHeaderView.frame = CGRectMake(xPos1, yPos1 - 25, width1, height1);
//
//    return YES;
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    self.navigationController.navigationBarHidden = NO;
//    
//    CGFloat xPos = searchBar.frame.origin.x;
//    CGFloat yPos = searchBar.frame.origin.y;
//    CGFloat width = searchBar.frame.size.width;
//    CGFloat height = searchBar.frame.size.height;
//    searchBar.frame = CGRectMake(xPos, yPos - 20, width, height);
//    
//    CGFloat xPos1 = self.bottomInHeaderView.frame.origin.x;
//    CGFloat yPos1 = self.bottomInHeaderView.frame.origin.y;
//    CGFloat width1 = self.bottomInHeaderView.frame.size.width;
//    CGFloat height1 = self.bottomInHeaderView.frame.size.height;
//    self.bottomInHeaderView.frame = CGRectMake(xPos1, yPos1 - 25, width1, height1);
//}
//
//-(void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}
//
//-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//}
//
//- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
//    tableView.rowHeight = 58;
//}
//
//-(void)keyboardWillHide:(NSNotification*)notification {
//    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
//    UIEdgeInsets inset;
//    [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? (inset = UIEdgeInsetsMake(0, 0, height, 0)) : (inset = UIEdgeInsetsZero);
//    [tableView setContentInset:inset];
//    [tableView setScrollIndicatorInsets:inset];
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField*)textField
//{
//    [textField resignFirstResponder];
//    [self.view endEditing:YES];
//    //  [textField resignFirstResponder];
//    return YES;
//}

#pragma mark - 左移偏移线
//- (void)viewDidLayoutSubviews
//{
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
//
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
//    if ([self.tableView1 respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView1 setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
//    
//    if ([self.tableView1 respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView1 setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
//    if ([self.tableView1 respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView1 setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
//    
//    if ([self.tableView2 respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView2 setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
//    if ([self.tableView2 respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView2 setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
//    
//    if ([self.tableView3 respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView3 setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
//    if ([self.tableView4 respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView4 setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
//}

//- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

#pragma mark - UISelectCity
-(void)UISelectDelegate:(IndustryModel *)model
{
    UIView *view1 = [WINDOW viewWithTag:1000];
    _selectedButton.selected = NO;
    _selectedButton = nil;
    view1.hidden = YES;
    [self.city remove];

    UIButton *button = (UIButton *)[self.view viewWithTag:_categoryCount];
    [button setTitle:model.industryName forState:UIControlStateNormal];
    switch (_categoryCount-10) {
//        case 0:/**< 招聘求职 */
//            _model.action = model.industryID;
//            if ([_model.action isEqualToString:@"EnterpriseRecruitment"]) {
//                _isRecruit = 1;
//            }else{
//                _isRecruit = 0;
//            }
//            
//            break;
        case 0:/**< 行业 */
            _model.industryID = model.industryID;
            break;
        case 1:/**< 职称 */
            _model.Position = model.industryID;
            break;
        case 2:/**< 工资 */
            _model.Wage = model.industryID;
            if ([model.industryName isEqualToString:@"面议"]) {
                [button setTitle:@"工资" forState:UIControlStateNormal];
            }
            break;
        case 3:/**< 经验 */
            _model.Experience = model.industryID;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"经验" forState:UIControlStateNormal];
            }
            break;
        case 4:/**< 学历 */
            _model.education = model.industryName;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"学历" forState:UIControlStateNormal];
            }
            break;
        case 5:/**< 福利 */
            _model.Welfare = model.industryID;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"福利" forState:UIControlStateNormal];
            }
            break;
        case 6:/**< 年龄 */
            _model.age = model.industryName;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"年龄" forState:UIControlStateNormal];
            }
            break;
        case 7:/**< 性别 */
            _model.Sex = model.industryID;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"性别" forState:UIControlStateNormal];
            }
            break;
        case 8:/**< 区域 */
            _buttonArea.selected = NO;
            [_buttonArea setTitle:model.industryName forState:UIControlStateNormal];
            _model.areaID = model.industryID;
            break;
        default:
            break;
    }
    [self refreshWithIndex:1];
}

//点击消失背景
-(void)touchHide:(UITapGestureRecognizer *)tap
{
//    _selectBlackView.hidden = YES;
//    UIView *view1 = [WINDOW viewWithTag:1000];
//    view1.hidden = YES;
//    UIView *view2 = [WINDOW viewWithTag:1001];
//    view2.hidden = YES;
//    [self.city remove];
//    _buttonArea.selected = NO;
    
    UIView *view1 = [WINDOW viewWithTag:1000];
    _selectedButton.selected = NO;
    _selectedButton = nil;
    view1.hidden = YES;
    [self.city remove];
    
}

#pragma mark - WPActionSheet
//-(void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
    //if (buttonIndex == 1) {
        //NSLog(@"招聘简历");
        //WPRecruitController *recuilist = [[WPRecruitController alloc]init];
        //recuilist.title = @"招聘简历";
        //recuilist.model = nil;
        //recuilist.delegate = self;
        //[self.navigationController pushViewController:recuilist animated:YES];
    //}
    //if (buttonIndex == 2) {
        //NSLog(@"求职简历");
        
        //WPInterviewController *interview = [[WPInterviewController alloc]init];
        //interview.title = @"求职简历";
        //interview.delegate = self;
        //if (![_userModel.resumeUserId isEqualToString:@"0"]) {
            //interview.model = _userModel;
        //}
        //[self.navigationController pushViewController:interview animated:YES];
    //}
//}

- (void)WPInterviewControllerDelegate{
    
    //if (!_isRecruit) {
        [self refreshWithIndex:1];
        [self refreshWithIndex:2];
        [self refreshWithIndex:3];
        [self refreshWithIndex:4];
    //}
}

//- (void)WPRecuilistControllerDelegate{
    //if (_isRecruit) {
        //[self refreshWithIndex:1];
        //[self refreshWithIndex:2];
        //[self refreshWithIndex:3];
        //[self refreshWithIndex:4];
    //}
//}

-(void)menuItem:(id)sender
{
    //if (_isRecruit) {
        //WPRecruitApplyController *apply = [[WPRecruitApplyController alloc] init];
        //apply.sid = self.selectedModel.jobId;
        //[self.navigationController pushViewController:apply animated:YES];
    //}else{
        WPInterviewApplyController *apply = [[WPInterviewApplyController alloc] init];
        apply.sid = self.selectedModel.jobId;
        [self.navigationController pushViewController:apply animated:YES];
    //}
}

-(void)menuItem2:(id)sender
{
    //可实现自定义功能
    NSString *url  = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    
    NSDictionary *dic = @{@"action":@"ResumeCollect",
                          @"user_id":kShareModel.userId,
                          @"username":kShareModel.username,
                          @"password":kShareModel.password,
                          @"resume_id":self.selectedModel.jobId};
    
    [WPHttpTool postWithURL:url params:dic success:^(id json) {
        [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)menuItem3:(id)sender
{
    //可实现自定义功能
//    [YYShareManager shareWithTitle:@"这是title" url:@"" action:^(YYShareManagerType type) {
//        if (type == YYShareManagerTypeWeiPinFriends) {
//            
//        }
//        if (type == YYShareManagerTypeWorkLines) {
//            
//        }
//    } status:^(UMSResponseCode status) {
//        if (status == UMSResponseCodeSuccess) {
//            
//        }
//    }];

}

-(void)menuItem4:(id)sender
{
    _collectionViewEditing = YES;
    //可实现自定义功能
    switch (_bottomType) {
        case 0:
            self.tableView.editing = YES;
            [self.collectionView reloadData];
            break;
        case 1:
            self.tableView1.editing = YES;
            [self.collectionView1 reloadData];
            break;
        case 2:
            self.tableView2.editing = YES;
            [self.collectionView2 reloadData];
            break;
        default:
            break;
    }
    
    _button.hidden = YES;
    _button1.hidden = YES;
    self.editBottomView.hidden = NO;
    self.scrollView.scrollEnabled = NO;
}

//长按后触发该方法
-(void)longPressWebView:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //判断长按状态
    if ([gestureRecognizer state]==UIGestureRecognizerStateBegan)
    {
        //得到按的cell
        UITableViewCell *cell = (UITableViewCell *)gestureRecognizer.view;
        if (_bottomType == 0) {
            //处理选中问题
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
            [self.tableView selectRowAtIndexPath:[self.tableView indexPathForCell:cell] animated:NO scrollPosition:UITableViewScrollPositionNone];
           
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            self.selectedModel = self.interviewArr[indexPath.row];
        }
        if (_bottomType == 1) {
            //处理选中问题
            [self.tableView1 deselectRowAtIndexPath:[self.tableView1 indexPathForSelectedRow] animated:NO];
            [self.tableView1 selectRowAtIndexPath:[self.tableView1 indexPathForCell:cell] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            NSIndexPath *indexPath = [self.tableView1 indexPathForCell:cell];
            self.selectedModel = self.interviewArr1[indexPath.row];
        }
        if (_bottomType == 2) {
            //处理选中问题
            [self.tableView2 deselectRowAtIndexPath:[self.tableView2 indexPathForSelectedRow] animated:NO];
            [self.tableView2 selectRowAtIndexPath:[self.tableView2 indexPathForCell:cell] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            NSIndexPath *indexPath = [self.tableView2 indexPathForCell:cell];
            self.selectedModel = self.interviewArr2[indexPath.row];
        }
        
        //必须设置为第一响应者
        [cell becomeFirstResponder];
        
        //得到菜单栏
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuVisible:NO];
        //设置菜单
        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"抢" action:@selector(menuItem:)];
        UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(menuItem2:)];
        UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"分享" action:@selector(menuItem3:)];
        UIMenuItem *menuItem4 = [[UIMenuItem alloc] initWithTitle:@"更多..." action:@selector(menuItem4:)];
        [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem2,menuItem3,menuItem4, nil]];
        //设置菜单栏位置
        [menuController setTargetRect:cell.frame inView:cell.superview];
        
        //self.cellString = @"";
        //self.cellString = cell.textLabel.text;
        //显示菜单栏
        [menuController setMenuVisible:YES animated:YES];
    
    }
}

#pragma mark - UIGestureDelegate
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

////哪些菜单能够显示
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
    //if (action == @selector(menuItem:) || action == @selector(menuItem2:))
    //{
        //return YES;
    //}
    //else
    //{
        //return NO;
    //}
//}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //if (_isRecruit) {
        //switch (_bottomType) {
            //case 0:
                 //[tableView tableViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr.count];
                //return self.RecruiListArr.count;
            //case 1:
                //[tableView tableViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr1.count];
                //return self.RecruiListArr1.count;
            //case 2:
                //[tableView tableViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr2.count];
                //return self.RecruiListArr2.count;
            //case 3:
                //[tableView tableViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr3.count];
                //return self.RecruiListArr3.count;
            //default:
                //return 0;
        //}
    //}else{
        switch (_bottomType) {
            case 0:
                [tableView tableViewDisplayWitMsg:@"没有查询到求职信息" ifNecessaryForRowCount:self.interviewArr.count];
                return self.interviewArr.count;
            case 1:
                [tableView tableViewDisplayWitMsg:@"没有查询到求职信息" ifNecessaryForRowCount:self.interviewArr1.count];
                return self.interviewArr1.count;
            case 2:
                [tableView tableViewDisplayWitMsg:@"没有查询到求职信息" ifNecessaryForRowCount:self.interviewArr2.count];
                return self.interviewArr2.count;
            case 3:
                [tableView tableViewDisplayWitMsg:@"没有查询到求职信息" ifNecessaryForRowCount:self.interviewArr3.count];
                return self.interviewArr3.count;
            default:
                return 0;
        }
    //}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kHEIGHT(58);
}


- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (tableView == self.tableView4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        return cell;
    }else{
        //if (_isRecruit) {/**< 招聘 */
            //WPRecruitTCell *cell = [WPRecruitTCell cellWithTableView:tableView];
            ////        [cell setModel:self.RecruiListArr[indexPath.row]];
            //cell.path = indexPath;
            //cell.cellIndexPathClick = ^(NSIndexPath *path){
                //[weakSelf tableView:path];
            //};
            //cell.detailBlock = ^(NSIndexPath *path){
                //[weakSelf detailActions:path];
            //};
            //switch (_bottomType) {
                //case 0:
                    //if (tableView == _tableView) {
                        //cell.model = self.RecruiListArr[indexPath.row];
                    //}
                    //break;
                //case 1:
                    //if (tableView == _tableView1) {
                        //cell.model = self.RecruiListArr1[indexPath.row];
                    //}
                    //break;
                //case 2:
                    //if (tableView == _tableView2) {
                        //cell.model = self.RecruiListArr2[indexPath.row];
                    //}
                    //break;
                //case 3:
                    //if (tableView == _tableView3) {
                        //cell.model = self.RecruiListArr3[indexPath.row];
                    //}
                    //break;
                //case 0:
                        //cell.model = self.RecruiListArr[indexPath.row];
                    //break;
                //case 1:
                        //cell.model = self.RecruiListArr1[indexPath.row];
                    //break;
                //case 2:
                        //cell.model = self.RecruiListArr2[indexPath.row];
                    //break;
                //case 3:
                        //cell.model = self.RecruiListArr3[indexPath.row];
                    //break;
                //default:
                    //break;
            //}
            //if (_bottomType != 3) {
                ////注册长按事件
                //UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWebView:)];
                //[longPressGesture setDelegate:self];
                ////添加到cell
                //[cell addGestureRecognizer:longPressGesture];
            //}
            
            //return cell;
        //}else{/**< 求职 */
            WPInterViewTCell *cell = [WPInterViewTCell cellWithTableView:tableView];
            //        [cell setModel:self.interviewArr[indexPath.row]];
            cell.path = indexPath;
            cell.cellIndexPathClick = ^(NSIndexPath *path){
                [weakSelf tableView:path];
            };
            switch (_bottomType) {
                case 0:
                    if (tableView == _tableView) {
                        cell.model = self.interviewArr[indexPath.row];
                    }
                    break;
                case 1:
                    if (tableView == _tableView1) {
                        cell.model = self.interviewArr1[indexPath.row];
                    }
                    break;
                case 2:
                    if (tableView == _tableView2) {
                        cell.model = self.interviewArr2[indexPath.row];
                    }
                    break;
                case 3:
                    if (tableView == _tableView3) {
                        cell.model = self.interviewArr3[indexPath.row];
                    }
                    break;
                default:
                    break;
            }
        
            
        
            if (_bottomType != 3) {
                //注册长按事件
                UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWebView:)];
                [longPressGesture setDelegate:self];
                //添加到cell
                [cell addGestureRecognizer:longPressGesture];
            }
            
            return cell;
        //}
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableView.editing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NearInterViewController *interView = [[NearInterViewController alloc]init];
        //    [interView createBackButtonWithPushType:Push];
        interView.isRecuilist = NO;
        [self.navigationController pushViewController:interView animated:YES];
        //if (_isRecruit) {
            //NSLog(@"招聘");
            //WPRecruitListModel *model = [[WPRecruitListModel alloc]init];;
            //switch (_bottomType) {
                //case 0:
                    //model = self.RecruiListArr[indexPath.row];
                    //break;
                //case 1:
                    //model = self.RecruiListArr1[indexPath.row];
                    //break;
                //case 2:
                    //model = self.RecruiListArr2[indexPath.row];
                    //break;
                //case 3:
                    //model = self.RecruiListArr3[indexPath.row];
                    //break;
                //default:
                    //break;
            //}
            
            //interView.subId = model.sid;
            //WPShareModel *shareModel = [WPShareModel sharedModel];
            //interView.isSelf = [model.userId isEqualToString:shareModel.dic[@"userid"]];
            //interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,model.sid,kShareModel.userId];
        //}else{
            NSLog(@"求职");
            WPInterviewListModel *model = [[WPInterviewListModel alloc]init];
            switch (_bottomType) {
                case 0:
                    model = self.interviewArr[indexPath.row];
                    break;
                case 1:
                    model = self.interviewArr1[indexPath.row];
                    break;
                case 2:
                    model = self.interviewArr2[indexPath.row];
                    break;
                case 3:
                    model = self.interviewArr3[indexPath.row];
                    break;
                default:
                    break;
            }
            interView.subId = model.jobId;
            interView.userId = model.userId;
            WPShareModel *shareModel = [WPShareModel sharedModel];
            interView.isSelf = [model.userId isEqualToString:shareModel.dic[@"userid"]];
            interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,model.jobId,kShareModel.userId];
        //}
    }else{
        WPInterviewListModel *model = [[WPInterviewListModel alloc]init];
        switch (_bottomType) {
            case 0:
                model = self.interviewArr[indexPath.row];
                break;
            case 1:
                model = self.interviewArr1[indexPath.row];
                break;
            case 2:
                model = self.interviewArr2[indexPath.row];
                break;
            case 3:
                model = self.interviewArr3[indexPath.row];
                break;
            default:
                break;
        }
        
        [self.selectedArray addObject:model];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    WPInterviewListModel *model = [[WPInterviewListModel alloc]init];
    switch (_bottomType) {
        case 0:
            model = self.interviewArr[indexPath.row];
            break;
        case 1:
            model = self.interviewArr1[indexPath.row];
            break;
        case 2:
            model = self.interviewArr2[indexPath.row];
            break;
        case 3:
            model = self.interviewArr3[indexPath.row];
            break;
        default:
            break;
    }
    
    for (WPInterviewListModel *listModel in self.selectedArray) {
        if ([listModel.jobId isEqualToString:model.jobId]) {
            [self.selectedArray removeObject:listModel];
            break;
        }
    }
}

-(void)tableView:(NSIndexPath *)indexPath
{
    //NearPersonalController *vc = [[NearPersonalController alloc]init];
    //[self.navigationController pushViewController:vc animated:YES];
    //vc.isRecruit = _isRecruit;
    //if (_isRecruit) {
        //switch (_bottomType) {
            //case 0:
                //vc.userId = [self.RecruiListArr[indexPath.row] userId];
                //break;
            //case 1:
                //vc.userId = [self.RecruiListArr1[indexPath.row] userId];
                //break;
            //case 2:
                //vc.userId = [self.RecruiListArr2[indexPath.row] userId];
                //break;
            //case 3:
                //vc.userId = [self.RecruiListArr3[indexPath.row] userId];
                //break;
            //default:
                //break;
        //}
    //}else{
        //switch (_bottomType) {
            //case 0:
                //vc.userId = [self.interviewArr[indexPath.row] userId];
                //break;
            //case 1:
                //vc.userId = [self.interviewArr1[indexPath.row] userId];
                //break;
            //case 2:
                //vc.userId = [self.interviewArr2[indexPath.row] userId];
                //break;
            //case 3:
                //vc.userId = [self.interviewArr3[indexPath.row] userId];
                //break;
            //default:
                //break;
        //}
    //}
    //WPShareModel *shareModel = [WPShareModel sharedModel];
    //vc.isSelf = [shareModel.dic[@"userid"] isEqualToString:vc.userId];
}

- (void)detailActions:(NSIndexPath *)indexPath
{
    NearInterViewController *interView = [[NearInterViewController alloc]init];
    interView.isRecuilist = 2;
    [self.navigationController pushViewController:interView animated:YES];
    //if (_isRecruit) {
        //NSLog(@"招聘");
        //WPRecruitListModel *model = [[WPRecruitListModel alloc]init];;
        //switch (_bottomType) {
            //case 0:
                //model = self.RecruiListArr[indexPath.row];
                //break;
            //case 1:
                //model = self.RecruiListArr1[indexPath.row];
                //break;
            //case 2:
                //model = self.RecruiListArr2[indexPath.row];
                //break;
            //case 3:
                //model = self.RecruiListArr3[indexPath.row];
                //break;
            //default:
                //break;
        //}
        //interView.subId = model.epId;
        //WPShareModel *shareModel = [WPShareModel sharedModel];
        //interView.isSelf = [model.userId isEqualToString:shareModel.dic[@"userid"]];
        //interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/recruitCompany.aspx?ep_id=%@&user_id=%@",IPADDRESS,model.epId,kShareModel.userId];
    //}
    //else{
        //NSLog(@"求职");
        //WPInterviewListModel *model = [[WPInterviewListModel alloc]init];
        //switch (_bottomType) {
            //case 0:
                //model = self.interviewArr[indexPath.row];
                //break;
            //case 1:
                //model = self.interviewArr1[indexPath.row];
                //break;
            //case 2:
                //model = self.interviewArr2[indexPath.row];
                //break;
            //case 3:
                //model = self.interviewArr3[indexPath.row];
                //break;
            //default:
                //break;
        //}
        //interView.subId = model.jobId;
    //}
}

#pragma mark - CollectonView data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //if (_isRecruit) {
        //return self.RecruiListArr.count;
    //}else{
        //return self.interviewArr.count;
    //}
    //if (_isRecruit) {
        //switch (_bottomType) {
            //case 0:
                //[collectionView collectionViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr.count];
                //return self.RecruiListArr.count;
            //case 1:
                //[collectionView collectionViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr1.count];
                //return self.RecruiListArr1.count;
            //case 2:
                //[collectionView collectionViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr2.count];
                //return self.RecruiListArr2.count;
            //case 3:
                //[collectionView collectionViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr3.count];
                //return self.RecruiListArr3.count;
            //default:
                //return 0;
        //}
    //}else{
        switch (_bottomType) {
            case 0:
                [collectionView collectionViewDisplayWitMsg:@"没有查询到求职信息" ifNecessaryForRowCount:self.interviewArr.count];
                return self.interviewArr.count;
            case 1:
                [collectionView collectionViewDisplayWitMsg:@"没有查询到求职信息" ifNecessaryForRowCount:self.interviewArr1.count];
                return self.interviewArr1.count;
            case 2:
                [collectionView collectionViewDisplayWitMsg:@"没有查询到求职信息" ifNecessaryForRowCount:self.interviewArr2.count];
                return self.interviewArr2.count;
            case 3:
                [collectionView collectionViewDisplayWitMsg:@"没有查询到求职信息" ifNecessaryForRowCount:self.interviewArr3.count];
                return self.interviewArr3.count;
            default:
                return 0;
        }
    //}
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //if (_isRecruit) {
        //WPRecruitCell *cell = [WPRecruitCell cellWithCellectionView:collectionView indexPath:indexPath];
        //[cell setModel:self.RecruiListArr[indexPath.row]];
        //cell.model = self.RecruiListArr[indexPath.row];
        //switch (_bottomType) {
            //case 0:
                //cell.model = self.RecruiListArr[indexPath.row];
                //break;
            //case 1:
                //cell.model = self.RecruiListArr1[indexPath.row];
                //break;
            //case 2:
                //cell.model = self.RecruiListArr2[indexPath.row];
                //break;
            //case 3:
                //cell.model = self.RecruiListArr3[indexPath.row];
                //break;
            //default:
                //break;
        //}

        //return cell;
    //}else{
        WPInterviewCell *cell = [WPInterviewCell cellWithCellectionView:collectionView indexPath:indexPath];
        //[cell setModel:self.interviewArr[indexPath.row]];
        //cell.model = self.interviewArr[indexPath.row];
        switch (_bottomType) {
            case 0:
                cell.model = self.interviewArr[indexPath.row];
                break;
            case 1:
                cell.model = self.interviewArr1[indexPath.row];
                break;
            case 2:
                cell.model = self.interviewArr2[indexPath.row];
                break;
            case 3:
                cell.model = self.interviewArr3[indexPath.row];
                break;
            default:
                break;
        }
    
    cell.selectedImageView.hidden = !_collectionViewEditing;
    
    if (_bottomType != 3) {
        //注册长按事件
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWebView:)];
        [longPressGesture setDelegate:self];
        //添加到cell
        [cell addGestureRecognizer:longPressGesture];
    }
    
        return cell;
    //}
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int width = 0;
    if (SCREEN_WIDTH == 320) {
        width = 320;
    }
    if (SCREEN_WIDTH == 375) {
        width = 376;
    }
    if (SCREEN_WIDTH == 414) {
        width = 416;
    }
    
    return CGSizeMake(width/4, width/4);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    WPInterviewListModel *model = [[WPInterviewListModel alloc]init];
    switch (_bottomType) {
        case 0:
            model = self.interviewArr[indexPath.row];
            break;
        case 1:
            model = self.interviewArr1[indexPath.row];
            break;
        case 2:
            model = self.interviewArr2[indexPath.row];
            break;
        case 3:
            model = self.interviewArr3[indexPath.row];
            break;
        default:
            break;
    }
    
    if (!_collectionViewEditing) {
        NSLog(@"求职");
        NearInterViewController *interView = [[NearInterViewController alloc]init];
        interView.isRecuilist = NO;
        [self.navigationController pushViewController:interView animated:YES];

        interView.subId = model.jobId;
        interView.userId = model.userId;
        WPShareModel *shareModel = [WPShareModel sharedModel];
        interView.isSelf = [model.userId isEqualToString:shareModel.dic[@"userid"]];
        interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,model.jobId,kShareModel.userId];
    }else{
        
        if (model.isSelected) {
            for (WPInterviewListModel *listModel in self.selectedArray) {
                if ([listModel.jobId isEqualToString:model.jobId]) {
                    [self.selectedArray removeObject:listModel];
                    break;
                }
            }
        }else{
            [self.selectedArray addObject:model];
        }
        
        model.isSelected = !model.isSelected;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView == self.scrollView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.indicatorView.left = targetContentOffset->x/4;
        }];
        _bottomType = targetContentOffset->x/SCREEN_WIDTH;
        for (int i = 0; i < 4; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:30+i];
            button.selected = (i == _bottomType?YES:NO);
        }
        switch (_bottomType) {
            case 0:
                //if (_isRecruit) {
                    //if (self.RecruiListArr.count == 0) {
                        //[self refreshWithIndex:1];
                    //}
                //}else{
                    if (self.interviewArr.count == 0) {
                        [self refreshWithIndex:1];
                    }
                //}
                break;
            case 1:
                //if (_isRecruit) {
                    //if (self.RecruiListArr1.count == 0) {
                        //[self refreshWithIndex:1];
                    //}
                //}else{
                    if (self.interviewArr1.count == 0) {
                        [self refreshWithIndex:1];
                    }
                //}
                break;
            case 2:
                //if (_isRecruit) {
                    //if (self.RecruiListArr2.count == 0) {
                        //[self refreshWithIndex:1];
                    //}
                //}else{
                    if (self.interviewArr2.count == 0) {
                        [self refreshWithIndex:1];
                    }
                //}
                break;
            case 3:
                //if (_isRecruit) {
                    //if (self.RecruiListArr3.count == 0) {
                        //[self refreshWithIndex:1];
                    //}
                //}else{
                    if (self.interviewArr3.count == 0) {
                        [self refreshWithIndex:1];
                    }
                //}
                break;
            default:
                break;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end

@implementation NearCategoryModel

@end