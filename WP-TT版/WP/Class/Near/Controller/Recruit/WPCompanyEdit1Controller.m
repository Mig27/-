//
//  WPCompanyEditController.m
//  WP
//
//  Created by CBCCBC on 15/10/9.
//  Copyright © 2015年 WP. All rights reserved.
//


#import "WPCompanyEdit1Controller.h"

#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "DBTakeVideoVC.h"
#import "CTAssetsPickerController.h"
#import "SAYPhotoManagerViewController.h"
#import "SAYVideoManagerViewController.h"
#import "WPCompanyController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <BlocksKit+UIKit.h>
//#import <ReactiveCocoa.h>
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "SPPhotoBrowser.h"
#import "SPPhotoAsset.h"

#import "SPActionSheet.h"
#import "WPActionSheet.h"

#import "SPItemView.h"
#import "SPTextView.h"
#import "SPSelectView.h"

#import "WPRecruitController.h"
#import "MLPhotoBrowserViewController.h"

@interface WPCompanyEdit1Controller () <SPSelectViewDelegate,WPActionSheet,SPActionSheetDelegate,callBackVideo,takeVideoBack,CTAssetsPickerControllerDelegate,UpdateImageDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,SPPhotoBrowserDelegate>

#pragma mark - UI层变量
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayerVC;
@property (strong, nonatomic) UIScrollView *verOneScrollView;
@property (strong, nonatomic) UIView *headView;

@property (strong, nonatomic) SPSelectView *selectView;

@property (strong, nonatomic) UIScrollView *photosView;
@property (strong, nonatomic) UIScrollView *videosView;
@property (strong, nonatomic) UIButton *addPhotoBtn;
@property (strong, nonatomic) UIButton *addVideoBtn;

#pragma mark - 数据层变量
@property (strong, nonatomic) NSMutableArray *photosArr;
@property (strong, nonatomic) NSMutableArray *videosArr;

@property (assign, nonatomic) NSInteger selectNum;
@property (assign, nonatomic) NSInteger number;

@end

#pragma mark - TAG
//tag列表
#define TagAddPhoto 13
#define TagShowAllPhotos 14
#define TagAddVideo 15
#define TagShowAllVideos 16
#define TagAddLogo 17
#define TagBack 18
#define TagPhotoSheet 19
#define TagVideoSheet 20
#define TagLogoSheet 21
#define TagBackSheet 22

#define PhotoTag 30
#define VideoTag 45

#pragma mark - Height
//子视图高度
//#define ItemViewHeight 48

@implementation WPCompanyEdit1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _number = 0;
    
    [self setNavbarItem];
    [self.view addSubview:self.verOneScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化数组
-(NSMutableArray *)photosArr
{
    if (!_photosArr) {
        _photosArr = [[NSMutableArray alloc]init];
    }
    return _photosArr;
}

-(NSMutableArray *)videosArr
{
    if (!_videosArr) {
        _videosArr = [[NSMutableArray alloc]init];
    }
    return _videosArr;
}

#pragma mark - 初始化导航栏
- (void)setNavbarItem/**< 初始化导航栏 */
{
    //    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    leftButton.frame = CGRectMake(0, 0, 50, 22);
    //    leftButton.titleLabel.font = GetFont(15);
    //    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    //    [leftButton setTitle:@"招聘" forState:UIControlStateNormal];
    //    [leftButton setTitle:@"求职" forState:UIControlStateSelected];
    //    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [leftButton addTarget:self action:@selector(leftBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    //    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 8, 10, 6)];
    //    imageView.image = [UIImage imageNamed:@"qiehuanjiantou"];
    //    [leftButton addSubview:imageView];
    //
    //    UIBarButtonItem* leftOne = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    //    self.navigationItem.leftBarButtonItem = leftOne;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 32, 22);
    button1.titleLabel.font = kFONT(14);
    [button1 setTitle:@"完成" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button1 addTarget:self action:@selector(rightButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem= rightBarItem;
    
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonItemClick:)];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
}

#pragma mark - 初始化根视图
-(UIScrollView *)verOneScrollView
{
    if (!_verOneScrollView) {
        _verOneScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, GetHeight(SCREEN_WIDTH)+PhotoViewHeight+10+ItemViewHeight*4+170+10);
        _verOneScrollView.backgroundColor = RGB(235, 235, 235);
        
        [_verOneScrollView addSubview:self.headView];
//        [_verOneScrollView addSubview:self.photosView];
        [_verOneScrollView addSubview:self.videosView];
    }
    return _verOneScrollView;
}

#pragma mark 初始化子视图
-(UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GetHeight(SCREEN_WIDTH)+PhotoViewHeight+350)];
        _headView.backgroundColor = RGB(235, 235, 235);
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, GetHeight(SCREEN_WIDTH));
//        backBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        [backBtn setImage:[UIImage imageNamed:@"defaultBG"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"back_default"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(recuilistTagClick:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.tag = TagBack;
        [_headView addSubview:backBtn];
        
        [_headView addSubview:self.photosView];
        
//        UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        headBtn.frame = CGRectMake(24, backBtn.bottom-24-72 , 72, 72);
//        headBtn.backgroundColor = RGB(204, 204, 204);
//        headBtn.layer.cornerRadius = 5;
//        headBtn.clipsToBounds = YES;
//        headBtn.tag = TagAddLogo;
//        [headBtn setImage:[UIImage imageNamed:@"addPhoto"] forState:UIControlStateNormal];
//        [headBtn addTarget:self action:@selector(recuilistTagClick:) forControlEvents:UIControlEventTouchUpInside];
//        [backBtn addSubview:headBtn];
        
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, headBtn.height - 18, headBtn.width, 18)];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.backgroundColor = RGBA(0, 0, 0, 0.5);
//        label.textColor = [UIColor whiteColor];
//        label.text = @"上传LOGO";
//        label.font = GetFont(10);
//        [headBtn addSubview:label];
        
        NSArray *titleArr = @[@"企业名称:",@"企业行业:",@"性       质:",@"规       模:"];
        NSArray *placeHolderArr = @[@"请填写企业名称",@"请选择行业",@"请选择企业性质",@"请选择企业规模"];
        NSArray *styleArr = @[kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeButton];
        for (int i = 0; i < titleArr.count; i++) {
            SPItemView *item = [[SPItemView alloc]initWithFrame:CGRectMake(0, i*ItemViewHeight+self.photosView.bottom+10, SCREEN_WIDTH, ItemViewHeight)];
            [item setTitle:titleArr[i] placeholder:placeHolderArr[i] style:styleArr[i]];
            item.tag = 20+i;
            item.SPItemBlock = ^(NSInteger tag){
                [self buttonItem:tag];
            };
            item.hideFromFont = ^(NSInteger tag, NSString *title){
                if (tag == 20) {
                    
                }
            };
            [_headView addSubview:item];
        }
        //公司简介
        SPTextView *worksView = [[SPTextView alloc]initWithFrame:CGRectMake(0, ItemViewHeight*4+self.photosView.bottom+10, SCREEN_WIDTH, 170)];
        worksView.tag = 25;
        [worksView setWithTitle:@"公司简介:" placeholder:@"请填写公司简介"];
        worksView.hideFromFont = ^(NSString *title){
            
        };
        [_headView addSubview:worksView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [_headView addGestureRecognizer:tap];
    }
    return _headView;
}

#pragma mark 选择框视图
-(SPSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[SPSelectView alloc]initWithTop:64];
        _selectView.delegate = self;
    }
    return _selectView;
}

#pragma mark 照片墙
-(UIScrollView *)photosView
{
    if (!_photosView) {
        
//        CGFloat height = (SCREEN_WIDTH-30-2*3)/4+16;
        _photosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, GetHeight(SCREEN_WIDTH), SCREEN_WIDTH-30, PhotoViewHeight)];
        _photosView.backgroundColor = [UIColor whiteColor];
        _photosView.showsHorizontalScrollIndicator = NO;
        
        _addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _addPhotoBtn.backgroundColor = RGB(204, 204, 204);
        _addPhotoBtn.frame = CGRectMake(10, 10, PhotoHeight, PhotoHeight);
        _addPhotoBtn.tag = TagAddPhoto;
//        [_addPhotoBtn setImage:[UIImage imageNamed:@"addPhoto"] forState:UIControlStateNormal];
//        [_addPhotoBtn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(102, 102, 102)] forState:UIControlStateHighlighted];
        [_addPhotoBtn addTarget:self action:@selector(recuilistTagClick:) forControlEvents:UIControlEventTouchUpInside];
        [_photosView addSubview:_addPhotoBtn];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:_addPhotoBtn.bounds];
        imageV.image = [UIImage imageNamed:@"tianjia64"];
        [_addPhotoBtn addSubview:imageV];
        
        /**< 照片墙翻页 */
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-30, _photosView.top, 30, PhotoViewHeight) ImageName:@"common_icon_arrow" Target:self Action:@selector(recuilistTagClick:)];
        scrollBtn.backgroundColor = [UIColor whiteColor];
        scrollBtn.tag = TagShowAllPhotos;
        [self.headView addSubview:scrollBtn];
    }
    return _photosView;
}

#pragma mark 刷新照片墙
-(void)updatePhotosView
{
    for (UIView *view in self.photosView.subviews) {
        [view removeFromSuperview];
    }
    
//    for (int i = 0; i < self.photosArr.count; i++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(i*(64+2)+10, 10, 64, 64);
//        button.tag = 30+i;
//        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [button setImage:self.photosArr[i] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.photosView addSubview:button];
//    }
//    if (self.photosArr.count == 8) {
//        self.photosView.contentSize = CGSizeMake(8*(64+2)+10, 64);
//    }else{
//        self.photosView.contentSize = CGSizeMake(self.photosArr.count*(64+2)+64+10, 64);
//        _addPhotoBtn.frame = CGRectMake(self.photosArr.count*(64+2)+10, 10, 64, 64);
//        [self.photosView addSubview:_addPhotoBtn];
//    }
    for (int i = 0; i < self.photosArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+6)+10, 10, PhotoHeight, PhotoHeight);
        button.tag = PhotoTag+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        //        SPPhotoAsset *asset = ;
        if ([self.photosArr[i] isKindOfClass:[Pohotolist class]]) {
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] thumb_path]]];
            [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        }else{
            [button setImage:[self.photosArr[i] thumbImage] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.photosView addSubview:button];
    }
    
    CGFloat width = self.photosArr.count*(PhotoHeight+6)+10;
    for (int i = 0; i < self.videosArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+6)+width, 10, PhotoHeight, PhotoHeight);
        button.tag = VideoTag+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button addTarget:self action:@selector(checkVideoClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.videosArr[i] isKindOfClass:[NSString class]]) {
            [button setImage:[UIImage getImage:self.videosArr[i]] forState:UIControlStateNormal];
        }else if([self.videosArr[i] isKindOfClass:[ALAsset class]]){
            ALAsset *asset = self.videosArr[i];
            [button setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
        }else{
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.videosArr[i] thumb_path]]];
            [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        }
        [self.photosView addSubview:button];
        
        UIImageView *subImageV = [[UIImageView alloc]initWithFrame:CGRectMake(PhotoHeight/2-10, PhotoHeight/2-10, 20, 20)];
        subImageV.image = [UIImage imageNamed:@"video_play"];
        [button addSubview:subImageV];
    }
    
    if (self.photosArr.count == 12&&self.videosArr.count == 4) {
        self.photosView.contentSize = CGSizeMake(16*(PhotoHeight+6)+10, PhotoViewHeight);
    }else{
        NSInteger count = self.photosArr.count+self.videosArr.count;
        self.photosView.contentSize = CGSizeMake(count*(PhotoHeight+6)+PhotoHeight+10, PhotoViewHeight);
        _addPhotoBtn.frame = CGRectMake(count*(PhotoHeight+6)+10, 10, PhotoHeight, PhotoHeight);
        [self.photosView addSubview:_addPhotoBtn];
    }
    
}

//-(UIScrollView *)videosView
//{
//    if (!_videosView) {
//
//        _videosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _photosView.bottom, SCREEN_WIDTH-30, 80)];
//        _videosView.backgroundColor = [UIColor whiteColor];
//        _videosView.showsHorizontalScrollIndicator = NO;
//
//        _addVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _addVideoBtn.frame = CGRectMake(10, 10, 64, 64);
//        _addVideoBtn.backgroundColor = RGB(204, 204, 204);
//        [_addVideoBtn setImage:[UIImage imageNamed:@"addPhoto"] forState:UIControlStateNormal];
//        [_addVideoBtn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(102, 102, 102)] forState:UIControlStateHighlighted];
//        _addVideoBtn.tag = TagAddVideo;
//        [_addVideoBtn addTarget:self action:@selector(recuilistTagClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_videosView addSubview:_addVideoBtn];
//
//        /**< 照片墙翻页 */
//        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-30, _videosView.top, 30, 80) ImageName:@"common_icon_arrow" Target:self Action:@selector(recuilistTagClick:)];
//        scrollBtn.backgroundColor = [UIColor whiteColor];
//        scrollBtn.tag = TagShowAllVideos;
//        [self.headView addSubview:scrollBtn];
//    }
//    return _videosView;
//}
//
//-(void)updateVideosView
//{
//    for (UIView *view in self.videosView.subviews) {
//        [view removeFromSuperview];
//    }
//    for (int i = 0; i < self.videosArr.count; i++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(i*(64+2)+10, 10, 64, 64);
//        button.tag = 40+i;
//        [button addTarget:self action:@selector(checkVideoClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.photosView addSubview:button];
//        if ([self.videosArr[i] isKindOfClass:[NSString class]]) {
//            [button setImage:[UIImage getImage:self.videosArr[i]] forState:UIControlStateNormal];
//        }else{
//            ALAsset *asset = self.videosArr[i];
//            [button setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
//        }
//        [self.videosView addSubview:button];
//
//        UIImageView *subImageV = [[UIImageView alloc]initWithFrame:CGRectMake(22, 22, 20, 20)];
//        subImageV.image = [UIImage imageNamed:@"video_play"];
//        [button addSubview:subImageV];
//    }
//    if (self.videosArr.count == 8) {
//        self.videosView.contentSize = CGSizeMake(8*(64+2)+10, 64);
//    }else{
//        self.videosView.contentSize = CGSizeMake(self.videosArr.count*(64+2)+64+10, 64);
//        _addVideoBtn.frame = CGRectMake(self.videosArr.count*(64+2)+10, 10, 64, 64);
//        [self.videosView addSubview:_addVideoBtn];
//    }
//}

#pragma mark - 初始化设置公司信息
-(void)setListModel:(WPCompanyListModel *)listModel
{
    _listModel = listModel;
    WPCompanyListModel *model = listModel;
    UIButton *backBtn = (UIButton *)[self.view viewWithTag:TagBack];
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.QRCode]];
    [backBtn sd_setImageWithURL:url forState:UIControlStateNormal];
//    [backBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    
    //    UIButton *headBtn = (UIButton *)[self.view viewWithTag:TagAddLogo];
    //    NSURL *headUrl = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.logo]];
    //    [headBtn sd_setImageWithURL:headUrl forState:UIControlStateNormal];
    
    self.photosArr = [[NSMutableArray alloc]initWithArray:model.photoList];
    self.videosArr = [[NSMutableArray alloc]initWithArray:model.videoList];
    [self updatePhotosView];
    
    SPItemView *company = (SPItemView *)[self.view viewWithTag:20];
    [company resetTitle:model.enterpriseName];
    
    SPItemView *industry = (SPItemView *)[self.view viewWithTag:21];
    industry.industryId = model.dataIndustryId;
    [industry resetTitle:model.dataIndustry];
    
    SPItemView *properties = (SPItemView *)[self.view viewWithTag:22];
    [properties resetTitle:model.enterpriseProperties];
    
    SPItemView *scale = (SPItemView *)[self.view viewWithTag:23];
    [scale resetTitle:model.enterpriseScale];
    
    NSString *str = [model.enterpriseBrief stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    SPTextView *textView = (SPTextView *)[self.view viewWithTag:25];
    [textView resetTitle:str];
}

#pragma mark - 网络层 - 更新公司信息
- (void)updateCompanyInfo{
    WPShareModel *shareModel = [WPShareModel sharedModel];
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/enterprise.ashx"];
    
    BOOL updateImage = YES;
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    //    WPFormData *formDatas = [[WPFormData alloc]init];
    //    UIButton *logo = (UIButton *)[self.view viewWithTag:TagAddLogo];
    //
    //    formDatas.data = UIImageJPEGRepresentation((UIImage *)logo.imageView.image, 0.5);
    //    formDatas.name = @"logo";
    //    formDatas.filename = @"logo.png";
    //    formDatas.mimeType = @"image/png";
    //    [arr addObject:formDatas];
    
    WPFormData *formDatas1 = [[WPFormData alloc]init];
    UIButton *back = (UIButton *)[self.view viewWithTag:TagBack];
    formDatas1.data = UIImageJPEGRepresentation((UIImage *)back.imageView.image, 0.5);
    formDatas1.name = @"background";
    formDatas1.filename = @"background.png";
    formDatas1.mimeType = @"image/png";
    [arr addObject:formDatas1];
    if (!formDatas1.data) {
        updateImage = NO;
    }
    
    for (int i = 0; i < self.photosArr.count; i++) {
        WPFormData *formDatas = [[WPFormData alloc]init];
        UIImage *image;
        if ([self.photosArr[i] isKindOfClass:[SPPhotoAsset class]]) {
            image = [self.photosArr[i] originImage];
            formDatas.data = UIImageJPEGRepresentation(image, 0.5);
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] original_path]]]];
            formDatas.data = data;
        }
        formDatas.name = [NSString stringWithFormat:@"PhotoAddress%d",i];
        formDatas.filename = [NSString stringWithFormat:@"PhotoAddress%d.png",i];
        formDatas.mimeType = @"image/png";
        [arr addObject:formDatas];
        if (!formDatas.data) {
            updateImage = NO;
        }
    }
    for (int i =0; i < self.videosArr.count; i++) {
        WPFormData *formDatas = [[WPFormData alloc]init];
        if ([self.videosArr[i] isKindOfClass:[NSString class]]) {
            NSData *data = [NSData dataWithContentsOfFile:self.videosArr[i]];
            formDatas.data = data;
        } else if([self.videosArr[i] isKindOfClass:[ALAsset class]]){
            ALAsset *asset = self.videosArr[i];
            //将视频转换成NSData
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            formDatas.data = data;
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.videosArr[i] original_path]]]];
            formDatas.data = data;
        }
        formDatas.name = [NSString stringWithFormat:@"PhotoAddress%lu",i+self.photosArr.count];
        formDatas.filename = [NSString stringWithFormat:@"PhotoAddress%lu.mp4",i+self.photosArr.count];
        formDatas.mimeType = @"video/quicktime";
        [arr addObject:formDatas];
        if (!formDatas.data) {
            updateImage = NO;
        }
    }
    NSString *PhotoNum;
    NSString *photoCount;
    if (updateImage) {
        PhotoNum = [NSString stringWithFormat:@"%lu",self.photosArr.count+self.videosArr.count];
        photoCount = [NSString stringWithFormat:@"%lu",self.photosArr.count];
    }else{
        PhotoNum = @"";
        photoCount = @"";
        arr = nil;
    }
    
    NSDictionary *params;
    if (self.listModel) {
        NSDictionary *dic = @{@"action":@"UpdateRecruit",
                              @"username":shareModel.username,
                              @"password":shareModel.password,
                              @"user_id":shareModel.dic[@"userid"],
                              @"epId":_listModel.epId,
                              @"epName":[(SPItemView *)[self.view viewWithTag:20] title],
                              @"epIndustry":[(SPItemView *)[self.view viewWithTag:21] title],
                              @"epIndustryId":[(SPItemView *)[self.view viewWithTag:21] industryId],
                              @"epType":[(SPItemView *)[self.view viewWithTag:22] title],
                              @"enterprise_scale":[(SPItemView *)[self.view viewWithTag:23] title],
                              @"enterprise_brief":[(SPTextView *)[self.view viewWithTag:25] title],
                              @"PhotoNum":PhotoNum,
                              @"photoCount":photoCount
                              };
        params = [NSDictionary dictionaryWithDictionary:dic];
    }else{
        NSDictionary *dic = @{@"action":@"addenterprise",
                              @"username":shareModel.username,
                              @"password":shareModel.password,
                              @"user_id":shareModel.dic[@"userid"],
                              @"epName":[(SPItemView *)[self.view viewWithTag:20] title],
                              @"epIndustry":[(SPItemView *)[self.view viewWithTag:21] title],
                              @"epIndustryId":[(SPItemView *)[self.view viewWithTag:21] industryId],
                              @"epType":[(SPItemView *)[self.view viewWithTag:22] title],
                              @"enterprise_scale":[(SPItemView *)[self.view viewWithTag:23] title],
                              @"enterprise_brief":[(SPTextView *)[self.view viewWithTag:25] title],
                              @"PhotoNum":PhotoNum,
                              @"photoCount":photoCount
                              };
        params = [NSDictionary dictionaryWithDictionary:dic];
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:strUrl params:params formDataArray:arr success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([json[@"status"] isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
            SPRecuilistModel *model = [SPRecuilistModel mj_objectWithKeyValues:json];
            [self performSelector:@selector(delay:) withObject:model afterDelay:1];
        }else{
            [MBProgressHUD showError:@"修改失败，请重试" toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)delay:(SPRecuilistModel *)recuilistModel{
    if (self.delegate) {
        //        WPCompanyListModel *model = [[WPCompanyListModel alloc]init];
        //        model.enterprise_name = recuilistModel.epName;
        //        model.Industry = recuilistModel.Industry;
        //        model.Industry_id = recuilistModel.Industryid;
        //        model.enterprise_properties = recuilistModel.enterprise_properties;
        //        model.enterprise_scale = recuilistModel.enterprise_scale;
        //        model.enterprise_brief = recuilistModel.enterprise_brief;
        //        model.dvList = recuilistModel.dvList;
        //        model.pohotoList = recuilistModel.pohotoList;
        //        model.QR_code = recuilistModel.background;
        [self.delegate RefreshCompanyInfo1:recuilistModel];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 交互层
- (void)buttonItem:(NSInteger)tag
{
    _selectNum = tag;
    [self.verOneScrollView endEditing:YES];
    NSMutableArray *scaleArr = [[NSMutableArray alloc]init];
    NSMutableArray *natureArr = [[NSMutableArray alloc]init];
    
    NSArray *scale = @[@"1-49人",@"50-99人",@"100-499人",@"500-999人",@"1000以上"];
    NSArray *nature = @[@"个人企业",@"非盈利机构",@"政府机关",@"事业单位",@"上市公司",@"中外合资/合作",@"外商独资/办事处"];
    
    for (int i = 0; i < scale.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = scale[i];
        model.industryID = scale[i];
        [scaleArr addObject:model];
    }
    
    for (int i = 0; i < nature.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = nature[i];
        model.industryID = nature[i];
        [natureArr addObject:model];
    }
    
    switch (tag) {
        case 20:
            
            break;
        case 21:
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getIndustry",@"fatherid":@"0"}];
            self.selectView.isIndustry = YES;
            break;
        case 22:
            [self.selectView setLocalData:natureArr];
            break;
        case 23:
            [self.selectView setLocalData:scaleArr];
            break;
        default:
            break;
    }
}

#pragma mark 右按钮点击
-(void)rightButtonItemClick:(UIButton *)sender
{
    NSLog(@"完成");
    if ([[(SPItemView *)[self.view viewWithTag:20] title] isEqualToString:@""]) {
        [MBProgressHUD alertView:@"" Message:@"请填写企业名称"];
    }else if ([[(SPItemView *)[self.view viewWithTag:21] title] isEqualToString:@"请选择行业"]){
        [MBProgressHUD alertView:@"" Message:@"请选择行业"];
    }else if ([[(SPItemView *)[self.view viewWithTag:22] title] isEqualToString:@"请选择企业性质"]){
        [MBProgressHUD alertView:@"" Message:@"请选择企业性质"];
    }else if ([[(SPItemView *)[self.view viewWithTag:23] title] isEqualToString:@"请选择企业规模"]){
        [MBProgressHUD alertView:@"" Message:@"请选择企业规模"];
    }else if ([[(SPTextView *)[self.view viewWithTag:25] title] isEqualToString:@""]){
        [MBProgressHUD alertView:@"" Message:@"请填写公司简介"];
    }else{
        [self updateCompanyInfo];
    }
}

#pragma mark 查看图片
-(void)checkImageClick:(UIButton *)sender
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < self.photosArr.count; i++) {/**< 头像或背景图 */
        MJPhoto *photo = [[MJPhoto alloc]init];
        if ([self.photosArr[i] isKindOfClass:[Pohotolist class]]) {
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] original_path]]];
            photo.url = url;
        }else{
            photo.image = [self.photosArr[i] originImage];
        }
        photo.srcImageView = [(UIButton *)[self.photosView viewWithTag:PhotoTag+i] imageView];
        [arr addObject:photo];
    }
    SPPhotoBrowser *brower = [[SPPhotoBrowser alloc] init];
    brower.delegate = self;
    brower.currentPhotoIndex = sender.tag-PhotoTag;
    brower.photos = arr;
    [brower show];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag-PhotoTag inSection:0];
//    // 图片游览器
//    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
//    // 缩放动画
//    photoBrowser.status = UIViewAnimationAnimationStatusFade;
//    // 可以删除
//    photoBrowser.editing = YES;
//    // 数据源/delegate
//    photoBrowser.delegate = self;
//    photoBrowser.dataSource = self;
//    // 当前选中的值
//    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
//    // 展示控制器
//    [photoBrowser showPickerVc:self];
}

- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser deleteImageAtIndex:(NSInteger)index{
    [self.photosArr removeObjectAtIndex:index];
    [self updatePhotosView];
}

- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser coverImageAtIndex:(NSInteger)index{
    id photo = self.photosArr[index];
    [self.photosArr removeObjectAtIndex:index];
    [self.photosArr insertObject:photo atIndex:0];
    [self updatePhotosView];
}

//- (NSInteger)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
//    return self.photosArr.count;
//}
//
//#pragma mark 每个组展示什么图片,需要包装下MLPhotoBrowserPhoto
//- (MLPhotoBrowserPhoto *) photoBrowser:(MLPhotoBrowserViewController *)browser photoAtIndexPath:(NSIndexPath *)indexPath{
//    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
//    MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
//    if ([self.photosArr[indexPath.row] isKindOfClass:[SPPhotoAsset class]]) {
//        photo.photoObj = [[self.photosArr objectAtIndex:indexPath.row] originImage];
//    }else{
//        photo.photoObj = [IPADDRESS stringByAppendingString:[self.photosArr[indexPath.row] original_path]];
//    }
//    // 缩略图
//    UIButton *btn = (UIButton *)[self.photosView viewWithTag:indexPath.row+PhotoTag];
//    photo.toView = btn.imageView;
//    //    photo.thumbImage = btn.imageView.image;
//    return photo;
//}
//
//#pragma mark <MLPhotoBrowserViewControllerDelegate>
//- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser coverPhotoAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIImage *photo = self.photosArr[indexPath.row];
//    [self.photosArr removeObjectAtIndex:indexPath.row];
//    [self.photosArr insertObject:photo atIndex:0];
//    [self updatePhotosView];
//}
//
//#pragma mark <MLPhotoBrowserViewControllerDelegate>
//- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
//    [self.photosArr removeObjectAtIndex:indexPath.row];
//    [self updatePhotosView];
//}

#pragma mark - 查看全部照片视频
-(void)checkAllPhotos
{
    SAYPhotoManagerViewController *vc = [[SAYPhotoManagerViewController alloc]init];
    vc.arr = self.photosArr;
    vc.videoArr = self.videosArr;
    vc.isEdit = YES;
    vc.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

#pragma mark - 查看视频墙（弃用）
-(void)checkAllVideos
{
    SAYVideoManagerViewController *vc = [[SAYVideoManagerViewController alloc]init];
    vc.arr = self.videosArr;
    //    vc.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

#pragma mark - 查看视频
-(void)checkVideoClick:(UIButton *)sender
{
    NSLog(@"观看视频");
    if ([self.videosArr[sender.tag-VideoTag] isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL fileURLWithPath:self.videosArr[sender.tag-VideoTag]];
        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    } else if([self.videosArr[sender.tag-VideoTag] isKindOfClass:[ALAsset class]]){
        ALAsset *asset = self.videosArr[sender.tag-VideoTag];
        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
    }else{
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.videosArr[sender.tag-VideoTag] original_path]]];
        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    }
    //指定媒体类型为文件
    _moviePlayerVC.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming|MPMovieSourceTypeFile;
    
    //通知中心
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPlaybackFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [self presentViewController:_moviePlayerVC animated:YES completion:^{}];
}

- (void)onPlaybackFinished
{
    NSLog(@"onPlaybackFinished");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

#pragma mark - 选择照片，视频
-(void)recuilistTagClick:(UIButton *)sender
{
    if (sender.tag == TagAddPhoto) {
        WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机",@"视频"] imageNames:nil top:64];
        actionSheet.tag = TagPhotoSheet;
        [actionSheet showInView:self.view];
    }
//    if (sender.tag == TagAddVideo) {
//        WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相机",@"相册"] imageNames:nil top:0];
//        actionSheet.tag = TagVideoSheet;
//        [actionSheet showInView:self.view];
//    }
    if (sender.tag == TagShowAllPhotos) {
        [self checkAllPhotos];
    }
    if (sender.tag == TagShowAllVideos) {
        [self checkAllVideos];
    }
    if (sender.tag == TagBack) {
        SPActionSheet *action = [[SPActionSheet alloc]initWithTitle:@"更换背景封面" delegate:self];
        [action show];
    }
    if (sender.tag == TagAddLogo) {
        WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机"] imageNames:nil top:64];
        actionSheet.tag = TagLogoSheet;
        [actionSheet showInView:self.view];
    }
}
#pragma mark - 代理回调函数
#pragma mark 代理回调函数 -SPSelectView 刷新选择内容
-(void)SPSelectViewDelegate:(IndustryModel *)model
{
    SPItemView *item = (SPItemView *)[self.verOneScrollView viewWithTag:_selectNum];
    [item resetTitle:model.industryName];
    switch (_selectNum) {
        case 21:
            item.industryId = model.industryID;
            break;
        default:
            break;
    }
}

#pragma mark 代理回调函数 - WPActionSheet
-(void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (sheet.tag == TagPhotoSheet) {
        if (buttonIndex == 2) {
            [self fromCamera];
        }
        if (buttonIndex == 1) {
            [self fromAlbums];
        }
        if (buttonIndex == 3) {
            [self videoFromCamera];
        }
    }
    if (sheet.tag == TagVideoSheet) {
        if (buttonIndex == 1) {
            [self videoFromCamera];
        }
        if (buttonIndex == 2) {
            [self videoFromAlbums];
        }
    }
    if (sheet.tag == TagLogoSheet) {
        _number = TagLogoSheet;
        if (buttonIndex == 2) {
            [self fromCameraSingle:2];
        }
        if (buttonIndex == 1) {
            [self fromCameraSingle:1];
        }
    }
    if (sheet.tag == TagBackSheet) {
        _number = TagBackSheet;
        if (buttonIndex == 2) {
            [self fromCameraSingle:2];
        }
        if (buttonIndex == 1) {
            [self fromCameraSingle:1];
        }
    }
}

#pragma mark 代理回调函数 - SPActionSheet
-(void)SPActionSheetDelegate
{
    WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机"] imageNames:nil top:64];
    actionSheet.tag = TagBackSheet;
    [actionSheet showInView:self.view];
}

#pragma mark - 拍照，相册
- (void)fromCameraSingle:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    switch (buttonIndex) {
            
        case 1: //相册
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            
            break;
        case 2: //相机
#if TARGET_IPHONE_SIMULATOR
            
            NSLog(@"");
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"模拟器暂不支持相机功能" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            break;
#elif TARGET_OS_IPHONE
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            break;
#endif
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image=[info objectForKey:UIImagePickerControllerEditedImage];

    if (_number == TagLogoSheet) {
        UIButton *button = (UIButton *)[self.view viewWithTag:TagAddLogo];
        [button setImage:image forState:UIControlStateNormal];
    }if (_number == TagBackSheet) {
        UIButton *button = (UIButton *)[self.view viewWithTag:TagBack];
        int width = image.size.width;
        int height = GetHeight(width);
        UIImage *image1 = [UIImage scaleToSize:image size:CGSizeMake(width, height)];
        [button setImage:image1 forState:UIControlStateNormal];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 拍照
- (void)fromCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        //        [@"您的设备不支持拍照" alertInViewController:self];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    //picker.delegate = self;
//    UIImagePickerControllerEditedImage
//    UIImagePickerControllerMediaType
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    picker.bk_didCancelBlock = ^(UIImagePickerController *picker){
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    picker.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        SPPhotoAsset *asset = [[SPPhotoAsset alloc]init];
        asset.image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.photosArr addObject:asset];
        [self updatePhotosView];
        [picker dismissViewControllerAnimated:YES completion:NULL];
           };
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark 相册
- (void)fromAlbums {
    
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 12 - self.photosArr.count;
    //        [pickerVc show];
    [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
    pickerVc.callBack = ^(NSArray *assets){
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        for (MLSelectPhotoAssets *asset in assets) {
            SPPhotoAsset *spAsset = [[SPPhotoAsset alloc]init];
            spAsset.asset = asset.asset;
            [photos addObject:spAsset];
        }
        [self.photosArr addObjectsFromArray:photos];
        [self updatePhotosView];
    };
}

#pragma mark 录制视频
-(void)videoFromCamera
{
    DBTakeVideoVC *tackVedio = [[DBTakeVideoVC alloc] init];
    tackVedio.delegate = self;
    tackVedio.fileCount = 4-self.videosArr.count;
    tackVedio.takeVideoDelegate = self;
    [self.navigationController pushViewController:tackVedio animated:YES];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tackVedio];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark 选择视频
-(void)videoFromAlbums
{
    NSLog(@"导入视频");
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = 8-self.videosArr.count;
    picker.assetsFilter = [ALAssetsFilter allVideos];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark 从录制界面选择Video返回
-(void)sendBackVideoWith:(NSArray *)array
{
    [self.videosArr addObjectsFromArray:array];
    [self updatePhotosView];
}
#pragma mark 录制返回
-(void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
    [self.videosArr addObject:filePaht];
    [self updatePhotosView];
}
#pragma mark 直接选择Video返回
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [self.videosArr addObjectsFromArray:assets];
    [self updatePhotosView];
}

#pragma mark - 更新照片墙 SAYPhotoManagerViewController代理
-(void)UpdateImageDelegate:(NSArray *)arr VideoArr:(NSArray *)videoArr
{
    [self.photosArr removeAllObjects];
    [self.photosArr addObjectsFromArray:arr];
    [self updatePhotosView];
}

#pragma mark - 更新视频墙（弃用）
-(void)UpdateVideoDelegate:(NSArray *)arr
{
    [self.videosArr removeAllObjects];
    [self.videosArr addObjectsFromArray:arr];
    [self updatePhotosView];
}

#pragma mark - 停止交互
-(void)tap:(UITapGestureRecognizer *)tap
{
    [self.verOneScrollView endEditing:YES];
}

@end
