//
//  NewHomePageViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/3/8.
//  Copyright © 2016年 WP. All rights reserved.
//  个人主页

#import "NewHomePageViewController.h"
#import "WPShareModel.h"
#import "RSButton.h"
#import "RSButtonMenu.h"
#import "WorkTableViewCell.h"
#import "PersonalInfoViewController.h"
#import "HJCActionSheet.h"
#import "UIMessageInputView.h"
#import "IQKeyboardManager.h"
#import "NewDetailViewController.h"
#import "YYShareManager.h"
#import "ShareEditeViewController.h"
#import "WPNewsViewController.h"
#import "WPMySecurities.h"
#import "NearInterViewController.h"
#import "ShareDetailController.h"
#import "ReportViewController.h"
#import "CollectViewController.h"
#import "HCInputBar.h"
#import "WPThreeBackView.h"
#import "WPSendToFriends.h"
#import "WPRecentLinkManController.h"
#import "WPDownLoadVideo.h"
#import "MTTDatabaseUtil.h"
@interface NewHomePageViewController ()<RSButtonMenuDelegate,UITableViewDataSource,UITableViewDelegate,HJCActionSheetDelegate,UIMessageInputViewDelegate>

/**评论 键盘 */
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
@property (nonatomic, strong) UIView *headView;       /**< 筛选框 */
@property (nonatomic,strong) RSButton *button5;
@property (nonatomic,strong) RSButtonMenu *buttonMenu1;
@property (nonatomic,strong) UIView *backView1;
@property (nonatomic,assign) NSUInteger index1;
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) NSString *speak_type; //说说类型
@property (nonatomic,assign) NSUInteger page;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign) BOOL isMore;            //是否有显示更多
@property (nonatomic,assign) BOOL isEditeNow;            //是否正在编辑状态

/**选中cell的IndexPath 评论 */
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@property (nonatomic,strong) NSMutableDictionary *deletParams;   //所要删除说说的参数
@property (nonatomic,assign) NSInteger deletIndex;               //所要删除说说的位置
@property (nonatomic,assign) BOOL isTopic;               //当前是回复说说还是回复评论
@property (nonatomic, strong) NSString *by_user_id;      //被回复人的user_id
@property (nonatomic, strong) NSString *peplyId;         //当前评论的id
@property (strong, nonatomic) HCInputBar *inputBar;
@property (nonatomic, strong) NSMutableArray*choiseAllArray;
@end

@implementation NewHomePageViewController
{
    BOOL _wasKeyboardManagerEnabled;
}
-(NSMutableArray*)choiseAllArray
{
    if (!_choiseAllArray)
    {
        _choiseAllArray = [NSMutableArray array];
    }
    return _choiseAllArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    if ([kShareModel.userId isEqualToString:self.info[@"user_id"]]) {
        self.titleView.titleString = @"回忆录";
    } else {
         self.titleView.titleString = self.info[@"nick_name"];
    }
    self.navigationItem.titleView = self.titleView;
    [[MTTDatabaseUtil instance] getMyShuoUserid:self.info[@"user_id"] success:^(NSArray *array) {
        if (array.count) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:array];
            [self.tableView reloadData];
        }
    }];
//    [[MTTDatabaseUtil instance] getMyShuoshuo:^(NSArray *array) {
//        if (array.count) {
//            [self.dataSource removeAllObjects];
//            [self.dataSource addObjectsFromArray:array];
//            [self.tableView reloadData];
//            
//        }
//    }];
    self.view.backgroundColor = [UIColor whiteColor];
    self.index1 = 0;
    self.speak_type = @"0";
    self.page = 1;
    self.isMore = NO;
    self.isEditeNow = NO;
    self.buttons = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    [self initNav];
    [self.tableView.mj_header beginRefreshing];
    
    // 评论
//    _myMsgInputView = [UIMessageInputView messageInputViewWithType:UIMessageInputViewContentTypeTweet];
//    _myMsgInputView.delegate = self;
    if (!self.isComeFromDynamic) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToShareDetailNotification:) name:@"shareJump" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToShareDynamicDetailNotification:) name:@"shareJumpToDynamic" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeJumpToShareDynamicDetailNotification:) name:@"resumeJumpToDynamic" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToPersonalHomePageNotification:) name:@"jumpToPersonalHomePage" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportNotification:) name:@"report" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectNotification:) name:@"collect" object:nil];
       
    }
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContent:) name:@"reloadShuoShuoDetail" object:nil];//reloadShuoShuo
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideview) name:@"HIDETHREEVIEW" object:nil];
    [self.view addSubview:self.inputBar];
    self.inputBar.hidden = YES;
    //块传值
    __weak typeof(self) weakSelf = self;
    [_inputBar showInputViewContents:^(NSString *contents) {
        NSString * string = [NSString stringWithFormat:@"%@",contents];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (!string.length) {
            [MBProgressHUD createHUD:@"请输入内容" View:self.view];
            return ;
        }
        _inputBar.hidden = YES;
        [weakSelf sendCommentMessage:contents];
    }];
    _inputBar.keyBoardHidden = ^(){
        [weakSelf keyBoardDismiss];
    };
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[NewHomePageViewController class]];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRelationship:) name:@"CHANGERELATIONSHIP" object:nil];
}
-(void)changeRelationship:(NSNotification*)noti
{
    NSIndexPath * index = noti.object;
    NSDictionary *dic =  self.dataSource[index.row];
    NSMutableDictionary * mudic = [NSMutableDictionary dictionary];
    [mudic setValuesForKeysWithDictionary:dic];
    [mudic setObject:@"1" forKey:@"add_fuser_state"];
   // [self.dataSource replaceObjectsAtIndexes:index.row withObjects:mudic];
    [self.dataSource replaceObjectAtIndex:index.row withObject:mudic];

}
-(void)reloadContent:(NSNotification*)noti
{
    if (self.dataSource.count) {
        NSIndexPath * index = noti.object;
        if (index.row > self.dataSource.count-1) {
            return;
        }
        [self.tableView reloadRowAtIndexPath:index withRowAnimation:UITableViewRowAnimationNone];
    }
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 键盘 即将显示
//    if (_myMsgInputView) {
//        [_myMsgInputView prepareToShow];
//    }
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 键盘 隐藏
//    if (_myMsgInputView) {
//        [_myMsgInputView prepareToDismiss];
//    }
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentTopic" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deletDiscuss" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentDiscussNotification:) name:@"commentTopic" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDiscussNotification:) name:@"deletDiscuss" object:nil];
    
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


#pragma mark - 跳到分享的招聘或者求职详情页面
- (void)jumpToShareDetailNotification:(NSNotification *)notification
{
    if ([notification.userInfo[@"jobNo"] isEqualToString:@"1"]) {
        NSArray *arr1 = [notification.userInfo[@"url"] componentsSeparatedByString:@"?"];
        NSArray *arr2 = [arr1[1] componentsSeparatedByString:@"&"];
        NSArray *typeArr = [arr2[0] componentsSeparatedByString:@"="];
        NSArray *userArr = [arr2[1] componentsSeparatedByString:@"="];
        //    NSLog(@"%@-----%@",typeArr,userArr);
        NearInterViewController *inter = [[NearInterViewController alloc] init];
        inter.subId = typeArr[1];
        inter.userId = userArr[1];
        inter.urlStr = [IPADDRESS stringByAppendingString:notification.userInfo[@"url"]];
        inter.isRecuilist = [typeArr[0] isEqualToString:@"recruit_id"] ? 1 : 0;
        inter.isSelf = [userArr[1] isEqualToString:kShareModel.userId] ? YES : NO;
        inter.isComeFromDynamic = YES;
        [self.navigationController pushViewController:inter animated:YES];
        
    } else {
        ShareDetailController *detail = [[ShareDetailController alloc] init];
        detail.url = notification.userInfo[@"url"];
        NSIndexPath *index = notification.userInfo[@"index"];
        detail.dic = self.dataSource[index.row];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - 跳到分享的动态详情页面
- (void)jumpToShareDynamicDetailNotification:(NSNotification *)notification
{
    NewDetailViewController *detail = [[NewDetailViewController alloc] init];
    detail.info = @{@"sid" : notification.userInfo[@"sid"],
                    @"nick_name" : notification.userInfo[@"nick_name"]};
    detail.isCommentFromDynamic = NO;
    detail.clickIndex = notification.userInfo[@"index"];
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
    NewHomePageViewController *homepage = [[NewHomePageViewController alloc] init];
    homepage.info = @{ @"user_id" : notification.userInfo[@"user_id"],
                       @"nick_name" : notification.userInfo[@"nick_name"]};
    [self.navigationController pushViewController:homepage animated:YES];
}

#pragma mark - report action
- (void)reportNotification:(NSNotification *)notification
{
    ReportViewController *report = [[ReportViewController alloc] init];
    report.speak_trends_id = notification.userInfo[@"sid"];
    report.type = ReportTypeDynamice;
    [self.navigationController pushViewController:report animated:YES];
    
}

#pragma mark - collect action
- (void)collectNotification:(NSNotification *)notification
{
    CollectViewController *collect = [[CollectViewController alloc] init];
    collect.collect_class = notification.userInfo[@"collect_class"];
    collect.user_id = notification.userInfo[@"user_id"];
    collect.content = notification.userInfo[@"content"];
    collect.img_url = notification.userInfo[@"img_url"];
    collect.vd_url = notification.userInfo[@"vd_url"];
    collect.jobid = notification.userInfo[@"jobid"];
    collect.url = notification.userInfo[@"url"];
    collect.isComeDetail = NO;
    collect.collectSuccessBlock = ^(){
        [MBProgressHUD createHUD:@"收藏成功" View:self.view];
    };
    [self.navigationController pushViewController:collect animated:YES];
}


#pragma mark - 回复评论
- (void)commentDiscussNotification:(NSNotification *)notification
{[self hideview];
    if (self.isEditeNow) {
        [self keyBoardDismiss];
        return;
    }
    //    NSLog(@"%@",notification.userInfo);
    self.by_user_id = notification.userInfo[@"user_id"];
    self.selectedIndexPath = notification.userInfo[@"index"];
    self.isTopic = NO;
//    [_myMsgInputView notAndBecomeFirstResponder];
//    _myMsgInputView.placeHolder = [NSString stringWithFormat:@"回复%@：",notification.userInfo[@"nick_name"]];
    _inputBar.hidden = NO;
    _inputBar.placeHolder = [NSString stringWithFormat:@"回复%@：",notification.userInfo[@"nick_name"]];
    [_inputBar.inputView becomeFirstResponder];
    self.isEditeNow = YES;
    
}

#pragma mark - 删除自己的评论
- (void)deleteDiscussNotification:(NSNotification *)notification
{
    [self hideview];
    if (self.isEditeNow) {
        [self keyBoardDismiss];
        return;
    }
    HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"删除", nil];
    self.peplyId = notification.userInfo[@"sid"];
    self.selectedIndexPath = notification.userInfo[@"index"];
    // 2.显示出来
    [sheet show];
}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 20004)
    {
        WPNewsViewController *news = [[WPNewsViewController alloc] init];
        news.isComeFromePersonal = YES;
        news.type = NewsTypeDynamic;
        [self.navigationController pushViewController:news animated:YES];
    }
    else
    {
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
//    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    WPShareModel *model = [WPShareModel sharedModel];
//    //    NSMutableDictionary *myDic = model.dic;
//    NSMutableDictionary *dic = self.dataSource[_selectedIndexPath.row];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"deletediscuss";
//    params[@"speak_id"] = dic[@"sid"];
//    params[@"username"] = model.username;
//    params[@"password"] = model.password;
//    params[@"peplyId"] = self.peplyId;
//    //    params[@"user_id"] = myDic[@"userid"];
//    //    NSLog(@"%@",params);
//    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        //        NSLog(@"%@--%@",json,json[@"info"]);
//        [self updateDiscussCountWithIndex:_selectedIndexPath];
//    } failure:^(NSError *error) {
//        
//    }];
    
    
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
        _inputBar.placeHolder = @"输入新消息";
    }
    return _inputBar;
}

- (void)initNav
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *usersid = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    if ([usersid isEqualToString:self.info[@"user_id"]]) {
//        self.title = @"回忆录";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
        
    } else {
//        self.title = self.info[@"nick_name"];
    }
    
}

- (void)rightBtnClick
{
//    NSLog(@"右按钮点击事件");
    if ([kShareModel.userId isEqualToString:self.info[@"user_id"]]) {
        
         HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"消息列表", nil];
        
        sheet.tag = 20004;
        [sheet show];
        
        
        
//        WPNewsViewController *news = [[WPNewsViewController alloc] init];
//        news.isComeFromePersonal = YES;
//        news.type = NewsTypeDynamic;
//        [self.navigationController pushViewController:news animated:YES];
    } else {
        NSLog(@"其他人的个人主页右按钮点击");
    }
}

- (UIView *)headView
{
    if (_headView == nil) {
        _headView = [UIView new];
        //        _headView.layer.borderColor = RGB(178, 178, 178).CGColor;
        //        _headView.layer.borderWidth = 0.5;
        _headView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_topLayoutGuide);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@(kHEIGHT(32)));
        }];
        
        UIView *ledgement = [UIView new];
        ledgement.backgroundColor = RGB(178, 178, 178);
        [_headView addSubview:ledgement];
        [ledgement mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headView.mas_bottom).offset(-0.5);
            make.left.right.equalTo(_headView);
            make.height.equalTo(@(0.5));
        }];
        
        CGFloat width = SCREEN_WIDTH;
        NSArray *titles = @[@"全部"];
        for (int i=0; i<titles.count; i++) {
            RSButton *btn = [[RSButton alloc] initWithFrame:CGRectMake(width*i, 0, width, kHEIGHT(32))];
            //        btn.title.text = titles[i];
            [btn setLabelText:titles[i]];
            btn.image.image = [UIImage imageNamed:@"arrow_down"];
            
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
            }
        }
        
    }
    
    return _headView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(64);
            make.left.right.bottom.equalTo(self.view);
        }];
        __weak typeof(self) unself = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.titleView.activity startAnimating];
            [unself.tableView.mj_footer resetNoMoreData];
            _page = 1;
            [unself requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
                [self.titleView.activity stopAnimating];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:datas];
                [_tableView reloadData];
                [_tableView.mj_header endRefreshing];
            } Error:^(NSError *error) {
                [self.titleView.activity stopAnimating];
                [_tableView.mj_header endRefreshing];
            }];
        }];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [unself requestWithPageIndex:_page andIsNear:YES Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.dataSource addObjectsFromArray:datas];
                    //                    for (NSDictionary *dic in datas) {
                    //                        NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
                    //                        [_goodData1 addObject:is_good];
                    //                    }
                }
                [unself.tableView reloadData];
                [_tableView.mj_footer endRefreshing];
            } Error:^(NSError *error) {
                _page--;
                [_tableView.mj_footer endRefreshing];
            }];
        }];
        
    }
    
    return _tableView;
}

- (RSButtonMenu *)buttonMenu1
{
    if (!_buttonMenu1) {
        _buttonMenu1 = [[RSButtonMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - kHEIGHT(32))];
        //        _backView1 = [UIView new];
        //        _backView1.backgroundColor = RGBA(0, 0, 0, 0.5);
        //        _backView1.backgroundColor = [UIColor redColor];
        //        [_backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(_headView.mas_bottom);
        //            make.left.right.bottom.equalTo(self.view);
        //        }];
        //        _buttonMenu1 = [RSButtonMenu new];
        _buttonMenu1.delegate = self;
        //        _buttonMenu1.backgroundColor = [UIColor cyanColor];
        _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(32) + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        [self.view addSubview:_backView1];
        [_backView1 addSubview:_buttonMenu1];
        //        [_buttonMenu1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(_headView.mas_bottom);
        //            make.left.right.bottom.equalTo(self.view);
        ////            make.bottom.equalTo(self.view.mas_bottom);
        //        }];
        __weak typeof(self) unself = self;
        _buttonMenu1.touchHide = ^(){
            [unself hidden];
        };
        
    }
    return _buttonMenu1;
}

#pragma mark - 封装网络请求
- (void)requestWithPageIndex:(NSInteger)page andIsNear:(BOOL)isNear Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getSpeakionList";
    params[@"page"] = [NSString stringWithFormat:@"%ld",(long)page];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = self.info[@"user_id"];
    params[@"luser_id"] = kShareModel.userId;
    params[@"state"] = @"4";
    params[@"speak_type"] = self.speak_type;
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSArray *arr = [[NSArray alloc] initWithArray:json[@"list"]];
        success(arr,(int)arr.count);
        //数据缓存，后期可能会用到
//        if (arr.count && page == 1) {
//
//            [[MTTDatabaseUtil instance] deleteMyShuoshuouserID:self.info[@"user_id"]];
//        }
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
        //数据缓存，后期可能会用到
//        if (page == 1 && arr.count) {
//            [[MTTDatabaseUtil instance] upDateMyShuoshuo:arr and:^(NSError *error) {
//            }];
//        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
        //数据缓存，后期可能用到
//        if (page == 1) {
//            [[MTTDatabaseUtil instance] getMyShuoUserid:self.info[@"user_id"] success:^(NSArray *array) {
//                 success(array,(int)array.count);
//            }];
//        }
    }];
    
}
-(NSString * )localUrl:(NSString*)urlStr
{
    //    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"thumb_" withString:@""];
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

- (void)selectBtnClick:(UIButton *)sender
{
    NSMutableArray *typeArr = [NSMutableArray array];
    NSMutableArray *timeArr = [NSMutableArray array];
    NSArray *type = @[@"全部话题",@"人气排行",@"职场说说",@"匿名吐槽",@"职场八卦",@"上班族",@"正能量",@"心理学",@"工作狂",@"创业心得",@"老板心得",@"管理智慧",@"求职宝典",@"找工作",@"交友",@"在路上",@"早安心语",@"情感心语"];
    NSArray *time = @[@"最新动态",@"好友圈动态",@"陌生人动态",@"我的动态"];
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
    if (!sender.isSelected) {
        [self.buttonMenu1 setNewLocalData:typeArr andSelectIndex:self.index1];
        self.button5.selected = YES;
        _backView1.hidden = NO;
    } else {
        _backView1.hidden = YES;
        self.button5.selected = NO;
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

- (void)RSButtonMenuDelegate:(IndustryModel *)model selectMenu:(RSButtonMenu *)menu
{
//    if ([menu isEqual:_buttonMenu1]) {
//        [self.button5 setLabelText:[model.industryName substringToIndex:model.industryName.length - 2]];
//        self.state = model.industryID;
//        self.index1 = model.industryID.integerValue - 1;
//    } else {
        [self.button5 setLabelText:model.industryName];
        self.speak_type = model.industryID;
        self.index1 = model.industryID.integerValue;
        if ([model.industryID isEqualToString:@"0"]) {
            [self.button5 setLabelText:@"全部"];
        }
//    }
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
    [self hidden];
}

- (void)delay
{
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)hidden{
    self.backView1.hidden = YES;
    self.button5.selected = NO;
    for (UIButton *button in _buttons) {
        button.selected = NO;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataSource.count;
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
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:1 inSection:3];
//    [self hideBackView:indexpath];
//}
#pragma mark - tabeleView delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>_dataSource.count-1) {
        return NO;
    }
    if(tableView.isEditing){
        return NO;
    }else{
        return YES;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    WorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
//        cell = [[WorkTableViewCell alloc] init];
        
        cell = [[WorkTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.type = WorkCellTypeNormal;
    }
    cell.isDetail = NO;
    cell.choiseArray = _choiseAllArray;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    NSDictionary *dicInfo = _dataSource[indexPath.row];
    cell.indexPath = indexPath;
    cell.isFromDetail = YES;
    [cell confineCellwithData:dicInfo];
    cell.praiseActionBlock = ^(NSIndexPath *index){
        [self addLinkWithIndex:index];
    };
    
    //点击全文和收起
    cell.clickAllTextBtn= ^(NSIndexPath*index,UIButton*sender){
        sender.selected = !sender.selected;
        if (sender.selected) {
            [self.choiseAllArray addObject:index];
        }
        else
        {
            [self.choiseAllArray removeObject:index];
        }
        [self.tableView reloadRowAtIndexPath:index withRowAnimation:UITableViewRowAnimationNone];
        
    };
    
    cell.clickThreeButton =^(NSIndexPath *indexpath){
        [self hideBackView:indexpath];
        WorkTableViewCell * cell1 = [tableView cellForRowAtIndexPath:indexpath];
        for (UIView * view in cell1.contentView.subviews) {
            if ([view isKindOfClass:[WPThreeBackView class]]) {
                WPThreeBackView * BackView = (WPThreeBackView*)view;
                BackView.indexpath = indexpath;
                BackView.hidden = NO;
                if (BackView.frame.origin.x == SCREEN_WIDTH-kHEIGHT(10)-18-6) {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGRect rect = BackView.frame;
                        rect.origin.x = SCREEN_WIDTH-kHEIGHT(10)-6-3*kHEIGHT(57)-18;
                        BackView.frame = rect;
                    }];
                }
                else
                {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGRect rect = BackView.frame;
                        rect.origin.x = SCREEN_WIDTH-kHEIGHT(10)-18-6 ;
                        BackView.frame = rect;
                    }];
                }
            }
        }
    };
    
    //点击评论
    cell.commentActionBlock = ^(NSIndexPath *index){
        [self hideview];
        [self.inputBar.inputView becomeFirstResponder];
//        NewDetailViewController *detail = [[NewDetailViewController alloc] init];
//        detail.info = self.dataSource[indexPath.row];
//        detail.isCommentFromDynamic = YES;
//        detail.jumpType = DetailJumpToComment;
//        detail.clickIndex = index;
//        [self.navigationController pushViewController:detail animated:YES];
    };
    
    cell.deleteActionBlock = ^(NSIndexPath *index){
        [self dustbinClickWithIndexPath:index];
    };
    
    cell.shareActionBlock = ^(NSIndexPath *index){
        [self shareDynamicWithIndex:index];
    };
    cell.checkActionBlock = ^(NSIndexPath *index){

        PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
        info.friendID = self.info[@"user_id"];
        
        if ([info.friendID isEqualToString:kShareModel.userId]) {
            info.title = @"个人资料";
        }
        else
        {
           info.title = @"好友资料";
        }
        
        NSDictionary *dic =  self.dataSource[indexPath.row];
        info.addFriendsSuccess = ^(NSIndexPath * index){
              NSDictionary *dic =  self.dataSource[index.row];
            NSMutableDictionary * mudic = [NSMutableDictionary dictionary];
            [mudic addEntriesFromDictionary:dic];
            [mudic setObject:@"0" forKey:@"add_fuser_state"];
            [self.dataSource replaceObjectAtIndex:index.row withObject:mudic];
        };
        info.ccindex = indexPath;
        if ([dic[@"add_fuser_state"] isEqualToString:@"0"]) {  // 1陌生人 0好友 [self.dataSource[indexPath.row] is_friend]
            info.newType = NewRelationshipTypeFriend;
        }else{
            info.newType = NewRelationshipTypeStranger;
        }
       info.comeFromVc= @"话题详情";
        [self.navigationController pushViewController:info animated:YES];
    };
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{[self hideview];
    if (self.isEditeNow) {
        [self keyBoardDismiss];
        return;
    }
    NewDetailViewController *detail = [[NewDetailViewController alloc] init];
    detail.info = self.dataSource[indexPath.row];
    detail.clickIndex = indexPath;
    detail.isCommentFromDynamic = NO;
    detail.deleteSuccessBlock = ^(NSIndexPath *index){
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
    NSDictionary *dic = self.dataSource[indexPath.row];
    NSString *shareType = [NSString stringWithFormat:@"%@",dic[@"share"]];
    
    NSInteger count = [dic[@"imgCount"] integerValue];
    NSInteger videoCount = [dic[@"videoCount"] integerValue];
    
    NSString *description = dic[@"speak_comment_content"];
    //    NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
    //    NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
    //    NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
    NSString *description1 = [WPMySecurities textFromBase64String:description];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
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
//    NSDictionary *dic = self.dataSource[indexPath.row];
//    NSString *shareType = [NSString stringWithFormat:@"%@",dic[@"share"]];
//    
//    NSInteger count = [dic[@"imgCount"] integerValue];
//    NSInteger videoCount = [dic[@"videoCount"] integerValue];
//    
//    NSString *description = dic[@"speak_comment_content"];
////    NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
////    NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
////    NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
//    NSString *description1 = [WPMySecurities textFromBase64String:description];
//    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
//    NSString *speak_comment_state = dic[@"speak_comment_state"];
//    NSString *lastDestription = [NSString stringWithFormat:@"%@\n%@",speak_comment_state,description3];
//    
//    if (description3.length) {
//        if ([description3 isEqualToString:@"分享"]) {
//            lastDestription = [NSString stringWithFormat:@"%@/分享",speak_comment_state];
//        }
//    }
//    else
//    {
//        lastDestription = speak_comment_state;
//    }
//    
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
//                }
//            }
//        }
//        else
//        {
//            descriptionLabelHeight = normalSize.height *9;
//        }
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
//    
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
//        videoWidth = (SCREEN_WIDTH == 320) ? 140 : ((SCREEN_WIDTH == 375) ? 164 : 172);
//        if (videoCount == 1) {
//            NSLog(@"controller 有视频");
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
//                cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
//            } else { //不是简历，求职
//                if ([dic[@"original_photos"] count] == 0) {
//                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
//                } else {
////                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
//                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + descriptionLabelHeight + photosHeight + kHEIGHT(32) + 8;
//                }
//                
//            }
//            
//        } else { //没地址
//            
//            if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
//                cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + 8;
//            } else {
//                if ([dic[@"original_photos"] count] == 0) {
//                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32) + 8;
//                } else {
//                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + 8;
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
//                cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
//            } else { //不是简历，求职
//                if ([dic[@"original_photos"] count] == 0) {
//                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
//                } else {
//                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10) + 8;
//                }
//            }
//        } else { //有地址
//            
//            if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
//                cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
//            } else {
//                if ([dic[@"original_photos"] count] == 0) {
//                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
//                } else {
//                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + bottomHeight + 2*kHEIGHT(10)+ 8;
//                }
//            }
//            
//        }
//        
//    }
//    
    return cellHeight;
    
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

#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size;
}

#pragma mark 分享
- (void)shareDynamicWithIndex:(NSIndexPath *)index
{
    NSDictionary * dic = self.dataSource[index.row];
    WPSendToFriends * toFriends = [[WPSendToFriends alloc]init];
    NSString * title = [toFriends shareShuoShuo:@[dic]];
    NSString *urlStr = [NSString stringWithFormat:@"%@/webMobile/November/Speak_detail.aspx?speak_id=%@",IPADDRESS,dic[@"sid"]];
    [self hideview];
    [self keyBoardDismiss];
    [YYShareManager shareWithTitle:title url:urlStr action:^(YYShareManagerType type) {
        if (type == YYShareManagerTypeWeiPinFriends)
        {
            NSLog(@"分享到微聘好友");
            [toFriends sendShuoShuoToWeiPinFriendsFromDetail:dic success:^(NSArray *array, NSString *toUserId, NSString *messageContent, NSString *display_type) {
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
            share.shareInfo = self.dataSource[index.row];
            share.shareSuccessedBlock = ^(id json){
                [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
                [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
            };
            [self.navigationController pushViewController:share animated:YES];
            
        }
    } status:^(UMSocialShareResponse* status) {
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
        NSLog(@"json: %@",json);
        //        [self updateCommentAndPraiseCountWithIndex:indexPath isPraise:YES];
        [self updatePraiseWithIndex:indexPath];
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
    
}

#pragma mark 删除
- (void)dustbinClickWithIndexPath:(NSIndexPath *)index{
    [self keyBoardDismiss];
    [self hideview];
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
    self.deletIndex = index.row;
    
    //    NSLog(@"****%@",params);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该条说说吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
    
    //    [self.data1 removeObjectAtIndex:btn.tag - 1];
    //    [self.table1 reloadData];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            NSLog(@"取消");
        } else {
            NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
            [WPHttpTool postWithURL:url params:self.deletParams success:^(id json) {
                NSLog(@"%@---%@",json,json[@"info"]);
                if ([json[@"status"] integerValue] == 1) {
                    [MBProgressHUD showSuccess:@"删除成功"];
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
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getPriseIndex";
    params[@"speak_id"] = self.dataSource[index.row][@"sid"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        //        NSLog(@"%@",json);
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[index.row]];
        NSString *is_good = [NSString stringWithFormat:@"%@",dic[@"is_good"]];
        [dic setObject:json[@"praiseUser"] forKey:@"praiseUser"];
        [dic setObject:json[@"speak_praise_count"] forKey:@"speak_praise_count"];
        if ([is_good isEqualToString:@"0"]) {
            [dic setObject:@"1" forKey:@"is_good"];
        } else {
            [dic setObject:@"0" forKey:@"is_good"];
        }
        //        NSLog(@"****%@",dic);
        [self.dataSource replaceObjectAtIndex:index.row withObject:dic];
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
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[index.row]];
        [dic setObject:json[@"shareUser"] forKey:@"shareUser"];
        [dic setObject:[NSString stringWithFormat:@"%@",json[@"shareCount"]] forKey:@"shareCount"];
        //        NSLog(@"****%@",dic);
        [self.dataSource replaceObjectAtIndex:index.row withObject:dic];
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
        //                NSLog(@"%@",json);
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[index.row]];
        [dic setObject:json[@"DiscussUser"] forKey:@"DiscussUser"];
        [dic setObject:json[@"speak_trends_person"] forKey:@"speak_trends_person"];
        //        NSLog(@"****%@",dic);
        [self.dataSource replaceObjectAtIndex:index.row withObject:dic];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
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
    if (self.isTopic) {
        params[@"speak_reply"] = @"0";
    } else {
        params[@"speak_reply"] = @"1";
        params[@"by_user_id"] = self.by_user_id;
    }
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        if ([json[@"status"] integerValue] == 1) {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
            //            [self updateCommentCount];
            //            [self updateCommentAndPraiseCountWithIndex:_selectedIndexPath isPraise:NO];
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
    
    [self hideview];
}
-(void)hideview{
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:1 inSection:3];
    [self hideBackView:indexpath];
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
