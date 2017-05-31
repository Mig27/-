//
//  WPNewSchoolController.m
//  WP
//
//  Created by CBCCBC on 16/1/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPNewSchoolController.h"
#import "WPNearController.h"
#import "WPInterviewController.h"

#import "UISelectCity.h"
#import "MJRefresh.h"
#import "WPUserListModel.h"
#import "UICollectionView+EmptyData.h"

#import "WPPeopleConnectionViewController.h"
#import "NearInterViewController.h"
#import "WPRecruitController.h"
#import "WPAllSearchController.h"
#import "WPRecruitApplyController.h"
#import "WPInterviewApplyController.h"
#import "YYShareManager.h"
#import "YYAlertManager.h"
#import "RecentPersonController.h"
#import "WPNewFullCell.h"
#import "WPNewPartCell.h"

#import "WPNewResumeModel.h"

@interface WPNewSchoolController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UISelectDelegate,WPInterviewControllerDelegate,WPRecuilistControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *button1;/**< 右按钮 */
@property (nonatomic, strong) UIButton *button;/**< 右按钮 */

@property (nonatomic, strong) NSMutableArray *resumeArr;/**< 求职 */
@property (nonatomic, strong) UICollectionView *collectionView;/**< 图片显示 */
@property (strong, nonatomic) UIView *headerView;/**< 头部视图 */
@property (nonatomic, strong) UIView *editBottomView;/**< 长按编辑后弹出的选择框 */
@property (nonatomic, strong) UIButton* selectedButton;/**< 分类选中Button */

@property (nonatomic, strong) UISelectCity *city;/**< 筛选框 */
@property (nonatomic, strong) NearCategoryModel *model;/**< 请求数据类型Model */
@property (nonatomic, strong) SPRecuilistModel *recModel;
@property (nonatomic, strong) WPUserListModel *userModel;
@property (nonatomic, strong) WPNewResumeListModel *selectedModel;
@property (strong, nonatomic) NSMutableArray *selectedArray;

@property (assign, nonatomic) BOOL collectionViewIsEditing;/**< collectionView是否为编辑状态 */
@property (assign, nonatomic) BOOL collectionViewItemIsFullScreen;/**< collectionView的item是否为全屏宽度 */
@property (nonatomic, assign) int pageNumber;/**< 请求的页数 */
@property (nonatomic, assign) NSInteger categoryCount; /**< 分类标志位 */
@property (assign, nonatomic) CGFloat historyY;/**< 滚动前ScrollView的位置 */

@property (assign, nonatomic) NSInteger typeSelectedNumber;
@property (strong, nonatomic) SPIndexPath *industrySelectedNumber;
@property (strong, nonatomic) SPIndexPath *positionSelectedNumber;
@property (assign, nonatomic) NSInteger salarySelectedNumber;
@property (assign, nonatomic) NSInteger worktimeSelectedNumber;
@property (assign, nonatomic) NSInteger educationSelectedNumber;
@property (assign, nonatomic) NSInteger welfareSelectedNumber;
@property (assign, nonatomic) NSInteger ageSelectedNumber;
@property (assign, nonatomic) NSInteger sexSelectedNumber;

@end

@implementation WPNewSchoolController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.edgesForExtendedLayout = UIRectEdgeAll;/**<  边缘延伸布局 */
    _categoryCount = 0;
    _pageNumber = 1;
    _historyY = 0.0;
    
    _industrySelectedNumber = [[SPIndexPath alloc]init];
    _positionSelectedNumber = [[SPIndexPath alloc]init];
    
    _industrySelectedNumber.section = -1;
    _industrySelectedNumber.row = -1;
    _positionSelectedNumber.section = -1;
    _positionSelectedNumber.row = -1;
    _salarySelectedNumber = -1;
    _worktimeSelectedNumber = -1;
    _educationSelectedNumber = -1;
    _welfareSelectedNumber = -1;
    _ageSelectedNumber = -1;
    _sexSelectedNumber = -1;
    
    _collectionViewIsEditing = NO;
    _collectionViewItemIsFullScreen = YES;
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.editBottomView];
    
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.headerView.height-0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(226, 226, 226);
    [self.headerView addSubview:line];
    
    [self setNavbarItem];
    
    [self getDefaultCompany];
    [self getDefaultResume];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WPInterviewControllerDelegate) name:@"kNotificationRefreshLsit" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WPInterviewControllerDelegate) name:@"kNotificationDeleteResume" object:nil];
}

#pragma mark - 初始化数组
- (WPNewResumeListModel *)selectedModel{
    if (!_selectedModel) {
        _selectedModel = [[WPNewResumeListModel alloc]init];
    }
    return _selectedModel;
}

- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc]init];
    }
    return _selectedArray;
}

- (NearCategoryModel *)model{
    if (!_model) {
        _model = [[NearCategoryModel alloc]init];
        _model.action = self.type == WPMainPositionTypeRecruit?@"CampusRecruitment":@"SchoolRescume";
        _model.areaID = @"";
        _model.industryID = @"";
        _model.Position = @"";
        _model.Sex = @"1";
        _model.Wage = @"1";
        _model.Experience = @"1";
        _model.education = @"";
        _model.Welfare = @"1";
        _model.age = @"";
        _model.states = @"1";
    }
    return _model;
}

-(NSMutableArray *)resumeArr
{
    if (!_resumeArr) {
        
        _resumeArr = [[NSMutableArray alloc]init];
    }
    return _resumeArr;
}

#pragma mark - 初始化子视图
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

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [_collectionView setCollectionViewLayout:flowLayout];
        
        int width = (SCREEN_WIDTH == 320?320:(SCREEN_WIDTH == 375)?376:416);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.headerView.bottom, width, SCREEN_HEIGHT-HEADVIEWHEIGHT-64) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = WPColor(255, 255, 255);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[WPNewFullCell class] forCellWithReuseIdentifier:@"WPNewFullCell"];
        [_collectionView registerClass:[WPNewPartCell class] forCellWithReuseIdentifier:@"WPNewPartCell"];
        __weak __typeof(self) unself = self;
        
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [unself.collectionView.mj_footer resetNoMoreData];
            _pageNumber = 1;
            [unself requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                [unself.resumeArr removeAllObjects];
                [unself.resumeArr addObjectsFromArray:datas];
                [unself.collectionView reloadData];
            } Error:^(NSError *error) {
            }];
            [self.collectionView.mj_header endRefreshing];
        }];
        
        [self.collectionView.mj_header beginRefreshing];
        
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pageNumber++;
            [unself requestWithPageIndex:_pageNumber Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [unself.resumeArr addObjectsFromArray:datas];
                    [unself.collectionView reloadData];
                }
            } Error:^(NSError *error) {
                _pageNumber--;
            }];
            [unself.collectionView.mj_footer endRefreshing];
        }];
    }
    return _collectionView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SEARCHBARHEIGHT+BOTTOMINHEADVIEWHEIGHT)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
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
        [_headerView addSubview:searchBar];
        
        UIView *bottomInHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, searchBar.bottom, SCREEN_WIDTH, BOTTOMINHEADVIEWHEIGHT)];
        [_headerView addSubview:bottomInHeaderView];
        
        UIButton *buttonArea = [[UIButton alloc] init];
        [buttonArea setFrame:CGRectMake(0, 0, IBUTTONXPOSITION, BOTTOMINHEADVIEWHEIGHT)];
        [buttonArea setTitle:@"最新" forState:UIControlStateNormal];
        
        // 字体大小
        buttonArea.titleLabel.font = kFONT(14);
        buttonArea.tag = 19;
        [buttonArea setBackgroundColor:[UIColor whiteColor]];
        // 文字颜色
        [buttonArea setTitleColor:IWTabBarButtonTitleColor forState:UIControlStateNormal];
        [buttonArea setTitleColor:IWTabBarButtonTitleSelectedColor forState:UIControlStateSelected];
        [buttonArea setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, buttonArea.width/2-15)];
        [buttonArea setBackgroundImage:[UIImage resizedImageWithName:@"discover_button"] forState:UIControlStateHighlighted];
        [buttonArea addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        
        [bottomInHeaderView addSubview:buttonArea];
        
        //2.设置uiscrollview
        UIScrollView *scrollViewFirst = [[UIScrollView alloc] initWithFrame:CGRectMake(IBUTTONXPOSITION, 0, SCREEN_WIDTH - IBUTTONXPOSITION, BOTTOMINHEADVIEWHEIGHT)];
        scrollViewFirst.backgroundColor = [UIColor whiteColor];
        [scrollViewFirst setShowsHorizontalScrollIndicator:NO];
        [scrollViewFirst setShowsVerticalScrollIndicator:NO];
        [scrollViewFirst setBounces:YES];
        
        NSArray* arrayButtonName = @[@"区域",@"行业", @"职称", @"工资", @"经验",@"学历",@"福利",@"年龄", @"性别"];
        scrollViewFirst.contentSize = CGSizeMake(arrayButtonName.count * IBUTTONXPOSITION, BOTTOMINHEADVIEWHEIGHT);
        
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
            [scrollViewFirst addSubview:button];
        }
        
        [bottomInHeaderView addSubview:scrollViewFirst];
    }
    
    return _headerView;
}

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
        
        WS(ws);
        _city.touchHide =^(){
            [ws touchHide:nil];
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

- (void)touchHide:(UITapGestureRecognizer *)tap{
    UIView *view1 = [WINDOW viewWithTag:1000];
    _selectedButton.selected = NO;
    _selectedButton = nil;
    view1.hidden = YES;
    [self.city remove];
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
    for (WPNewResumeListModel *model in self.selectedArray) {
        str = [NSString stringWithFormat:@"%@%@%@",str,model.resumeId,SEPARATOR];
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
        if (self.selectedArray.count != 0) {
            NSString *resumeId = @"";
            for (WPNewResumeListModel *listModel in self.selectedArray) {
                resumeId = [NSString stringWithFormat:@"%@%@%@",resumeId,listModel.resumeId,@","];
            }
            
            NSString *userId = [self.selectedArray[0] userId];
            
            NSString *action = @"";
            if (self.selectedArray.count == 1) {
                action = (self.type == WPMainPositionTypeInterView?@"oneshareresume2":@"onesharejob2");
            }else{
                action = (self.type == WPMainPositionTypeInterView?@"shareresume2":@"sharejob2");
            }
            
            NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
            NSDictionary *params = @{@"action":action,
                                     (self.type == WPMainPositionTypeInterView?@"resumeid":@"jobid"):[resumeId substringToIndex:resumeId.length-1],
                                     @"user_id":userId,
                                     };
            
            [WPHttpTool postWithURL:str params:params success:^(id json) {
                
                if([json[@"status"] isEqualToString:@"1"]){
                    
                    [self shareAllResumeWithUrl:json[@"url"]];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error.localizedDescription);
            }];        }
    }
}

#pragma mark - shareWithUrl
- (void)shareAllResumeWithUrl:(NSString *)url{
#pragma mark 校园招聘
    NSLog(@"%@",[IPADDRESS stringByAppendingString:url]);
    [YYShareManager shareWithTitle:@"这是title" url:[IPADDRESS stringByAppendingString:url] action:^(YYShareManagerType type) {
        if (type == YYShareManagerTypeWeiPinFriends) {
            RecentPersonController *recent = [[RecentPersonController alloc]init];
            recent.shareArray = self.selectedArray;
            UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:recent];
            [self presentViewController:navc animated:YES completion:nil];
        }
        if (type == YYShareManagerTypeWorkLines) {
            
        }
    } status:^(UMSocialShareResponse*status) {
        if (status) {
            [self backToFromViewController:nil];
            [self.selectedArray removeAllObjects];
            for (WPNewResumeListModel *listModel in self.resumeArr) {
                listModel.isSelected = NO;
            }
        }
    }];
}

- (void)shareSingleWithUrl:(NSString *)url{
#pragma mark 校园招聘
    [YYShareManager shareWithTitle:@"这是title" url:[IPADDRESS stringByAppendingString:url] action:^(YYShareManagerType type) {
        if (type == YYShareManagerTypeWeiPinFriends) {
            RecentPersonController *recent = [[RecentPersonController alloc]init];
            recent.shareArray = @[self.selectedModel];
            UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:recent];
            [self presentViewController:navc animated:YES completion:nil];
        }
        if (type == YYShareManagerTypeWorkLines) {
            
        }
    } status:^(UMSocialShareResponse*status) {
//        if (status == UMSResponseCodeSuccess) {
//            
//        }
    }];
}

#pragma mark - 网络请求
-(void)requestWithPageIndex:(int)pageIndex Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
    NSString *str = [IPADDRESS stringByAppendingString:self.type == WPMainPositionTypeRecruit?@"/ios/inviteJob.ashx":@"/ios/resume.ashx"];
    NSDictionary *params = @{@"action":self.model.action,
                             @"state":self.model.states,
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"keyWords":@"",
                             @"areaID":self.model.areaID,
                             @"Industry":self.model.industryID,
                             @"Position":self.model.Position,
                             @"Sex":self.model.Sex,
                             @"Wage":self.model.Wage,
                             @"Experience":self.model.Experience,
                             @"Demand":@"1",
                             @"education":self.model.education,
                             @"Welfare":self.model.Welfare,
                             @"age":self.model.age,
                             @"page":[NSString stringWithFormat:@"%d",pageIndex]};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        
        WPNewResumeModel *recruitModel = [WPNewResumeModel mj_objectWithKeyValues:json];
        NSArray *arr = [[NSArray alloc]initWithArray:recruitModel.list];
        for (WPNewResumeListModel *listModel in arr) {
            listModel.type = self.type?1:0;
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
    NSDictionary *params = @{@"action":@"defaultinfo",
                             @"user_id":kShareModel.userId,
                             @"username":kShareModel.username,
                             @"password":kShareModel.password
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
    NSDictionary *params = @{@"action":@"GetDefaultResume",
                             @"user_id":kShareModel.dic[@"userid"],
                             @"username":kShareModel.username,
                             @"password":kShareModel.password
                             };
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        _userModel = [WPUserListModel mj_objectWithKeyValues:json];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - Actions
- (void)backToFromViewController:(UIButton *)sender{
    if (_collectionViewIsEditing) {
        _collectionViewIsEditing = NO;
        _button.hidden = NO;
        _button1.hidden = NO;
        self.editBottomView.hidden = YES;
        [self.selectedArray removeAllObjects];
        [self.collectionView reloadData];
    }else{
        [self.city removeFromSuperview];
        UIView *view = [WINDOW viewWithTag:1000];
        [view removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)rightBarButtonItemClick:(UIButton *)sender/**< 右按钮创建 */
{
    if(self.type == WPMainPositionTypeRecruit){
        NSLog(@"招聘简历");
        WPRecruitController *recuilist = [[WPRecruitController alloc]init];
        recuilist.title = @"招聘简历";
        recuilist.isFirst = _recModel.status;
        recuilist.model = nil;
        recuilist.delegate = self;
        [self.navigationController pushViewController:recuilist animated:YES];
    }else{
        WPInterviewController *interview = [[WPInterviewController alloc]init];
        interview.title = @"求职简历";
        interview.delegate = self;
        if (![_userModel.resumeUserId isEqualToString:@"0"]) {
            interview.model = _userModel;
        }
        [self.navigationController pushViewController:interview animated:YES];
    }
}

-(void)switchPhotoStyle:(UIButton *)sender/**< 右按钮切换 */
{
    sender.selected = !sender.selected;
    _collectionViewItemIsFullScreen = !sender.selected;
    [_collectionView reloadData];
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
            
            NSArray *statesArr = (self.type == WPMainPositionTypeInterView?@[@"最新求职",@"好友圈求职",@"陌生人求职",@"我的求职"]:@[@"最新招聘",@"好友圈招聘",@"陌生人招聘",@"我的招聘"]);
            NSMutableArray *states = [[NSMutableArray alloc]init];
            for (int i = 0; i < statesArr.count; i++) {
                IndustryModel *model = [[IndustryModel alloc]init];
                model.industryName = statesArr[i];
                model.industryID = [NSString stringWithFormat:@"%@",@(i+1)];
                [states addObject:model];
            }
            switch (sender.tag-10) {
                case 0:
                    self.city.isArea = YES;
                    self.city.isIndusty = NO;
                    [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
                    break;
                    break;
                case 1:/**< 行业 */
                    self.city.isArea = NO;
                    self.city.isIndusty = YES;
                    [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getIndustry",@"fatherid":@"0"} selectedIndex:_industrySelectedNumber];
                    break;
                case 2:/**< 职位 */
                    self.city.isArea = NO;
                    self.city.isIndusty = NO;
                    [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getPosition",@"fatherid":@"0"} selectedIndex:_positionSelectedNumber];
                    break;
                case 3:/**< 工资 */
                    [self.city setLocalData:[SPLocalApplyArray salaryArray] selectedIndex:_salarySelectedNumber];
                    break;
                case 4:/**< 经验 */
                    [self.city setLocalData:[SPLocalApplyArray workTimeArray] selectedIndex:_worktimeSelectedNumber];
                    break;
                case 5:/**< 学历 */
                    [self.city setLocalData:[SPLocalApplyArray educationArray] selectedIndex:_educationSelectedNumber];
                    break;
                case 6:/**< 福利 */
                    [self.city setLocalData:[SPLocalApplyArray welfareArray] selectedIndex:_welfareSelectedNumber];
                    break;
                case 7:/**< 年龄 */
                    [self.city setLocalData:[SPLocalApplyArray ageArray] selectedIndex:_ageSelectedNumber];
                    break;
                case 8:/**< 性别 */
                    [self.city setLocalData:[SPLocalApplyArray sexWithNoLimitArray] selectedIndex:_sexSelectedNumber];
                    break;
                case 9:/**< 最新 */
                    [self.city setLocalData:states selectedIndex:_typeSelectedNumber];
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

#pragma mark - UISerachBar Deleagte
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    WPAllSearchController *search = [[WPAllSearchController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:search];
    [self presentViewController:navc animated:NO completion:nil];
    return NO;
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
        case 0:
            self.model.areaID = model.industryID;
            break;
        case 1:/**< 行业 */
            self.model.industryID = model.industryID;
            _industrySelectedNumber.section = model.section;
            _industrySelectedNumber.row = model.row;
            break;
        case 2:/**< 职称 */
            self.model.Position = model.industryID;
            _positionSelectedNumber.section = model.section;
            _positionSelectedNumber.row = model.row;
            break;
        case 3:/**< 工资 */
            self.model.Wage = model.industryID;
            if ([model.industryName isEqualToString:@"面议"]) {
                [button setTitle:@"工资" forState:UIControlStateNormal];
            }
            _salarySelectedNumber = model.section;
            break;
        case 4:/**< 经验 */
            self.model.Experience = model.industryID;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"经验" forState:UIControlStateNormal];
            }
            _worktimeSelectedNumber = model.section;
            break;
        case 5:/**< 学历 */
            self.model.education = model.industryName;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"学历" forState:UIControlStateNormal];
            }
            _educationSelectedNumber = model.section;
            break;
        case 6:/**< 福利 */
            self.model.Welfare = model.industryID;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"福利" forState:UIControlStateNormal];
            }
            _welfareSelectedNumber = model.section;
            break;
        case 7:/**< 年龄 */
            self.model.age = model.industryName;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"年龄" forState:UIControlStateNormal];
            }
            _ageSelectedNumber = model.section;
            break;
        case 8:/**< 性别 */
            self.model.Sex = model.industryID;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"性别" forState:UIControlStateNormal];
            }
            _sexSelectedNumber = model.section;
            break;
        case 9:/**< 最新 */
            self.model.states = model.industryID;
            _typeSelectedNumber = model.section;
            break;
        default:
            break;
    }
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - 求职or招聘回调函数
- (void)WPInterviewControllerDelegate{
    [self.collectionView.mj_header beginRefreshing];
}

- (void)WPRecuilistControllerDelegate{
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - 长按菜单事件
-(void)menuItem:(id)sender
{
    WPInterviewApplyController *apply = [[WPInterviewApplyController alloc] init];
    apply.sid = self.selectedModel.resumeId;
    [self.navigationController pushViewController:apply animated:YES];
    //}
}

-(void)menuItem2:(id)sender
{
    NSString *url  = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    
    NSDictionary *dic = @{@"action":@"ResumeCollect",
                          @"user_id":kShareModel.userId,
                          @"username":kShareModel.username,
                          @"password":kShareModel.password,
                          @"resume_id":self.selectedModel.resumeId};
    
    [WPHttpTool postWithURL:url params:dic success:^(id json) {
        [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)menuItem3:(id)sender
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
    NSDictionary *params = @{@"action":(self.type == WPMainPositionTypeInterView?@"oneshareresume2":@"onesharejob2"),
                             (self.type == WPMainPositionTypeInterView?@"resumeid":@"jobid"):self.selectedModel.resumeId,
                             @"user_id":self.selectedModel.userId,
                             };
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        
        if([json[@"status"] isEqualToString:@"1"]){
            [self shareSingleWithUrl:json[@"url"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)menuItem4:(id)sender
{
    _collectionViewIsEditing = YES;
    [self.collectionView reloadData];
    
    _button.hidden = YES;
    _button1.hidden = YES;
    self.editBottomView.hidden = NO;
}

#pragma mark - 长按后触发该方法
-(void)longPressWebView:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (!_collectionViewIsEditing) {
        //判断长按状态
        if ([gestureRecognizer state]==UIGestureRecognizerStateBegan)
        {
            
            //必须设置为第一响应者
            UICollectionViewCell *cell = (UICollectionViewCell *)gestureRecognizer.view;
            
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            self.selectedModel = self.resumeArr[indexPath.row];
            
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
}

#pragma mark - UIGestureDelegate
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - CollectonView data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [collectionView collectionViewDisplayWitMsg:@"没有查询到求职信息" ifNecessaryForRowCount:self.resumeArr.count];
    return self.resumeArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //注册长按事件
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWebView:)];
    [longPressGesture setDelegate:self];
    
    if (_collectionViewItemIsFullScreen) {
        static NSString *cellId = @"WPNewFullCell";
        WPNewFullCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        cell.model = self.resumeArr[indexPath.row];
        
        [cell exchangeSubViewFrame:_collectionViewIsEditing];
        
        //添加到cell
        [cell addGestureRecognizer:longPressGesture];
        
        return cell;
    }else{
        static NSString *cellId = @"WPNewPartCell";
        WPNewPartCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        cell.model = self.resumeArr[indexPath.row];
        
        cell.selectedImageView.hidden = !_collectionViewIsEditing;
        
        //添加到cell
        [cell addGestureRecognizer:longPressGesture];
        
        return cell;
    }
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_collectionViewItemIsFullScreen) {
        return CGSizeMake(SCREEN_WIDTH, kHEIGHT(58));
    }else{
        int width = (SCREEN_WIDTH == 320?320:(SCREEN_WIDTH == 375)?376:416);
        return CGSizeMake(width/4, width/4);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    WPNewResumeListModel *model = self.resumeArr[indexPath.row];
    
    if (!_collectionViewIsEditing) {
        NSLog(@"求职");
        NearInterViewController *interView = [[NearInterViewController alloc]init];
        interView.isRecuilist = self.type == WPMainPositionTypeInterView?0:1;
        [self.navigationController pushViewController:interView animated:YES];
        
        interView.subId = model.resumeId;
        interView.userId = model.userId;
        WPShareModel *shareModel = [WPShareModel sharedModel];
        interView.isSelf = [model.userId isEqualToString:shareModel.dic[@"userid"]];
        if (self.type == WPMainPositionTypeInterView) {
            interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,model.resumeId,kShareModel.userId];
        }else{
            interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,model.resumeId,kShareModel.userId];
        }
    }else{
        
        if (model.isSelected) {
            for (WPNewResumeListModel *listModel in self.selectedArray) {
                if ([listModel.resumeId isEqualToString:model.resumeId]) {
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


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_historyY>0&&_historyY<scrollView.contentOffset.y) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.headerView.top = -SEARCHBARHEIGHT+20;
            self.collectionView.top = self.headerView.bottom;
            self.collectionView.height = SCREEN_HEIGHT-self.headerView.bottom;
        }];
    }
    if (_historyY>scrollView.contentOffset.y&&_historyY<scrollView.contentSize.height-scrollView.frame.size.height){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            self.headerView.top = 64;
            self.collectionView.top = self.headerView.bottom;
            self.collectionView.height = SCREEN_HEIGHT-self.headerView.bottom;
        }];
    }
    //_historyY = scrollView.contentOffset.y;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
