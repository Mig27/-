//
//  NearInterViewController.m
//  WP
//
//  Created by CBCCBC on 15/9/24.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "NearInterViewController.h"
#import "ApplyForActivityController.h"
#import "WPRecruitApplyController.h"
#import "WPInterviewApplyController.h"
#import "SPPreview.h"
#import "SPButton.h"
#import "UIWebView+AFNetworking.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "MBProgressHUD+MJ.h"
#import "IQKeyboardManager.h"
#import "WPRecruitApplyChooseModel.h"
#import "WPInterviewApplyChooseModel.h"
#import "WPRecruitApplyChooseController.h"
#import "WPInterviewApplyController.h"
#import "WPInterviewApplyChooseController.h"
#import "WPResumeCheckController.h"
#import "WPPersonalResumeListController.h"
#import "RequestManager.h"
#import "UIImage+autoGenerate.h"
#import "WPNewMeResumeController.h"
#import "WPScrollView.h"
#import "YYShareManager.h"
#import "ShareEditeViewController.h"
#import "MLPhotoBrowserPhoto.h"
#import "MLPhotoBrowserViewController.h"
#import "CollectViewController.h"
#import "WPIVManager.h"
#import "WPIVModel.h"
#import "WPCheckImagesController.h"
#import "VideoBrowser.h"
#import "WPResumeAndInviteDetailModel.h"
#import "ReportViewController.h"
#import "RecentPersonController.h"
#import "ChattingMainViewController.h"
#import "PersonalInfoViewController.h"
#import "WPPersonalAlbumController.h"
#import "WPNewCheckController.h"
#import "WPDetailPhotoViewController.h"
#import "SAYVideoManagerViewController.h"
#import "ChattingMainViewController.h"
#import "WPRecentLinkManController.h"
#import "SessionModule.h"
#import "WPMySecurities.h"
#import "WPDownLoadVideo.h"
#import "WPMapViewController.h"
#import "WPApplyViewController.h"
#define shuoShuoVideo @"/shuoShuoVideo"
#define boundsWidth self.view.bounds.size.width
#define boundsHeight self.view.bounds.size.height
@interface NearInterViewFourButton ()<UIWebViewDelegate>

@property (nonatomic ,strong)NSMutableArray *buttonArr;

@end

@implementation NearInterViewFourButton
#pragma mark -- 这是一个封装的View
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        NSArray *titles = @[@"  聊聊",@"  申请",@"  收藏",@"  留言"];
        NSArray *images = @[@"common_liaoliao",@"common_gongyong",@"common_shoucang",@"quanzhi_liuyan"];
        for (int i = 0; i< 4; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateHighlighted];
            button.titleLabel.font = kFONT(15);
            [button addTarget:self action:@selector(userOperationClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(i*SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4+1, 49);
            if (i==0) {
                [button setBackgroundImage:[UIImage imageWithColor:RGB(0, 172, 255) size:CGSizeMake(SCREEN_WIDTH/4+1, 49)] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageWithColor:RGB(0, 146, 217) size:CGSizeMake(SCREEN_WIDTH/4+1, 49)] forState:UIControlStateHighlighted];
            }else{
                [button setBackgroundImage:[UIImage imageWithColor:RGB(255, 139, 0) size:CGSizeMake(SCREEN_WIDTH/4+1, 49)] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageWithColor:RGB(217, 118, 0) size:CGSizeMake(SCREEN_WIDTH/4+1, 49)] forState:UIControlStateHighlighted];
            }
            [self addSubview:button];
            if (i==1) {
//                [button setTitle:@"已申请" forState:UIControlStateSelected];
            }else if (i == 2) {
                [button setTitle:@"已收藏" forState:UIControlStateSelected];
            }
            if (i>0) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/4, 0, 0.5, 49)];
                line.backgroundColor = [UIColor whiteColor];
                [self addSubview:line];
            }
            [self.buttonArr addObject:button];
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [self addSubview:line];
    }
    return self;
}

- (NSMutableArray *)buttonArr
{
    if (!_buttonArr) {
        self.buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}
//设置apply属性时确定 申请button的点击状态
- (void)setAplly:(BOOL)aplly
{
    UIButton *button = self.buttonArr[1];
    _aplly = aplly;
    if (aplly) {
        button.selected = YES;
    }else{
        button.selected = NO;
    }
}

- (void)setCollection:(BOOL)collection
{
    UIButton *button = self.buttonArr[2];
    _collection = collection;
    if (collection) {
        button.selected = YES;
    }else{
        button.selected = NO;
    }
}

- (void)setIsRecuilist:(BOOL)isRecuilist
{
    UIButton *button = self.buttonArr[1];
    _isRecuilist = isRecuilist;
    if (isRecuilist) {
        
    }else{
        [button setTitle:@"抢人" forState:UIControlStateNormal];
        [button setTitle:@"已抢" forState:UIControlStateSelected];
    }
}
#pragma mark 点击底部按钮
-(void)userOperationClick:(UIButton *)sender
{
    NSInteger tag = [self.buttonArr indexOfObject:sender];
    if (self.delegate && [self.delegate respondsToSelector:@selector(delegateActionWithIndex:)]) {
        [self.delegate delegateActionWithIndex:tag];
    }
}
@end
@interface NearInterViewController () <UIWebViewDelegate,NJKWebViewProgressDelegate,UITextFieldDelegate,WPRecruitApplyDelegate,WPInterviewApplyDelegate,NearInterViewFourButtonDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *baseView;
@property (strong, nonatomic) NearInterViewFourButton *bottomView;
@property (strong, nonatomic) UIView *bottomChatView;
@property (strong, nonatomic) UIView *bottomEditView;
@property (strong, nonatomic) UIView *bottomManagerView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NJKWebViewProgressView *webViewProgressView;
@property (strong, nonatomic) NJKWebViewProgress *webViewProgress;
@property (strong, nonatomic) UIView *messageView;
@property (nonatomic ,strong) UIButton *editButton;
@property (nonatomic ,strong) NSMutableArray *array;
@property (nonatomic, strong) WPResumeAndInviteDetailModel *detailModel;  /**< 招聘或者求职的信息 */
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic ,strong)UIScrollView * webScroller;
@property (nonatomic, strong)UIButton*rightButton;
@property (nonatomic, assign)BOOL isSame;
//@property (nonatomic, strong)UIPanGestureRecognizer*swipePanGesture;
//@property (nonatomic, assign)BOOL isSwipingBack;
//@property (nonatomic, strong)UIView* currentSnapShotView;
//@property (nonatomic, strong)UIView* prevSnapShotView;
//@property (nonatomic, strong)UIView* swipingBackgoundView;
//@property (nonatomic, strong)NSMutableArray* snapShotsArray;
@end

@implementation NearInterViewController
#pragma mark -- 该页面推出 -> 全职 -> "企业招聘"  点击Cell ->

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
//    [MBProgressHUD showMessage:@"" toView:self.view];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNav];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    WPIVManager *manager = [WPIVManager sharedManager];
    manager.fk_id = self.subId;
    manager.fk_type = self.isFromCompanyGive?(self.isRecuilist?@"1":@"0"):[NSString stringWithFormat:@"%d",self.isRecuilist]
    ;
    [manager requsetForImageAndVideo];
    [self.view addSubview:self.baseView];
    
    (_isRecuilist == 2?(_isSelf?[self bottomEditView]:[self bottomChatView]):(_isSelf?[self bottomManagerView]:[self bottomView]));
//    [self.baseView  addSubview:self.webView];
    [self.view addSubview:self.webView];
    [self getRecruitApplyMessage];
    
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[NearInterViewController class]];
    
    [self.navigationController.navigationBar addSubview:self.webViewProgressView];
    
    //增加监听，当键盘出现 改变 退出时收出消息
//    [self addObserverForKeyBoard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(refreshApplyState)
                                        name:@"kNotificationApplySucceed"
                                               object:nil];
    
    //修改成功后查看界面刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(refreshData)
                                          name:@"REFRESHCHECKDATA"
                                          object:nil];
    if(self.isSelf){
        [self.view addSubview:self.editButton];
    }
}
////////////////////////////////////////////////

//-(BOOL)isSwipingBack{
//    if (!_isSwipingBack) {
//        _isSwipingBack = NO;
//    }
//    return _isSwipingBack;
//}
//-(UIView*)swipingBackgoundView{
//    if (!_swipingBackgoundView) {
//        _swipingBackgoundView = [[UIView alloc] initWithFrame:self.view.bounds];
//        _swipingBackgoundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//    }
//    return _swipingBackgoundView;
//}
//-(void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request{
//    //    NSLog(@"push with request %@",request);
//    NSURLRequest* lastRequest = (NSURLRequest*)[[self.snapShotsArray lastObject] objectForKey:@"request"];
//    
//    //如果url是很奇怪的就不push
//    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
//        //        NSLog(@"about blank!! return");
//        return;
//    }
//    //如果url一样就不进行push
//    if ([lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
//        return;
//    }
//    
//    UIView* currentSnapShotView = [self.webView snapshotViewAfterScreenUpdates:YES];
//    [self.snapShotsArray addObject:
//     @{
//       @"request":request,
//       @"snapShotView":currentSnapShotView
//       }
//     ];
//    //    NSLog(@"now array count %d",self.snapShotsArray.count);
//}
//
//
//-(NSMutableArray*)snapShotsArray{
//    if (!_snapShotsArray) {
//        _snapShotsArray = [NSMutableArray array];
//    }
//    return _snapShotsArray;
//}
//-(UIPanGestureRecognizer*)swipePanGesture{
//    if (!_swipePanGesture) {
//        _swipePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipePanGestureHandler:)];
//    }
//    return _swipePanGesture;
//}
//-(void)swipePanGestureHandler:(UIPanGestureRecognizer*)panGesture{
//    CGPoint translation = [panGesture translationInView:self.webView];
//    CGPoint location = [panGesture locationInView:self.webView];
//    
//    if (panGesture.state == UIGestureRecognizerStateBegan) {
//        if (location.x <= 50 && translation.x > 0) {  //开始动画
//            [self startPopSnapshotView];
//        }
//    }else if (panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateEnded){
//        [self endPopSnapShotView];
//    }else if (panGesture.state == UIGestureRecognizerStateChanged){
//        [self popSnapShotViewWithPanGestureDistance:translation.x];
//    }
//}
//-(void)startPopSnapshotView{
//    if (self.isSwipingBack) {
//        return;
//    }
//    if (!self.webView.canGoBack) {
//        return;
//    }
//    self.isSwipingBack = YES;
//    //create a center of scrren
//    CGPoint center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
//    
//    self.currentSnapShotView = [self.webView snapshotViewAfterScreenUpdates:YES];
//    
//    //add shadows just like UINavigationController
//    self.currentSnapShotView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.currentSnapShotView.layer.shadowOffset = CGSizeMake(3, 3);
//    self.currentSnapShotView.layer.shadowRadius = 5;
//    self.currentSnapShotView.layer.shadowOpacity = 0.75;
//    
//    //move to center of screen
//    self.currentSnapShotView.center = center;
//    
//    self.prevSnapShotView = (UIView*)[[self.snapShotsArray lastObject] objectForKey:@"snapShotView"];
//    center.x -= 60;
//    self.prevSnapShotView.center = center;
//    self.prevSnapShotView.alpha = 1;
//    self.view.backgroundColor = [UIColor blackColor];
//    
//    [self.view addSubview:self.prevSnapShotView];
//    [self.view addSubview:self.swipingBackgoundView];
//    [self.view addSubview:self.currentSnapShotView];
//}
//-(void)endPopSnapShotView{
//    if (!self.isSwipingBack) {
//        return;
//    }
//    
//    //prevent the user touch for now
//    self.view.userInteractionEnabled = NO;
//    
//    if (self.currentSnapShotView.center.x >= boundsWidth) {
//        // pop success
//        [UIView animateWithDuration:0.2 animations:^{
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//            
//            self.currentSnapShotView.center = CGPointMake(boundsWidth*3/2, boundsHeight/2);
//            self.prevSnapShotView.center = CGPointMake(boundsWidth/2, boundsHeight/2);
//            self.swipingBackgoundView.alpha = 0;
//        }completion:^(BOOL finished) {
//            [self.prevSnapShotView removeFromSuperview];
//            [self.swipingBackgoundView removeFromSuperview];
//            [self.currentSnapShotView removeFromSuperview];
//            [self.webView goBack];
//            [self.snapShotsArray removeLastObject];
//            self.view.userInteractionEnabled = YES;
//            
//            self.isSwipingBack = NO;
//        }];
//    }else{
//        //pop fail
//        [UIView animateWithDuration:0.2 animations:^{
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//            
//            self.currentSnapShotView.center = CGPointMake(boundsWidth/2, boundsHeight/2);
//            self.prevSnapShotView.center = CGPointMake(boundsWidth/2-60, boundsHeight/2);
//            self.prevSnapShotView.alpha = 1;
//        }completion:^(BOOL finished) {
//            [self.prevSnapShotView removeFromSuperview];
//            [self.swipingBackgoundView removeFromSuperview];
//            [self.currentSnapShotView removeFromSuperview];
//            self.view.userInteractionEnabled = YES;
//            
//            self.isSwipingBack = NO;
//        }];
//    }
//}
//-(void)popSnapShotViewWithPanGestureDistance:(CGFloat)distance{
//    if (!self.isSwipingBack) {
//        return;
//    }
//    
//    if (distance <= 0) {
//        return;
//    }
//    
//    CGPoint currentSnapshotViewCenter = CGPointMake(boundsWidth/2, boundsHeight/2);
//    currentSnapshotViewCenter.x += distance;
//    CGPoint prevSnapshotViewCenter = CGPointMake(boundsWidth/2, boundsHeight/2);
//    prevSnapshotViewCenter.x -= (boundsWidth - distance)*60/boundsWidth;
//    //    NSLog(@"prev center x%f",prevSnapshotViewCenter.x);
//    
//    self.currentSnapShotView.center = currentSnapshotViewCenter;
//    self.prevSnapShotView.center = prevSnapshotViewCenter;
//    self.swipingBackgoundView.alpha = (boundsWidth - distance)/boundsWidth;
//}

////////////////////////////////////////////////////////////////////////
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
    NSString * classN = [NSString stringWithFormat:@"%@",self.chatDic[@"classN"]];
     NSDictionary * dictionary = [NSDictionary dictionary];
    BOOL apply;
 if ([classN isEqualToString:@"7"])
  {
      NSString * share = [NSString stringWithFormat:@"%@",self.chatDic[@"share"]];
      apply = [share isEqualToString:@"2"];//2为求职
      switch (share.intValue) {
          case 2://求职
          {
              NSString *qz_positionstr = [NSString stringWithFormat:@"%@",self.chatDic[@"address"]];
              NSArray * positionArray = [qz_positionstr componentsSeparatedByString:@"："];
              qz_positionstr = [NSString stringWithFormat:@"%@",positionArray[positionArray.count-1]];
            dictionary = @{@"qz_id":[self.chatDic[@"jobid"] length]?self.chatDic[@"jobid"]:@"",
                                            @"qz_position":[qz_positionstr length]?qz_positionstr:@"",//dic[@"address"]
                                            @"qz_avatar":[self.chatDic[@"img_url"][0][@"small_address"] length]?self.chatDic[@"img_url"][0][@"small_address"]:@"",
                                            @"qz_name":@"",
                                            @"belong":@"",
                                            @"title":@"",
                                            @"qz_sex":[self.chatDic[@"company"] length]?self.chatDic[@"company"]:@"",
                                            @"qz_age":@"",
                                            @"qz_educaiton":@"",
                                            @"qz_workTime":@"",
                                            @"info":@""};
          }
              break;
          case 3://招聘
          {
              dictionary = @{@"zp_id":[self.chatDic[@"jobid"] length]?self.chatDic[@"jobid"]:@"",
                                                @"zp_position":[self.chatDic[@"address"] length]?self.chatDic[@"address"]:@"",
                                                @"zp_avatar":[self.chatDic[@"img_url"][0][@"small_address"] length]?self.chatDic[@"img_url"][0][@"small_address"]:@"",
                                                @"cp_name":[self.chatDic[@"company"] length]?self.chatDic[@"company"]:@"",
                                                @"belong":@"",
                                                @"title":@"",
                                                @"info":@""};
          }
              break;
          default:
              break;
      }
      
  }
 else
  {
     
    apply = [classN isEqualToString:@"6"];
   
    if (!apply)
    {
        dictionary = @{@"zp_id":[self.chatDic[@"jobid"] length]?self.chatDic[@"jobid"]:@"",
                       @"zp_position":[self.chatDic[@"title"] length]?self.chatDic[@"title"]:@"",
                       @"zp_avatar":[self.chatDic[@"img_url"][0][@"small_address"] length]?self.chatDic[@"img_url"][0][@"small_address"]:@"",
                       @"cp_name":[self.chatDic[@"company"] length]?self.chatDic[@"company"]:@"",
                       @"belong":@"",
                       @"title":@"",
                       @"info":@""};
    }
    else
    {
        dictionary = @{@"qz_id":[self.chatDic[@"jobid"] length]?self.chatDic[@"jobid"]:@"",
                       @"qz_position":[self.chatDic[@"title"] length]?self.chatDic[@"title"]:@"",
                       @"qz_avatar":[self.chatDic[@"img_url"][0][@"small_address"] length]?self.chatDic[@"img_url"][0][@"small_address"]:@"",
                       @"qz_name":@"",
                       @"belong":@"",
                       @"title":@"",
                       @"qz_sex":[self.chatDic[@"company"] length]?self.chatDic[@"company"]:@"",
                       @"qz_age":@"",
                       @"qz_educaiton":@"",
                       @"qz_workTime":@"",
                       @"info":@""};
    }
    
   }
    NSArray * array = @[dictionary];
    if (apply)
    {
        [[ChattingMainViewController shareInstance] sendMyApplyAndWant:array andApply:YES];
    }
    else
    {
        [[ChattingMainViewController shareInstance] sendMyWant:array andApply:NO];
    }
    
    NSArray * viewArray = self.navigationController.viewControllers;
    [self.navigationController popToViewController:viewArray[viewArray.count-4] animated:YES];
}
-(void)refreshData
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];
    
    //加载图片
    WPIVManager *manager = [WPIVManager sharedManager];
    manager.fk_id = self.subId;
    manager.fk_type = [NSString stringWithFormat:@"%@",self.isRecuilist==0?@"4":@"3"];
    [manager requsetForImageAndVideo];
}
#pragma mark - 请求招聘或者求职的默认信息
- (void)requestResumeInfo
{
    NSString *url =[IPADDRESS stringByAppendingString:self.isRecuilist? @"/ios/invitejob.ashx" : @"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action" : self.isRecuilist?@"GetJobSignStatus":@"GetResumeSignStatus",
                             self.isRecuilist ? @"job_id" : @"resume_id" : self.subId,
                             @"username" : kShareModel.username,
                             @"password" : kShareModel.password,
                             @"user_id" : kShareModel.userId};
    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"%@",json);
    } failure:^(NSError *error) {
        
    }];
}

- (void)initNav{
    self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.titleView.titleString = @"详情";
    self.navigationItem.titleView = self.titleView;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =self.isFromChat?[[UIBarButtonItem alloc]initWithCustomView:self.rightButton]:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}
#pragma mark 点击右侧进行分享
- (void)rightBtnClick
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
    NSDictionary *params = @{@"action":(self.isRecuilist == 0?@"oneshareresume2":@"onesharejob2"),
                             (self.isRecuilist == 0?@"resumeid":@"jobid"):self.resumeId,
                             @"user_id":kShareModel.userId,
                             };
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        if([json[@"status"] isEqualToString:@"1"]){
                [self requstModel:^(id string) {
                    [self shareWithUrl:json[@"url"] angImageStr:self.isRecuilist?[IPADDRESS stringByAppendingString:self.model.logo]:[IPADDRESS stringByAppendingString:self.model.avatar]];
                }];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)shareSuccess
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
    NSDictionary *params = @{@"action":(self.isRecuilist == 0?@"oneshareresume":@"onesharejob"),
                             (self.isRecuilist == 0?@"resumeid":@"jobid"):self.resumeId,
                             @"user_id":kShareModel.userId,
                             };
    [WPHttpTool postWithURL:str params:params success:^(id json) {
    } failure:^(NSError *error) {
    }];
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
        case DDMEssageMyWant:
            person.display_type = @"9";
            break;
        case DDMEssageMyApply:
            person.display_type = @"8";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:person animated:YES];
}
-(void)requstModel:(void(^)(id))Success
{
    NSDictionary * dic = nil;
    NSString * urlStr = nil;
    if (self.isRecuilist)//招聘
    {
        dic = @{@"action":@"GetJobDraftInfo",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"job_id":self.resumeId};
        urlStr = [NSString stringWithFormat:@"%@/ios/inviteJob.ashx",IPADDRESS];
    }
    else
    {
        dic = @{@"action":@"GetResumeInfo",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"resume_id":self.resumeId};
        urlStr = [NSString stringWithFormat:@"%@/ios/resume_new.ashx",IPADDRESS];
    }
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        if (self.isRecuilist)//招聘
        {
            WPNewResumeListModel * model = [[WPNewResumeListModel alloc]init];
            model.logo = json[@"photoList"][0][@"original_path"];
            model.enterpriseName = json[@"enterprise_name"];
            model.resumeId = self.resumeId;
            model.resume_user_id = json[@"user_id"];
            model.jobPositon = json[@"jobPositon"];
            model.enterprise_properties = json[@"enterprise_properties"];
            model.enterprise_brief = json[@"enterprise_brief"];
            model.enterprise_scale = json[@"enterprise_scale"];
            model.enterprise_address = json[@"enterprise_address"];
            model.dataIndustry = json[@"dataIndustry"];
            model.userId = json[@"user_id"];
            
            NSArray *epRemarkList = json[@"epRemarkList"];
            if (epRemarkList.count) {
                model.enterprise_brief = epRemarkList[0][@"txtcontent"];
            }
            self.model = model;
        }
        else
        {
            NSArray * jaonArray = json[@"PhotoList"];
            WPNewResumeListModel * model = [[WPNewResumeListModel alloc]init];
            model.resumeId = self.resumeId;
            model.avatar = jaonArray.count?jaonArray[0][@"original_path"]:@"";
            model.HopePosition = json[@"Hope_Position"];
            model.name = json[@"name"];
            model.sex = json[@"sex"];
            model.education = json[@"education"];
            model.WorkTim = json[@"WorkTime"];
            model.resume_user_id = json[@"user_id"];
            model.WorkTim = json[@"WorkTime"];
            model.lightspot = json[@"txtcontent"];
            model.userId = json[@"user_id"];
            self.model = model;
        }
        Success(json);
    } failure:^(NSError *error) {
    }];
}
-(void)sendeToWeiPinFriends
{
    NSDictionary * dic = nil;
    if (self.isRecuilist)
    {//招聘
        dic = @{@"zp_id":self.model.resumeId,
                @"zp_position":self.model.jobPositon,
                @"zp_avatar":self.model.logo,
                @"cp_name":[NSString stringWithFormat:@"%@",self.model.enterpriseName],
                @"belong":self.model.resume_user_id,
                @"title":@"",@"info":[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.model.enterpriseName.length?self.model.enterpriseName:@"",self.model.dataIndustry.length?self.model.dataIndustry:@"",self.model.enterprise_properties.length?self.model.enterprise_properties:@"",self.model.enterprise_scale.length?self.model.enterprise_scale:@"",self.model.enterprise_address.length?self.model.enterprise_address:@"",self.model.enterprise_brief.length?self.model.enterprise_brief:@""]};
    }
    else//求职
    {
        dic = @{@"qz_id":self.model.resumeId,
                @"qz_avatar":self.model.avatar,
                @"qz_position":self.model.HopePosition,
                @"qz_name":self.model.name,
                @"qz_sex":self.model.sex,
                @"qz_age":@"",@"qz_educaiton":self.model.education,
                @"qz_workTime":self.model.WorkTim,
                @"belong":self.model.resume_user_id,
                @"info":[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.model.name.length?self.model.name:@"",self.model.age.length?self.model.age:@"",self.model.sex.length?self.model.sex:@"", self.model.education.length?self.model.education:@"",self.model.WorkTim.length?self.model.WorkTim:@"",self.model.lightspot.length?self.model.lightspot:@""],
                @"title":@""};
    }
    
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *messageContent = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    DDMessageContentType  contentType;
    if (self.isRecuilist)
    {
       contentType = DDMEssageMyWant;
    }
    else
    {
        contentType = DDMEssageMyApply;
    }
    [self tranmitMessage:messageContent andMessageType:contentType andToUserId:@""];
}
-(void)shareWithUrl:(NSString *)urlString angImageStr:(NSString*)iageStr;
{
    NSString * briefStr = self.model.enterprise_brief;
    NSString *description1 = [WPMySecurities textFromBase64String:briefStr];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    if (description3.length) {
        self.model.enterprise_brief = description3;
    }
    
    
    
    NSString*light = self.model.lightspot;
    NSString *description4 = [WPMySecurities textFromBase64String:light];
    NSString *description5 = [WPMySecurities textFromEmojiString:description4];
    if (description5.length) {
        self.model.lightspot = description5;
    }
    
    urlString = [IPADDRESS stringByAppendingString:urlString];
    NSString * firstStr = nil;
    NSString * secondStr = nil;
    if (self.isRecuilist)
    {//招聘
        firstStr = [NSString stringWithFormat:@"招聘:%@",self.model.jobPositon];
        secondStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.model.enterpriseName.length?self.model.enterpriseName:@"",self.model.dataIndustry.length?self.model.dataIndustry:@"",self.model.enterprise_properties.length?self.model.enterprise_properties:@"",self.model.enterprise_scale.length?self.model.enterprise_scale:@"",self.model.enterprise_address.length?self.model.enterprise_address:@"",self.model.enterprise_brief.length?self.model.enterprise_brief:@""];
    }
    else
    {
        firstStr = [NSString stringWithFormat:@"求职:%@",self.model.HopePosition];
        secondStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.model.name.length?self.model.name:@"",self.model.age.length?self.model.age:@"",self.model.sex.length?self.model.sex:@"",self.model.education.length?self.model.education:@"",self.model.WorkTim.length?self.model.WorkTim:@"",self.model.lightspot];
    }
    
    NSString * titleStr = [NSString stringWithFormat:@"%@|%@|%@",firstStr,secondStr,iageStr];
    [YYShareManager newShareWithTitle:titleStr url:urlString action:^(YYShareManagerType type) {
        if (type == YYShareManagerTypeWeiPinFriends)
        {
            [self sendeToWeiPinFriends];
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
            if(self.isRecuilist == WPMainPositionTypeRecruit){
                if (jobids.length == 0) {
                    jobids = _model.resumeId;
                }else{
                    jobids = [NSString stringWithFormat:@"%@,%@",jobids,_model.resumeId];
                }
//                share_title = [@"招聘:" stringByAppendingString:_model.jobPositon];
                share_title = [NSString stringWithFormat:@"招聘:%@",_model.jobPositon];
                if (!_model.avatar) {
                    _model.avatar = @"";
                }
                [jobPhoto addObject:@{@"small_address":_model.avatar}];
                name = _model.enterpriseName;
                
                i ++;
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"jobNo":[NSString stringWithFormat:@"%d",i],
                                                                                           @"jobids":jobids,
                                                                                           @"share":[NSString stringWithFormat:@"%d",3],
                                                                                           @"shareMsg":@{@"jobPhoto":jobPhoto,
                                                                                                         @"share_title":share_title,
                                                                                                         @"name":name}}];
                
                share.shareInfo = dic;
            }else{
                if (jobids.length == 0) {
                    jobids = _model.resumeId;
                }else{
                    jobids = [NSString stringWithFormat:@"%@,%@",jobids,_model.resumeId];
                }
//                share_title = [@"求职:" stringByAppendingString:_model.HopePosition];
                share_title  = [NSString stringWithFormat:@"求职:%@",_model.HopePosition];
                if (!_model.avatar) {
                    _model.avatar = @"";
                }
                [jobPhoto addObject:@{@"small_address":_model.avatar}];
                name = _model.name;
                sex = _model.sex;
                birthday = _model.birthday.length?_model.birthday:@"";
                education = _model.education;
                workTime = _model.WorkTim;
                i ++;
                //                }
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
                [MBProgressHUD createHUD:@"分享成功" View:self.view];
                [self shareSuccess];
            };
            [self.navigationController pushViewController:share animated:YES];
        }
        if (type == YYShareManagerTypeCollect) {//点击进行收藏
            [self performSelector:@selector(collection) withObject:nil afterDelay:0.2];
        }
        if (type == YYShareManagerTypeReport) {//点击进行举报
            [self performSelector:@selector(gotoReport) withObject:nil afterDelay:0.2];
        }
    } status:^(UMSocialShareResponse* status) {
//        if (status == UMSResponseCodeSuccess) {
//        }
    }];
}
-(void)gotoReport
{
    ReportViewController *report = [[ReportViewController alloc] init];
//    report.speak_trends_id = self.info[@"sid"];
    report.speak_trends_id = self.subId;
    report.type = ReportTypeDynamice;
    [self.navigationController pushViewController:report animated:YES];
}
/*- (NSDictionary *)getDictionaryForWorklineWithModelArray:(NSArray *)modelArray
{
    NSString *jobids;
    NSString *share_title;
    NSString *name;
    NSString *sex;
    NSString *birthday;
    NSString *education;
    NSString *workTime;
    for (WPNewResumeListModel *model in modelArray) {
        if (jobids.length == 0) {
            jobids = model.resumeId;
        }else{
            jobids = [NSString stringWithFormat:@"%@,%@",jobids,model.resumeId];
        }
        if (modelArray.count>1) {
            if (share_title.length == 0) {
                share_title = model.resumeId;
            }else{
                share_title = [NSString stringWithFormat:@"%@,%@",share_title,model.name];
            }
        }
    }
    
    NSDictionary *dic = @{@"jobNo":@"1",
                          @"jobids":self.model.resumeId,
                          @"share":[NSString stringWithFormat:@"%d",self.isRecuilist+2],
                          @"shareMsg":@{@"jobPhoto":@[@{@"small_adress":self.model.avatar}],
                                        @"share_title":self.model.HopePosition,
                                        @"name":self.model.name,
                                        @"sex":self.model.sex,
                                        @"birthday":self.model.birthday,
                                        @"education":self.model.education,
                                        @"WorkTime":self.model.WorkTim}};
    return dic;
}*/

- (UIButton *)editButton
{
    if (!_editButton) {
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.editButton.frame = CGRectMake(0, SCREEN_HEIGHT-kHEIGHT(42), SCREEN_WIDTH, kHEIGHT(42));
        [self.editButton setTitle:@"查看" forState:UIControlStateNormal];
        self.editButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
//        [self.editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.editButton setImage:[UIImage imageNamed:@"common_chakan"] forState:UIControlStateNormal];
        [self.editButton setBackgroundImage:[UIImage imageWithColor:RGB(0, 146, 217) size:CGSizeMake(SCREEN_WIDTH, kHEIGHT(42))] forState:UIControlStateHighlighted];
        [self.editButton setBackgroundImage:[UIImage imageWithColor:RGB(0, 172, 255) size:CGSizeMake(SCREEN_WIDTH, kHEIGHT(42))] forState:UIControlStateNormal];
        [self.editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchDown];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        view.backgroundColor = RGB(178, 178, 178);
        [self.editButton addSubview:view];
    }
    return _editButton;
}
#pragma mark 查看自己的简历
- (void)editButtonAction:(UIButton *)sender
{
//    WPNewMeResumeController *resume = [[WPNewMeResumeController alloc]init];
//    resume.type = WPNewMeResumeTypeInterview;
//    [self.navigationController pushViewController:resume animated:YES];

    WPNewCheckController *check = [[WPNewCheckController alloc]init];
    check.type = self.isRecuilist;
    check.resumeId = self.resumeId;
    check.model = self.model;
    check.subId = self.subId;
    check.isRecuilist = self.isRecuilist;
    [self.navigationController pushViewController:check animated:YES];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
//    [MBProgressHUD showMessage:@"" toView:self.view];
    [self.titleView.activity startAnimating];
}
-(NSString*)getVideoPath:(NSString*)filePath
{
    NSArray * pathArray = [filePath componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
   BOOL isOrNOt = [[NSFileManager defaultManager] fileExistsAtPath:fileName1];
    if (isOrNOt) {
      return fileName1;
    }
    else
    {
      return @"";
    }
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    [self pushCurrentSnapshotViewWithRequest:request];
    NSString *str = request.URL.relativeString;
    NSArray *array = [str componentsSeparatedByString:@"="];
    if ([array[0]isEqualToString:[NSString stringWithFormat:@"%@/webMobile/November/PhotoAndVideo.aspx?img_path",IPADDRESS]]) {//点击图片
        NSString *urlstr1 = array[1];
        NSArray *arr2 = [urlstr1 componentsSeparatedByString:@"&"];
        NSString *mediaType = arr2[0];
        if ([mediaType hasSuffix:@".mp4"]) {
            NSString * path = [self getVideoPath:[IPADDRESS stringByAppendingString:mediaType]];
            if (!path.length) {
                [MBProgressHUD showMessage:@"" toView:self.view];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    WPDownLoadVideo * video = [[WPDownLoadVideo alloc]init];
                    [video downLoadVideo:[IPADDRESS stringByAppendingString:mediaType] success:^(id response) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       NSString* string = [self getVideoPath:[IPADDRESS stringByAppendingString:mediaType]];
                        [MBProgressHUD hideHUDForView:self.view];
                        VideoBrowser *video = [[VideoBrowser alloc] init];
                        video.videoUrl = string;
                        video.isNetOrNot = NO;
                        video.isCreat = YES;
                        video.addLongPress = YES;
                        [video showPickerVc:self];
                    });
                    } failed:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:self.view];
                            [MBProgressHUD createHUD:@"获取失败" View:self.view];
                            
                        });
                    } progress:^(NSProgress *progreee) {
                    }];
                });
            }
            else
            {
                VideoBrowser *video = [[VideoBrowser alloc] init];
                video.videoUrl = path;
                video.isNetOrNot = NO;
                video.isCreat = YES;
                video.addLongPress = YES;
                [video showPickerVc:self];
            }
        } else {
            NSArray *images = [WPIVManager sharedManager].model.ImgPhoto;
            if (!images.count) {
                [MBProgressHUD createHUD:@"图片获取失败" View:self.view];
                return NO;
            }
            [self showPhotoBrowserWithPhotoArray:images url:arr2[0]];
        }
        return NO;
    }else if ([array[0] isEqualToString:[NSString stringWithFormat:@"%@/webMobile/November/PhotoAndVideo.aspx?fk_id",IPADDRESS]]){
        WPIVManager *sharedManager = [WPIVManager sharedManager];
        NSMutableArray * photoArray = [NSMutableArray array];
        NSArray * array = sharedManager.model.ImgPhoto;
        [photoArray addObjectsFromArray:array];
        NSMutableArray * videoArray = [NSMutableArray array];
        NSArray * array1 = sharedManager.model.VideoPhoto;
        [videoArray addObjectsFromArray:array1];
        SAYVideoManagerViewController *vc = [[SAYVideoManagerViewController alloc]init];
        vc.arr = photoArray;
        vc.videoArr = videoArray;
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:navc animated:YES completion:nil];
        return NO;
    }
    else if ([array[0] isEqualToString:[NSString stringWithFormat:@"%@/webMobile/November/recruit_info.aspx?recruit_id",IPADDRESS]] && ![str isEqualToString:self.urlStr])
    {
        
        WPApplyViewController * apply = [[WPApplyViewController alloc]init];
        apply.urlStr = [NSString stringWithFormat:@"%@&isVisible=1",str];
//        apply.model = self.detailModel;
        WPHotCompanyListModel * hotModel = [[WPHotCompanyListModel alloc]init];
        hotModel.userId = self.model.userId;
        hotModel.logo = self.model.logo;
        apply.model = hotModel;
        apply.listModel = self.model;
        NSArray * array5 = [array[1] componentsSeparatedByString:@"&"];
        apply.applyID = [NSString stringWithFormat:@"%@",array5[0]];
        [self.navigationController pushViewController:apply animated:YES];
        return NO;
//        if (_urlString.length)
//        {
//           
//        }
//        else
//        {
//            self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//            self.titleView.titleString = @"职位详情";
//            self.navigationItem.titleView = self.titleView;
//            self.isSame = YES;
//            
//            str = [NSString stringWithFormat:@"%@&isVisible=1",str];
//            [UIView animateWithDuration:0.5 animations:^{
//                
//                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
//                _urlString = str;
//                [self.webView loadRequest:request];
//            }];
//        }
    }
    else if (![str isEqualToString:self.urlStr]) {
        
        NSArray * array = [str componentsSeparatedByString:@"?"];
        if ([array containsObject:[NSString stringWithFormat:@"%@/webMobile/November/show_GDmap.aspx",IPADDRESS]]) {
            WPMapViewController * map = [[WPMapViewController alloc]init];
            map.mapUrl = str;
            [self.navigationController pushViewController:map animated:YES];
        }
        else
        {
//           [self pushPersonalResumeListControllerWithUserId:array[1]];
            
            NSArray * array1 = [str componentsSeparatedByString:@"="];
            PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
            personInfo.comeFromVc = @"自己判断";
            personInfo.friendID = array1[1];
            [self.navigationController pushViewController:personInfo animated:YES];
            
            
        }
        
//        [self pushPersonalResumeListControllerWithUserId:array[1]];
        return NO;
    }
    return YES;
}
-(void)backToFromViewController:(UIButton *)sender
{
    if (self.isSame)
    {
        
        self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        self.titleView.titleString = @"详情";
        self.navigationItem.titleView = self.titleView;
        self.isSame = NO;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
        [_webView loadRequest:request];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_async(dispatch_get_main_queue(), ^{
//       [MBProgressHUD hideHUDForView:self.view];
        [self.titleView.activity stopAnimating];
    });
    
    
    [self.webView stopLoading];
//    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
}
- (NSMutableArray *)array
{
    if (!_array) {
        self.array = [NSMutableArray array];
    }
    return _array;
}

- (void)removeAllImageViews
{
    for (UIImageView *imageView in self.array) {
        [imageView removeFromSuperview];
    }
}

- (void)showPhotoBrowserWithPhotoArray:(NSArray *)array url:(NSString *)urlStr
{
    NSInteger count = array.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    [self removeAllImageViews];
    for (int i = 0; i<array.count; i++) {
        Pohotolist *list = array[i];
        NSString *url = [IPADDRESS stringByAppendingString:list.original_path];
        
        MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:url];
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        imageView.frame = CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43));
        imageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [self.view addSubview:imageView];
        photo.toView = imageView;
        [self.array addObject:imageView];
        [self.view sendSubviewToBack:imageView];
        [photos addObject:photo];
    }
    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
    // 缩放动画
    photoBrowser.status = UIViewAnimationAnimationStatusZoom;
    photoBrowser.isNewZoom = YES;
    photoBrowser.photos = photos;
    photoBrowser.isNeedShow = YES;
    // 当前选中的值
    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:[self getCurrentIndexPathWithUrl:urlStr] inSection:0];
    // 展示控制器
    [photoBrowser showPickerVc:self];
//    [photoBrowser show];
}

- (NSInteger)getCurrentIndexPathWithUrl:(NSString *)urlStr
{
    int i = 0;
    for (Pohotolist *model in [WPIVManager sharedManager].model.ImgPhoto) {
        if ([model.original_path isEqualToString:urlStr]) {
            return i;
        }
        i++;
    }
    return 0;
}

- (void)pushPersonalResumeListControllerWithUserId:(NSString *)userid
{
    PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
    personInfo.comeFromVc = @"自己判断";
    personInfo.friendID = userid;
    [self.navigationController pushViewController:personInfo animated:YES];
//    WPPersonalResumeListController *list = [[WPPersonalResumeListController alloc]init];
//    list.userId = userid;
//    if (_isRecuilist == 0)list.isRecruit = NO;
//    if (_isRecuilist > 0)list.isRecruit = YES;
//    list.isSelf = self.isSelf;
//    list.isFromCompanyGiveList = self.isFromCompanyGive;
//    list.personalApplyList = self.personalApply;
//    
//    list.isFromMyApply = self.isFromMyApply;
//    list.isFromMyRobList = self.isFromMyRob;
//    [self.navigationController pushViewController:list animated:YES];
}
// 四个 button 用 isRecuilist 属性确定 "申请" "抢人"
-(NearInterViewFourButton *)bottomView{
    if (!_bottomView) {
        _bottomView = [[NearInterViewFourButton alloc]initWithFrame:CGRectMake(0, self.baseView.height-49, SCREEN_WIDTH, 49)];
        _bottomView.delegate = self;
        self.bottomView.isRecuilist = _isRecuilist;
        [self getCurrentStateOfBottomView];
        [self.baseView addSubview:_bottomView];
    }
    return _bottomView;
}

// 获取简历投递状态 , 确定 "已申请 . 已抢人" 或 "申请 . 抢人"
- (void)getCurrentStateOfBottomView
{
    if (_isRecuilist) {
        [self getJobSignStatus];//获取职位申请状态
//        if (_isFromCompanGive) {
//             [self getJobSignStatus];
//          
//        }
//        else
//        {
//             [self getResumeSignStatus];
//        }
    }else{
        [self getResumeSignStatus];//获取简历抢人状态
//        if (_isFromCompanGive) {
//            
//            [self getResumeSignStatus];
//        }
//        else
//        {
//            [self getJobSignStatus];
//        }
    }
}

- (void)getJobSignStatus
{
    [[RequestManager shareManager]getJobSignStatusWithJobid:self.subId status:^(id json) {
        [self pageEffectWithJson:json];
    }fail:^(NSError *error) {
        
    }];
}

- (void)getResumeSignStatus
{
    [[RequestManager shareManager]getJobSignStatusWithJobid:self.subId status:^(id json) {
        [self pageEffectWithJson:json];
    }fail:^(NSError *error) {
        
    }];
}

- (void)pageEffectWithJson:(NSDictionary *)json
{
    if ([json[@"status"] intValue]) {
        [MBProgressHUD showError:@"未获取到投递状态"];
    }else{
        if (![json[@"signStatus"]intValue]) {
            // 可以点击投递简历 button显示"申请" selected应为NO
            self.bottomView.aplly = NO;
            NSLog(@"可以点击投递简历%d",[json[@"signStatus"]intValue]);
        }else{
            // 可以点击取消投递 button显示"已申请" selected应为YES
//            self.bottomView.aplly = YES;
            NSLog(@"可以点击取消投递%d",[json[@"signStatus"]intValue]);
        }
    }
}

//- (UIView *)bottomChatView{
//    if (!_bottomChatView) {
//        _bottomChatView = [[UIView alloc]initWithFrame:CGRectMake(0, self.scrollView.height-49, SCREEN_WIDTH, 49)];
////        SPButton *button = [[SPButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49) title:@"聊聊" ImageName:@"liaoliao" Target:self Action:@selector(chatClick:)];
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
//        [button setTitle:@"  聊聊" forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"common_liaoliao"] forState:UIControlStateNormal];
//        button.titleLabel.tintColor = RGB(0, 0, 0);
//        [button setBackgroundImage:[UIImage imageWithColor:RGB(0, 172, 255) size:CGSizeMake(SCREEN_WIDTH, 49)] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageWithColor:RGB(0, 146, 217) size:CGSizeMake(SCREEN_WIDTH, 49)] forState:UIControlStateHighlighted];
//        button.tag = 100;
//        [_bottomChatView addSubview:button];
//        
//        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//        line.backgroundColor = RGB(178, 178, 178);
//        [_bottomChatView addSubview:line];
//        
//        [self.scrollView addSubview:_bottomChatView];
//    }
//    return _bottomChatView;
//}
/*
- (UIView *)bottomEditView{
    if (!_bottomEditView) {
        _bottomEditView = [[UIView alloc]initWithFrame:CGRectMake(0, self.scrollView.height-49, SCREEN_WIDTH, 49)];
        SPButton *button = [[SPButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49) title:@"编辑" ImageName:@"bianji" Target:self Action:@selector(editClick:)];
        button.contentLabel.textColor = RGB(0, 0, 0);
        button.tag = 100;
        [_bottomEditView addSubview:button];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomEditView addSubview:line];
        
        [self.scrollView addSubview:_bottomEditView];
    }
    return _bottomChatView;
}

- (UIView *)bottomManagerView{
    if (!_bottomManagerView) {
        _bottomManagerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.scrollView.height-49, SCREEN_WIDTH, 49)];
        SPButton *button = [[SPButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49) title:@"查看" ImageName:@"chakan" Target:self Action:@selector(editClick:)];
        button.contentLabel.textColor = RGB(0, 0, 0);
        button.tag = 100;
        [_bottomManagerView addSubview:button];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomManagerView addSubview:line];
        
        [self.scrollView addSubview:_bottomManagerView];
    }
    return _bottomManagerView;
}*/

- (UIView *)messageView
{
    if (!_messageView) {
        
        _messageView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 49)];
        _messageView.backgroundColor = RGB(235, 235, 235);
        [self.baseView addSubview:_messageView];
        
        UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-49-10, 49)];
        text.placeholder = @"发送消息";
        text.tag = 50;
        text.delegate = self;
        text.returnKeyType = UIReturnKeyDone;
        
        [_messageView addSubview:text];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH-49, 0, 49, 49);
        button.titleLabel.font = kFONT(15);
        [button setTitle:@"发送" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sendmessageClick:) forControlEvents:UIControlEventTouchUpInside];
        [_messageView addSubview:button];
    }
    return _messageView;
}

- (void)sendmessageClick:(UIButton *)sender
{
    //获取键盘的高度
    UITextField *text = (UITextField *)[self.view viewWithTag:50];
    if (![text.text isEqualToString:@""]) {
        self.messageView.frame = CGRectMake(0, SCREEN_HEIGHT-64, SCREEN_WIDTH, 49);
        [text resignFirstResponder];
        [self AddRecruitComment];
    }else{
//        [MBProgressHUD createHUD:@"请输入发送内容" View:self.view];
    }
}
#pragma mark -- 点击申请 推出填写个人信息方法
- (void)requestRecruitGetApplyCondition{
    WPRecruitApplyController *apply = [[WPRecruitApplyController alloc] init];
    apply.applySuccess = ^(){
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"个人求职简历申请成功，请加对方为好友，以便后续联系方便，谢谢使用快捷招聘，网络求职需谨慎，谨防招聘骗局，如发现违法求职者请及时报警和举报！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    };
    apply.title = @"申请";
    apply.delegate = self;
    apply.sid = self.subId;
//    apply.isApplyFromDetail = YES;
    apply.isFromCompanyGive = self.isFromCompanyGive;
    if (self.isFromCompanyGive) {
        apply.isApplyFromDetail = NO;
    }
    else
    {
        apply.isApplyFromDetail = YES;
    }
    
    //从收藏中申请
    apply.isFromcollection = self.isFromCollection;
    apply.isApplyFromDetail = self.isFromCollection?NO:YES;
    
    apply.isFromMuchcollection = self.isFromMuchCollection;
    apply.isApplyFromDetail = self.isFromMuchCollection?NO:YES;
    [self.navigationController pushViewController:apply animated:YES];
}
#pragma mark -- 点击抢人 推出填写个人信息方法 可与上合并
- (void)requestInterviewGetApplyCondition{
    WPInterviewApplyController *Interview = [[WPInterviewApplyController alloc] init];
    Interview.delegate = self;
    Interview.sid = self.subId;
    Interview.robSuccess = ^(){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"企业招聘发布邀请成功，请加对方为好友，以便后续联系方便，谢谢使用快捷招聘，网络招聘需谨慎，谨防求职骗局，如发现违法招聘请及时报警和举报！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    };
    
    Interview.personalApply = self.personalApply;
    Interview.isFromMyRob  = self.isFromMyRob;
    Interview.isFromCollection = self.isFromCollection;
    Interview.isFromMuchCollection = self.isFromMuchCollection;
    
    
    if (Interview.personalApply) {
       Interview.personIsFromDetail = NO;//用于直接选择简历
        Interview.isFromDetail = NO;//用于选择企业
    }
    else
    {
       Interview.personIsFromDetail = YES;//用于直接选择简历
        Interview.isFromDetail = YES;//用于选择企业
    }
    
    if (Interview.isFromMyRob) {
        Interview.personIsFromDetail = NO;//用于直接选择简历
        Interview.isFromDetail = NO;//用于选择企业
    }
    else
    {
        Interview.personIsFromDetail = YES;//用于直接选择简历
        Interview.isFromDetail = YES;//用于选择企业
    }
    
    if (Interview.isFromCollection) {
        Interview.personIsFromDetail = NO;//用于直接选择简历
        Interview.isFromDetail = NO;//用于选择企业
    }
    else
    {
        Interview.personIsFromDetail = YES;//用于直接选择简历
        Interview.isFromDetail = YES;//用于选择企业
    }
    if (Interview.isFromMuchCollection) {
        Interview.personIsFromDetail = NO;//用于直接选择简历
        Interview.isFromDetail = NO;//用于选择企业
    }
    else
    {
        Interview.personIsFromDetail = YES;//用于直接选择简历
        Interview.isFromDetail = YES;//用于选择企业
    }
    
    [self.navigationController pushViewController:Interview animated:YES];
}

- (void)AddRecruitComment{
    NSString *action = self.isRecuilist?@"AddRecruitComment":@"AddResumeComment";
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/invitejob.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    UITextField *text = (UITextField *)[self.view viewWithTag:50];
    NSDictionary *params = @{@"action":action,
                             @"username":model.username,
                             @"password":model.password,
                             @"jobId":self.subId,
                             @"CommentContent":text.text};
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
        if (![json[@"status"] integerValue]) {
            text.text = @"";
            [_webView reload];
        }else{
            [MBProgressHUD showError:@"留言失败，请重试" toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"服务器错误" toView:self.view];
    }];
}

#pragma mark - 获取报名状态
- (void)getRecruitApplyMessage{
//    if (_isRecuilist) {
        NSString *str = [IPADDRESS stringByAppendingString:(_isRecuilist?@"/ios/invitejob.ashx":@"/ios/resume_new.ashx")];
        WPShareModel *model = [WPShareModel sharedModel];
        
        NSDictionary *params = @{@"action":(_isRecuilist?@"GetJobSignStatus":@"GetResumeSignStatus"),
                                 @"username":model.username,
                                 @"password":model.password,
                                 @"user_id":model.dic[@"userid"],
                                 (_isRecuilist?@"job_id":@"resume_id"):self.subId};
        [WPHttpTool postWithURL:str params:params success:^(id json) {
//            NSLog(@"%@",json);
            self.detailModel = [WPResumeAndInviteDetailModel mj_objectWithKeyValues:json];
            SPButton *button = (SPButton *)[self.view viewWithTag:WPInterViewOperationTypeApply];
            switch ([json[@"signStatus"] integerValue]) {
                case 0:
                    button.contentLabel.text = _isRecuilist?@"申请":@"抢人";
                    break;
                case 1:
//                    button.contentLabel.text = _isRecuilist?@"已申请":@"已抢";
                    button.contentLabel.text = _isRecuilist?@"申请":@"抢人";
                    break;
                case 2:
                    button.contentLabel.text = @"已通过";
                    break;
                default:
                    break;
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
}
#pragma mark -- 该页面 下三个按钮 推出下一个页面方法
- (void)delegateActionWithIndex:(NSInteger)index
{
    switch (index) {
            //聊天
        case 0:
            [self chat];
            break;
            //查看
        case 3:
            [self message];
            break;
        case 2:
        {
            [self requstModel:^(id string) {
                [self collection];
            }];
//            [self collection];
        }
            break;
            //申请
        case 1:
            [self applyTouchAction];
            break;
        default:
            break;
    }
}

//- (void)chatClick:(UIButton *)sender{
//    NSLog(@"非本公司聊天");
//}
/*
- (void)editClick:(UIButton *)sender{
    switch (_isRecuilist) {
        case 0:
            NSLog(@"求职编辑");
            if (_isSelf) {
                WPPersonalResumeListController *list = [[WPPersonalResumeListController alloc]init];
                list.userId = self.userId;
                list.resumeId = self.subId;
                list.isSelf = _isSelf;
                list.isRecruit = _isRecuilist;
                [self.navigationController pushViewController:list animated:YES];
            }else{
                [self message];
            }
            break;
        case 1:
            if (_isSelf) {
                WPPersonalResumeListController *list = [[WPPersonalResumeListController alloc]init];
                list.userId = self.userId;
                list.resumeId = self.subId;
                list.isSelf = _isSelf;
                list.isRecruit = _isRecuilist;
                [self.navigationController pushViewController:list animated:YES];
            }else{
                
                [self message];
            }
            break;
        case 2:
            NSLog(@"企业编辑");
            break;
        default:
            break;
    }
}*/

- (void)chat{
    [self requireDataWithAciont];
//    NSString *str = [IPADDRESS stringByAppendingString:(_isRecuilist?@"/ios/invitejob.ashx":@"/ios/resume_new.ashx")];
//    WPShareModel *model = [WPShareModel sharedModel];
//    
//    NSDictionary *params = @{@"action":(_isRecuilist?@"GetJobSignStatus":@"GetResumeSignStatus"),
//                             @"username":model.username,
//                             @"password":model.password,
//                             @"user_id":model.dic[@"userid"],
//                             (_isRecuilist?@"job_id":@"resume_id"):self.subId};
//    [WPHttpTool postWithURL:str params:params success:^(id json) {
//        MTTSessionEntity *session = [[MTTSessionEntity alloc]initWithSessionID:[NSString stringWithFormat:@"user_%@",self.userId] type:SessionTypeSessionTypeSingle];
//        ChattingMainViewController *chat = [ChattingMainViewController shareInstance];
//        [chat showChattingContentForSession:session];
//        [self.navigationController pushViewController:chat animated:YES];
//
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
}
#pragma mark 获取好友信息
- (void)requireDataWithAciont
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/friend.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"GetFriend";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSDictionary * dic = (NSDictionary*)json;
        NSArray * list = dic[@"list"];
        BOOL isOrNot = NO;
        if (list.count)
        {
            for (NSDictionary* dictory in list) {
                NSString * friend_id = [NSString stringWithFormat:@"%@",dictory[@"friend_id"]];
                if ([friend_id isEqualToString:self.userId]) {
                    isOrNot = YES;
                }
                else
                {}
            }
            if (isOrNot) {
                MTTSessionEntity *session = [[MTTSessionEntity alloc]initWithSessionID:[NSString stringWithFormat:@"user_%@",self.userId] type:SessionTypeSessionTypeSingle];
                if (self.isFromChatClick)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"POPFROMINTERVIEW" object:session];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    ChattingMainViewController *chat = [ChattingMainViewController shareInstance];
                    [chat showChattingContentForSession:session];
                    [self.navigationController pushViewController:chat animated:YES];
                }
                
//                ChattingMainViewController *chat = [ChattingMainViewController shareInstance];
//                [chat showChattingContentForSession:session];
//                [self.navigationController pushViewController:chat animated:YES];

            }//不是好友则跳到添加页面
            else
            {
                PersonalInfoViewController * person = [[PersonalInfoViewController alloc]init];
                person.friendID = self.userId;
                person.newType = NewRelationshipTypeStranger;
                [self.navigationController pushViewController:person animated:YES];
            }
        }
        else//通讯录中没有好友跳到添加页面
        {
            PersonalInfoViewController * person = [[PersonalInfoViewController alloc]init];
            person.friendID = self.userId;
            person.newType = NewRelationshipTypeStranger;
            [self.navigationController pushViewController:person animated:YES];
        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
    }];
}
#pragma mark - 查看简历或招聘
- (void)message{
    WPResumeCheckController *resume = [[WPResumeCheckController alloc]init];
//    resume.title = @"查看";
    resume.resumeId = self.subId;
    resume.userId = self.userId;
    resume.isRecruit = self.isRecuilist;
    resume.model = self.model;
    resume.detailModel = self.detailModel;
    resume.isFromShuoShuo = YES;
    resume.isComeFromDynamic = self.isComeFromDynamic;
    SPButton *button = (SPButton *)[self.view viewWithTag:WPInterViewOperationTypeApply];
    if ([button.contentLabel.text isEqualToString:(_isRecuilist?@"申请":@"抢人")]) {
        resume.isApply = NO;
    }
    if ([button.contentLabel.text isEqualToString:(_isRecuilist?@"已申请":@"已抢")]) {
        resume.isApply = YES;
    }
    [self.navigationController pushViewController:resume animated:YES];
}
// 收藏方法
- (void)collection
{
    
    //收藏匿名
    NSString * col3 = nil;
    if (self.isNiMing) {
        col3 = [NSString stringWithFormat:@"%@,%@,%@",self.shareDic[@"nick_name"],self.shareDic[@"POSITION"],self.shareDic[@"avatar"]];
    }
    CollectViewController *VC = [[CollectViewController alloc]init];
    if (_isRecuilist) {
        VC.titles = self.model.jobPositon;
        VC.companys = self.model.enterpriseName;
        VC.jobid = self.model.resumeId;
        VC.collect_class = @"5";
        VC.user_id = self.model.userId;
        VC.img_url = [self getImageString:self.model.logo];
    }else{
        VC.titles = self.model.HopePosition;
        VC.companys = [NSString stringWithFormat:@"%@ %@ %@ %@",self.model.name,self.model.sex,self.model.education,self.model.WorkTim];
        VC.jobid = self.model.resumeId;
        VC.collect_class = @"6";
        VC.user_id = self.model.userId;
       VC.img_url = [self getImageString:self.model.avatar];
    }
    if (col3.length) {
        VC.col3 = col3;
    }
    VC.collectSuccessBlock = ^(){
    };
    [self.navigationController pushViewController:VC animated:YES];
}
-(NSString*)getImageString:(NSString*)image
{
    NSArray * array = [image componentsSeparatedByString:@"/"];
    NSString * lastStr = array[array.count-1];
    lastStr = [@"thumb_" stringByAppendingString:lastStr];
    NSMutableArray * muarray = [NSMutableArray array];
    [muarray addObjectsFromArray:array];
    [muarray replaceObjectAtIndex:array.count-1 withObject:lastStr];
    return [muarray componentsJoinedByString:@"/"];
}
- (void)applyTouchAction{
    UIButton *button = self.bottomView.buttonArr[1];
    if (!button.selected) {
        _isRecuilist?[self requestRecruitGetApplyCondition]:[self requestInterviewGetApplyCondition];
    }else
    {
        [SPAlert alertControllerWithTitle:@"提示" message:(_isRecuilist?@"是否取消已申请？":@"是否取消已抢？") superController:self cancelButtonTitle:@"否" cancelAction:nil defaultButtonTitle:@"是" defaultAction:^{
            if (_isRecuilist) {
                [[RequestManager shareManager]cancelApplicationJobWithJobid:self.subId status:^(id json) {
                    [self cancelActionWithJson:json];
                } fail:^(NSError *error) {
                    
                }];
            }else{
                [[RequestManager shareManager]cancelApplicationResumeWithResumeid:self.subId status:^(id json) {
                    [self cancelActionWithJson:json];
                } fail:^(NSError *error) {
                    
                }];
            }
        }];
        
    }
    if ([button.titleLabel.text isEqualToString:@"已通过"]) {
        NSLog(@"已通过");
    }
    
}

- (void)cancelActionWithJson:(NSDictionary *)json
{
    UIButton *button = self.bottomView.buttonArr[1];
    if (![json[@"status"] integerValue]) {
        button.selected = NO;
    }else{
        [MBProgressHUD showError:json[@"info"] toView:self.view];
    }
}

- (void)refreshApplyState{
//    SPButton *button = (SPButton *)[self.view viewWithTag:WPInterViewOperationTypeApply];
//    button.contentLabel.text = (_isRecuilist?@"已申请":@"已抢");
}

- (void)recruitApplyDelegate{
//    SPButton *button = (SPButton *)[self.view viewWithTag:WPInterViewOperationTypeApply];
//    button.contentLabel.text = (_isRecuilist?@"已申请":@"已抢");
}

- (void)interviewApplyDelegate{
//    SPButton *button = (SPButton *)[self.view viewWithTag:WPInterViewOperationTypeApply];
//    button.contentLabel.text = (_isRecuilist?@"已申请":@"已抢");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];
    if (self.title.length > 0) {
        return;
    }
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void)dealloc
{
    _webViewProgress = nil;
    [_webViewProgressView removeFromSuperview];
}

#pragma mark -- 懒加载代码

- (UIView *)baseView{
    if (!_baseView) {
        self.baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    }
    return _baseView;
}


- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];//self.webView
        _webView.detectsPhoneNumbers=NO;
       
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
        
        [_webView loadRequest:request];
//        _webView.delegate = self.webViewProgress;
        _webView.scrollView.delegate = self;
        _webView.scalesPageToFit = YES;
        
        
        _webView.delegate = self;
        //固定网页不让其上下滑动
        UIScrollView *scroller = [_webView.subviews objectAtIndex:0];
        if (scroller){
            scroller.bounces = NO;
            scroller.alwaysBounceVertical = NO;
            scroller.alwaysBounceHorizontal = NO;
        }
//        [_webView addGestureRecognizer:self.swipePanGesture];

        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:nil];
        longPress.delegate = self;
        longPress.minimumPressDuration = 0.4;//必须设定为0.4
        [_webView addGestureRecognizer:longPress];
        _webView.userInteractionEnabled = YES;
        
    }
    return _webView;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return NO;
    }
    return  YES;
}
- (NJKWebViewProgressView *)webViewProgressView
{
    if (!_webViewProgressView) {
        CGRect navBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0,navBounds.size.height - 2,navBounds.size.width,2);
        
        self.webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        self.webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.webViewProgressView setProgress:0 animated:YES];
    }
    return _webViewProgressView;
}

- (NJKWebViewProgress *)webViewProgress
{
    if (!_webViewProgress) {
        self.webViewProgress = [[NJKWebViewProgress alloc] init];
        self.webViewProgress.webViewProxyDelegate = self;
        self.webViewProgress.progressDelegate = self;
    }
    return _webViewProgress;
}

@end
