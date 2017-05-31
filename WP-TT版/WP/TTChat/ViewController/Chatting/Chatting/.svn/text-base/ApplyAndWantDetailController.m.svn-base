//
//  ApplyAndWantDetailController.m
//  WP
//
//  Created by CC on 16/8/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "ApplyAndWantDetailController.h"
#import "ChattingMainViewController.h"
#import "VideoBrowser.h"
#import "WPIVManager.h"
#import "SAYVideoManagerViewController.h"
#import "MLPhotoBrowserPhoto.h"
#import "MLPhotoBrowserViewController.h"
#import "WPMySecurities.h"
@interface ApplyAndWantDetailController ()<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, strong)NSMutableArray* array;
@property (nonatomic, strong)UIButton*rightBtn;
@end

@implementation ApplyAndWantDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WPIVManager *manager = [WPIVManager sharedManager];
    manager.fk_id = self.subId;
    manager.fk_type = self.isApply?@"0":@"1";
    ;
    [manager requsetForImageAndVideo];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    [self initWebView];
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _rightBtn.frame = CGRectMake(0, 0, 45, 45);
        _rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_rightBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
-(NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}
-(void)initWebView
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    NSURL * url = [NSURL URLWithString:self.urlStr];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
    for (UIView * view in self.webView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView * scroller = (UIScrollView*)view;
            scroller.bounces = NO;
        }
    }
}
-(void)rightBtnClick
{
    NSMutableArray * muarray = [[NSMutableArray alloc]init];
            NSDictionary * dic = [NSDictionary dictionary];
            if (_isApply)
            {
//                dic = @{@"qz_id":[NSString stringWithFormat:@"%@",_listModel.resumeId],
//                        @"qz_avatar":[NSString stringWithFormat:@"%@",_listModel.avatar],
//                        @"qz_position":[NSString stringWithFormat:@"%@",[[NSString stringWithFormat:@"%@",_listModel.position] componentsSeparatedByString:@"："][1]],
//                        @"qz_name":[NSString stringWithFormat:@"%@",_listModel.nike_name],
//                        @"qz_sex":[NSString stringWithFormat:@"%@",_listModel.sex],
//                        @"qz_age":[NSString stringWithFormat:@"%@",_listModel.age],
//                        @"qz_educaiton":[NSString stringWithFormat:@"%@",_listModel.education],
//                        @"qz_workTime":[NSString stringWithFormat:@"%@",_listModel.worktime],
//                        @"belong":[NSString stringWithFormat:@"%@",_listModel.userId],
//                        @"info":[NSString stringWithFormat:@"%@ %@ %@ %@ %@",_listModel.nike_name.length?_listModel.position:@"",_listModel.nike_name.length?_listModel.nike_name:@"",_listModel.nike_name.length?_listModel.nike_name:@"",_listModel.nike_name.length?_listModel.nike_name:@"",_listModel.nike_name.length?_listModel.nike_name:@""],
//                        @"title":@""};
                dic = @{@"qz_id":[NSString stringWithFormat:@"%@",_listModel.resumeId],
                        @"qz_avatar":[NSString stringWithFormat:@"%@",_listModel.avatar],
                        @"qz_position":[NSString stringWithFormat:@"%@",[[NSString stringWithFormat:@"%@",_listModel.position] componentsSeparatedByString:@"："][1]],
                        @"qz_name":[NSString stringWithFormat:@"%@",_listModel.nike_name],
                        @"qz_sex":[NSString stringWithFormat:@"%@",_listModel.sex],
                        @"qz_age":[NSString stringWithFormat:@"%@",_listModel.age],
                        @"qz_educaiton":[NSString stringWithFormat:@"%@",_listModel.education],
                        @"qz_workTime":[NSString stringWithFormat:@"%@",_listModel.worktime],
                        @"belong":[NSString stringWithFormat:@"%@",_listModel.userId],
                        @"info":[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",_listModel.nike_name.length?_listModel.nike_name:@"",_listModel.age.length?_listModel.age:@"",_listModel.sex.length?_listModel.sex:@"",_listModel.education.length?_listModel.education:@"",_listModel.worktime.length?_listModel.worktime:@"",_listModel.lightSpot.length?_listModel.lightSpot:@""],
                        @"title":@""};
            }
            else
            {
//                dic = @{@"zp_id":[NSString stringWithFormat:@"%@",_listModel.resumeId],
//                        @"zp_position":[NSString stringWithFormat:@"%@",[[NSString stringWithFormat:@"%@",_listModel.position] componentsSeparatedByString:@"："][1]],
//                        @"zp_avatar":[NSString stringWithFormat:@"%@",_listModel.avatar],
//                        @"b":[NSString stringWithFormat:@"%@",_listModel.enterprise_name],
//                        @"belong":[NSString stringWithFormat:@"%@",_listModel.userId],
//                        @"title":@"",
//                        @"info":[NSString stringWithFormat:@"%@ %@ %@ %@ %@",_listModel.nike_name.length?_listModel.position:@"",_listModel.nike_name.length?_listModel.nike_name:@"",_listModel.nike_name.length?_listModel.nike_name:@"",_listModel.nike_name.length?_listModel.nike_name:@"",_listModel.nike_name.length?_listModel.nike_name:@""]};
                
                NSString * string = _listModel.enterprise_brief;
                string = [WPMySecurities textFromBase64String:string];
                string = [WPMySecurities textFromEmojiString:string];
                if (string.length) {
                    _listModel.enterprise_brief = string;
                }
                
                dic = @{@"zp_id":[NSString stringWithFormat:@"%@",_listModel.resumeId],
                        @"zp_position":[NSString stringWithFormat:@"%@",[[NSString stringWithFormat:@"%@",_listModel.position] componentsSeparatedByString:@"："][1]],
                        @"zp_avatar":[NSString stringWithFormat:@"%@",_listModel.avatar],
                        @"cp_name":[NSString stringWithFormat:@"%@",_listModel.enterprise_name],
                        @"belong":[NSString stringWithFormat:@"%@",_listModel.userId],
                        @"title":@"",
                        @"info":[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",_listModel.enterprise_name.length?_listModel.enterprise_name:@"",_listModel.dataIndustry.length?_listModel.dataIndustry:@"",_listModel.enterprise_properties.length?_listModel.enterprise_properties:@"",_listModel.enterprise_scale.length?_listModel.enterprise_scale:@"",_listModel.enterprise_address.length?_listModel.enterprise_address:@"",_listModel.enterprise_brief.length?_listModel.enterprise_brief:@""]};
            }
            [muarray addObject:dic];
    [[ChattingMainViewController shareInstance] sendMyApplyAndWant:muarray andApply:_isApply];
    NSArray * viewArray = self.navigationController.viewControllers;
    [self.navigationController popToViewController:viewArray[viewArray.count-3] animated:YES];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *str = request.URL.relativeString;
    NSArray *array = [str componentsSeparatedByString:@"="];
//    NSString * string = [NSString stringWithFormat:@"%@",IPADDRESS];
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
        return NO;
    }
//    else if ([array[0] isEqualToString:@"http://192.168.1.160/webMobile/November/EnterpriseRecruit.aspx?recruit_id"] && ![str isEqualToString:self.urlStr])
//    {
//        if (_urlString.length)
//        {
//            
//        }
//        else
//        {
//            [UIView animateWithDuration:0.5 animations:^{
//                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
//                _urlString = str;
//                [self.webView loadRequest:request];
//            }];
//        }
//    }
//    else if (![str isEqualToString:self.urlStr]) {
//        [self pushPersonalResumeListControllerWithUserId:array[1]];
//        return NO;
//    }
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
