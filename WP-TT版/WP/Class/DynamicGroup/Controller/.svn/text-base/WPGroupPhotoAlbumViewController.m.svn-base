//
//  WPGroupPhotoAlbumViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/4/26.
//  Copyright © 2016年 WP. All rights reserved.
//  群相册

#import "WPGroupPhotoAlbumViewController.h"
#import "GroupPhotoAlumModel.h"
#import "GroupPhotoAlumCell.h"
#import "WriteViewController.h"
#import "WPGroupAlumDetailViewController.h"
#import "RKAlertView.h"
#import "DDGroupModule.h"
#import "IQKeyboardManager.h"
#import "UIMessageInputView.h"
#import "HJCActionSheet.h"
#import "ReportViewController.h"
#import "CollectViewController.h"
#import "PersonalInfoViewController.h"
#import "WPDynamicTipView.h"
#import "WPTipModel.h"
#import "HCInputBar.h"
#import "WPNewsViewController.h"
#import "WPMySecurities.h"
#import "GroupAlbumCommentAndPraise.h"
#import "SessionModule.h"
#import "ChattingModule.h"
#import "MTTDatabaseUtil.h"
#import "MTTMessageEntity.h"
#import "DDMessageSendManager.h"

@interface WPGroupPhotoAlbumViewController ()<UITableViewDataSource,UITableViewDelegate,UIMessageInputViewDelegate,HJCActionSheetDelegate>
@property (nonatomic, copy)NSString * replay_nick_name;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign) NSUInteger page;        //分页
@property (nonatomic, strong) NSMutableArray *dataSource;
/**评论 键盘 */
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
@property (nonatomic,assign) BOOL isEditeNow;            //是否正在编辑状态
@property (nonatomic,copy) NSIndexPath *selectedIndexPath;

@property (nonatomic,assign) BOOL isTopic;               //当前是回复说说还是回复评论
@property (nonatomic, strong) NSString *replay_user_id;      //被回复人的user_id
@property (nonatomic, strong) NSString *Replay_commentID;         //当前评论的id
@property (nonatomic, strong) WPDynamicTipView *tipView; /**< 未读消息提示 */
@property (strong, nonatomic) HCInputBar *inputBar;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NSMutableArray *choiseArray;
@property (nonatomic, strong) UIWindow*coverWindow;
@end

@implementation WPGroupPhotoAlbumViewController
{
    BOOL _wasKeyboardManagerEnabled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[MTTDatabaseUtil instance] getAllAlbum:^(NSArray *array) {
//        if (array.count) {
//            NSDictionary * dic = @{@"list":array};
//            GroupPhotoAlumModel *model = [GroupPhotoAlumModel mj_objectWithKeyValues:dic];
//            NSArray *arr = [[NSArray alloc] initWithArray:model.list];
//            [self.dataSource removeAllObjects];
//            [self.dataSource addObjectsFromArray:arr];
//            [self.tableView reloadData];
//        }
//    }];
    
    self.isTopic = NO;
    self.page = 1;
    self.dataSource = [NSMutableArray array];
    [self initNav];
//    [self.tableView.mj_header beginRefreshing];
    [self.tableView reloadData];
    [self replaceRefresh];
    // 评论
//    _myMsgInputView = [UIMessageInputView messageInputViewWithType:UIMessageInputViewContentTypeTweet];
//    _myMsgInputView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToShareDynamicDetailNotification:) name:@"AlumJumpToDetail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportNotification:) name:@"alumReport" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectNotification:) name:@"alumCollect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalNotifation:) name:@"alumPersonal" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageTip) name:@"GlobalMessageTip" object:nil];
    
//    [self.view addSubview:self.inputBar];
//    self.inputBar.hidden = YES;
//    //块传值
//    __weak typeof(self) weakSelf = self;
//    [_inputBar showInputViewContents:^(NSString *contents) {
//        
//        NSString * string = [NSString stringWithFormat:@"%@",contents];
//        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
//        if (!string.length) {
//            [MBProgressHUD createHUD:@"请输入内容" View:self.view];
//            return ;
//        }
//        
//        //        weakSelf.textWindow.text = contents;
//        _inputBar.hidden = YES;
//        [weakSelf sendCommentMessage:contents];
//    }];
//    _inputBar.keyBoardHidden = ^(){
//        [weakSelf keyBoardDismiss];
//    };
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
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[WPGroupPhotoAlbumViewController class]];
    [self getMessageTip];
}
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
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self requestWithPageIndex:1 Success:^(NSArray *datas, int more) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.titleView.activity stopAnimating];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:datas];
                [self.tableView reloadData];
            });
        } Error:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
              [self.titleView.activity stopAnimating];
            });
        }];
    });
}

-(NSMutableArray*)choiseArray{
    if (!_choiseArray) {
        _choiseArray = [NSMutableArray array];
    }
    return _choiseArray;
}
-(void)getMessageTip
{

    dispatch_queue_t queue = dispatch_get_main_queue();
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        [self requstTipMessgae];
    });
    // 启动定时器
    dispatch_resume(self.timer);
    
}
-(void)requstTipMessgae
{
    NSDictionary * dictionary = @{@"action":@"getAlbumMsgCount",@"user_id":kShareModel.userId,@"username":kShareModel.username,@"group_id":_model.group_id};
    NSString * urlStr = [NSString stringWithFormat:@"%@/msg/msgcount.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dictionary success:^(id json) {
        NSString * count = json[@"count"];
        if (count.intValue) {
            [self messageTip:json];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 当将要返回父级的时候，注销观察者
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GlobalMessageTip" object:nil];//GlobalMessageTip
}

#pragma mark - 请求消息提醒
- (void)messageTip:(NSDictionary*)dictionary
{
     [self.tipView configeWith:dictionary[@"avatar"] count:dictionary[@"count"]];
     self.tableView.tableHeaderView = self.tipView;
//    WPTipModel *model = [WPTipModel sharedManager];
//    if ([model.GroupCount integerValue]>0) {
//        [self.tipView configeWith:model.Group_com_avatar count:model.GroupCount];
//        self.tableView.tableHeaderView = self.tipView;
//    } else {
//        self.tableView.tableHeaderView = nil;
//    }
    
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.coverWindow makeKeyAndVisible];
        [window makeKeyWindow];
    });
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.coverWindow = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentDiscussNotification:) name:@"commentAlumTopic" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDiscussNotification:) name:@"deletAlumDiscuss" object:nil];

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentAlumTopic" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deletAlumDiscuss" object:nil];

    // 键盘 隐藏
//    if (_myMsgInputView) {
//        [_myMsgInputView prepareToDismiss];
//    }
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AlumJumpToDetail" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"alumReport" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"alumCollect" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"alumPersonal" object:nil];

}

#pragma mark - 回复评论
- (void)commentDiscussNotification:(NSNotification *)notification
{
    [self hideView];
    if (self.isEditeNow) {
        [self keyBoardDismiss];
        return;
    }
    //    NSLog(@"%@",notification.userInfo);
    self.replay_user_id = notification.userInfo[@"user_id"];
    self.Replay_commentID = notification.userInfo[@"sid"];
    self.selectedIndexPath = notification.userInfo[@"index"];
    self.isTopic = YES;
//    _myMsgInputView.placeHolder = [NSString stringWithFormat:@"回复%@：",notification.userInfo[@"nick_name"]];
//    [_myMsgInputView notAndBecomeFirstResponder];
//    self.isEditeNow = YES;
    _inputBar.hidden = NO;
    _inputBar.placeHolder = [NSString stringWithFormat:@"回复%@：",notification.userInfo[@"nick_name"]];
    [_inputBar.inputView becomeFirstResponder];
    self.isEditeNow = YES;
    self.replay_nick_name = notification.userInfo[@"nick_name"];
}

#pragma mark - 删除自己的评论
- (void)deleteDiscussNotification:(NSNotification *)notification
{
    [self hideView];
    if (self.isEditeNow) {
        [self keyBoardDismiss];
        return;
    }
    HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"删除", nil];
    self.Replay_commentID = notification.userInfo[@"sid"];
    self.selectedIndexPath = notification.userInfo[@"index"];
    // 2.显示出来
    [sheet show];
}

#pragma mark - 跳到详情页面
- (void)jumpToShareDynamicDetailNotification:(NSNotification *)notification
{
    [self hideView];
    [self keyBoardDismiss];
    NSIndexPath *indexPath = notification.userInfo[@"index"];
    [self goToDetailWith:indexPath isCommentFromAlum:NO];
//    WPGroupAlumDetailViewController *detail = [[WPGroupAlumDetailViewController alloc] init];
//    detail.info = self.dataSource[indexPath.row];
//    detail.isOwner = self.isOwner;
//    detail.group_id = _model.group_id;
//    detail.currentIndex = indexPath;
//    [self.navigationController pushViewController:detail animated:YES];

}

#pragma mark - report action
- (void)reportNotification:(NSNotification *)notification
{
    [self hideView];
    [self keyBoardDismiss];
    ReportViewController *report = [[ReportViewController alloc] init];
    report.speak_trends_id = notification.userInfo[@"sid"];
    report.type = ReportTypeGroupPhotoAlbum;
    [self.navigationController pushViewController:report animated:YES];
    
}

#pragma mark - collect action
- (void)collectNotification:(NSNotification *)notification
{
    [self hideView];
    [self keyBoardDismiss];
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

#pragma mark - personal action
- (void)personalNotifation:(NSNotification *)notifation
{
    [self hideView];
    [self keyBoardDismiss];
    PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
    info.friendID = notifation.userInfo[@"user_id"];
    [self.navigationController pushViewController:info animated:YES];

}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
    GroupPhotoAlumListModel *dic = self.dataSource[_selectedIndexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"DelComment";
    params[@"album_id"] = dic.albumnId;
    params[@"username"] = kShareModel.username;
    params[@"password"] = kShareModel.password;
    params[@"user_id"] = kShareModel.userId;
    params[@"comment_id"] = self.Replay_commentID;
    //    params[@"user_id"] = myDic[@"userid"];
        NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@--%@",json,json[@"info"]);
        [self updateCommentCountWith:_selectedIndexPath];
    } failure:^(NSError *error) {
    }];
}


- (void)initNav
{
    
    self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.navigationItem.titleView = self.titleView;
    
    self.view.backgroundColor = BackGroundColor;
    if (self.numberOfClume.intValue)
    {
//        self.title = [NSString stringWithFormat:@"群相册(%@)",self.numberOfClume];
        self.titleView.titleString = [NSString stringWithFormat:@"群相册(%@)",self.numberOfClume];
    }
    else
    {
//      self.title = @"群相册";
        self.titleView.titleString = @"群相册";
        
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

- (void)rightBtnClick
{
    [self hideView];
    [self keyBoardDismiss];
    WriteViewController *write = [[WriteViewController alloc] init];
    write.is_dynamic = NO;
    write.group_id = self.model.group_id;
    write.groupId = self.groupId;//用来发送消息的群组id
    write.title = @"群相册";
    write.mouble = self.mouble;
    write.publishSuccessBlock = ^(){
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
    };
    [self.navigationController pushViewController:write animated:YES];
}
-(void)replaceRefresh
{
    [self.titleView.activity startAnimating];
    _page = 1;
    [self requestWithPageIndex:_page Success:^(NSArray *datas, int more) {
        [self.titleView.activity stopAnimating];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:datas];
        [_tableView reloadData];
    } Error:^(NSError *error) {
        [self.titleView.activity stopAnimating];
    }];
}
- (void)delay
{
//    [self.tableView.mj_header beginRefreshing];
    [self replaceRefresh];
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


- (void)requsetData
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
    NSDictionary *params = @{@"action" : @"GetRecentlyAlbumList",
                             @"group_id" : _model.group_id,
                             @"user_id" : kShareModel.userId,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"page" : @"2"};
//    NSLog(@"%@",params);
     [WPHttpTool postWithURL:url params:params success:^(id json) {
         NSLog(@"%@",json);
     } failure:^(NSError *error) {
         
     }];
}


#pragma mark - 提示最新
- (WPDynamicTipView *)tipView
{
    if (!_tipView) {
        _tipView = [[WPDynamicTipView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(36) + 8)];
        WS(ws);
        _tipView.clickBlock = ^(){
            WPNewsViewController *news = [[WPNewsViewController alloc] init];
            news.groupId = ws.model.group_id;
            news.type = NewsTypeGroup;
            news.gid = ws.model.g_id;//群消息id
            news.mouble = ws.mouble;
            news.readOverBlock = ^(){
                ws.tableView.tableHeaderView= nil;
            };
            [ws.navigationController pushViewController:news animated:YES];
//            WPNewsViewController *news = [[WPNewsViewController alloc] init];
//            news.readOverBlock = ^(){
//                [ws.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
//                [ws performSelector:@selector(delay) withObject:nil afterDelay:0.3];
//            };
//            [ws.navigationController pushViewController:news animated:YES];
        };
    }
    return _tipView;
}


#pragma mark tableView
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_topLayoutGuide);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        __weak typeof(self) unself = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.titleView.activity startAnimating];
            [unself.tableView.mj_footer resetNoMoreData];
            _page = 1;
            [unself requestWithPageIndex:_page Success:^(NSArray *datas, int more) {
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
            [unself requestWithPageIndex:_page Success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.dataSource addObjectsFromArray:datas];
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


#pragma mark - 封装网络请求
- (void)requestWithPageIndex:(NSInteger)page Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
    NSDictionary *params = @{@"action" : @"GetRecentlyAlbumList",
                             @"group_id" : _model.group_id,
                             @"user_id" : kShareModel.userId,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"page" : @(page)};
    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        GroupPhotoAlumModel *model = [GroupPhotoAlumModel mj_objectWithKeyValues:json];
        NSArray *arr = [[NSArray alloc] initWithArray:model.list];
        success(arr,(int)arr.count);
        
        //数据缓存，后期可能会用到
//        if (arr.count && page == 1) {
//          [[MTTDatabaseUtil instance] deleteAllAlbum];
//          [[MTTDatabaseUtil instance] upDateGroupAlbum:json[@"list"] groupID:_model.group_id];
//        }
        
        
        
    } failure:^(NSError *error) {
        //NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
        
        //数据缓存，后期可能会用到
//        [[MTTDatabaseUtil instance] getAllAlbum:^(NSArray *array) {
//            if (array.count && page == 1) {
//                NSDictionary * dic = @{@"list":array};
//                GroupPhotoAlumModel *model = [GroupPhotoAlumModel mj_objectWithKeyValues:dic];
//                NSArray *arr = [[NSArray alloc] initWithArray:model.list];
//                success(arr,(int)arr.count);
//            }
//        }];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(void)hideBackView:(NSIndexPath*)indexPath
{
    for (int i = 0 ; i < self.dataSource.count; i++) {
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:i inSection:0];
        if (indexpath == indexPath) {
            continue;
        }
        GroupPhotoAlumCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
        for (UIView * view in cell.contentView.subviews) {
            if ([view isKindOfClass:[GroupAlbumCommentAndPraise class]]) {
                GroupAlbumCommentAndPraise * backView = (GroupAlbumCommentAndPraise*)view;
                
                [UIView animateWithDuration:0.2 animations:^{
                    CGRect rect = backView.frame;
                    rect.origin.x = SCREEN_WIDTH-kHEIGHT(10)-18-6;
                    backView.frame = rect;
                }];
                
            }
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupPhotoAlumCell *cell = [GroupPhotoAlumCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isDetail = NO;
    cell.isOwner = self.isOwner;
    cell.indexPath = indexPath;
    cell.choiseArray = self.choiseArray;
    cell.dic = self.dataSource[indexPath.row];
    cell.praiseActionBlock = ^(NSIndexPath *index){
        [self praiseClickWith:index];
    };
    
    //点击评论和赞的按钮

    cell.clickTwoBtn = ^(NSIndexPath*index){
        [self hideBackView:index];
        GroupPhotoAlumCell * cell1 = [tableView cellForRowAtIndexPath:index];

        for (UIView * view in cell1.contentView.subviews) {
            if ([view isKindOfClass:[GroupAlbumCommentAndPraise class]]) {
                GroupAlbumCommentAndPraise *BackView = (GroupAlbumCommentAndPraise*)view;
                if (BackView.frame.origin.x == SCREEN_WIDTH-kHEIGHT(10)-18-6) {
                    [UIView animateWithDuration:0.2 animations:^{
                        CGRect rect = BackView.frame;
                        rect.origin.x = SCREEN_WIDTH-kHEIGHT(10)-6-2*kHEIGHT(57)-18;
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
    //点击全文和收起
    cell.clickAllTextBtn = ^(NSIndexPath*index,UIButton*sender){
        BOOL isOrNot = NO;
        for (NSIndexPath * indexpath in self.choiseArray) {
            if (indexpath == index) {
                isOrNot = YES;
            }
        }
        if (isOrNot) {
            [self.choiseArray removeObject:index];
        }
        else
          {
            [self.choiseArray addObject:index];
        }
        
        [self.tableView reloadRowAtIndexPath:index withRowAnimation:UITableViewRowAnimationNone];
    };
    
    
    cell.deleteActionBlock = ^(NSIndexPath *index){
      [RKAlertView showAlertWithTitle:@"提示" message:@"你确定要删除该条群说说吗？" cancelTitle:@"取消" confirmTitle:@"确定" confrimBlock:^(UIAlertView *alertView) {
          [self deleteClickWith:index];
      } cancelBlock:^{
          
      }];
    };
    
    //点击评论
// FIXME:  此处会不会出现循环应用问题
    cell.commentActionBlock = ^(NSIndexPath *index){
//        indexPathSEL = index;
        self.selectedIndexPath = index;
//        [self goToDetailWith:index isCommentFromAlum:YES];
        [self hideView];
        self.inputBar.hidden = NO;
        self.inputBar.placeHolder = @"说点什么吧";
        [self.inputBar.inputView becomeFirstResponder];
    };
    cell.checkActionBlock = ^(NSIndexPath *index){
        PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
        info.friendID = [self.dataSource[index.row] created_user_id];
        [self.navigationController pushViewController:info animated:YES];
    };

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [GroupPhotoAlumCell calculateHeightWithInfo:self.dataSource[indexPath.row] isDetail:NO];
    CGFloat height = [GroupPhotoAlumCell calculateHeightWithInfo:self.dataSource[indexPath.row] isDetail:NO];
    
    GroupPhotoAlumListModel * model = self.dataSource[indexPath.row];
    NSString *description = model.remark;
//    NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
//    NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
//    NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
//    NSString *lastDestription = [WPMySecurities textFromEmojiString:description3];
    NSString *description1 = [WPMySecurities textFromBase64String:description];
    NSString *lastDestription = [WPMySecurities textFromEmojiString:description1];
    
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    CGFloat descriptionLabelHeight;//内容的显示高度
    descriptionLabelHeight = [lastDestription boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(14)]} context:nil].size.height;
    

    if (descriptionLabelHeight > normalSize.height*8) {
        height += normalSize.height + 10;
        
        for (NSIndexPath*inedex in self.choiseArray) {
            if (indexPath == inedex) {
                height -= normalSize.height*8;
                height += descriptionLabelHeight;
            }
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self goToDetailWith:indexPath isCommentFromAlum:NO];
}

#pragma mark 查看全部X条评论
- (void)goToDetailWith:(NSIndexPath *)indexPath isCommentFromAlum:(BOOL)isAlum
{
    [self hideView];
    [self keyBoardDismiss];
    WPGroupAlumDetailViewController *detail = [[WPGroupAlumDetailViewController alloc] init];
    detail.isNeedChat = self.isNeedChat;
    detail.info = self.dataSource[indexPath.row];
    detail.isOwner = self.isOwner;
    detail.group_id = _model.group_id;
    detail.groupId = self.groupId;
    detail.albumId = detail.info.albumnId;
    detail.currentIndexPath = indexPath;
    detail.isCommetFromAlum = isAlum;
    detail.mouble = self.mouble;
    detail.deleteSuccessBlock = ^(NSIndexPath *index){
        [self.dataSource removeObjectAtIndex:index.row];
        [self.tableView reloadData];
    };
    detail.commentSuccessBlock = ^(NSIndexPath *index){
        [self updateCommentCountWith:index];
    };
    detail.praiseSuccessBlock = ^(NSIndexPath *index) {
        [self updatePraiseCountWith:index];
    };
    [self.navigationController pushViewController:detail animated:YES];

}

#pragma mark - 删除该相册
- (void)deleteClickWith:(NSIndexPath *)indexPath
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
    GroupPhotoAlumListModel *model = self.dataSource[indexPath.row];
    NSDictionary *params = @{@"action" : @"DeleteAlbum",
                             @"album_id" : model.albumnId,
                             @"user_id" : kShareModel.userId,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@---%@",json,json[@"info"]);
        if ([json[@"status"] integerValue] == 0) {
            [self.dataSource removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            //从本地数据库中删除
            [[MTTDatabaseUtil instance] deleteAlbum:model.albumnId];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 对相册进行点赞
- (void)praiseClickWith:(NSIndexPath *)indexPath
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
    GroupPhotoAlumListModel *model = self.dataSource[indexPath.row];
    NSDictionary *params = @{@"action" : @"ClickPraise",
                             @"album_id" : model.albumnId,
                             @"user_id" : kShareModel.userId,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@---%@",json,json[@"info"]);
        [self updatePraiseCountWith:indexPath];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 更新出3条最新的赞
- (void)updatePraiseCountWith:(NSIndexPath *)indexPath
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
    GroupPhotoAlumListModel *model = self.dataSource[indexPath.row];
    NSDictionary *params = @{@"action" : @"Top3priseuserlist",
                             @"album_id" : model.albumnId,
                             @"user_id" : kShareModel.userId,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password};
   [WPHttpTool postWithURL:url params:params success:^(id json) {
       NSLog(@"%@",json);
       GroupPhotoAlumModel *alumModel = [GroupPhotoAlumModel mj_objectWithKeyValues:json];
       GroupPhotoAlumListModel *newModel = alumModel.list[0];
       model.myPraise = newModel.myPraise;
       model.praiseCount = newModel.praiseCount;
       model.PraiseList = newModel.PraiseList;
       [self.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
       [self.tableView reloadData];
   } failure:^(NSError *error) {
       
   }];
}

#pragma mark - 更新出最新的评论
- (void)updateCommentCountWith:(NSIndexPath *)indexPath
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
    GroupPhotoAlumListModel *model = self.dataSource[indexPath.row];
    NSDictionary *params = @{@"action" : @"Top6discussuserlist",
                             @"album_id" : model.albumnId,
                             @"user_id" : kShareModel.userId,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        GroupPhotoAlumModel *alumModel = [GroupPhotoAlumModel mj_objectWithKeyValues:json];
        GroupPhotoAlumListModel *newModel = alumModel.list[0];
        model.commentCount = newModel.commentCount;
        model.CommentList = newModel.CommentList;
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
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

#pragma mark - 发送评论消息
- (void)sendCommentMessage:(id)obj
{
    
//    WPShareModel *model = [WPShareModel sharedModel];
//    NSMutableDictionary *myDic = model.dic;
    GroupPhotoAlumListModel *dic = self.dataSource[_selectedIndexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"AddComment";
    params[@"album_id"] = dic.albumnId;
    params[@"username"] = kShareModel.username;
    params[@"password"] = kShareModel.password;
    params[@"user_id"] = kShareModel.userId;
    //    params[@"nick_name"] = myDic[@"nick_name"];
    params[@"commentContent"] = obj;
    params[@"Replay_commentID"] = self.Replay_commentID;
    params[@"replay_user_id"] = self.replay_user_id;
    NSLog(@"****%@",params);
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
    
    //    NSLog(@"####%@",url);
    
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        if ([json[@"status"] integerValue] == 0) {
//            self.model;
            [self updateCommentCountWith:_selectedIndexPath];
//            [self sendGroupAblumMessage:dic.albumnId andAvatar:@"" andStr:obj];
           // self.replay_user_id = @"";
           // self.Replay_commentID = @"";
            
        }
        if (self.model.PhotoList.count) {
             GroupPhotoListModel * photoListModel = [GroupPhotoListModel new];
             photoListModel = self.model.PhotoList[0];
            [self sendGroupAblumMessage:dic.albumnId andAvatar:photoListModel.thumb_path andStr:obj];
        }

        
//        if (self.isFromChat||self.isNeedChat ||self.isFromAlbumNoti)
//        {
//            GroupPhotoListModel * photoListModel = [GroupPhotoListModel new];
//            if (self.info.PhotoList.count) {
//                photoListModel = self.info.PhotoList[0];
//            }
//            [self sendGroupAblumMessage:self.albumId andAvatar:photoListModel.thumb_path andStr:obj];
//        }
        
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
    // 键盘隐藏
    [self keyBoardDismiss];
    
    
    
    
}
-(void)sendGroupAblumMessage:(NSString*)ablumId andAvatar:(NSString*)avatar andStr:(NSString*)string
{
    
    GroupPhotoAlumListModel *dic = self.dataSource[_selectedIndexPath.row];
    [[DDGroupModule instance] getGroupInfogroupID:[NSString stringWithFormat:@"group_%@",self.groupId] completion:^(MTTGroupEntity *group) {//groupId
        MTTSessionEntity * session = [[SessionModule instance] getSessionById:group.objID];
        if (!session)
        {//不存在时要创建
            session = [[MTTSessionEntity alloc]initWithSessionID:group.objID type:SessionTypeSessionTypeGroup];
            [[SessionModule instance] addToSessionModel:session];
            [[MTTDatabaseUtil instance] updateRecentSession:session completion:^(NSError *error) {
            }];
        }
        ChattingModule*mouble = [[ChattingModule alloc] init];
        mouble.MTTSessionEntity = session;
        DDMessageContentType msgContentType = DDMEssageLitteralbume;
        
        NSString * textStr = [NSString string];
        textStr = string;
        
        NSString *nameStr = dic.user_name;
        NSString *nameStr1 = [nameStr stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
        NSString *nameStr2 = [nameStr1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
        NSString *description = dic.remark;
        //        NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
        //        NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
        //        NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
        //        NSString *lastDestription = [WPMySecurities textFromEmojiString:description3];
        NSString *description1 = [WPMySecurities textFromBase64String:description];
        NSString *lastDestription = [WPMySecurities textFromEmojiString:description1];
        //评论
        NSString * titleString = [NSString string];
        NSString * infoString = [NSString string];
        NSString * session_info = [NSString string];

        //之前内容
//        if (!self.isTopic)
//        {
//            titleString = [NSString stringWithFormat:@"评论：%@",textStr];
//            infoString = [NSString stringWithFormat:@"%@：%@",nameStr2,lastDestription.length?lastDestription:@"[图片]"];
//            session_info = @"评论了群相册";//[NSString stringWithFormat:@"%@:评论了群相册",kShareModel.nick_name];
//        }
//        else//回复
//        {
//            titleString = [NSString stringWithFormat:@"回复%@：%@",self.replay_nick_name,textStr];
//            infoString =  [NSString stringWithFormat:@"%@：%@",self.replay_nick_name,string];
//            session_info = [NSString stringWithFormat:@"回复了%@的评论",self.replay_nick_name];
//        }
        
        if (self.isTopic)
        {
            titleString = [NSString stringWithFormat:@"回复%@：%@",self.replay_nick_name,textStr];
            infoString = [NSString stringWithFormat:@"%@", lastDestription.length?lastDestription:@"[图片]"];
            // infoString =  [NSString stringWithFormat:@"%@：%@",self.replay_nick_name,self.replay_comment];
            session_info = [NSString stringWithFormat:@"回复了%@的评论",self.replay_nick_name];

        }
        else//回复
        {
            titleString = [NSString stringWithFormat:@"评论：%@",textStr];
            // infoString = [NSString stringWithFormat:@"%@：%@",nameStr2,lastDestription.length?lastDestription:@"[图片]"];
            infoString = [NSString stringWithFormat:@"%@", lastDestription.length?lastDestription:@"[图片]"];
            session_info = @"评论了群相册";//[NSString stringWithFormat:@"%@:评论了群相册",kShareModel.nick_name];
        }
        
        [self hideView];
        [self keyBoardDismiss];
        self.replay_user_id = dic.created_user_id;
        NSDictionary * dictionary = @{@"display_type":@"13",@"content":@{@"from_type":@"1",
                                                                         @"from_title":titleString,//[NSString stringWithFormat:@"评论:%@",textStr]
                                                                         @"from_info":infoString,//[NSString stringWithFormat:@"%@:%@",nameStr2,lastDestription]
                                                                         @"from_qun_id":_model.group_id,
                                                                         @"from_g_id":self.groupId,
                                                                         @"from_id":ablumId,
                                                                         @"from_avatar":avatar,
                                                                         @"session_info":session_info
                                                                         }};
        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:self.mouble?self.mouble:mouble MsgType:msgContentType];
        [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SENDARGUMENTSUCCESS" object:message];
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        message.msgContent = contentStr;
        [[DDMessageSendManager instance] sendMessage:message isGroup:YES Session:session  completion:^(MTTMessageEntity* theMessage,NSError *error) {
        } Error:^(NSError *error) {
            [self.tableView reloadData];
        }];
    }];
}
#pragma mark ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self keyBoardDismiss];
    [self hideView];
}
-(void)hideView{
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:2 inSection:3];
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
