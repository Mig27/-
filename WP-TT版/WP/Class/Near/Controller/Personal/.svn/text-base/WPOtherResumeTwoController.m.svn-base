//
//  WPOtherResumeTwoController.m
//  WP
//
//  Created by CBCCBC on 15/12/30.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPOtherResumeTwoController.h"
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
#import "MTTSessionEntity.h"
#import "PersonalInfoViewController.h"
#import "ChattingMainViewController.h"
#import "CollectViewController.h"
#import "VideoBrowser.h"
#import "WPIVManager.h"
#import "WPDetailPhotoViewController.h"
#import "MLPhotoBrowserPhoto.h"
#import "MLPhotoBrowserViewController.h"
#import "WPNewCheckController.h"
#import "YYShareManager.h"
#import "RecentPersonController.h"
#import "ShareEditeViewController.h"
#import "ReportViewController.h"
#import "SAYVideoManagerViewController.h"
#import "WPRecentLinkManController.h"
#import "SessionModule.h"
#import "WPSendToFriends.h"
#import "WPTitleView.h"
//#import "XHDemoWeChatMessageTableViewController.h"

@interface WPOtherResumeTwoController () <UIWebViewDelegate,NJKWebViewProgressDelegate,UITextFieldDelegate,WPRecruitApplyDelegate,WPInterviewApplyDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIView *bottomChatView;
@property (strong, nonatomic) UIView *bottomEditView;
@property (strong, nonatomic) UIView *bottomManagerView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NJKWebViewProgressView *webViewProgressView;
@property (strong, nonatomic) NJKWebViewProgress *webViewProgress;

@property (strong, nonatomic) UIView *messageView;
@property(strong, nonatomic)NSMutableArray *array;
@property (nonatomic, strong)WPTitleView * titleView;
@end

@implementation WPOtherResumeTwoController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.titleView.titleString = @"详情";
    self.navigationItem.titleView = self.titleView;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    WPIVManager *manager = [WPIVManager sharedManager];
    manager.fk_id = self.subId;
    manager.fk_type = [NSString stringWithFormat:@"%ld",(long)self.isRecuilist];
    [manager requsetForImageAndVideo];
    
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    (_isRecuilist == 2?(_isSelf?[self bottomEditView]:[self bottomChatView]):(_isSelf?[self bottomManagerView]:[self bottomView]));
    //    [self.view addSubview:self.preview];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    _webView.detectsPhoneNumbers=NO;
    [self.scrollView addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.urlStr stringByAppendingFormat:@"&isVisible=1"]]];
    [_webView loadRequest:request];
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
//    _webViewProgress.progressDelegate = self;
    UIScrollView * scroll = [_webView.subviews objectAtIndex:0];
    scroll.bounces = NO;
    
    [self getRecruitApplyMessage];
    
    //[[IQKeyboardManager sharedManager] disableInViewControllerClass:[WPOtherResumeTwoController class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[WPOtherResumeTwoController class]];
    
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 2,
                                 navBounds.size.width,
                                 2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    [self.navigationController.navigationBar addSubview:_webViewProgressView];
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshApplyState) name:@"kNotificationApplySucceed" object:nil];
}
-(void)sendeToWeiPinFriends
{
//    if (!self.resumeModel) {//model无数据需要请求
//        [self requstModel:^(id json) {
//            [self sendeToWeiPinFriends];
//        }];
//        return;
//    }
    NSDictionary * dic = nil;
    if (self.isRecuilist)
    {//招聘
        dic = @{@"zp_id":self.resumeModel.resumeId,@"zp_position":self.resumeModel.jobPositon,@"zp_avatar":self.resumeModel.logo,@"cp_name":[NSString stringWithFormat:@"%@",self.resumeModel.enterpriseName],@"belong":self.resumeModel.resume_user_id,@"title":@"",@"info":[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.resumeModel.enterpriseName,self.resumeModel.dataIndustry,self.resumeModel.enterprise_properties,self.resumeModel.enterprise_scale,self.resumeModel.enterprise_address,self.resumeModel.enterprise_brief]};
    }
    else//求职
    {
        dic = @{@"qz_id":self.resumeModel.resumeId,@"qz_avatar":self.resumeModel.avatar,@"qz_position":self.resumeModel.HopePosition,@"qz_name":self.resumeModel.name,@"qz_sex":self.resumeModel.sex,@"qz_age":@"",@"qz_educaiton":self.resumeModel.education,@"qz_workTime":self.resumeModel.WorkTim,@"belong":self.resumeModel.resume_user_id,@"info":@"",@"title":[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.resumeModel.nike_name.length?self.resumeModel.nike_name:@"",self.resumeModel.age.length?self.resumeModel.age:@"",self.resumeModel.sex.length?self.resumeModel.sex:@"",self.resumeModel.education.length?self.resumeModel.education:@"",self.resumeModel.worktime.length?self.resumeModel.worktime:@"",self.resumeModel.lightspot.length?self.resumeModel.lightspot:@""]};
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
//    if (self.isRecuilist)//招聘
//    {
//        dic = @{@"action":@"GetJobInfoMgr",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"job_id":self.resumeId};
//        urlStr = [NSString stringWithFormat:@"%@/ios/inviteJob.ashx",IPADDRESS];
//    }
//    else
//    {
//        dic = @{@"action":@"GetResumeInfo",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"resume_id":self.resumeId};
//        urlStr = [NSString stringWithFormat:@"%@/ios/resume_new.ashx",IPADDRESS];
//    }
    
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
            self.resumeModel = model;
//            WPNewResumeListModel * model = [[WPNewResumeListModel alloc]init];
//            model.logo = json[@"avatar"];
//            model.enterpriseName = json[@"ep_name"];
//            model.resumeId = self.resumeId;
//            model.resume_user_id = json[@"user_id"];
//            model.jobPositon = json[@"position"];
//            model.userId = json[@"user_id"];
//            self.resumeModel = model;
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
            self.resumeModel = model;
//            NSArray * jaonArray = json[@"PhotoList"];
//            WPNewResumeListModel * model = [[WPNewResumeListModel alloc]init];
//            model.resumeId = self.resumeId;
//            model.avatar = jaonArray.count?jaonArray[0][@"original_path"]:@"";//json[@"PhotoList"][0][@"original_path"]
//            model.HopePosition = json[@"Hope_Position"];
//            model.name = json[@"name"];
//            model.sex = json[@"sex"];
//            model.education = json[@"education"];
//            model.WorkTim = json[@"WorkTime"];
//            model.resume_user_id = json[@"resume_user_id"];
//            model.userId = json[@"user_id"];
//            self.resumeModel = model;
        }
        Success(json);
    } failure:^(NSError *error) {
    }];
}
#pragma mark 点击右侧进行分享
- (void)rightBtnClick
{
    [self requstModel:^(id string) {
    
        NSString * urlStr;
        if (self.isRecuilist == 0) {
            urlStr = [NSString stringWithFormat:@"%@/webMobile/November/share_resume_info.aspx?resume_id=%@",IPADDRESS,_resumeModel.resumeId];
        }
        else
        {
            urlStr = [NSString stringWithFormat:@"%@/webMobile/November/share_EnterpriseRecruit.aspx?recruit_id=%@",IPADDRESS,_resumeModel.resumeId];
        }
        
        
       
        
        WPSendToFriends * toFriend = [[WPSendToFriends alloc]init];
        toFriend.type = self.isRecuilist;
        toFriend.model = self.resumeModel;
        NSString* title = [toFriend shareDetailFromZhaopinOrQiuZhiandImage:(!self.isRecuilist)?self.resumeModel.avatar:self.resumeModel.logo];
        [YYShareManager newShareWithTitle:title url:urlStr action:^(YYShareManagerType type) {
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
                        jobids = _resumeModel.resumeId;
                    }else{
                        jobids = [NSString stringWithFormat:@"%@,%@",jobids,_resumeModel.resumeId];
                    }
                    share_title = [NSString stringWithFormat:@"招聘:%@",_resumeModel.jobPositon];
                    if (!_resumeModel.avatar) {
                        _resumeModel.avatar = @"";
                    }
                    [jobPhoto addObject:@{@"small_address":_resumeModel.avatar}];
                    name = _resumeModel.enterpriseName;
                    
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
                        jobids = _resumeModel.resumeId;
                    }else{
                        jobids = [NSString stringWithFormat:@"%@,%@",jobids,_resumeModel.resumeId];
                    }
                    share_title = [NSString stringWithFormat:@"求职:%@",_resumeModel.HopePosition];
                    if (!_resumeModel.avatar) {
                        _resumeModel.avatar = @"";
                    }
                    [jobPhoto addObject:@{@"small_address":_resumeModel.avatar}];
                    name = _resumeModel.name;
                    sex = _resumeModel.sex;
                    birthday = _resumeModel.birthday;
                    education = _resumeModel.education;
                    workTime = _resumeModel.WorkTim;
                    i ++;
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
                    //                [self hidden];
                    [MBProgressHUD createHUD:@"分享成功" View:self.view];
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
//            if (status == UMSResponseCodeSuccess) {
//                
//            }
        }];
    }];
    
//    NSString * urlStr;
//    if (self.isRecuilist == 0) {
//        urlStr = [NSString stringWithFormat:@"%@/webMobile/November/share_resume_info.aspx?resume_id=%@",IPADDRESS,_resumeModel.resumeId];
//    }
//    else
//    {
//        urlStr = [NSString stringWithFormat:@"%@/webMobile/November/share_EnterpriseRecruit.aspx?recruit_id=%@",IPADDRESS,_resumeModel.resumeId];
//    }
//    [YYShareManager newShareWithTitle:@"这是title" url:urlStr action:^(YYShareManagerType type) {
//        if (type == YYShareManagerTypeWeiPinFriends)
//        {
//           [self sendeToWeiPinFriends];
//        }
//        if (type == YYShareManagerTypeWorkLines) {
//            ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
//            NSString *jobids;
//            NSString *share_title;
//            NSString *name;
//            NSString *sex;
//            NSString *birthday;
//            NSString *education;
//            NSString *workTime;
//            NSMutableArray *jobPhoto = [NSMutableArray array];
//            int i = 0;
//            if(self.isRecuilist == WPMainPositionTypeRecruit){
//                if (jobids.length == 0) {
//                    jobids = _resumeModel.resumeId;
//                }else{
//                    jobids = [NSString stringWithFormat:@"%@,%@",jobids,_resumeModel.resumeId];
//                }
//                share_title = [NSString stringWithFormat:@"招聘:%@",_resumeModel.jobPositon];
//                if (!_resumeModel.avatar) {
//                    _resumeModel.avatar = @"";
//                }
//                [jobPhoto addObject:@{@"small_address":_resumeModel.avatar}];
//                name = _resumeModel.enterpriseName;
//                
//                i ++;
//                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"jobNo":[NSString stringWithFormat:@"%d",i],
//                                                                                           @"jobids":jobids,
//                                                                                           @"share":[NSString stringWithFormat:@"%d",3],
//                                                                                           @"shareMsg":@{@"jobPhoto":jobPhoto,
//                                                                                                         @"share_title":share_title,
//                                                                                                         @"name":name}}];
//                
//                share.shareInfo = dic;
//            }else{
//                if (jobids.length == 0) {
//                    jobids = _resumeModel.resumeId;
//                }else{
//                    jobids = [NSString stringWithFormat:@"%@,%@",jobids,_resumeModel.resumeId];
//                }
//                share_title = [NSString stringWithFormat:@"求职:%@",_resumeModel.HopePosition];
//                if (!_resumeModel.avatar) {
//                    _resumeModel.avatar = @"";
//                }
//                [jobPhoto addObject:@{@"small_address":_resumeModel.avatar}];
//                name = _resumeModel.name;
//                sex = _resumeModel.sex;
//                birthday = _resumeModel.birthday;
//                education = _resumeModel.education;
//                workTime = _resumeModel.WorkTim;
//                i ++;
//                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"jobNo":[NSString stringWithFormat:@"%d",i],
//                                                                                           @"jobids":jobids,
//                                                                                           @"share":[NSString stringWithFormat:@"%d",2],
//                                                                                           @"shareMsg":@{@"jobPhoto":jobPhoto,
//                                                                                                         @"share_title":share_title,
//                                                                                                         @"name":name,
//                                                                                                         @"sex":sex,
//                                                                                                         @"birthday":birthday,
//                                                                                                         @"education":education,
//                                                                                                         @"WorkTime":workTime}}];
//                
//                share.shareInfo = dic;
//            }
//            share.shareSuccessedBlock = ^(id json){
//                //                [self hidden];
//                [MBProgressHUD createHUD:@"分享成功" View:self.view];
//            };
//            [self.navigationController pushViewController:share animated:YES];
//        }
//        if (type == YYShareManagerTypeCollect) {//点击进行收藏
//            [self performSelector:@selector(collection) withObject:nil afterDelay:0.2];
//        }
//        if (type == YYShareManagerTypeReport) {//点击进行举报
//            [self performSelector:@selector(gotoReport) withObject:nil afterDelay:0.2];
//        }
//    } status:^(UMSResponseCode status) {
//        if (status == UMSResponseCodeSuccess) {
//            
//        }
//    }];
}
-(void)gotoReport
{
    ReportViewController *report = [[ReportViewController alloc] init];
    //    report.speak_trends_id = self.info[@"sid"];
    report.speak_trends_id = self.subId;
    report.type = ReportTypeDynamice;
    [self.navigationController pushViewController:report animated:YES];
}
-(NSMutableArray*)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.titleView.activity startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.titleView.activity stopAnimating];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSString *str = request.URL.relativeString;
//    NSArray *array = [str componentsSeparatedByString:@"="];
    
    
    
    NSString *str = request.URL.relativeString;
    NSArray *array = [str componentsSeparatedByString:@"="];
    if ([array[0]isEqualToString:[NSString stringWithFormat:@"%@/webMobile/November/PhotoAndVideo.aspx?img_path",IPADDRESS]]) {//点击图片
        NSString *urlstr1 = array[1];
        NSArray *arr2 = [urlstr1 componentsSeparatedByString:@"&"];
        NSString *mediaType = arr2[0];
        if ([mediaType hasSuffix:@".mp4"]) {
            VideoBrowser *video = [[VideoBrowser alloc] init];
            video.videoUrl = [IPADDRESS stringByAppendingString:mediaType];
            [video show];
        } else {
            NSArray *images = [WPIVManager sharedManager].model.ImgPhoto;
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
//        WPDetailPhotoViewController * photoDetail = [[WPDetailPhotoViewController alloc]init];
//        NSString * string = [NSString stringWithFormat:@"%@",array[1]];
//        NSString * substr = @"&";
//        int beging = 0;
//        for (int i = 0 ; i < string.length; i++) {
//            NSRange range = NSMakeRange(i, 1);
//            NSString * subString = [string substringWithRange:range];
//            if ([substr isEqualToString:subString]) {
//                beging = i;
//                break;
//            }
//        }
//        
//        NSString * fk_idStr = [string substringToIndex:beging];
//        
//        photoDetail.fk_type =[NSString stringWithFormat:@"%@",array[array.count-1]];
//        photoDetail.fk_id = fk_idStr;
//        [self.navigationController pushViewController:photoDetail animated:YES];
        return NO;
    }
//    else if (![str isEqualToString:self.urlStr]) {
////        [self pushPersonalResumeListControllerWithUserId:array[1]];
//        return NO;
//    }
    return YES;
//    if ([array[0] hasSuffix:@"/webMobile/November/user_id"]) {
//        WPPersonalResumeListController *list = [[WPPersonalResumeListController alloc]init];
//        list.userId = array[1];
//        list.isRecruit = _isRecuilist;
//        list.isSelf = NO;
//        [self.navigationController pushViewController:list animated:YES];
//        return NO;
//    }
    
//    return YES;
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
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

//-(SPPreview *)preview{
//    if (!_preview) {
//        _preview = [[SPPreview alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
//        _preview.isPreview = NO;
//
//        WPInterEditModel *model = [[WPInterEditModel alloc]init];
//
//        model.sex = @"男";
//        model.name = @"佟丽娅";
//        model.birthday = @"23岁";
//        model.education = @"本科";
//        model.expe = @"3~5年";
//        model.hometown = @"安徽-亳州-利辛县";
//        model.lifeAddress = @"安徽-合肥-瑶海区";
//        model.position = @"iOS程序员";
//        model.wage = @"5000~7000";
//        model.wel = @"五险一金/周末双休";
//        model.area = @"合肥市瑶海区";
//        model.works = @"春在田畴，松软的泥土散发着清新湿润的气息，冬憩后醒来的麦苗儿精神焕发，展现出一派蓬勃盎然的生机；渠水欢唱，如母爱的乳汁，与土地和麦苗的血液水乳交融。春在河畔，碧波清荡，鱼虾畅游，蛙鼓抑扬弄喉嗓，柳丝婆娑舞倩影，阳光水波交相辉映，洒落捧捧金和银。春在天空，燕语呢喃，蝴蝶翩跹，风筝高飞，浓浓春意弥漫洁白的云朵间，甜脆笑声穿梭浩淼九天。春在果园，红杏流火，桃花漫霞，梨树飞雪，蜂蝶追逐喧嚷，酝酿生活的甘甜和芬芳……";
//        model.phone = @"11234567899786";
//        model.personal = @"吃苦耐劳，有上进心，责任心强，团队意识强，能很好的与大家配合，希望考虑";
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
//        for (int i = 0; i < 4; i++) {
//            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
//            [arr addObject:image];
//        }
//        _preview.model = model;
//        _preview.photosArr = arr;
//        [_preview reloadData];
//
//    }
//    return _preview;
//}

-(UIView *)bottomView{
    if (!_bottomView) {
//        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.scrollView.height-49, SCREEN_WIDTH, 49)];
//        NSArray *titles = @[@" 聊聊",(_isRecuilist?@" 申请":@" 抢人"),@" 收藏",@" 查看"];
//        NSArray *images = @[@"common_liaoliao",@"common_gongyong",@"common_shoucang",@"common_chakan"];
//        for (int i = 0; i< 4; i++) {
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.tag = 100+i;
//            [button setTitle:titles[i] forState:UIControlStateNormal];
//            [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
//            [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateHighlighted];
//            button.titleLabel.font = kFONT(15);
//            [button addTarget:self action:@selector(userOperationClick:) forControlEvents:UIControlEventTouchUpInside];
//            button.frame = CGRectMake(i*SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4+1, 49);
//            if (i==0) {
//                [button setBackgroundImage:[UIImage imageWithColor:RGB(0, 172, 255) size:CGSizeMake(SCREEN_WIDTH/4+1, 49)] forState:UIControlStateNormal];
//                [button setBackgroundImage:[UIImage imageWithColor:RGB(0, 146, 217) size:CGSizeMake(SCREEN_WIDTH/4+1, 49)] forState:UIControlStateHighlighted];
//            }else{
//                [button setBackgroundImage:[UIImage imageWithColor:RGB(255, 139, 0) size:CGSizeMake(SCREEN_WIDTH/4+1, 49)] forState:UIControlStateNormal];
//                [button setBackgroundImage:[UIImage imageWithColor:RGB(217, 118, 0) size:CGSizeMake(SCREEN_WIDTH/4+1, 49)] forState:UIControlStateHighlighted];
//            }
//            [_bottomView addSubview:button];
//            if (i>0) {
//                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/4, 0, 0.5, 49)];
//                line.backgroundColor = [UIColor whiteColor];
//                [_bottomView addSubview:line];
//            }
//        }
//        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//        line.backgroundColor = RGB(178, 178, 178);
//        [self.scrollView addSubview:_bottomView];
        
        
        
        
        
        
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.scrollView.height-49, SCREEN_WIDTH, 49)];
        NSArray *titles = @[@" 聊聊",(_isRecuilist?@" 申请":@" 抢人"),@" 收藏",@" 查看"];
        NSArray *images = @[@"common_liaoliao",@"common_gongyong",@"common_shoucang",@"common_chakan"];
        for (int i = 0; i< 4; i++) {
            SPButton *button = [[SPButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, 49) title:titles[i] ImageName:images[i] Target:self Action:@selector(userOperationClick:)];
            button.tag = 100+i;
            button.contentLabel.textColor = [UIColor whiteColor];
            button.contentLabel.font = kFONT(15);
            if (i == 0) {
                [button setBackgroundColor:RGB(0, 172, 255)];
            }
            else
            {
                [button setBackgroundColor:RGB(255, 139, 0)];
            }
            [_bottomView addSubview:button];
            
            if (i!=0) {
                UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/4, 0, 0.5, 49)];
                line.backgroundColor = [UIColor whiteColor];
                [_bottomView addSubview:line];
            }
        }
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomView addSubview:line];
        [self.scrollView addSubview:_bottomView];
    }
    return _bottomView;
}
#pragma mark 初始化聊聊
- (UIView *)bottomChatView{
    if (!_bottomChatView) {
        _bottomChatView = [[UIView alloc]initWithFrame:CGRectMake(0, self.scrollView.height-49, SCREEN_WIDTH, 49)];
        SPButton *button = [[SPButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49) title:@"聊聊" ImageName:@"common_liaoliao" Target:self Action:@selector(chatClick:)];
        button.contentLabel.textColor = RGB(0, 0, 0);
        [button setBackgroundImage:[UIImage imageWithColor:RGB(0, 172, 255)] forState:UIControlStateNormal];
        button.tag = 100;
        [_bottomChatView addSubview:button];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomChatView addSubview:line];
        
        [self.scrollView addSubview:_bottomChatView];
    }
    return _bottomChatView;
}
#pragma mark 初始化编辑
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
        
        SPButton *button = [[SPButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49) title:@"查看" ImageName:@"common_chakan" Target:self Action:@selector(editClick:)];
        button.contentLabel.textColor =[UIColor whiteColor];
        button.tag = 100;
        [_bottomManagerView addSubview:button];
        [button setBackgroundColor:RGB(0, 172, 255)];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomManagerView addSubview:line];
        
        [self.scrollView addSubview:_bottomManagerView];
    }
    return _bottomManagerView;
}

- (UIView *)messageView
{
    if (!_messageView) {
        
        _messageView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 49)];
        _messageView.backgroundColor = RGB(235, 235, 235);
        [self.scrollView addSubview:_messageView];
        
        UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-49-10, 49)];
        text.placeholder = @"发送消息";
        text.tag = 50;
        text.delegate = self;
        text.returnKeyType = UIReturnKeyDone;
        //        [text becomeFirstResponder];
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

#pragma mark 点击申请跳转页面
- (void)requestRecruitGetApplyCondition{
    WPRecruitApplyController *apply = [[WPRecruitApplyController alloc] init];
    apply.isFix = YES;
    apply.delegate = self;
    apply.sid = self.subId;
//    apply.isApplyFromDetailList = YES;
    apply.isFromCompanyGiveList = self.isFromCompanyGiveList;
    apply.isApplyFromDetailList = !self.isFromCompanyGiveList;
    apply.isFromMyApply = self.isFromMyAplly;
    apply.isApplyFromDetailList = !self.isFromMyAplly;
    [self.navigationController pushViewController:apply animated:YES];
    //    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/invitejob.ashx"];
    //    WPShareModel *model = [WPShareModel sharedModel];
    //    NSDictionary *params = @{@"action":@"ClickSign",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"],@"jobId":self.subId};
    //    [MBProgressHUD showMessage:@"" toView:self.view];
    //    [WPHttpTool postWithURL:str params:params success:^(id json) {
    //        [MBProgressHUD hideHUDForView:self.view];
    //        NSLog(@"%@",describe(json));
    //        if ([json[@"status"] isEqualToString:@"0"]) {
    //            WPRecruitApplyChooseModel *model = [WPRecruitApplyChooseModel objectWithKeyValues:json];
    //                if (model.resumeList.count) {
    //                    WPRecruitApplyChooseController *choose = [[WPRecruitApplyChooseController alloc]init];
    //                    choose.sid = self.subId;
    //                    [self.navigationController pushViewController:choose animated:YES];
    //                }else{
    //                    WPRecruitApplyController *apply = [[WPRecruitApplyController alloc] init];
    //                    apply.delegate = self;
    //                    apply.sid = self.subId;
    //                    [self.navigationController pushViewController:apply animated:YES];
    //            }
    //        }else{
    //            [MBProgressHUD showError:@"服务器连接失败" toView:self.view];
    //        }
    //    } failure:^(NSError *error) {
    //        [MBProgressHUD hideHUDForView:self.view];
    //        NSLog(@"%@",error.localizedDescription);
    //    }];
}

#pragma mark 点击抢人跳转页面
- (void)requestInterviewGetApplyCondition{
    WPInterviewApplyController *apply = [[WPInterviewApplyController alloc] init];
    apply.isFix = YES;
    apply.delegate = self;
    apply.sid = self.subId;
    
    apply.personalApplytList = self.personalApplyList;
    apply.personDetailList = !self.personalApplyList;
    
    apply.isFromMyRob = self.isFromMyRob;
    apply.personDetailList = !self.isFromMyRob;
    
    apply.isFromMyRobList = self.isFromMyRobList;
    apply.personDetailList = !self.isFromMyRobList;
    
    apply.isFix = self.isFromMyRobList?NO:YES;
    
    [self.navigationController pushViewController:apply animated:YES];
    //    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    //    WPShareModel *model = [WPShareModel sharedModel];
    //    NSDictionary *params = @{@"action":@"ClickSign",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"],@"resume_id":self.subId,@"ep_id":@""};
    //    [MBProgressHUD showMessage:@"" toView:self.view];
    //    [WPHttpTool postWithURL:str params:params success:^(id json) {
    //        [MBProgressHUD hideHUDForView:self.view];
    //        NSLog(@"%@",describe(json));
    //        if ([json[@"status"] isEqualToString:@"0"]) {
    //            WPInterviewApplyChooseModel *model = [WPInterviewApplyChooseModel objectWithKeyValues:json];
    //            if (model.jobList.count) {
    //                WPInterviewApplyChooseController *choose = [[WPInterviewApplyChooseController alloc]init];
    //                choose.sid = self.subId;
    //                [self.navigationController pushViewController:choose animated:YES];
    //            }else{
    //                WPInterviewApplyController *apply = [[WPInterviewApplyController alloc] init];
    //                apply.delegate = self;
    //                apply.sid = self.subId;
    //                [self.navigationController pushViewController:apply animated:YES];
    //            }
    //        }else{
    //            [MBProgressHUD showError:@"服务器连接失败" toView:self.view];
    //        }
    //    } failure:^(NSError *error) {
    //        [MBProgressHUD hideHUDForView:self.view];
    //        NSLog(@"%@",error.localizedDescription);
    //    }];
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
        SPButton *button = (SPButton *)[self.view viewWithTag:101];
        switch ([json[@"signStatus"] integerValue]) {
            case 0:
                button.contentLabel.text = _isRecuilist?@"申请":@"抢人";
                break;
            case 1:
                button.contentLabel.text = _isRecuilist?@"已申请":@"已抢";
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
    //    }else{
    //        NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    //        WPShareModel *model = [WPShareModel sharedModel];
    //
    //        NSDictionary *params = @{@"action":@"GetResumeSignStatus",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"],@"resume_id":self.subId};
    //
    //        [WPHttpTool postWithURL:str params:params success:^(id json) {
    //
    //            SPButton *button = (SPButton *)[self.view viewWithTag:WPInterViewOperationTypeApply];
    //            switch ([json[@"signStatus"] integerValue]) {
    //                case 0:
    //                    button.contentLabel.text = @"报名";
    //                    break;
    //                case 1:
    //                    button.contentLabel.text = @"已报名";
    //                    break;
    //                case 2:
    //                    button.contentLabel.text = @"已通过";
    //                    break;
    //                default:
    //                    break;
    //            }
    //        } failure:^(NSError *error) {
    //            NSLog(@"%@",error.localizedDescription);
    //        }];
    //    }
    
}
#pragma mark 点击聊聊，抢人，收藏，查看
-(void)userOperationClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
            [self chatClick:nil];
            break;
        case 103:
            [self message];
            break;
        case 101:
            [self apply];
            break;
        case 102:
            [self collection];
        default:
            break;
    }
}
#pragma mark 点击进行收藏
- (void)collection
{
        CollectViewController *VC = [[CollectViewController alloc]init];
        if (_isRecuilist) {
            VC.titles = self.resumeModel.jobPositon;
            VC.companys = self.resumeModel.enterpriseName;
            VC.jobid = self.resumeModel.resumeId;
            VC.collect_class = @"5";
            VC.user_id = self.resumeModel.userId;
            VC.img_url = self.resumeModel.logo;
        }else{
            VC.titles = self.resumeModel.HopePosition;
            VC.companys = [NSString stringWithFormat:@"%@ %@ %@ %@",self.resumeModel.name,self.resumeModel.sex,self.resumeModel.education,self.resumeModel.WorkTim];
            VC.jobid = self.resumeModel.resumeId;
            VC.collect_class = @"6";
            VC.user_id = self.resumeModel.userId;
            VC.img_url = self.resumeModel.avatar;
        }
        
        VC.collectSuccessBlock = ^(){
//            [MBProgressHUD showSuccess:@"收藏成功"];
        };
        [self.navigationController pushViewController:VC animated:YES];
}
- (void)chatClick:(UIButton *)sender{
    
    [self requireDataWithAciont];
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
                ChattingMainViewController *chat = [ChattingMainViewController shareInstance];
                [chat showChattingContentForSession:session];
                [self.navigationController pushViewController:chat animated:YES];
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
#pragma mark 点击查看
- (void)editClick:(UIButton *)sender{
    switch (_isRecuilist) {
        case 0:
            NSLog(@"求职编辑");
            if (_isSelf) {
                WPNewCheckController *check = [[WPNewCheckController alloc]init];
                check.type = self.isRecuilist;
                check.resumeId = self.resumeId;
                check.model = self.resumeModel;
                check.subId = self.subId;
                check.isRecuilist = self.isRecuilist;
                check.listFix = self.listFix;
                [self.navigationController pushViewController:check animated:YES];
//                WPPersonalResumeListController *list = [[WPPersonalResumeListController alloc]init];
//                list.userId = self.userId;
//                list.resumeId = self.subId;
//                list.isSelf = _isSelf;
//                list.isRecruit = _isRecuilist;
//                [self.navigationController pushViewController:list animated:YES];
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
}
#pragma mark
- (void)message{
    WPResumeCheckController *resume = [[WPResumeCheckController alloc]init];
    resume.title = @"查看";
    resume.resumeId = self.resumeId;
    resume.isRecruit = self.isRecuilist;
    resume.model = self.resumeModel;
    resume.userId = self.userId;
    resume.listFix = self.listFix;
    SPButton *button = (SPButton *)[self.view viewWithTag:101];
    if ([button.contentLabel.text isEqualToString:(_isRecuilist?@"申请":@"抢人")]) {
        resume.isApply = NO;
    }
    if ([button.contentLabel.text isEqualToString:(_isRecuilist?@"已申请":@"已抢")]) {
        resume.isApply = YES;
    }
    
    [self.navigationController pushViewController:resume animated:YES];
}

- (void)apply{
    SPButton *button = (SPButton *)[self.view viewWithTag:101];
    
    if ([button.contentLabel.text isEqualToString:(_isRecuilist?@"申请":@"抢人")]) {
        // 判断  页面如何跳转
        _isRecuilist?[self requestRecruitGetApplyCondition]:[self requestInterviewGetApplyCondition];
    }
    if ([button.contentLabel.text isEqualToString:(_isRecuilist?@"已申请":@"已抢")]) {
        [SPAlert alertControllerWithTitle:@"提示" message:(_isRecuilist?@"是否取消已申请？":@"是否取消已抢？") superController:self cancelButtonTitle:@"否" cancelAction:nil defaultButtonTitle:@"是" defaultAction:^{
            NSString *str = [IPADDRESS stringByAppendingString:(_isRecuilist?@"/ios/invitejob.ashx":@"/ios/resume_new.ashx")];
            WPShareModel *model = [WPShareModel sharedModel];
            NSDictionary *params = @{@"action":(_isRecuilist?@"CancelApplicationJob":@"CancelApplicationResume"),
                                     @"username":model.username,
                                     @"password":model.password,
                                     @"user_id":model.dic[@"userid"],
                                     (_isRecuilist?@"job_id":@"resume_id"):self.subId};
            [WPHttpTool postWithURL:str params:params success:^(id json) {
                if (![json[@"status"] integerValue]) {
                    button.contentLabel.text = (_isRecuilist?@"申请":@"抢人");
                }else{
                    [MBProgressHUD showError:json[@"info"] toView:self.view];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error.localizedDescription);
            }];
        }];
        
    }
    if ([button.contentLabel.text isEqualToString:@"已通过"]) {
        NSLog(@"已通过");
    }
    
    //    if (_isRecuilist) {
    //        if ([button.contentLabel.text isEqualToString:@"报名"]) {
    ////            WPRecruitApplyController *apply = [[WPRecruitApplyController alloc] init];
    ////            apply.delegate = self;
    ////            apply.sid = self.subId;
    ////            [self.navigationController pushViewController:apply animated:YES];
    //            [self requestRecruitGetApplyCondition];
    //        }
    //        if ([button.contentLabel.text isEqualToString:@"已报名"]) {
    //            NSString *str = [IPADDRESS stringByAppendingString:@"/ios/invitejob.ashx"];
    //            WPShareModel *model = [WPShareModel sharedModel];
    //            NSDictionary *params = @{@"action":@"CancelSign",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"],@"job_id":self.subId};
    //            [WPHttpTool postWithURL:str params:params success:^(id json) {
    //                //            NSLog(@"%@",describe(json));
    //                if (![json[@"status"] integerValue]) {
    //                    button.contentLabel.text = @"报名";
    //                }else{
    //                    [MBProgressHUD showError:@"取消报名失败" toView:self.view];
    //                }
    //            } failure:^(NSError *error) {
    //                NSLog(@"%@",error.localizedDescription);
    //            }];
    //        }
    //        if ([button.contentLabel.text isEqualToString:@"已通过"]) {
    //            NSLog(@"已通过");
    //        }
    //    }else{
    //        if ([button.contentLabel.text isEqualToString:@"报名"]) {
    ////            WPInterviewApplyController *apply = [[WPInterviewApplyController alloc] init];
    ////            apply.delegate = self;
    ////            apply.sid = self.subId;
    ////            [self.navigationController pushViewController:apply animated:YES];
    //            [self requestInterviewGetApplyCondition];
    //        }
    //        if ([button.contentLabel.text isEqualToString:@"已报名"]) {
    //            NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    //            WPShareModel *model = [WPShareModel sharedModel];
    //            NSDictionary *params = @{@"action":@"CancelSign",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"],@"resume_id":self.subId};
    //            [WPHttpTool postWithURL:str params:params success:^(id json) {
    //                //            NSLog(@"%@",describe(json));
    //                if (![json[@"status"] integerValue]) {
    //                    button.contentLabel.text = @"报名";
    //                }else{
    //                    [MBProgressHUD showError:@"取消报名失败" toView:self.view];
    //                }
    //            } failure:^(NSError *error) {
    //                NSLog(@"%@",error.localizedDescription);
    //            }];
    //        }
    //        if ([button.contentLabel.text isEqualToString:@"已通过"]) {
    //            NSLog(@"已通过");
    //        }
    //    }
}

- (void)refreshApplyState{
    SPButton *button = (SPButton *)[self.view viewWithTag:101];
    button.contentLabel.text = (_isRecuilist?@"已申请":@"已抢");
}

- (void)recruitApplyDelegate{
    SPButton *button = (SPButton *)[self.view viewWithTag:101];
    button.contentLabel.text = (_isRecuilist?@"已申请":@"已抢");
}

- (void)interviewApplyDelegate{
    SPButton *button = (SPButton *)[self.view viewWithTag:101];
    button.contentLabel.text = (_isRecuilist?@"已申请":@"已抢");
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    CGRect rect = CGRectMake(0, SCREEN_HEIGHT-49-64-height, SCREEN_WIDTH, 49);
    self.messageView.frame = rect;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //获取键盘的高度
    self.messageView.frame = CGRectMake(0, SCREEN_HEIGHT-64, SCREEN_WIDTH, 49);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void)dealloc
{
    _webViewProgress = nil;
    [_webViewProgressView removeFromSuperview];
}

@end
