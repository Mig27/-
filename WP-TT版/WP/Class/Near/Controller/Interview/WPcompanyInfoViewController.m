//
//  WPcompanyInfoViewController.m
//  WP
//
//  Created by CC on 16/8/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPcompanyInfoViewController.h"
#import "VideoBrowser.h"
#import "WPIVManager.h"
#import "SAYVideoManagerViewController.h"
#import "MLPhotoBrowserViewController.h"
@interface WPcompanyInfoViewController ()<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, strong)NSMutableArray *array;

@end

@implementation WPcompanyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    
    [self initNavc];
    
    
    
    WPIVManager *manager = [WPIVManager sharedManager];
    manager.fk_id = self.subId;
    manager.fk_type = @"3";
    [manager requsetForImageAndVideo];
    
}
-(void)initNavc
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
   
    button.frame = CGRectMake(0, 0, 45, 45);
    //        [_rightBtn setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"确认" forState:UIControlStateNormal];
    button.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
    //        [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kHEIGHT(12))];
    [button addTarget:self action:@selector(rightButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

#pragma mark点击确认
-(void)rightButtonItemAction:(UIButton*)sender
{
    NSArray * array = self.navigationController.viewControllers;
    self.delegate = array[array.count-3];
    if (self.delegate && [self.delegate respondsToSelector:@selector(controller:Model:)]) {
        [self.delegate controller:nil Model:self.infoModel];
        [self.navigationController popToViewController:array[array.count-3] animated:YES];
    }
    
    
    
    
//    if (self.isFromList)
//    {
//        self.delegate = array[2];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(controller:Model:)]) {
//            [self.delegate controller:nil Model:self.infoModel];
//            [self.navigationController popToViewController:array[2] animated:YES];
//        }
//    }
//    else if (self.isFromDetail)
//    {
//        self.delegate = array[3];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(controller:Model:)]) {
//            [self.delegate controller:nil Model:self.infoModel];
//            [self.navigationController popToViewController:array[3] animated:YES];
//        }
//    }
//    else if (self.isFromDetailList)
//    {
//        self.delegate = array[5];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(controller:Model:)]) {
//            [self.delegate controller:nil Model:self.infoModel];
//             [self.navigationController popToViewController:array[5] animated:YES];
//        }
//    }
//    else if (self.personalApply)
//    {
//        self.delegate = array[6];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(controller:Model:)]) {
//            [self.delegate controller:nil Model:self.infoModel];
//            [self.navigationController popToViewController:array[6] animated:YES];
//        }
//    }
//    else if (self.personalApplyList)
//    {
//        self.delegate = array[8];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(controller:Model:)]) {
//            [self.delegate controller:nil Model:self.infoModel];
//            [self.navigationController popToViewController:array[8] animated:YES];
//        }
//    
//    }
//    else if (self.isFromMyRob)
//    {
//        self.delegate = array[4];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(controller:Model:)]) {
//            [self.delegate controller:nil Model:self.infoModel];
//            [self.navigationController popToViewController:array[4] animated:YES];
//        }
//    }
//    else if (self.isFromMyRobList)
//    {
//        self.delegate = array[6];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(controller:Model:)]) {
//            [self.delegate controller:nil Model:self.infoModel];
//            [self.navigationController popToViewController:array[6] animated:YES];
//        }
//    }
//    else if (self.isFromCollection)
//    {
//        self.delegate = array[4];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(controller:Model:)]) {
//            [self.delegate controller:nil Model:self.infoModel];
//            [self.navigationController popToViewController:array[4] animated:YES];
//        }
//    }
//    else if (self.isFromMuchCollection)
//    {
//        self.delegate = array[5];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(controller:Model:)]) {
//            [self.delegate controller:nil Model:self.infoModel];
//            [self.navigationController popToViewController:array[5] animated:YES];
//        }
//    }
    
    
}

-(NSMutableArray*)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}
-(UIWebView*)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _webView.delegate = self;
        NSURLRequest * requst = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
        [_webView loadRequest:requst];
        for (UIView*view in _webView.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                UIScrollView * scroller = (UIScrollView*)view;
                scroller.bounces = NO;
            }
        }
    }
    return _webView;
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
//            [video show];
            video.isNetOrNot = YES;
            [video showPickerVc:self];
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
        return NO;
    }else if (![str isEqualToString:self.urlStr]) {
//        [self pushPersonalResumeListControllerWithUserId:array[1]];
//        return NO;
    }
    return YES;
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
