//
//  WPGroupAlumDetailViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/4/29.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGroupAlumDetailViewController.h"
#import "YYShareManager.h"
#import "GroupPhotoAlumCell.h"
#import "GroupAlumDetailScanCell.h"
#import "GroupAlumDetailCommentCell.h"
#import "IQKeyboardManager.h"
#import "UIMessageInputView.h"
#import "HJCActionSheet.h"
#import "RKAlertView.h"
#import "ReportViewController.h"
#import "CollectViewController.h"
#import "PersonalInfoViewController.h"
#import "HCInputBar.h"
#import "WPMySecurities.h"
#import "DDGroupModule.h"
#import "MTTSessionEntity.h"
#import "SessionModule.h"
#import "MTTDatabaseUtil.h"
#import "ChattingModule.h"
#import "MTTMessageEntity.h"
#import "DDMessageSendManager.h"
#import "GroupAlbumCommentAndPraise.h"
@interface WPGroupAlumDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIMessageInputViewDelegate,HJCActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *segTitleView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSMutableArray *segTitles;
@property (nonatomic, strong) NSString *scanCount;  //浏览数量
@property (nonatomic, strong) NSString *commentCount;//评论数量
@property (nonatomic, strong) NSString *praiseCount; //赞的数量
@property (nonatomic, strong) NSArray *actions;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) GroupPhotoAlumListModel *defualtModel;
//@property (nonatomic, assign) NSInteger currentIndex;     //当前页(0浏览，1评论，2赞)
/**评论 键盘 */
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
@property (nonatomic,assign) BOOL isEditeNow;            //是否正在编辑状态
@property (nonatomic,assign) BOOL isTopic;            //是否是评论相册
@property (nonatomic, strong) NSString *album_id;
@property (nonatomic, strong) NSString *Replay_commentID;
@property (nonatomic, strong) NSString *replay_user_id;
@property (nonatomic, strong) NSString *replay_nick_name;
@property (nonatomic, copy) NSString *replay_comment;
@property (nonatomic, strong) GroupAlumDetailCommentCell *cliclCell;
@property (nonatomic,assign) BOOL scrollToBottom;                //滚到最底部
@property (strong, nonatomic) HCInputBar *inputBar;


@end

@implementation WPGroupAlumDetailViewController
{
    NSInteger _page;
    BOOL _wasKeyboardManagerEnabled;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.isBack) {
        [MBProgressHUD createHUD:@"该群相册已被删除" View:self.view];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    
    
    // Do any additional setup after loading the view.
    [self initDataSource];
    [self initNav];
//    [self.tableView reloadData];

    [self loadData];

    
    [self.view addSubview:self.inputBar];
    //    self.inputBar.hidden = YES;
    //块传值
    __weak typeof(self) weakSelf = self;
    [_inputBar showInputViewContents:^(NSString *contents) {
        NSString * string = [NSString stringWithFormat:@"%@",contents];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (!string.length) {
            [MBProgressHUD createHUD:@"请输入内容" View:self.view];
            return ;
        }
        [weakSelf sendCommentMessage:contents];
    }];
    
    _inputBar.keyBoardHidden = ^(){
        [weakSelf keyBoardDismiss];
    };
    
//    if (self.isCommentFromDynamic) {
//        //        [_myMsgInputView notAndBecomeFirstResponder];
//        [_inputBar.inputView becomeFirstResponder];
//        self.isEditeNow = YES;
//    }
    if (self.isCommetFromAlum) {
        [_inputBar.inputView becomeFirstResponder];
        self.isEditeNow = YES;
    }
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[WPGroupAlumDetailViewController class]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 键盘 即将显示
//    if (_myMsgInputView) {
//        [_myMsgInputView prepareToShow];
//    }
//    if (self.isCommetFromAlum) {
//        [_myMsgInputView notAndBecomeFirstResponder];
//        self.isEditeNow = YES;
//    }
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self keyBoardDismiss];
//    [self.sheet hideFromView:self.view];
    // 键盘 隐藏
//    if (_myMsgInputView) {
//        [_myMsgInputView prepareToDismiss];
//    }
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

#pragma mark - 定于导航栏
- (void)initNav{
    self.title = @"详情";
    self.titleView= [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.titleView.titleString = @"详情";
    self.navigationItem.titleView = self.titleView;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

- (void)initDataSource
{
    _scanCount = @"浏览 0";
    _commentCount = @"评论 0";
    _praiseCount = @"赞 0";
    _actions = @[@"readuserlist",
                 @"discussuserlist",
                 @"priseuserlist"];
    _page = 1;
    _segTitles = [NSMutableArray array];
    self.isEditeNow = NO;
    self.scrollToBottom = NO;
    self.replay_nick_name = self.info.user_name;
    self.replay_user_id = self.info.created_user_id;
    self.album_id = self.info.albumnId;
    self.isTopic = YES;
}

- (void)rightBtnClick
{
//    [YYShareManager newShareWithTitle:@"这是title" url:nil action:^(YYShareManagerType type) {
//        if (type == YYShareManagerTypeWeiPinFriends)
//        {
//            NSLog(@"分享到微聘好友");
//        }
////        if (type == YYShareManagerTypeWorkLines) {
////            ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
////            share.shareInfo = self.defaultDataSource[0];
////            share.shareSuccessedBlock = ^(id json){
////            };
////            [self.navigationController pushViewController:share animated:YES];
////        }
//        if (type == YYShareManagerTypeCollect) {
//            [self performSelector:@selector(gotoCollect) withObject:nil afterDelay:0.2];
//        }
//        if (type == YYShareManagerTypeReport) {
//            [self performSelector:@selector(gotoReport) withObject:nil afterDelay:0.2];
//        }
//    } status:^(UMSResponseCode status) {
//        if (status == UMSResponseCodeSuccess) {
//            
//        }
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
        _inputBar.placeHolder = @"说点什么吧...";
        if (self.isFromAlbumNoti) {
            _inputBar.placeHolder = [NSString stringWithFormat:@"回复:%@",self.fromAlbumUserName];
            
            self.replay_user_id = self.fromAlbumUserId;
            self.replay_nick_name = self.fromAlbumUserName;
            self.Replay_commentID = self.fromAlbumCommentId;
            self.replay_comment = self.fromAlbumComment;
            self.isTopic = NO;
        }
        
    }
    return _inputBar;
}

- (void)gotoReport
{
    ReportViewController *report = [[ReportViewController alloc] init];
    report.speak_trends_id = self.info.albumnId;
    report.type = ReportTypeDynamice;
    [self.navigationController pushViewController:report animated:YES];
    
}

#pragma mark - 收藏
- (void)gotoCollect
{
    CollectViewController *collect = [[CollectViewController alloc] init];
    collect.collect_class = @"9";
    NSMutableArray *arr = [NSMutableArray array];
    for (GroupPhotoListModel *model in self.info.PhotoList) {
        [arr addObject:model.thumb_path];
    }
    NSString *imgurl = [arr componentsJoinedByString:@","];
    collect.img_url = imgurl;
    collect.content = self.info.remark;
    collect.jobid = self.info.albumnId;
    collect.user_id = self.info.created_user_id;
    collect.collectSuccessBlock = ^(){
        [MBProgressHUD createHUD:@"收藏成功" View:self.view];
    };
    [self.navigationController pushViewController:collect animated:YES];
}


#pragma mark - 请求默认数据
- (void)loadData
{
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"GetAlbumInfo";
    params[@"username"] = kShareModel.username;
    params[@"password"] = kShareModel.password;
    params[@"album_id"] = self.isFromChat?self.albumId:self.info.albumnId;
    params[@"user_id"] = kShareModel.userId;
    params[@"group_id"] = self.group_id;
    
    NSLog(@"****%@",params);
    [self.titleView.activity startAnimating];
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        [self.titleView.activity stopAnimating];
        NSLog(@"**%@",json);
        _defualtModel = [GroupPhotoAlumListModel mj_objectWithKeyValues:json];
        _data = [NSMutableArray arrayWithArray:_defualtModel.otherList];
        [self setupTitles];
    } failure:^(NSError *error) {
        [self.titleView.activity stopAnimating];
        [[MTTDatabaseUtil instance] getGroupAlbum:self.isFromChat?self.albumId:self.info.albumnId success:^(NSArray *array) {
            if (array.count) {
                NSDictionary * dic = array[0];
                 _defualtModel = [GroupPhotoAlumListModel mj_objectWithKeyValues:dic];
                _data = [NSMutableArray arrayWithArray:_defualtModel.CommentList];
                self.currentIndex = 1;
                [self setupTitles];
            }
        }];
    }];
    
}

#pragma mark - NetWork 网络请求
- (void)requsetWithPageIndex:(NSInteger)page url:(NSString *)url action:(NSString *)action Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = action;
    params[@"page"] = @(page);
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = kShareModel.userId;
    params[@"album_id"] = self.info.albumnId;
//        NSLog(@"*******%@",params);
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
                NSLog(@"******%@",json);
        GroupAlumDetailModel *model = [GroupAlumDetailModel mj_objectWithKeyValues:json];
        NSArray *arr = [[NSArray alloc] initWithArray:model.list];
        success(arr,(int)arr.count);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
    }];
    
}


#pragma 更新数量
- (void)setupTitles
{
    _scanCount = [NSString stringWithFormat:@"浏览  %@",self.defualtModel.browseCount?self.defualtModel.browseCount:@"0"];
    _commentCount = [NSString stringWithFormat:@"评论  %@",self.defualtModel.commentCount];
    _praiseCount = [NSString stringWithFormat:@"赞  %@",self.defualtModel.praiseCount];
    NSString *disType = self.defualtModel.disType;
    if (self.isCommetFromAlum) {
        self.currentIndex = 1;
        [self segTitleView];
        [self.tableView.mj_header beginRefreshing];
        
    } else {
        if (self.isFromAlbumNoti)
        {
            [self buttonClickRefresh];
        }
        else
        {
//            if ([disType isEqualToString:@"browse"]) { //浏览
//                self.currentIndex = 0;
//            } else if ([disType isEqualToString:@"discuss"]) { //评论
                self.currentIndex = 1;
//            } else if ([disType isEqualToString:@"praise"]) { //赞
//                self.currentIndex = 2;
//            }
            if (![disType isEqualToString:@"discuss"]) {
                [self.data removeAllObjects];
            }
        }
        [self.tableView reloadData];
    }
    [self.view bringSubviewToFront:self.inputBar];
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(64);
            make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        }];
        
        __weak typeof(self) unself = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.titleView.activity startAnimating];
            [unself.tableView.mj_footer resetNoMoreData];
            _page = 1;
            [unself requsetWithPageIndex:_page url:nil action:_actions[self.currentIndex] Success:^(NSArray *datas, int more) {
                [self.titleView.activity stopAnimating];
                [self.data removeAllObjects];
                GroupAlumDetailListModel *model = datas[0];
                [self.data addObjectsFromArray:model.otherList];
                [unself.tableView reloadData];
                if (self.currentIndex == 1) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } Error:^(NSError *error) {
                [self.titleView.activity stopAnimating];
            }];
            
            [_tableView.mj_header endRefreshing];
            [self updateAllCount];
            [self performSelector:@selector(scrollBottom) afterDelay:0.5];
            
        }];
        
//        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            _page++;
//            if (self.currentIndex == 1){
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                return ;
//            }
//            
//            [unself requsetWithPageIndex:_page url:nil action:_actions[self.currentIndex] Success:^(NSArray *datas, int more) {
//                    GroupAlumDetailListModel *model = datas[0];
//                if (model.otherList.count == 0) {
//                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                } else {
//                    [self.data addObjectsFromArray:model.otherList];
//                }
//
//                [unself.tableView reloadData];
//            } Error:^(NSError *error) {
//                _page--;
//            }];
//            [_tableView.mj_footer endRefreshing];
//        }];
        
    }
    return _tableView;
}

- (void)scrollBottom
{
    if (self.currentIndex != 1) {
        return;
    }
    if (self.scrollToBottom) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:self.data.count - 1 inSection:1];
        [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
        self.scrollToBottom = NO;
    }
    
}


- (UIView *)segTitleView
{
    if (!_segTitleView) {
        _segTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(36))];
        NSArray *titles = @[_scanCount,_commentCount,_praiseCount];
        UIView *lastView = nil;
        for (int i = 0; i < titles.count; i++) {
            UIButton *button = [UIButton new];
            button.tag = 233+i;
            button.titleLabel.font = kFONT(12);
            button.selected = (self.currentIndex == i)?YES:NO;
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
            [button setTitleColor:AttributedColor forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(viewForHeaderInSectionActions:) forControlEvents:UIControlEventTouchUpInside];
            [_segTitleView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_segTitleView);
                make.left.equalTo((lastView?lastView.mas_right:_segTitleView.mas_left));
                make.width.equalTo(_segTitleView).dividedBy(3);
                make.bottom.equalTo(_segTitleView);
            }];
            [self.segTitles addObject:button];
            lastView = button;
        }
        
        UILabel *blueLine = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*((titles.count == 3)?1:2)/3, _segTitleView.height-2, SCREEN_WIDTH/3, 2)];
        blueLine.backgroundColor = AttributedColor;
        blueLine.tag = 2333;
        [_segTitleView addSubview:blueLine];
        
        UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, _segTitleView.height-0.5, SCREEN_WIDTH, 0.5)];
        line2.backgroundColor = RGB(226, 226, 226);
        [_segTitleView addSubview:line2];
    }
    return _segTitleView;
}

- (void)viewForHeaderInSectionActions:(UIButton *)sender{
//    [self keyBoardDismiss];
    self.currentIndex = sender.tag-233;
//        [self.tableView.mj_header beginRefreshing];
    [self buttonClickRefresh];
    //_selectedButtonTag = sender.tag;
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:233+i];
        button.selected = button.tag == sender.tag?YES:NO;
    }
    
    UILabel *blueLine = (UILabel *)[self.view viewWithTag:2333];
    blueLine.left = self.currentIndex*SCREEN_WIDTH/3;
    
}

#pragma mark 点击浏览评论赞时请求数据
- (void)buttonClickRefresh
{
    //    if (self.currentIndex == 3) {
    //        [self updateCountIsPraise:YES];
    //    } else {
//    [self updateCountIsPraise:NO];
    //    }
    [self updateAllCount];
    [self.tableView.mj_footer resetNoMoreData];
    WPShareModel *model = [WPShareModel sharedModel];
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = _actions[self.currentIndex];
    params[@"page"] = @"1";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"album_id"] = self.info.albumnId;
    params[@"user_id"] = kShareModel.userId;
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        GroupAlumDetailModel *detailModel = [GroupAlumDetailModel mj_objectWithKeyValues:json];
        GroupAlumDetailListModel *model = detailModel.list[0];
        for (otherListModel * listmodel in model.otherList) {
            listmodel.comment_content.length?0:(listmodel.comment_content = @"");
        }
        
        [self.data removeAllObjects];
        [self.data addObjectsFromArray:model.otherList];
        [self.tableView reloadData];
        if (self.isFromAlbumNoti) {//跳到指定的位子otherListModel
            for (int i = 0; i < self.data.count; i++) {
                otherListModel* model = self.data[i];
                if ([model.comment_id isEqualToString:self.scrollerStr]) {
                    NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:1];
                    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD createHUD:@"网络错误,请稍后重试" View:self.view];
        [self.data removeAllObjects];
        if (self.currentIndex == 1) {
            [[MTTDatabaseUtil instance] getGroupAlbum:self.info.albumnId success:^(NSArray *array) {
                if (array.count) {
                    NSDictionary * dic = array[0];
                    _data = [NSMutableArray arrayWithArray:_defualtModel.CommentList];
                    self.currentIndex = 1;
                    [self setupTitles];
                    [self.tableView reloadData];
                }
            }];
        }
        else
        {
             [self.tableView reloadData];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else {
        return _data.count;
    }
}
-(void)hideView{
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self hideBackView:indexpath];
}
-(void)hideBackView:(NSIndexPath*)indexPath
{
        GroupPhotoAlumCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GroupPhotoAlumCell *cell = [GroupPhotoAlumCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isDetail = YES;
//        cell.isFromColume = YES;
        cell.isOwner = self.isOwner;
        cell.indexPath = indexPath;
        cell.isDetailInfo = YES;
        cell.dic = self.defualtModel;
        
        cell.praiseActionBlock = ^(NSIndexPath *index){
            [self praiseClickWith:index];
        };
        
        
        cell.clickTwoBtn = ^(NSIndexPath*index){
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self hideBackView:indexpath];
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
        
        
        cell.deleteActionBlock = ^(NSIndexPath *index){
            [RKAlertView showAlertWithTitle:@"提示" message:@"你确定要删除该条群说说吗？" cancelTitle:@"取消" confirmTitle:@"确定" confrimBlock:^(UIAlertView *alertView) {
                [self deleteClickWith:index];
            } cancelBlock:^{
                
            }];
        };
        cell.commentActionBlock = ^(NSIndexPath *index){
//            [_myMsgInputView notAndBecomeFirstResponder];
            [_inputBar.inputView becomeFirstResponder];
            self.isEditeNow = YES;
        };
        cell.checkActionBlock = ^(NSIndexPath *index){
            PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
            info.friendID = self.info.created_user_id;
            [self.navigationController pushViewController:info animated:YES];
        };

        return cell;
    } else {
        if (self.currentIndex != 1) {
            GroupAlumDetailScanCell *cell = [GroupAlumDetailScanCell cellWithTableView:tableView];
            cell.dic = self.data[indexPath.row];
            return cell;
        } else {
            GroupAlumDetailCommentCell *cell = [GroupAlumDetailCommentCell cellWithTableView:tableView];
            cell.currentIndex = indexPath;
            cell.dic = self.data[indexPath.row];
            UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            recognizer.minimumPressDuration = 0.5;
            [cell addGestureRecognizer:recognizer];
            cell.iconClickBlock = ^(NSIndexPath *index){
                PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
                info.friendID = [self.data[indexPath.row] created_user_id];
                [self.navigationController pushViewController:info animated:YES];
            };
            
            cell.nickNameClickBlock = ^(NSIndexPath *index) {
                PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
                info.friendID = [self.data[indexPath.row] replay_user_id];
                [self.navigationController pushViewController:info animated:YES];
            };
            return cell;
        }
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        GroupAlumDetailCommentCell *cell = (GroupAlumDetailCommentCell *)recognizer.view;
        self.cliclCell = cell;
        [cell becomeFirstResponder];
        cell.backgroundColor = RGB(226, 226, 226);
        
        UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(flag:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        [menu setMenuItems:[NSArray arrayWithObjects:flag, nil]];
        [menu setTargetRect:cell.frame inView:cell.superview];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)flag:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSIndexPath *index = [self.tableView indexPathForCell:self.cliclCell];
    pasteboard.string = [WPMySecurities textFromEmojiString:[self.data[index.row] comment_content]];
}

-(void)WillHideMenu:(id)sender
{
    self.cliclCell.backgroundColor = [UIColor whiteColor];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [GroupPhotoAlumCell calculateHeightWithInfo:self.info isDetail:YES];
    } else {
        if (self.currentIndex !=1) {
            return kHEIGHT(50);
        } else {
            return [GroupAlumDetailCommentCell cellHeightWith:self.data[indexPath.row]];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return self.segTitleView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    } else {
        return kHEIGHT(36);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideView];
    [self keyBoardDismiss];
    //    NSLog(@"****");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.currentIndex != 1) {
        if (indexPath.section != 0) {
            PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
            info.friendID = [self.data[indexPath.row] created_user_id];
            [self.navigationController pushViewController:info animated:YES];
        } else {
            if (self.isEditeNow) {
                [self keyBoardDismiss];
                return;
            }
        }
    } else {
        if (indexPath.section != 0) {
            
            NSString *userid = kShareModel.userId;
            otherListModel *model = self.data[indexPath.row];
            NSString *user_id = model.created_user_id;
            if ([userid isEqualToString:user_id]) {
                if (self.isEditeNow) {
                    [self keyBoardDismiss];
                    return;
                }
                HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"删除", nil];
                self.Replay_commentID = model.comment_id;
//                self.selectedIndexPath = indexPath;
                // 2.显示出来
                [sheet show];
                
            } else {
                if (self.isEditeNow) {
                    [self keyBoardDismiss];
                    return;
                }
                self.replay_user_id = model.created_user_id;
                self.replay_nick_name = model.created_nick_name;
                self.Replay_commentID = model.comment_id;
                self.replay_comment = model.comment_content;
                self.isTopic = NO;
//                _myMsgInputView.placeHolder = [NSString stringWithFormat:@"回复%@：",model.created_nick_name];
//                [_myMsgInputView notAndBecomeFirstResponder];
                _inputBar.placeHolder = [NSString stringWithFormat:@"回复%@：",model.created_nick_name];
                [_inputBar.inputView becomeFirstResponder];
                self.isEditeNow = YES;
            }
        }
    }
}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
//    GroupPhotoAlumListModel *dic = self.dataSource[_selectedIndexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"DelComment";
    params[@"album_id"] = self.album_id;
    params[@"username"] = kShareModel.username;
    params[@"password"] = kShareModel.password;
    params[@"user_id"] = kShareModel.userId;
    params[@"comment_id"] = self.Replay_commentID;
    //    params[@"user_id"] = myDic[@"userid"];
    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@--%@",json,json[@"info"]);
//        [self updateCommentCountWith:_selectedIndexPath];
        [self updateAllCount];
        if (self.currentIndex == 1) {
            [self.tableView.mj_header beginRefreshing];
        }
        if (self.commentSuccessBlock) {
            self.commentSuccessBlock(self.currentIndexPath);
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}


#pragma mark - 对相册进行点赞
- (void)praiseClickWith:(NSIndexPath *)indexPath
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
    NSDictionary *params = @{@"action" : @"ClickPraise",
                             @"album_id" : self.info.albumnId,
                             @"user_id" : kShareModel.userId,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        [self updateAllCount];
        if (self.currentIndex == 2) {
            
//            [self.tableView.mj_header beginRefreshing];
            
            [self requsetWithPageIndex:_page url:nil action:_actions[self.currentIndex] Success:^(NSArray *datas, int more) {
                [self.data removeAllObjects];
                GroupAlumDetailListModel *model = datas[0];
                [self.data addObjectsFromArray:model.otherList];
                [self.tableView reloadData];
            } Error:^(NSError *error) {
            }];
            [self updateAllCount];
            [self performSelector:@selector(scrollBottom) afterDelay:0.5];
            
            
            
        }
        if (self.praiseSuccessBlock) {
            self.praiseSuccessBlock(self.currentIndexPath);
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 删除该相册
- (void)deleteClickWith:(NSIndexPath *)indexPath
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
//    GroupPhotoAlumListModel *model = self.dataSource[indexPath.row];
    NSDictionary *params = @{@"action" : @"DeleteAlbum",
                             @"album_id" : self.info.albumnId,
                             @"user_id" : kShareModel.userId,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password};
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        //        NSLog(@"%@---%@",json,json[@"info"]);
        if ([json[@"status"] integerValue] == 0) {
            
            //从本地数据库中删除
            [[MTTDatabaseUtil instance] deleteAlbum:self.info.albumnId];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.deleteSuccessBlock) {
                self.deleteSuccessBlock(self.currentIndexPath);
            }
        }
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"AddComment";
    params[@"album_id"] = self.album_id;
    params[@"username"] = kShareModel.username;
    params[@"password"] = kShareModel.password;
    params[@"user_id"] = kShareModel.userId;
    params[@"commentContent"] = obj;
    if (self.isTopic) {
        params[@"Replay_commentID"] = @"0";
    } else {
        params[@"Replay_commentID"] = self.Replay_commentID;
    }
    params[@"replay_user_id"] = self.replay_user_id;
    NSLog(@"****%@",params);
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
    
    //    NSLog(@"####%@",url);
    
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"json: %@---%@",json,json[@"info"]);
        if ([json[@"status"] integerValue] == 0) {
            [self updateAllCount];
            self.currentIndex = 1;
            
            for (int i = 0; i < 3; i++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:233+i];
                button.selected = button.tag == 233 + self.currentIndex?YES:NO;
            }
            
            UILabel *blueLine = (UILabel *)[self.view viewWithTag:2333];
            blueLine.left = self.currentIndex*SCREEN_WIDTH/3;
            
            if (self.currentIndex == 1) {
                self.scrollToBottom = YES;
                
                NSDictionary *dictionary = [USER_DEFAULT objectForKey:@"LOGINUSERINFO"];
                NSDictionary * dic = @{@"avatar":dictionary[@"list"][0][@"avatar"],
                                       @"by_avatar":@"",@"by_company":@"",
                                       @"by_nick_name":self.replay_nick_name,@"by_position":@"",
                                       @"by_user_id":self.replay_user_id,
                                       @"company":dictionary[@"list"][0][@"company"],
                                       @"father_id":@"0",@"id":json[@"id"],
                                       @"created_nick_name":dictionary[@"list"][0][@"nick_name"],
                                       @"pos":@"",
                                       @"position":dictionary[@"list"][0][@"position"],
                                       @"post_remark":@"",
                                       @"post_remark2":@"",
                                       @"id":json[@"id"],
                                       @"add_time":@"1分钟前",
                                       @"comment_content":obj,
                                       @"speak_id":@"",
                                       @"speak_trends_person":@"",
                                       @"created_user_id":dictionary[@"list"][0][@"userid"],
                                       @"created_user_name":dictionary[@"list"][0][@"user_name"],
                                       @"file_id":@"",@"group_id":self.group_id,
                                       @"album_id":self.album_id,
                                       @"nick_name":dictionary[@"list"][0][@"nick_name"]};
                
                otherListModel*model = [otherListModel mj_objectWithKeyValues:dic];
                if (self.data.count) {
                    [self.data insertObject:model atIndex:self.data.count];
                }
                else
                {
                    [self.data addObject:model];
                }
                [self.tableView reloadData];
//                [self requsetWithPageIndex:_page url:nil action:_actions[self.currentIndex] Success:^(NSArray *datas, int more) {
//                    [self.data removeAllObjects];
//                    GroupAlumDetailListModel *model = datas[0];
//                    [self.data addObjectsFromArray:model.otherList];
//                    [self.tableView reloadData];
//                    if (self.currentIndex == 1) {
//                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                    }
//                } Error:^(NSError *error) {
//                }];
                [self updateAllCount];
                [self performSelector:@selector(scrollBottom) afterDelay:0.5];
            }
        }
        if (self.commentSuccessBlock) {
            self.commentSuccessBlock(self.currentIndexPath);
        }
        
        //发送消息成功
        if (self.isFromChat||self.isNeedChat ||self.isFromAlbumNoti)
        {
            GroupPhotoListModel * photoListModel = [GroupPhotoListModel new];
            if (self.info.PhotoList.count) {
                photoListModel = self.info.PhotoList[0];
            }
           [self sendGroupAblumMessage:self.albumId andAvatar:photoListModel.thumb_path andStr:obj];
        }
       
        
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
    // 键盘隐藏
//    [self keyBoardDismiss];
}

-(void)sendGroupAblumMessage:(NSString*)ablumId andAvatar:(NSString*)avatar andStr:(NSString*)string
{
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
        
      //  NSString *nameStr = self.info.user_name;
        //NSString *nameStr1 = [nameStr stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
        //NSString *nameStr2 = [nameStr1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
        NSString *description = self.info.remark;
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
        if (self.isTopic)
        {
            titleString = [NSString stringWithFormat:@"评论：%@",textStr];
           // infoString = [NSString stringWithFormat:@"%@：%@",nameStr2,lastDestription.length?lastDestription:@"[图片]"];
            infoString = [NSString stringWithFormat:@"%@", lastDestription.length?lastDestription:@"[图片]"];
            session_info = @"评论了群相册";//[NSString stringWithFormat:@"%@:评论了群相册",kShareModel.nick_name];
        }
        else//回复
        {
             titleString = [NSString stringWithFormat:@"回复%@：%@",self.replay_nick_name,textStr];
            infoString = [NSString stringWithFormat:@"%@", lastDestription.length?lastDestription:@"[图片]"];
            // infoString =  [NSString stringWithFormat:@"%@：%@",self.replay_nick_name,self.replay_comment];
            session_info = [NSString stringWithFormat:@"回复了%@的评论",self.replay_nick_name];
        }
        [self hideView];
        [self keyBoardDismiss];
         self.replay_user_id = self.info.created_user_id;
        NSDictionary * dictionary = @{@"display_type":@"13",@"content":@{@"from_type":@"1",
                                                                         @"from_title":titleString,//[NSString stringWithFormat:@"评论:%@",textStr]
                                                                         @"from_info":infoString,//[NSString stringWithFormat:@"%@:%@",nameStr2,lastDestription]
                                                                         @"from_qun_id":self.group_id,
                                                                         @"from_g_id":self.groupId,
                                                                         @"from_id":ablumId,
                                                                         @"from_avatar":avatar,
                                                                         @"session_info":session_info
                                                                         }};
        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        MTTMessageEntity *message = [MTTMessageEntity makeMessage:contentStr Module:mouble MsgType:msgContentType];
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
#pragma mark - 更新初中U出最新的额数据源
- (void)updateAllCount
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
    NSDictionary *params = @{@"action" : @"GetAlbumInfoCount",
                             @"group_id" : self.group_id,
                             @"user_id" : kShareModel.userId,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"album_id" : self.info.albumnId};
//    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@",json);
        GroupPhotoAlumModel *model = [GroupPhotoAlumModel mj_objectWithKeyValues:json];
        GroupPhotoAlumListModel *newModel = model.list[0];
        _scanCount = [NSString stringWithFormat:@"浏览  %@",newModel.browseCount?newModel.browseCount:@"0"];
        _commentCount = [NSString stringWithFormat:@"评论  %@",newModel.commentCount];
        _praiseCount = [NSString stringWithFormat:@"赞  %@",newModel.praiseCount];
        NSArray *titles = @[_scanCount,_commentCount,_praiseCount];
        for (int i = 0; i<3; i++) {
            UIButton *btn = self.segTitles[i];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
        }
        self.defualtModel.commentCount = newModel.commentCount;
        self.defualtModel.praiseCount = newModel.praiseCount;
        self.defualtModel.myPraise = newModel.myPraise;
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 键盘消失
- (void)keyBoardDismiss
{
//    _myMsgInputView.placeHolder = @"说点什么吧...";
    self.replay_nick_name = self.info.user_name;
//    self.replay_user_id = self.info.created_user_id;
    self.album_id = self.info.albumnId;
    self.isTopic = YES;
//    [self.myMsgInputView isAndResignFirstResponder];
//    self.isEditeNow = NO;
    [_inputBar.inputView resignFirstResponder];
    _inputBar.keyboardTypeBtn.tag = 0;
    _inputBar.inputView.inputView = nil;
    [_inputBar.keyboardTypeBtn setImage:[UIImage imageNamed:@"common_biaoqing"] forState:UIControlStateNormal];
    _inputBar.placeHolder = @"说点什么吧...";
    [_inputBar.inputView reloadInputViews];
    _inputBar.inputView.text = @"";
    [_inputBar layout];
    self.isEditeNow = NO;

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self keyBoardDismiss];
    [self hideView];
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
