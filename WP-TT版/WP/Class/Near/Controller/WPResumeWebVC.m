//
//  WPResumeWebVC.m
//  WP
//
//  Created by Kokia on 16/3/24.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPResumeWebVC.h"
#import "YYKit.h"
//#import "WPInterviewDraftEditController.h"

#import "WPResumeUserInfoModel.h"

#import "WPResumeEditVC.h"

#import "WPRecruitApplyController.h"
#import "VideoBrowser.h"
#import "WPIVManager.h"
#import "WPCheckImagesController.h"
#import "MLPhotoBrowserPhoto.h"
#import "MLPhotoBrowserViewController.h"
#import "SAYVideoManagerViewController.h"
#define PERSONALURL @"/webMobile/November/resume.aspx?resume_user_id=%@&user_id=%@"

#define RESUMEURL @"/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@&isVisible=1"


@interface WPResumeWebVC ()<UIWebViewDelegate,WPResumeEditVCDelagte>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIWebView *personalView;

@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, strong) NSString *personalUrl;

@property (nonatomic, strong) WPResumeUserInfoModel * userInfoModel;
@property (nonatomic, strong) NSMutableArray * array;

@end

@implementation WPResumeWebVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WPIVManager *manager = [WPIVManager sharedManager];
    manager.fk_id = [NSString stringWithFormat:@"%@",self.model.resumeUserId];
    manager.fk_type = @"2";
    [manager requsetForImageAndVideo];
    
    
//    WPIVManager *manager = [WPIVManager sharedManager];
//    manager.fk_id = [NSString stringWithFormat:@"%@",self.model.resumeUserId];
//    manager.fk_type = @"2";
//    [manager requsetForImageAndVideo];
    self.view.backgroundColor = RGB(226, 226, 226);
    
    WS(ws)
    [self getInterviewResumeDraftDetail:self.model.resumeUserId success:^(WPResumeUserInfoModel *model) {
        
        if (model) {
            ws.userInfoModel = model;
        }
        
    }];
    
    [self.view addSubview:self.scrollView];
    
    [self.view addSubview:self.editBtn];
    
    if (self.isMyPersonalInfo) {
       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemAc:)];
    }
    else
    {
       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemAction:)];
    }
   
    
    

}
-(void)rightItemAc:(UIButton*)btn
{
    WPResumeEditVC *VC = [[WPResumeEditVC alloc]init];
    VC.isEdit=1000;
    VC.isPerson=100;
    VC.isPersonInfo = YES;
    VC.personModel = self.personalModel;
    VC.upDataSuccess = ^(){
        [self.personalView reload];
        if (self.setAgain) {
            self.setAgain();
        }
    };
    [self.navigationController pushViewController:VC animated:YES];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark 点击确认
- (void)rightItemAction:(UIBarButtonItem *)sender
{
//    if (_isBuildNew) {
//        NSArray *arr = [self.navigationController viewControllers];
//        self.delegate = arr[3];
//        [self.delegate reloadDataWithEpid:self.userInfoModel.resumeUserId];
//        [self.navigationController popToViewController:arr[3] animated:YES];
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    NSArray *arr = [self.navigationController viewControllers];
    self.delegate = arr[arr.count-3];
    if (self.choiseResume) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadResumeDataWithModel:)]) {
            [self.delegate reloadResumeDataWithModel:self.infoModel];
            [self.navigationController popToViewController:arr[arr.count-3] animated:YES];
        }
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadDataWithEpid:)]) {
            [self.delegate reloadDataWithEpid:self.userInfoModel.resumeUserId];
            [self.navigationController popToViewController:arr[arr.count-3] animated:YES];
        }
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        [self.scrollView addSubview:self.personalView];
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.bounces = NO;
        self.scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UIWebView *)personalView
{
    if (!_personalView) {
        self.personalView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.personalUrl]];
        
        [self.personalView loadRequest:request];
        self.personalView.delegate = self;
        for (id subView in self.personalView.subviews) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                UIScrollView * scroller = (UIScrollView*)subView;
                scroller.bounces = NO;
            }
        }
    }
    return _personalView;
}
#pragma mark 获取UIWebView上的点击事件
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *str = request.URL.relativeString;
    NSArray *array = [str componentsSeparatedByString:@"="];
    if ([array[0]isEqualToString:[NSString stringWithFormat:@"%@/webMobile/November/PhotoAndVideo.aspx?img_path",IPADDRESS]]) {
        NSString *urlstr1 = array[1];
        NSArray *arr2 = [urlstr1 componentsSeparatedByString:@"&"];
        NSString *mediaType = arr2[0];
        if ([mediaType hasSuffix:@".mp4"]) {
            VideoBrowser *video = [[VideoBrowser alloc] init];
            video.isNetOrNot = YES;
            video.isCreat = NO;
            video.addLongPress = YES;
            video.videoUrl = [IPADDRESS stringByAppendingString:mediaType];
            [video showPickerVc:self];
            
            
//            video.videoUrl = [IPADDRESS stringByAppendingString:mediaType];
//            [video show];
          
        } else {
            NSArray *images = [WPIVManager sharedManager].model.ImgPhoto;
            if (images.count) {
                [self showPhotoBrowserWithPhotoArray:images url:arr2[0]];
            }
            
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

       
//        WPCheckImagesController *VC = [[WPCheckImagesController alloc]init];
//        //        NSArray *data = @[[WPIVManager sharedManager].model.ImgPhoto,[WPIVManager sharedManager].model.VideoPhoto];
//        //        VC.dataArray = data;
//        [self.navigationController pushViewController:VC animated:YES];
        return NO;
    }
//    else if (![str isEqualToString:self.urlStr]) {
//        [self pushPersonalResumeListControllerWithUserId:array[1]];
//        return NO;
//    }
    
    return YES;
    //判断是否是单击
//    if (navigationType == UIWebViewNavigationTypeLinkClicked)
//    {
//        NSURL *url = [request URL];
//        NSString * urlStr = [[url absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        int startNum = 0;
//        int endNum = 0;
//        NSString * string = @"upload";
//        NSString * string1 = @"png";
//        for (int i = 0 ; i < urlStr.length; i++) {
//            NSRange range = NSMakeRange(i, 6);
//            NSString * subStr = [urlStr substringWithRange:range];
//            if ([subStr isEqualToString:string]) {
//                startNum = i;
//            }
//            
//            NSRange range1 = NSMakeRange(i, 3);
//            NSString * subStr1 = [urlStr substringWithRange:range1];
//            if ([subStr1 isEqualToString:string1]) {
//                endNum = i;
//                int length = endNum+3-startNum;
//                NSRange range2 = NSMakeRange(startNum, length);
//                NSString * subString = [urlStr substringWithRange:range2];
//                NSURL * openUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",IPADDRESS,subString]];
//                if([[UIApplication sharedApplication]canOpenURL:openUrl])
//                {
//                    [[UIApplication sharedApplication]openURL:openUrl];
//                }
//            }
//        }
//        return NO;
//    }
//    return YES;
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
- (void)setModel:(WPResumeUserModel *)model
{
    _model = model;
    
    self.title = model.name;
    
    
    NSString *urlSuffix = [NSString stringWithFormat:_isBuildNew?PERSONALURL:RESUMEURL,_isBuildNew ? model.resumeUserId : model.resume_id,kShareModel.userId];
//    NSLog(@"%@",urlSuffix);
    self.personalUrl = [NSString stringWithFormat:@"%@%@",IPADDRESS,urlSuffix];
}

// 编辑按钮
- (UIButton *)editBtn
{
    if (!_editBtn) {
        self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.editBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
        
        self.editBtn.backgroundColor = [UIColor whiteColor];
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.editBtn setBackgroundImage:[UIImage imageWithColor:RGB(226, 226, 226) size:CGSizeMake(SCREEN_WIDTH, 44)] forState:UIControlStateHighlighted];
        
        [self.editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchDown];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = RGB(178, 178, 178);
        [self.editBtn addSubview:lineView];
    }
    return nil;
}

- (void)editBtnAction:(UIButton *)sender
{
//    WS(ws);
    
//    [self getInterviewResumeDraftDetail:self.model.resumeUserId success:^(WPResumeUserInfoModel *model) {
    
//        WPInterviewDraftEditController *edit = [[WPInterviewDraftEditController alloc]init];
//        edit.type = WPInterviewEditTypeEdit;
//        
//        edit.draftInfoModel = model;
//        edit.delegate = ws;
        
        WPResumeEditVC *edit = [WPResumeEditVC new];
        [edit setupSubViews];
        edit.title = @"编辑个人信息";
        edit.userModel = self.userInfoModel;
        
        [self.navigationController pushViewController:edit animated:YES];
//    }];
}


- (void)getInterviewResumeDraftDetail:(NSString *)resumeUserId success:(void (^)(WPResumeUserInfoModel *model))success
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    
    NSDictionary *params = @{@"action":_isBuildNew ? @"GetResumeUserInfo" : @"GetResumeDraftInfo",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             _isBuildNew ? @"resume_user_id": @"resume_id": _isBuildNew ? self.model.resumeUserId : self.model.resume_id};
    
    [WPHttpTool postWithURL:str params:params success:^(id json)
    {
        WPResumeUserInfoModel *model = [WPResumeUserInfoModel mj_objectWithKeyValues:json];
        success(model);
    } failure:^(NSError *error) { 
        NSLog(@"%@",error.localizedDescription);
    }];
}


@end
