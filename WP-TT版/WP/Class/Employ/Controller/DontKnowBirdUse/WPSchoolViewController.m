//
//  WPSchoolViewController.m
//  WP
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPSchoolViewController.h"

#import "WPNearController.h"
#import "WPInterviewController.h"
#import "WPSearchBar.h"
#import "WPRecruitTCell.h"
#import "WPRecruitCell.h"
#import "WPActionSheet.h"
#import "UISelectCity.h"
#import "SPSelectView.h"
#import "MJRefresh.h"
#import "WPUserListModel.h"
#import "WPSchoolRecruitModel.h"
#import "UITableView+EmptyData.h"
#import "UICollectionView+EmptyData.h"

#import "WPPeopleConnectionViewController.h"
#import "NearInterViewController.h"
#import "WPRecruitController.h"
#import "WPAllSearchController.h"
#import "YYShareManager.h"
#import "RecentPersonController.h"
#import "WPRecruitApplyController.h"

@interface WPSchoolViewController () <UITextFieldDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITabBarDelegate, UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,WPActionSheet,UISelectDelegate,WPRecuilistControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSMutableArray *RecruiListArr;/**< 招聘 */
@property (nonatomic, strong) NSMutableArray *RecruiListArr1;/**< 招聘 */
@property (nonatomic, strong) NSMutableArray *RecruiListArr2;/**< 招聘 */
@property (nonatomic, strong) NSMutableArray *RecruiListArr3;/**< 招聘 */
@property (nonatomic, strong) NSMutableArray *RecruiListArr4;/**< 招聘 */

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

@property (nonatomic, strong) WPActionSheet *actionSheet;

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

@property (nonatomic, strong) WPRecruitListModel *selectedModel;

@property (strong, nonatomic) NSMutableArray *selectedArray;

@property (assign, nonatomic) BOOL collectionViewEditing;

@end

@implementation WPSchoolViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.edgesForExtendedLayout = UIRectEdgeAll;/**<  边缘延伸布局 */

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
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bottomInHeaderView.height-0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(226, 226, 226);
    [self.bottomInHeaderView addSubview:line];
    
    [self setUpGesture];
    [self setNavbarItem];
    
    _model = [[NearCategoryModel alloc]init];
    _model.action = @"CampusRecruitment";
    _model.areaID = @"";
    _model.industryID = @"";
    _model.Position = @"";
    _model.Sex = @"1";
    _model.Wage = @"1";
    _model.education = @"";
    _model.Welfare = @"1";
    _model.age = @"";
    [self refreshWithIndex:1];
    [self getDefaultCompany];
    [self getDefaultResume];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WPRecuilistControllerDelegate) name:@"kNotificationRecruitRefreshList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WPRecuilistControllerDelegate) name:@"kNotificationDeleteResume" object:nil];
}

#pragma mark - 初始化数组
- (WPRecruitListModel *)selectedModel{
    if (!_selectedModel) {
        _selectedModel = [[WPRecruitListModel alloc]init];
    }
    return _selectedModel;
}

- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc]init];
    }
    return _selectedArray;
}
-(NSMutableArray *)RecruiListArr
{
    if (!_RecruiListArr) {
        _RecruiListArr = [[NSMutableArray alloc]init];
    }
    return _RecruiListArr;
}

-(NSMutableArray *)RecruiListArr1
{
    if (!_RecruiListArr1) {
        _RecruiListArr1 = [[NSMutableArray alloc]init];
    }
    return _RecruiListArr1;
}

-(NSMutableArray *)RecruiListArr2
{
    if (!_RecruiListArr2) {
        _RecruiListArr2 = [[NSMutableArray alloc]init];
    }
    return _RecruiListArr2;
}

-(NSMutableArray *)RecruiListArr3
{
    if (!_RecruiListArr3) {
        _RecruiListArr3 = [[NSMutableArray alloc]init];
    }
    return _RecruiListArr3;
}

#pragma mark - 初始化子视图
- (void)setUpGesture/**< 设置点击取消手势 */
{
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)setNavbarItem/**< 初始化导航栏 */
{
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button1.frame = CGRectMake(0, 0, 35, 22);
    _button1.titleLabel.font = kFONT(14);
    [_button1 setTitle:@"创建" forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_button1 addTarget:self action:@selector(rightBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
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
                [unself.RecruiListArr removeAllObjects];
                [unself.RecruiListArr addObjectsFromArray:datas];
                [unself.tableView reloadData];
                [unself.collectionView reloadData];
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
                    [unself.RecruiListArr addObjectsFromArray:datas];
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
        [_collectionView registerClass:[WPRecruitCell class] forCellWithReuseIdentifier:@"WPRecruitCell"];
        _collectionView.hidden = YES;
        __weak __typeof(self) unself = self;
        
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.collectionView.mj_footer resetNoMoreData];
            [unself.tableView.mj_footer resetNoMoreData];
            _pageNumber = 1;
            [unself requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                [unself.RecruiListArr removeAllObjects];
                [unself.RecruiListArr addObjectsFromArray:datas];
                [unself.collectionView reloadData];
                [unself.tableView reloadData];
                
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
                    [unself.RecruiListArr addObjectsFromArray:datas];
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
                [unself.RecruiListArr1 removeAllObjects];
                [unself.RecruiListArr1 addObjectsFromArray:datas];
                [unself.tableView1 reloadData];
                [unself.collectionView1 reloadData];
                if (unself.RecruiListArr1.count == 0) {
                    //                        [MBProgressHUD createHUD:@"没有招聘信息" View:self.view];
                }
                
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
                    [unself.RecruiListArr1 addObjectsFromArray:datas];
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
        [_collectionView1 registerClass:[WPRecruitCell class] forCellWithReuseIdentifier:@"WPRecruitCell"];
        _collectionView1.hidden = YES;
        __weak __typeof(self) unself = self;
        
        self.collectionView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.collectionView1.mj_footer resetNoMoreData];
            [unself.tableView1.mj_footer resetNoMoreData];
            _pageNumber1 = 1;
            [unself requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                [unself.RecruiListArr1 removeAllObjects];
                [unself.RecruiListArr1 addObjectsFromArray:datas];
                [unself.collectionView1 reloadData];
                [unself.tableView1 reloadData];
        
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
                    [unself.RecruiListArr1 addObjectsFromArray:datas];
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
                [unself.RecruiListArr2 removeAllObjects];
                [unself.RecruiListArr2 addObjectsFromArray:datas];
                [unself.tableView2 reloadData];
                [unself.collectionView2 reloadData];
                
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
                    [unself.RecruiListArr2 addObjectsFromArray:datas];
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
        [_collectionView2 registerClass:[WPRecruitCell class] forCellWithReuseIdentifier:@"WPRecruitCell"];
        _collectionView2.hidden = YES;
        __weak __typeof(self) unself = self;
        
        self.collectionView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.collectionView2.mj_footer resetNoMoreData];
            [unself.tableView2.mj_footer resetNoMoreData];
            _pageNumber2 = 1;
            [unself requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                [unself.RecruiListArr2 removeAllObjects];
                [unself.RecruiListArr2 addObjectsFromArray:datas];
                [unself.collectionView2 reloadData];
                [unself.tableView2 reloadData];
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
                    [unself.RecruiListArr2 addObjectsFromArray:datas];
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
                [unself.RecruiListArr3 removeAllObjects];
                [unself.RecruiListArr3 addObjectsFromArray:datas];
                [unself.tableView3 reloadData];
                [unself.collectionView3 reloadData];
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
                    [unself.RecruiListArr3 addObjectsFromArray:datas];
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
        [_collectionView3 registerClass:[WPRecruitCell class] forCellWithReuseIdentifier:@"WPRecruitCell"];
        _collectionView3.hidden = YES;
        __weak __typeof(self) unself = self;
        
        self.collectionView3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.collectionView3.mj_footer resetNoMoreData];
            [unself.tableView3.mj_footer resetNoMoreData];
            _pageNumber3 = 1;
            [unself requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                [unself.RecruiListArr3 removeAllObjects];
                [unself.RecruiListArr3 addObjectsFromArray:datas];
                [unself.collectionView3 reloadData];
                [unself.tableView3 reloadData];
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
                    [unself.RecruiListArr3 addObjectsFromArray:datas];
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
                [unself.RecruiListArr4 removeAllObjects];
                [unself.RecruiListArr4 addObjectsFromArray:datas];
                [unself.tableView4 reloadData];
                [unself.collectionView4 reloadData];
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
                    [unself.RecruiListArr4 addObjectsFromArray:datas];
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
        [_collectionView4 registerClass:[WPRecruitCell class] forCellWithReuseIdentifier:@"WPRecruitCell"];
        _collectionView4.hidden = YES;
        __weak __typeof(self) unself = self;
        
        self.collectionView4.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.collectionView4.mj_footer resetNoMoreData];
            [unself.tableView4.mj_footer resetNoMoreData];
            _pageNumber4 = 1;
            [unself requestWithPageIndex:1 Success:^(NSArray *datas, int more) {

                [unself.RecruiListArr4 removeAllObjects];
                [unself.RecruiListArr4 addObjectsFromArray:datas];
                [unself.tableView4 reloadData];
                [unself.collectionView4 reloadData];
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
                    [unself.RecruiListArr4 addObjectsFromArray:datas];
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
        
        NSArray* arrayButtonName = @[@"行业", @"职称", @"工资",@"学历",@"福利",@"年龄", @"性别"];
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

-(WPActionSheet *)actionSheet
{
    if (!_actionSheet) {
        _actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"招聘简历",@"求职简历"] imageNames:nil top:64];
        __weak typeof(self) unself = self;
        _actionSheet.touchToHide = ^(){
            [unself hideRightBlack];
        };
    }
    return _actionSheet;
}

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
            button.selected = i==0?1:0;
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

- (UIView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-3, SCREEN_WIDTH/4, 3)];
        _indicatorView.backgroundColor = RGB(10, 110, 210);
    }
    return _indicatorView;
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
    for (WPRecruitListModel *model in self.selectedArray) {
        str = [NSString stringWithFormat:@"%@%@%@",str,model.sid,SEPARATOR];
    }
    
    if (sender.tag == 40) {
        if (self.selectedArray.count == 0) {
            [SPAlert alertControllerWithTitle:@"提示" message:@"请至少选择一个简历！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
        }else{
            WPRecruitApplyController *apply = [[WPRecruitApplyController alloc] init];
            apply.sid = str;
            [self.navigationController pushViewController:apply animated:YES];
        }
    }
    
    if (sender.tag == 41) {
        
        if (self.selectedArray.count == 0) {
            [SPAlert alertControllerWithTitle:@"提示" message:@"请至少选择一个简历！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
        }else{
            NSString *url  = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
            
            NSDictionary *dic = @{@"action":@"JobCollect",
                                  @"user_id":kShareModel.userId,
                                  @"username":kShareModel.username,
                                  @"password":kShareModel.password,
                                  @"job_id":str};
            
            [WPHttpTool postWithURL:url params:dic success:^(id json) {
                [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
            } failure:^(NSError *error) {
                NSLog(@"%@",error.localizedDescription);
            }];
        }
    }
    if (sender.tag == 42) {
#pragma mark  无用
//        if (self.selectedArray.count == 0) {
//            [SPAlert alertControllerWithTitle:@"提示" message:@"请至少选择一个简历！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
//        }
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
    [_actionSheet hideFromView:self.view];
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
                             @"Demand":@"1",
                             @"education":_model.education,
                             @"Welfare":_model.Welfare,
                             @"age":_model.age,
                             @"page":[NSString stringWithFormat:@"%d",pageIndex]};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPRecruitModel *recruitModel = [WPRecruitModel mj_objectWithKeyValues:json];
        NSArray *arr = [[NSArray alloc]initWithArray:recruitModel.list];
        success(arr,(int)arr.count);
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
                for (WPRecruitListModel *model in self.RecruiListArr) {
                    model.isSelected = NO;
                }
                [self.collectionView reloadData];
                break;
            case 1:
                for (WPRecruitListModel *model in self.RecruiListArr1) {
                    model.isSelected = NO;
                }
                [self.collectionView1 reloadData];
                break;
            case 2:
                for (WPRecruitListModel *model in self.RecruiListArr2) {
                    model.isSelected = NO;
                }
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

-(void)rightBarButtonItemClick:(UIButton *)sender/**< 右按钮创建 */
{
    WPRecruitController *recuilist = [[WPRecruitController alloc]init];
    recuilist.title = @"招聘简历";
    recuilist.model = nil;
    recuilist.delegate = self;
    [self.navigationController pushViewController:recuilist animated:YES];
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
            
            switch (sender.tag-10) {
                case 0:/**< 行业 */
                    [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getIndustry",@"fatherid":@"0"}];
                    self.city.isIndusty = YES;
                    break;
                case 1:/**< 职位 */
                    [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getPosition",@"fatherid":@"0"}];
                    self.city.isIndusty = NO;
                    break;
                case 2:/**< 工资 */
                    [self.city setLocalData:[SPLocalApplyArray salaryArray]];
                    break;
                case 3:/**< 学历 */
                    [self.city setLocalData:[SPLocalApplyArray educationArray]];
                    break;
                case 4:/**< 福利 */
                    [self.city setLocalData:[SPLocalApplyArray welfareArray]];
                    break;
                case 5:/**< 年龄 */
                    [self.city setLocalData:[SPLocalApplyArray ageArray]];
                    break;
                case 6:/**< 性别 */
                    [self.city setLocalData:[SPLocalApplyArray sexWithNoLimitArray]];
                    break;
                case 9:/**< 地区 */
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
            if (self.RecruiListArr.count == 0) {
                [self refreshWithIndex:1];
            }
            break;
        case 1:
            if (self.RecruiListArr1.count == 0) {
                [self refreshWithIndex:1];
            }
            break;
        case 2:
            if (self.RecruiListArr2.count == 0) {
                [self refreshWithIndex:1];
            }
            break;
        case 3:
            if (self.RecruiListArr3.count == 0) {
                [self refreshWithIndex:1];
            }
            break;
        default:
            break;
    }
}

#pragma mark - SearchBar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.searchBarTwo resignFirstResponder];
}

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
        case 3:/**< 学历 */
            _model.education = model.industryName;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"学历" forState:UIControlStateNormal];
            }
            break;
        case 4:/**< 福利 */
            _model.Welfare = model.industryID;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"福利" forState:UIControlStateNormal];
            }
            break;
        case 5:/**< 年龄 */
            _model.age = model.industryName;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"年龄" forState:UIControlStateNormal];
            }
            break;
        case 6:/**< 性别 */
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
    UIView *view1 = [WINDOW viewWithTag:1000];
    _selectedButton.selected = NO;
    _selectedButton = nil;
    view1.hidden = YES;
    [self.city remove];
}

#pragma mark - WPActionSheet
-(void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"招聘简历");
        WPRecruitController *recuilist = [[WPRecruitController alloc]init];
        recuilist.title = @"招聘简历";
        recuilist.model = nil;
        recuilist.delegate = self;
        [self.navigationController pushViewController:recuilist animated:YES];
    }
}

- (void)WPInterviewControllerDelegate{
    
    [self refreshWithIndex:1];
    [self refreshWithIndex:2];
    [self refreshWithIndex:3];
    [self refreshWithIndex:4];
}

- (void)WPRecuilistControllerDelegate{
    [self refreshWithIndex:1];
    [self refreshWithIndex:2];
    [self refreshWithIndex:3];
    [self refreshWithIndex:4];
}

-(void)menuItem:(id)sender
{
    WPRecruitApplyController *apply = [[WPRecruitApplyController alloc] init];
    apply.sid = self.selectedModel.sid;
    [self.navigationController pushViewController:apply animated:YES];
}

-(void)menuItem2:(id)sender
{
    //可实现自定义功能
    NSString *url  = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    
    NSDictionary *dic = @{@"action":@"ResumeCollect",
                          @"user_id":kShareModel.userId,
                          @"username":kShareModel.username,
                          @"password":kShareModel.password,
                          @"resume_id":self.selectedModel.sid};
    
    [WPHttpTool postWithURL:url params:dic success:^(id json) {
        [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)menuItem3:(id)sender
{
#pragma mark无用
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
            self.selectedModel = self.RecruiListArr[indexPath.row];
        }
        if (_bottomType == 1) {
            //处理选中问题
            [self.tableView1 deselectRowAtIndexPath:[self.tableView1 indexPathForSelectedRow] animated:NO];
            [self.tableView1 selectRowAtIndexPath:[self.tableView1 indexPathForCell:cell] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            NSIndexPath *indexPath = [self.tableView1 indexPathForCell:cell];
            self.selectedModel = self.RecruiListArr1[indexPath.row];
        }
        if (_bottomType == 2) {
            //处理选中问题
            [self.tableView2 deselectRowAtIndexPath:[self.tableView2 indexPathForSelectedRow] animated:NO];
            [self.tableView2 selectRowAtIndexPath:[self.tableView2 indexPathForCell:cell] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            NSIndexPath *indexPath = [self.tableView2 indexPathForCell:cell];
            self.selectedModel = self.RecruiListArr2[indexPath.row];
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
        
        //显示菜单栏
        [menuController setMenuVisible:YES animated:YES];
        
    }
}

#pragma mark - UIGestureDelegate
- (BOOL)canBecomeFirstResponder
{
    return YES;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (_bottomType) {
        case 0:
            [tableView tableViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr.count];
            return self.RecruiListArr.count;
        case 1:
            [tableView tableViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr1.count];
            return self.RecruiListArr1.count;
        case 2:
            [tableView tableViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr2.count];
            return self.RecruiListArr2.count;
        case 3:
            [tableView tableViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr3.count];
            return self.RecruiListArr3.count;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kHEIGHT(58);
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == self.tableView4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        return cell;
    }else{
        WPRecruitTCell *cell = [WPRecruitTCell cellWithTableView:tableView];
        cell.path = indexPath;
        switch (_bottomType) {
            case 0:
                if (tableView == _tableView) {
                    cell.model = self.RecruiListArr[indexPath.row];
                }
                break;
            case 1:
                if (tableView == _tableView1) {
                    cell.model = self.RecruiListArr1[indexPath.row];
                }
                break;
            case 2:
                if (tableView == _tableView2) {
                    cell.model = self.RecruiListArr2[indexPath.row];
                }
                break;
            case 3:
                if (tableView == _tableView3) {
                    cell.model = self.RecruiListArr3[indexPath.row];
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
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"招聘");
    WPRecruitListModel *model = [[WPRecruitListModel alloc]init];;
    switch (_bottomType) {
        case 0:
            model = self.RecruiListArr[indexPath.row];
            break;
        case 1:
            model = self.RecruiListArr1[indexPath.row];
            break;
        case 2:
            model = self.RecruiListArr2[indexPath.row];
            break;
        case 3:
            model = self.RecruiListArr3[indexPath.row];
            break;
        default:
            break;
    }
    if (!tableView.editing) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NearInterViewController *interView = [[NearInterViewController alloc]init];
        interView.isRecuilist = YES;
        [self.navigationController pushViewController:interView animated:YES];
        interView.subId = model.sid;
        WPShareModel *shareModel = [WPShareModel sharedModel];
        interView.isSelf = [model.userId isEqualToString:shareModel.dic[@"userid"]];
        interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,model.sid,kShareModel.userId];

    }else{
        
        [self.selectedArray addObject:model];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    WPRecruitListModel *model = [[WPRecruitListModel alloc]init];
    switch (_bottomType) {
        case 0:
            model = self.RecruiListArr[indexPath.row];
            break;
        case 1:
            model = self.RecruiListArr1[indexPath.row];
            break;
        case 2:
            model = self.RecruiListArr2[indexPath.row];
            break;
        case 3:
            model = self.RecruiListArr3[indexPath.row];
            break;
        default:
            break;
    }
    
    for (WPRecruitListModel *listModel in self.selectedArray) {
        if ([listModel.sid isEqualToString:model.sid]) {
            [self.selectedArray removeObject:listModel];
            break;
        }
    }
}

- (void)detailActions:(NSIndexPath *)indexPath
{
    NearInterViewController *interView = [[NearInterViewController alloc]init];
    interView.isRecuilist = 2;
    [self.navigationController pushViewController:interView animated:YES];
    NSLog(@"招聘");
    WPRecruitListModel *model = [[WPRecruitListModel alloc]init];;
    switch (_bottomType) {
        case 0:
            model = self.RecruiListArr[indexPath.row];
            break;
        case 1:
            model = self.RecruiListArr1[indexPath.row];
            break;
        case 2:
            model = self.RecruiListArr2[indexPath.row];
            break;
        case 3:
            model = self.RecruiListArr3[indexPath.row];
            break;
        default:
            break;
    }
    interView.subId = model.epId;
    WPShareModel *shareModel = [WPShareModel sharedModel];
    interView.isSelf = [model.userId isEqualToString:shareModel.dic[@"userid"]];
    interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/recruitCompany.aspx?ep_id=%@&user_id=%@",IPADDRESS,model.epId,kShareModel.userId];
}

#pragma mark - CollectonView data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (_bottomType) {
        case 0:
            [collectionView collectionViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr.count];
            return self.RecruiListArr.count;
        case 1:
            [collectionView collectionViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr1.count];
            return self.RecruiListArr1.count;
        case 2:
            [collectionView collectionViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr2.count];
            return self.RecruiListArr2.count;
        case 3:
            [collectionView collectionViewDisplayWitMsg:@"没有查询到招聘信息" ifNecessaryForRowCount:self.RecruiListArr3.count];
            return self.RecruiListArr3.count;
        default:
            return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPRecruitCell *cell = [WPRecruitCell cellWithCellectionView:collectionView indexPath:indexPath];
    switch (_bottomType) {
        case 0:
            cell.model = self.RecruiListArr[indexPath.row];
            break;
        case 1:
            cell.model = self.RecruiListArr1[indexPath.row];
            break;
        case 2:
            cell.model = self.RecruiListArr2[indexPath.row];
            break;
        case 3:
            cell.model = self.RecruiListArr3[indexPath.row];
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

    WPRecruitListModel *model = [[WPRecruitListModel alloc]init];;
    switch (_bottomType) {
        case 0:
            model = self.RecruiListArr[indexPath.row];
            break;
        case 1:
            model = self.RecruiListArr1[indexPath.row];
            break;
        case 2:
            model = self.RecruiListArr2[indexPath.row];
            break;
        case 3:
            model = self.RecruiListArr3[indexPath.row];
            break;
        default:
            break;
    }
    
    if (!_collectionViewEditing) {
        NearInterViewController *interView = [[NearInterViewController alloc]init];
        interView.isRecuilist = YES;
        [self.navigationController pushViewController:interView animated:YES];
        NSLog(@"招聘");
        
        interView.subId = model.sid;
        WPShareModel *shareModel = [WPShareModel sharedModel];
        interView.isSelf = [model.userId isEqualToString:shareModel.dic[@"userid"]];
        interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,model.sid,kShareModel.userId];
    }else{
        if (model.isSelected) {
            for (WPRecruitListModel *listModel in self.selectedArray) {
                if ([listModel.sid isEqualToString:model.sid]) {
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
                if (self.RecruiListArr.count == 0) {
                    [self refreshWithIndex:1];
                }
                break;
            case 1:
                if (self.RecruiListArr1.count == 0) {
                    [self refreshWithIndex:1];
                }

                break;
            case 2:
                if (self.RecruiListArr2.count == 0) {
                    [self refreshWithIndex:1];
                }
                break;
            case 3:
                if (self.RecruiListArr3.count == 0) {
                    [self refreshWithIndex:1];
                }
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
