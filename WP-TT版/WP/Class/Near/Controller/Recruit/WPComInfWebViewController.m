//
//  WPComInfWebViewController.m
//  WP
//
//  Created by CBCCBC on 16/3/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPComInfWebViewController.h"
#import "WPRecruitDraftEditController.h"
#import "WPCompanyEditController.h"
#import "UIImage+autoGenerate.h"
#import "WPIVManager.h"
#import "SAYVideoManagerViewController.h"
#import "VideoBrowser.h"
#import "MLPhotoBrowserPhoto.h"
#import "MLPhotoBrowserViewController.h"
//#import "GetWPCompanyList.h"

@interface WPComInfWebViewController ()<UIWebViewDelegate,RefreshCompanyInfoDelegate>

@property (nonatomic , strong)UIButton *editBtn;
@property (nonatomic , strong)UIWebView *webView;
@property (nonatomic , strong)UIView *lineView;
@property (nonatomic, strong)NSMutableArray *array;
@end

@implementation WPComInfWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WPIVManager *manager = [WPIVManager sharedManager];
    manager.fk_id = [NSString stringWithFormat:@"%@",self.listModel.epId];
    manager.fk_type = @"3";
    [manager requsetForImageAndVideo];
    
    // Do any additional setup after loading the view.
    
//    [self.view addSubview:self.editBtn];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.lineView];
    [self addBarButton];
    
}
-(NSMutableArray*)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}
- (void)addBarButton
{
    if (self.isMyPersonalCompany) {
       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItem:)];
    }
    else
    {
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
    }
}
-(void)rightBarButtonItem:(UIButton*)brn
{
    WPCompanyEditController *VC = [[WPCompanyEditController alloc]init];
    VC.isEditCompany=1000;
    VC.isCompany=100;
    VC.companyModel = self.companyModel;
    VC.upDateSuccess = ^(){
        [self.webView reload];
    };
    [self.navigationController pushViewController:VC animated:YES];

}
//- (void)fuck{
//    [self.navigationController popViewControllerAnimated:YES];
//}

// 右青龙点击方法,返回指定页面
- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    NSArray *VCarr = self.navigationController.viewControllers;
    self.delegate = VCarr[VCarr.count - 3];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCompanyInfo:)])
    {
        [self.delegate getCompanyInfo:self.listModel];
    }
    [self.navigationController popToViewController:VCarr[VCarr.count - 3] animated:YES];

    
//    if (self.isFix)
//    {
//        if (self.personalApplyList)
//        {
//            self.delegate = VCarr[9];
//            if (self.delegate && [self.delegate respondsToSelector:@selector(getCompanyInfo:)])
//            {
//                [self.delegate getCompanyInfo:self.listModel];
//            }
//            [self.navigationController popToViewController:VCarr[9] animated:YES];
//        }
//        else
//        {
//        
//            self.delegate = VCarr[6];
//            if (self.delegate && [self.delegate respondsToSelector:@selector(getCompanyInfo:)])
//            {
//                [self.delegate getCompanyInfo:self.listModel];
//            }
//            [self.navigationController popToViewController:VCarr[6] animated:YES];
//        }
//        
//    }
//    else
//    {
//        if (self.isFromDetail)
//        {
//            self.delegate = VCarr[4];
//            if (self.delegate && [self.delegate respondsToSelector:@selector(getCompanyInfo:)])
//            {
//                [self.delegate getCompanyInfo:self.listModel];
//            }
//            [self.navigationController popToViewController:VCarr[4] animated:YES];
//        }
//        else
//        {
//            if (self.isBuild)
//            {
//                self.delegate = VCarr[2];
//                if (self.delegate && [self.delegate respondsToSelector:@selector(getCompanyInfo:)])
//                {
//                    [self.delegate getCompanyInfo:self.listModel];
//                }
//                [self.navigationController popToViewController:VCarr[2] animated:YES];
//            }
//            else
//            {
//                if (self.personalApply)
//                {
//                    self.delegate = VCarr[7];
//                    if (self.delegate && [self.delegate respondsToSelector:@selector(getCompanyInfo:)])
//                    {
//                        [self.delegate getCompanyInfo:self.listModel];
//                    }
//                    [self.navigationController popToViewController:VCarr[7] animated:YES];
//                }
//                else
//                {
//                    if (self.personalApplyList)
//                    {
//                        self.delegate = VCarr[9];
//                        if (self.delegate && [self.delegate respondsToSelector:@selector(getCompanyInfo:)])
//                        {
//                            [self.delegate getCompanyInfo:self.listModel];
//                        }
//                        [self.navigationController popToViewController:VCarr[9] animated:YES];
//                    }
//                    else
//                    {
//                        if (self.isFromMyRob)
//                        {
//                            self.delegate = VCarr[5];
//                            if (self.delegate && [self.delegate respondsToSelector:@selector(getCompanyInfo:)])
//                            {
//                                [self.delegate getCompanyInfo:self.listModel];
//                            }
//                            [self.navigationController popToViewController:VCarr[5] animated:YES];
//                        }
//                        else
//                        {
//                            if (self.isFromMyRobList) {
//                                self.delegate = VCarr[7];
//                                if (self.delegate && [self.delegate respondsToSelector:@selector(getCompanyInfo:)])
//                                {
//                                    [self.delegate getCompanyInfo:self.listModel];
//                                }
//                                [self.navigationController popToViewController:VCarr[7] animated:YES];
//                            }
//                            else
//                            {
//                                if (self.isFromcollection) {
//                                    self.delegate = VCarr[5];
//                                    if (self.delegate && [self.delegate respondsToSelector:@selector(getCompanyInfo:)])
//                                    {
//                                        [self.delegate getCompanyInfo:self.listModel];
//                                    }
//                                    [self.navigationController popToViewController:VCarr[5] animated:YES];
//                                }
//                                else
//                                {
//                                    if (self.isFromMuchcollection) {
//                                        self.delegate = VCarr[6];
//                                        if (self.delegate && [self.delegate respondsToSelector:@selector(getCompanyInfo:)])
//                                        {
//                                            [self.delegate getCompanyInfo:self.listModel];
//                                        }
//                                        [self.navigationController popToViewController:VCarr[6] animated:YES];
//                                    }
//                                    else
//                                    {
//                                        self.delegate = VCarr[3];
//                                        if (self.delegate && [self.delegate respondsToSelector:@selector(getCompanyInfo:)])
//                                        {
//                                            [self.delegate getCompanyInfo:self.listModel];
//                                        }
//                                        [self.navigationController popToViewController:VCarr[3] animated:YES];
//                                    }
//                                   
//                                }
//                               
//                            }
// 
//                        }
//                    }
//                    
//                }
//            }
//            
//        }
//        
//    }
}

// 懒加载  WebView
- (UIWebView *)webView
{
    if (!_webView) {
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        self.webView.delegate = self;
        NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",IPADDRESS,@"/webMobile/November/CompanyEx.aspx?ep_id=",self.listModel.epId];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
        
        [self.webView loadRequest:request];
        for (UIView* view in self.webView.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                UIScrollView * scroller = (UIScrollView*)view;
                scroller.bounces = NO;
            }
        }
    }
    return _webView;
}

// 编辑按钮
- (UIButton *)editBtn
{
    if (!_editBtn) {
        self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.editBtn.frame = CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44);
        self.editBtn.backgroundColor = [UIColor whiteColor];
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.editBtn setTitleColor:RGB(226, 226, 226) forState:UIControlStateHighlighted];
        [self.editBtn setBackgroundImage:[UIImage imageWithColor:RGB(226, 226, 226) size:CGSizeMake(SCREEN_WIDTH, 44)] forState:UIControlStateHighlighted];
        [self.editBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = RGB(178, 178, 178);
        [self.editBtn addSubview:lineView];
    }
    return _editBtn;
}

// 编辑按钮 点击方法
- (void)buttonAction:(UIButton *)sender
{
    WPCompanyEditController *check = [[WPCompanyEditController alloc]init];
    check.listModel = self.listModel;
    check.launch = YES;
    [self.navigationController pushViewController:check animated:YES];
}

- (void)setListModel:(WPCompanyListModel *)listModel
{
    _listModel = listModel;
    self.title = listModel.enterpriseName;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
