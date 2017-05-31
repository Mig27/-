//
//  ThirdJobViewController_New.m
//  WP
//
//  Created by Kokia on 16/3/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "ThirdJobViewController_New.h"
#import "WPDownLoadVideo.h"
#import "WriteViewController.h"
#import "WorkTableViewCell.h"
#import "NewDetailViewController.h"
#import "NewHomePageViewController.h"
#import "ShareEditeViewController.h"
#import "ShareDetailController.h"
#import "ReportViewController.h"
#import "CollectViewController.h"
#import "WPNewsViewController.h"
#import "NearInterViewController.h"
#import "imageConsider.h"
#import "WPSelectButton.h"
#import "RSButtonMenu.h"
#import "IQKeyboardManager.h"
#import "WPDynamicTipView.h"
#import "DynamicTopicTypeModel.h"
#import "WPSendToFriends.h"
#import "UIMessageInputView.h"
#import "YYShareManager.h"
#import "HJCActionSheet.h"
#import "WPTipModel.h"
#import "WPMySecurities.h"
#import "HCInputBar.h"
#import "WPThreeBackView.h"
#import "WPWhitrBackView.h"
#import "WPNewResumeModel.h"
#import "zhiChangVideo.h"
#import "imageConsider.h"
#import "WPDownLoadVideo.h"
#import "ZacharyPlayManager.h"
#import "MTTDatabaseUtil.h"
#import "WPRecentLinkManController.h"
#import "ShareResume.h"
#import "ShareDynamic.h"
#import "DynamicBottomView.h"
#import "modeView.h"
#import "PersonalInfoViewController.h"
#import "WPShuoStateStyle.h"
#import "WPShuoStaticData.h"
#define shuoShuoVideo @"/shuoShuoVideo"
@interface ThirdJobViewController_New () <UITableViewDelegate, UITableViewDataSource, RSButtonMenuDelegate, UIMessageInputViewDelegate,HJCActionSheetDelegate,UIScrollViewDelegate>
{
    
}
@property (nonatomic, strong)modeView * screenBtn;
/**评论 键盘 */
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;


@property (nonatomic, strong) UITableView *tableView;

/**头部，筛选框 */
@property (nonatomic, strong) UIView *headView;

/**最新、全部 */
@property (nonatomic,strong) NSMutableArray *buttons;

/**最新、全部 */
@property (nonatomic,strong) WPSelectButton *button5;
@property (nonatomic,strong) WPSelectButton *button6;

@property (nonatomic,strong) RSButtonMenu *buttonMenu1;
@property (nonatomic,strong) RSButtonMenu *buttonMenu2;

@property (nonatomic,strong) UIView *backView1;
@property (nonatomic,strong) UIView *backView2;
@property (nonatomic,strong) UIView *subView;

@property (nonatomic,assign) NSUInteger index1;

@property (nonatomic,assign) NSUInteger index2;

@property (nonatomic,strong) NSString *speak_type; //说说类型
@property (nonatomic,strong) NSString *state;      //说说的状态


@property (nonatomic,assign) NSUInteger page;       // 朋友圈分页
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic,assign) BOOL isMore;            //是否有显示更多
@property (nonatomic,assign) BOOL isEditeNow;            //是否正在编辑状态

/**选中cell的IndexPath 评论 */
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@property (nonatomic,strong) NSMutableDictionary *deletParams;   //所要删除说说的参数
@property (nonatomic,assign) NSInteger deletIndex;               //所要删除说说的位置

@property (nonatomic,assign) BOOL isTopic;               //当前是回复说说还是回复评论
@property (nonatomic, strong) NSString *by_user_id;      //被回复人的user_id
@property (nonatomic, strong) NSString *peplyId;         //当前评论的id

@property (nonatomic, strong) WPDynamicTipView *tipView; /**< 未读消息提示 */
@property (nonatomic, strong) dispatch_source_t timer;
@property (strong, nonatomic) HCInputBar *inputBar;

@property (nonatomic, strong)NSMutableArray *choiseAllArray;
@property (nonatomic, assign) BOOL  workNetState;
@property (nonatomic, strong) NSMutableArray * cellHeightArray;//用来存放cell的高度
@property (nonatomic, assign) BOOL IsShowThree;

@property (nonatomic, strong) UIWindow * coverWindow;

@end

@implementation ThirdJobViewController_New
{
    BOOL _wasKeyboardManagerEnabled;
}
//-(modeView*)screenBtn
//{
//    if (!_screenBtn) {
//        _screenBtn = [[modeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        _screenBtn.backgroundColor = [UIColor redColor];
//        __weak typeof(_screenBtn)btn = _screenBtn;
//        _screenBtn.clickButton = ^(){
//            [[ThirdJobViewController_New class] hideView];
//            [btn removeFromSuperview];
//        };
//    }
//    else
//    {
//      
//    }
//    return _screenBtn;
//}
-(UIWindow*)coverWindow
{
    if (!_coverWindow) {
        _coverWindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        _coverWindow.hidden = NO;
        _coverWindow.backgroundColor = [UIColor clearColor];
        _coverWindow.windowLevel = UIWindowLevelStatusBar+1;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapWin)];
        [_coverWindow addGestureRecognizer:tap];
        [_coverWindow makeKeyAndVisible];
    }
    return _coverWindow;
}
-(void)tapWin
{
    [self.tableView scrollToTop];
    [self.titleView.activity startAnimating];
    [self requestWithPageIndex:1 andIsNear:YES Success:^(NSArray *datas, int more) {
        [self.titleView.activity stopAnimating];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:datas];
        //获取cell的高
        [self getHeightOfCell:self.dataSource];
        [_tableView reloadData];
    } Error:^(NSError *error) {
        [self.titleView.activity stopAnimating];
    }];
}
-(NSMutableArray*)cellHeightArray
{
    if (!_cellHeightArray) {
        _cellHeightArray = [NSMutableArray array];
    }
    return _cellHeightArray;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.titleView.titleString = @"话题";
    [self.titleView.activity stopAnimating];
    self.navigationItem.titleView = self.titleView;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.index1 = 0;
    self.index2 = 0;
    self.page = 1;
    self.state = @"1";
    self.speak_type = @"0";
    self.isMore = NO;
    self.isTopic = YES;
    self.isEditeNow = NO;
    self.dataSource = [NSMutableArray array];
    self.buttons = [NSMutableArray array];
    [self initNav];
    [self headView];
    int num = 0;
    
    WPShuoStaticData * dataShuo = [WPShuoStaticData shareShuoData];
    if (dataShuo.dataArray.count || dataShuo.leftID.length||dataShuo.topicID.length)
    {
        self.state = dataShuo.leftID;
        self.speak_type = dataShuo.topicID;
        self.index1 = dataShuo.index1;
        self.index2 = dataShuo.index2;
        
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:dataShuo.dataArray];
        [self getHeightOfCell:dataShuo.dataArray];
        [self.tableView reloadData];
        
        NSString * scrollerY = dataShuo.scrollerPosition;
        [self.tableView setContentOffset:CGPointMake(0, scrollerY.floatValue)];
        _page = dataShuo.scrollerPage;
        if (scrollerY.floatValue == 0 || !scrollerY) {
            _page = 1;
            [self.titleView.activity startAnimating];
            [self requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
                [self.titleView.activity stopAnimating];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:datas];
                //获取cell的高
                [self getHeightOfCell:self.dataSource];
                [self.tableView reloadData];
            } Error:^(NSError *error) {
                [self.titleView.activity stopAnimating];
            }];
        }
    }
    else
    {
        dataShuo.leftID = @"1";
        dataShuo.topicID = @"";
        [[MTTDatabaseUtil instance] getShuoShuosurrent:num :^(NSArray *array) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:array];
            [self getHeightOfCell:self.dataSource];
            [self.tableView reloadData];
        }];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _page = 1;
            [self.titleView.activity startAnimating];
            [self requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
                [self.titleView.activity stopAnimating];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:datas];
                //获取cell的高
                [self getHeightOfCell:self.dataSource];
                [self.tableView reloadData];
            } Error:^(NSError *error) {
                [self.titleView.activity stopAnimating];
            }];
        });
    }
//    [[MTTDatabaseUtil instance] getShuoShuosurrent:num :^(NSArray *array) {
//        [self.dataSource removeAllObjects];
//        [self.dataSource addObjectsFromArray:array];
//        [self getHeightOfCell:self.dataSource];
//        [self.tableView reloadData];
//
//        NSString * scrollerY = [[NSUserDefaults standardUserDefaults] objectForKey:@"scrollerY"];
//        CGFloat totalY = 0;
//
//        if (self.cellHeightArray.count<10) {
//            for (int i = 0 ; i < self.cellHeightArray.count; i++) {
//                NSString * string = self.cellHeightArray[i];
//                totalY += string.floatValue;
//            }
//        }
//        else
//        {
//            for (int i = 0 ; i < 10; i++) {
//                NSString * string = self.cellHeightArray[i];
//                totalY += string.floatValue;
//            }
//        }
//        if (totalY+SCREEN_HEIGHT<scrollerY.floatValue) {
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.cellHeightArray.count inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
//        }
//        else
//        {
//            if (scrollerY.intValue== 0) {
//                [self.tableView scrollToTop];
//            }
//            else
//            {
//              [self.tableView setContentOffset:CGPointMake(0, scrollerY.floatValue)];
//            }
//        }
//    }];
//    
//    
//    
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _page = 1;
//        [self.titleView.activity startAnimating];
//        [self requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
//            [self.titleView.activity stopAnimating];
//            [self.dataSource removeAllObjects];
//            [self.dataSource addObjectsFromArray:datas];
//            //获取cell的高
//            [self getHeightOfCell:self.dataSource];
//            [self.tableView reloadData];
//        } Error:^(NSError *error) {
//            [self.titleView.activity stopAnimating];
//        }];
//    });
    

    
    //点击简历跳到简历界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToShareDetailNotification:) name:@"shareJump" object:nil];
    
    //点击文字跳到详情界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToShareDynamicDetailNotification:) name:@"shareJumpToDynamic" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeJumpToShareDynamicDetailNotification:) name:@"resumeJumpToDynamic" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToPersonalHomePageNotification:) name:@"jumpToPersonalHomePage" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportNotification:) name:@"report" object:nil];
    
    //点击进行收藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectNotification:) name:@"collect" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageTip) name:@"GlobalMessageTip" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToNextController:) name:@"JUMPTONEXTCONTROLLER" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideView) name:@"HIDETHREEVIEW" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable:) name:@"reloadShuoShuo" object:nil];
    
    //有网络时重新加载数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFrishData) name:@"refreshShuoShuo" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadVideoCell:) name:@"videoLoadSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideView) name:@"hideThreeButton" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:@"upLoadShuoSuccessAgain" object:nil];
    // 评论
//    _myMsgInputView = [UIMessageInputView messageInputViewWithType:UIMessageInputViewContentTypeTweet];
//    _myMsgInputView.delegate = self;
    
    UIWindow * win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:self.inputBar];
    self.inputBar.hidden = YES;
//   [self.view addSubview:self.inputBar];
//    self.inputBar.hidden = YES;
    //块传值
    __weak typeof(self) weakSelf = self;
    [_inputBar showInputViewContents:^(NSString *contents) {
        NSString * string = [NSString stringWithFormat:@"%@",contents];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if (!string.length) {
            [MBProgressHUD createHUD:@"请输入内容" View:self.view];
            return ;
        }
        _inputBar.hidden = YES;
        [weakSelf sendCommentMessage:string];
    }];
    _inputBar.keyBoardHidden = ^(){
        [weakSelf keyBoardDismiss];
    };
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[ThirdJobViewController_New class]];
}

-(void)loadData:(NSNotification*)noti
{
//    [self.tableView.mj_header beginRefreshing];
    [self.titleView.activity startAnimating];
    [self requestWithPageIndex:1 andIsNear:YES Success:^(NSArray *datas, int more) {
        [self.titleView.activity stopAnimating];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:datas];
        //获取cell的高
        [self getHeightOfCell:self.dataSource];
        [_tableView reloadData];
    } Error:^(NSError *error) {
        [self.titleView.activity stopAnimating];
    }];
}
-(void)reloadVideoCell:(NSNotification*)noti
{
    NSIndexPath * index = noti.object;
    [self.tableView reloadRowAtIndexPath:index withRowAnimation:UITableViewRowAnimationNone];
}
-(void)refreshFrishData
{
    [self.dataSource removeAllObjects];
    //[self.tableView.mj_header beginRefreshing];
    [self.titleView.activity startAnimating];
    [self requestWithPageIndex:1 andIsNear:YES Success:^(NSArray *datas, int more) {
        [self.titleView.activity stopAnimating];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:datas];
        //获取cell的高
        [self getHeightOfCell:self.dataSource];
        [_tableView reloadData];
    } Error:^(NSError *error) {
        [self.titleView.activity stopAnimating];
    }];
}

-(void)refreshTable:(NSNotification*)noti
{
    
    NSIndexPath*index = (NSIndexPath*)noti.object;
    if (index.row > self.dataSource.count-1) {
        return;
    }
    [self.tableView reloadRowAtIndexPath:index withRowAnimation:UITableViewRowAnimationNone];
}
-(void)requstWiFiData
{
    NSDictionary * dci = @{@"action":@"getAutoPlay",
                           @"username":kShareModel.username,
                           @"password":kShareModel.password,
                           @"user_id":kShareModel.userId};
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/userInfo.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dci success:^(id json) {
        
        NSString * workState = [self networkingStatesFromStatebar];
        NSString * string = json[@"auto_play"];
        switch (string.intValue) {
            case 0:
            {
                _workNetState = workState.intValue == 0;
            }
//                _wifiStr = @"仅WiFi";
                break;
            case 1:
                _workNetState = (workState.intValue == 1)||(workState.intValue == 0);
//                _wifiStr = @"3G/4G和WiFi";
                break;
            case 2:
                _workNetState = NO;
//                _wifiStr = @"关闭";
                break;
            default:
                break;
        }
//        _workNetState = [self networkingStatesFromStatebar];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 获取当前网络状态
- (NSString *)networkingStatesFromStatebar {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
//    NSString *stateString = @"wifi";
    
    NSString * string = [NSString string];
    switch (type) {
        case 0:
//            stateString = @"notReachable";
            string = @"2";
            break;
            
        case 1:
//            stateString = @"2G";
            string = @"2";
            break;
            
        case 2:
//            stateString = @"3G";
            string = @"1";
            break;
            
        case 3:
//            stateString = @"4G";
            string = @"1";
            break;
            
        case 4:
//            stateString = @"LTE";
            string = @"";
            break;
            
        case 5:
//            stateString = @"wifi";
            string = @"0";
            break;
            
        default:
            break;
    }
    return string;
}


-(void)jumpToNextController:(NSNotification*)noticication
{
    NSIndexPath*indexpath = (NSIndexPath*)noticication.object;
    [self jumpToDetailWith:indexpath];
}
-(NSMutableArray*)choiseAllArray
{
    if (!_choiseAllArray) {
        _choiseAllArray = [[NSMutableArray alloc]init];
    }
    return _choiseAllArray;
}
#pragma mark - 请求消息提醒
- (void)messageTip
{
    WPTipModel *model = [WPTipModel sharedManager];
    if ([model.speak integerValue]>0) {
        [self.tipView configeWith:model.con_avatar count:model.speak];
        self.tableView.tableHeaderView = self.tipView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
    
    if (model.avatar.length||model.M_avatar.length)
    {
        self.button5.isHideOrNot = YES;
        self.friendTopic = model.avatar.length;
        self.newTopic = model.M_avatar.length;
    }
    else
    {
        self.button5.isHideOrNot = NO;
        self.friendTopic = NO;
        self.newTopic = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 键盘 即将显示
    if (_myMsgInputView) {
        [_myMsgInputView prepareToShow];
    }
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 键盘 隐藏
    if (_myMsgInputView) {
        [_myMsgInputView prepareToDismiss];
    }
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.coverWindow = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentTopic" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deletDiscuss" object:nil];
    
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:2 inSection:3];
    [self hideBackView:indexpath];
    [self keyBoardDismiss];
}

-(void)hideView{
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:2 inSection:3];
    [self hideBackView:indexpath];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.coverWindow makeKeyAndVisible];
        [window makeKeyWindow];
    });
    
    
    [self requstWiFiData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentDiscussNotification:) name:@"commentTopic" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDiscussNotification:) name:@"deletDiscuss" object:nil];
}

#pragma mark - 跳到分享的招聘或者求职详情页面
- (void)jumpToShareDetailNotification:(NSNotification *)notification
{
    if (self.IsShowThree) {
        self.IsShowThree = NO;
        [self hideView];
        return;
    }
    
    
    [self hideView];
    [self keyBoardDismiss];
    if ([notification.userInfo[@"jobNo"] isEqualToString:@"1"]) {
        
        NSIndexPath * indexpath = notification.userInfo[@"index"];
        NSDictionary *dic = _dataSource[indexpath.row];
        BOOL isOrNot = [self clickNotFinish:dic[@"guid"]];
        if (isOrNot) {
            return ;
        }
        
        
        
        NSDictionary * dictionary = _dataSource[indexpath.row];
        WPNewResumeListModel *model = [[WPNewResumeListModel alloc]init];
        
        NSString * position = [NSString stringWithFormat:@"%@",dictionary[@"shareMsg"][@"jobPosition"][0][@"position"]];
        NSArray * positionArray = [position componentsSeparatedByString:@"："];
        
        model.jobPositon = [NSString stringWithFormat:@"%@",positionArray[1]];//dictionary[@"shareMsg"][@"jobPosition"][0][@"position"]
        model.HopePosition = model.jobPositon;
        model.avatar =dictionary[@"shareMsg"][@"jobPhoto"][0][@"small_address"];
        model.resumeId = dictionary[@"jobids"];
        model.name = dictionary[@"shareMsg"][@"name"];
        model.sex =dictionary[@"shareMsg"][@"sex"];
        model.education =dictionary[@"shareMsg"][@"education"];
        model.WorkTim =dictionary[@"shareMsg"][@"WorkTime"];
        model.birthday =dictionary[@"shareMsg"][@"birthday"];
        model.enterpriseName = model.name;
        
        
        NSArray *arr1 = [notification.userInfo[@"url"] componentsSeparatedByString:@"?"];
        NSArray *arr2 = [arr1[1] componentsSeparatedByString:@"&"];
        NSArray *typeArr = [arr2[0] componentsSeparatedByString:@"="];
        NSArray *userArr = [arr2[1] componentsSeparatedByString:@"="];
        //    NSLog(@"%@-----%@",typeArr,userArr);
        
        
        
        
        NearInterViewController *inter = [[NearInterViewController alloc] init];
        NSString * speak_comment_state = dictionary[@"speak_comment_state"];
        if ([speak_comment_state isEqualToString:@"匿名吐槽"]) {
            inter.isNiMing = YES;
        }
        inter.model = model;
        inter.subId = typeArr[1];
        inter.userId = userArr[1];
        inter.resumeId = typeArr[1];
        inter.urlStr = [IPADDRESS stringByAppendingString:notification.userInfo[@"url"]];
        inter.isRecuilist = [typeArr[0] isEqualToString:@"recruit_id"] ? 1 : 0;
        inter.isSelf = [userArr[1] isEqualToString:kShareModel.userId] ? YES : NO;
        inter.isComeFromDynamic = YES;
        inter.shareDic = dictionary;
        [self.navigationController pushViewController:inter animated:YES];

    } else {//点击多个简历的合并
        ShareDetailController *detail = [[ShareDetailController alloc] init];
        detail.isTopic = YES;
        detail.url = notification.userInfo[@"url"];
        NSIndexPath *index = notification.userInfo[@"index"];
        if (index.row>self.dataSource.count-1) {
            return;
        }
        detail.dic = self.dataSource[index.row];
        NSString * speak_comment_state = self.dataSource[index.row][@"speak_comment_state"];
        if ([speak_comment_state isEqualToString:@"匿名吐槽"]) {
            detail.isNiMing = YES;
        }
        detail.isFromShuoShuo = YES;
        NSString * share = self.dataSource[index.row][@"share"];
        detail.type = [share isEqualToString:@"2"]?WPMainPositionTypeInterView:WPMainPositionTypeRecruit;
        [share isEqualToString:@"2"]?(detail.title = @"求职简历"):(detail.title = @"企业招聘");
        detail.chatDic = [self getChatDic:self.dataSource[index.row]];
        [self.navigationController pushViewController:detail animated:YES];
    }
}


-(NSDictionary*)getChatDic:(NSDictionary*)dic
{
    NSString * company = dic[@"share_title"];
    NSArray * titleArr = [company componentsSeparatedByString:@","];
    NSMutableArray * muarray = [NSMutableArray array];
    [muarray addObjectsFromArray:titleArr];
    [muarray removeLastObject];
    company = [muarray componentsJoinedByString:@","];
    
    NSArray * jobPosition = dic[@"shareMsg"][@"jobPosition"];
    NSMutableArray * positionArr = [NSMutableArray array];
    for (NSDictionary *dic in jobPosition) {
        [positionArr addObject:dic[@"position"]];
    }
    NSString * title = [positionArr componentsJoinedByString:@","];
    NSDictionary * dictionary = @{@"avatar":dic[@"shareMsg"][@"jobPhoto"][0][@"small_address"],@"company":company,@"title":title,@"img_url":dic[@"shareMsg"][@"jobPhoto"],@"url":dic[@"share_url"]};
    return dictionary;
    
}
#pragma mark - 跳到分享的动态详情页面
- (void)jumpToShareDynamicDetailNotification:(NSNotification *)notification
{
    if (self.IsShowThree) {
        self.IsShowThree = NO;
        [self hideView];
        return;
    }
    [self hideView];
    [self keyBoardDismiss];
    NewDetailViewController *detail = [[NewDetailViewController alloc] init];
    detail.info = @{@"sid" : notification.userInfo[@"sid"],
                    @"nick_name" : notification.userInfo[@"nick_name"]};
    detail.isCommentFromDynamic = NO;
    detail.clickIndex = notification.userInfo[@"index"];
    
    //未发布完成的点击不跳转
    NSDictionary * dic = self.dataSource[detail.clickIndex.row];
    BOOL isorNot = [self clickNotFinish:dic[@"guid"]];
    if (isorNot) {
        return;
    }
    
    
    detail.isCommentFromDynamic = NO;
    detail.deleteSuccessBlock = ^(NSIndexPath *index){
        //        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        //        [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
        [self.dataSource removeObjectAtIndex:index.row];
        [self.tableView reloadData];
    };
    detail.praiseSuccessBlock = ^(NSIndexPath *index,NSString *sid) {
        [self updatePraiseWithIndex:index];
    };
    detail.commentSuccessBlock = ^(NSIndexPath *index,NSString *sid) {
        [self updateDiscussCountWithIndex:index];
    };
    detail.shareSuccessBlock = ^(NSIndexPath *index,NSString *sid) {
        [self updateShareCountWithIndex:index];
    };
    
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - 分享的说说点击进入详情
- (void)resumeJumpToShareDynamicDetailNotification:(NSNotification *)notification
{
    
    if (self.IsShowThree) {
        self.IsShowThree = NO;
        [self hideView];
        return;
    }
    [self hideView];
    [self keyBoardDismiss];
    NewDetailViewController *detail = [[NewDetailViewController alloc] init];
    detail.info = @{@"sid" : notification.userInfo[@"sid"],
                    @"nick_name" : notification.userInfo[@"nick_name"]};
    detail.isCommentFromDynamic = NO;
    detail.clickIndex = notification.userInfo[@"index"];
    
    
    
    
    detail.isCommentFromDynamic = NO;
//    detail.deleteSuccessBlock = ^(NSIndexPath *index){
//        //        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
//        //        [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
//        [self.dataSource removeObjectAtIndex:index.row];
//        [self.tableView reloadData];
//    };
    detail.praiseSuccessBlock = ^(NSIndexPath *index,NSString *sid) {
        for (int i = 0; i<self.dataSource.count; i++) {
            NSDictionary *dict = self.dataSource[i];
            if ([sid isEqualToString:dict[@"sid"]]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self updatePraiseWithIndex:indexPath];
            }
        }
    };
    detail.commentSuccessBlock = ^(NSIndexPath *index,NSString *sid) {
        for (int i = 0; i<self.dataSource.count; i++) {
            NSDictionary *dict = self.dataSource[i];
            if ([sid isEqualToString:dict[@"sid"]]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self updateDiscussCountWithIndex:indexPath];
            }
        }
    };
    detail.shareSuccessBlock = ^(NSIndexPath *index,NSString *sid) {
        for (int i = 0; i<self.dataSource.count; i++) {
            NSDictionary *dict = self.dataSource[i];
            if ([sid isEqualToString:dict[@"sid"]]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self updateShareCountWithIndex:indexPath];
            }
        }
    };
    
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - 跳到个人界面
- (void)jumpToPersonalHomePageNotification:(NSNotification *)notification
{
    if (self.IsShowThree) {
        self.IsShowThree = NO;
        [self hideView];
        return;
    }
    [self hideView];
    [self keyBoardDismiss];
    
    PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
//    NSDictionary *dic =  self.data[indexPath.row];
    info.friendID = notification.userInfo[@"user_id"];
    if ([notification.userInfo containsObjectForKey:@"is_an"]) {
         NSString * is_an  = notification.userInfo[@"is_an"]; //判断是否是匿名分享的
        if ([is_an isEqualToString:@"0"]) {  //匿名分享,不予许查看
            return;
        }
    }
    [[MTTDatabaseUtil instance] getLinkMan:^(NSArray *array) {
        BOOL isONot = NO;
        if (array.count) {
            for (NSDictionary * dic in array) {
                NSString * user_id = dic[@"friend_id"];
                if ([user_id isEqualToString:info.friendID]) {
                    isONot = YES;
                    break;
                }
            }
            if (isONot) {
                info.newType = NewRelationshipTypeFriend;
            }
            else
            {
                info.newType = NewRelationshipTypeStranger;
            }
            [self.navigationController pushViewController:info animated:YES];
        }
        else
        {
            info.newType = NewRelationshipTypeStranger;
            [self.navigationController pushViewController:info animated:YES];
        }
    }];
    
//    NewHomePageViewController *homepage = [[NewHomePageViewController alloc] init];
//    homepage.info = @{ @"user_id" : notification.userInfo[@"user_id"],
//                       @"nick_name" : notification.userInfo[@"nick_name"]};
//    homepage.isComeFromDynamic = YES;
//    [self.navigationController pushViewController:homepage animated:YES];
}

#pragma mark - report action
- (void)reportNotification:(NSNotification *)notification
{
    if (self.IsShowThree) {
        self.IsShowThree = NO;
        [self hideView];
        return;
    }
    
    [self hideView];
    [self keyBoardDismiss];
    ReportViewController *report = [[ReportViewController alloc] init];
    report.speak_trends_id = notification.userInfo[@"sid"];
    report.type = ReportTypeDynamice;
    [self.navigationController pushViewController:report animated:YES];

}

#pragma mark - collect action点击进行收藏
- (void)collectNotification:(NSNotification *)notification
{
    NSString * class = notification.userInfo[@"collect_class"];
    NSString * action = [NSString new];
   //先判断列表三种类型 有没有这一条,有的话,再进行收藏页面跳转
    //ExistsJob 判断招聘  ExistsResume 判断求职  ExistsSpeak 判断说说
    action = [class isEqualToString:@"4"]?@"ExistsSpeak":([class isEqualToString:@"5"]?@"ExistsJob":@"ExistsResume");
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/speak_manage.ashx",IPADDRESS];
    NSDictionary * dictionary = @{@"action":action,@"id":notification.userInfo[@"jobid"]};
    [WPHttpTool postWithURL:urlStr params:dictionary success:^(id json) {
            NSString * string = [NSString new];
            string = [class isEqualToString:@"6"]?@"该简历已被删除":([class isEqualToString:@"5"]?@"该招聘已被删除":@"该说说已被删除");
        NSArray * array = [notification.userInfo[@"jobid"] componentsSeparatedByString:@","];
            if ([json[@"status"] intValue] && array.count == 1 && ![notification.userInfo[@"jobid"] isEqualToString:@""]) {
                [MBProgressHUD createHUD:string View:self.view];
            }
            else
            {
                if (self.IsShowThree) {
                    self.IsShowThree = NO;
                    [self hideView];
                    return;
                }
                
                [self hideView];
                [self keyBoardDismiss];
                CollectViewController *collect = [[CollectViewController alloc] init];
                
                NSString * col3 = nil;
                NSString * isNiMing = notification.userInfo[@"isNiMing"];
                if ([isNiMing isEqualToString:@"匿名吐槽"]) {
                    NSDictionary * dic = notification.userInfo[@"dic"];
                    col3 = [NSString stringWithFormat:@"%@,%@,%@",dic[@"nick_name"],dic[@"POSITION"],dic[@"avatar"]];
                }
                if (col3) {
                    collect.col3 = col3;
                }
                collect.collect_class = notification.userInfo[@"collect_class"];
                collect.user_id = notification.userInfo[@"user_id"];
                collect.content = notification.userInfo[@"content"];
                collect.img_url = notification.userInfo[@"img_url"];
                collect.vd_url = notification.userInfo[@"vd_url"];
                collect.jobid = notification.userInfo[@"jobid"];
                collect.url = notification.userInfo[@"url"];
                collect.companys = notification.userInfo[@"company"];
                collect.shareStr = notification.userInfo[@"share"];
                collect.titleArray = notification.userInfo[@"title"];
                collect.isComeDetail = NO;
                collect.collectSuccessBlock = ^(){
                    //        [MBProgressHUD createHUD:@"收藏成功" View:self.view];
                };
                [self.navigationController pushViewController:collect animated:YES];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD createHUD:@"网络错误" View:self.view];
        }];
    
    
    
    
//    if (self.IsShowThree) {
//        self.IsShowThree = NO;
//        [self hideView];
//        return;
//    }
//    
//    [self hideView];
//    [self keyBoardDismiss];
//    CollectViewController *collect = [[CollectViewController alloc] init];
//    
//    NSString * col3 = nil;
//    NSString * isNiMing = notification.userInfo[@"isNiMing"];
//    if ([isNiMing isEqualToString:@"匿名吐槽"]) {
//        NSDictionary * dic = notification.userInfo[@"dic"];
//        col3 = [NSString stringWithFormat:@"%@,%@,%@",dic[@"nick_name"],dic[@"POSITION"],dic[@"avatar"]];
//    }
//    if (col3) {
//        collect.col3 = col3;
//    }
//    collect.collect_class = notification.userInfo[@"collect_class"];
//    collect.user_id = notification.userInfo[@"user_id"];
//    collect.content = notification.userInfo[@"content"];
//    collect.img_url = notification.userInfo[@"img_url"];
//    collect.vd_url = notification.userInfo[@"vd_url"];
//    collect.jobid = notification.userInfo[@"jobid"];
//    collect.url = notification.userInfo[@"url"];
//    collect.companys = notification.userInfo[@"company"];
//    collect.shareStr = notification.userInfo[@"share"];
//    collect.titleArray = notification.userInfo[@"title"];
//    collect.isComeDetail = NO;
//    collect.collectSuccessBlock = ^(){
////        [MBProgressHUD createHUD:@"收藏成功" View:self.view];
//    };
//    [self.navigationController pushViewController:collect animated:YES];
}

#pragma mark - 回复评论
- (void)commentDiscussNotification:(NSNotification *)notification
{
    if (self.isEditeNow) {
        [self keyBoardDismiss];
        [self hideView];
        return;
    }
//    NSLog(@"%@",notification.userInfo);
    self.by_user_id = notification.userInfo[@"user_id"];
    self.selectedIndexPath = notification.userInfo[@"index"];
    self.isTopic = NO;
//    _myMsgInputView.placeHolder = [NSString stringWithFormat:@"回复%@：",notification.userInfo[@"nick_name"]];
//    [_myMsgInputView notAndBecomeFirstResponder];
    _inputBar.hidden = NO;
    _inputBar.placeHolder = [NSString stringWithFormat:@"回复%@：",notification.userInfo[@"nick_name"]];
    [_inputBar.inputView becomeFirstResponder];
    self.isEditeNow = YES;

}

#pragma mark - 删除自己的评论
- (void)deleteDiscussNotification:(NSNotification *)notification
{
    
    if (self.isEditeNow) {
        [self keyBoardDismiss];
        [self hideView];
        return;
    }
    HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"删除", nil];
    self.peplyId = notification.userInfo[@"sid"];
    self.selectedIndexPath = notification.userInfo[@"index"];
    // 2.显示出来
    [sheet show];
}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *dic = self.dataSource[_selectedIndexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"deletediscuss";
    params[@"speak_id"] = dic[@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"peplyId"] = self.peplyId;
//    params[@"user_id"] = myDic[@"userid"];
//    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@--%@",json,json[@"info"]);
        [self updateDiscussCountWithIndex:_selectedIndexPath];
    } failure:^(NSError *error) {
        
    }];
    

}

#pragma mark - 当将要返回父级的时候，注销观察者
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GlobalMessageTip" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shareJump" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shareJumpToDynamic" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resumeJumpToDynamic" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jumpToPersonalHomePage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"report" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"collect" object:nil];

}

- (void)initNav{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"zhichangshuoshuo_fabu"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

#pragma mark 点击发布说说
- (void)rightBtnClick
{
    if (self.IsShowThree) {
        self.IsShowThree = NO;
        [self hideView];
        return;
    }
    [self hidden];
    WriteViewController *write = [[WriteViewController alloc] init];
    write.is_dynamic = YES;
//    write.title = @"职场说说";
//    write.publishSuccessBlock = ^(){
//        [self.button6 setLabelText:@"话题"];
//        self.speak_type = @"0";
//        self.index2 = 0;
//        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
//        [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
//    };
    write.publishShuoShuoSuccess= ^(NSDictionary*dictionary){
        if ([self.button6.title.text isEqualToString:@"话题"])
        {
            [self.dataSource insertObject:dictionary atIndex:0];
            [self.cellHeightArray removeAllObjects];
            [self getHeightOfCell:self.dataSource];
            [self.tableView reloadData];
            [self.tableView scrollToTop];
        }
        else
        {
            [self.button6 setLabelText:@"话题"];
            self.speak_type = @"0";
            self.index2 = 0;
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
            [[MTTDatabaseUtil instance] getShuoShuosurrent:0 :^(NSArray *array) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:array];
                [self.dataSource insertObject:dictionary atIndex:0];
                [self getHeightOfCell:self.dataSource];
                [self.tableView reloadData];
            }];
        }
    };
    [self.navigationController pushViewController:write animated:YES];
}

- (HCInputBar *)inputBar {
    if (!_inputBar) {
        _inputBar = [[HCInputBar alloc]initWithStyle:DefaultInputBarStyle];
//        _inputBar.isHidden = YES;
//        }else{
//            _inputBar = [[HCInputBar alloc]initWithStyle:ExpandingInputBarStyle];
//            _inputBar.expandingAry = @[[NSNumber numberWithInteger:ImgStyleWithEmoji],[NSNumber numberWithInteger:ImgStyleWithVideo],[NSNumber numberWithInteger:ImgStyleWithPhoto],[NSNumber numberWithInteger:ImgStyleWithCamera],[NSNumber numberWithInteger:ImgStyleWithVoice]];
//        }
        _inputBar.keyboard.showAddBtn = NO;
        [_inputBar.keyboard addBtnClicked:^{
            NSLog(@"我点击了添加按钮");
        }];
        _inputBar.placeHolder = @"说点什么吧";
    }
    return _inputBar;
}


#pragma mark - 头部，筛选框
- (UIView *)headView
{
    if (_headView == nil) {
        _headView = [UIView new];
        _headView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_headView];
        
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_topLayoutGuide);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@(kHEIGHT(32)));
        }];
        
        UIView *ledgement = [UIView new];
        ledgement.backgroundColor = RGB(226, 226, 226);
        [_headView addSubview:ledgement];
        
        [ledgement mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headView.mas_bottom).offset(-0.5);
            make.left.right.equalTo(_headView);
            make.height.equalTo(@(0.5));
        }];
        
        CGFloat width = SCREEN_WIDTH/2;
        NSArray *titles = @[@"最新",@"话题"];
        WPShuoStateStyle * style = [WPShuoStateStyle instance];
        for (int i=0; i<titles.count; i++) {
            WPSelectButton *btn = [[WPSelectButton alloc] initWithFrame:CGRectMake(width*i, 0, width, kHEIGHT(32))];
            [btn setLabelText:titles[i]];
            WPShuoStaticData * shuoData = [WPShuoStaticData shareShuoData];
            if (shuoData.leftString.length || shuoData.topicString.length) {
                if (shuoData.leftString.length && i == 0) {
                    [btn setLabelText:shuoData.leftString];
                }
                if (shuoData.topicString.length && i == 1) {
                    [btn setLabelText:shuoData.topicString];
                }
            }
            //显示保存的状态
            if (style.stateName.length && i == 0) {
                [btn setLabelText:style.stateName];
                self.state = style.stateID;
                self.index1 = style.stateIndex.integerValue;
            }
            if (style.styleName.length && i == 1) {
                [btn setLabelText:style.styleName];
                self.speak_type = style.styleId;
                self.index2 = style.styleIndex.integerValue;
            }
            btn.image.image = [UIImage imageNamed:@"arrow_down"];
//            if (i == 0) {
//                NSDictionary * dic = self.messageArray[0][0];
//                NSString * avatar = dic[@"publishAvatar"];
//                if (avatar.length) {
//                    btn.isHideOrNot = YES;
//                }
//            }
            [_headView addSubview:btn];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(width*i, 0, width, kHEIGHT(32));
            button.tag = 10 + i;
            [button addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_buttons addObject:button];
            [_headView addSubview:button];
            btn.isSelected = button.isSelected;
            if (i != 0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width*i, (kHEIGHT(32) - 15)/2, 0.5, 15)];
                line.backgroundColor = RGB(226, 226, 226);
                [_headView addSubview:line];
            }
            if (i==0) {
                self.button5 = btn;
            } else if (i==1) {
                self.button6 = btn;
            }
        }
    }
    return _headView;
}

#pragma mark - 提示最新
- (WPDynamicTipView *)tipView
{
    if (!_tipView) {
        _tipView = [[WPDynamicTipView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(36) + 8)];
        WS(ws);
        __weak typeof(self) weakSelf = self;
        _tipView.clickBlock = ^(){
            if (weakSelf.IsShowThree) {
                weakSelf.IsShowThree = NO;
                [weakSelf hideView];
                return;
            }
            [ws keyBoardDismiss];
            [ws hideView];
            WPNewsViewController *news = [[WPNewsViewController alloc] init];
            news.type = NewsTypeDynamic;
            news.readOverBlock = ^(){
                [ws.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
                [ws performSelector:@selector(delay) withObject:nil afterDelay:0.3];
            };
            [ws.navigationController pushViewController:news animated:YES];
        };
    }
    return _tipView;
}

#pragma mark 点击最新和全部
- (void)selectBtnClick:(UIButton *)sender
{
    NSMutableArray *typeArr = [NSMutableArray array];
    NSMutableArray *timeArr = [NSMutableArray array];
    
    // 全部
    NSArray *type = @[@"全部话题",@"人气排行",@"话题",@"匿名吐槽",@"职场八卦",@"上班族",@"正能量",@"心理学",@"工作狂",@"创业心得",@"老板心得",@"管理智慧",@"求职宝典",@"找工作",@"交友",@"在路上",@"早安心语",@"情感心语"];
    
    // 最新
    NSArray *time = @[@"最新说说",@"好友说说"];
    
    // to do
    for (int i = 0; i<type.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = type[i];
        model.industryID = [NSString stringWithFormat:@"%d",i];
        [typeArr addObject:model];
    }
    
    for (int i = 0; i<time.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = time[i];
        model.industryID = [NSString stringWithFormat:@"%d",i + 1];
        [timeArr addObject:model];
    }
    
    self.backView1.hidden = YES;
    self.backView2.hidden = YES;
    self.subView.hidden = NO;
    if (sender.tag == 10) {
        if (!sender.isSelected) {//点击最新
//            self.buttonMenu1.imageString = self.messageArray[0][0][@"publishAvatar"];
            self.buttonMenu1.isFriend = self.friendTopic;
            self.buttonMenu1.isNew = self.newTopic;
            [self.buttonMenu1 setLocalType:timeArr andSelectIndex:self.index1];
            self.button5.selected = YES;
            _backView1.hidden = NO;
        } else {
            _backView1.hidden = YES;
            self.button5.selected = NO;
        }
        self.button6.selected = NO;
    } else if(sender.tag == 11){//点击全部
        self.button5.selected = NO;
        if (!sender.isSelected) {
            self.buttonMenu2.imageString = @"";
//            [self.buttonMenu2 setNewLocalData:typeArr andSelectIndex:self.index2];
            [self.buttonMenu2 setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"] dictionary:@{@"action":@"getTypeList",@"user_id":kShareModel.userId} selectedIndex:self.index2];
            self.button6.selected = YES;
            _backView2.hidden = NO;
        } else {
            _backView2.hidden = YES;
            self.button6.selected = NO;
        }
        
    }
    
    for (int i = 0; i<_buttons.count; i++) {
        UIButton *btn = _buttons[i];
        if (i == sender.tag - 10) {
            btn.selected = !btn.selected;
        } else {
            btn.selected = NO;
        }
    }
    
}

- (RSButtonMenu *)buttonMenu1
{
    if (!_buttonMenu1) {
        _buttonMenu1 = [[RSButtonMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - kHEIGHT(32))];
       
        _buttonMenu1.delegate = self;
        _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(32) + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        
        [self.view addSubview:_backView1];

        [_backView1 addSubview:_buttonMenu1];

        __weak typeof(self) unself = self;
        _buttonMenu1.touchHide = ^(){
            [unself hidden];
        };
        
    }
    return _buttonMenu1;
}

- (RSButtonMenu *)buttonMenu2
{
    if (!_buttonMenu2) {
        _buttonMenu2 = [[RSButtonMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - kHEIGHT(32))];

        _buttonMenu2.delegate = self;

        _backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(32) + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        [self.view addSubview:_backView2];
        [_backView2 addSubview:_buttonMenu2];
        
        __weak typeof(self) unself = self;
        _buttonMenu2.touchHide = ^(){
            [unself hidden];
        };
        
    }
    return _buttonMenu2;
}

- (UIView *)subView
{
    if (!_subView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        _subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _subView.backgroundColor = RGBA(0, 0, 0, 0);
        //        _subView.backgroundColor = [UIColor redColor];
        [window addSubview:_subView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]init];
        [tap1 addTarget:self action:@selector(hidden)];
        [_subView addGestureRecognizer:tap1];
    }
    return _subView;
}

- (void)hidden{
    self.backView1.hidden = YES;
    self.backView2.hidden = YES;
    self.subView.hidden = YES;
    self.button5.selected = NO;
    self.button6.selected = NO;
    for (UIButton *button in _buttons) {
        button.selected = NO;
    }
}

#pragma mark - 键盘消失
- (void)keyBoardDismiss
{
    [_inputBar.inputView resignFirstResponder];
    _inputBar.keyboardTypeBtn.tag = 0;
    _inputBar.inputView.inputView = nil;
    [_inputBar.keyboardTypeBtn setImage:[UIImage imageNamed:@"common_biaoqing"] forState:UIControlStateNormal];
    [_inputBar.inputView reloadInputViews];
    _inputBar.inputView.text = @"";
    [_inputBar layout];
    self.isEditeNow = NO;
    _inputBar.hidden = YES;

//    [self.myMsgInputView isAndResignFirstResponder];
//    self.isEditeNow = NO;
}

#pragma mark tableView
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView = self.tipView;
        [self.view addSubview:_tableView];
//        _tableView.frame = CGRectMake(0, 64 + kHEIGHT(32),SCREEN_WIDTH, SCREEN_HEIGHT - 64 - kHEIGHT(32));
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        __weak typeof(self) unself = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.titleView.activity startAnimating];
            [unself.tableView.mj_footer resetNoMoreData];
            _page = 1;
            [unself requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
                [self.titleView.activity stopAnimating];
                [_tableView.mj_header endRefreshing];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:datas];
                //获取cell的高
                [self getHeightOfCell:self.dataSource];
                [_tableView reloadData];
            } Error:^(NSError *error) {
                 [self.titleView.activity stopAnimating];
                [_tableView.mj_header endRefreshing];
            }];
        }];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [unself requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
                [_tableView.mj_footer endRefreshing];
                if (more == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.dataSource addObjectsFromArray:datas];
                    //                    for (NSDictionary *dic in datas) {
                    //                        NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                    //                        [_goodData1 addObject:is_good];
                    //                    }
                    
                    //获取cell的高
                    [self getHeightOfCell:self.dataSource];
                }
                [unself.tableView reloadData];
            } Error:^(NSError *error) {
                [_tableView.mj_footer endRefreshing];
                _page--;
            }];
        }];
        
    }
    
    return _tableView;
}


#pragma mark UIMessageInputViewDelegate
- (void)messageInputView:(UIMessageInputView *)inputView sendText:(NSString *)text
{
    [self sendCommentMessage:text];
}

- (void)messageInputView:(UIMessageInputView *)inputView heightToBottomChenged:(CGFloat)heightToBottom
{
    DebugLog(@"height");
    
}


#pragma mark - 点击全部和最新的代理
- (void)RSButtonMenuDelegate:(id)model selectMenu:(RSButtonMenu *)menu selectIndex:(NSInteger)index
{
    if ([menu isEqual:_buttonMenu1]) {
        IndustryModel *new = (IndustryModel *)model;
//        self.button5.isHideOrNot = NO;
        self.messageArray = @[@[@{@"publishAvatar":@""}]];
        
        [self.button5 setLabelText:[new.industryName substringToIndex:new.industryName.length - 2]];
        self.state = new.industryID;
        //将状态存到单利中
        WPShuoStateStyle* style = [WPShuoStateStyle instance];
        style.stateName = [new.industryName substringToIndex:new.industryName.length - 2];
        style.stateID = new.industryID;
        style.stateIndex = [NSString stringWithFormat:@"%ld",(long)index];
        self.index1 = index;
        
        //数据存放到静态变量中
        WPShuoStaticData * shuoData = [WPShuoStaticData shareShuoData];
        [shuoData.dataArray removeAllObjects];
        shuoData.leftID = new.industryID;
        shuoData.index1 = index;
        shuoData.leftString = [new.industryName substringToIndex:new.industryName.length - 2];
        
    } else {
        DynamicTopicTypeModel *new = (DynamicTopicTypeModel *)model;
        [self.button6 setLabelText:new.type_name];
        self.speak_type = new.sid;
        self.index2 = index;
        //将状态存到单利中
        WPShuoStateStyle* style = [WPShuoStateStyle instance];
        style.styleName = new.type_name;
        style.styleId = new.sid;
        style.styleIndex = [NSString stringWithFormat:@"%ld",(long)index];
        if ([new.sid isEqualToString:@"0"]) {
            [self.button6 setLabelText:@"话题"];
        }
        
        //将数据存放到静态变量中
        WPShuoStaticData * shuoData = [WPShuoStaticData shareShuoData];
        [shuoData.dataArray removeAllObjects];
        shuoData.topicID = new.sid;
        shuoData.index2 = index;
        shuoData.topicString = new.type_name;
        
    }
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
    [self hidden];
}

- (void)delay
{
    [self.dataSource removeAllObjects];
    [self.titleView.activity startAnimating];
    [self requestWithPageIndex:1 andIsNear:YES Success:^(NSArray *datas, int more) {
        [self.titleView.activity stopAnimating];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:datas];
        //获取cell的高
        [self getHeightOfCell:self.dataSource];
        [_tableView reloadData];
    } Error:^(NSError *error) {
        [self.titleView.activity stopAnimating];
    }];
    
}
-(NSString * )localUrl:(NSString*)urlStr
{
    NSArray * array = [urlStr componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:pictureAddress];
    NSString * fileName = [NSString stringWithFormat:@"%@/%@",savePath,array[array.count-1]];
    NSFileManager * mager = [NSFileManager defaultManager];
    if ([mager fileExistsAtPath:fileName])
    {
        return fileName;
    }
    else
    {
        return @"";
    }
}
#pragma mark - 封装网络  请求数据
- (void)requestWithPageIndex:(NSInteger)page andIsNear:(BOOL)isNear Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = [NSString stringWithFormat:@"%ld",(long)page];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    if ([self.state isEqualToString:@"1"]) {
        params[@"longitude"] = @"";
        params[@"latitude"] = @"";
    }
    params[@"state"] = self.state;
    params[@"speak_type"] = self.speak_type;
    WPShuoStaticData * shuoData = [WPShuoStaticData shareShuoData];
    shuoData.scrollerPage = page;
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSArray *arr = [[NSArray alloc] initWithArray:json[@"list"]];
        
        
        //guid删除服务器和本地都有的数据
        if (page == 1) {
            NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"UPLOAdSHUOSHUO"];
            NSMutableArray * dicArray = [NSMutableArray array];
            [dicArray addObjectsFromArray:array];
            for (NSDictionary*dic in arr) {
                NSString *guid = dic[@"guid"];
                for (NSDictionary * dictionary in array) {
                    if (dictionary[guid]) {
                        [dicArray removeObject:dictionary];
                    }
                }
            }
            array = [[NSArray alloc]initWithArray:dicArray];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"UPLOAdSHUOSHUO"];
        }
        
        
        NSMutableArray * muarray = nil;
        if (page == 1  && [self.speak_type isEqualToString:@"0"])
        {
            if (arr.count)
            {
                [[MTTDatabaseUtil instance] deleteAllShuoshuo];
                [[MTTDatabaseUtil instance] upDateShuoShuo:arr and:^(NSError *error) {
                }];
            }
        }
        //加载本地数据
        if (page == 1) {
            NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"UPLOAdSHUOSHUO"];
            if (array.count) {
                muarray = [NSMutableArray array];
                for (NSDictionary * dic in array) {
                    NSArray * array1 = [dic allValues];
                    NSArray * array2 = array1[0];
                    [muarray addObject:array2[1]];
                }
                [muarray addObjectsFromArray:arr];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mm" ascending:NO];
                NSArray * array0 = [NSArray arrayWithObject:sortDescriptor];
                [muarray sortUsingDescriptors:array0];
                arr = [NSArray arrayWithArray:muarray];
            }
        }
        //将数据存到静态变量中下次使用；
        
        if (page == 1) {
            [shuoData.dataArray removeAllObjects];
        }
        [shuoData.dataArray addObjectsFromArray:arr];
        if (!shuoData.topicString.length) {
            shuoData.topicString = @"话题";
        }
        if (!shuoData.leftString.length) {
            shuoData.leftString = @"最新";
        }
        //移除重复的数据
        success(arr,(int)arr.count);
        //加载等比例图片
        for (NSDictionary * dic in arr) {
            NSArray * small_photos = dic[@"small_photos"];
            if (small_photos.count) {
                for (NSDictionary * dictionary in small_photos) {
                    NSString * string = dictionary[@"small_address"];
                    string = [string stringByReplacingOccurrencesOfString:@"thumb_" withString:@"thumbd_"];
                    string = [self localUrl:string];
                    //本地中没有缩略图
                    if (!string.length) {
                        WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
                        NSString * imageUrl = dictionary[@"small_address"];
                        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"thumb_" withString:@"thumbd_"];
                        if (![imageUrl hasPrefix:@"http"]) {
                            imageUrl = [IPADDRESS stringByAppendingString:imageUrl];
                        }
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [down downLoadImage:imageUrl success:^(id response) {
                               
                            } failed:^(NSError *error) {
                            }];
                        });
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.titleView.activity stopAnimating];
       
        if (page == 1) {
           
            NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"UPLOAdSHUOSHUO"];
            if (array.count) {
                 [self.dataSource removeAllObjects];
                for (NSDictionary * dic  in array) {
                    NSArray * array1 = [dic allValues];
                    NSArray * array2 = array1[0];
                    [self.dataSource addObject:array2[1]];
                }
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mm" ascending:NO];
                NSArray * array0 = [NSArray arrayWithObject:sortDescriptor];
                
                [[MTTDatabaseUtil instance] getShuoShuosurrent:0 :^(NSArray *array) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.dataSource addObjectsFromArray:array];
                        [self.dataSource sortUsingDescriptors:array0];
                        [self getHeightOfCell:self.dataSource];
                        [self.tableView reloadData];
                    });
                }];
            }
        }
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD createHUD:@"网络不给力，请稍后再试" View:self.view];
    }];
}
-(void)getHeightOfCell:(NSArray*)arr
{
    for (int i = 0 ; i < self.dataSource.count; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        NSDictionary *dic = self.dataSource[i];
        NSString *shareType = [NSString stringWithFormat:@"%@",dic[@"share"]];
        NSInteger count = [dic[@"imgCount"] integerValue];
        NSInteger videoCount = [dic[@"videoCount"] integerValue];
        NSString *description = dic[@"speak_comment_content"];
        
    
        
        NSString *description1 = [WPMySecurities textFromBase64String:description];
        NSString *description3 = [WPMySecurities textFromEmojiString:description1];
        
        NSLog(@"%@",description3);
        
        NSString *speak_comment_state = dic[@"speak_comment_state"];
        NSString *lastDestription = [NSString stringWithFormat:@"%@\n%@",speak_comment_state,description3];
        if (description3.length) {
            if ([description3 isEqualToString:@"分享"]) {
                lastDestription = [NSString stringWithFormat:@"%@/分享",speak_comment_state];
            }
        }
        else
        {
            lastDestription = speak_comment_state;
        }
        CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
        CGFloat descriptionLabelHeight;//内容的显示高度
        descriptionLabelHeight = [self sizeWithString:lastDestription fontSize:FUCKFONT(14)].height;
        CGFloat allHeight = descriptionLabelHeight;
        if (descriptionLabelHeight > normalSize.height *9) {//6
            descriptionLabelHeight = normalSize.height *9;//6
            if (_choiseAllArray.count)
            {
                for (NSIndexPath*indexpath in _choiseAllArray) {
                    if (indexPath == indexpath) {
                        descriptionLabelHeight = allHeight;
                        
                        //                    descriptionLabelHeight += 2*normalSize.height;
                    }
                }
            }
            else
            {
                descriptionLabelHeight = normalSize.height *9;
            }
            
            //        descriptionLabelHeight += 5;
            
            self.isMore = YES;
        } else {
            self.isMore = NO;
            descriptionLabelHeight = descriptionLabelHeight;
        }
        
        //加上全文的高度
        if (self.isMore) {
            descriptionLabelHeight += normalSize.height+10;
        }
        CGFloat photosHeight;//定义照片的高度
        
        if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"]) {
            photosHeight = kHEIGHT(43);
        } else if ([shareType isEqualToString:@"1"]) {
            photosHeight = kHEIGHT(43);
        }else {
            CGFloat photoWidth;
            CGFloat videoWidth;
            photoWidth = (SCREEN_WIDTH == 320) ? 74 : ((SCREEN_WIDTH == 375) ? 79 : 86);
            //        videoWidth = (SCREEN_WIDTH == 320) ? 140 : ((SCREEN_WIDTH == 375) ? 164 : 172);
            videoWidth = (SCREEN_WIDTH == 320) ? 112 : ((SCREEN_WIDTH == 375) ? 131 : 145);
            
            if (videoCount == 1) {
                //            NSLog(@"controller 有视频");
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
        }
        
        NSArray *praiseArr = dic[@"praiseUser"];
        NSArray *shareArr = dic[@"shareUser"];
        NSArray *discussArr = dic[@"DiscussUser"];
        CGFloat bottomHeight = [DynamicBottomView calculateHeightWithInfo:dic];
        
        CGFloat cellHeight;
        
        if (praiseArr.count == 0 && shareArr.count ==0 && discussArr.count == 0) { //没有bottom
            
            if ([dic[@"address"] length] == 0) { //有地址
                
                if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
                } else { //不是简历，求职
                    if ([dic[@"original_photos"] count] == 0) {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
                    } else {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
                    }
                    
                }
                
            } else { //没地址
                
                if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + 8;
                } else {
                    if ([dic[@"original_photos"] count] == 0) {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32) + 8;
                    } else {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + 8;
                    }
                }
                
            }
            
        } else { //有bottom
            
            if ([dic[@"address"] length] == 0) { //没有地址
                
                if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
                } else { //不是简历，求职
                    if ([dic[@"original_photos"] count] == 0) {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
                    } else {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10) + 8;
                    }
                    
                }
                
            } else { //有地址
                
                if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
                } else {
                    if ([dic[@"original_photos"] count] == 0) {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
                    } else {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
                    }
                }
            }
        }
        
        if (self.cellHeightArray.count) {
            [self.cellHeightArray insertObject:[NSString stringWithFormat:@"%f",cellHeight] atIndex:i];
        }
        else
        {
        [self.cellHeightArray addObject:[NSString stringWithFormat:@"%f",cellHeight]];
        }
    }
}
-(void)removeShuo
{
    [[MTTDatabaseUtil instance] getAllShuo:^(NSArray *array) {
        
    }];
}



-(BOOL)clickNotFinish:(NSString*)guid
{
    BOOL isOrNot = NO;
    NSMutableArray * muarray = [NSMutableArray array];
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"UPLOAdSHUOSHUO"];
    if (array.count) {
        for (NSDictionary * dic in array) {
            NSArray * array1 = [dic allKeys];
            [muarray addObject:array1[0]];
        }
    }
    NSArray * dicArray = [NSArray arrayWithArray:muarray];
    for (NSString * string in dicArray) {
        if ([string isEqualToString:guid]) {
            isOrNot = YES;
            break;
        }
    }
     return isOrNot;
}


-(void)hideBackView:(NSIndexPath*)indexPath
{
    for (int i = 0 ; i < self.dataSource.count; i++) {
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:i inSection:0];
        if (indexpath == indexPath) {
            continue;
        }
         WorkTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
        for (UIView * view in cell.contentView.subviews) {
            if ([view isKindOfClass:[WPThreeBackView class]]) {
                WPThreeBackView * backView = (WPThreeBackView*)view;
                [UIView animateWithDuration:0.2 animations:^{
                    CGRect rect = backView.frame;
                    rect.origin.x = SCREEN_WIDTH-kHEIGHT(10)-18-6;
                    backView.frame = rect;
                }];
                
            }
        }
    }
}


#pragma mark - TableView Delegate


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.isEditing){
        return NO;
    }else{
        return YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    WorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[WorkTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//        cell = [[WorkTableViewCell alloc]init];

        cell.type = WorkCellTypeNormal;
    }
    if (!self.dataSource.count) {
        return cell;
    }
    
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.workNetState = _workNetState;
    cell.isDetail = NO;
    cell.choiseArray = _choiseAllArray;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    NSDictionary *dicInfo = _dataSource[indexPath.row];
    cell.indexPath = indexPath;
    [cell confineCellwithData:dicInfo];
    
    //点击全文和收起
    cell.clickAllTextBtn= ^(NSIndexPath*index,UIButton*sender){
        
        NSDictionary *dic = _dataSource[index.row];
        BOOL isOrNot = [self clickNotFinish:dic[@"guid"]];
        if (isOrNot) {
            return ;
        }
        
        sender.selected = !sender.selected;
        if (sender.selected) {
            [self.choiseAllArray addObject:index];
        }
        else
        {
            [self.choiseAllArray removeObject:index];
        }
        [self getHeightOfCell:self.dataSource];
        [self.tableView reloadRowAtIndexPath:index withRowAnimation:UITableViewRowAnimationNone];
    };
    //点击评论，分享，赞
//    __weak typeof (wekaCell)cell = cell;
    __weak typeof(cell) weakCell = cell;
    cell.clickThreeButton =^(NSIndexPath *indexpath){
        
        NSDictionary *dic = _dataSource[indexpath.row];
        BOOL isOrNot = [self clickNotFinish:dic[@"guid"]];
        if (isOrNot) {
            return ;
        }
        
//        self.screenBtn = [[modeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//         __weak typeof (self.screenBtn) btn = self.screenBtn;
//        self.screenBtn.clickButton = ^(){
//            [btn removeFromSuperview];
//        };
//        self.screenBtn.backgroundColor = [UIColor redColor];
//        [self.view addSubview:self.screenBtn];

        
        [self hideBackView:indexpath];
        WorkTableViewCell * cell1 = [tableView cellForRowAtIndexPath:indexpath];
        for (UIView * view in cell1.contentView.subviews) {
            if ([view isKindOfClass:[WPThreeBackView class]]) {
                WPThreeBackView * BackView = (WPThreeBackView*)view;
                BackView.hidden = NO;
                BackView.indexpath = indexpath;
               
                
                if (BackView.frame.origin.x == SCREEN_WIDTH-kHEIGHT(10)-18-6) {
                    self.IsShowThree = YES;
                    [UIView animateWithDuration:0.2 animations:^{
                        CGRect rect = BackView.frame;
                        rect.origin.x = SCREEN_WIDTH-kHEIGHT(10)-6-3*kHEIGHT(57)-18;
                        BackView.frame = rect;
                    }];
                }
                else
                {
                    self.IsShowThree = NO;
                    [UIView animateWithDuration:0.2 animations:^{
                        CGRect rect = BackView.frame;
                        rect.origin.x = SCREEN_WIDTH-kHEIGHT(10)-18-6 ;
                        BackView.frame = rect;
                    }];
                }
            }
        }
    };
    
    cell.praiseActionBlock = ^(NSIndexPath *index){
        NSDictionary *dic = _dataSource[index.row];
        BOOL isOrNot = [self clickNotFinish:dic[@"guid"]];
        if (isOrNot) {
            return ;
        }
        
        [self addLinkWithIndex:index];
    };
    
    //点击评论
    cell.commentActionBlock = ^(NSIndexPath *index){
        
        NSDictionary *dic = _dataSource[index.row];
        BOOL isOrNot = [self clickNotFinish:dic[@"guid"]];
        if (isOrNot) {
            return ;
        }
        
//        NewDetailViewController *detail = [[NewDetailViewController alloc] init];
//        detail.info = self.dataSource[indexPath.row];
//        detail.isCommentFromDynamic = YES;
//        detail.jumpType = DetailJumpToComment;
//        detail.clickIndex = index;
//        detail.deleteSuccessBlock = ^(NSIndexPath *index){
//            //        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
//            //        [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
//            [self.dataSource removeObjectAtIndex:index.row];
//            [self.tableView reloadData];
//        };
//        detail.praiseSuccessBlock = ^(NSIndexPath *index,NSString *sid) {
//            [self updatePraiseWithIndex:index];
//        };
//        detail.commentSuccessBlock = ^(NSIndexPath *index,NSString *sid) {
//            [self updateDiscussCountWithIndex:index];
//        };
//        detail.shareSuccessBlock = ^(NSIndexPath *index,NSString *sid) {
//            [self updateShareCountWithIndex:index];
//        };
//        [self.navigationController pushViewController:detail animated:YES];
        
//        self.selectedIndexPath = index;
//        self.chatInputView.hidden = NO;
//        self.isEditeNow = YES;
//        [self.chatInputView.textView becomeFirstResponder];
        
       
        
        [self.screenBtn removeFromSuperview];
        //对评论的要赋值
        self.isTopic = YES;
        _selectedIndexPath = index;
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:3];
        [self hideBackView:indexpath];
        self.inputBar.hidden = NO;
        self.inputBar.placeHolder = @"说点什么吧";
        [self.inputBar.inputView becomeFirstResponder];
    };
    cell.deleteActionBlock = ^(NSIndexPath *index){
        NSDictionary *dic = _dataSource[index.row];
        BOOL isOrNot = [self clickNotFinish:dic[@"guid"]];
        if (isOrNot) {
            return ;
        }
        [self dustbinClickWithIndexPath:index];
    };
    //分享/评论/点赞
    cell.shareActionBlock = ^(NSIndexPath *index){
        NSDictionary *dic = _dataSource[index.row];
        BOOL isOrNot = [self clickNotFinish:dic[@"guid"]];
        if (isOrNot) {
            return ;
        }
        [self shareDynamicWithIndex:index];
        
    };
    //点击头像
    cell.checkActionBlock = ^(NSIndexPath *index){
    
        
        NSDictionary *dic = _dataSource[index.row];
        BOOL isOrNot = [self clickNotFinish:dic[@"guid"]];
        if (isOrNot) {
            return ;
        }
        [self checkHomePageWith:index];
    };
    
    return cell;
}

//-(void)isHideOrPush
//{
//    if (self.IsShowThree) {
//        self.IsShowThree = NO;
//        [self hideView];
//        return;
//    }
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.IsShowThree) {
//        self.IsShowThree = NO;
//        [self hideView];
//        return;
//    }
    
    if (self.isEditeNow) {
        [self keyBoardDismiss];
        return;
    }
    [self jumpToDetailWith:indexPath];
    
}
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0)
{
    cell = nil;
    if(!self.dataSource.count)
    {
        return;
    }
    
    if(indexPath.row>_dataSource.count-1)
    {
        return;
    }
//    NSDictionary * dic = _dataSource[indexPath.row];
//    NSString * videoCount = dic[@"videoCount"];
//    if(videoCount.intValue)
//    {
//        NSString * small_photos = [NSString stringWithFormat:@"%@",dic[@"small_photos"][0][@"small_address"]];
//        NSArray *specialUrlArr = [small_photos componentsSeparatedByString:@"/"];
//        NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
//        NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
//        NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
//     [[ZacharyPlayManager sharedInstance]cancelVideo:fileName1];
//    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIView * view in cell.contentView.subviews) {
        if ([view isKindOfClass:[imageConsider class]]) {
            
            imageConsider * view1 = (imageConsider*)view;
            for (UIView * view2 in view1.subviews) {
                if ([view2 isKindOfClass:[zhiChangVideo class]]) {
                    zhiChangVideo * view3 = (zhiChangVideo*)view2;
                    [view3 removPlay:view3.player];
                    view3.playerLayer = nil;
                }
            }
        }
    }
}
//#pragma mark 滑动置顶
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSIndexPath * indespath = [NSIndexPath indexPathForRow:1 inSection:0];
//    [tableView moveRowAtIndexPath:indexPath toIndexPath:indespath];
//}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}
//-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction * action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        NSLog(@"操作在此进行");
//    }];
//    NSArray * arr = @[action];
//    return arr;
//
//}
#pragma mark - 跳到详情页
- (void)jumpToDetailWith:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataSource[indexPath.row];
    BOOL isOrNot = [self clickNotFinish:dic[@"guid"]];
    if (isOrNot) {
        return;
    }
   
    if (self.IsShowThree) {
        self.IsShowThree = NO;
        [self hideView];
        return;
    }
    
    NewDetailViewController *detail = [[NewDetailViewController alloc] init];
    detail.info = self.dataSource[indexPath.row];
    detail.clickIndex = indexPath;
    detail.isCommentFromDynamic = NO;
    detail.deleteComentBlock = ^(){
//        [self.tableView.mj_header beginRefreshing];
        _page = 1;
        [self.titleView.activity startAnimating];
        [self requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
            [self.titleView.activity stopAnimating];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:datas];
            [self getHeightOfCell:self.dataSource];
            [_tableView reloadData];
        } Error:^(NSError *error) {
            [self.titleView.activity stopAnimating];
        }];
    };
    detail.deleteSuccessBlock = ^(NSIndexPath *index){
        [self.cellHeightArray removeObjectAtIndex:indexPath.row];
        [self.dataSource removeObjectAtIndex:index.row];
        [self.tableView reloadData];
    };
    detail.praiseSuccessBlock = ^(NSIndexPath *index,NSString *sid) {
        [self updatePraiseWithIndex:index];
    };
    detail.commentSuccessBlock = ^(NSIndexPath *index,NSString *sid) {
        [self updateDiscussCountWithIndex:index];
    };
    detail.shareSuccessBlock = ^(NSIndexPath *index,NSString *sid) {
        [self updateShareCountWithIndex:index];
    };
    [self.navigationController pushViewController:detail animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataSource.count) {
        return 0;
    }
//    NSDictionary *dic = self.dataSource[indexPath.row];
//    NSString *shareType = [NSString stringWithFormat:@"%@",dic[@"share"]];
//    NSInteger count = [dic[@"imgCount"] integerValue];
//    NSInteger videoCount = [dic[@"videoCount"] integerValue];
//    NSString *description = dic[@"speak_comment_content"];
//    NSString *description1 = [WPMySecurities textFromBase64String:description];
//    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
//    NSString *speak_comment_state = dic[@"speak_comment_state"];
//    NSString *lastDestription = [NSString stringWithFormat:@"%@\n%@",speak_comment_state,description3];
//    if (description3.length) {
//        if ([description3 isEqualToString:@"分享"]) {
//        lastDestription = [NSString stringWithFormat:@"%@/分享",speak_comment_state];
//        }
//    }
//    else
//    {
//        lastDestription = speak_comment_state;
//    }
//    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
//    CGFloat descriptionLabelHeight;//内容的显示高度
//    descriptionLabelHeight = [self sizeWithString:lastDestription fontSize:FUCKFONT(14)].height;
//    CGFloat allHeight = descriptionLabelHeight;
//    if (descriptionLabelHeight > normalSize.height *9) {//6
//        descriptionLabelHeight = normalSize.height *9;//6
//        if (_choiseAllArray.count)
//        {
//            for (NSIndexPath*indexpath in _choiseAllArray) {
//                if (indexPath == indexpath) {
//                    descriptionLabelHeight = allHeight;
//                    
////                    descriptionLabelHeight += 2*normalSize.height;
//                }
//            }
//        }
//        else
//        {
//         descriptionLabelHeight = normalSize.height *9;
//        }
//        
////        descriptionLabelHeight += 5;
//        
//        self.isMore = YES;
//    } else {
//        self.isMore = NO;
//        descriptionLabelHeight = descriptionLabelHeight;
//    }
//    
//    //加上全文的高度
//    if (self.isMore) {
//        descriptionLabelHeight += normalSize.height+10;
//    }
//    CGFloat photosHeight;//定义照片的高度
//    
//    if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"]) {
//        photosHeight = kHEIGHT(43);
//    } else if ([shareType isEqualToString:@"1"]) {
//        photosHeight = kHEIGHT(43);
//    }else {
//        CGFloat photoWidth;
//        CGFloat videoWidth;
//        photoWidth = (SCREEN_WIDTH == 320) ? 74 : ((SCREEN_WIDTH == 375) ? 79 : 86);
////        videoWidth = (SCREEN_WIDTH == 320) ? 140 : ((SCREEN_WIDTH == 375) ? 164 : 172);
//        videoWidth = (SCREEN_WIDTH == 320) ? 112 : ((SCREEN_WIDTH == 375) ? 131 : 145);
//        
//        if (videoCount == 1) {
////            NSLog(@"controller 有视频");
//            photosHeight = videoWidth;
//        } else {
//            if (count == 0) {
//                photosHeight = 0;
//            } else if (count >= 1 && count <= 3) {
//                photosHeight = photoWidth;
//            } else if (count >= 4 && count <= 6) {
//                photosHeight = photoWidth*2 + 3;
//            } else {
//                photosHeight = photoWidth*3 + 6;
//            }
//        }
//    }
//    
//    NSArray *praiseArr = dic[@"praiseUser"];
//    NSArray *shareArr = dic[@"shareUser"];
//    NSArray *discussArr = dic[@"DiscussUser"];
//    CGFloat bottomHeight = [DynamicBottomView calculateHeightWithInfo:dic];
//    
//    CGFloat cellHeight;
//    
//    if (praiseArr.count == 0 && shareArr.count ==0 && discussArr.count == 0) { //没有bottom
//        
//        if ([dic[@"address"] length] == 0) { //有地址
//            
//            if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
//                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
//            } else { //不是简历，求职
//                if ([dic[@"original_photos"] count] == 0) {
//                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
//                } else {
//                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
//                }
//                
//            }
//            
//        } else { //没地址
//            
//            if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
//                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + 8;
//            } else {
//                if ([dic[@"original_photos"] count] == 0) {
//                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32) + 8;
//                } else {
//                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + 8;
//                }
//            }
//            
//        }
//        
//    } else { //有bottom
//        
//        if ([dic[@"address"] length] == 0) { //没有地址
//            
//            if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
//                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
//            } else { //不是简历，求职
//                if ([dic[@"original_photos"] count] == 0) {
//                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
//                } else {
//                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10) + 8;
//                }
//            }
//        } else { //有地址
//            if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
//                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
//            } else {
//                if ([dic[@"original_photos"] count] == 0) {
//                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
//                } else {
//                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
//                }
//            }
//            
//        }
//        
//    }
    return [self.cellHeightArray[indexPath.row] floatValue];
    
}

#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}

//-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return YES;
//}
//
//-(BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
//    if (action == @selector(copy:)) {
//        return YES;
//    }
//    
//    return NO;
//}
//
//-(void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
//    
////    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (action == @selector(copy:)) {
////        [UIPasteboard generalPasteboard].string = cell.textLabel.text;
//    }
//    
//}

-(void)hideThreeButton
{
    if (self.IsShowThree) {
        self.IsShowThree = NO;
        [self hideView];
        return;
    }

}

#pragma mark - 查看个人主页
- (void)checkHomePageWith:(NSIndexPath *)indexPath
{
    if (self.IsShowThree) {
        self.IsShowThree = NO;
        [self hideView];
        return;
    }
    [self keyBoardDismiss];
    NewHomePageViewController *homepage = [[NewHomePageViewController alloc] init];
    homepage.info = self.dataSource[indexPath.row];
    homepage.isComeFromDynamic = YES;
    [self.navigationController pushViewController:homepage animated:YES];
}

#pragma mark 分享
- (void)shareDynamicWithIndex:(NSIndexPath *)index
{
    NSDictionary *dic = self.dataSource[index.row];
    WPSendToFriends *toFriends = [[WPSendToFriends alloc]init];
    NSString * title = [toFriends shareShuoShuo:@[dic]];
    
    [self hideView];
    [self keyBoardDismiss];
    NSString *urlStr = [NSString stringWithFormat:@"%@/webMobile/November/Speak_detail.aspx?speak_id=%@",IPADDRESS,dic[@"sid"]];
    [YYShareManager shareWithTitle:title url:urlStr action:^(YYShareManagerType type) {
        
        if (type == YYShareManagerTypeWeiPinFriends)
        {
            [toFriends sendShuoShuoToFriends:dic success:^(NSArray *array, NSString *userId, NSString *messageContent, NSString *display_type) {
                WPRecentLinkManController * linkMan = [[WPRecentLinkManController alloc]init];
                linkMan.dataSource = array;
                linkMan.toUserId = userId;
                linkMan.transStr = messageContent;
                linkMan.display_type = display_type;
                [self.navigationController pushViewController:linkMan animated:YES];
            }];
        }
        if (type == YYShareManagerTypeWorkLines) {
            NSString * action = [NSString new];
            NSDictionary * dic = self.dataSource[index.row];
            action = [dic[@"share"] isEqualToString:@"2"]?@"ExistsResume":([dic[@"share"] isEqualToString:@"3"]?@"ExistsJob":@"ExistsSpeak");
           
            //判断分享的是否被删除
            NSString * urlStr = [NSString stringWithFormat:@"%@/ios/speak_manage.ashx",IPADDRESS];
            NSDictionary * dictionary = @{@"action":action,@"id":dic[@"jobids"]};
            NSArray * jobAray = [dic[@"jobids"] componentsSeparatedByString:@","];
            if ([dic[@"share"] integerValue] && jobAray.count == 1) {
                [WPHttpTool postWithURL:urlStr params:dictionary success:^(id json) {
                    //
                    NSString * string = [NSString new];
                    string = [dic[@"share"] isEqualToString:@"2"]?@"该简历已被删除":([dic[@"share"] isEqualToString:@"3"]?@"该招聘已被删除":@"该说说已被删除");
                    
                    if ([json[@"status"] integerValue]) {
                        [MBProgressHUD createHUD:string View:self.view];
                    }
                    else
                    {
                        ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
                        share.shareInfo = self.dataSource[index.row];
                        share.shareSuccessedBlock = ^(id json){
                            [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
                            [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
                        };
                        [self.navigationController pushViewController:share animated:YES];
                    }
                } failure:^(NSError *error) {
                    [MBProgressHUD createHUD:@"网络错误" View:self.view];
                }];
            }
            else
            {
                ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
                share.shareInfo = self.dataSource[index.row];
                share.shareSuccessedBlock = ^(id json){
                    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
                    [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
                };
                [self.navigationController pushViewController:share animated:YES];

            }
            
//            [WPHttpTool postWithURL:urlStr params:dictionary success:^(id json) {
//                NSString * string = [NSString new];
//                string = [dic[@"share"] isEqualToString:@"2"]?@"该简历已被删除":([dic[@"share"] isEqualToString:@"3"]?@"该招聘已被删除":@"该说说已被删除");
//                
//                if (json[@"info"]) {
//                    [MBProgressHUD createHUD:string View:self.view];
//                }
//                else
//                {
//                    ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
//                    share.shareInfo = self.dataSource[index.row];
//                    share.shareSuccessedBlock = ^(id json){
//                        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
//                        [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
//                    };
//                    [self.navigationController pushViewController:share animated:YES];
//                }
//            } failure:^(NSError *error) {
//                [MBProgressHUD createHUD:@"网络错误" View:self.view];
//            }];
            
            
//        ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
//        share.shareInfo = self.dataSource[index.row];
//        share.shareSuccessedBlock = ^(id json){
//            [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
//            [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
//        };
//        [self.navigationController pushViewController:share animated:YES];
        }
    } status:^(UMSocialShareResponse*status) {
//        if (status == UMSResponseCodeSuccess) {
//            
//        }
    }];
    
}

#pragma mark 点赞
- (void)addLinkWithIndex:(NSIndexPath *)indexPath
{
    //    NSLog(@"***%ld",(long)indexPath.row);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[indexPath.row]];
    //    NSLog(@"%@",dic);
    NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
    //    NSLog(@"####%@",is_good);
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"prise";
    params[@"speak_trends_id"] = dic[@"sid"];
    params[@"user_id"] = userInfo[@"userid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
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
//        NSLog(@"json: %@",json);
//        [self updateCommentAndPraiseCountWithIndex:indexPath isPraise:YES];
        [self updatePraiseWithIndex:indexPath];
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
}

#pragma mark 删除
- (void)dustbinClickWithIndexPath:(NSIndexPath *)index{
    [self hideView];
    [self keyBoardDismiss];

    NSDictionary *dic = [NSDictionary dictionary];
    //    NSIndexPath *path = [self.tableViews[self.currentPage] indexPathForCell:cell];
    dic = self.dataSource[index.row];
    
    //    NSLog(@"####%@",url);
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"deleteDynamic";
    params[@"speak_id"] = [NSString stringWithFormat:@"%@",dic[@"sid"]];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    
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
    self.deletIndex = index.row;
    
    //    NSLog(@"****%@",params);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该条说说吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
        } else {
            NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
            [WPHttpTool postWithURL:url params:self.deletParams success:^(id json) {
                if ([json[@"status"] integerValue] == 1) {
//                    [MBProgressHUD showSuccess:@"删除成功"];
                    //存放高度的数组中的数据要移除
                    [self.cellHeightArray removeObjectAtIndex:self.deletIndex];
                    [self.dataSource removeObjectAtIndex:self.deletIndex];
                    [self.tableView reloadData];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
                [MBProgressHUD showError:@"删除失败"];
            }];
            
        }
    }
}

#pragma mark - 点赞后更新出最新的点赞数据
- (void)updatePraiseWithIndex:(NSIndexPath *)index
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getPriseIndex";
    params[@"speak_id"] = self.dataSource[index.row][@"sid"];
    params[@"user_id"] = userInfo[@"userid"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[index.row]];
        NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
        [dic setObject:json[@"praiseUser"] forKey:@"praiseUser"];
        [dic setObject:json[@"speak_praise_count"] forKey:@"speak_praise_count"];
        if ([is_good isEqualToString:@"0"]) {
            [dic setObject:@"1" forKey:@"is_good"];
        } else {
            [dic setObject:@"0" forKey:@"is_good"];
        }
        [self.dataSource replaceObjectAtIndex:index.row withObject:dic];
        [self getHeightOfCell:self.dataSource];
        [self.tableView reloadData];
    } failure:^(NSError *error) {

    }];

}

#pragma mark - 评论后更新出最新的评论数据
- (void)updateDiscussCountWithIndex:(NSIndexPath *)index
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getDiscusIndex";
    params[@"speak_id"] = self.dataSource[index.row][@"sid"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@",json);
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[index.row]];
        [dic setObject:json[@"DiscussUser"] forKey:@"DiscussUser"];
        [dic setObject:json[@"speak_trends_person"] forKey:@"speak_trends_person"];
        //        NSLog(@"****%@",dic);
        [self.dataSource replaceObjectAtIndex:index.row withObject:dic];
        //改变高度
        
         [self getHeightOfCell:self.dataSource];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark - 更新分享的最新数据
- (void)updateShareCountWithIndex:(NSIndexPath *)index
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getShareIndex";
    params[@"speak_id"] = self.dataSource[index.row][@"sid"];
    params[@"user_id"] = kShareModel.userId;
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[index.row]];
        [dic setObject:json[@"shareUser"] forKey:@"shareUser"];
        [dic setObject:[NSString stringWithFormat:@"%@",json[@"shareCount"]] forKey:@"shareCount"];
        //        NSLog(@"****%@",dic);
        [self.dataSource replaceObjectAtIndex:index.row withObject:dic];
         [self getHeightOfCell:self.dataSource];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark 更新评论和赞的数量
- (void)updateCommentAndPraiseCountWithIndex:(NSIndexPath *)index isPraise:(BOOL)isPraise
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getsum";
    params[@"speak_trends_id"] = self.dataSource[index.row][@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
//    NSLog(@"######%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        if ([json[@"state"] integerValue] == 0) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[index.row]];
            NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
            [dic setObject:json[@"discuss"] forKey:@"speak_trends_person"];
            [dic setObject:json[@"click"] forKey:@"speak_praise_count"];
            if (isPraise) {
                if ([is_good isEqualToString:@"0"]) {
                    [dic setObject:@"1" forKey:@"is_good"];
                } else {
                    [dic setObject:@"0" forKey:@"is_good"];
                }
            }
            [self.dataSource replaceObjectAtIndex:index.row withObject:dic];
             [self getHeightOfCell:self.dataSource];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error.description);
    }];
    
}

#pragma mark - 发送评论消息
- (void)sendCommentMessage:(id)obj
{
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *dic = self.dataSource[_selectedIndexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"replySpeak";
    params[@"speak_id"] = dic[@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = myDic[@"userid"];
    //    params[@"nick_name"] = myDic[@"nick_name"];
    params[@"by_nick_name"] = dic[@"nick_name"];
    params[@"speak_comment_content"] = obj;
    if (self.isTopic) {//评论
        params[@"speak_reply"] = @"0";
    } else {//回复
        params[@"speak_reply"] = @"1";
        params[@"by_user_id"] = self.by_user_id;
    }
    
//    NSLog(@"****%@",params);
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    
//    NSLog(@"####%@",url);
    
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"json: %@",json);
        if ([json[@"status"] integerValue] == 1) {
            [self updateDiscussCountWithIndex:_selectedIndexPath];
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
    // 键盘隐藏
    [self keyBoardDismiss];
}

#pragma mark ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self keyBoardDismiss];
    [self hideView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat Y = scrollView.contentOffset.y;
    WPShuoStaticData * shuoData = [WPShuoStaticData shareShuoData];
    shuoData.scrollerPosition = [NSString stringWithFormat:@"%f",Y];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",Y] forKey:@"scrollerY"];
}

@end
