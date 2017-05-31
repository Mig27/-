//
//  WPRecruitDraftEditController.m
//  WP
//
//  Created by CBCCBC on 15/12/25.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPRecruitDraftEditController.h"
#import "VideoBrowser.h"

#import "WPRecruitController.h"
#import "WPActionSheet.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "DBTakeVideoVC.h"
#import "MLPhotoBrowserViewController.h"
#import "CTAssetsPickerController.h"
#import "SAYPhotoManagerViewController.h"
#import "SAYVideoManagerViewController.h"
#import "WPCompanyController.h"
#import "WPRecruitDraftController.h"
#import "WPCompanyBriefController.h"
#import "ActivityTextEditingController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <BlocksKit+UIKit.h>

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "SPPhotoAsset.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "SPPhotoBrowser.h"
#import "WPMySecurities.h"
#import "WPRecruitiew.h"
#import "SPShareView.h"
#import "SPItemView.h"
#import "SPTextView.h"
#import "SPSelectView.h"
#import "THLabel.h"
#import "SPButton.h"
#import "SPRecPreview.h"
#import "UIButton+WebCache.h"
#import "HJCActionSheet.h"

typedef NS_ENUM(NSInteger,WPRecruitDraftEditControllerActionType) {
    WPRecruitDraftEditControllerActionTypeNavigationItemComplete = 1/**< 完成 */,
    WPRecruitDraftEditControllerActionTypeNavigationItemDrafts = 2/**< 草稿 */,
    WPRecruitDraftEditControllerActionTypeChooseCompanyName = 3/**< 草稿 */,
    WPRecruitDraftEditControllerActionTypeCompanyLogo = 4/**< 公司LOGO */,
    WPRecruitDraftEditControllerActionTypeAddPhoto = 5/**< 添加图片或视频 */,
    WPRecruitDraftEditControllerActionTypePhotoviewPage = 6/**< 照片浏览 */,
    // 7 ~ 18 /**< 添加过的照片或视频TAG */
    WPRecruitDraftEditControllerActionTypeCompanyName = 20/**< 公司名称 */,
    WPRecruitDraftEditControllerActionTypeCompanyIndustry = 21/**< 公司行业 */,
    WPRecruitDraftEditControllerActionTypeCompanyProperty = 22/**< 公司性质 */,
    WPRecruitDraftEditControllerActionTypeCompanyScale = 23/**< 公司规模 */,
    WPRecruitDraftEditControllerActionTypeCompanyArea = 24/**< 公司地点 */,
    
    WPRecruitDraftEditControllerActionTypeCompanyDetailArea = 25,//公司具体地点
    
    WPRecruitDraftEditControllerActionTypePersonalName = 26/**< 联系人 */,
    WPRecruitDraftEditControllerActionTypeCompanyPhone = 27/**< 企业官网 */,
    WPRecruitDraftEditControllerActionTypeCompanyBrief = 28/**< 公司简介 */,
    WPRecruitDraftEditControllerActionTypeMoreConditions = 29/**< 更多条件 */,
    WPRecruitDraftEditControllerActionTypeMoreResume = 30/**< 更多简历 */,
    WPRecruitDraftEditControllerActionTypePhone = 70/**< 企业电话 */,
    WPRecruitDraftEditControllerActionTypeQQ = 71/**< 企业QQ */,
    WPRecruitDraftEditControllerActionTypeWeChat = 72/**< 企业微信 */,
    WPRecruitDraftEditControllerActionTypeWebsite = 73/**< 企业官网 */,
    WPRecruitDraftEditControllerActionTypeEmail = 74 /**< 企业邮箱 */,
};

@interface WPRecruitDraftEditController ()

<SPSelectViewDelegate,WPActionSheet,
callBackVideo,takeVideoBack,
CTAssetsPickerControllerDelegate,
UpdateImageDelegate,
WPGetCompanyInfoDelegate,
WPGetDraftInfoDelegate,
UINavigationControllerDelegate,
UIScrollViewDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,
UIAlertViewDelegate,
SPPhotoBrowserDelegate,
WPCompanyBriefDelegate,
HJCActionSheetDelegate
>

//@property (strong, nonatomic) UIScrollView *horScrollView;
@property (strong, nonatomic) UIScrollView *verOneScrollView;
//@property (strong, nonatomic) UIScrollView *verOnesScrollView;
@property (strong, nonatomic) UIView *headView;
//@property (strong, nonatomic) UIView *headsView;
@property (strong, nonatomic) UIView *chooseComapnyView;
@property (strong, nonatomic) UIView *addMoreResumeView;
@property (strong, nonatomic) UIView *moreConditionView;
//@property (strong, nonatomic) UIView *indicatorView;
@property (strong, nonatomic) WPRecruitiew *recruitView;

@property (strong, nonatomic) UIScrollView *photosView;
//@property (strong, nonatomic) UIScrollView *videosView;

@property (strong, nonatomic) NSMutableArray *photosArr;
@property (strong, nonatomic) NSMutableArray *videosArr;

@property (strong, nonatomic) UIButton *addPhotoBtn;
//@property (strong, nonatomic) UIButton *addVideoBtn;

@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayerVC;

@property (assign, nonatomic) NSInteger number;
@property (assign, nonatomic) NSInteger bodyNumber;
@property (assign, nonatomic) NSInteger recruitResumeCount;
@property (assign, nonatomic) NSInteger nextTop;

@property (strong, nonatomic) SPSelectView *selectView;
@property (assign, nonatomic) NSInteger selectNum;

@property (assign, nonatomic) NSInteger defaultSid;

@property (strong, nonatomic) SPRecPreview *recPreview;
@property (strong, nonatomic) UIView *sendbottomView;

@property (nonatomic, strong) UILabel *draftNumber;/**< 草稿数量 */

@property (nonatomic, strong) NSArray *briefArray;/**< 公司简介数组 */
@property (nonatomic, copy) NSString *briefString;//公司简介描述
@property (nonatomic, strong) UIButton *draftButton;
@property (nonatomic, strong) WPActionSheet *actionSheet;
@property (nonatomic, assign) BOOL isShareHiden;


@end

/**
 *  Controller中tag统计
 PhotoSheet 18
 VideoSheet 19
 headView 1~30
 BodyView 100、200、300、400、500
 */

#define TagPhotoSheet 40
#define TagVideoSheet 41
#define TagLogoSheet 42
#define TagBackSheet 43

#define PhotoTag 7 /**< 照片起始TAG */
#define VideoTag 15/**< 视频起始TAG */



#define RecuilistHeight (ItemViewHeight*11)
#define RecruitResumeHeight (ItemViewHeight*11+ItemViewHeight)

@implementation WPRecruitDraftEditController
{
    BOOL showedTelephone; //是否显示手机号
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:nil];
    [self.view addGestureRecognizer:pan];
    
    self.title = @"企业招聘信息";
    
    _number = 0;
    _nextTop = 0;
    _recruitResumeCount = 0;
    _bodyNumber = 100;
    
    [self requestDraftCount];
    
    [self setNavigationItem];
    
    //不区分有无简历,只区分有无选择企业
    [self.view addSubview:self.verOneScrollView];
    /*
     //区分有无简历(弃用)
     if (_isFirst) {
     [self.view addSubview:self.verOneScrollView];
     }else{
     [self.view addSubview:self.verOnesScrollView];
     }
     */
}

#pragma mark - 数据层
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

- (NSArray *)briefArray{
    if (!_briefArray) {
        _briefArray = [[NSArray alloc]init];
        
    }
    return _briefArray;
}
-(NSString *)briefString
{
    if ( !_briefString) {
        _briefString= [[NSString alloc]init];
    }
    return _briefString;
}
- (WPCompanyListModel *)model{
    if (!_model) {
        _model = [[WPCompanyListModel alloc]init];
        _model.enterpriseName = [self ModelPropretyNotNull:_model.enterpriseName];
        _model.dataIndustry = [self ModelPropretyNotNull:_model.dataIndustry];
        _model.dataIndustryId = [self ModelPropretyNotNull:_model.dataIndustryId];
        _model.enterpriseProperties = [self ModelPropretyNotNull:_model.enterpriseProperties];
        _model.enterpriseScale = [self ModelPropretyNotNull:_model.enterpriseScale];
        _model.enterpriseAddress = [self ModelPropretyNotNull:_model.enterpriseAddress];
        _model.enterpriseAddressID = [self ModelPropretyNotNull:_model.enterpriseAddressID];
        _model.enterprisePersonName = [self ModelPropretyNotNull:_model.enterprisePersonName];
        _model.enterprisePersonTel = [self ModelPropretyNotNull:_model.enterprisePersonTel];
        _model.enterpriseBrief = [self ModelPropretyNotNull:_model.enterpriseBrief];
        _model.enterpriseName = [self ModelPropretyNotNull:_model.enterpriseName];
        _model.enterprisePhone = [self ModelPropretyNotNull:_model.enterprisePhone];
        _model.enterpriseQq = [self ModelPropretyNotNull:_model.enterpriseQq];
        _model.enterpriseWebchat = [self ModelPropretyNotNull:_model.enterpriseWebchat];
        _model.enterpriseWebsite = [self ModelPropretyNotNull:_model.enterpriseWebsite];
        _model.enterpriseEmail = [self ModelPropretyNotNull:_model.enterpriseEmail];
        _model.enterpriseDewtailAddress = [self ModelPropretyNotNull:_model.enterpriseDewtailAddress];
    }
    return _model;
}

//- (void)setModel:(WPCompanyListModel *)model{
//if (model&&[model isKindOfClass:[WPCompanyListModel class]]) {
//_model = model;
//}else{
//_model = [[WPCompanyListModel alloc]init];
//}
//_model.enterpriseName = [self ModelPropretyNotNull:_model.enterpriseName];
//_model.dataIndustry = [self ModelPropretyNotNull:_model.dataIndustry];
//_model.dataIndustryId = [self ModelPropretyNotNull:_model.dataIndustryId];
//_model.enterpriseProperties = [self ModelPropretyNotNull:_model.enterpriseProperties];
//_model.enterpriseScale = [self ModelPropretyNotNull:_model.enterpriseScale];
//_model.enterpriseAddress = [self ModelPropretyNotNull:_model.enterpriseAddress];
//_model.enterpriseAddressID = [self ModelPropretyNotNull:_model.enterpriseAddressID];
//_model.enterprisePersonName = [self ModelPropretyNotNull:_model.enterprisePersonName];
//_model.enterprisePersonTel = [self ModelPropretyNotNull:_model.enterprisePersonTel];
//_model.enterpriseBrief = [self ModelPropretyNotNull:_model.enterpriseBrief];
//_model.enterpriseName = [self ModelPropretyNotNull:_model.enterpriseName];
//_model.enterprisePhone = [self ModelPropretyNotNull:_model.enterprisePhone];
////_model.enterpriseQq = [self ModelPropretyNotNull:_model.enterpriseQq];
//_model.enterpriseWebchat = [self ModelPropretyNotNull:_model.enterpriseWebchat];
//_model.enterpriseWebsite = [self ModelPropretyNotNull:_model.enterpriseWebsite];
//_model.enterpriseEmail = [self ModelPropretyNotNull:_model.enterpriseEmail];
//}

- (void)setInfomodel:(WPRecruitDraftInfoModel *)Infomodel{
    _Infomodel = Infomodel;
    [self getDraftInfo:Infomodel];
    if (self.type == WPRecuitEditTypeInfo) {
        self.sendbottomView.hidden = YES;
        _isShareHiden = YES;
        [self AddrecPreview];
    }
}

#pragma mark - 初始化子视图
-(void)setNavigationItem
{
    //self.title = @"草稿信息";
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(0, 0, 50, 44);
    completeBtn.tag = WPRecruitDraftEditControllerActionTypeNavigationItemComplete;
    [completeBtn normalTitle:@"完成" Color:RGB(0, 0, 0) Font:kFONT(14)];
    [completeBtn selectedTitle:@"编辑" Color:RGB(0, 0, 0)];
    completeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [completeBtn addTarget:self action:@selector(rightButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *completeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:completeBtn];
    
    //_draftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //_draftButton.frame = CGRectMake(0, 0, 55, 44);
    //[_draftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    //_draftButton.tag = WPRecruitDraftEditControllerActionTypeNavigationItemDrafts;
    //[_draftButton normalTitle:@"草稿" Color:RGB(0, 0, 0) Font:kFONT(14)];
    //_draftNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, 13, 20, 20)];
    //_draftNumber.backgroundColor = RGB(10, 110, 210);
    //_draftNumber.layer.cornerRadius = 10;
    //_draftNumber.layer.masksToBounds = YES;
    //_draftNumber.text = @"0";
    //_draftNumber.font = kFONT(12);
    //_draftNumber.textColor = [UIColor whiteColor];
    //_draftNumber.textAlignment = NSTextAlignmentCenter;
    //[_draftButton addSubview:_draftNumber];
    //[_draftButton addTarget:self action:@selector(rightButtonDraftClick:) forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem *draftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_draftButton];
    self.navigationItem.rightBarButtonItem = completeButtonItem;
    
    if (self.type == WPRecuitEditTypeInfo) {
        completeBtn.selected = YES;
    }
}

/*
 -(UIScrollView *)horScrollView
 {
 if (!_horScrollView) {
 _horScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
 _horScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT-64-49);
 _horScrollView.delegate = self;
 _horScrollView.showsHorizontalScrollIndicator = NO;
 _horScrollView.pagingEnabled = YES;
 
 for (int i = 1; i < 3; i++) {
 UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, SCREEN_HEIGHT/2-60, SCREEN_WIDTH, 40)];
 label.text = @"正在开发中";
 label.textAlignment = NSTextAlignmentCenter;
 [_horScrollView addSubview:label];
 }
 }
 return _horScrollView;
 }
 */
-(UIScrollView *)verOneScrollView
{
    if (!_verOneScrollView) {
        _verOneScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        CGFloat headViewHeight = self.headView.height+kListEdge+self.recruitView.height+kListEdge;//+self.moreConditionView.height+kListEdge+kListEdge
        _verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, headViewHeight);
        _verOneScrollView.backgroundColor = RGB(235, 235, 235);
        
        //[_verOneScrollView addSubview:self.chooseComapnyView];
        //1?(self.chooseComapnyView.height = 0):0;
        //self.chooseComapnyView.height = 0;
        [_verOneScrollView addSubview:self.headView];
        [_verOneScrollView addSubview:self.recruitView];
//        [_verOneScrollView addSubview:self.moreConditionView];
        //[_verOneScrollView addSubview:self.addMoreResumeView];
    }
    return _verOneScrollView;
}
/*
 -(UIScrollView *)verOnesScrollView
 {
 if (!_verOnesScrollView) {
 _verOnesScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
 _verOnesScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.headsView.height+10+RecuilistHeight+10+ItemViewHeight+10);
 _verOnesScrollView.backgroundColor = RGB(235, 235, 235);
 
 [_verOnesScrollView addSubview:self.headsView];
 //        [_verOnesScrollView addSubview:self.recuilistView];
 [self firstRecuilistView];
 [_verOnesScrollView addSubview:self.shareView];
 }
 return _verOnesScrollView;
 }
 */
- (UIView *)chooseComapnyView
{
    if (!_chooseComapnyView) {
        _chooseComapnyView = [[UIView alloc]initWithFrame:CGRectMake(0, kListEdge, SCREEN_WIDTH, kHEIGHT(43))];
        _chooseComapnyView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, kHEIGHT(43))];
        label.text = @"请选择企业";
        label.font = kFONT(15);
        [_chooseComapnyView addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 43);
        button.tag = WPRecruitDraftEditControllerActionTypeChooseCompanyName;
        [button normalTitle:@"" Color:RGB(153, 153, 153) Font:kFONT(15)];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [button addTarget:self action:@selector(chooseCompanyClick) forControlEvents:UIControlEventTouchUpInside];
        [_chooseComapnyView addSubview:button];
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"common_icon_arrow"]];
        imageV.frame = CGRectMake(_chooseComapnyView.width-15-15, _chooseComapnyView.height/2-7.5, 15,15);
        [_chooseComapnyView addSubview:imageV];
    }
    return _chooseComapnyView;
}

-(UIScrollView *)photosView
{
    if (!_photosView) {
        _photosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH-28, PhotoViewHeight)];//GetHeight(16)
        _photosView.backgroundColor = [UIColor whiteColor];
        _photosView.showsHorizontalScrollIndicator = NO;
        
        _addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPhotoBtn.frame = CGRectMake(10, 10, PhotoHeight, PhotoHeight);
        _addPhotoBtn.tag = WPRecruitDraftEditControllerActionTypeAddPhoto;
        [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
        [_addPhotoBtn addTarget:self action:@selector(recuilistTagClick:) forControlEvents:UIControlEventTouchUpInside];
        [_photosView addSubview:_addPhotoBtn];
        
        /**< 照片墙翻页 */
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-28, _photosView.top, 28, PhotoViewHeight) ImageName:@"jinru" Target:self Action:@selector(recuilistTagClick:)];
        scrollBtn.backgroundColor = [UIColor whiteColor];
        scrollBtn.tag = WPRecruitDraftEditControllerActionTypePhotoviewPage;
        [self.headView addSubview:scrollBtn];
    }
    return _photosView;
}

-(UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 0)];
        _headView.backgroundColor = RGB(235, 235, 235);
        
        //        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        backBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, GetHeight(SCREEN_WIDTH));
        //        //[backBtn setImage:[UIImage imageNamed:@"back_default"] forState:UIControlStateNormal];
        //        [backBtn addTarget:self action:@selector(recuilistTagClick:) forControlEvents:UIControlEventTouchUpInside];
        //        backBtn.tag = WPRecruitDraftEditControllerActionTypeCompanyLogo;
        //        [_headView addSubview:backBtn];
        
        [_headView addSubview:self.photosView];
        
//        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, _photosView.top, SCREEN_WIDTH, 0.5)];
//        line.backgroundColor = RGB(178, 178, 178);
//        [self.headView addSubview:line];
//        
//        UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _photosView.bottom-0.5, SCREEN_WIDTH, 0.5)];
//        line1.backgroundColor = RGB(178, 178, 178);
//        [self.headView addSubview:line1];
        
        NSArray *titleArr = @[@"企业名称:",@"企业行业:",@"企业性质:",@"企业规模:",@"企业区域:",@"详细地址:",@"联  系 人:",@"企业官网:",@"企业描述:"];
        NSArray *placeHolderArr = @[@"请填写企业名称",@"请选择行业",@"请选择企业性质",@"请选择企业规模",@"请选择企业区域",@"请输入详细地址",@"请输入联系人",@"请输入企业官网",@"请输入企业描述"];
        NSArray *styleArr = @[kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeText,kCellTypeText,kCellTypeText,kCellTypeButton];
        
        UIView *lastview = nil;
        __weak typeof(self) weakSelf = self;
        for (int i = 0; i < titleArr.count; i++) {
            CGFloat top = lastview?lastview.bottom:self.photosView.bottom+8;
            SPItemView *item = [[SPItemView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight)];
            [item setTitle:titleArr[i] placeholder:placeHolderArr[i] style:styleArr[i]];
            item.tag = WPRecruitDraftEditControllerActionTypeCompanyName+i;
            item.SPItemBlock = ^(NSInteger tag){
                [weakSelf buttonItem:tag];
            };
            
            item.tag ==WPRecruitDraftEditControllerActionTypeCompanyPhone?(item.textField.keyboardType = UIKeyboardTypeURL):0;
            
            item.hideFromFont = ^(NSInteger tag, NSString *title){
                SPItemView *itemview = (SPItemView *)[weakSelf.view viewWithTag:tag];
                [itemview resetTitle:title];
                switch (tag) {
                    case WPRecruitDraftEditControllerActionTypeCompanyName:
                        self.model.enterpriseName = title;
                        break;
                    case WPRecruitDraftEditControllerActionTypePersonalName:
                        self.model.enterprisePersonName = title;
                        break;
                    case WPRecruitDraftEditControllerActionTypeCompanyPhone://企业官网
                        self.model.enterpriseWebsite = title;
                        break;
                    case WPRecruitDraftEditControllerActionTypeCompanyDetailArea://详细地址
                        self.model.enterpriseDewtailAddress = title;
                        break;
                }
            };
            [_headView addSubview:item];
            
            lastview = item;
        }
        //        WS(ws);
        //        //公司简介
        //        SPTextView *worksView = [[SPTextView alloc]initWithFrame:CGRectMake(0, lastview.bottom, SCREEN_WIDTH, 170)];
        //        worksView.tag = WPRecruitControllerActionTypeCompanyBrief;
        //        [worksView setWithTitle:@"公司简介:" placeholder:@"请填写公司简介"];
        //        worksView.hideFromFont = ^(NSString *title){
        //            ws.model.enterpriseBrief = title;
        //        };
        //        [_headView addSubview:worksView];
        //
        //        //获取headview最后子视图的bottom，设置headview的高度
        _headView.height = lastview.bottom;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [_headView addGestureRecognizer:tap];
    }
    return _headView;
}

-(void)updatePhotosView
{
    for (UIView *view in self.photosView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < self.photosArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
        button.tag = PhotoTag+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        if ([self.photosArr[i] isKindOfClass:[Pohotolist class]]) {
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] original_path]]];
            [button sd_setImageWithURL:url forState:UIControlStateNormal];
        }else{
            [button setImage:[self.photosArr[i] thumbImage] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.photosView addSubview:button];
        
    }
    
    CGFloat width = self.photosArr.count*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12);
    for (int i = 0; i < self.videosArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+kHEIGHT(6))+width, 10, PhotoHeight, PhotoHeight);
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
    
    if (self.photosArr.count == 8) {//&&self.videosArr.count == 4
        self.photosView.contentSize = CGSizeMake(8*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), PhotoViewHeight);
    }else{
        NSInteger count = self.photosArr.count+self.videosArr.count;
        self.photosView.contentSize = CGSizeMake(count*(PhotoHeight+kHEIGHT(6))+PhotoHeight+kHEIGHT(12), PhotoViewHeight);
        _addPhotoBtn.frame = CGRectMake(count*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
        [self.photosView addSubview:_addPhotoBtn];
    }
}
/*
 -(UIView *)headsView
 {
 if (!_headsView) {
 
 _headsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ItemViewHeight+10+10+GetHeight(SCREEN_WIDTH))];
 
 SPItemView *view = [[SPItemView alloc]initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, 48)];
 [view setTitle:@"请选择企业" placeholder:@"默认 杭州阿里巴巴" style:kCellTypeButton];
 [view.button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
 [_headsView addSubview:view];
 
 UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, ItemViewHeight)];
 view.backgroundColor = [UIColor whiteColor];
 
 UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 160, ItemViewHeight)];
 label.text = @"请选择企业";
 label.font = kFONT(15);
 [view addSubview:label];
 
 UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
 button.frame = CGRectMake(120, 0, SCREEN_WIDTH-120-26, ItemViewHeight);
 button.titleLabel.font = kFONT(12);
 button.tag = WPRecruitControllerActionTypeChooseCompanyName;
 NSString *str = [NSString stringWithFormat:@"默认·%@",self.model.epName];
 [button setTitle:str forState:UIControlStateNormal];
 [button setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
 [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
 [button addTarget:self action:@selector(chooseCompanyClick) forControlEvents:UIControlEventTouchUpInside];
 [view addSubview:button];
 
 UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
 button1.frame = CGRectMake(button.right, 0, SCREEN_WIDTH-button.right, ItemViewHeight);
 [button1 addTarget:self action:@selector(chooseCompanyClick) forControlEvents:UIControlEventTouchUpInside];
 [view addSubview:button1];
 
 UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"jinru"]];
 imageV.frame = CGRectMake(view.width-10-8, view.height/2-7, 8,14);
 [view addSubview:imageV];
 
 [_headsView addSubview:view];
 
 UIImageView *backImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, view.bottom+8, SCREEN_WIDTH, GetHeight(SCREEN_WIDTH))];
 backImageV.userInteractionEnabled = YES;
 NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.model.background]];
 backImageV.tag = TagRefreshBack;
 [backImageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"back_default"]];
 [_headsView addSubview:backImageV];
 
 UITapGestureRecognizer *backtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyCLick)];
 [backImageV addGestureRecognizer:backtap];
 
 //        UIImageView *headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(24, backImageV.height-24-72, 72, 72)];
 //        headImageV.tag = TagRefreshHead;
 //        NSURL *url1 = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.model.logo]];
 //        [headImageV sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"defaultHead"]];
 //        [backImageV addSubview:headImageV];
 
 THLabel *company = [[THLabel alloc]initWithFrame:CGRectMake(8, backImageV.height-10-15-8-20, SCREEN_WIDTH-12, 20)];
 company.tag = TagCompany;
 if ([self.model.epName hasPrefix:@"默认·"]) {
 company.text = [self.model.epName substringFromIndex:3];
 }else{
 company.text = self.model.epName;
 }
 company.font = kFONT(15);
 company.textColor = [UIColor whiteColor];
 company.shadowColor = kShadowColor1;
 company.shadowOffset = kShadowOffset;
 company.shadowBlur = kShadowBlur;
 [backImageV addSubview:company];
 
 THLabel *message = [[THLabel alloc]initWithFrame:CGRectMake(8, backImageV.height-10-15, SCREEN_WIDTH-12, 15)];
 message.tag = TagInfo;
 message.text = [NSString stringWithFormat:@"%@ %@ %@",self.model.Industry,self.model.enterprise_properties,self.model.enterprise_scale];
 message.font = kFONT(12);
 message.textColor = [UIColor whiteColor];
 message.shadowColor = kShadowColor1;
 message.shadowOffset = kShadowOffset;
 message.shadowBlur = kShadowBlur;
 [backImageV addSubview:message];
 
 UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
 [_headsView addGestureRecognizer:tap];
 }
 return _headsView;
 }
 */

- (WPRecruitiew *)recruitView
{
    if (!_recruitView) {
        /*
         _isFirst?(height = self.headView.bottom+10):(height = self.headsView.bottom+10);
         */
        _recruitView = [[WPRecruitiew alloc]initWithFrame:CGRectMake(0, self.headView.bottom+kListEdge, SCREEN_WIDTH, RecuilistHeight)];
        [_recruitView setNumber:100];
        _recruitView.telephoneShowOrHiddenBlock = ^(BOOL showed){
            showedTelephone = showed;
        };
        WS(ws);
        _recruitView.InputPositionRequireBlock = ^(NSInteger tag){
            ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
            
            NSString * string = [WPMySecurities textFromBase64String:ws.recruitView.model.requstString];
            string = [WPMySecurities textFromEmojiString:string];
            if (string.length) {
                editing.textFieldString = string;
            }
            else
            {
              editing.textFieldString = ((ws.recruitView.model.requstString.length)&& (![ws.recruitView.model.requstString isEqualToString:@"(null)"]))?ws.recruitView.model.requstString:@"";
            }
            editing.verifyClickBlock = ^(NSAttributedString *attributedString){
                ws.recruitView.model.requstString = attributedString;
                if (ws.recruitView.model.requstString.length) {
                    SPItemView *item = (SPItemView *)[ws.recruitView viewWithTag:tag];
                    [item resetTitle:@"任职要求已填写"];
                }
                else
                {
                    SPItemView *item = (SPItemView *)[ws.recruitView viewWithTag:tag];
                    [item resetTitle:@""];
                }
            };
            [ws.navigationController pushViewController:editing animated:YES];
        };
    }
    return _recruitView;
}

- (UIView *)moreConditionView{
    
    if (!_moreConditionView) {
        CGFloat top = self.recruitView.bottom+kListEdge;
        _moreConditionView = [[UIView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight)];
        _moreConditionView.backgroundColor = [UIColor redColor];
        
        SPButton *button = [[SPButton alloc]initWithFrame:_moreConditionView.bounds title:@"更多条件(可填可不填)" ImageName:@"tianjiafeiyong" Target:self Action:@selector(showMoreConditionAction:)];
        button.tag = WPRecruitDraftEditControllerActionTypeMoreConditions;
        button.contentLabel.textColor = [UIColor blackColor];
        [_moreConditionView addSubview:button];
    }
    return _moreConditionView;
}
/*
 - (void)addMoreRecuilistView{
 __weak typeof(self) weakSelf = self;
 
 _nextTop = _recruitResumeCount*RecuilistHeight+_recruitResumeCount*kListEdge+self.moreConditionView.bottom+kListEdge;
 
 if (_isFirst) {
 _nextTop = _bodyCount*RecuilistHeight+_bodyCount*10+self.headView.bottom+10;
 }else{
 _nextTop = _bodyCount*RecuilistHeight+_bodyCount*10+self.headsView.bottom+10;
 }
 
 WPRecruitiew *recuilistView = [[WPRecruitiew alloc]initWithFrame:CGRectMake(0, _nextTop, SCREEN_WIDTH, RecuilistHeight)];
 recuilistView.deletePositionBlock = ^(NSInteger tag){
 [weakSelf compeleteDeletePosition:tag];
 };
 [recuilistView setNumber:_bodyNumber];
 
 [self.verOneScrollView addSubview:recuilistView];
 
 if (_isFirst) {
 [_verOneScrollView addSubview:recuilistView];
 }else{
 [_verOnesScrollView addSubview:recuilistView];
 }
 
 }
 */
-(UIView *)addMoreResumeView{
    if (!_addMoreResumeView) {
        _addMoreResumeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.moreConditionView.bottom+kListEdge, SCREEN_WIDTH, ItemViewHeight)];
        _addMoreResumeView.backgroundColor = [UIColor whiteColor];
        
        SPButton *button = [[SPButton alloc]initWithFrame:_addMoreResumeView.bounds title:@"招聘更多职位" ImageName:@"tianjiafeiyong" Target:self Action:@selector(addMorePosition)];
        button.contentLabel.textColor = RGB(0, 0, 0);
        [_addMoreResumeView addSubview:button];
    }
    return _addMoreResumeView;
}


/*
 - (UIView *)indicatorView
 {
 if (!_indicatorView) {
 _indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-3, SCREEN_WIDTH/3, 3)];
 _indicatorView.backgroundColor = [UIColor blueColor];
 }
 return _indicatorView;
 }
 */
-(SPSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[SPSelectView alloc]initWithTop:64];
        _selectView.delegate = self;
    }
    return _selectView;
}

#pragma mark - 展示or删除预览
- (void )AddrecPreview
{
    CGFloat height = self.sendbottomView.hidden?SCREEN_HEIGHT-64:SCREEN_HEIGHT-64-49;
    SPRecPreview *recPreview = [[SPRecPreview alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, height)];
    
    __weak typeof(self) weakSelf = self;
    recPreview.checkVideosBlock = ^(NSInteger num){
        [weakSelf checkVideos:num];
    };
    
    recPreview.checkAllVideosBlock = ^(){
        [weakSelf checkAllVideosBlock:NO];
    };
    
    NSMutableArray *recruitArr = [[NSMutableArray alloc]init];
    for (UIView *view in self.verOneScrollView.subviews) {
        if ([view isKindOfClass:[WPRecruitiew class]]) {
            [recruitArr addObject:[(WPRecruitiew *)view model]];
        }
    }
    
    WPRecruitPreviewModel *model = [[WPRecruitPreviewModel alloc]init];
    model.photosArr = self.photosArr;
    model.videosArr = self.videosArr;
//    model.briefArr = self.briefArray;
    model.briefStr = self.briefString;
    model.recruitResumeArr = recruitArr;
    UIImage *image = [(UIButton *)[self.verOneScrollView viewWithTag:WPRecruitDraftEditControllerActionTypeCompanyLogo] imageView].image;
    if (image == nil) {
        image = [UIImage imageNamed:@"back_default"];
    }
    model.logoArr = @[image];
    model.listModel = self.model;
    recPreview.model = model;
    
    if (_isShareHiden)
    {
        recPreview.share.hidden = YES;
        _isShareHiden = NO;
        
        CGSize size = recPreview.contentSize;
        size.height -= ItemViewHeight+kListEdge;
        recPreview.contentSize = size;
    }
    else
    {
        recPreview.share.hidden = NO;
//        CGSize size = recPreview.contentSize;
//        size.height += ItemViewHeight+kListEdge;
//        recPreview.contentSize = size;
    }
    [self.view addSubview:recPreview];
}
- (void)deleteRecPreview{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[SPRecPreview class]]) {
            [view removeFromSuperview];
        }
    }
}
#pragma mark - 发布视图
-(UIView *)sendbottomView
{
    if (!_sendbottomView) {
        
        _sendbottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _sendbottomView.backgroundColor = RGB(0, 172, 255);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
        
        NSString *str = @"";
        if (self.type == WPRecuitEditTypeDraft) {
            str = @"发布";
        }else{
            str = @"更新";
        }

        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = kFONT(15);
        button.tag = 90;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 4)];
        [button setImage:[UIImage imageNamed:(self.type == WPRecuitEditTypeDraft)?@"qz_fabu":@"qz_gengxin"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:(self.type == WPRecuitEditTypeDraft)?@"qz_fabu":@"qz_gengxin"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(completeAllMessage:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
        [_sendbottomView addSubview:button];
        
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_sendbottomView.width/2 - 7 -25, _sendbottomView.height/2-7, 14, 14)];
//        imageView.image = [UIImage imageNamed:@"publish"];
//        imageView.userInteractionEnabled = YES;
//        [_sendbottomView addSubview:imageView];
        
        
        _sendbottomView.hidden = YES;
        [self.view addSubview:_sendbottomView];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [_sendbottomView addSubview:line];
    }
    return _sendbottomView;
}
-(void)clickDown:(UIButton*)sender
{
    [sender setBackgroundColor:RGB(0, 146, 217)];
}
- (void)deleteAllClick{
    //    [MBProgressHUD createHUD:@"测试ing" View:self.view];
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"是否删除此次招聘简历" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];;
    [sheet showInView:self.view];
}

#pragma mark - 展示or隐藏更多条件
- (void)showMoreConditionAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    UIView *lastView  = nil;
    
    SPButton *button = (SPButton *)[self.moreConditionView viewWithTag:WPRecruitDraftEditControllerActionTypeMoreConditions];
    
    if (sender.selected) {/**< 展开更多信息 */
        NSArray *titleArr = @[@"企业电话:",@"企业Q Q:",@"企业微信:",@"企业官网:",@"企业邮箱:"];
        NSArray *placehorderArr = @[@"请输入企业电话",@"请输入企业QQ",@"请输入企业微信",@"请输入企业官网",@"请输入企业邮箱"];
        
        for (int i = 0; i < titleArr.count; i++) {
            CGFloat top = lastView?lastView.bottom:0;
            SPItemView *itemView = [[SPItemView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight)];
            itemView.tag = i+WPRecruitDraftEditControllerActionTypePhone;
            [itemView setTitle:titleArr[i] placeholder:placehorderArr[i] style:kCellTypeText];
            [self.moreConditionView addSubview:itemView];
            
            WS(ws);
            itemView.hideFromFont = ^(NSInteger tag, NSString *title){
                SPItemView *item = (SPItemView *)[ws.moreConditionView viewWithTag:tag];
                [item resetTitle:title];
                button.contentLabel.text = @"删除";
                switch (tag) {
                    case WPRecruitDraftEditControllerActionTypePhone:
                        self.model.enterprisePhone = title;
                        break;
                    case WPRecruitDraftEditControllerActionTypeQQ:
                        self.model.enterpriseQq = title;
                        break;
                    case WPRecruitDraftEditControllerActionTypeWeChat:
                        self.model.enterpriseWebchat = title;
                        break;
                    case WPRecruitDraftEditControllerActionTypeWebsite:
                        self.model.enterpriseWebsite = title;
                        break;
                    case WPRecruitDraftEditControllerActionTypeEmail:
                        self.model.enterpriseEmail = title;
                        break;
                    default:
                        break;
                }
            };
            
            lastView = itemView;
        }
        
        button.contentLabel.text = @"收起";
        button.subImageView.image = [UIImage imageNamed:@"shouqi"];
        [button setContentLabelSize:@"收起" font:15];
        
    }else{/**< 收起更多信息 */
        for (UIView *view in self.moreConditionView.subviews) {
            if ([view isKindOfClass:[SPItemView class]]) {
                [view removeFromSuperview];
            }
        }
        button.contentLabel.text = @"更多条件(可填可不填)";
        button.subImageView.image = [UIImage imageNamed:@"tianjiafeiyong"];
        [button setContentLabelSize:@"更多条件(可填可不填)" font:15];
    }
    
    //重置『更多条件』frame
    button.top = lastView?lastView.bottom:0;
    
    self.moreConditionView.height = button.bottom;
    
    [self updateRecruitResumeFrame];
    
}

- (void)updateRecruitResumeFrame{
    UIView *lastview = nil;
    for (UIView *recruitView in self.verOneScrollView.subviews) {
        
        if ([recruitView isKindOfClass:[WPRecruitiew class]]) {
            
            if (recruitView.tag != 100) {
                recruitView.top = (lastview?lastview.bottom:self.moreConditionView.bottom)+kListEdge;
                lastview = recruitView;
            }
        }
    }
    CGFloat height = lastview?(lastview.bottom):(self.moreConditionView.bottom);
    
    self.verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height+kListEdge+ItemViewHeight+kListEdge);
    
    self.addMoreResumeView.bottom = self.verOneScrollView.contentSize.height-kListEdge;
}


//- (void)onPlaybackFinished
//{
//    NSLog(@"onPlaybackFinished");
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//}

//- (void)companyCLick
//{
//    WPCompanyEdit1Controller *company = [[WPCompanyEdit1Controller alloc]init];
//    company.delegate = self;
//    company.title = @"企业信息";
//    WPCompanyListModel *model = [[WPCompanyListModel alloc]init];
//    if ([self.model.epName hasPrefix:@"默认·"]) {
//        model.enterprise_name = [self.model.epName substringFromIndex:3];
//    }else{
//        model.enterprise_name = self.model.epName;
//    }
//    model.Industry = self.model.Industry;
//    model.Industry_id = self.model.Industryid;
//    model.enterprise_properties = self.model.enterprise_properties;
//    model.enterprise_scale = self.model.enterprise_scale;
//    model.enterprise_brief = self.model.enterprise_brief;
//    model.QR_code = self.model.background;
//    model.dvList = self.model.dvList;
//    model.pohotoList = self.model.pohotoList;
//    model.sid = [NSString stringWithFormat:@"%ld",(long)self.model.epid];
//    company.listModel = model;
//    [self.navigationController pushViewController:company animated:YES];
//}

#pragma mark - 选择企业
-(void)chooseCompanyClick
{
    NSLog(@"选择公司");
    WPCompanyController *company = [[WPCompanyController alloc]init];
    company.delegate = self;
    [self.navigationController pushViewController:company animated:YES];
}

-(void)tap:(UITapGestureRecognizer *)tap
{
    [self.verOneScrollView endEditing:YES];
    /*
     if (_isFirst) {
     [self.verOneScrollView endEditing:YES];
     }else{
     [self.verOnesScrollView endEditing:YES];
     }
     */
}

#pragma mark - 查看图片
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
    [self.navigationController pushViewController:brower animated:YES];
//    [brower show];
    /*
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag-PhotoTag inSection:0];
     // 图片游览器
     MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
     // 缩放动画
     photoBrowser.status = UIViewAnimationAnimationStatusFade;
     // 可以删除
     photoBrowser.editing = YES;
     // 数据源/delegate
     photoBrowser.delegate = self;
     photoBrowser.dataSource = self;
     // 当前选中的值
     photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
     // 展示控制器
     [photoBrowser showPickerVc:self];
     */
}
#pragma mark 点击图片大图显示删除图片的代理
- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser deleteImageAtIndex:(NSInteger)index{
    if (self.photosArr.count == 1)
    {
        //        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请至少保留一张图片" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        //        [alert show];
    }
    else
    {
        [self.photosArr removeObjectAtIndex:index];
    }
    [self updatePhotosView];
}
- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser coverImageAtIndex:(NSInteger)index
{
    id object = self.photosArr[index];
    [self.photosArr removeObjectAtIndex:index];
    [self.photosArr insertObject:object atIndex:0];
    [self updatePhotosView];
}
//- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser deleteImageAtIndex:(NSInteger)index{
//    [self.photosArr removeObjectAtIndex:index];
//    [self updatePhotosView];
//}
//
//- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser coverImageAtIndex:(NSInteger)index{
//    id photo = self.photosArr[index];
//    [self.photosArr removeObjectAtIndex:index];
//    [self.photosArr insertObject:photo atIndex:0];
//    [self updatePhotosView];
//}

/*
 - (NSInteger)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
 return self.photosArr.count;
 }
 
 #pragma mark - 每个组展示什么图片,需要包装下MLPhotoBrowserPhoto
 - (MLPhotoBrowserPhoto *) photoBrowser:(MLPhotoBrowserViewController *)browser photoAtIndexPath:(NSIndexPath *)indexPath{
 // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
 MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
 if ([self.photosArr[indexPath.row] isKindOfClass:[SPPhotoAsset class]]) {
 photo.photoObj = [[self.photosArr objectAtIndex:indexPath.row] originImage];
 }else{
 photo.photoObj = [IPADDRESS stringByAppendingString:[self.photosArr[indexPath.row] original_path]];
 }
 // 缩略图
 UIButton *btn = (UIButton *)[self.photosView viewWithTag:indexPath.row+PhotoTag];
 photo.toView = btn.imageView;
 //    photo.thumbImage = btn.imageView.image;
 return photo;
 }
 
 #pragma mark - <MLPhotoBrowserViewControllerDelegate>
 - (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser coverPhotoAtIndexPath:(NSIndexPath *)indexPath
 {
 UIImage *photo = self.photosArr[indexPath.row];
 [self.photosArr removeObjectAtIndex:indexPath.row];
 [self.photosArr insertObject:photo atIndex:0];
 [self updatePhotosView];
 }
 
 #pragma mark - <MLPhotoBrowserViewControllerDelegate>
 - (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
 [self.photosArr removeObjectAtIndex:indexPath.row];
 [self updatePhotosView];
 }
 
 
 -(UIScrollView *)videosView
 {
 if (!_videosView) {
 
 _videosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _photosView.bottom, SCREEN_WIDTH-30, 80)];
 _videosView.backgroundColor = [UIColor whiteColor];
 _videosView.showsHorizontalScrollIndicator = NO;
 
 _addVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
 _addVideoBtn.frame = CGRectMake(10, 10, 64, 64);
 _addVideoBtn.backgroundColor = RGB(204, 204, 204);
 [_addVideoBtn setImage:[UIImage imageNamed:@"addPhoto"] forState:UIControlStateNormal];
 [_addVideoBtn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(102, 102, 102)] forState:UIControlStateHighlighted];
 _addVideoBtn.tag = TagAddVideo;
 [_addVideoBtn addTarget:self action:@selector(recuilistTagClick:) forControlEvents:UIControlEventTouchUpInside];
 [_videosView addSubview:_addVideoBtn];
 
 *< 照片墙翻页
 UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-30, _videosView.top, 30, 80) ImageName:@"common_icon_arrow" Target:self Action:@selector(recuilistTagClick:)];
 scrollBtn.backgroundColor = [UIColor whiteColor];
 scrollBtn.tag = TagShowAllVideos;
 [self.headView addSubview:scrollBtn];
 }
 return _videosView;
 }
 
 -(void)updateVideosView
 {
 for (UIView *view in self.videosView.subviews) {
 [view removeFromSuperview];
 }
 for (int i = 0; i < self.videosArr.count; i++) {
 UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
 button.frame = CGRectMake(i*(64+2)+10, 10, 64, 64);
 button.tag = 40+i;
 [button addTarget:self action:@selector(checkVideoClick:) forControlEvents:UIControlEventTouchUpInside];
 [self.photosView addSubview:button];
 if ([self.videosArr[i] isKindOfClass:[NSString class]]) {
 [button setImage:[UIImage getImage:self.videosArr[i]] forState:UIControlStateNormal];
 }else{
 ALAsset *asset = self.videosArr[i];
 [button setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
 }
 [self.videosView addSubview:button];
 
 UIImageView *subImageV = [[UIImageView alloc]initWithFrame:CGRectMake(22, 22, 20, 20)];
 subImageV.image = [UIImage imageNamed:@"video_play"];
 [button addSubview:subImageV];
 }
 if (self.videosArr.count == 8) {
 self.videosView.contentSize = CGSizeMake(8*(64+2)+10, 64);
 }else{
 self.videosView.contentSize = CGSizeMake(self.videosArr.count*(64+2)+64+10, 64);
 _addVideoBtn.frame = CGRectMake(self.videosArr.count*(64+2)+10, 10, 64, 64);
 [self.videosView addSubview:_addVideoBtn];
 }
 }
 */
#pragma mark - 查看照片墙
-(void)checkAllVideosBlock:(BOOL)isEdit
{
    SAYVideoManagerViewController *vc = [[SAYVideoManagerViewController alloc]init];
    //if (_isFirst) {
    vc.arr = self.photosArr;
    vc.videoArr = self.videosArr;
    //}else{
    //vc.arr = self.model.pohotoList;
    //vc.videoArr = self.model.dvList;
    //}
    
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}
#pragma mark - 查看视频
-(void)checkVideos:(NSInteger)number
{
    NSLog(@"观看视频");
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    //if (_isFirst) {
//    [arr addObject:self.videosArr];
    //}else{
    //[arr addObject:self.model.dvList];
    //}
    [arr addObjectsFromArray:self.videosArr];
    VideoBrowser *video = [[VideoBrowser alloc] init];
    video.isCreat = YES;
    if ([arr[number] isKindOfClass:[NSString class]]) {
//        NSURL *url = [NSURL fileURLWithPath:arr[number]];
        //        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
        video.isNetOrNot = NO;
        video.videoUrl = arr[number];
    } else if([arr[number] isKindOfClass:[ALAsset class]]){
        ALAsset *asset = arr[number];
        video.isNetOrNot = NO;
        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
    }else{
        video.isNetOrNot = YES;
        video.videoUrl =[IPADDRESS stringByAppendingString:[arr[number] original_path]];
    }
    [video showPickerVc:self];
    
    
//    if ([arr[number] isKindOfClass:[NSString class]]) {
//        NSURL *url = [NSURL fileURLWithPath:arr[number]];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
//    } else if([arr[number] isKindOfClass:[ALAsset class]]){
//        ALAsset *asset = arr[number];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
//    }else{
//        NSLog(@"%@",[IPADDRESS stringByAppendingString:[arr[number] original_path]]);
//        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[arr[number] original_path]]];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
//    }
//    //指定媒体类型为文件
//    _moviePlayerVC.moviePlayer.movieSourceType = MPMovieSourceTypeFile|MPMovieSourceTypeStreaming;
//    
//    //通知中心
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPlaybackFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    
//    [self presentViewController:_moviePlayerVC animated:YES completion:^{}];
}

-(void)checkVideoClick:(UIButton *)sender
{
    NSLog(@"观看视频");
    VideoBrowser *video = [[VideoBrowser alloc] init];
    video.isCreat = YES;
    if ([self.videosArr[sender.tag-VideoTag] isKindOfClass:[NSString class]]) {
        video.isNetOrNot = NO;
        video.videoUrl = self.videosArr[sender.tag-VideoTag];
    } else {
        video.isNetOrNot = YES;
        video.videoUrl =[IPADDRESS stringByAppendingString:[self.videosArr[sender.tag-VideoTag] original_path]];
    }
     [video showPickerVc:self];
    
    
    
//    if ([self.videosArr[sender.tag-VideoTag] isKindOfClass:[NSString class]]) {
//        NSURL *url = [NSURL fileURLWithPath:self.videosArr[sender.tag-VideoTag]];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
//    } else {
//        ALAsset *asset = self.videosArr[sender.tag-VideoTag];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
//    }
//    //指定媒体类型为文件
//    _moviePlayerVC.moviePlayer.movieSourceType = MPMovieSourceTypeFile|MPMovieSourceTypeStreaming;
//    
//    //通知中心
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPlaybackFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    
//    [self presentViewController:_moviePlayerVC animated:YES completion:^{}];
}

- (void)onPlaybackFinished
{
    NSLog(@"onPlaybackFinished");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

#pragma mark - 增加or删除招聘简历
-(void)addMorePosition
{
    if (_recruitResumeCount == 2) {
        [MBProgressHUD alertView:@"" Message:@"最多允许创建3个职位"];
    }else{
        [MBProgressHUD createHUD:@"已新增一个职位" View:self.view];
        
        _nextTop = _recruitResumeCount*RecruitResumeHeight+_recruitResumeCount*kListEdge+self.moreConditionView.bottom+kListEdge;
        
        _recruitResumeCount ++;
        _bodyNumber+=100*_recruitResumeCount;
        
        WS(ws);
        WPRecruitiew *recuilistView = [[WPRecruitiew alloc]initWithFrame:CGRectMake(0, _nextTop, SCREEN_WIDTH, RecruitResumeHeight)];
        recuilistView.deletePositionBlock = ^(NSInteger tag){
            [SPAlert alertControllerWithTitle:@"提示" message:@"是否确认删除" superController:self cancelButtonTitle:@"取消" cancelAction:nil defaultButtonTitle:@"确认" defaultAction:^{
                NSLog(@"点击确认");
                [ws deletePosition:tag];
            }];
        };
        
        __weak typeof(recuilistView) weakRecuilistView = recuilistView;
        recuilistView.InputPositionRequireBlock = ^(NSInteger tag){
            ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
            editing.attributedString = weakRecuilistView.model.requireString;
            //            editing.attributedString = [[NSAttributedString alloc] initWithAttributedString:ws.recruitView.model.requireString];
            editing.verifyClickBlock = ^(NSAttributedString *attributedString){
                weakRecuilistView.model.requireString = attributedString;
                if (weakRecuilistView.model.requstString.length) {
                    SPItemView *item = (SPItemView *)[weakRecuilistView viewWithTag:tag];
                    [item resetTitle:@"任职要求已填写"];
                }
                else
                {
                    SPItemView *item = (SPItemView *)[weakRecuilistView viewWithTag:tag];
                    [item resetTitle:@""];
                }
                
            };
            [ws.navigationController pushViewController:editing animated:YES];
        };
        
        [recuilistView setNumber:_bodyNumber];
        
        [_verOneScrollView addSubview:recuilistView];
        CGFloat scrollViewContentHeight = self.verOneScrollView.contentSize.height;
        _verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, scrollViewContentHeight+RecruitResumeHeight+kListEdge);
        self.addMoreResumeView.bottom = _verOneScrollView.contentSize.height-kListEdge;
        //        if (_isFirst) {
        //            [_verOneScrollView addSubview:recuilistView];
        //            _verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (_recruitResumeCount+1)*(RecuilistHeight+10)+self.headView.height+ItemViewHeight+20);
        //        }else{
        //            [_verOnesScrollView addSubview:recuilistView];
        //            _verOnesScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (_recruitResumeCount+1)*(RecuilistHeight+10)+self.headsView.height+ItemViewHeight+10+10);
        //        }
        //        [_verOneScrollView addSubview:recuilistView];
        //        _verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (_bodyCount+1)*(RecuilistHeight+10)+self.headView.height+60);
        //        self.shareView.top = (_bodyCount+1)*RecuilistHeight+_bodyCount*10+self.headView.height+10+10;
        
        //        WPRecuilistView *revc = (WPRecuilistView *)[self.verOneScrollView viewWithTag:60];
        //        revc.deleteButton.hidden = NO;
        //        if (_recruitResumeCount == 1) {
        //
        //        }
        //        NSMutableArray *subArr = [[NSMutableArray alloc]init];
        //        if (_isFirst) {
        //            [subArr addObjectsFromArray:self.verOneScrollView.subviews];
        //        }else{
        //            [subArr addObjectsFromArray:self.verOnesScrollView.subviews];
        //        }
        //        for (UIView *view in subArr) {
        //            if ([view isKindOfClass:[WPRecruitiew class]]) {
        //                [[(WPRecruitiew *)view deleteButton] setHidden:NO];
        //            }
        //        }
    }
}

- (void)deletePosition:(NSInteger)tag
{
    _recruitResumeCount--;
    
    for (int i = 0; i <= _bodyNumber/100; i++) {
        if (i*100 == tag) {
            WPRecruitiew *revc = (WPRecruitiew *)[self.verOneScrollView viewWithTag:tag];
            [revc removeFromSuperview];
        }
        if (i*100 > tag) {
            WPRecruitiew *revc = (WPRecruitiew *)[self.verOneScrollView viewWithTag:tag];
            revc.top = revc.top - RecruitResumeHeight- kListEdge;
        }
    }
    CGFloat height = self.verOneScrollView.contentSize.height;
    self.verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height-RecruitResumeHeight-kListEdge);
    self.addMoreResumeView.bottom = self.verOneScrollView.contentSize.height-kListEdge;
    
    //    if (tag != _bodyNumber) {
    //        for (int i = 0; i < (_bodyNumber-tag)/10; i++) {
    //            if (_isFirst) {
    //                WPRecruitiew *revc = (WPRecruitiew *)[self.verOneScrollView viewWithTag:tag+(1+i)*10];
    //                revc.top = revc.top-RecuilistHeight-10;
    //            }else{
    //                WPRecruitiew *revc = (WPRecruitiew *)[self.verOnesScrollView viewWithTag:tag+(1+i)*10];
    //                revc.top = revc.top-RecuilistHeight-10;
    //            }
    //        }
    //    }
    //    if (_isFirst) {
    //        WPRecruitiew *revc = (WPRecruitiew *)[self.verOneScrollView viewWithTag:tag];
    //        [revc removeFromSuperview];
    //        _verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (_recruitResumeCount+1)*(RecuilistHeight+10)+self.headView.height+ItemViewHeight+20);
    //    }else{
    //        WPRecruitiew *revc = (WPRecruitiew *)[self.verOnesScrollView viewWithTag:tag];
    //        [revc removeFromSuperview];
    //        _verOnesScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (_recruitResumeCount+1)*(RecuilistHeight+10)+self.headsView.height+ItemViewHeight+10+10);
    //    }
    
    //    NSMutableArray *subArr = [[NSMutableArray alloc]init];
    //    if (_isFirst) {
    //        [subArr addObjectsFromArray:self.verOneScrollView.subviews];
    //    }else{
    //        [subArr addObjectsFromArray:self.verOnesScrollView.subviews];
    //    }
    //    int subCount = 0;
    //    for (UIView *view in subArr) {
    //        if ([view isKindOfClass:[WPRecruitiew class]]) {
    //            subCount++;
    //        }
    //    }
    //    if (subCount == 1) {
    //        for (UIView *view in subArr) {
    //            if ([view isKindOfClass:[WPRecruitiew class]]) {
    //                [[(WPRecruitiew *)view deleteButton] setHidden:YES];
    //            }
    //        }
    //    }
    [MBProgressHUD createHUD:@"已删除当前职位" View:self.view];
}
/*
 -(void)exampleClick:(UIButton *)sender
 {
 [self.horScrollView setContentOffset:CGPointMake((sender.tag-10)*SCREEN_WIDTH, 0) animated:YES];
 [UIView animateWithDuration:0.3 animations:^{
 self.indicatorView.left = (sender.tag-10)*SCREEN_WIDTH/3;
 }];
 }
 */

- (WPActionSheet *)actionSheet{
    if (!_actionSheet) {
        WS(ws);
        _actionSheet = [[WPActionSheet alloc]initWithOtherButtonTitle:@[@"保存修改",@"不保存修改"] imageNames:nil top:64 actions:^(NSInteger type) {
            if (type == 1) {
                [self completeAllMessage:@"1"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            if (type == 2) {
                [ws.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    return _actionSheet;
}

#pragma mark - 返回
-(void)backToFromViewController:(UIButton *)sender
{
    if(self.actionSheet.frame.origin.y < 0&&sender.selected){
        sender.selected = !sender.selected;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        if ([self judgeIsEdited]) {
//            [self.actionSheet showInView:self.view];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认退出编辑?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alert.tag = 20000;
            [alert show];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.actionSheet hideFromView:self.view];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}
#pragma mark - 右导航栏切换编辑or预览
-(void)rightButtonItemClick:(UIButton *)sender
{
    NSLog(@"完成");
    [self.headView endEditing:YES];
    [self.recruitView endEditing:YES];
    
    NSMutableArray *subArr = [[NSMutableArray alloc]init];
    //if (_isFirst) {
    [subArr addObjectsFromArray:self.verOneScrollView.subviews];
    //}else{
    ////        [subArr addObjectsFromArray:self.verOnesScrollView.subviews];
    //}
    //    [subArr addObjectsFromArray:self.verOneScrollView.subviews];
    
    BOOL allReady = YES;
    
    //for (UIView *view in subArr) {
    //if ([view isKindOfClass:[WPRecruitiew class]]) {
    //[(WPRecruitiew *)view endEditing:YES];
    //if ([(WPRecruitiew *)view allMessageIsComplete]) {
    //}else{
    //allReady = NO;
    //break;
    //}
    //}
    //}
    
    if (allReady == YES) {
        //        [self completeAllMessage];
        sender.selected = !sender.selected;
        self.sendbottomView.hidden = NO;
        [self AddrecPreview];
        
        _draftButton.hidden = YES;
    }
    
    if (!sender.selected) {
        [self deleteRecPreview];
        self.sendbottomView.hidden = YES;
        
        _draftButton.hidden = NO;
    }
}

- (void)rightButtonDraftClick:(UIButton *)sender{
    WPRecruitDraftController *company = [[WPRecruitDraftController alloc]init];
    company.delegate = self;
    [self.navigationController pushViewController:company animated:YES];
}

#pragma mark - 获取草稿数量
- (void)requestDraftCount{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    NSDictionary *params = @{@"action":@"BeforeAddJob",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        if ([json[@"status"] isEqualToString:@"0"]) {
            _draftNumber.text = json[@"draftCount"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);;
    }];
}

#pragma mark - 点击发布简历
-(void)completeAllMessage:(NSString *)isDraft
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    BOOL updateImage = YES;
    //if (_isFirst) {
    //        WPFormData *formDatas = [[WPFormData alloc]init];
    //        UIButton *logo = (UIButton *)[self.view viewWithTag:TagAddLogo];
    //        formDatas.data = UIImageJPEGRepresentation((UIImage *)logo.imageView.image, 0.5);
    //        formDatas.name = @"logo";
    //        formDatas.filename = @"logo.png";
    //        formDatas.mimeType = @"image/png";
    //        [arr addObject:formDatas];
    
//    WPFormData *formDatas1 = [[WPFormData alloc]init];
//    UIButton *back = (UIButton *)[self.view viewWithTag:WPRecruitDraftEditControllerActionTypeCompanyLogo];
//    formDatas1.data = UIImageJPEGRepresentation((UIImage *)back.imageView.image, 0.5);
//    formDatas1.name = @"background";
//    formDatas1.filename = @"background.png";
//    formDatas1.mimeType = @"image/png";
//    [arr addObject:formDatas1];
//    if (!formDatas1.data) {
//        updateImage = NO;
//    }
//    
    for (int i = 0; i < self.photosArr.count; i++) {
        WPFormData *formDatas = [[WPFormData alloc]init];
        //            formDatas.data = UIImageJPEGRepresentation(self.photosArr[i], 0.5);
        UIImage *image;
        if ([self.photosArr[i] isKindOfClass:[SPPhotoAsset class]]) {
            image = [self.photosArr[i] originImage];
            formDatas.data = UIImageJPEGRepresentation(image, 0.5);
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] original_path]]]];
            formDatas.data = data;
        }
        formDatas.name = [NSString stringWithFormat:@"photoAddress%d",i];
        formDatas.filename = [NSString stringWithFormat:@"photoAddress%d.png",i];
        formDatas.mimeType = @"image/png";
        [arr addObject:formDatas];
        if (!formDatas.data) {
            updateImage = NO;
        }
    }
    
    for (int i =0; i < self.videosArr.count; i++) {
        WPFormData *formDatas = [[WPFormData alloc]init];
        //if ([self.videosArr[i] isKindOfClass:[NSString class]]) {
        //NSData *data = [NSData dataWithContentsOfFile:self.videosArr[i]];
        //formDatas.data = data;
        //} else {
        //ALAsset *asset = self.videosArr[i];
        ////将视频转换成NSData
        //ALAssetRepresentation *rep = [asset defaultRepresentation];
        //Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
        //NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
        //NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        //formDatas.data = data;
        //}
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
        formDatas.name = [NSString stringWithFormat:@"photoAddress%lu",i+self.photosArr.count];
        formDatas.filename = [NSString stringWithFormat:@"photoAddress%lu.mp4",i+self.photosArr.count];
        formDatas.mimeType = @"video/quicktime";
        [arr addObject:formDatas];
        if (!formDatas.data) {
            updateImage = NO;
        }
    }
    //}
    
    NSArray *subArr = self.verOneScrollView.subviews;
    //    if (_isFirst) {
    //        [subArr addObjectsFromArray:self.verOneScrollView.subviews];
    //    }else{
    //        [subArr addObjectsFromArray:self.verOnesScrollView.subviews];
    //    }
    //    [subArr addObjectsFromArray:self.verOneScrollView.subviews];
    NSMutableArray *jobs = [[NSMutableArray alloc]init];
    for (UIView *view in subArr) {
        if ([view isKindOfClass:[WPRecruitiew class]]) {
            WPRecEditModel *editModel = [(WPRecruitiew *)view model];
            
            //转换成字典上传
            NSString *text = [NSString stringWithFormat:@"%@",editModel.requireString];
            NSArray *arr = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
            NSMutableArray *attStr = [NSMutableArray array];
            NSInteger index = (arr.count - 1)/2;
            for (int j = 0 ; j<index; j++) {
                NSString *detail = arr[2*j];
                NSString *attribute = arr[2*j+1];
                NSDictionary *attibuteTex = @{@"detail" : detail,
                                              @"attribute" : attribute};
                [attStr addObject:attibuteTex];
            }
            //            NSLog(@"#####%@",attStr);
            //            NSDictionary *textDic = @{@"txt": attStr};
            
            NSDictionary *dic =@{@"job_id":self.Infomodel.jobId,
                                 @"jobPositon":editModel.jobPositon,
                                 @"jobPositonID":editModel.jobPositonID,
                                 @"salary":editModel.salary,
                                 @"epRange":editModel.epRange,
                                 @"workTime":editModel.workTime,
                                 @"education":editModel.education,
                                 @"sex":editModel.sex,
                                 @"age":editModel.age,
                                 @"Tel":editModel.Tel,
                                 @"TelIsShow":showedTelephone?@"0":@"1",
                                 @"invitenumbe":editModel.invitenumbe,
                                 @"workAddressID":editModel.workAddressID,
                                 @"workAddress":editModel.workAddress,
                                 @"workAdS":editModel.workAdS,
                                 @"longitude":@"",//TODO:精度
                                 @"latitude":@"",//TODO:纬度
                                 @"Require":[NSString stringWithFormat:@"%@",editModel.requstString],
                                 @"guid_0":self.guid
                                 };
            [jobs addObject:dic];
        }
    }
    
    NSMutableArray *briefList = [[NSMutableArray alloc]init];
    //        WPInterviewEducationModel *model = self.educationListArray[i];
    for (int i = 0; i < self.briefArray.count; i++) {
        if ([self.briefArray[i] isKindOfClass:[NSAttributedString class]]) {//文字
            //            NSAttributedString *str = self.previewModel.textAndImage[i];
            NSString *text = [NSString stringWithFormat:@"%@",self.briefArray[i]];
            //        NSLog(@"#####%@",str);
            NSArray *arr = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
            //            NSLog(@"%@----%lu",arr,(unsigned long)arr.count);
            NSMutableArray *attStr = [NSMutableArray array];
            NSInteger index = (arr.count - 1)/2;
            for (int j = 0 ; j<index; j++) {
                NSString *detail = arr[2*j];
                NSString *attribute = arr[2*j+1];
                NSDictionary *attibuteTex = @{@"detail" : detail,
                                              @"attribute" : attribute};
                [attStr addObject:attibuteTex];
            }
            //            NSLog(@"#####%@",attStr);
            NSDictionary *textDic = @{@"txt": attStr};
            [briefList addObject:textDic];
        } else { //图片
            
            WPFormData *formData = [[WPFormData alloc]init];
            if ([self.briefArray[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                MLSelectPhotoAssets *asset = self.briefArray[i];
                UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                formData.data = UIImageJPEGRepresentation(img, 0.5);
            }else{
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.briefArray[i]]];
                formData.data = [NSData dataWithContentsOfURL:url];
            }
            formData.name = [NSString stringWithFormat:@"img%d",i];
            formData.filename = [NSString stringWithFormat:@"img%d.jpg",i];
            formData.mimeType = @"application/octet-stream";
            [arr addObject:formData];//把数据流加入上传文件数组
            NSString *value = [NSString stringWithFormat:@"img%d",i];
            NSDictionary *photoDic = @{@"txt":value};
            [briefList addObject:photoDic];
        }
    }
    
    NSString *jsonString;
    //    if (_isFirst) {
    //NSDictionary *jsonDic = @{@"ep_id":@"",
    //@"enterprise_name":(_isFirst?[self superview:self.verOneScrollView title:WPRecruitControllerActionTypeCompanyName]:self.model.enterpriseName),
    //@"dataIndustry":(_isFirst?[self superview:self.verOneScrollView title:WPRecruitControllerActionTypeCompanyIndustry]:self.model.dataIndustry),
    //@"dataIndustry_id":(_isFirst?[self superview:self.verOneScrollView industry:WPRecruitControllerActionTypeCompanyIndustry]:self.model.dataIndustryId),
    //@"enterprise_properties":(_isFirst?[self superview:self.verOneScrollView title:WPRecruitControllerActionTypeCompanyProperty]:self.model.enterpriseProperties),
    //@"enterprise_scale":(_isFirst?[self superview:self.verOneScrollView title:WPRecruitControllerActionTypeCompanyScale]:self.model.enterpriseScale),
    //@"enterprise_brief":[(SPTextView *)[self.verOneScrollView viewWithTag:WPRecruitControllerActionTypeCompanyBrief] title],
    //@"enterprise_addressID":(_isFirst?[self superview:self.verOneScrollView industry:WPRecruitControllerActionTypeCompanyArea]:self.model.enterpriseAddressID),
    //@"enterprise_address":(_isFirst?[self superview:self.verOneScrollView industry:WPRecruitControllerActionTypeCompanyArea]:self.model.enterpriseAddress),
    //@"enterprise_personName":(_isFirst?[self superview:self.verOneScrollView title:WPRecruitControllerActionTypePersonalName]:self.model.enterprisePersonName),
    //@"enterprise_personTel":(_isFirst?[self superview:self.verOneScrollView title:WPRecruitControllerActionTypeCompanyPhone]:self.model.enterprisePersonTel),
    //@"enterprise_brief":@"",//企业简介(留着 传空就可以了)
    //@"enterprise_phone":(_isFirst?[self superview:self.moreConditionView title:10]:self.model.enterprisePhone),
    //@"enterprise_qq":(_isFirst?[self superview:self.moreConditionView title:11]:self.model.enterpriseQq),
    //@"enterprise_email":(_isFirst?[self superview:self.moreConditionView title:12]:self.model.enterpriseEmail),
    //@"enterprise_webchat":(_isFirst?[self superview:self.moreConditionView title:13]:self.model.enterpriseWebchat),
    //@"enterprise_website":(_isFirst?[self superview:self.moreConditionView title:14]:self.model.enterpriseWebsite),
    //@"JobList":jobs,
    //@"epRemarkList":briefList
    //};
//    NSString * stradress  = [self superview:self.verOneScrollView industry:WPRecruitDraftEditControllerActionTypeCompanyArea];
//    NSLog(@"%@",stradress);
    
    NSDictionary *jsonDic = @{@"ep_id":self.Infomodel.epId,
                              @"enterprise_name":([self superview:self.verOneScrollView title:WPRecruitDraftEditControllerActionTypeCompanyName]),
                              @"dataIndustry":([self superview:self.verOneScrollView title:WPRecruitDraftEditControllerActionTypeCompanyIndustry]),
                              @"dataIndustry_id":([self superview:self.verOneScrollView industry:WPRecruitDraftEditControllerActionTypeCompanyIndustry]),
                              @"enterprise_properties":([self superview:self.verOneScrollView title:WPRecruitDraftEditControllerActionTypeCompanyProperty]),
                              @"enterprise_scale":([self superview:self.verOneScrollView title:WPRecruitDraftEditControllerActionTypeCompanyScale]),
                              @"enterprise_brief":[(SPTextView *)[self.verOneScrollView viewWithTag:WPRecruitDraftEditControllerActionTypeCompanyBrief] title],
                              
                              @"enterprise_addressID":self.model.enterpriseAddressID,//([self superview:self.verOneScrollView industry:WPRecruitDraftEditControllerActionTypeCompanyArea])
                              @"enterprise_address":self.model.enterpriseAddress,//([self superview:self.verOneScrollView industry:WPRecruitDraftEditControllerActionTypeCompanyArea])
                              
                              
                              @"enterprise_ads":([self superview:self.verOneScrollView title:WPRecruitDraftEditControllerActionTypeCompanyDetailArea]),
                              @"enterprise_personName":([self superview:self.verOneScrollView title:WPRecruitDraftEditControllerActionTypePersonalName]),
                              @"enterprise_website":([self superview:self.verOneScrollView title:WPRecruitDraftEditControllerActionTypeCompanyPhone]),
                              @"enterprise_brief":self.model.enterpriseBrief,//企业简介(留着 传空就可以了)
//                              @"enterprise_phone":([self superview:self.moreConditionView title:10]),
//                              @"enterprise_qq":([self superview:self.moreConditionView title:11]),
//                              @"enterprise_email":([self superview:self.moreConditionView title:12]),
//                              @"enterprise_webchat":([self superview:self.moreConditionView title:13]),
                              
                              @"JobList":jobs,
                              @"epRemarkList":briefList
                              };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    }
    //    else{
    //        NSDictionary *jsonDic = @{@"epName":self.model.enterprisename,
    //                                  @"epIndustry":self.model.Industry,
    //                                  @"epType":self.model.enterprise_properties,
    //                                  @"enterprise_scale":self.model.enterprise_scale,
    //                                  @"enterprise_brief":self.model.enterprise_brief,
    //                                  @"epIndustryId":self.model.Industry_id,
    //                                  @"companyId":[NSString stringWithFormat:@"%ld",(long)self.model.sid],
    //                                  @"jobs":jobs
    //                                  };
    //        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    //        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    }
    
    NSString *PhotoNum;
    NSString *fileCount;
    if (updateImage) {
        PhotoNum = [NSString stringWithFormat:@"%lu",self.photosArr.count];
        fileCount = [NSString stringWithFormat:@"%lu",self.photosArr.count+self.videosArr.count+1];
    }else{
        PhotoNum = @"";
        fileCount = @"";
        arr = nil;
    }
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/invitejob.ashx"];
    NSDictionary *params = @{@"action":@"JobInsert",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.userId,
                             @"PhotoCount":PhotoNum,
                             @"FileCount":fileCount,
                             @"isModify":(updateImage)?@"0":@"1",
                             @"status":([isDraft isKindOfClass:[NSString class]]?@"1":@"0"),
                             @"JobJsonList":jsonString
                             };
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:url params:params formDataArray:arr success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([json[@"status"] isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"新建成功" toView:self.view];
            [self performSelector:@selector(delay) withObject:nil afterDelay:1];
        }else{
            [MBProgressHUD showError:json[@"info"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)delay{
    //if (self.delegate) {
    //[self.delegate WPRecuilistControllerDelegate];
    //[self.navigationController popViewControllerAnimated:YES];
    //}
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kNotificationRecruitRefreshList" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHECKDATA" object:nil];
//    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 公司信息选择点击事件
- (void)buttonItem:(NSInteger)tag
{
    _selectNum = tag;
    [self.verOneScrollView endEditing:YES];
    //    if (_isFirst) {
    //       [self.verOneScrollView endEditing:YES];
    //    }else{
    //       [self.verOnesScrollView endEditing:YES];
    //    }
    
    switch (tag) {
        case WPRecruitDraftEditControllerActionTypeCompanyIndustry:
            self.selectView.isIndustry = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getIndustry",@"fatherid":@"0"}];
            break;
        case WPRecruitDraftEditControllerActionTypeCompanyProperty:
            [self.selectView setLocalData:[SPLocalApplyArray natureArray]];
            break;
        case WPRecruitDraftEditControllerActionTypeCompanyScale:
            [self.selectView setLocalData:[SPLocalApplyArray scaleArray]];
            break;
        case WPRecruitDraftEditControllerActionTypeCompanyArea:
            self.selectView.isIndustry = NO;
            self.selectView.isArea = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
        case WPRecruitDraftEditControllerActionTypeCompanyBrief:
            [self pushToCompanyBrief];
            break;
        default:
            break;
    }
}

#pragma mark  点击企业描述
- (void)pushToCompanyBrief{
    
    ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
    //    editing.title = @"任职要求";
    __weak typeof(self) weakSelf = self;
    //    editing.attributedString = [NSString stringWithString:self.briefString];
    NSString * string = [WPMySecurities textFromBase64String:self.briefString];
    string = [WPMySecurities textFromEmojiString:string];
    if (string.length) {
        self.briefString = string;
    }
    
    editing.textFieldString = self.briefString;
    editing.title = @"企业描述";
    editing.verifyClickBlock = ^(NSAttributedString *attributedString){
        //        weakSelf.recruitView.model.requireString = attributedString;
        self.briefString = attributedString;
        if (self.briefString.length) {
            SPItemView *item = (SPItemView *)[weakSelf.headView viewWithTag:WPRecruitDraftEditControllerActionTypeCompanyBrief];
            [item resetTitle:@"企业描述已填写"];
            self.model.enterpriseBrief = self.briefString;
        }
        else
        {
            SPItemView *item = (SPItemView *)[weakSelf.headView viewWithTag:WPRecruitDraftEditControllerActionTypeCompanyBrief];
            [item resetTitle:@""];
            self.model.enterpriseBrief = self.briefString;
        }
    };
    [weakSelf.navigationController pushViewController:editing animated:YES];
    
    
    
//    WPCompanyBriefController *brief = [[WPCompanyBriefController alloc]init];
//    brief.delegate = self;
//    [brief.objects addObjectsFromArray:self.briefArray];
//    [self.navigationController pushViewController:brief animated:YES];
}

#pragma mark - 企业简介返回函数
- (void)getCompanyBrief:(NSArray *)briefArray{
    self.briefArray = briefArray;
    SPItemView *item = (SPItemView *)[self.view viewWithTag:WPRecruitDraftEditControllerActionTypeCompanyBrief];
    [item resetTitle:@"企业简介已填写"];
}

#pragma mark - 公司信息返回代理
-(void)SPSelectViewDelegate:(IndustryModel *)model
{
    SPItemView *item = (SPItemView *)[self.verOneScrollView viewWithTag:_selectNum];
    [item resetTitle:model.industryName];
    switch (_selectNum) {
        case 21:
            self.model.dataIndustry = model.industryName;
            self.model.dataIndustryId = model.industryID;
            break;
        case 22:
            self.model.enterpriseProperties = model.industryName;
            break;
        case 23:
            self.model.enterpriseScale = model.industryName;
            break;
        case 24:
            self.model.enterpriseAddress = model.industryName;
            self.model.enterpriseAddressID = model.industryID;
            break;
        default:
            break;
    }
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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

#pragma mark - 选择照片或视频ActionSheet
-(void)recuilistTagClick:(UIButton *)sender
{
    if (sender.tag == WPRecruitDraftEditControllerActionTypeAddPhoto) {
        HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册",@"相机", nil];//@"视频",
        [sheet show];
    }
    if (sender.tag == WPRecruitDraftEditControllerActionTypePhotoviewPage) {
        [self checkAllPhotos];
    }
    if (sender.tag == WPRecruitDraftEditControllerActionTypeCompanyLogo) {
        WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机"] imageNames:nil top:64];
        actionSheet.tag = TagBackSheet;
        [actionSheet showInView:self.view];
    }
}

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
        if (buttonIndex == 2) {
            [self videoFromCamera];
        }
        if (buttonIndex == 1) {
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
        if (buttonIndex == 1) {
            [self fromCameraSingle:1];
        }
        if (buttonIndex == 2) {
            [self fromCameraSingle:2];
        }
    }
}



#pragma mark -
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
        //        UIButton *button = (UIButton *)[self.view viewWithTag:TagAddLogo];
        //        [button setImage:image forState:UIControlStateNormal];
    }if (_number == TagBackSheet) {
        UIButton *button = (UIButton *)[self.view viewWithTag:WPRecruitDraftEditControllerActionTypeCompanyLogo];
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

// Transform values for full screen support:
#define CAMERA_TRANSFORM_X 1
// this works for iOS 4.x
#define CAMERA_TRANSFORM_Y 1.24299

#pragma mark - Photos
- (void)fromCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        //        [@"您的设备不支持拍照" alertInViewController:self];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    //    UIImagePickerControllerEditedImage *image = UIImagePickerControllerEditedImage;
    //picker.delegate = self;
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

- (void)fromAlbums {
    
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 8 - self.photosArr.count;
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

#pragma mark - VideoSelected
-(void)videoFromCamera
{
    DBTakeVideoVC *tackVedio = [[DBTakeVideoVC alloc] init];
    tackVedio.delegate = self;
    tackVedio.takeVideoDelegate = self;
    tackVedio.fileCount = 4-self.videosArr.count;
    [self.navigationController pushViewController:tackVedio animated:YES];
    
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tackVedio];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(void)videoFromAlbums
{
    NSLog(@"导入视频");
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = 8-self.videosArr.count;
    picker.assetsFilter = [ALAssetsFilter allVideos];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

//从录制界面选择Video返回
-(void)sendBackVideoWith:(NSArray *)array
{
    [self.videosArr addObjectsFromArray:array];
    [self updatePhotosView];
}
//录制返回
-(void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
    [self.videosArr addObject:filePaht];
    [self updatePhotosView];
}
//直接选择Video返回
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [self.videosArr addObjectsFromArray:assets];
    [self updatePhotosView];
}

-(void)checkAllPhotos
{
    SAYPhotoManagerViewController *vc = [[SAYPhotoManagerViewController alloc]init];
    vc.arr = self.photosArr;
    vc.videoArr = self.videosArr;
    vc.delegate = self;
    vc.isEdit = YES;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

-(void)checkAllVideos
{
    SAYVideoManagerViewController *vc = [[SAYVideoManagerViewController alloc]init];
    vc.arr = self.videosArr;
    //    vc.delegate = self;
    //    vc.isEdit = YES;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

-(void)UpdateImageDelegate:(NSArray *)arr VideoArr:(NSArray *)videoArr
{
    [self.photosArr removeAllObjects];
    [self.photosArr addObjectsFromArray:arr];
    
    [self.videosArr removeAllObjects];
    [self.videosArr addObjectsFromArray:videoArr];
    
    [self updatePhotosView];
}

-(void)UpdateVideoDelegate:(NSArray *)arr
{
    [self.videosArr removeAllObjects];
    [self.videosArr addObjectsFromArray:arr];
    //    [self updateVideosView];
    [self updatePhotosView];
}

#pragma mark - 填写任职要求回调函数

#pragma mark - 选择草稿后回调代理函数
- (void)getDraftInfo:(WPRecruitDraftInfoModel *)model{
    
    self.model.enterpriseName = model.enterpriseName;
    self.model.dataIndustry = model.dataIndustry;
    self.model.dataIndustryId = model.dataIndustryId;
    self.model.enterpriseProperties = model.enterpriseProperties;
    self.model.enterpriseScale = model.enterpriseScale;
    self.model.enterpriseAddress = model.enterpriseAddress;
    self.model.enterpriseDewtailAddress = model.enterpriseDewtailAddress;
    self.model.enterpriseAddressID = model.enterpriseAddressID;
    self.model.enterprisePersonName = model.enterprisePersonName;
    self.model.enterprisePersonTel = model.enterprisePersonTel;
    self.model.enterpriseBrief = model.enterpriseBrief;
    self.model.enterprisePhone = model.enterprisePhone;
    self.model.enterpriseQq = model.enterpriseQQ;
    self.model.enterpriseWebchat = model.enterpriseWebchat;
    self.model.enterpriseWebsite = model.enterpriseWebsite;
    self.model.enterpriseEmail = model.enterpriseEmail;
//    UIButton *button = (UIButton *)[self.verOneScrollView viewWithTag:WPRecruitDraftEditControllerActionTypeCompanyLogo];
//    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.QRCode]];
//    [button sd_setImageWithURL:url forState:UIControlStateNormal];
    
    //刷新照片和视频
    [self.photosArr removeAllObjects];
    [self.videosArr removeAllObjects];
    [self.photosArr addObjectsFromArray:model.photoList];
    [self.videosArr addObjectsFromArray:model.videoList];
    [self updatePhotosView];
    
    NSArray *title = @[model.enterpriseName.length?model.enterpriseName:@"",model.dataIndustry.length?model.dataIndustry:@"",model.enterpriseProperties.length?model.enterpriseProperties:@"",model.enterpriseScale.length?model.enterpriseScale:@"",model.enterpriseAddress.length?model.enterpriseAddress:@"",model.enterpriseDewtailAddress.length?model.enterpriseDewtailAddress:@"",model.enterprisePersonName.length?model.enterprisePersonName:@"",model.enterpriseWebsite.length?model.enterpriseWebsite:@""];
    for (int i = WPRecruitDraftEditControllerActionTypeCompanyName; i <= WPRecruitDraftEditControllerActionTypeCompanyPhone; i++) {
        
        SPItemView *view = (SPItemView *)[self.verOneScrollView viewWithTag:i];
        
        [view resetTitle:title[i-WPRecruitDraftEditControllerActionTypeCompanyName]];
    }
    
    
    SPItemView *textView = (SPItemView *)[self.verOneScrollView viewWithTag:WPRecruitDraftEditControllerActionTypeCompanyBrief];
    if (model.enterpriseBrief.length) {
        [textView resetTitle:@"企业描述已填写"];
        self.briefString = model.enterpriseBrief;
    }
    
    
    NSArray *recruitTitle = @[model.jobPositon.length?model.jobPositon:@"",model.salary.length?model.salary:@"",model.epRange.length?model.epRange:@"",model.workTime.length?model.workTime:@"",model.education.length?model.education:@"",model.sex.length?model.sex:@"",model.age.length?model.age:@"",model.invitenumbe.length?model.invitenumbe:@"",model.workAddress.length?model.workAddress:@"",model.workAdS.length?model.workAdS:@"",model.Tel.length?model.Tel:@"",model.TelIsShow.length?model.TelIsShow:@"1",model.Require.length?model.Require:@""];
    NSArray *recruitIdArr = @[model.jobPositonID.length?model.jobPositonID:@"",model.workAddressID.length?model.workAddressID:@""];
    [self.recruitView reloadDataWithTitleArray:recruitTitle IdArray:recruitIdArr];
    self.recruitView.model.requstString = model.Require.length?model.Require:@"";
    //    self.recruitView.model.requireString = [[NSAttributedString alloc] initWithData:[model.Require dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    //self.briefArray = model.epRemarkList;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (WPRecruitDraftInfoRemarkModel *remarkModel in model.epRemarkList) {
        if ([remarkModel.types isEqualToString:@"txt"]) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [arr addObject:str];
        }else{
            [arr addObject:remarkModel.txtcontent];
        }
    }
    self.briefArray = arr;
    
//    NSArray *title = @[model.enterpriseName,model.dataIndustry,model.enterpriseProperties,model.enterpriseScale,model.enterpriseAddress,model.enterprisePersonName,model.enterprisePersonTel];
//    for (int i = WPRecruitDraftEditControllerActionTypeCompanyName; i <= WPRecruitDraftEditControllerActionTypeCompanyPhone; i++) {
//        
//        SPItemView *view = (SPItemView *)[self.verOneScrollView viewWithTag:i];
//        
//        [view resetTitle:title[i-WPRecruitDraftEditControllerActionTypeCompanyName]];
//    }
//    
//    SPTextView *textView = (SPTextView *)[self.verOneScrollView viewWithTag:WPRecruitDraftEditControllerActionTypeCompanyBrief];
//    [textView resetTitle:@"公司简介已填写"];
//    
//    NSArray *recruitTitle = @[model.jobPositon,model.salary,model.epRange,model.workTime,model.education,model.sex,model.age,model.invitenumbe,model.workAddress,model.workAdS,model.Require];
//    NSArray *recruitIdArr = @[model.jobPositonID,model.workAddressID];
//    [self.recruitView reloadDataWithTitleArray:recruitTitle IdArray:recruitIdArr];
//    
//    self.recruitView.model.requireString = [[NSAttributedString alloc] initWithData:[model.Require dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    
//    //self.briefArray = model.epRemarkList;
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    for (WPRecruitDraftInfoRemarkModel *remarkModel in model.epRemarkList) {
//        if ([remarkModel.types isEqualToString:@"txt"]) {
//            NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//            [arr addObject:str];
//        }else{
//            [arr addObject:remarkModel.txtcontent];
//        }
//    }
//    self.briefArray = arr;
}

#pragma mark - 选择企业后回调代理函数
- (void)getCompanyInfo:(WPCompanyListModel *)model
{
    self.model = model;
    
    UIButton *button = (UIButton *)[self.verOneScrollView viewWithTag:WPRecruitDraftEditControllerActionTypeCompanyLogo];
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.QRCode]];
    [button sd_setImageWithURL:url forState:UIControlStateNormal];
    
    //刷新照片和视频
    [self.photosArr removeAllObjects];
    [self.videosArr removeAllObjects];
    [self.photosArr addObjectsFromArray:model.photoList];
    [self.videosArr addObjectsFromArray:model.videoList];
    [self updatePhotosView];
    
    
    NSArray *title = @[model.enterpriseName.length?model.enterpriseName:@"",model.dataIndustry.length?model.dataIndustry:@"",model.enterpriseProperties.length?model.enterpriseProperties:@"",model.enterpriseScale.length?model.enterpriseScale:@"",model.enterpriseAddress.length?model.enterpriseAddress:@"",model.enterpriseDewtailAddress.length?model.enterpriseDewtailAddress:@"",model.enterprisePersonName.length?model.enterprisePersonName:@"",model.enterpriseWebsite.length?model.enterpriseWebsite:@""];
    for (int i = WPRecruitDraftEditControllerActionTypeCompanyName; i <= WPRecruitDraftEditControllerActionTypeCompanyPhone; i++) {
        SPItemView *view = (SPItemView *)[self.verOneScrollView viewWithTag:i];
        [view resetTitle:title[i-WPRecruitDraftEditControllerActionTypeCompanyName]];
    }
    
    SPItemView *textView = (SPItemView *)[self.verOneScrollView viewWithTag:WPRecruitDraftEditControllerActionTypeCompanyBrief];
    if (model.enterpriseBrief.length) {
        [textView resetTitle:@"企业描述已填写"];
        self.briefString = model.enterpriseBrief;
    }
    
    
    NSArray *recruitTitle = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    NSArray *recruitIdArr = @[@"",@""];
    [self.recruitView reloadDataWithTitleArray:recruitTitle IdArray:recruitIdArr];
    
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (WPRecruitDraftInfoRemarkModel *remarkModel in model.epRemarkList) {
        if ([remarkModel.types isEqualToString:@"txt"]) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [arr addObject:str];
        }else{
            [arr addObject:remarkModel.txtcontent];
        }
    }
    self.briefArray = arr;
//    NSArray *title = @[model.enterpriseName,model.dataIndustry,model.enterpriseProperties,model.enterpriseScale,model.enterpriseAddress,model.enterprisePersonName,model.enterprisePersonTel];
//    for (int i = WPRecruitDraftEditControllerActionTypeCompanyName; i <= WPRecruitDraftEditControllerActionTypeCompanyPhone; i++) {
//        
//        SPItemView *view = (SPItemView *)[self.verOneScrollView viewWithTag:i];
//        
//        [view resetTitle:title[i-WPRecruitDraftEditControllerActionTypeCompanyName]];
//    }
//    
//    SPItemView *textView = (SPItemView *)[self.verOneScrollView viewWithTag:WPRecruitDraftEditControllerActionTypeCompanyBrief];
//    [textView resetTitle:@"公司简介已填写"];
//    
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    for (WPRecruitDraftInfoRemarkModel *remarkModel in model.epRemarkList) {
//        if ([remarkModel.types isEqualToString:@"txt"]) {
//            NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//            [arr addObject:str];
//        }else{
//            [arr addObject:remarkModel.txtcontent];
//        }
//    }
//    self.briefArray = arr;
}

/*
 - (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
 {
 if (scrollView == self.horScrollView) {
 [UIView animateWithDuration:0.3 animations:^{
 self.indicatorView.left = targetContentOffset->x/3;
 }];
 }
 }
 */
#pragma mark - 获取ItemView的Title或IndustryID
/**
 *  获取当前TAG的itemView的title
 *
 *  @param superview 父视图
 *  @param tag       TAG
 *
 *  @return 当前itemView的title
 */
- (NSString *)superview:(UIView *)superview title:(NSInteger)tag{
    return [(SPItemView *)[superview viewWithTag:tag] title];
}
/**
 *  获取当前TAG的itemView的industry
 *
 *  @param superview 父视图
 *  @param tag       TAG
 *
 *  @return 当前itemView的industryID
 */
- (NSString *)superview:(UIView *)superview industry:(NSInteger)tag{
    return [(SPItemView *)[superview viewWithTag:tag] industryId];
}

- (NSString *)ModelPropretyNotNull:(NSString *)proprety{
    return proprety?:@"";
}

#pragma mark - 判断是否输入了数据
- (BOOL)judgeIsEdited{
    
    if (![self.model.enterpriseName isEqualToString:self.Infomodel.enterpriseName]) {
        return YES;
    }
    if (![self.model.dataIndustry isEqualToString:self.Infomodel.dataIndustry]) {
        return YES;
    }
    if (![self.model.enterpriseProperties isEqualToString:self.Infomodel.enterpriseProperties]) {
        return YES;
    }
    if (![self.model.enterpriseScale isEqualToString:self.Infomodel.enterpriseScale]) {
        return YES;
    }
    if (![self.model.enterpriseAddress isEqualToString:self.Infomodel.enterpriseAddress]) {
        return YES;
    }
    if (![self.model.enterprisePersonName isEqualToString:self.Infomodel.enterprisePersonName]) {
        return YES;
    }
    if (![self.model.enterprisePersonTel isEqualToString:self.Infomodel.enterprisePersonTel]) {
        return YES;
    }
    //if (![self.model.enterpriseBrief isEqualToString:self.Infomodel.enterpriseBrief]) {
    //return YES;
    //}
    if (self.briefArray.count != self.Infomodel.epRemarkList.count) {
        return YES;
    }
    if (![self.model.enterpriseQq isEqualToString:self.Infomodel.enterpriseQQ]) {
        return YES;
    }
    if (![self.model.enterprisePhone isEqualToString:self.Infomodel.enterprisePhone]) {
        return YES;
    }
    if (![self.model.enterpriseWebchat isEqualToString:self.Infomodel.enterpriseWebchat]) {
        return YES;
    }
    if (![self.model.enterpriseWebsite isEqualToString:self.Infomodel.enterpriseWebsite]) {
        return YES;
    }
    if (![self.model.enterpriseEmail isEqualToString:self.Infomodel.enterpriseEmail]) {
        return YES;
    }
    
    for (UIView *view in self.verOneScrollView.subviews) {
        
        if ([view isKindOfClass:[WPRecruitiew class]]) {
            WPRecruitiew *subview = (WPRecruitiew *)view;
            
            if (![subview.model.jobPositon isEqualToString:self.Infomodel.jobPositon]) {
                return YES;
            }
            //if (![subview.model.jobIndustry isEqualToString:self.Infomodel.jobPositon]) {
            //return YES;
            //}
            //if (![subview.model.jobPositon isEqualToString:self.Infomodel.jobPositon]) {
            //return YES;
            //}
            if (![subview.model.salary isEqualToString:self.Infomodel.salary]) {
                return YES;
            }
            if (![subview.model.epRange isEqualToString:self.Infomodel.epRange]) {
                return YES;
            }
            if (![subview.model.workTime isEqualToString:self.Infomodel.workTime]) {
                return YES;
            }
            if (![subview.model.education isEqualToString:self.Infomodel.education]) {
                return YES;
            }
            if (![subview.model.sex isEqualToString:self.Infomodel.sex]) {
                return YES;
            }
            if (![subview.model.age isEqualToString:self.Infomodel.age]) {
                return YES;
            }
            if (![subview.model.invitenumbe isEqualToString:self.Infomodel.invitenumbe]) {
                return YES;
            }
            if (![subview.model.workAddress isEqualToString:self.Infomodel.workAddress]) {
                return YES;
            }
            if (![subview.model.workAdS isEqualToString:self.Infomodel.workAdS]) {
                return YES;
            }
            //if (![subview.model.apply_Condition isEqualToString:self.Infomodel.jobPositon]) {
            //return YES;
            //}
            //if (![subview.model.Require isEqualToString:self.Infomodel.jobPositon]) {
            //return YES;
            //}
//            NSAttributedString *str = [[NSAttributedString alloc] initWithData:[self.Infomodel.Require dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            NSString * str = self.Infomodel.Require.length?self.Infomodel.Require:@"";
            
            if (![subview.model.requstString isEqualToString:str]) {
                return YES;
            }
        }
    }
    
    if (self.briefArray.count != self.Infomodel.epRemarkList.count) {
        return YES;
    }else{
        for (int i = 0; i < self.briefArray.count; i++) {
            
            WPRecruitDraftInfoRemarkModel *remarkModel = self.Infomodel.epRemarkList[i];
            if ([remarkModel.types isEqualToString:@"txt"]) {
                NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];;
                if (![self.briefArray[i] isEqualToAttributedString:str]) {
                    return YES;
                }
            }
            if ([remarkModel.types isEqualToString:@"img"]) {
                if ([self.briefArray[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
