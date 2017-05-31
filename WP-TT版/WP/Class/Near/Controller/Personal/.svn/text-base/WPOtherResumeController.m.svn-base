//
//  WPOtherResumeController.m
//  WP
//
//  Created by CBCCBC on 15/12/3.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPOtherResumeController.h"
#import "NearInterViewController.h"
#import "ApplyForActivityController.h"
#import "WPRecruitApplyController.h"
#import "WPInterviewApplyController.h"
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
#import "MTTSessionEntity.h"
#import "ChattingMainViewController.h"
#import "PersonalInfoViewController.h"
#import "VideoBrowser.h"
#import "WPIVManager.h"
#import "WPPersonalAlbumController.h"
#import "MLPhotoBrowserPhoto.h"
#import "MLPhotoBrowserViewController.h"
#import "WPPersonalResumeListController.h"
#import "WPDetailPhotoViewController.h"
#import "SAYVideoManagerViewController.h"
#import "YYShareManager.h"
#import "WPSendToFriends.h"
#import "WPRecentLinkManController.h"
#import "ShareEditeViewController.h"
//#import "XHDemoWeChatMessageTableViewController.h"

@interface WPOtherResumeController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *bottomManagerView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NJKWebViewProgressView *webViewProgressView;
@property (strong, nonatomic) NJKWebViewProgress *webViewProgress;

@property (strong, nonatomic) UIView *messageView;
@property (strong, nonatomic) NSMutableArray * array;
@property (nonatomic, strong)WPNewResumeListModel*model;
@end

@implementation WPOtherResumeController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * string = self.isRecuilist?@"企业招聘":@"求职简历";
    self.titleView = [[WPTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.titleView.titleString = string;
    self.navigationItem.titleView = self.titleView;
//  self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self bottomManagerView];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT-64-49)];
    _webView.detectsPhoneNumbers=NO;
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [self.view addSubview:_webView];
    for (UIView * view in _webView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView * scroller = (UIScrollView*)view;
            scroller.bounces = NO;
        }
    }
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.urlStr stringByAppendingFormat:@"&isVisible=1"]]];
//    [_webView loadRequest:request];
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    
   // [[IQKeyboardManager sharedManager] disableInViewControllerClass:[NearInterViewController class]];
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[NearInterViewController class]];
    
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 2,
                                 navBounds.size.width,
                                 2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    [self.navigationController.navigationBar addSubview:_webViewProgressView];
}
- (void)rightBtnClick
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
    NSDictionary *params = @{@"action":(self.isRecuilist == 0?@"oneshareresume2":@"onesharejob2"),
                             (self.isRecuilist == 0?@"resumeid":@"jobid"):self.resumeID,
                             @"user_id":kShareModel.userId,
                             };
    
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        
        if([json[@"status"] isEqualToString:@"1"]){
            [self requstModel:^(id string) {
                [self shareWithUrlStr:json[@"url"]];
            }];
            
            //            [self shareWithUrlStr:json[@"url"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
}];
}

-(void)shareSuccess
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/sharefile.ashx"];
    NSDictionary *params = @{@"action":(self.isRecuilist == 0?@"oneshareresume":@"onesharejob"),
                             (self.isRecuilist == 0?@"resumeid":@"jobid"):self.resumeID,
                             @"user_id":kShareModel.userId,
                             };
    [WPHttpTool postWithURL:str params:params success:^(id json) {
    } failure:^(NSError *error) {
    }];
}

-(void)shareWithUrlStr:(NSString*)urlString
{
    urlString = [IPADDRESS stringByAppendingString:urlString];
    WPSendToFriends *toFriends = [[WPSendToFriends alloc]init];
    toFriends.model = self.model;
    toFriends.isRecuilist = self.isRecuilist;
    NSString * title = [toFriends shareDetailFromZhaopinOrQiuZhiandImage:(!self.isRecuilist)?self.model.avatar:self.model.logo];
    [YYShareManager newShareWithTitle:title url:urlString action:^(YYShareManagerType type) {
        if (type == YYShareManagerTypeWeiPinFriends)
        {
            //NSLog(@"分享到微聘好友");
            [toFriends sendeToWeiPinFriends:^(NSArray *array, NSString *toUserId, NSString *messageContent, NSString *display_type) {
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
                [jobPhoto addObject:@{@"small_address":_model.logo}];
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
                share_title = [NSString stringWithFormat:@"求职:%@",_model.HopePosition];
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
                //                [self hidden];
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
-(void)requstModel:(void(^)(id))Success
{
    NSDictionary * dic = nil;
    NSString * urlStr = nil;
    if (self.isRecuilist)//招聘
    {
        dic = @{@"action":@"GetJobDraftInfo",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"job_id":self.resumeID};
        urlStr = [NSString stringWithFormat:@"%@/ios/inviteJob.ashx",IPADDRESS];
    }
    else
    {
        dic = @{@"action":@"GetResumeInfo",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"resume_id":self.resumeID};
        urlStr = [NSString stringWithFormat:@"%@/ios/resume_new.ashx",IPADDRESS];
    }
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        if (self.isRecuilist)//招聘
        {
            WPNewResumeListModel * model = [[WPNewResumeListModel alloc]init];
            model.logo = json[@"photoList"][0][@"original_path"];
            model.enterpriseName = json[@"enterprise_name"];
            model.resumeId = self.resumeID;
            model.resume_user_id = json[@"user_id"];
            model.jobPositon = json[@"jobPositon"];
            model.enterprise_properties = json[@"enterprise_properties"];
            model.enterprise_brief = json[@"enterprise_properties"];
            model.enterprise_scale = json[@"enterprise_scale"];
            model.enterprise_address = json[@"enterprise_address"];
            model.dataIndustry = json[@"dataIndustry"];
            self.model = model;
        }
        else
        {
            NSArray * jaonArray = json[@"PhotoList"];
            WPNewResumeListModel * model = [[WPNewResumeListModel alloc]init];
            model.resumeId = self.resumeID;
            model.avatar = jaonArray.count?jaonArray[0][@"original_path"]:@"";//json[@"PhotoList"][0][@"original_path"]
            model.HopePosition = json[@"Hope_Position"];
            model.name = json[@"name"];
            model.sex = json[@"sex"];
            model.education = json[@"education"];
            model.WorkTim = json[@"WorkTime"];
            model.resume_user_id = json[@"resume_user_id"];
            model.lightspot = json[@"lightspot"];
            self.model = model;
        }
        Success(json);
    } failure:^(NSError *error) {
    }];
}

- (UIView *)bottomManagerView{
    if (!_bottomManagerView) {
        _bottomManagerView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        SPButton *button = [[SPButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49) title:@"聊聊" ImageName:@"common_liaoliao" Target:self Action:@selector(editClick:)];
        button.tag = 100;
//        button.backgroundColor = RGB(255, 255, 255);
        [button setBackgroundColor:RGB(0, 172, 255)];
        button.contentLabel.textColor = [UIColor whiteColor];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
        
        [_bottomManagerView addSubview:button];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomManagerView addSubview:line];
        
        [self.view addSubview:_bottomManagerView];
    }
    return _bottomManagerView;
}
//-(void)clickDown:(UIButton*)sender
//{
//  
//}
- (void)editClick:(UIButton *)sender{
    [sender setBackgroundColor:RGB(0, 172, 255)];
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
//        
////        XHDemoWeChatMessageTableViewController *chat = [[XHDemoWeChatMessageTableViewController alloc] init];
////        chat.chatObj = json[@"user_name"];
////        chat.avatar = json[@"avatar"];
////        chat.nick_name = json[@"nick_name"];
////        [self.navigationController pushViewController:chat animated:YES];
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

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
//    [_webViewProgressView setProgress:progress animated:YES];
//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
}

-(void)dealloc
{
    _webViewProgress = nil;
    [_webViewProgressView removeFromSuperview];
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
   
    [self.titleView.activity startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.titleView.activity stopAnimating];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *str = request.URL.relativeString;
    NSArray *array = [str componentsSeparatedByString:@"="];
    if ([array[0]isEqualToString:[NSString stringWithFormat:@"%@/webMobile/November/PhotoAndVideo.aspx?img_path",IPADDRESS]]) {//点击图片
        NSString *urlstr1 = array[1];
        NSArray *arr2 = [urlstr1 componentsSeparatedByString:@"&"];
        NSString *mediaType = arr2[0];
        if ([mediaType hasSuffix:@".mp4"]) {
            VideoBrowser *video = [[VideoBrowser alloc] init];
            video.videoUrl = [IPADDRESS stringByAppendingString:mediaType];
            video.isNetOrNot = YES;
            video.isCreat = NO;
            video.addLongPress = NO;
            [video showPickerVc:self];
            
            
//            VideoBrowser *video = [[VideoBrowser alloc] init];
//            video.videoUrl = [IPADDRESS stringByAppendingString:mediaType];
//            [video show];
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
//        photoDetail.fk_id = self.userId;
//        WPPersonalAlbumController *album = [[WPPersonalAlbumController alloc] init];
//        album.fk_id = self.userId;
//        album.fk_type = @"4";
//        album.isOrNot = YES;
////        album.friend_id = self.userId;
//        [self.navigationController pushViewController:photoDetail animated:YES];
        return NO;
    }else if (![str isEqualToString:self.urlStr]) {
        [self pushPersonalResumeListControllerWithUserId:self.userId];
        return NO;
    }
    return YES;
}

- (void)pushPersonalResumeListControllerWithUserId:(NSString *)userid
{
    WPPersonalResumeListController *list = [[WPPersonalResumeListController alloc]init];
    list.userId = userid;
    if (_isRecuilist == 0)list.isRecruit = NO;
    if (_isRecuilist > 0)list.isRecruit = YES;
    list.isSelf = NO;
    [self.navigationController pushViewController:list animated:YES];
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
@end
