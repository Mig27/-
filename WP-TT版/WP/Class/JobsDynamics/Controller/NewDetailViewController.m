//
//  NewDetailViewController.m
//  WP
//
//  Created by 沈亮亮 on 16/2/24.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "NewDetailViewController.h"
#import "WorkTableViewCell.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "MJRefresh.h"
#import "DetailScanCell.h"
#import "CommentCell.h"
#import "UIButton+WebCache.h"
#import "IQKeyboardManager.h"
#import "UIMessageInputView.h"
#import "NewHomePageViewController.h"
#import "ShareEditeViewController.h"
#import "NewCommentCell.h"
#import "NewHomePageViewController.h"
#import "HJCActionSheet.h"
#import "WPActionSheet.h"
#import "ReportViewController.h"
#import "CollectViewController.h"
#import "YYShareManager.h"
#import "WPMySecurities.h"
#import "HCInputBar.h"
#import "RecentPersonController.h"
#import "ShareDetailController.h"
#import "NearInterViewController.h"
#import "ChattingMainViewController.h"
#import "WPThreeBackView.h"
#import "WPRecentLinkManController.h"
#import "SessionModule.h"
#import "MLPhotoBrowserPhoto.h"
#import "WPSendToFriends.h"
#import "MTTDatabaseUtil.h"
#import "PersonalInfoViewController.h"
#import "MTTDatabaseUtil.h"
@interface NewDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIMessageInputViewDelegate,HJCActionSheetDelegate,WPActionSheet,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isMore;                //是否有显示更多
@property (nonatomic, strong) NSMutableArray *scanData;   //浏览
@property (nonatomic, strong) NSMutableArray *shareData;  //分享
@property (nonatomic, strong) NSMutableArray *commentData;//评论
@property (nonatomic, strong) NSMutableArray *praiseData; //赞
@property (nonatomic, strong) NSMutableArray *data;       //当前显示的数据
@property (nonatomic, strong) NSMutableArray *dataSources;//所以的数据
@property (nonatomic, assign) CGFloat scanOff_Y;          //浏览的偏移量
@property (nonatomic, assign) CGFloat shareOff_Y;         //分享的偏移量
@property (nonatomic, assign) CGFloat commentOff_Y;       //评论的偏移量
@property (nonatomic, assign) CGFloat praiseOff_Y;        //赞的偏移量
@property (nonatomic, strong) NSMutableArray *offSets;    //所有的偏移量
@property (nonatomic, strong) NSMutableArray *pages;      //不同页数的当前页
@property (nonatomic, assign) NSInteger currentIndex;     //当前页(0浏览，1分享，2评论，3赞)
@property (nonatomic, strong) NSMutableArray *actions;    //所有界面请求的action
@property (nonatomic, strong) NSDictionary *defaultInfo;  //默认信息
@property (nonatomic, strong) NSMutableArray *defaultDataSource; //默认数据
@property (nonatomic, strong) UIView *segTitleView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSMutableArray *segTitles;
@property (nonatomic, strong) NSString *scanCount;  //浏览数量
@property (nonatomic, strong) NSString *shareCount; //分享数量
@property (nonatomic, strong) NSString *commentCount;//评论数量
@property (nonatomic, strong) NSString *praiseCount; //赞的数量
@property (nonatomic,strong) NSMutableDictionary *deletParams;   //所要删除说说的参数
@property (nonatomic,assign) NSInteger deletIndex;               //所要删除说说的位置
@property (nonatomic, strong) NSMutableDictionary *commentParams;//所要评论的人的参数
@property (nonatomic,strong) NSString *by_reply_nickName;  //键盘的placehoder
@property (nonatomic,strong) NSString *by_reply_sid;     //被评论人的信息
@property (nonatomic,strong) NSString *discuss_id;       //评论的ID
@property (nonatomic,assign) BOOL isTopic;               //是否是动态
//@property (nonatomic, strong) NSString *by_user_id;      //被回复人的user_id
@property (nonatomic, strong) NSString *peplyId;         //当前评论的id
@property (nonatomic,assign) BOOL isEditeNow;            //是否正在编辑状态
@property (nonatomic,assign) BOOL isShow;                //正在显示
@property (nonatomic,assign) BOOL scrollToBottom;                //滚到最底部
@property (nonatomic,assign) BOOL hasJumped;                //是否已跳到指定位置
@property (nonatomic, strong) WPActionSheet *sheet;
/**选中cell的IndexPath 评论 */
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NewCommentCell *clickCell; /**< 长按的cell */
@property (nonatomic, assign) BOOL firstEnter;  /**< 第一次进入 */
@property (strong, nonatomic) HCInputBar *inputBar;
@property (nonatomic, strong) UIButton*rightButton;
@property (nonatomic, copy) NSString * conmentString;
@property (nonatomic, strong)NSIndexPath*deleteIndex;


@property (nonatomic,strong)NSMutableArray *browerArray;//浏览
@property (nonatomic, assign)BOOL isRequstBrowser;

@property (nonatomic,strong)NSMutableArray *shareArray;//分享
@property (nonatomic,assign)BOOL isRequstShare;

@property (nonatomic,strong)NSMutableArray *commentArray;//评论
@property (nonatomic,assign)BOOL isRequstComment;

@property (nonatomic,strong)NSMutableArray *praiseArray;//赞
@property (nonatomic,assign)BOOL isRequstPraise;

@end

@implementation NewDetailViewController
{
    NSInteger _page;
    NSInteger _page2;
    NSInteger _page3;
    NSInteger _page4;
    BOOL _wasKeyboardManagerEnabled;
}
-(NSMutableArray*)browerArray
{
    if (!_browerArray) {
        _browerArray = [NSMutableArray array];
    }
    return _browerArray;
}
-(NSMutableArray*)shareArray
{
    if (!_shareArray) {
        _shareArray = [NSMutableArray array];
    }
    return _shareArray;
}
-(NSMutableArray*)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}
-(NSMutableArray*)praiseArray
{
    if (!_praiseArray) {
        _praiseArray = [NSMutableArray array];
    }
    return _praiseArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDatasource];
    [self initNav];
    [self loadData];
    self.by_reply_nickName = self.info[@"nick_name"];
    self.by_reply_sid = self.info[@"user_id"];
    self.discuss_id = self.info[@"sid"];
    self.isTopic = YES;
    self.isEditeNow = NO;
    self.scrollToBottom = NO;
    self.hasJumped = NO;
    self.firstEnter = YES;

    
    UIWindow * win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:self.inputBar];
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
    if (self.isCommentFromDynamic) {
        [_inputBar.inputView becomeFirstResponder];
        self.isEditeNow = YES;
    }
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[NewDetailViewController class]];
    if (self.isFromCollection) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToNextView:) name:@"resumeJumpToDynamic" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToDetail:) name:@"shareJump" object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideView) name:@"HIDETHREEVIEW" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideThreeButton:) name:@"hideThreeButton" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"reloadShuoShuo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendSuccess) name:@"sendToFriendSuccess" object:nil];
    
}
-(void)sendSuccess
{
    [self updateCountIsPraise:NO];
    if (self.currentIndex == 1) {
        [self refreshHead];
    }
    if (self.shareSuccessBlock) {
        self.shareSuccessBlock(self.clickIndex,self.info[@"sid"]);
    }
}

#pragma mark -- 这个地方的刷新还是存在问题,回收图片的时候,会有frame 的乱跑的情况发生,要在修
-(void)reloadData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view.layer removeAllAnimations];
        [self.tableView reloadData];
    });
}
-(void)hideThreeButton:(NSNotification*)noti
{
  [self hideView];
}
#pragma mark发送图片给朋友
-(void)sendPhotoToFrineds:(NSNotification*)notification
{//info
    
    NSDictionary * dictionary = (NSDictionary*)notification.userInfo;
    MLPhotoBrowserPhoto * photo = dictionary[@"info"];
    NSString * photoUrl = [NSString stringWithFormat:@"%@",photo.photoURL];
    photoUrl = [NSString stringWithFormat:@"%@%@",DD_MESSAGE_IMAGE_PREFIX,photoUrl];
    photoUrl = [NSString stringWithFormat:@"%@%@",photoUrl,DD_MESSAGE_IMAGE_SUFFIX];
    [self tranmitMessage:photoUrl andMessageType:DDMessageTypeImage andToUserId:@""];
    
    
}
-(void)jumpToDetail:(NSNotification*)notification
{
    NSArray *arr1 = [notification.userInfo[@"url"] componentsSeparatedByString:@"?"];
    
    
    NSArray *arr2 = [NSArray array];
    NSArray *typeArr = [NSArray array];
    NSArray *userArr = [NSArray array];
    if (arr1.count > 1)
    {
        arr2 = [arr1[1] componentsSeparatedByString:@"&"];
        typeArr = [arr2[0] componentsSeparatedByString:@"="];
        userArr = [arr2[1] componentsSeparatedByString:@"="];
    }
    else
    {
    }
//    NSArray *arr2 = [arr1[1] componentsSeparatedByString:@"&"];
//    NSArray *typeArr = [arr2[0] componentsSeparatedByString:@"="];
//    NSArray *userArr = [arr2[1] componentsSeparatedByString:@"="];
    //    NSLog(@"%@-----%@",typeArr,userArr);
    NearInterViewController *inter = [[NearInterViewController alloc] init];
    inter.subId = typeArr[1];
    inter.userId = userArr[1];
    inter.urlStr = [IPADDRESS stringByAppendingString:notification.userInfo[@"url"]];
    inter.isRecuilist = [typeArr[0] isEqualToString:@"recruit_id"] ? 1 : 0;
    inter.isSelf = [userArr[1] isEqualToString:kShareModel.userId] ? YES : NO;
    inter.isComeFromDynamic = YES;
    [self.navigationController pushViewController:inter animated:YES];
}

#pragma mark 从收藏中来点击是跳到下一个界面
-(void)jumpToNextView:(NSNotification*)notification
{
    [self hideView];
    [self keyBoardDismiss];
    NewDetailViewController *detail = [[NewDetailViewController alloc] init];
    detail.info = @{@"sid" : notification.userInfo[@"sid"],
                    @"nick_name" : notification.userInfo[@"nick_name"]};
    detail.isCommentFromDynamic = NO;
    detail.clickIndex = notification.userInfo[@"index"];
    detail.isCommentFromDynamic = NO;
//        detail.deleteSuccessBlock = ^(NSIndexPath *index){
//            //        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
//            //        [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
//            [self.dataSource removeObjectAtIndex:index.row];
//            [self.tableView reloadData];
//        };
//    detail.praiseSuccessBlock = ^(NSIndexPath *index,NSString *sid) {
//        for (int i = 0; i<self.dataSource.count; i++) {
//            NSDictionary *dict = self.dataSource[i];
//            if ([sid isEqualToString:dict[@"sid"]]) {
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                [self updatePraiseWithIndex:indexPath];
//            }
//        }
//    };
//    detail.commentSuccessBlock = ^(NSIndexPath *index,NSString *sid) {
//        for (int i = 0; i<self.dataSources.count; i++) {
//            NSDictionary *dict = self.dataSources[i];
//            if ([sid isEqualToString:dict[@"sid"]]) {
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                [self updateDiscussCountWithIndex:indexPath];
//            }
//        }
//    };
//    detail.shareSuccessBlock = ^(NSIndexPath *index,NSString *sid) {
//        for (int i = 0; i<self.dataSources.count; i++) {
//            NSDictionary *dict = self.dataSources[i];
//            if ([sid isEqualToString:dict[@"sid"]]) {
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                [self updateShareCountWithIndex:indexPath];
//            }
//        }
//    };
//    
    [self.navigationController pushViewController:detail animated:YES];

}
- (void)messageTip
{
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.inputBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
   
    self.inputBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self keyBoardDismiss];
    //[self hideView];
    [self.sheet hideFromView:self.view];
    // 键盘 隐藏
//    if (_myMsgInputView) {
//        [_myMsgInputView prepareToDismiss];
//    }
    self.isEditeNow = NO;
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];

    self.inputBar.hidden = YES;
    
//    [self.inputBar removeFromSuperview];
//    
//    UIWindow * win = [UIApplication sharedApplication].keyWindow;
//    BOOL isOrNot = NO;
//    for (UIView * view in win.subviews) {
//        if ([view isKindOfClass:[HCInputBar class]]) {
//            isOrNot = YES;
//        }
//    }
//    
//    if (isOrNot) {
//        NSLog(@"还有啊");
//    }
    
}

//- (void)willMoveToParentViewController:(UIViewController *)parent
//{
//    if (self.firstEnter) {
//        NSLog(@"出去");
//        [self keyBoardDismiss];
//        [self.sheet hideFromView:self.view];
//        // 键盘 隐藏
//        if (_myMsgInputView) {
//            [_myMsgInputView prepareToDismiss];
//        }
//        self.isEditeNow = NO;
//        [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
//        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
//
//    } else {
//        NSLog(@"进来");
//    }
//}


#pragma mark - 初始化数据源
- (void)initDatasource
{
    NSArray *actions = @[@"readuserlist",
                         @"shareuserlist",
                         @"discussuserlist",
                         @"priseuserlist"];
    _actions = [NSMutableArray arrayWithArray:actions];
    
    _scanData = [NSMutableArray array];
    _shareData = [NSMutableArray array];
    _commentData = [NSMutableArray array];
    _praiseData = [NSMutableArray array];
    self.dataSources = [[NSMutableArray alloc] initWithObjects:_scanData, _shareData, _commentData, _praiseData, nil];
//    _defaultDataSource = [NSMutableArray array];
    _segTitles = [NSMutableArray array];
    _scanCount = @"浏览 0";
    _shareCount = @"分享 0";
    _commentCount = @"评论 0";
    _praiseCount = @"赞 0";
    _page = 1;
}

#pragma mark - 定于导航栏
- (void)initNav{
   
//    self.title = @"详情";
    self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.titleView.titleString = @"详情";
    self.navigationItem.titleView = self.titleView;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.isFromChat?[[UIBarButtonItem alloc]initWithCustomView:self.rightButton]:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}
- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _rightButton.frame = CGRectMake(0, 0, 45, 45);
        _rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_rightButton setTitle:@"发送" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
#pragma mark 点击发送
-(void)rightBarButtonItemAction:(UIButton*)sender
{
    if (!self.chatDic) {
        return;
    }
    [self sendPersonDay:self.chatDic];
}
-(void)sendPersonDay:(NSDictionary*)dictionary
{
   NSString * classN = [NSString stringWithFormat:@"%@",dictionary[@"classN"]];
    NSDictionary * dic = [NSDictionary dictionary];
  if ([classN isEqualToString:@"7"])//链接
  {
      NSString * content = [NSString stringWithFormat:@"%@",dictionary[@"address"]];
      NSArray * contentArray = [content componentsSeparatedByString:@":"];
      
      NSString * name = [NSString stringWithFormat:@"%@",contentArray[0]];
      
      NSString * cont = [NSString string];
      NSString * string = [NSString string];
      if (contentArray.count > 2)
      {
          cont = [NSString stringWithFormat:@"%@",contentArray[2]];
          string = [NSString stringWithFormat:@"%@",contentArray[1]];
      }
      
      NSString * contentStr = [NSString string];
      
      if (cont.length)
      {
          contentStr = [NSString stringWithFormat:@"%@:%@",string,cont];
      }
      else
      {
          NSArray * url = dictionary[@"url"];
          NSString * small_address = [NSString stringWithFormat:@"%@",url[0][@"small_address"]];
          if ([small_address hasSuffix:@".mp4"]) {
              contentStr = [NSString stringWithFormat:@"%@:视频",contentArray[0]];
          }
          else
          {
              contentStr = [NSString stringWithFormat:@"%@:图片",contentArray[0]];
          }
      }
       dic = @{@"nick_name":[name length]?[NSString stringWithFormat:@"%@的%@",name,string]:@"",
                             @"shuoshuoid":[dictionary[@"jobid"] length]?dictionary[@"jobid"]:@"",
                             @"avatar":[dictionary[@"img_url"][0][@"small_address"] length]?[NSString stringWithFormat:@"%@%@",IPADDRESS,dictionary[@"img_url"][0][@"small_address"]]:@"",
                             @"message":contentStr.length?contentStr:@""};
  }
  else
  {
    
    NSString * share = [NSString stringWithFormat:@"%@",dictionary[@"share"]];
    NSString * content = [NSString stringWithFormat:@"%@",dictionary[@"content"]];
    NSArray * contentArray = [content componentsSeparatedByString:@":"];
    NSString * cont = [NSString stringWithFormat:@"%@",contentArray[1]];
    NSString *description1 = [WPMySecurities textFromBase64String:cont];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    NSString * contentStr = [NSString string];
    
    if (description3.length)
    {
        contentStr = [NSString stringWithFormat:@"%@:%@",contentArray[0],description3];
    }
    else
    {
        NSArray * url = dictionary[@"url"];
        NSString * small_address = [NSString stringWithFormat:@"%@",url[0][@"small_address"]];
        if ([small_address hasSuffix:@".mp4"]) {
            contentStr = [NSString stringWithFormat:@"%@:视频",contentArray[0]];
        }
        else
        {
            contentStr = [NSString stringWithFormat:@"%@:图片",contentArray[0]];
        }
    }
     dic = @{@"nick_name":[dictionary[@"nick_name"] length]?([share isEqualToString:@"0"]?[NSString stringWithFormat:@"%@的话题",dictionary[@"nick_name"]]:([share isEqualToString:@"1"]?[NSString stringWithFormat:@"%@分享的话题",dictionary[@"nick_name"]]:([share isEqualToString:@"2"]?[NSString stringWithFormat:@"%@分享的求职",dictionary[@"nick_name"]]:[NSString stringWithFormat:@"%@分享的招聘",dictionary[@"nick_name"]]))):@"",
                           @"shuoshuoid":[dictionary[@"jobid"] length]?dictionary[@"jobid"]:@"",
                           @"avatar":[dictionary[@"avatar"] length]?[NSString stringWithFormat:@"%@%@",IPADDRESS,dictionary[@"avatar"]]:@"",
                           @"message":contentStr.length?contentStr:@""};
    
//    NSArray * array = @[dic];
//    [[ChattingMainViewController shareInstance] sendPersonDay:array];
//    NSArray * viewArray = self.navigationController.viewControllers;
//    [self.navigationController popToViewController:viewArray[viewArray.count-4] animated:YES];
  }
    NSArray * array = @[dic];
    [[ChattingMainViewController shareInstance] sendPersonDay:array];
    NSArray * viewArray = self.navigationController.viewControllers;
    [self.navigationController popToViewController:viewArray[viewArray.count-4] animated:YES];
}
-(void)tranmitMessage:(NSString*)messageContent andMessageType:(DDMessageContentType)type andToUserId:(NSString*)userId
{//DDMessageTypeText
    
    WPRecentLinkManController * person = [[WPRecentLinkManController alloc]init];
    NSArray * array = [[SessionModule instance] getAllSessions];
    NSMutableArray * muarray = [NSMutableArray arrayWithArray:array];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
    NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
    
    person.dataSource = muarray;
    person.toUserId = userId;
    person.transStr = messageContent;
    switch (type) {
        case DDMessageTypeText:
            person.display_type = @"1";
            break;
        case DDMEssageMyWant:
            person.display_type = @"9";
            break;
        case DDMEssageMyApply:
            person.display_type = @"8";
            break;
        case DDMEssageSHuoShuo:
            person.display_type = @"11";
            break;
        case DDMessageTypeImage:
            person.display_type = @"2";
            break;
        case DDMessageTypeVoice:
            person.display_type = @"3";
            break;
        case DDMEssageMuchMyWantAndApply:
            person.display_type = @"10";
            break;
        case DDMEssageEmotion:
            person.display_type = @"1";
            break;
        case DDMEssagePersonalaCard:
            person.display_type = @"6";
            break;
        case DDMEssageLitterVideo:
            person.display_type = @"7";
            break;
        case DDMEssageLitterInviteAndApply:
            person.display_type = @"12";
            break;
        case DDMEssageLitteralbume:
            person.display_type = @"13";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:person animated:YES];
}
//-(void)sendeToWeiPinFriends
//{
//    NSDictionary * dictionary = _defaultDataSource[0];
//    NSString * share  = [NSString stringWithFormat:@"%@",dictionary[@"share"]];
//    NSString * nickName = [NSString string];
//    if ([share isEqualToString:@"0"]) {//原说说
//        nickName = [NSString stringWithFormat:@"%@发表的说说",dictionary[@"nick_name"]];
//    }
//    else if ([share isEqualToString:@"1"])//分享的说说
//    {
//      nickName = [NSString stringWithFormat:@"%@分享的说说",dictionary[@"nick_name"]];
//    }
//    else if ([share isEqualToString:@"2"])
//    {
//      nickName = [NSString stringWithFormat:@"%@分享的求职",dictionary[@"nick_name"]];
//    }
//    else
//    {
//      nickName = [NSString stringWithFormat:@"%@分享的招聘",dictionary[@"nick_name"]];
//    }
//    NSString * contentStr = [NSString string];
//    NSString * speak_comment_state = [NSString stringWithFormat:@"%@",dictionary[@"speak_comment_state"]];
//    NSString * speak_comment_content = [NSString stringWithFormat:@"%@",dictionary[@"speak_comment_content"]];
//    NSString *description1 = [WPMySecurities textFromBase64String:speak_comment_content];
//    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
//    if (description3.length)
//    {
//        contentStr = [NSString stringWithFormat:@"%@:%@",speak_comment_state,description3];
//    }
//    else
//    {
//        NSString * videoCount = [NSString stringWithFormat:@"%@",dictionary[@"videoCount"]];
//        if (videoCount.intValue) {
//            contentStr = [NSString stringWithFormat:@"%@:[视频]",speak_comment_state];
//        }
//        else
//        {
//            contentStr = [NSString stringWithFormat:@"%@:[图片]",speak_comment_state];
//        }
//    }
//    
//    NSDictionary * dic = @{@"nick_name":nickName,
//                           @"shuoshuoid":[dictionary[@"id"] length]?dictionary[@"id"]:@"",
//                           @"avatar":[dictionary[@"avatar"] length]?[NSString stringWithFormat:@"%@%@",IPADDRESS,dictionary[@"avatar"]]:@"",
//                           @"message":contentStr.length?contentStr:@""};
//    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString * messageContent = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    [self tranmitMessage:messageContent andMessageType:DDMEssageSHuoShuo andToUserId:@""];
//}
-(void)refreshHead
{
    _page = 1;
    [self.titleView.activity startAnimating];
    [self requsetWithPageIndex:_page url:nil action:_actions[self.currentIndex] Success:^(NSArray *datas, int more) {
        [self.titleView.activity stopAnimating];
        [self.data removeAllObjects];
        [self.data addObjectsFromArray:datas];
        [self.tableView reloadData];
    } Error:^(NSError *error) {
        [self.titleView.activity stopAnimating];
    }];
    [self updateCountIsPraise:NO];
    [self performSelector:@selector(scrollBottom) afterDelay:0.5];
    [self performSelector:@selector(jumpToDestination) afterDelay:0.5];
}
#pragma mark 点击右侧进行分享
- (void)rightBtnClick
{
    WPSendToFriends * toFriends = [[WPSendToFriends alloc]init];
    NSString * title = [toFriends shareShuoShuo:self.defaultDataSource];
    [self hideView];
    [self keyBoardDismiss];
    NSString *urlStr = [NSString stringWithFormat:@"%@/webMobile/November/Speak_detail.aspx?speak_id=%@",IPADDRESS,self.info[@"sid"]];
    [YYShareManager newShareWithTitle:title url:urlStr action:^(YYShareManagerType type) {
        if (type == YYShareManagerTypeWeiPinFriends)//分享微聘好友
        {
//            [self sendeToWeiPinFriends];
            [toFriends sendShuoShuoToWeiPinFriendsFromDetail:self.defaultDataSource[0] success:^(NSArray *array, NSString *toUserId, NSString *messageContent, NSString *display_type) {
                WPRecentLinkManController * linkMan = [[WPRecentLinkManController alloc]init];
                linkMan.dataSource = array;
                linkMan.toUserId = toUserId;
                linkMan.transStr = messageContent;
                linkMan.display_type = display_type;
                linkMan.isFromShuoDetail = YES;
                linkMan.shuoID = self.info[@"sid"];
                [self.navigationController pushViewController:linkMan animated:YES];
            }];
            
        }
        if (type == YYShareManagerTypeWorkLines) {
            [self shareToTopic];
//            ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
//            share.shareInfo = self.defaultDataSource[0];
//            share.shareSuccessedBlock = ^(id json){
//                [self updateCountIsPraise:NO];
//                if (self.currentIndex == 1) {
//                    [self refreshHead];
//                }
//                if (self.shareSuccessBlock) {
//                    self.shareSuccessBlock(self.clickIndex,self.info[@"sid"]);
//                }
//            };
//            [self.navigationController pushViewController:share animated:YES];
        }
        if (type == YYShareManagerTypeCollect) {//收藏
         [self performSelector:@selector(gotoCollect) withObject:nil afterDelay:0.2];
        }
        if (type == YYShareManagerTypeReport) {//举报
         [self performSelector:@selector(gotoReport) withObject:nil afterDelay:0.2];
        }
    } status:^(UMSocialShareResponse* status) {
//        if (status == UMSResponseCodeSuccess) {
//            
//        }
    }];
}

- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    if (buttonIndex == 1) {       //收藏
        [self performSelector:@selector(gotoCollect) withObject:nil afterDelay:0.2];
    } else if (buttonIndex == 2) {//举报
        [self performSelector:@selector(gotoReport) withObject:nil afterDelay:0.2];
    } else if (buttonIndex == 3) {//分享
        
    }
}

- (void)gotoReport
{
    ReportViewController *report = [[ReportViewController alloc] init];
    report.speak_trends_id = self.info[@"sid"];
    report.type = ReportTypeDynamice;
    [self.navigationController pushViewController:report animated:YES];
    
}

#pragma mark - 点击进行收藏
- (void)gotoCollect
{
    NSDictionary * dic = self.defaultDataSource[0];
    NSString * speak_comment_state = dic[@"speak_comment_state"];
    NSString * col3 = nil;
    if ([speak_comment_state isEqualToString:@"匿名吐槽"]) {
        col3 = [NSString stringWithFormat:@"%@,%@,%@",dic[@"nick_name"],dic[@"POSITION"],dic[@"avatar"]];
    }
    
    CollectViewController *collect = [[CollectViewController alloc] init];
    if (col3.length) {
        collect.col3 = col3;
    }
    collect.collect_class = @"4";
//    collect.shareStr = [NSString stringWithFormat:@"%@",self.defaultDataSource[0][@"share"]];
    collect.dynamicInfo = self.defaultDataSource[0];
    collect.isComeDetail = YES;
    collect.user_id = self.defaultDataSource[0][@"user_id"];
    collect.collectSuccessBlock = ^(){
//        [MBProgressHUD createHUD:@"收藏成功" View:self.view];
    };
    [self.navigationController pushViewController:collect animated:YES];
}


- (void)collect{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSDictionary *params = @{@"action" : @"collect",
                             @"username" : model.username,
                             @"password" : model.password,
                             @"user_id" : userInfo[@"userid"],
                             @"speak_trends_id" : self.info[@"sid"]};
    //    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        [[[UIAlertView alloc] initWithTitle:json[@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    } failure:^(NSError *error) {
        
    }];
    
}

- (HCInputBar *)inputBar {
    if (!_inputBar) {
        _inputBar = [[HCInputBar alloc]initWithStyle:DefaultInputBarStyle];
                _inputBar.hidden = NO;
        //        }else{
        //            _inputBar = [[HCInputBar alloc]initWithStyle:ExpandingInputBarStyle];
        //            _inputBar.expandingAry = @[[NSNumber numberWithInteger:ImgStyleWithEmoji],[NSNumber numberWithInteger:ImgStyleWithVideo],[NSNumber numberWithInteger:ImgStyleWithPhoto],[NSNumber numberWithInteger:ImgStyleWithCamera],[NSNumber numberWithInteger:ImgStyleWithVoice]];
        //        }
        _inputBar.keyboard.showAddBtn = NO;
        [_inputBar.keyboard addBtnClicked:^{
            NSLog(@"我点击了添加按钮");
        }];
        _inputBar.placeHolder = @"说点什么吧...";
    }
    return _inputBar;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
                [self.data addObjectsFromArray:datas];
                [unself.tableView reloadData];
            } Error:^(NSError *error) {
                [self.titleView.activity stopAnimating];
            }];
            
            [_tableView.mj_header endRefreshing];
            [self updateCountIsPraise:NO];
            [self performSelector:@selector(scrollBottom) afterDelay:0.5];
            [self performSelector:@selector(jumpToDestination) afterDelay:0.5];

        }];
        
//        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            _page++;
//            [unself requsetWithPageIndex:_page url:nil action:_actions[self.currentIndex] Success:^(NSArray *datas, int more) {
////                NSLog(@"###%@",datas);
//                if (more == 0) {
//                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                } else {
//                    [self.data addObjectsFromArray:datas];
//                }
//                [unself.tableView reloadData];
//            } Error:^(NSError *error) {
//                _page--;
//            }];
//            [_tableView.mj_footer endRefreshing];
//        }];

    }
    return _tableView;
}

#pragma mark - 跳到指定位置
- (void)jumpToDestination
{
    if (self.jumpType) {
        if (!self.hasJumped) {
            for (int i = 0; i<self.data.count; i++) {
                NSDictionary *dic = self.data[i];
                if ([dic[@"id"] isEqualToString:self.destination_id]) {
                    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:1];
                    [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    self.hasJumped = YES;
                    if (self.jumpType == DetailJumpToComment) {
                        self.by_reply_sid = dic[@"user_id"];
                        self.isTopic = NO;
                        _inputBar.placeHolder = [NSString stringWithFormat:@"回复%@:",self.nickName];
                    }
                }
            }
        }
    }
}


#pragma mark - 跳到底部
- (void)scrollBottom
{
    if (self.currentIndex != 2) {
        return;
    }
    if (self.scrollToBottom) {
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.data.count - 1 inSection:1];
        if (self.data.count) {
            [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];   
        }
        self.scrollToBottom = NO;
    }
}
#pragma mark 添加浏览，分享，评论，赞
- (UIView *)segTitleView
{
    NSLog(@"当前浏览的是第几个 == %ld",(long)self.currentIndex);
    if (!_segTitleView) {
        _segTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(36))];
        NSArray *titles = @[_scanCount,_shareCount,_commentCount,_praiseCount];
        UIView *lastView = nil;
        for (int i = 0; i < 4; i++) {
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
                make.width.equalTo(_segTitleView).dividedBy(4);
                make.bottom.equalTo(_segTitleView);
            }];
            [self.segTitles addObject:button];
            lastView = button;
        }
        
        UILabel *blueLine = [[UILabel alloc]initWithFrame:CGRectMake(self.currentIndex*SCREEN_WIDTH/4, _segTitleView.height-2, SCREEN_WIDTH/4, 2)];
        blueLine.backgroundColor = AttributedColor;
        blueLine.tag = 2333;
        [_segTitleView addSubview:blueLine];
        
        UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, _segTitleView.height-0.5, SCREEN_WIDTH, 0.5)];
        line2.backgroundColor = RGB(226, 226, 226);
        [_segTitleView addSubview:line2];

    }
    return _segTitleView;
}
#pragma mark 点击浏览，评论，分享，赞
- (void)viewForHeaderInSectionActions:(UIButton *)sender{
    [self keyBoardDismiss];
    [self hideView];
    self.currentIndex = sender.tag-233;
    
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:233+i];
        button.selected = button.tag == sender.tag?YES:NO;
    }
    
    UILabel *blueLine = (UILabel *)[self.view viewWithTag:2333];
    blueLine.left = self.currentIndex*SCREEN_WIDTH/4;
    
    [self buttonClickRefresh];
//    
//    for (int i = 0; i < 4; i++) {
//        UIButton *button = (UIButton *)[self.view viewWithTag:233+i];
//        button.selected = button.tag == sender.tag?YES:NO;
//    }
//    
//    UILabel *blueLine = (UILabel *)[self.view viewWithTag:2333];
//    blueLine.left = self.currentIndex*SCREEN_WIDTH/4;
    
}
#pragma mark请求评论，赞，分享，浏览的数据
- (void)buttonClickRefresh
{
    
    switch (self.currentIndex) {
        case 0:
        {
            if (self.isRequstBrowser)
            {
                [self.data removeAllObjects];
                [self.data addObjectsFromArray:self.browerArray];
                [self.tableView reloadData];
                return;
            }
            else
            {
                self.isRequstBrowser = YES;
            }
        }
            break;
        case 1:
        {
            if (self.isRequstShare)
            {
                [self.data removeAllObjects];
                [self.data addObjectsFromArray:self.shareArray];
                [self.tableView reloadData];
                return;
            }
            else
            {
                self.isRequstShare = YES;
            }
        }
            break;
        case 2:
        {
            if (self.isRequstComment)
            {
                [self.data removeAllObjects];
                [self.data addObjectsFromArray:self.commentArray];
                [self.tableView reloadData];
                return;
            }
            else
            {
                self.isRequstComment = YES;
            }
        }
            break;
        case 3:
        {
            if (self.isRequstPraise)
            {
                [self.data removeAllObjects];
                [self.data addObjectsFromArray:self.praiseArray];
                [self.tableView reloadData];
                return;
            }
            else
            {
                self.isRequstPraise = YES;
            }
        }
            break;
        default:
            break;
    }
    
    [self updateCountIsPraise:NO];
    WPShareModel *model = [WPShareModel sharedModel];
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = _actions[self.currentIndex];
    params[@"page"] = @"1";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"speak_id"] = self.info[@"sid"];
    params[@"user_id"] = kShareModel.userId;
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        NSArray *arr = [[NSArray alloc] initWithArray:json[@"list"]];
        [self.data removeAllObjects];
        [self.data addObjectsFromArray:arr];
        [self.tableView reloadData];
        [self addArray:arr];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
        [MBProgressHUD  createHUD:@"网络错误,请稍后重试" View:self.view];
        [self.data removeAllObjects];
        if (self.currentIndex == 2) {
            [[MTTDatabaseUtil instance] getOneShuoshuo:self.info[@"sid"] success:^(NSArray *array) {
                if (array.count) {
                    NSDictionary * dic = array[0];
                    _data = [NSMutableArray arrayWithArray:dic[@"DiscussUser"]];
                    [self setupTitles];
                    [self.tableView reloadData];
                }
                else
                {
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

#pragma mark - NetWork 网络请求
- (void)requsetWithPageIndex:(NSInteger)page url:(NSString *)url action:(NSString *)action Success:(DealsSuccessBlock)success Error:(DealsErrorBlock)errors
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = action;
    params[@"page"] = @(page);
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"speak_id"] = self.info[@"sid"];
    params[@"user_id"] = kShareModel.userId;
//    NSLog(@"*******%@",params);
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
//        NSLog(@"******%@",json);
        NSArray *arr = [[NSArray alloc] initWithArray:json[@"list"]];
        success(arr,(int)arr.count);
        [self addArray:arr];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
        errors(error);
    }];
}

-(void)addArray:(NSArray*)array
{
    switch (self.currentIndex) {
        case 0:
        {
            [self.browerArray removeAllObjects];
            [self.browerArray addObjectsFromArray:array];
        }
            break;
        case 1:
        {
            [self.shareArray removeAllObjects];
            [self.shareArray addObjectsFromArray:array];
        }
            break;
        case 2:
        {
            [self.commentArray removeAllObjects];
            [self.commentArray addObjectsFromArray:array];
        }
            break;
        case 3:
        {
            [self.praiseArray removeAllObjects];
            [self.praiseArray addObjectsFromArray:array];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 请求默认数据
- (void)loadData
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"speakinfo";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"speak_id"] = self.info[@"sid"];
    params[@"user_id"] = userInfo[@"userid"];
    
    [self.titleView.activity startAnimating];
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        [self.titleView.activity stopAnimating];
        if ([json[@"status"] integerValue] == 0) {
            [MBProgressHUD createHUD:@"该说说已被删除" View:self.view];
            [self performSelector:@selector(backup) withObject:nil afterDelay:1.2];
            return ;
        }
        
        _defaultDataSource = [NSMutableArray arrayWithArray:json[@"speakinfo"]];
        _data = [NSMutableArray arrayWithArray:json[@"list"]];
        
        self.commentParams = [NSMutableDictionary dictionaryWithDictionary:json[@"speakinfo"][0]];
        [self setupTitles];
        [self addArray:json[@"list"]];
        if (!self.jumpType) {
            [self.tableView reloadData];
        }
        [self.view bringSubviewToFront:self.inputBar];
    } failure:^(NSError *error) {
        [self.titleView.activity stopAnimating];
        [[MTTDatabaseUtil instance] getOneShuoshuo:self.info[@"sid"] success:^(NSArray *array) {
            if (array.count) {
                NSDictionary * dic = array[0];
                _defaultDataSource = [NSMutableArray arrayWithArray:array];
                _data = [NSMutableArray arrayWithArray:dic[@"DiscussUser"]];
                self.currentIndex = 2;
                [self setupTitles];
                if (!self.jumpType) {
                    [self.tableView reloadData];
                }
                [self.view bringSubviewToFront:self.inputBar];
            }
           
        }];
        
    }];

}

- (void)backup
{
    if (self.deleteSuccessBlock) {
        self.deleteSuccessBlock(self.clickIndex);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 更新数量
- (void)setupTitles
{
    NSDictionary *dic = _defaultDataSource[0];
    _scanCount = [NSString stringWithFormat:@"浏览  %@",[dic[@"speak_browse_count"] intValue]?dic[@"speak_browse_count"]:@"0"];
    _shareCount = [NSString stringWithFormat:@"分享  %@",dic[@"shareCount"]];
    _commentCount = [NSString stringWithFormat:@"评论  %@",dic[@"speak_trends_person"]];
    _praiseCount = [NSString stringWithFormat:@"赞  %@",dic[@"speak_praise_count"]];
    NSString *disType = dic[@"DisType"];
    if (self.jumpType) {
        self.currentIndex = self.jumpType;
        [self segTitleView];
        [self refreshHead];

    } else {
//        if ([disType isEqualToString:@"browse"]) { //浏览
//            self.currentIndex = 0;
//        } else if ([disType isEqualToString:@"share"]) { //分享
//            self.currentIndex = 1;
//        } else if ([disType isEqualToString:@"discuss"]) { //评论
            self.currentIndex = 2;//固定显示在评论上
//        } else if ([disType isEqualToString:@"praise"]) { //赞
//            self.currentIndex = 3;
//        }
        
        if (![disType isEqualToString:@"discuss"]) {
            [self.data removeAllObjects];
        }
        
        [self.tableView reloadData];
    }
    
    [self.view bringSubviewToFront:self.inputBar];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        if (section == 0) {
            return 1;
        } else {
            return self.data.count;
        }
}

-(void)hideBackView:(NSIndexPath*)indexPath
{
    for (int i = 0 ; i < self.data.count; i++) {
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
//                     backView.hidden = YES;
                }];
            }
        }
    }
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:3];
//    [self hideBackView:indexpath];
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellId = @"cellId";
        WorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[WorkTableViewCell alloc] init];
            cell.type = WorkCellTypeSpecial;
        }
        cell.isDetail = YES;
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.indexPath = self.clickIndex;
        [cell confineCellwithData:_defaultDataSource[0]];
            cell.praiseActionBlock = ^(NSIndexPath *index){
                [self addLinkWithIndex:index];
            };
        //点击评论，分享，赞
        cell.clickThreeButton =^(NSIndexPath *indexpath){
            NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
            [self hideBackView:index];
            WorkTableViewCell * cell1 = [tableView cellForRowAtIndexPath:index];
            for (UIView * view in cell1.contentView.subviews) {
                if ([view isKindOfClass:[WPThreeBackView class]]) {
                    WPThreeBackView * BackView = (WPThreeBackView*)view;
                    BackView.indexpath = index;
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
                            rect.origin.x = SCREEN_WIDTH-kHEIGHT(10)-18-6;
                            BackView.frame = rect;
                        }];
                    }
                }
            }
        };
        
        
            cell.commentActionBlock = ^(NSIndexPath *index){
                NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:3];
                [self hideBackView:indexpath];
                self.commentParams = [NSMutableDictionary dictionaryWithDictionary:self.defaultDataSource[0]];
                _inputBar.placeHolder = @"说点什么吧...";
                [_inputBar.inputView becomeFirstResponder];
                self.isEditeNow = YES;
            };
            cell.deleteActionBlock = ^(NSIndexPath *index){
                [self dustbinClickWithIndexPath:index];
            };
            cell.shareActionBlock = ^(NSIndexPath *index){
                [self shareDynamicWithIndex:index];
            };
            cell.checkActionBlock = ^(NSIndexPath *index){
                [self checkHomePageWith:index];
            };

        return cell;
    } else {
        if (self.currentIndex != 2) {
            DetailScanCell *cell = [DetailScanCell cellWithTableView:tableView];
            cell.dic = self.data[indexPath.row];
            return cell;
        } else {
            [self.commentArray removeAllObjects];
            [self.commentArray addObjectsFromArray:self.data];
            
            NewCommentCell *cell = [NewCommentCell cellWithTableView:tableView];
            cell.currentIndex = indexPath;
            cell.dic = self.data[indexPath.row];
            UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            recognizer.minimumPressDuration = 0.5;
            [cell addGestureRecognizer:recognizer];
            cell.iconClickBlock = ^(NSIndexPath *index){
                
                PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
                NSDictionary *dic =  self.data[indexPath.row];
                info.friendID = dic[@"user_id"];
                
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
//                if ([dic[@"add_fuser_state"] isEqualToString:@"0"]) {  // 0陌生人 1好友 [self.dataSource[indexPath.row] is_friend]
//                    info.newType = NewRelationshipTypeFriend;
//                }else{
//                    info.newType = NewRelationshipTypeStranger;
//                }
                
//                [self.navigationController pushViewController:info animated:YES];
                
                
                
//                NewHomePageViewController *homepage = [[NewHomePageViewController alloc] init];
//                homepage.info = self.data[indexPath.row];
//                homepage.isComeFromDynamic = YES;
//                [self.navigationController pushViewController:homepage animated:YES];
            };
            
            cell.nickNameClickBlock = ^(NSIndexPath *index) {
                NSDictionary *dict = self.data[indexPath.row];
                NewHomePageViewController *homepage = [[NewHomePageViewController alloc] init];
                homepage.info = @{ @"user_id" : dict[@"by_user_id"],
                                   @"nick_name" : dict[@"by_nick_name"]};
                homepage.isComeFromDynamic = YES;
                [self.navigationController pushViewController:homepage animated:YES];
            };
            return cell;
        }
    }
    
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NewCommentCell *cell = (NewCommentCell *)recognizer.view;
        self.clickCell = cell;
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
    NSIndexPath *index = [self.tableView indexPathForCell:self.clickCell];
    pasteboard.string = [WPMySecurities textFromEmojiString:self.data[index.row][@"speak_comment_content"]];
}

-(void)WillHideMenu:(id)sender
{
    self.clickCell.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSDictionary *dic = _defaultDataSource[0];
        NSString *shareType = [NSString stringWithFormat:@"%@",dic[@"share"]];
        NSInteger count = [dic[@"imgCount"] integerValue];
        NSInteger videoCount = [dic[@"videoCount"] integerValue];
        NSString *description = dic[@"speak_comment_content"];
        NSString *description1 = [WPMySecurities textFromBase64String:description];
        NSString *description3 = [WPMySecurities textFromEmojiString:description1];
        NSString *speak_comment_state = dic[@"speak_comment_state"];
        NSString *lastDestription = [NSString stringWithFormat:@"%@\n%@",speak_comment_state,description3];
        if (!description3.length) {
            lastDestription = speak_comment_state;
        }
        else
        {
            if ([description3 isEqualToString:@"分享"]) {
                lastDestription = [NSString stringWithFormat:@"%@/分享",speak_comment_state];
            }
        }
        
        CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
        CGFloat descriptionLabelHeight;//内容的显示高度
        if ([dic[@"speak_comment_content"] length] == 0) {
            descriptionLabelHeight = normalSize.height;
        } else {
            CGSize size = [lastDestription boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(14)]} context:nil].size;
            
            descriptionLabelHeight = size.height;
        }
        CGFloat photosHeight;//定义照片的高度
        
        if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"]) {
            photosHeight = kHEIGHT(43);
        } else if ([shareType isEqualToString:@"1"]) {
            photosHeight = kHEIGHT(43);
//            photosHeight = [ShareDynamic calculateHeightWithInfo:dic[@"shareMsg"]];
        }else {
            CGFloat photoWidth;
            CGFloat videoWidth;
            photoWidth = (SCREEN_WIDTH == 320) ? 74 : ((SCREEN_WIDTH == 375) ? 79 : 86);
            videoWidth = (SCREEN_WIDTH == 320) ? 140 : ((SCREEN_WIDTH == 375) ? 164 : 180);//172->180
            
            if (videoCount == 1) {
                NSLog(@"controller 有视频");
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
        
        CGFloat cellHeight;
        
        if ([dic[@"address"] length] == 0) { //没地址
            
            if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
            } else { //不是简历，求职
                if ([dic[@"original_photos"] count] == 0) {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
                } else {
                    if (self.isMore) {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + normalSize.height + 10 + 8;
                    } else {
                        if (videoCount == 1) {
                          cellHeight = kHEIGHT(10) + kHEIGHT(37) + descriptionLabelHeight + photosHeight + kHEIGHT(32) + 8;
                        }
                        else
                        {
                         cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
                        }
//                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(10) + kHEIGHT(32) + 8;
//                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + descriptionLabelHeight + photosHeight + kHEIGHT(32) + 8;
                    }
                }
            }
            
        } else { //有地址
            
            if ([shareType isEqualToString:@"2"] || [shareType isEqualToString:@"3"] || [shareType isEqualToString:@"1"]) {
                    cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + 8;
            } else {
                if ([dic[@"original_photos"] count] == 0) {
                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + 15 + kHEIGHT(10) + kHEIGHT(32) + 8;
                } else {
//                        cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + 8;
                    
                    if (videoCount) {
                      cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + kHEIGHT(32) + kHEIGHT(10);
                    }
                    else
                    {
                      cellHeight = kHEIGHT(10) + kHEIGHT(37) + kHEIGHT(10) + descriptionLabelHeight + 10 + photosHeight + 10 +  15 + kHEIGHT(10) + kHEIGHT(32) + 8;
                    }
                }
            }
        }
        return cellHeight;
    } else {
        if (self.currentIndex !=2) {
            return kHEIGHT(50);
        } else {
            return [NewCommentCell cellHeightWith:self.data[indexPath.row]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self keyBoardDismiss];
    [self hideView];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.currentIndex != 2) {
        if (indexPath.section != 0) {
            
            PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
            NSDictionary *dic =  self.data[indexPath.row];
            info.friendID = dic[@"user_id"];
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
            
            
//            NewHomePageViewController *homepage = [[NewHomePageViewController alloc] init];
//            homepage.info = self.data[indexPath.row];
//            homepage.isComeFromDynamic = YES;
//            [self.navigationController pushViewController:homepage animated:YES];
        } else {
            if (self.isEditeNow) {
                [self keyBoardDismiss];
                
                return;
            }
        }
    } else {
        if (indexPath.section != 0) {
            
            WPShareModel *model = [WPShareModel sharedModel];
            NSMutableDictionary *userInfo = model.dic;
            NSString *userid = userInfo[@"userid"];
            NSString *user_id = self.data[indexPath.row][@"user_id"];
            if ([userid isEqualToString:user_id]) {
                if (self.isEditeNow) {
                    [self keyBoardDismiss];
                   
                    return;
                }
                HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"删除", nil];
                self.peplyId = self.data[indexPath.row][@"sid"];
                self.deleteIndex = indexPath;
                self.selectedIndexPath = indexPath;
                // 2.显示出来
                [sheet show];

            } else {
                if (self.isEditeNow) {
                    [self keyBoardDismiss];
                  
                    return;
                }
                self.by_reply_sid = user_id;
                self.isTopic = NO;
//                _myMsgInputView.placeHolder = [NSString stringWithFormat:@"回复%@：",self.data[indexPath.row][@"nick_name"]];
//                [_myMsgInputView notAndBecomeFirstResponder];
                
                _inputBar.placeHolder = [NSString stringWithFormat:@"回复%@：",self.data[indexPath.row][@"nick_name"]];
                self.nickName = self.data[indexPath.row][@"nick_name"];
                [_inputBar.inputView becomeFirstResponder];
                self.isEditeNow = YES;
            }
            
        }
    }
}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    //    NSMutableDictionary *myDic = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"deletediscuss";
    params[@"speak_id"] = self.info[@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"peplyId"] = self.peplyId;
    //    params[@"user_id"] = myDic[@"userid"];
    //    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        //        NSLog(@"%@--%@",json,json[@"info"]);
        [self updateCountIsPraise:NO];
//        [self.tableView.mj_header beginRefreshing];
//        self.data
        
        [self.data removeObjectAtIndex:self.deleteIndex.row];
        [self.tableView reloadData];
        if (self.deleteComentBlock) {
            self.deleteComentBlock();
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

#pragma mark - replyBtn click
- (void)replyBtnClickWith:(UIButton *)replyBtn
{
    NSDictionary *dic = _data[replyBtn.tag - 2];
    NSLog(@"****%@",dic);
    self.discuss_id = dic[@"id"];
    self.by_reply_nickName = dic[@"nick_name"];
    self.by_reply_sid = dic[@"user_id"];
    self.isTopic = NO;
    NSString *placeHoder = [NSString stringWithFormat:@"回复:%@",dic[@"nick_name"]];
//    _myMsgInputView.placeHolder = placeHoder;
//    [_myMsgInputView notAndBecomeFirstResponder];
    
    _inputBar.placeHolder = placeHoder;
    [_inputBar.inputView becomeFirstResponder];
    
}

#pragma mark - 查看个人主页
- (void)checkHomePageWith:(NSIndexPath *)indexPath
{
    [self hideView];
    [self keyBoardDismiss];
    NewHomePageViewController *homepage = [[NewHomePageViewController alloc] init];
    homepage.info = _defaultDataSource[0];
    homepage.isComeFromDynamic = self.isFromCollection?NO:YES;
    
//    homepage.isComeFromDynamic = YES;
    [self.navigationController pushViewController:homepage animated:YES];
}

#pragma mark 点击三个中的分享
- (void)shareDynamicWithIndex:(NSIndexPath *)index
{
    
    WPSendToFriends * toFriends = [[WPSendToFriends alloc]init];
    NSString * title = [toFriends shareShuoShuo:self.defaultDataSource];
    
    [self hideView];
    [self keyBoardDismiss];
    NSString *urlStr = [NSString stringWithFormat:@"http://uxinsoft.iok.la:85/webMobile/November/Speak_detail.aspx?speak_id=%@",self.info[@"sid"]];
    [YYShareManager shareWithTitle:title url:urlStr action:^(YYShareManagerType type) {
        if (type == YYShareManagerTypeWeiPinFriends)
        {
//            [self sendeToWeiPinFriends];
            
            [toFriends sendShuoShuoToWeiPinFriendsFromDetail:self.defaultDataSource[0] success:^(NSArray *array, NSString *toUserId, NSString *messageContent, NSString *display_type) {
                WPRecentLinkManController * linkMan = [[WPRecentLinkManController alloc]init];
                linkMan.dataSource = array;
                linkMan.toUserId = toUserId;
                linkMan.transStr = messageContent;
                linkMan.display_type = display_type;
                [self.navigationController pushViewController:linkMan animated:YES];
            }];
        }
        if (type == YYShareManagerTypeWorkLines) {
            [self shareToTopic];

//            ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
//            share.shareInfo = self.defaultDataSource[0];
//            share.shareSuccessedBlock = ^(id json){
//                [self updateCountIsPraise:NO];
//                if (self.currentIndex == 1) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self refreshHead];
//                    });
//                }
//                if (self.shareSuccessBlock) {
//                    self.shareSuccessBlock(self.clickIndex,self.info[@"sid"]);
//                }
//            };
//            [self.navigationController pushViewController:share animated:YES];
            
        }
    } status:^(UMSocialShareResponse*status) {
    }];
}
-(void)shareToTopic
{
    NSString * action = [NSString new];
    NSDictionary * dic = self.defaultDataSource[0];
    action = [dic[@"share"] isEqualToString:@"2"]?@"ExistsResume":([dic[@"share"] isEqualToString:@"3"]?@"ExistsJob":@"ExistsSpeak");
    
    //判断分享的是否被删除
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/speak_manage.ashx",IPADDRESS];
    NSDictionary * dictionary = @{@"action":action,@"id":dic[@"jobids"]};
    NSArray * arr = [dic[@"jobids"] componentsSeparatedByString:@","];
    if ([dic[@"share"] integerValue]&&(arr.count == 1)) {
        [WPHttpTool postWithURL:urlStr params:dictionary success:^(id json) {
            NSString * string = [NSString new];
            string = [dic[@"share"] isEqualToString:@"2"]?@"该简历已被删除":([dic[@"share"] isEqualToString:@"3"]?@"该招聘已被删除":@"该说说已被删除");
            
            if ([json[@"status"] integerValue]) {
                [MBProgressHUD createHUD:string View:self.view];
            }
            else
            {
                ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
                share.shareInfo = self.defaultDataSource[0];
                share.shareSuccessedBlock = ^(id json){
                    [self updateCountIsPraise:NO];
                    if (self.currentIndex == 1) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self refreshHead];
                        });
                    }
                    if (self.shareSuccessBlock) {
                        self.shareSuccessBlock(self.clickIndex,self.info[@"sid"]);
                    }
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
        share.shareInfo = self.defaultDataSource[0];
        share.shareSuccessedBlock = ^(id json){
            [self updateCountIsPraise:NO];
            if (self.currentIndex == 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self refreshHead];
                });
            }
            if (self.shareSuccessBlock) {
                self.shareSuccessBlock(self.clickIndex,self.info[@"sid"]);
            }
        };
        [self.navigationController pushViewController:share animated:YES];
        
    }

}
#pragma mark 点赞
- (void)addLinkWithIndex:(NSIndexPath *)indexPath
{
    //    NSLog(@"***%ld",(long)indexPath.row);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_defaultDataSource[0]];
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
        //        if ([is_good isEqualToString:@"0"]) {
        //            [goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"1"];
        //        } else {
        //            [goodData replaceObjectAtIndex:_selectedIndexPath.row withObject:@"0"];
        //        }
//        [self updateCommentAndPraiseCountWithIndex:indexPath isPraise:YES];
        [self updateCountIsPraise:YES];
        [self buttonClickRefresh];
        if (self.praiseSuccessBlock) {
            self.praiseSuccessBlock(self.clickIndex,self.info[@"sid"]);
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
    
}

#pragma mark 删除
- (void)dustbinClickWithIndexPath:(NSIndexPath *)index{
    [self keyBoardDismiss];
    [self hideView];
    NSDictionary *dic = [NSDictionary dictionary];
    //    NSIndexPath *path = [self.tableViews[self.currentPage] indexPathForCell:cell];
    dic = self.defaultDataSource[0];
    
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
    //    NSLog(@"%d",buttonIndex);
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            NSLog(@"取消");
        } else {
            NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
            [WPHttpTool postWithURL:url params:self.deletParams success:^(id json) {
//                                NSLog(@"%@---%@",json,json[@"info"]);
                if ([json[@"status"] integerValue] == 1) {
//                    [MBProgressHUD showSuccess:@"删除成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                    if (self.deleteSuccessBlock) {
                        self.deleteSuccessBlock(self.clickIndex);
                    }
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
                [MBProgressHUD showError:@"删除失败"];
            }];
            
        }
    } else {
        if (self.deleteSuccessBlock) {
            self.deleteSuccessBlock(self.clickIndex);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 请求当前最新的数量：浏览，评论，分享，赞
- (void)updateCountIsPraise:(BOOL)isPraise
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
//    WPShareModel *model = [WPShareModel sharedModel];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getCount";
    params[@"speak_id"] = self.defaultDataSource[0][@"sid"];
    params[@"user_id"] = userInfo[@"userid"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
        NSDictionary *dic = json[@"List"][0];
        _scanCount = [NSString stringWithFormat:@"浏览  %@",[dic[@"speak_browse_count"] intValue]?dic[@"speak_browse_count"]:@"0"];
        _shareCount = [NSString stringWithFormat:@"分享  %@",dic[@"shareCount"]];
        _commentCount = [NSString stringWithFormat:@"评论  %@",dic[@"speak_trends_person"]];
        _praiseCount = [NSString stringWithFormat:@"赞  %@",dic[@"speak_praise_count"]];
        NSArray *titles = @[_scanCount,_shareCount,_commentCount,_praiseCount];
        for (int i = 0; i<4; i++) {
            UIButton *btn = self.segTitles[i];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.defaultDataSource[0]];
        NSString *is_good = [NSString stringWithFormat:@"%@",dict[@"is_good"]];
        [dict setObject:dic[@"speak_trends_person"] forKey:@"speak_trends_person"];
        [dict setObject:dic[@"speak_praise_count"] forKey:@"speak_praise_count"];
       
        [dict setObject:dic[@"shareCount"] forKey:@"shareCount"];
        if (isPraise) {
            if ([is_good isEqualToString:@"0"]) {
                [dict setObject:@"1" forKey:@"is_good"];
            } else {
                [dict setObject:@"0" forKey:@"is_good"];
            }
        }
        [self.defaultDataSource replaceObjectAtIndex:0 withObject:dict];
        [self.tableView reloadData];
  
    } failure:^(NSError *error) {
    
    }];
    
}

#pragma mark 更新评论和赞的数量
- (void)updateCommentAndPraiseCountWithIndex:(NSIndexPath *)index isPraise:(BOOL)isPraise
{
    //    UITableView *table = self.tableViews[self.currentPage];
    //    WorkTableViewCell *cell = (WorkTableViewCell *)[table cellForRowAtIndexPath:_selectedIndexPath];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getsum";
    params[@"speak_trends_id"] = self.defaultDataSource[0][@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        if ([json[@"state"] integerValue] == 0) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.defaultDataSource[0]];
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"replySpeak";
    params[@"speak_id"] = self.info[@"sid"];
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = myDic[@"userid"];
    params[@"nick_name"] = myDic[@"nick_name"];
    params[@"speak_comment_content"] = obj;
    if (self.isTopic) {
        params[@"speak_reply"] = @"0";
    } else {
        params[@"speak_reply"] = @"1";
        params[@"by_user_id"] = self.by_reply_sid;
    }
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        
        if ([json[@"status"] integerValue] == 1) {
            [self updateCountIsPraise:NO];
            if (self.currentIndex != 2) {
                [self.data removeAllObjects];
                [self.data addObjectsFromArray:self.commentArray];
            }
            
            self.currentIndex = 2;
            for (int i = 0; i < 4; i++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:233+i];
                button.selected = button.tag == 233 + self.currentIndex?YES:NO;
            }
            UILabel *blueLine = (UILabel *)[self.view viewWithTag:2333];
            blueLine.left = self.currentIndex*SCREEN_WIDTH/4;
            if (self.currentIndex == 2) {
                self.scrollToBottom = YES;
                NSDictionary *dictionary = [USER_DEFAULT objectForKey:@"LOGINUSERINFO"];
                NSDictionary * dic = @{@"addtime":@"",@"avatar":dictionary[@"list"][0][@"avatar"],
                                       @"by_avatar":@"",@"by_company":@"",@"by_nick_name":self.nickName,@"by_position":@"",@"by_user_id":self.by_reply_sid,
                                       @"company":dictionary[@"list"][0][@"company"],@"father_id":@"0",@"id":json[@"id"],
                                       @"nick_name":dictionary[@"list"][0][@"nick_name"],@"pos":@"",
                                       @"position":dictionary[@"list"][0][@"position"],
                                       @"post_remark":@"",@"post_remark2":@"",@"sid":json[@"id"],@"speak_add_time":@"1分钟前",
                                       @"speak_comment_content":obj,@"speak_id":@"",@"speak_trends_person":@"",
                                       @"user_id":dictionary[@"list"][0][@"userid"]};
                
                if (self.data.count) {
                 [self.data insertObject:dic atIndex:self.data.count];
                }
                else
                {
                    [self.data addObject:dic];
                }
                
                [self.tableView reloadData];
//                [self.tableView scrollToBottom];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.data.count-1 inSection:1] atScrollPosition:UITableViewScrollPositionNone animated:YES];
                self.nickName = @"";
                self.by_reply_sid = @"";
                self.inputBar.placeHolder= @"说点什么吧...";
                
//                _page = 1;
//                [self requsetWithPageIndex:_page url:nil action:_actions[self.currentIndex] Success:^(NSArray *datas, int more) {
//                    [self.data removeAllObjects];
//                    [self.data addObjectsFromArray:datas];
//                    [self.tableView reloadData];
//                    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:self.data.count-1 inSection:1];
//                    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                } Error:^(NSError *error) {
//                    
//                }];
                
            }
            if (self.commentSuccessBlock) {
                self.commentSuccessBlock(self.clickIndex,self.info[@"sid"]);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];
    
    // 键盘隐藏
    [self keyBoardDismiss];
}

#pragma mark - 键盘消失
- (void)keyBoardDismiss
{
    self.by_reply_nickName = self.info[@"nick_name"];
    self.by_reply_sid = self.info[@"user_id"];
    self.discuss_id = self.info[@"sid"];
    self.isTopic = YES;
    [_inputBar.inputView resignFirstResponder];
    _inputBar.keyboardTypeBtn.tag = 0;
    _inputBar.inputView.inputView = nil;
    [_inputBar.keyboardTypeBtn setImage:[UIImage imageNamed:@"common_biaoqing"] forState:UIControlStateNormal];
//    _inputBar.placeHolder = @"说点什么吧...";
    dispatch_async(dispatch_get_main_queue(), ^{
        [_inputBar.inputView reloadInputViews];
        [_inputBar layout];
    });

//    _inputBar.inputView.text = @"";
    self.isEditeNow = NO;
//
    
}


- (void)recoverWith:(NSIndexPath *)index
{
    CommentCell *cell = [self.tableView cellForRowAtIndexPath:index];
    cell.commentLabel.backgroundColor = [UIColor whiteColor];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideView];
    [self keyBoardDismiss];
}
-(void)hideView{
   NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:3];
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
