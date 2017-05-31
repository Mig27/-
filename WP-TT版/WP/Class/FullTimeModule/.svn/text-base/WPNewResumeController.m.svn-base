//
//  WPMainInterviewController.m
//  WP
//
//  Created by CBCCBC on 16/1/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPNewResumeController.h"
#import "WPNearController.h"
#import "WPInterviewController.h"
#import "ShareEditeViewController.h"
#import "CollectViewController.h"
#import "WPPeopleConnectionViewController.h"
#import "NearInterViewController.h"
#import "WPRecruitController.h"
#import "WPAllSearchController.h"
#import "WPRecruitApplyController.h"
#import "WPInterviewApplyController.h"
#import "RecentPersonController.h"
#import "SessionModule.h"
#import "UISelectCity.h"
#import "MJRefresh.h"
#import "JSDropDownMenu.h"
#import "UICollectionView+EmptyData.h"
#import "WPSendToFriends.h"
#import "YYShareManager.h"
#import "YYAlertManager.h"
#import "WPcodeAlert.h"
#import "WPNewFullCell.h"
#import "WPNewPartCell.h"
#import "WPMySecurities.h"
#import "WPNewResumeModel.h"
#import "WPUserListModel.h"
#import "WPNewResumeHeaderView.h"
#import "WPTipModel.h"
#import "WPNewsViewController.h"
#import "WPNewResumeTableViewCell.h"
#import "WPDynamicTipView.h"
#import "MTTMessageEntity.h"
#import "WPRecentLinkManController.h"
#import "MTTDatabaseUtil.h"
#import "WPDownLoadVideo.h"
#import "WPShuoStaticData.h"
static NSString * const kNewResumeHeader = @"MGHeaderCell";
@interface WPNewResumeController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UISelectDelegate,WPInterviewControllerDelegate,WPRecuilistControllerDelegate,UIGestureRecognizerDelegate,WPInterviewApplyDelegate,CollectViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    WPNewResumeTableViewCell *currentCell;
}
@property (nonatomic, strong) UIButton *button1;/**< 右按钮 */
@property (nonatomic, strong) UIButton *button;/**< 右按钮 */
// <求职 数据 collectionView 数据
@property (nonatomic, strong) NSMutableArray *resumeArr  ;
@property (nonatomic, strong) UICollectionView *collectionView;/**< 图片显示 */
/**< collectionView的item是否为全屏宽度 */
@property (assign, nonatomic) BOOL collectionViewItemIsFullScreen;
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
@property (nonatomic, assign) int pageNumber;/**< 请求的页数 */
@property (nonatomic, assign) NSInteger categoryCount; /**< 分类标志位 */
@property (assign, nonatomic) CGFloat historyY;/**< 滚动前ScrollView的位置 */
@property (assign, nonatomic) NSInteger typeSelectedNumber;
@property (strong, nonatomic) SPIndexPath *industrySelectedNumber;
@property (strong, nonatomic) SPIndexPath *positionSelectedNumber;
@property (strong, nonatomic) SPIndexPath *citySelectedNumber;
@property (assign, nonatomic) NSInteger salarySelectedNumber;
@property (assign, nonatomic) NSInteger worktimeSelectedNumber;
@property (assign, nonatomic) NSInteger educationSelectedNumber;
@property (assign, nonatomic) NSInteger welfareSelectedNumber;
@property (assign, nonatomic) NSInteger ageSelectedNumber;
@property (assign, nonatomic) NSInteger sexSelectedNumber;
@property (assign, nonatomic) BOOL isFirst;
@property (strong, nonatomic) IndustryModel*cityModel;
@property (strong, nonatomic) UIWindow *coverWindow;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString * applyString;
@property (nonatomic, strong) WPDynamicTipView *tipView; /**< 未读消息提示 */
@property (nonatomic, strong) NSString * fromArea;
@end
@implementation WPNewResumeController
#pragma mark -- 该页面为 全职页面 推出 -> 企业招聘 和 面试
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.titleView.titleString = self.titleString.length?self.titleString:(self.type == WPMainPositionTypeInterView?@"面试":@"企业招聘");
    self.navigationItem.titleView = self.titleView;
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.edgesForExtendedLayout = UIRectEdgeAll;/**<  边缘延伸布局 */
    _categoryCount = 0;
    _pageNumber = 1;
    _historyY = 0.0;

    _industrySelectedNumber = [[SPIndexPath alloc]init];
    _positionSelectedNumber = [[SPIndexPath alloc]init];
    _citySelectedNumber = [[SPIndexPath alloc]init];
    
    _industrySelectedNumber.section = -1;
    _industrySelectedNumber.row = -1;
    _positionSelectedNumber.section = -1;
    _positionSelectedNumber.row = -1;
    _citySelectedNumber.section = -1;
    _citySelectedNumber.row = -1;
    _salarySelectedNumber = -1;
    _worktimeSelectedNumber = -1;
    _educationSelectedNumber = -1;
    _welfareSelectedNumber = -1;
    _ageSelectedNumber = -1;
    _sexSelectedNumber = -1;
    _collectionViewIsEditing = NO;
    _collectionViewItemIsFullScreen = YES;
    _isFirst = YES;
    [self.view addSubview:self.headerView];
    
 if (self.titleString.length)//从行业界面跳转
  {
      if (self.hangFatherID.length || self.positionHangID.length)
      {//热门职位
          
          UIButton *button = (UIButton *)[self.view viewWithTag:12];
          [button setTitle:@"职位" forState:UIControlStateNormal];
          self.model.industryID = self.positionHangID;
          self.model.Position =self.positionHangID ;
          [self.titleView.activity startAnimating];
          [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
              [self.titleView.activity stopAnimating];
              [self.resumeArr removeAllObjects];
              [self.resumeArr addObjectsFromArray:datas];
              [self.tableView reloadData];
          } Error:^(NSError *error) {
              [self.titleView.activity stopAnimating];
          }];
      }
      else//热门专区
      {
          [self.titleString isEqualToString:@"为我推荐"]?(self.fromArea = @"1"):([self.titleString isEqualToString:@"五险一金"]?(self.model.Welfare = @"2"):([self.titleString isEqualToString:@"周末双休"]?(self.model.Welfare = @"5"):([self.titleString isEqualToString:@"附近工作"]?(self.model.Welfare = @""):([self.titleString isEqualToString:@"包吃住专区"]?(self.model.Welfare = @"3"):(self.model.education = @"1")))));
          
          if ([self.titleString isEqualToString:@"五险一金"]||[self.titleString isEqualToString:@"周末双休"]||[self.titleString isEqualToString:@"包吃住专区"]) {
              UIButton *button = (UIButton *)[self.view viewWithTag:16];
              NSString * string = self.titleString;
              if ( [string isEqualToString:@"包吃住专区"]) {
                  string = @"包吃包住";
              }
              [button setTitle:string forState:UIControlStateNormal];
          }
          else if ([self.titleString isEqualToString:@"应届生专区"])
          {
              UIButton *button = (UIButton *)[self.view viewWithTag:14];
//              [button setTitle:@"不限" forState:UIControlStateNormal];
              [button setTitle:@"一年以下" forState:UIControlStateNormal];
              self.model.Experience = @"2";
          }
          [self.titleView.activity startAnimating];
          [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
              [self.titleView.activity stopAnimating];
              [self.resumeArr removeAllObjects];
              [self.resumeArr addObjectsFromArray:datas];
              [self.tableView reloadData];
          } Error:^(NSError *error) {
              [self.titleView.activity stopAnimating];
          }];
      }
  }
 else
  {
    
    WPShuoStaticData * shuoData = [WPShuoStaticData shareShuoData];
    if (shuoData.isShow && (self.type == WPMainPositionTypeInterView))//使用静态数据
    {
           [self.resumeArr removeAllObjects];
           [self.resumeArr addObjectsFromArray:shuoData.applyArray];
           [self.tableView reloadData];
           [self.tableView setContentOffset:CGPointMake(0,shuoData.applyScroller.floatValue)];
        
            shuoData.citySelected?_citySelectedNumber.section=shuoData.citySelected:0;
            shuoData.citySelectedRow?_citySelectedNumber.row = shuoData.citySelectedRow:0;
            shuoData.positionSelected?_positionSelectedNumber.section = shuoData.positionSelected:0;
            shuoData.positionSelectedRow?_positionSelectedNumber.row = shuoData.positionSelectedRow:0;
            shuoData.salarySelected?_salarySelectedNumber = shuoData.salarySelected:0;
            shuoData.experienceSelected?_worktimeSelectedNumber = shuoData.experienceSelected:0;
            shuoData.educationSelected?_educationSelectedNumber = shuoData.educationSelected:0;
            shuoData.welfareSelected?_welfareSelectedNumber = shuoData.welfareSelected:0;
            shuoData.ageSelected?_ageSelectedNumber = shuoData.ageSelected:0;
            shuoData.sexSelected?_sexSelectedNumber = shuoData.sexSelected:0;
            shuoData.stateSelected?_typeSelectedNumber = shuoData.stateSelected:0;
            
            self.model.areaID = shuoData.cityID.length?shuoData.cityID:self.model.areaID;
            self.model.industryID = shuoData.positionIndustry.length?shuoData.positionIndustry:self.model.industryID;
            self.model.Position = shuoData.positionID.length?shuoData.positionID:self.model.Position;
            self.model.Sex = shuoData.sexID.length?shuoData.sexID:self.model.Sex;
            self.model.Experience = shuoData.experienceID.length?shuoData.experienceID:self.model.Experience;
            self.model.education = shuoData.educationName.length?shuoData.educationName:self.model.education;
            self.model.Welfare = shuoData.welfareID.length?shuoData.welfareID:self.model.Welfare;
            self.model.age = shuoData.ageName.length?shuoData.ageName:self.model.age;
            self.model.Wage = shuoData.salaryID.length?shuoData.salaryID:self.model.Wage;
            self.model.states = shuoData.stateID.length?shuoData.stateID:self.model.states;
        
        if (shuoData.applyScroller.floatValue == 0 || !shuoData.applyScroller) {
            [self.titleView.activity startAnimating];
            [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                [self.titleView.activity stopAnimating];
                [self.resumeArr removeAllObjects];
                [self.resumeArr addObjectsFromArray:datas];
                [self.tableView reloadData];
            } Error:^(NSError *error) {
                [self.titleView.activity stopAnimating];
            }];
        }
    }
    else if (shuoData.isInviteShow && (self.type == WPMainPositionTypeRecruit))
    {
        [self.resumeArr removeAllObjects];
        [self.resumeArr addObjectsFromArray:shuoData.inviteArray];
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0,shuoData.inviteScroller.floatValue)];
        
        shuoData.IcitySelected?_citySelectedNumber.section=shuoData.IcitySelected:0;
        shuoData.IcitySelectedRow?_citySelectedNumber.row = shuoData.IcitySelectedRow:0;
        shuoData.IpositionSelected?_positionSelectedNumber.section = shuoData.IpositionSelected:0;
        shuoData.IpositionSelectedRow?_positionSelectedNumber.row = shuoData.IpositionSelectedRow:0;
        shuoData.IsalarySelected?_salarySelectedNumber = shuoData.IsalarySelected:0;
        shuoData.IexperienceSelected?_worktimeSelectedNumber = shuoData.IexperienceSelected:0;
        shuoData.IeducationSelected?_educationSelectedNumber = shuoData.IeducationSelected:0;
        shuoData.IwelfareSelected?_welfareSelectedNumber = shuoData.IwelfareSelected:0;
        shuoData.IageSelected?_ageSelectedNumber = shuoData.IageSelected:0;
        shuoData.IsexSelected?_sexSelectedNumber = shuoData.IsexSelected:0;
        shuoData.IstateSelected?_typeSelectedNumber = shuoData.IstateSelected:0;
        
        self.model.areaID = shuoData.IcityID.length?shuoData.IcityID:0;
        self.model.industryID = shuoData.IpositionIndustry.length?shuoData.IpositionIndustry:0;
        self.model.Position = shuoData.IpositionID.length?shuoData.IpositionID:0;
        self.model.Sex = shuoData.IsexID.length?shuoData.IsexID:0;
        self.model.Experience = shuoData.IexperienceID.length?shuoData.IexperienceID:0;
        self.model.education = shuoData.IeducationName.length?shuoData.IeducationName:0;
        self.model.Welfare = shuoData.IwelfareID.length?shuoData.IwelfareID:0;
        self.model.age = shuoData.IageName.length?shuoData.IageName:0;
        self.model.Wage = shuoData.IsalaryID.length?shuoData.IsalaryID:0;
        self.model.states = shuoData.IstateID.length?shuoData.IstateID:self.model.states;
        
        if (shuoData.inviteScroller.floatValue == 0 || !shuoData.inviteScroller) {
            [self.titleView.activity startAnimating];
            [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                [self.titleView.activity stopAnimating];
                [self.resumeArr removeAllObjects];
                [self.resumeArr addObjectsFromArray:datas];
                [self.tableView reloadData];
            } Error:^(NSError *error) {
                [self.titleView.activity stopAnimating];
            }];
        }
    }
    else
    {
        if (self.type == WPMainPositionTypeInterView) {
            [[MTTDatabaseUtil instance] getPersonalPrrly:^(NSArray *array) {
                if (array.count) {
                    [self.resumeArr removeAllObjects];
                    [self.resumeArr addObjectsFromArray:array];
                    [self.tableView reloadData];
                }
            }];
        }
        else
        {
            [[MTTDatabaseUtil instance] getPersonalApply:^(NSArray *array) {
                if (array.count) {
                    [self.resumeArr removeAllObjects];
                    [self.resumeArr addObjectsFromArray:array];
                    [self.tableView reloadData];
                }
            }];
        }
        
        if (self.type == WPMainPositionTypeInterView) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self.titleView.activity startAnimating];
                [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                    [self.titleView.activity stopAnimating];
                    [self.resumeArr removeAllObjects];
                    [self.resumeArr addObjectsFromArray:datas];
                    [self.tableView reloadData];
                } Error:^(NSError *error) {
                    [self.titleView.activity stopAnimating];
                }];
            });
        }
        else
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self.titleView.activity startAnimating];
                [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                    [self.titleView.activity stopAnimating];
                    [self.resumeArr removeAllObjects];
                    [self.resumeArr addObjectsFromArray:datas];
                    [self.tableView reloadData];
                } Error:^(NSError *error) {
                    [self.titleView.activity stopAnimating];
                }];
            });
        }
    }
  }
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.headerView.height-0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(226, 226, 226);
    [self.headerView addSubview:line];
    [self setNavbarItem];
    [self getDefaultCompany];
    [self getDefaultResume];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WPInterviewControllerDelegate) name:@"kNotificationRefreshLsit" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WPInterviewControllerDelegate) name:@"kNotificationDeleteResume" object:nil];
    //收到消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageTip) name:@"GlobalMessageTip" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"REFRESHMIANSHIDATA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delegateResumeSuccess) name:@"delegateResumeSuccess" object:nil];//删除简历成功
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"REFRESHCHECKDATA" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSuccess) name:@"SHARETOOTHERSUCCESS" object:nil];//sendToPersonSuccess
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSuccess) name:@"sendToPersonSuccess" object:nil];//upLoadMyApplySuccess
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upLoadMyApplySuccess:) name:@"upLoadMyApplySuccess" object:nil];
}
//-(UIWindow*)coverWindow
//{
//    if (!_coverWindow) {
//        _coverWindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//        _coverWindow.hidden = NO;
//        _coverWindow.backgroundColor = [UIColor redColor];
//        _coverWindow.windowLevel = UIWindowLevelStatusBar+1;
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapWin)];
//        [_coverWindow addGestureRecognizer:tap];
////        [_coverWindow makeKeyAndVisible];
//    }
//    return _coverWindow;
//}
-(void)tapWin
{
    [self.tableView scrollToTop];
    [self.titleView.activity startAnimating];
    [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
        [self.titleView.activity stopAnimating];
        [self.resumeArr removeAllObjects];
        [self.resumeArr addObjectsFromArray:datas];
        [self.tableView reloadData];
    } Error:^(NSError *error) {
        [self.titleView.activity stopAnimating];
    }];
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    UIWindow * window = [UIApplication sharedApplication].keyWindow;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.coverWindow makeKeyAndVisible];
//        [window makeKeyWindow];
//    });
//}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.coverWindow = nil;
    
    //隐藏窗口上的view
  
    UIView * view = (UIView*)[WINDOW viewWithTag:3344];
    [view removeFromSuperview];
    
    
    
//    view.hidden = YES;
    
}
-(void)upLoadMyApplySuccess:(NSNotification*)noti
{
    [self.titleView.activity startAnimating];
    [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
        [self.titleView.activity stopAnimating];
        [self.titleView.activity stopAnimating];
        [self.resumeArr removeAllObjects];
        [self.resumeArr addObjectsFromArray:datas];
        [self.tableView reloadData];
        [self.tableView scrollToTop];
    } Error:^(NSError *error) {
        [self.titleView.activity stopAnimating];
    }];
}
-(void)shareSuccess
{
    [self hidden];
}
-(IndustryModel*)cityModel
{
    if (!_cityModel) {
        _cityModel = [[IndustryModel alloc]init];
    }
    return _cityModel;
}
-(void)refresh
{
    [self hidden];
    __weak __typeof(self) unself = self;
    [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
        [unself.resumeArr removeAllObjects];
        [unself.resumeArr addObjectsFromArray:datas];
        [unself.tableView reloadData];
    } Error:^(NSError *error) {
    }];
}
-(void)delegateResumeSuccess
{
    __weak __typeof(self) unself = self;
    [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
        [unself.resumeArr removeAllObjects];
        [unself.resumeArr addObjectsFromArray:datas];
        [unself.tableView reloadData];
    } Error:^(NSError *error) {
    }];
}

#pragma  mark 收到消息的方法
- (void)messageTip
{
    if (self.isFromInduetry) {
        return;
    }
    
    
    WPTipModel *model = [WPTipModel sharedManager];
    NSString *count = self.type == WPMainPositionTypeRecruit ? model.jobMsgCount : model.ReMsgCount;
    if (![count isEqualToString:@"0"]) {//re_com_avatar
        [self.tipView configeWith:self.type == WPMainPositionTypeRecruit ? model.job_com_avatar : model.re_com_avatar count:self.type == WPMainPositionTypeRecruit ? model.jobMsgCount : model.ReMsgCount];
        self.tableView.tableHeaderView = self.tipView;
        self.tableView.tableHeaderView.hidden = NO;
    } else {
        self.tableView.tableHeaderView = nil;
    }
    if (self.type == WPMainPositionTypeInterView)//面试
    {
//        self.isNew = model.M_re_avatar.length;
//        self.isFriend = model.re_avatar.length;
    }
    else
    {
//        self.isNew = model.M_job_avatar.length;
//        self.isFriend = model.job_avatar.length;
    }
    UILabel * label = (UILabel*)[self.headerView viewWithTag:20];
    if (self.isNew||self.isFriend)
    {
        label.hidden = NO;
    }
    else
    {
        label.hidden = YES;
    }
}

#pragma mark - 新的消息通知
- (WPDynamicTipView *)tipView
{
    if (!_tipView) {
        _tipView = [[WPDynamicTipView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(36) + 8)];
        WS(ws);
        _tipView.clickBlock = ^(){
//            NSLog(@"点击");
            WPNewsViewController *news = [[WPNewsViewController alloc] init];
            if (self.type == WPMainPositionTypeInterView) {//面试
                news.type = NewsTypeResume;
            } else {//招聘
                news.type = NewsTypeInvite;
            }
            news.readOverBlock = ^(){
                ws.tableView.tableHeaderView.hidden = YES;
            };
            [ws.navigationController pushViewController:news animated:YES];
        };
    }
    return _tipView;
}
-(void)delay
{
//    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - 当将要返回父级的时候，注销观察者
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GlobalMessageTip" object:nil];
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
        _model.action = self.type == WPMainPositionTypeInterView?@"Interview":@"EnterpriseRecruitment";
        _model.areaID = @"340100";//设置定位的地址区域
        _model.industryID = @"0";
        _model.Position = @"0";
        _model.Sex = @"1";
        _model.Wage = @"0";
        _model.Experience = @"1";
        _model.education = @"";
        _model.Welfare = @"1";
        _model.age = @"";
        _model.states = @"1";
        _model.fatherID = @"";
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

#pragma mark -- 右按钮创建
-(void)rightBarBtnItemClick:(UIButton *)sender/**< 右按钮创建 */
{
    if(self.type == WPMainPositionTypeRecruit)
    {
//        NSLog(@"招聘简历");
        WPRecruitController *recuilist = [[WPRecruitController alloc]init];
        recuilist.title = @"创建企业招聘";
        recuilist.isFirst = _recModel.status;
        recuilist.isRecuilist = (self.type == WPMainPositionTypeInterView?0:1);
        recuilist.model = nil;
        recuilist.delegate = self;
        recuilist.isBuild = YES;
        recuilist.uploadMyWant = ^(NSArray*array){
            for (NSDictionary * dic in array) {
                 WPNewResumeListModel * model = [WPNewResumeListModel mj_objectWithKeyValues:dic];
                model.type = WPMainPositionTypeRecruit;
                [self.resumeArr insertObject:model atIndex:0];
            }
            [self.tableView reloadData];
        };
        
        [self.navigationController pushViewController:recuilist animated:YES];
    }
    else
    {
        // 后面修改的
        WPRecruitApplyController *interview = [[WPRecruitApplyController alloc]init];
        interview.upLoadMyApply = ^(NSDictionary*dic){
            WPNewResumeListModel * model = [WPNewResumeListModel mj_objectWithKeyValues:dic];
            [self.resumeArr insertObject:model atIndex:0];
            [self.tableView reloadData];
        };
        interview.title = @"创建求职简历";
        //interview.delegate = self;
        interview.isBuildNew = YES;
        interview.isBuild = YES;
        interview.isRecuilist = (self.type == WPMainPositionTypeInterView?0:1);
        if (![_userModel.resumeUserId isEqualToString:@"0"]) {
        //interview.model = _userModel;
        }
        [self.navigationController pushViewController:interview animated:YES];

    }
}

#pragma mark - 初始化导航栏
- (void)setNavbarItem
{
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button1.frame = CGRectMake(0, 0, 35, 22);
    _button1.titleLabel.font = kFONT(14);
    [_button1 setTitle:@"创建" forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_button1 addTarget:self action:@selector(rightBarBtnItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:_button1];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0, 22, 22);
    [_button setImage:[UIImage imageNamed:@"qiehuanliebiao"] forState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:@"tupianmushi"] forState:UIControlStateSelected];
    [_button addTarget:self action:@selector(switchPhotoStyle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem2 = [[UIBarButtonItem alloc]initWithCustomView:_button];
    
//    NSArray *rightBars = @[rightBarItem,rightBarItem2];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"zhichangshuoshuo_fabu"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarBtnItemClick:)];
}

#pragma mark 初始化collectionView
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
        [_collectionView registerClass:[WPNewResumeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kNewResumeHeader];
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
        self.collectionView.scrollsToTop = YES;
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

#pragma mark tableView
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.rowHeight = [WPNewResumeTableViewCell rowHeight];
        //        _tableView.tableHeaderView = self.tipView;
        [self.view addSubview:_tableView];
        [self.view addSubview:self.editBottomView];
        //        _tableView.frame = CGRectMake(0, 64 + kHEIGHT(32),SCREEN_WIDTH, SCREEN_HEIGHT - 64 - kHEIGHT(32));
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        __weak typeof(self) unself = self;
        //刷新数据
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.titleView.activity startAnimating];
            [unself.tableView.mj_footer resetNoMoreData];
            [unself.collectionView.mj_footer resetNoMoreData];
            _pageNumber = 1;
            [unself requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                [self.titleView.activity stopAnimating];
                [unself.resumeArr removeAllObjects];
                [unself.resumeArr addObjectsFromArray:datas];
                [unself.tableView reloadData];
            } Error:^(NSError *error) {
                [self.titleView.activity stopAnimating];
            }];
            [_tableView.mj_header endRefreshing];
        }];
        
        //加载更多数据
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pageNumber++;
            [unself requestWithPageIndex:_pageNumber Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [unself.resumeArr addObjectsFromArray:datas];
                    [unself.tableView reloadData];
                }
            } Error:^(NSError *error) {
                _pageNumber--;
            }];
            [unself.tableView.mj_footer endRefreshing];
        }];
        
    }
    
    return _tableView;
}


#pragma mark 点击弹出的视图时隐藏视图
- (void)touchHide:(UITapGestureRecognizer *)tap{
    UIView *view1 = [WINDOW viewWithTag:3344];
    _selectedButton.selected = NO;
    _selectedButton = nil;
    view1.hidden = YES;
    [self.city remove];
}

- (UIView *)editBottomView{
    if (!_editBottomView) {
        _editBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, BOTTOMHEIGHT)];
        _editBottomView.backgroundColor = [UIColor whiteColor];
        
        NSArray *arr = @[self.type == WPMainPositionTypeInterView ? @"抢人" : @"申请",@"收藏",@"分享"];
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, BOTTOMHEIGHT);
            [button setTitle:arr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if (i==0) {
                [button setBackgroundImage:[UIImage imageWithColor:RGB(0, 172, 255) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageWithColor:RGB(0, 146, 217) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
            }else{
                [button setBackgroundImage:[UIImage imageWithColor:RGB(255, 139, 0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageWithColor:RGB(217, 118, 0) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
            }
            
            button.titleLabel.font = kFONT(15);
            button.tag = 40+i;
            [button addTarget:self action:@selector(editBottomClick:) forControlEvents:UIControlEventTouchUpInside];
            [_editBottomView addSubview:button];
            if (i>0) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/3, 0, 0.5, 49)];
                line.backgroundColor = [UIColor whiteColor];
                [self.editBottomView addSubview:line];
            }
        }
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_editBottomView addSubview:line];
        
        _editBottomView.hidden = YES;
    }
    return _editBottomView;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 345) {
        BOOL isMySelf = NO;
        for (WPNewResumeListModel *model in self.selectedArray) {
            if ([model.userId isEqualToString:kShareModel.userId]) {
                isMySelf = YES;
                continue;
            }
        }
        if (buttonIndex == 1 && !isMySelf) {
            if (self.type == WPMainPositionTypeInterView) {//抢人
                WPInterviewApplyController *apply = [[WPInterviewApplyController alloc] init];
                apply.sid = self.applyString;
                apply.delegate = self;
                apply.controller = @"WPNewResumeController";
                [self.navigationController pushViewController:apply animated:YES];
            } else {//申请
                WPRecruitApplyController *apply = [[WPRecruitApplyController alloc] init];
                [self.navigationController pushViewController:apply animated:YES];
            }
  
        }
    }
}
#pragma mark  点击更多后再点击底部按钮
- (void)editBottomClick:(UIButton *)sender{
    
    NSString *str = @"";
    BOOL isMySelf = NO;
    for (WPNewResumeListModel *model in self.selectedArray) {
        if ([model.userId isEqualToString:kShareModel.userId]) {
            isMySelf = YES;
            continue;
        }
        str = [NSString stringWithFormat:@"%@%@%@",str,model.resumeId,SEPARATOR];
    }
    
    if (sender.tag == 40) {//点击抢人
        if (self.selectedArray.count == 0) {//self.selectedArray.count == 0
            [SPAlert alertControllerWithTitle:@"提示" message:@"请至少选择一个简历！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
        }else{
            self.applyString = str;
            if (isMySelf) {
                NSString * titleString =nil;
                self.type == WPMainPositionTypeInterView?(titleString = @"选择的求职中，自己发布的求职不能投递！"):(titleString = @"选择的招聘中，自己发布的招聘不能申请！");
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:titleString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alert.tag = 345;
                [alert show];
            }
            else
            {
                if (self.type == WPMainPositionTypeInterView) {//抢人
                    WPInterviewApplyController *apply = [[WPInterviewApplyController alloc] init];
                    apply.sid = str;
                    apply.delegate = self;
                    apply.controller = @"WPNewResumeController";
                    apply.robSuccess = ^(){
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"企业招聘发布邀请成功，请加对方为好友，以便后续联系方便，谢谢使用快捷招聘，网络招聘需谨慎，谨防求职骗局，如发现违法求职者，请及时报警和举报！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                        [alert show];
                    };
                    [self.navigationController pushViewController:apply animated:YES];
                } else {//申请
                    WPRecruitApplyController *apply = [[WPRecruitApplyController alloc] init];
                    apply.sid = str;
                    WS(ws);
                    apply.applySuccess = ^(){
                        [ws backToFromViewController:nil];
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"个人求职简历申请成功，请加对方为好友，以便后续联系方便，谢谢使用快捷招聘，网络求职需谨慎，谨防招聘骗局，如发现违法招聘，请及时报警和举报！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                        [alert show];
                    };
                    [self.navigationController pushViewController:apply animated:YES];
                }
            }
        }
    }
    
    if (sender.tag == 41) {//点击收藏
        
        if (self.selectedArray.count == 0) {
            [SPAlert alertControllerWithTitle:@"提示" message:@"请至少选择一个简历！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
        }else{
            
            
            CollectViewController *VC = [[CollectViewController alloc]init];
            VC.collect_class = (self.type == WPMainPositionTypeInterView?@"6":@"5");
            VC.isHeBing = @"1";
            NSString * jobId = @"";
            NSString * titleStr = @"";
            NSString * image_Url = @"";
            NSString * companyStr = @"";
            for (WPNewResumeListModel *listModel in self.selectedArray )
            {
                jobId = (jobId.length)?[NSString stringWithFormat:@"%@%@,",jobId,listModel.resumeId]:[NSString stringWithFormat:@"%@,",listModel.resumeId];
                titleStr = (titleStr.length)?[NSString stringWithFormat:@"%@%@,",titleStr,(self.selectedModel.type == WPMainPositionTypeInterView)?listModel.HopePosition:listModel.jobPositon]:[NSString stringWithFormat:@"%@,",(self.selectedModel.type == WPMainPositionTypeInterView)?listModel.HopePosition:listModel.jobPositon];
                image_Url = (image_Url.length)?[NSString stringWithFormat:@"%@%@,",image_Url,(self.selectedModel.type == WPMainPositionTypeInterView)?listModel.avatar:listModel.logo]:[NSString stringWithFormat:@"%@,",(self.selectedModel.type == WPMainPositionTypeInterView)?listModel.avatar:listModel.logo];
            }
            companyStr = [self getSendDic:nil];
            VC.jobid = [jobId substringToIndex:jobId.length-1];
            VC.titles = [titleStr substringToIndex:titleStr.length-1];
            VC.img_url = [image_Url substringToIndex:image_Url.length-1];
            VC.companys = companyStr;
            VC.user_id = kShareModel.userId;
            VC.collectSuccessBlock = ^(){
            [self hidden];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    if (sender.tag == 42) {//点击分享
        if (self.selectedArray.count == 0) {
            [SPAlert alertControllerWithTitle:@"提示" message:@"请至少选择一个简历！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
        }
        if (self.selectedArray.count != 0) {
            if (self.selectedArray.count ==1)
            {
                //只有一个数据时进行单个分享
                self.selectedModel = self.selectedArray[0];
                [self menuItem3:nil];
                return;
            }
            
            NSString *resumeId = @"";
            for (WPNewResumeListModel *listModel in self.selectedArray) {
                resumeId = [NSString stringWithFormat:@"%@%@%@",resumeId,listModel.resumeId,@","];
            }
            NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
            NSString *action = @"";
            if (self.selectedArray.count == 1) {
                action = (self.type == WPMainPositionTypeInterView?@"oneshareresume2":@"onesharejob2");
            }else{
                action = (self.type == WPMainPositionTypeInterView?@"shareresume2":@"sharejob2");
            }
            NSDictionary *params = @{@"action":action,
                                     (self.type == WPMainPositionTypeInterView?@"resumeid":@"jobid"):[resumeId substringToIndex:resumeId.length-1],
                                     @"user_id":kShareModel.userId,
                                     };
            
            [WPHttpTool postWithURL:str params:params success:^(id json) {
                if([json[@"status"] isEqualToString:@"1"]){
                    
                    [self shareAllResumeWithUrl:json[@"url"]];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error.localizedDescription);
            }];
        }
    }
}
-(NSString * )getShareTitile
{
    BOOL isOrNot = (self.type == WPMainPositionTypeRecruit);
    NSString * title =nil; //isOrNot?self.resumeArr[0].enterprise_name:[self.resumeArr[0] name];
    if (isOrNot) {
        WPNewResumeListModel * model = self.resumeArr[0];
        title = model.enterpriseName;
    }
    else
    {
        WPNewResumeListModel * model = self.resumeArr[0];
        title = model.name;
    }
    NSString * title1 = nil;
    
    BOOL isSameOrNot = NO;
    for (int i = 1 ; i<self.resumeArr.count; i++)
    {
        NSString * string = isOrNot?[self.resumeArr[i] enterpriseName]:[self.resumeArr[i] name];
        if (title1.length)
        {
            if (![string isEqualToString:title1] && ![string isEqualToString:title]) {
                isSameOrNot = YES;
                break;
            }
        }
        else
        {
            if (![string isEqualToString:title]) {
                title1 = string;
            }
        }
    }
    NSString * husStr = isOrNot?@"等企业的招聘信息":@"等人的求职简历";
    NSString * hasStr = isOrNot?@"的招聘信息":@"的求职简历";
    if (title1.length)
    {
        if (isSameOrNot) {
            title = [NSString stringWithFormat:@"%@,%@%@",title,title1,husStr];
        }
        else
        {
            title = [NSString stringWithFormat:@"%@,%@%@",title,title1,hasStr];
        }
    }
    else
    {
        title = [NSString stringWithFormat:@"%@%@",title,hasStr];
    }
    return title;
}
-(NSString*)getSendDic:(NSString*)url
{
    BOOL isOrNot = (self.type == WPMainPositionTypeRecruit);
    NSString * title =isOrNot?[self.selectedArray[0] enterpriseName]:[self.selectedArray[0] name];
    NSString * title1 = nil;
    
    BOOL isSameOrNot = NO;
    for (int i = 1 ; i<self.selectedArray.count; i++)
    {
        NSString * string = isOrNot?[self.selectedArray[i] enterpriseName]:[self.selectedArray[i] name];
        if (title1.length)
        {
            if (![string isEqualToString:title1] && ![string isEqualToString:title]) {
                isSameOrNot = YES;
                break;
            }
        }
        else
        {
            if (![string isEqualToString:title]) {
                title1 = string;
            }
        }
    }
    NSString * husStr = isOrNot?@"等企业的招聘信息":@"等人的求职简历";
    NSString * hasStr = isOrNot?@"的招聘信息":@"的求职简历";
    if (title1.length)
    {
        if (isSameOrNot) {
           title = [NSString stringWithFormat:@"%@,%@%@",title,title1,husStr];
        }
        else
        {
            title = [NSString stringWithFormat:@"%@,%@%@",title,title1,hasStr];
        }
    }
    else
    {
       title = [NSString stringWithFormat:@"%@%@",title,hasStr];
    }
    return title;
}
#pragma mark - 点击多个分享
- (void)shareAllResumeWithUrl:(NSString *)url{
    
    
    
//    NSString * briefStr = self.selectedModel.enterprise_brief;
//    NSString *description1 = [WPMySecurities textFromBase64String:briefStr];
//    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
//    self.selectedModel.enterprise_brief = description3;
    
    WPSendToFriends * toFriends = [[WPSendToFriends alloc]init];
    toFriends.selectedArray = self.selectedArray;
    toFriends.type = self.type;
    toFriends.isRecuilist = self.type;
    NSString * titlStr = [toFriends shareToOtherPeople:NO];
    [YYShareManager shareWithTitle:titlStr url:[IPADDRESS stringByAppendingString:url] action:^(YYShareManagerType type) {
        if (type == YYShareManagerTypeWeiPinFriends) {
            [toFriends sendToFriendsMuch:^(NSArray *array, NSArray *messageArr, NSString *userID) {
//                [self hidden];
                WPRecentLinkManController * linkMan = [[WPRecentLinkManController alloc]init];
                linkMan.dataSource = array;
                linkMan.moreTranitArray = messageArr;
                linkMan.toUserId = userID;
                [self.navigationController pushViewController:linkMan animated:YES];
            }];
        }
        if (type == YYShareManagerTypeWorkLines) {
            ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
            NSString *jobids;
            NSString *share_title;
            NSString *name;
            NSString *sex;
            NSString *birthday;
            NSString *education;
            NSString *workTime;
            NSMutableArray *jobPhoto = [NSMutableArray array];
            int i = 0;
            if(self.type == WPMainPositionTypeRecruit){//企业招聘
                for (WPNewResumeListModel *model in self.resumeArr) {
                    if (!model.isSelected) {
                        continue;
                    }
                    if (jobids.length == 0) {
                        jobids = model.resumeId;
                    }else{
                        jobids = [NSString stringWithFormat:@"%@,%@",jobids,model.resumeId];
                    }
                    if (self.resumeArr.count>1) {
//                        if (share_title.length == 0) {
//                            share_title = model.enterpriseName;
//                        }else{
//                            share_title = [NSString stringWithFormat:@"%@,%@",share_title,model.enterpriseName];
//                        }
                       share_title = [self getShareTitile];
                        
                    }else{
                        share_title = model.HopePosition;
                    }
                    if (!model.avatar) {
                        model.avatar = @"";
                    }
                    [jobPhoto addObject:@{@"small_address":model.logo}];
                    name = model.enterpriseName;
                    
                    i ++;
                }
//                share_title = [share_title stringByAppendingString:@"的招聘"];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"jobNo":[NSString stringWithFormat:@"%d",i],
                                                                                           @"jobids":jobids,
                                                                                           @"share":[NSString stringWithFormat:@"%d",3],
                                                                                           @"shareMsg":@{@"jobPhoto":jobPhoto,
                                                                                                         @"share_title":share_title,
                                                                                                         @"name":name}}];
                
                share.shareInfo = dic;
            }else{
                for (WPNewResumeListModel *model in self.resumeArr) {
                    if (!model.isSelected) {
                        continue;
                    }
                    if (jobids.length == 0) {
                        jobids = model.resumeId;
                    }else{
                        jobids = [NSString stringWithFormat:@"%@,%@",jobids,model.resumeId];
                    }
                    if (self.resumeArr.count>1) {
//                        if (share_title.length == 0) {
//                            share_title = model.name;
//                        }else{
//                            share_title = [NSString stringWithFormat:@"%@,%@",share_title,model.name];
//                        }
                        share_title = [self getShareTitile];
                    }else{
                        share_title = model.HopePosition;
                    }
                    if (!model.avatar) {
                        model.avatar = @"";
                    }
                    [jobPhoto addObject:@{@"small_address":model.avatar}];
                    name = model.name;
                    sex = model.sex;
                    birthday = model.birthday;
                    education = model.education;
                    workTime = model.WorkTim;
                    i ++;
                }
//                share_title = [share_title stringByAppendingString:@"的简历"];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"jobNo":[NSString stringWithFormat:@"%d",i],
                                                                                           @"jobids":jobids,
                                                                                           @"share":[NSString stringWithFormat:@"%d",2],
                                                                                           @"shareMsg":@{@"jobPhoto":jobPhoto,
                                                                                                         @"share_title":share_title,
                                                                                                         @"name":name,
                                                                                                         @"sex":sex,
                                                                                                         @"birthday":birthday,
                                                                                                         @"education":education,
                                                                                                         @"WorkTime":workTime}}];
                
                share.shareInfo = dic;
            }
            share.shareSuccessedBlock = ^(id json){
//                self.title = self.type ==WPMainPositionTypeInterView?@"面试":@"招聘";
                
                
                NSString * string = self.titleString.length?self.titleString:(self.type == WPMainPositionTypeInterView ?@"面试":@"企业招聘");
                self.titleView.titleString = string;
                [self hidden];
                [MBProgressHUD createHUD:@"分享成功" View:self.view];
                [self shareToWorklineSuccess];
            };
            [self.navigationController pushViewController:share animated:YES];
        }
    } status:^(UMSocialShareResponse*status) {
        if (status) {
            [self backToFromViewController:nil];
            [self.selectedArray removeAllObjects];
            for (WPNewResumeListModel *listModel in self.resumeArr) {
                listModel.isSelected = NO;
            }
            [self.tableView reloadData];
        }
    }];
}
#pragma mark 分享给单个人
- (void)shareSingleWithUrl:(NSString *)url{
    
//    NSString * briefStr = self.selectedModel.enterprise_brief;
//    NSString *description1 = [WPMySecurities textFromBase64String:briefStr];
//    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
//    self.selectedModel.enterprise_brief = description3;
    
    
    NSString *description1 = [WPMySecurities textFromBase64String:self.selectedModel.txtcontent];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    if (description3.length) {
        self.selectedModel.lightspot = description3;
    }
    WPSendToFriends * toFriends = [[WPSendToFriends alloc]init];
    toFriends.model = self.selectedModel;
    toFriends.type = self.type;
    NSString * titlStr = [toFriends shareToOtherPeople:YES];
    [YYShareManager shareWithTitle:titlStr url:[IPADDRESS stringByAppendingString:url] action:^(YYShareManagerType type) {
        if (type == YYShareManagerTypeWeiPinFriends) {//微聘朋友
            WPSendToFriends * send = [[WPSendToFriends alloc]init];
            if (self.type == WPMainPositionTypeInterView)
            {//面试
                send.isRecuilist = NO;
            }
            else
            {
                send.isRecuilist = YES;
            }
            send.model = self.selectedModel;
            [send sendeToWeiPinFriends:^(NSArray *array, NSString *toUserId, NSString *messageContent, NSString *display_type) {
                WPRecentLinkManController * linkMan = [[WPRecentLinkManController alloc]init];
                linkMan.dataSource = array;
                linkMan.toUserId = toUserId;
                linkMan.transStr = messageContent;
                linkMan.display_type = display_type;
                [self.navigationController pushViewController:linkMan animated:YES];
            }];
        }
        if (type == YYShareManagerTypeWorkLines) {
            ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
            NSString *jobids;
            NSString *share_title;
            NSString *name;
            NSString *sex;
            NSString *birthday;
            NSString *education;
            NSString *workTime;
            NSMutableArray *jobPhoto = [NSMutableArray array];
            int i = 0;
            if(self.type == WPMainPositionTypeRecruit){
                for (WPNewResumeListModel *model in self.resumeArr) {
                    if (!model.isSelected) {
                        continue;
                    }
                    if (jobids.length == 0) {
                        jobids = model.resumeId;
                    }else{
                        jobids = [NSString stringWithFormat:@"%@,%@",jobids,model.resumeId];
                    }
                    share_title = [@"招聘:" stringByAppendingString:model.jobPositon];
                    if (!model.avatar) {
                        model.avatar = @"";
                    }
                    [jobPhoto addObject:@{@"small_address":model.logo}];
                    name = model.enterpriseName;
                    
                    i ++;
                }
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"jobNo":[NSString stringWithFormat:@"%d",i],
                                                                                           @"jobids":jobids,
                                                                                           @"share":[NSString stringWithFormat:@"%d",3],
                                                                                           @"shareMsg":@{@"jobPhoto":jobPhoto,
                                                                                                         @"share_title":share_title,
                                                                                                         @"name":name}}];
                
                share.shareInfo = dic;
            }else{
                for (WPNewResumeListModel *model in self.resumeArr) {
                    if (!model.isSelected) {
                        continue;
                    }
                    if (jobids.length == 0) {
                        jobids = model.resumeId;
                    }else{
                        jobids = [NSString stringWithFormat:@"%@,%@",jobids,model.resumeId];
                    }
                    share_title = [@"求职:" stringByAppendingString:model.HopePosition];
                    if (!model.avatar) {
                        model.avatar = @"";
                    }
                    [jobPhoto addObject:@{@"small_address":model.avatar}];
                    name = model.name;
                    sex = model.sex;
                    birthday = model.birthday;
                    education = model.education;
                    workTime = model.WorkTim;
                    i ++;
                }
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"jobNo":[NSString stringWithFormat:@"%d",i],
                                                                                           @"jobids":jobids,
                                                                                           @"share":[NSString stringWithFormat:@"%d",2],
                                                                                           @"shareMsg":@{@"jobPhoto":jobPhoto,
                                                                                                         @"share_title":share_title,
                                                                                                         @"name":name,
                                                                                                         @"sex":sex,
                                                                                                         @"birthday":birthday,
                                                                                                         @"education":education,
                                                                                                         @"WorkTime":workTime}}];
                
                share.shareInfo = dic;
            }
            share.shareSuccessedBlock = ^(id json){
                [self hidden];
                [MBProgressHUD createHUD:@"分享成功" View:self.view];
               // [self shareToWorklineSuccess];
            };
            [self.navigationController pushViewController:share animated:YES];
        }
    } status:^(UMSocialShareResponse*status) {
    }];
}

#pragma mark - 网络请求
-(void)requestWithPageIndex:(int)pageIndex Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    if (self.hotPosition) {
        self.model.industryID = self.hotPosition;
    }
    if (self.hotArea) {
        self.model.industryID = self.hotArea;
    }

    NSDictionary *params = @{@"action":self.model.action,
                             @"state":self.model.states,
                             @"user_name":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"keyWords":@"",
                             @"areaID":self.model.areaID,
                             @"Position_f":self.model.industryID,
                             @"Position":self.model.Position,
                             @"Sex":self.model.Sex,
                             @"Wage":self.model.Wage,
                             @"Experience":self.model.Experience,
                             @"Demand":@"1",
                             @"education":self.model.education,
                             @"Welfare":self.model.Welfare,
                             @"age":self.model.age,
                             @"page":[NSString stringWithFormat:@"%d",pageIndex],
                             @"fromArea":self.fromArea,
                             @"clearRed":self.isIndustry?@"1":@"0"};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        WPNewResumeModel *recruitModel = [WPNewResumeModel mj_objectWithKeyValues:json];
        NSArray *arr = [[NSArray alloc]initWithArray:recruitModel.list];
        if (arr.count)
        {
            if (pageIndex == 1) {
                if (self.type == WPMainPositionTypeInterView)
                {
                    [[MTTDatabaseUtil instance] removePersonalApply];
                }
                else
                {
                    [[MTTDatabaseUtil instance] removeCompanyInvite];
                }
            }
        }
        for (WPNewResumeListModel *listModel in arr) {
            listModel.type = self.type;
            listModel.age = listModel.birthday;
            listModel.resume_user_id = listModel.userId;
            //排序
            NSString * string = listModel.time;
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSDate * date = [formatter dateFromString:string];
            NSTimeInterval timerInter = [date timeIntervalSince1970];
            listModel.timeOrder = timerInter;
            NSString *description1 = [WPMySecurities textFromBase64String:listModel.txtcontent];
            NSString *description3 = [WPMySecurities textFromEmojiString:description1];
            if (description3.length ) {
                if (self.type == WPMainPositionTypeInterView) {
                  listModel.lightspot = description3;
                }
                else
                {
                   listModel.enterprise_brief = description3;
                }
            }
        }
        //获取未上传完成的
        NSMutableArray * mudic = [NSMutableArray array];
        if (self.type == WPMainPositionTypeInterView)
        {
            if (pageIndex == 1) {
                NSArray * array = [self getMyApply];
                for (NSDictionary * dic in array) {
                    WPNewResumeListModel *listModel = [WPNewResumeListModel mj_objectWithKeyValues:dic];
                    NSString * string = listModel.time;
                    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                    NSDate * date = [formatter dateFromString:string];
                    NSTimeInterval timerInter = [date timeIntervalSince1970];
                    listModel.timeOrder = timerInter;
                    [mudic addObject:listModel];
                }
            }
        }
        else
        {
            if (pageIndex == 1) {
                NSArray * array = [self getMyWant];
                for (NSDictionary * dic  in array) {
                    WPNewResumeListModel *listModel = [WPNewResumeListModel mj_objectWithKeyValues:dic];
                    listModel.type = WPMainPositionTypeRecruit;
                    NSString * string = listModel.time;
                    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                    NSDate * date = [formatter dateFromString:string];
                    NSTimeInterval timerInter = [date timeIntervalSince1970];
                    listModel.timeOrder = timerInter;
                    [mudic addObject:listModel];
                }
            }
        }
        
        WPShuoStaticData * shuoData = [WPShuoStaticData shareShuoData];
        self.type == WPMainPositionTypeInterView?(shuoData.isShow = YES):(shuoData.isInviteShow = YES);
        if (mudic.count) {
            [mudic addObjectsFromArray:arr];
            NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"timeOrder" ascending:NO];
            NSArray * array0 = [NSArray arrayWithObject:sortFixed];
            [mudic sortUsingDescriptors:array0];
            success(mudic,(int)mudic.count);
            
            //存放到静态数据中
            if (!self.titleString.length) {
                if (pageIndex == 1)
                {
                    if (self.type == WPMainPositionTypeInterView) {
                        [shuoData.applyArray removeAllObjects];
                    }
                    else
                    {
                        [shuoData.inviteArray removeAllObjects];
                    }
                }
                
                if (self.type == WPMainPositionTypeInterView) {
                    [shuoData.applyArray addObjectsFromArray:mudic];
                }
                else
                {
                    [shuoData.inviteArray addObjectsFromArray:mudic];
                }
            }
//            if (pageIndex == 1)
//            {
//                if (self.type == WPMainPositionTypeInterView) {
//                    [shuoData.applyArray removeAllObjects];
//                }
//                else
//                {
//                    [shuoData.inviteArray removeAllObjects];
//                }
//            }
//            
//            if (self.type == WPMainPositionTypeInterView) {
//                [shuoData.applyArray addObjectsFromArray:mudic];
//            }
//            else
//            {
//                [shuoData.inviteArray addObjectsFromArray:mudic];
//            }
            
        }
        else
        {
            
          success(arr,(int)arr.count);
            //存放到静态数据中
            if (!self.titleString.length) {
                if (pageIndex == 1)
                {
                    if (self.type == WPMainPositionTypeInterView) {
                        [shuoData.applyArray removeAllObjects];
                    }
                    else
                    {
                        [shuoData.inviteArray removeAllObjects];
                    }
                }
                if (self.type == WPMainPositionTypeInterView) {
                    [shuoData.applyArray addObjectsFromArray:arr];
                }
                else
                {
                    [shuoData.inviteArray addObjectsFromArray:arr];
                }
            }
//            if (pageIndex == 1)
//            {
//                if (self.type == WPMainPositionTypeInterView) {
//                    [shuoData.applyArray removeAllObjects];
//                }
//                else
//                {
//                    [shuoData.inviteArray removeAllObjects];
//                }
//            }
//            if (self.type == WPMainPositionTypeInterView) {
//                [shuoData.applyArray addObjectsFromArray:arr];
//            }
//            else
//            {
//                [shuoData.inviteArray addObjectsFromArray:arr];
//            }
        }
        if (self.type == WPMainPositionTypeInterView) {//面试
            if (pageIndex == 1) {
                [[MTTDatabaseUtil instance] upDatePersonalInvite:arr];
            }
        }
        else
        {
            if (pageIndex == 1) {
                [[MTTDatabaseUtil instance] upDateCompanyInvite:arr];
            }
        }
        
        if (pageIndex == 1) {//将图片缓存
            for (WPNewResumeListModel*model in arr) {
                NSString * imageStr = (self.type == WPMainPositionTypeInterView)?model.avatar:model.logo;
                NSArray * pathArray = [imageStr componentsSeparatedByString:@"/"];
                NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
                NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
                NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
                BOOL isOrNot = [[NSFileManager defaultManager] fileExistsAtPath:fileName1];
                if (!isOrNot) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
                        [down downLoadImage:[NSString stringWithFormat:@"%@%@",IPADDRESS,imageStr] success:^(id response) {
                        } failed:^(NSError *error) {
                        }];
                    });
                }
            }
        }
    } failure:^(NSError *error) {
        if (pageIndex == 1) {
            //获取未上传完成的
            NSMutableArray * mudic = [NSMutableArray array];
            if (pageIndex == 1) {
                NSArray * array = self.type == WPMainPositionTypeInterView?[self getMyApply]:[self getMyWant];
                for (NSDictionary * dic in array) {
                    WPNewResumeListModel *listModel = [WPNewResumeListModel mj_objectWithKeyValues:dic];
                    listModel.type = self.type;
                    [mudic addObject:listModel];
                    for (WPNewResumeListModel * model in self.resumeArr) {
                        if ([model.guid isEqualToString:listModel.guid]) {
                            [self.resumeArr removeObject:model];
                            break;
                        }
                    }
                }
            }
            [mudic addObjectsFromArray:self.resumeArr];
            NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"updateTime" ascending:NO];
            NSArray * array0 = @[sortFixed];
            [mudic sortUsingDescriptors:array0];
            success(mudic,(int)mudic.count);
        }
        NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
    }];
}
-(NSArray*)getMyWant
{
    NSMutableArray * muarray = [NSMutableArray array];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [defaults objectForKey:@"UPLOAdMYWANT"];
    if (array.count) {
        
        for (NSDictionary * dic in array) {
            NSArray * valueArr = [dic allValues];
            NSArray * array1 = valueArr[0];
            NSDictionary * dictionsry = array1[1];
            NSArray * dicArray = dictionsry[@"json"];
            for (NSDictionary * dic in dicArray) {
                [muarray addObject:dic];
            }
        }
    }
    return [NSArray arrayWithArray:muarray];
}
-(NSArray *)getMyApply
{
    NSMutableArray * muarray = [NSMutableArray array];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [defaults objectForKey:@"UPLOAdMYAPPLY"];
    if (array.count) {
        
        for (NSDictionary * dic in array) {
            NSArray * valueArr = [dic allValues];
            NSArray * array1 = valueArr[0];
            NSDictionary * dictionsry = array1[1];
            NSDictionary * dic = dictionsry[@"json"];
            [muarray addObject:dic];
        }
    }
    return [NSArray arrayWithArray:muarray];
}
-(NSArray*)getAllArray
{

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [defaults objectForKey:@"UPLOAdMYAPPLY"];
    return array;
}
-(NSArray*)getAllWant
{
   
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [defaults objectForKey:@"UPLOAdMYWANT"];
    return array;
}
-(void)getDefaultCompany
{
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/enterprise.ashx"];
    NSDictionary *params = @{@"action":@"defaultinfo",
                             @"user_id":kShareModel.userId,
                             @"user_name":kShareModel.username,
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
                             @"user_name":kShareModel.username,
                             @"password":kShareModel.password
                             };
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        _userModel = [WPUserListModel mj_objectWithKeyValues:json];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - 点击返回
- (void)backToFromViewController:(UIButton *)sender{
    if (_collectionViewIsEditing) {
        [self hidden];
    }else{
        [self.city removeFromSuperview];
        UIView *view = [WINDOW viewWithTag:3344];
        [view removeFromSuperview];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)hidden
{
    NSString * string = self.titleString.length?self.titleString:(self.type == WPMainPositionTypeInterView ?@"面试":@"企业招聘");
    self.titleView.titleString = string;//self.type == WPMainPositionTypeInterView?@"面试":@"企业招聘"
    for (WPNewResumeListModel *model in self.resumeArr) {
        model.isSelected = NO;
    }
    _collectionViewIsEditing = NO;
    _button.hidden = NO;
    _button1.hidden = NO;
    self.editBottomView.hidden = YES;
    [self.selectedArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)chooseAreaClick:(UIButton *)sender
{
    if (!sender.selected) {
        [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
        UIView *view1 = [WINDOW viewWithTag:3344];
        view1.hidden = NO;
        //        UIView *view2 = [WINDOW viewWithTag:1001];
        //        .hidden = NO;
        _categoryCount = 19;
    }else{
        UIView *view1 = [WINDOW viewWithTag:3344];
        view1.hidden = YES;
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


-(void)switchPhotoStyle:(UIButton *)sender/**< 右按钮切换 */
{
    sender.selected = !sender.selected;
    _collectionViewItemIsFullScreen = !sender.selected;
    [_collectionView reloadData];
}


#pragma mark - 下拉菜单 headerView
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
        WPShuoStaticData * shuoData = [WPShuoStaticData shareShuoData];
//        if (self.type == WPMainPositionTypeInterView) {
//          shuoData.stateName.length?[buttonArea setTitle:shuoData.stateName forState:UIControlStateNormal]:0;
//        }
//        else
//        {
//           shuoData.IstateName.length?[buttonArea setTitle:shuoData.IstateName forState:UIControlStateNormal]:0;
//        }
        
        
        // 字体大小
        buttonArea.titleLabel.font = kFONT(14);
        buttonArea.tag = 19;
        [buttonArea setBackgroundColor:[UIColor whiteColor]];
        // 文字颜色
        [buttonArea setTitleColor:IWTabBarButtonTitleColor forState:UIControlStateNormal];
        [buttonArea setTitleColor:RGB(0, 172, 255) forState:UIControlStateSelected];
        //[buttonArea setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, buttonArea.width/2-15)];
        [buttonArea setBackgroundImage:[UIImage resizedImageWithName:@"discover_button"] forState:UIControlStateHighlighted];
        [buttonArea addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
//        [bottomInHeaderView addSubview:buttonArea];
        
       
        
        //2.设置uiscrollview
        UIScrollView *scrollViewFirst = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BOTTOMINHEADVIEWHEIGHT)];
        scrollViewFirst.backgroundColor = [UIColor whiteColor];
        [scrollViewFirst setShowsHorizontalScrollIndicator:NO];
        [scrollViewFirst setShowsVerticalScrollIndicator:NO];
        [scrollViewFirst setBounces:YES];
        scrollViewFirst.scrollsToTop = NO;
        
       
        
        NSString * provinceStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCity"];
        NSMutableArray* arrayButtonName = [NSMutableArray arrayWithArray:@[provinceStr,@"最新",@"职位",@"工资", @"经验",@"学历",@"福利",@"年龄", @"性别"]];
//        if (_isPostion) {
//            if (!_hotArea) {
//                [arrayButtonName insertObject:@"职位" atIndex:1];
//            }
//        }else{
//            [arrayButtonName insertObject:@"职位" atIndex:1];
////            [arrayButtonName insertObject:@"行业" atIndex:1]; //去掉行业
//        }
        scrollViewFirst.contentSize = CGSizeMake(arrayButtonName.count * IBUTTONXPOSITION, BOTTOMINHEADVIEWHEIGHT);
        for (int i = 0; i < arrayButtonName.count; ++i) {
            UIButton* button = [[UIButton alloc] init];
            [button setFrame:CGRectMake(i * IBUTTONXPOSITION, 0, IBUTTONXPOSITION, BOTTOMINHEADVIEWHEIGHT)];
            [button setTitle:arrayButtonName[i] forState:UIControlStateNormal];
            if (!self.titleString.length)//从行业界面进入时不保存
            {
            switch (i) {
                case 0:
                {
                    if (self.type == WPMainPositionTypeInterView) {
                        shuoData.cityName.length?[button setTitle:shuoData.cityName forState:UIControlStateNormal]:0;
                    }
                    else
                    {
                      shuoData.IcityName.length?[button setTitle:shuoData.IcityName forState:UIControlStateNormal]:0;
                    }
                }
                    break;
                    
                    case 1:
                {
                    if (self.type == WPMainPositionTypeInterView) {
                        shuoData.stateName.length?[button setTitle:shuoData.stateName forState:UIControlStateNormal]:0;
                    }
                    else
                    {
                        shuoData.IstateName.length?[button setTitle:shuoData.IstateName forState:UIControlStateNormal]:0;
                    }

                }
                    break;
                    
                case 2:
                    if (self.type == WPMainPositionTypeInterView) {
                        shuoData.positionName.length?[button setTitle:shuoData.positionName forState:UIControlStateNormal]:0;
                    }
                    else
                    {
                        shuoData.IpositionName.length?[button setTitle:shuoData.IpositionName forState:UIControlStateNormal]:0;
                    }
                    break;
                case 3:
                    if (self.type == WPMainPositionTypeInterView) {
                        shuoData.salaryName.length?[button setTitle:shuoData.salaryName forState:UIControlStateNormal]:0;
                    }
                    else
                    {
                        shuoData.IsalaryName.length?[button setTitle:shuoData.IsalaryName forState:UIControlStateNormal]:0;
                    }
                    break;
                case 4:
                    if (self.type == WPMainPositionTypeInterView) {
                        shuoData.experienceName.length?[button setTitle:shuoData.experienceName forState:UIControlStateNormal]:0;
                    }
                    else
                    {
                        shuoData.IexperienceName.length?[button setTitle:shuoData.IexperienceName forState:UIControlStateNormal]:0;
                    }
                    break;
                case 5:
                    if (self.type == WPMainPositionTypeInterView) {
                        shuoData.educationName.length?[button setTitle:shuoData.educationName forState:UIControlStateNormal]:0;
                    }
                    else
                    {
                        shuoData.IeducationName.length?[button setTitle:shuoData.IeducationName forState:UIControlStateNormal]:0;
                    }
                    break;
                case 6:
                    if (self.type == WPMainPositionTypeInterView) {
                        shuoData.welfareName.length?[button setTitle:shuoData.welfareName forState:UIControlStateNormal]:0;
                    }
                    else
                    {
                        shuoData.IwelfareName.length?[button setTitle:shuoData.IwelfareName forState:UIControlStateNormal]:0;
                    }
                    break;
                case 7:
                    if (self.type == WPMainPositionTypeInterView) {
                        shuoData.ageName.length?[button setTitle:shuoData.ageName forState:UIControlStateNormal]:0;
                    }
                    else
                    {
                        shuoData.IageName.length?[button setTitle:shuoData.IageName forState:UIControlStateNormal]:0;
                    }
                    break;
                case 8:
                    if (self.type == WPMainPositionTypeInterView) {
                        shuoData.sexName.length?[button setTitle:shuoData.sexName forState:UIControlStateNormal]:0;
                    }
                    else
                    {
                        shuoData.IsexName.length?[button setTitle:shuoData.IsexName forState:UIControlStateNormal]:0;
                    }
                    break;
                default:
                    break;
            }
          }
            // 字体大小
            button.titleLabel.font = kFONT(14);
            button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [button setBackgroundColor:[UIColor whiteColor]];
            
            // 文字颜色
            [button setTitleColor:IWTabBarButtonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:WPColor(0, 172, 255) forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage resizedImageWithName:@"discover_button"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
            [button setTag:10+i];
            [scrollViewFirst addSubview:button];
        }
        //小红点
        UILabel * redBot =[[UILabel alloc]initWithFrame:CGRectMake(IBUTTONXPOSITION+IBUTTONXPOSITION-12, 6, 8, 8)];
        redBot.backgroundColor = [UIColor redColor];
        redBot.layer.cornerRadius = 4;
        redBot.clipsToBounds = YES;
        redBot.tag = 20;
        redBot.hidden = YES;
        [scrollViewFirst addSubview:redBot];
        [bottomInHeaderView addSubview:scrollViewFirst];
    }
    return _headerView;
}

#pragma makr 创建弹出的视图
- (UISelectCity *)city
{
    if (!_city) {
        _city = [[UISelectCity alloc]initWithFrame:CGRectMake(0, 64+HEADVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64-HEADVIEWHEIGHT)];
        _city.delegate = self;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *subView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64+40)];
        subView1.tag = 3344;//1000
        subView1.backgroundColor = RGBA(0, 0, 0, 0);
        [window addSubview:subView1];
        WS(ws);
        _city.touchHide =^(){
            [ws touchHide:nil];
        };
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]init];
        [tap1 addTarget:self action:@selector(touchHide:)];
        [subView1 addGestureRecognizer:tap1];
        [window addSubview:_city];
    }
    return _city;
}

#pragma mark 点击选择的面试条件
- (void)buttonClick:(UIButton*)sender/**< 选中的分类 */
{
    sender.selected = !sender.selected;
    
    if(sender.selected){
        if(_selectedButton == sender){
            UIView *view1 = [WINDOW viewWithTag:3344];
            _selectedButton = nil;
            view1.hidden = YES;
            [self.city remove];
        }else{
            _selectedButton.selected = !_selectedButton.selected;
            self.selectedButton = sender;
            UIView *view1 = [WINDOW viewWithTag:3344];
            view1.hidden = NO;
            _categoryCount = sender.tag;
            
            NSArray *statesArr = (self.type == WPMainPositionTypeInterView?@[@"最新求职",@"好友求职"]:@[@"最新招聘",@"好友招聘"]);//,@"陌生人求职",@"我的求职",@"陌生人招聘",@"我的招聘"
            NSMutableArray *states = [[NSMutableArray alloc]init];
            for (int i = 0; i < statesArr.count; i++) {
                IndustryModel *model = [[IndustryModel alloc]init];
                model.industryName = statesArr[i];
               if([model.industryName isEqualToString:@"推荐简历"])
               {
                   model.industryID = @"5";
               }
              else
                {
                  model.industryID = [NSString stringWithFormat:@"%@",@(i+1)];
                }
                [states addObject:model];
            }
            self.city.isFriend = NO;
            self.city.isWelafer = NO;
            [self.city.bottomBtn removeFromSuperview];
            switch (sender.tag-10) {
                case 0://区域
                {  self.city.isArea = YES;
                    self.city.isIndusty = NO;
                    self.city.isCity = YES;
                    self.city.isPosition = NO;
                    
                    //将定位的id保存以便于判断数组中应添加的类型
                    [[NSUserDefaults standardUserDefaults] setObject:@"340100" forKey:@"LOCALID"];
                    self.city.localName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCity"];
                    self.city.localFatherName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localPrivince"];
                    self.city.localID = @"340100";
                    self.city.localFatherId = @"340000";
                    
                    
                    [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":self.model.fatherID.length?self.model.fatherID:@"340100"} citySelectedindex:_citySelectedNumber];
                }
                    break;
//                case 1:/**< 行业 */
//                    self.city.isArea = NO;
//                    self.city.isIndusty = YES;
//                    [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getIndustry",@"fatherid":@"0"} selectedIndex:_industrySelectedNumber];
//                    break;
                case 2:/**< 职位 */
                {
                    self.city.isCity = NO;
                    self.city.isPosition = YES;
                    self.city.isArea = NO;
                    self.city.isIndusty = NO;
                    self.city.isResume = YES;
                    
                    NSString * string = self.hangFatherID;
                    self.city.isFromHangYe = string.length;
                    string.length ? ([string isEqualToString:@"0"]?(string = self.positionHangID):0) : (string = @"0");
                    [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getNearPosition",@"fatherid":string} selectedIndex:_positionSelectedNumber];
                }
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
                {
                    self.city.isWelafer = YES;
                    [self.city setLocalData:[SPLocalApplyArray unLimitWelfareArray] selectedIndex:_welfareSelectedNumber];
                    __weak typeof(self) weakSelf = self;
                    self.city.clickBottomBtn = ^(NSArray*array){
                        [weakSelf touchHide:nil];
                        _welfareSelectedNumber = -1;
                        NSString * string   = [NSString new];
                        NSString * nameStr = [NSString new];
                        for (IndustryModel *model in array) {
                            if(model.isSelected)
                            {
                              if(string.length)
                              {
                                  string = [NSString stringWithFormat:@"%@,%@",string,model.industryID];
                                  nameStr = [NSString stringWithFormat:@"%@,%@",nameStr,model.industryName];
                              }
                            else
                              {
                                  string = model.industryID;
                                  nameStr = model.industryName;
                              }
                            }
                        }
                        UIButton *button = (UIButton *)[weakSelf.view viewWithTag:weakSelf.categoryCount];
                        [button setTitle:nameStr forState:UIControlStateNormal];
                        weakSelf.model.Welfare = string;
                        WPShuoStaticData * shuoData = [WPShuoStaticData shareShuoData];
                        if (!weakSelf.titleString.length) {
                            if (weakSelf.type == WPMainPositionTypeInterView) {
                                shuoData.welfareID = string;
                                shuoData.welfareName = nameStr;
                            }
                            else
                            {
                                shuoData.IwelfareID = string;
                                shuoData.IwelfareName = nameStr;
                            }
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            __weak __typeof(weakSelf) unself = weakSelf;
                            [weakSelf.titleView.activity startAnimating];
                            [weakSelf requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
                                [weakSelf.titleView.activity stopAnimating];
                                [weakSelf.resumeArr removeAllObjects];
                                [weakSelf.resumeArr addObjectsFromArray:datas];
                                [weakSelf.tableView reloadData];
                                [weakSelf.tableView scrollToTop];
                            } Error:^(NSError *error) {
                                [weakSelf.titleView.activity stopAnimating];
                            }];
                            [weakSelf.collectionView.mj_header beginRefreshing];
                        });
        
                    };
                }
                    break;
                case 7:/**< 年龄 */
                    [self.city setLocalData:[SPLocalApplyArray ageArray] selectedIndex:_ageSelectedNumber];
                    break;
                case 8:/**< 性别 */
                    [self.city setLocalData:[SPLocalApplyArray sexWithNoLimitArray] selectedIndex:_sexSelectedNumber];
                    break;
                case 1:/**< 最新 */
                    self.city.isNew = self.isNew;
                    self.city.isFriend = self.isFriend;
                    [self.city setLocalData:states selectedIndex:_typeSelectedNumber];
                default:
                    break;
            }
        }
    }else{//隐藏弹出的视图
        UIView *view1 = [WINDOW viewWithTag:3344];
        _selectedButton = nil;
        view1.hidden = YES;
        [self.city remove];
    }
}

#pragma mark 点击职位的代理方法
- (void)uiselectDelegateFatherModel:(IndustryModel *)f_model andChildModel:(IndustryModel *)c_model
{
    UIView *view1 = [WINDOW viewWithTag:3344];
    _selectedButton.selected = NO;
    _selectedButton = nil;
    view1.hidden = YES;
    [self.city remove];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:12];
        [button setTitle:c_model.industryName forState:UIControlStateNormal];
        self.model.Position = c_model.industryID;
        self.model.industryID = f_model.industryID;
        _positionSelectedNumber.section = f_model.section;
        _positionSelectedNumber.row = c_model.row;
        
        if (!self.titleString.length) {
            WPShuoStaticData * shuoData = [WPShuoStaticData shareShuoData];
            if (self.type == WPMainPositionTypeInterView)
            {
                shuoData.positionID = c_model.industryID;
                shuoData.positionName = c_model.industryName;
                shuoData.positionIndustry = f_model.industryID;
                shuoData.positionSelected = f_model.section;
                shuoData.positionSelectedRow = c_model.row;
                [shuoData.applyArray removeAllObjects];
            }
            else
            {
                shuoData.IpositionID = c_model.industryID;
                shuoData.IpositionName = c_model.industryName;
                shuoData.IpositionIndustry = f_model.industryID;
                shuoData.IpositionSelected = f_model.section;
                shuoData.IpositionSelectedRow = c_model.row;
                [shuoData.inviteArray removeAllObjects];
            }
        }
  
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak __typeof(self) unself = self;
        [self.titleView.activity startAnimating];
        [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
            [self.titleView.activity stopAnimating];
            [unself.resumeArr removeAllObjects];
            [unself.resumeArr addObjectsFromArray:datas];
            [unself.tableView reloadData];
        } Error:^(NSError *error) {
            [self.titleView.activity stopAnimating];
        }];
        [self.collectionView.mj_header beginRefreshing];
    });
    
    
//    __weak __typeof(self) unself = self;
//    [self.titleView.activity startAnimating];
//    [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
//        [self.titleView.activity stopAnimating];
//        [unself.resumeArr removeAllObjects];
//        [unself.resumeArr addObjectsFromArray:datas];
//        [unself.tableView reloadData];
//    } Error:^(NSError *error) {
//        [self.titleView.activity stopAnimating];
//    }];
//    [self.collectionView.mj_header beginRefreshing];
}
#pragma mark 点击地区的代理方法
- (void)citUiselectDelegateFatherModel:(IndustryModel *)f_model andChildModel:(IndustryModel *)c_model
{
    _cityModel = f_model;
    UIView *view1 = [WINDOW viewWithTag:3344];
    _selectedButton.selected = NO;
    _selectedButton = nil;
    view1.hidden = YES;
    [self.city remove];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:_categoryCount];
    if (_categoryCount-10 != 9) {
        [button setTitle:f_model.industryName forState:UIControlStateNormal];
    }
    
    _citySelectedNumber.section = f_model.section;
    _citySelectedNumber.row = c_model.row;
    self.model.areaID = f_model.industryID;
    self.model.fatherID = f_model.fatherID;
    
    //数据存放到静态变量中
    WPShuoStaticData * shuoData = [WPShuoStaticData shareShuoData];
    if (self.type == WPMainPositionTypeInterView)
    {
        shuoData.cityName = f_model.industryName;
        shuoData.cityID = f_model.industryID;
        shuoData.fatherCityID = f_model.fatherID;
        shuoData.citySelected = f_model.section;
        shuoData.citySelectedRow = c_model.row;
        [shuoData.applyArray removeAllObjects];
    }
    else
    {
        shuoData.IcityName = f_model.industryName;
        shuoData.IcityID = f_model.industryID;
        shuoData.IfatherCityID = f_model.fatherID;
        shuoData.IcitySelected = f_model.section;
        shuoData.IcitySelectedRow = c_model.row;
        [shuoData.inviteArray removeAllObjects];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak __typeof(self) unself = self;
        [self.titleView.activity startAnimating];
        [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
            [self.titleView.activity stopAnimating];
            [unself.resumeArr removeAllObjects];
            [unself.resumeArr addObjectsFromArray:datas];
            [unself.tableView reloadData];
        } Error:^(NSError *error) {
            [self.titleView.activity stopAnimating];
        }];
        [self.collectionView.mj_header beginRefreshing];
    });
    
//    __weak __typeof(self) unself = self;
//    [self.titleView.activity startAnimating];
//    [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
//        [self.titleView.activity stopAnimating];
//        [unself.resumeArr removeAllObjects];
//        [unself.resumeArr addObjectsFromArray:datas];
//        [unself.tableView reloadData];
//    } Error:^(NSError *error) {
//        [self.titleView.activity stopAnimating];
//    }];
//    [self.collectionView.mj_header beginRefreshing];
}
#pragma mark -最新 工资，经验，学历...的代理方法
-(void)UISelectDelegate:(IndustryModel *)model
{
    UIView *view1 = [WINDOW viewWithTag:3344];
    _selectedButton.selected = NO;
    _selectedButton = nil;
    view1.hidden = YES;
    [self.city remove];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:_categoryCount];
    if (_categoryCount-10 != 9) {
        [button setTitle:model.industryName forState:UIControlStateNormal];
    }
    
    WPShuoStaticData * shuoData = [WPShuoStaticData shareShuoData];
    switch (_categoryCount-10) {
        case 0:
            self.model.areaID = model.industryID;
            break;
//        case 1:/**< 行业 */
//            self.model.industryID = model.industryID;
//            _industrySelectedNumber.section = model.section;
//            _industrySelectedNumber.row = model.row;
//            break;
//        case 1:/**< 职称 */
//            self.model.Position = model.industryID;
//            NSLog(@"%@",model.industryID);
//            _positionSelectedNumber.section = model.section;
//            _positionSelectedNumber.row = model.row;
//            break;
        case 3:/**< 工资 */
            self.model.Wage = model.industryID;
            if ([model.industryName isEqualToString:@"面议"]) {
                [button setTitle:@"工资" forState:UIControlStateNormal];
            }
            _salarySelectedNumber = model.section;
            
            if (!self.titleString.length) {
                //静态数据
                if (self.type == WPMainPositionTypeInterView) {
                    shuoData.salaryID = model.industryID;
                    shuoData.salaryName = [model.industryName isEqualToString:@"面议"]?@"工资":model.industryName;
                    shuoData.salarySelected = model.section;
                }
                else
                {
                    shuoData.IsalaryID = model.industryID;
                    shuoData.IsalaryName = [model.industryName isEqualToString:@"面议"]?@"工资":model.industryName;
                    shuoData.IsalarySelected = model.section;
                }
            }
//            //静态数据
//            if (self.type == WPMainPositionTypeInterView) {
//                shuoData.salaryID = model.industryID;
//                shuoData.salaryName = [model.industryName isEqualToString:@"面议"]?@"工资":model.industryName;
//                shuoData.salarySelected = model.section;
//            }
//            else
//            {
//                shuoData.IsalaryID = model.industryID;
//                shuoData.IsalaryName = [model.industryName isEqualToString:@"面议"]?@"工资":model.industryName;
//                shuoData.IsalarySelected = model.section;
//            }
            
            
            break;
        case 4:/**< 经验 */
            self.model.Experience = model.industryID;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"经验" forState:UIControlStateNormal];
            }
            _worktimeSelectedNumber = model.section;
            
            if (!self.titleString.length) {
                if (self.type == WPMainPositionTypeInterView) {
                    shuoData.experienceID = model.industryID;
                    shuoData.experienceName = [model.industryName isEqualToString:@"不限"]?@"经验":model.industryName;
                    shuoData.experienceSelected = model.section;
                }
                else
                {
                    shuoData.IexperienceID = model.industryID;
                    shuoData.IexperienceName = [model.industryName isEqualToString:@"不限"]?@"经验":model.industryName;
                    shuoData.IexperienceSelected = model.section;
                }
            }
            //静态数据
//            if (self.type == WPMainPositionTypeInterView) {
//                shuoData.experienceID = model.industryID;
//                shuoData.experienceName = [model.industryName isEqualToString:@"不限"]?@"经验":model.industryName;
//                shuoData.experienceSelected = model.section;
//            }
//            else
//            {
//                shuoData.IexperienceID = model.industryID;
//                shuoData.IexperienceName = [model.industryName isEqualToString:@"不限"]?@"经验":model.industryName;
//                shuoData.IexperienceSelected = model.section;
//            }
           
            break;
        case 5:/**< 学历 */
            self.model.education = model.industryName;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"学历" forState:UIControlStateNormal];
            }
            _educationSelectedNumber = model.section;
            
            if (!self.titleString.length) {
                if (self.type == WPMainPositionTypeInterView) {
                    shuoData.educationID = model.industryID;
                    shuoData.educationName = [model.industryName isEqualToString:@"不限"]?@"学历":model.industryName;
                    shuoData.educationSelected = model.section;
                }
                else
                {
                    shuoData.IeducationID = model.industryID;
                    shuoData.IeducationName = [model.industryName isEqualToString:@"不限"]?@"学历":model.industryName;
                    shuoData.IeducationSelected = model.section;
                }
            }
            //静态数据
//            if (self.type == WPMainPositionTypeInterView) {
//                shuoData.educationID = model.industryID;
//                shuoData.educationName = [model.industryName isEqualToString:@"不限"]?@"学历":model.industryName;
//                shuoData.educationSelected = model.section;
//            }
//            else
//            {
//                shuoData.IeducationID = model.industryID;
//                shuoData.IeducationName = [model.industryName isEqualToString:@"不限"]?@"学历":model.industryName;
//                shuoData.IeducationSelected = model.section;
//            }
           
            break;
        case 6:/**< 福利 */
            self.model.Welfare = model.industryID;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"福利" forState:UIControlStateNormal];
            }
            _welfareSelectedNumber = model.section;
            
            if (!self.titleString.length) {
                if (self.type == WPMainPositionTypeInterView) {
                    shuoData.welfareID = model.industryID;
                    shuoData.welfareName = [model.industryName isEqualToString:@"不限"]?@"福利":model.industryName;
                    shuoData.welfareSelected = model.section;
                }
                else
                {
                    shuoData.IwelfareID = model.industryID;
                    shuoData.IwelfareName = [model.industryName isEqualToString:@"不限"]?@"福利":model.industryName;
                    shuoData.IwelfareSelected = model.section;
                }
            }
            //静态数据
//            if (self.type == WPMainPositionTypeInterView) {
//                shuoData.welfareID = model.industryID;
//                shuoData.welfareName = [model.industryName isEqualToString:@"不限"]?@"福利":model.industryName;
//                shuoData.welfareSelected = model.section;
//            }
//            else
//            {
//                shuoData.IwelfareID = model.industryID;
//                shuoData.IwelfareName = [model.industryName isEqualToString:@"不限"]?@"福利":model.industryName;
//                shuoData.IwelfareSelected = model.section;
//            }
            
            break;
        case 7:/**< 年龄 */
            self.model.age = model.industryName;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"年龄" forState:UIControlStateNormal];
            }
            _ageSelectedNumber = model.section;
            
            if (!self.titleString.length) {
                if (self.type == WPMainPositionTypeInterView) {
                    shuoData.ageName = [model.industryName isEqualToString:@"不限"]?@"年龄":model.industryName;
                    shuoData.ageSelected = model.section;
                }
                else
                {
                    shuoData.IageName = [model.industryName isEqualToString:@"不限"]?@"年龄":model.industryName;
                    shuoData.IageSelected = model.section;
                }
            }
            //静态数据
//            if (self.type == WPMainPositionTypeInterView) {
//                shuoData.ageName = [model.industryName isEqualToString:@"不限"]?@"年龄":model.industryName;
//                shuoData.ageSelected = model.section;
//            }
//            else
//            {
//                shuoData.IageName = [model.industryName isEqualToString:@"不限"]?@"年龄":model.industryName;
//                shuoData.IageSelected = model.section;
//            }
            
            break;
        case 8:/**< 性别 */
            self.model.Sex = model.industryID;
            if ([model.industryName isEqualToString:@"不限"]) {
                [button setTitle:@"性别" forState:UIControlStateNormal];
            }
            _sexSelectedNumber = model.section;
            
            if (!self.titleString.length) {
                if (self.type == WPMainPositionTypeInterView) {
                    shuoData.sexID = model.industryID;
                    shuoData.sexName = [model.industryName isEqualToString:@"不限"]?@"性别":model.industryName;
                    shuoData.sexSelected = model.section;
                }
                else
                {
                    shuoData.IsexID = model.industryID;
                    shuoData.IsexName = [model.industryName isEqualToString:@"不限"]?@"性别":model.industryName;
                    shuoData.IsexSelected = model.section;
                }
            }
            //静态数据
//            if (self.type == WPMainPositionTypeInterView) {
//                shuoData.sexID = model.industryID;
//                shuoData.sexName = [model.industryName isEqualToString:@"不限"]?@"性别":model.industryName;
//                shuoData.sexSelected = model.section;
//            }
//            else
//            {
//                shuoData.IsexID = model.industryID;
//                shuoData.IsexName = [model.industryName isEqualToString:@"不限"]?@"性别":model.industryName;
//                shuoData.IsexSelected = model.section;
//            }
           
            break;
        case 1:/**< 最新 */
            self.model.states = model.industryID;
            _typeSelectedNumber = model.section;
            NSLog(@"");
            NSString *str = [model.industryName substringToIndex:model.industryName.length-2];
            [button setTitle:str forState:UIControlStateNormal];
            
            if (!self.titleString.length) {
                if (self.type == WPMainPositionTypeInterView) {
                    shuoData.stateID = model.industryID;
                    shuoData.stateName = str;
                    shuoData.stateSelected = model.section;
                }
                else
                {
                    shuoData.IstateID = model.industryID;
                    shuoData.IstateName = str;
                    shuoData.IstateSelected = model.section;
                }
            }
            //静态数据
//            if (self.type == WPMainPositionTypeInterView) {
//                shuoData.stateID = model.industryID;
//                shuoData.stateName = str;
//                shuoData.stateSelected = model.section;
//            }
//            else
//            {
//                shuoData.IstateID = model.industryID;
//                shuoData.IstateName = str;
//                shuoData.IstateSelected = model.section;
//            }
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak __typeof(self) unself = self;
        [self.titleView.activity startAnimating];
        [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
            [self.titleView.activity stopAnimating];
            [unself.resumeArr removeAllObjects];
            [unself.resumeArr addObjectsFromArray:datas];
            [unself.tableView reloadData];
            [unself.tableView scrollToTop];
        } Error:^(NSError *error) {
            [self.titleView.activity stopAnimating];
        }];
        [self.collectionView.mj_header beginRefreshing];
    });
//    __weak __typeof(self) unself = self;
//    [self.titleView.activity startAnimating];
//    [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
//        [self.titleView.activity stopAnimating];
//        [unself.resumeArr removeAllObjects];
//        [unself.resumeArr addObjectsFromArray:datas];
//        [unself.tableView reloadData];
//    } Error:^(NSError *error) {
//        [self.titleView.activity stopAnimating];
//    }];
//    [self.collectionView.mj_header beginRefreshing];
}


#pragma mark - 求职or招聘回调函数
- (void)WPInterviewControllerDelegate{
    [self.collectionView.mj_header beginRefreshing];
}

- (void)WPRecuilistControllerDelegate{
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - 点击抢人和申请
-(void)menuItem:(id)sender
{
    if (self.type == WPMainPositionTypeInterView) {//点击面试的抢人
        if ([self.selectedModel.resume_user_id isEqualToString:kShareModel.userId]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不能投递自己发布的职位!" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        WPInterviewApplyController *apply = [[WPInterviewApplyController alloc] init];
        apply.sid = self.selectedModel.resumeId;
        apply.isFromList = YES;
        apply.delegate = self;
        apply.robSuccess = ^(){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"企业招聘发布邀请成功，请加对方为好友，以便后续联系方便，谢谢使用快捷招聘，网络招聘需谨慎，谨防求职骗局，如发现违法求职者，请及时报警和举报！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        };
        [self.navigationController pushViewController:apply animated:YES];
    } else {//点击招聘申请
        if ([self.selectedModel.resume_user_id isEqualToString:kShareModel.userId]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不能申请自己发布的职位!" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        WPRecruitApplyController *interview = [[WPRecruitApplyController alloc]init];
        interview.sid = self.selectedModel.resumeId;
        interview.isApplyFromList = YES;
        interview.title = @"申请";
        interview.applySuccess = ^(){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"个人求职简历申请成功，请加对方为好友，以便后续联系方便，谢谢使用快捷招聘，网络求职需谨慎，谨防招聘骗局，如发现违法招聘，请及时报警和举报！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        };
        [self.navigationController pushViewController:interview animated:YES];
    }
}

- (void)isAlready
{
    [self hidden];
}
#pragma mark 点击收藏
-(void)menuItem2:(id)sender
{
    CollectViewController *VC = [[CollectViewController alloc]init];
    VC.collect_class = (self.type == WPMainPositionTypeInterView?@"6":@"5");
    VC.user_id = self.selectedModel.userId;
    if (self.selectedModel.type == WPMainPositionTypeInterView) {
        VC.jobid = self.selectedModel.resumeId;
        VC.titles = self.selectedModel.HopePosition;
        VC.img_url = self.selectedModel.avatar;
        VC.companys = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",self.selectedModel.name.length?self.selectedModel.name:@"",self.selectedModel.sex.length?self.selectedModel.sex:@"",self.selectedModel.age.length?self.selectedModel.age:@"",self.selectedModel.education.length?self.selectedModel.education:@"",self.selectedModel.WorkTim.length?self.selectedModel.WorkTim:@""];
    }
    if (self.selectedModel.type == WPMainPositionTypeRecruit) {
        VC.jobid = self.selectedModel.resumeId;
        VC.titles = self.selectedModel.jobPositon;
        VC.img_url = self.selectedModel.logo;
        VC.companys = self.selectedModel.enterpriseName;
    }
    [self.navigationController pushViewController:VC animated:YES];
//    NSString *url  = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
//    
//    NSDictionary *dic = @{@"action":@"ResumeCollect",
//                          @"user_id":kShareModel.userId,
//                          @"username":kShareModel.username,
//                          @"password":kShareModel.password,
//                          @"resume_id":self.selectedModel.resumeId};
//    
//    [WPHttpTool postWithURL:url params:dic success:^(id json) {
//        [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
}

#pragma mark 点击分享
-(void)menuItem3:(id)sender
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
    NSDictionary *params = @{@"action":(self.type == WPMainPositionTypeInterView?@"oneshareresume2":@"onesharejob2"),
                             (self.type == WPMainPositionTypeInterView?@"resumeid":@"jobid"):self.selectedModel.resumeId,
                             @"user_id":kShareModel.userId,
                             };
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        if([json[@"status"] isEqualToString:@"1"]){
            [self shareSingleWithUrl:json[@"url"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)shareToWorklineSuccess
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
    NSDictionary *params = @{@"action":(self.type == WPMainPositionTypeInterView?@"oneshareresume":@"onesharejob"),
                             (self.type == WPMainPositionTypeInterView?@"resumeid":@"jobid"):self.selectedModel.resumeId,
                             @"user_id":kShareModel.userId,
                             };
    [WPHttpTool postWithURL:str params:params success:^(id json) {
    } failure:^(NSError *error) {
    }];
}
#pragma mark 点击更多
-(void)menuItem4:(id)sender
{
    _collectionViewIsEditing = YES;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:currentCell];
    WPNewResumeListModel *Model = self.resumeArr[indexPath.row];
    [self.selectedArray addObject:Model];
    [self.tableView reloadData];
    
    _button.hidden = YES;
    _button1.hidden = YES;
    self.editBottomView.hidden = NO;
    
    
    NSString * string = self.titleString.length?self.titleString:(self.type == WPMainPositionTypeInterView ?@"面试":@"企业招聘");
    if (self.type == WPMainPositionTypeInterView)
    {
//        self.titleView.titleString = @"面试(1/20)";
        self.titleView.titleString = [NSString stringWithFormat:@"%@(1/20)",string];
        NSArray * arary = [self getAllArray];
        for (NSDictionary * dic in arary) {
            if (dic[Model.guid]) {
                Model.isSelected = NO;
                [self.selectedArray removeObject:Model];
//                self.titleView.titleString = @"面试(0/20)";
                 self.titleView.titleString = [NSString stringWithFormat:@"%@(0/20)",string];
            }
        }
    }
    else
    {

//        self.titleView.titleString = @"企业招聘(1/20)";
         self.titleView.titleString = [NSString stringWithFormat:@"%@(1/20)",string];
        NSArray * arary = [self getAllArray];
        for (NSDictionary * dic in arary) {
            if (dic[Model.guid]) {
                Model.isSelected = NO;
                [self.selectedArray removeObject:Model];
//                self.titleView.titleString = @"企业招聘(0/20)";
                 self.titleView.titleString = [NSString stringWithFormat:@"%@(0/20)",string];
            }
        }
        
    }
}

#pragma mark - UIGestureDelegate
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - 长按后触发该方法
// 该方法为长按菜单触发方法
-(void)longPressWebView:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (!_collectionViewIsEditing) {
        //判断长按状态
        if ([gestureRecognizer state]==UIGestureRecognizerStateBegan)
        {
            
            //必须设置为第一响应者
            currentCell = (WPNewResumeTableViewCell *)gestureRecognizer.view;
            currentCell.selected = YES;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:currentCell];
            self.selectedModel = self.resumeArr[indexPath.row];
            
            BOOL isSameMen = [self.selectedModel.userId isEqualToString:kShareModel.userId];
            
            for (WPNewResumeListModel *model in self.resumeArr) {
                if (self.selectedModel != model) {
                    model.isSelected = NO;
                }
            }
            self.selectedModel .isSelected = YES;
            [currentCell becomeFirstResponder];
            
            //得到菜单栏
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            [menuController setMenuVisible:NO];
            //设置菜单
            UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:self.type == WPMainPositionTypeInterView ? @"抢人" : @"申请" action:@selector(menuItem:)];
            UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(menuItem2:)];
            UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"分享" action:@selector(menuItem3:)];
            UIMenuItem *menuItem4 = [[UIMenuItem alloc] initWithTitle:@"更多..." action:@selector(menuItem4:)];
            
            if (isSameMen)//本人发布的不显示抢人和申请
            {
              [menuController setMenuItems:[NSArray arrayWithObjects:menuItem2,menuItem3,menuItem4, nil]];
            }
            else
            {
               [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem2,menuItem3,menuItem4, nil]];
            }
//            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem2,menuItem3,menuItem4, nil]];
            //设置菜单栏位置
            [menuController setTargetRect:currentCell.frame inView:currentCell.superview];
            //显示菜单栏
            [menuController setMenuVisible:YES animated:YES];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
        }
//        else if ([gestureRecognizer state]== UIGestureRecognizerStateCancelled || [gestureRecognizer state]== UIGestureRecognizerStateEnded)
//        {
//          currentCell = (WPNewResumeTableViewCell *)gestureRecognizer.view;
//            currentCell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
//        }
    }
}

//- (void)longPress:(UILongPressGestureRecognizer *)recognizer{
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        WPNewFullCell *cell = (WPNewFullCell *)recognizer.view;
////        self.clickCell = cell;
//        [cell becomeFirstResponder];
//        cell.backgroundColor = RGB(226, 226, 226);
//        
//        UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(flag:)];
//        UIMenuController *menu = [UIMenuController sharedMenuController];
//        
//        [menu setMenuItems:[NSArray arrayWithObjects:flag, nil]];
//        [menu setTargetRect:cell.frame inView:cell.superview];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
//        [menu setMenuVisible:YES animated:YES];
//    }
//}


- (void)WillHideMenu:(id)sender
{
    currentCell.selected = NO;
    [currentCell resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.resumeArr.count];
    return self.resumeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPNewResumeTableViewCell *cell = [WPNewResumeTableViewCell cellWithTableView:tableView];
    cell.model = self.resumeArr[indexPath.row];
    if (cell.model.userId == kShareModel.userId)
    {
        NSLog(@"%@",kShareModel.userId);
        
    }
    else
    {
        if (self.type == WPMainPositionTypeRecruit) {
            cell.status = @"申请";
        }else{
            cell.status = @"抢人";
        }
    }
    //编辑状态改变控件的位置
    [cell exchangeSubViewFrame:_collectionViewIsEditing];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = RGB(226, 226, 226);
    //添加到cell
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWebView:)];
    recognizer.minimumPressDuration = 0.5;
    [cell addGestureRecognizer:recognizer];
    
    WPNewResumeListModel * model = self.resumeArr[indexPath.row];
    NSArray * array = (self.type == WPMainPositionTypeRecruit)?[self getAllArray]:[self getMyWant];
    BOOL isOrNot = NO;
    for (NSDictionary * dic  in array) {
        if (dic[model.guid]) {
            isOrNot = YES;
            break;
        }
    }
    if (isOrNot) {
         cell.canSlected = YES;
    }
    else
    {
        cell.canSlected = NO;
    }
  
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPNewResumeListModel *model = self.resumeArr[indexPath.row];
    if (!_collectionViewIsEditing) {//点击抢人
        NearInterViewController *interView = [[NearInterViewController alloc]init];
        interView.isRecuilist = self.type == WPMainPositionTypeInterView?0:1;
        interView.subId = model.resumeId;
        interView.resumeId = model.resumeId;
        interView.userId = model.userId;
        interView.model = model;
        WPShareModel *shareModel = [WPShareModel sharedModel];
        interView.isSelf = [model.userId isEqualToString:shareModel.dic[@"userid"]];
        if (self.type == WPMainPositionTypeInterView) {
            interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,model.resumeId,kShareModel.userId];
        }else{
            interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,model.resumeId,kShareModel.userId];
        }
        [self.navigationController pushViewController:interView animated:YES];
    }else{//点击更多
        //未发送完成的不可点击
        NSArray * arary = [self getAllArray];
        for (NSDictionary * dic in arary) {
            if (dic[model.guid]) {
                return;
            }
        }
            WPNewResumeTableViewCell *cell = (WPNewResumeTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            if (cell.model.isSelected) {
                for (WPNewResumeListModel *listModel in self.selectedArray) {
                    if ([listModel.resumeId isEqualToString:cell.model.resumeId]) {
                        [self.selectedArray removeObject:listModel];
                        break;
                    }
                }
            }else{
                
                if (self.selectedArray.count ==20) {
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能选择20条" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    return;
                }
                [self.selectedArray addObject:model];
            }
        cell.model.isSelected = !cell.model.isSelected;
        NSString * string = self.titleString.length?self.titleString:(self.type == WPMainPositionTypeInterView ?@"面试":@"企业招聘");
        if (self.type == WPMainPositionTypeInterView) {
            self.titleView.titleString = [NSString stringWithFormat:@"%@(%lu/20)",string,(unsigned long)self.selectedArray.count];
        }
        else
        {
            self.titleView.titleString = [NSString stringWithFormat:@"%@(%lu/20)",string,(unsigned long)self.selectedArray.count];
        }
        [tableView reloadData];
    }

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
    
//    if (_collectionViewItemIsFullScreen) {
        static NSString *cellId = @"WPNewFullCell";
        WPNewFullCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        cell.model = self.resumeArr[indexPath.row];
        if (cell.model.userId == kShareModel.userId)
        {
            NSLog(@"%@",kShareModel.userId);
            
        }
        else
        {
            
            
            if (self.type == WPMainPositionTypeRecruit) {
                cell.status = @"申请";
            }else{
                cell.status = @"抢人";
            }
        }
        
        [cell exchangeSubViewFrame:_collectionViewIsEditing];
        
        //添加到cell
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWebView:)];
        recognizer.minimumPressDuration = 0.5;
        [cell addGestureRecognizer:recognizer];
    
        return cell;
//    }else{
//        static NSString *cellId = @"WPNewPartCell";
//        WPNewPartCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
//        cell.model = self.resumeArr[indexPath.row];
//        
//        cell.selectedImageView.hidden = !_collectionViewIsEditing;
//        
//        //添加到cell
//        [cell addGestureRecognizer:longPressGesture];
//        
//        return cell;
//    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        WPNewResumeHeaderView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kNewResumeHeader forIndexPath:indexPath];
        WPNewResumeHeaderView *cell = (WPNewResumeHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kNewResumeHeader forIndexPath:indexPath];

        if (!cell) {
            cell = [[WPNewResumeHeaderView alloc]init];
        }
        WPTipModel *model = [WPTipModel sharedManager];
        [cell configeWith:self.type == WPMainPositionTypeRecruit ? model.job_com_avatar : model.re_com_avatar count:self.type == WPMainPositionTypeRecruit ? model.jobMsgCount : model.ReMsgCount];
        cell.clickBlock = ^(){
            NSLog(@"点击");
            WPNewsViewController *news = [[WPNewsViewController alloc] init];
            if (self.type == WPMainPositionTypeInterView) {
                news.type = NewsTypeResume;
            } else {
                news.type = NewsTypeInvite;
            }
            [self.navigationController pushViewController:news animated:YES];
        };
        return cell;
    } else {
        return nil;
    }
}

#pragma mark 返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    WPTipModel *model = [WPTipModel sharedManager];
    NSString *count = self.type == WPMainPositionTypeRecruit ? model.jobMsgCount : model.ReMsgCount;
    CGSize size={SCREEN_WIDTH,[count isEqualToString:@"0"] ? 0 : kHEIGHT(36) + 8};
    return size;
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
        
        interView.subId = model.resumeId;
        interView.userId = model.userId;
        interView.model = model;
        WPShareModel *shareModel = [WPShareModel sharedModel];
        interView.isSelf = [model.userId isEqualToString:shareModel.dic[@"userid"]];
        if (self.type == WPMainPositionTypeInterView) {
           interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,model.resumeId,kShareModel.userId];
        }else{
            interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,model.resumeId,kShareModel.userId];
        }
        [self.navigationController pushViewController:interView animated:YES];
    }else{
        
        if (_collectionViewItemIsFullScreen) {
            WPNewFullCell *cell = (WPNewFullCell*)[collectionView cellForItemAtIndexPath:indexPath];
            if (cell.model.isSelected) {
                for (WPNewResumeListModel *listModel in self.selectedArray) {
                    if ([listModel.resumeId isEqualToString:cell.model.resumeId]) {
                        [self.selectedArray removeObject:listModel];
                        break;
                    }
                }
            }else{
                [self.selectedArray addObject:model];
            }
            
            cell.model.isSelected = !cell.model.isSelected;
        }else{
            
        }
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
    
    CGFloat y = scrollView.contentOffset.y;
   //NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    WPShuoStaticData * shuoData = [WPShuoStaticData shareShuoData];
    if (!self.titleString.length) {
        if (self.type == WPMainPositionTypeInterView)
        {
            shuoData.applyScroller = [NSString stringWithFormat:@"%f",y];
        }
        else
        {
            shuoData.inviteScroller = [NSString stringWithFormat:@"%f",y];
        }
    }
//    if (self.type == WPMainPositionTypeInterView)
//    {
//        shuoData.applyScroller = [NSString stringWithFormat:@"%f",y];
//    }
//    else
//    {
//        shuoData.inviteScroller = [NSString stringWithFormat:@"%f",y];
//    }
    
    
}
@end
