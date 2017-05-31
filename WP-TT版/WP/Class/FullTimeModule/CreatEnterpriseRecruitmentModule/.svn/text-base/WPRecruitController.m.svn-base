//
//  WPRecuilistController.m
//  WP
//
//  Created by CBCCBC on 15/9/29.
//  Copyright (c) 2015年 WP. All rights reserved.
//



#import "WPRecruitController.h"
#import "WPActionSheet.h"
#import "OpenViewController.h"
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
#import "WPComInfWebViewController.h"
#import "VideoBrowser.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <BlocksKit+UIKit.h>
//#import <ReactiveCocoa.h>
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "SPPhotoAsset.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "SPPhotoBrowser.h"

#import "WPRecruitiew.h"
#import "SPShareView.h"
#import "SPItemView.h"
#import "SPTextView.h"
#import "SPSelectView.h"
#import "THLabel.h"
#import "SPButton.h"
#import "SPRecPreview.h"

#import "WPUploadShuoShuo.h"
#import "ChooseCompanyView.h"
#import "HJCActionSheet.h"
#import "WPCompanyRCTController.h"
#import "WPMySecurities.h"
typedef NS_ENUM(NSInteger,WPRecruitControllerActionType) {
    WPRecruitControllerActionTypeNavigationItemComplete = 1/**< 完成 */,
    WPRecruitControllerActionTypeNavigationItemDrafts = 2/**< 草稿 */,
    WPRecruitControllerActionTypeChooseCompanyName = 3/**< 草稿 */,
    WPRecruitControllerActionTypeCompanyLogo = 4/**< 公司LOGO */,
    WPRecruitControllerActionTypeAddPhoto = 5/**< 添加图片或视频 */,
    WPRecruitControllerActionTypePhotoviewPage = 6/**< 照片浏览 */,
    // 7 ~ 18 /**< 添加过的照片或视频TAG */
    WPRecruitControllerActionTypeCompanyName = 20/**< 公司名称 */,
    WPRecruitControllerActionTypeCompanyIndustry = 21/**< 公司行业 */,
    WPRecruitControllerActionTypeCompanyProperty = 22/**< 公司性质 */,
    WPRecruitControllerActionTypeCompanyScale = 23/**< 公司规模 */,
    WPRecruitControllerActionTypeCompanyArea = 24/**< 公司地点 */,
    
    WPRecruitControllerActionTypeCompanyDetailArea = 25,//公司具体地点,
    
    WPRecruitControllerActionTypePersonalName = 26/**< 联系人 */,
    WPRecruitControllerActionTypeCompanyPhone = 27/**< 企业官网 */,
    WPRecruitControllerActionTypeCompanyBrief = 28/**< 公司简介 */,
    WPRecruitControllerActionTypeMoreConditions = 29/**< 更多条件 */,
    WPRecruitControllerActionTypeMoreResume = 30/**< 更多简历 */,
    WPRecruitControllerActionTypePhone = 70/**< 企业电话 */,
    WPRecruitControllerActionTypeQQ = 71/**< 企业QQ */,
    WPRecruitControllerActionTypeWeChat = 72/**< 企业微信 */,
    WPRecruitControllerActionTypeWebsite = 73/**< 企业官网 */,
    WPRecruitControllerActionTypeEmail = 74 /**< 企业邮箱 */,
};

@implementation SPRecuilistModel

+ (NSDictionary *)objectClassInArray{
    return @{@"dvList" : [Dvlist class], @"pohotoList" : [Pohotolist class]};
}

@end

@interface WPRecruitController () <SPSelectViewDelegate,WPActionSheet,callBackVideo,takeVideoBack,CTAssetsPickerControllerDelegate,UpdateImageDelegate,WPGetCompanyInfoDelegate,WPGetDraftInfoDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,SPPhotoBrowserDelegate,WPCompanyBriefDelegate,WPComInfWebViewDelegate,HJCActionSheetDelegate,UISelectDelegate,getCompanyDreaftInfo>

//@property (strong, nonatomic) UIScrollView *horScrollView;
@property (strong, nonatomic) UIScrollView *verOneScrollView;
//@property (strong, nonatomic) UIScrollView *verOnesScrollView;
@property (strong, nonatomic) UIView *headView;
//@property (strong, nonatomic) UIView *headsView;
@property (strong, nonatomic) ChooseCompanyView *chooseComapnyView;
@property (strong, nonatomic) UIView *addMoreResumeView;
//@property (strong, nonatomic) UIView *moreConditionView;
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
@property (nonatomic, copy) NSString *briefString;//公司简介

@property (nonatomic, strong) UIButton *draftButton;

@property (nonatomic, strong) WPActionSheet *actionSheet;

@property (nonatomic, copy) NSString *epId;
@property (nonatomic, copy) NSString * job_id;

@property (nonatomic, strong) UIImageView *imageViewt;
@property (nonatomic, strong) UILabel *backLabel;
@property (nonatomic, strong)CommonTipView * redView;

@property (nonatomic, assign)BOOL isComeFromDraft;      //判断当前编辑信息是来自草稿
@property (nonatomic, assign)BOOL imageChanged;

@property (nonatomic, strong)WPRecruitDraftInfoModel*draftmoldel;
@property (nonatomic, strong)WPCompanyListModel*companyModel;
@property (nonatomic, assign)BOOL isComeFromCompany;


@property (nonatomic, copy) NSString * choiseCompanyId;//选择企业的id
@property (nonatomic, copy) NSString * choiseDraftId;//选择的草稿id

@property (nonatomic, copy) NSString * is_anoymous;
@property (nonatomic, copy) NSString * is_Look;
@property (nonatomic, copy) NSString * not_look;
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



#define RecuilistHeight (ItemViewHeight*12)
#define RecruitResumeHeight (ItemViewHeight*12+ItemViewHeight)

@implementation WPRecruitController
{
    BOOL isPhotoExit;//判断图片是否存在，不存在是跳到图片上
    BOOL isCompany;//企业中有空数据
    BOOL isZhaopoin;//招聘中有数据
    BOOL isAddFirst;//添加的第一个职位有空数据
    BOOL isAddSecond;//添加的第二个职位有空数据
    BOOL showedTelephone; //是否显示手机号码
}

#pragma mark -- 该页面由 全职-> 企业招聘页面 点击创建 推出
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //禁用滑动手势
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    self.is_Look = @"";
    self.not_look = @"";
    self.is_anoymous = @"0";
    showedTelephone = NO;
    
    _number = 0;
    _nextTop = 0;
    _recruitResumeCount = 0;
    _bodyNumber = 100;
    
    _epId = @"";
    _job_id = @"";
    
    [self requestDraftCount];
    
    [self setNavigationItem];
    //     [self.view addSubview:self.verOneScrollView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessageFromCompanyDraft) name:@"numOfCompanyDraft" object:nil];
    
}
-(WPRecruitDraftInfoModel*)draftmoldel{
    if (!_draftmoldel) {
        _draftmoldel = [[WPRecruitDraftInfoModel alloc]init];
    }
    return _draftmoldel;
}
-(void)receiveMessageFromCompanyDraft
{
    [self requestDraftCount];
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
-(NSString*)briefString
{
    if (!_briefString) {
        _briefString = [[NSString alloc]init];
    }
    return _briefString;
}
- (void)setModel:(WPCompanyListModel *)model{
    if (model&&[model isKindOfClass:[WPCompanyListModel class]]) {
        _model = model;
    }else{
        _model = [[WPCompanyListModel alloc]init];
    }
    _model.enterpriseName = [self ModelPropretyNotNull:_model.enterpriseName];
    _model.dataIndustry = [self ModelPropretyNotNull:_model.dataIndustry];
    _model.dataIndustryId = [self ModelPropretyNotNull:_model.dataIndustryId];
    _model.enterpriseProperties = [self ModelPropretyNotNull:_model.enterpriseProperties];
    _model.enterpriseScale = [self ModelPropretyNotNull:_model.enterpriseScale];
    _model.enterpriseAddress = [self ModelPropretyNotNull:_model.enterpriseAddress];
    _model.enterpriseDewtailAddress = [self ModelPropretyNotNull:_model.enterpriseDewtailAddress];
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
}

#pragma mark - 导航栏
-(void)setNavigationItem
{
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(0, 0, 50, 44);
    completeBtn.tag = WPRecruitControllerActionTypeNavigationItemComplete;
    [completeBtn normalTitle:@"完成" Color:RGB(0, 0, 0) Font:kFONT(14)];
    [completeBtn selectedTitle:@"编辑" Color:RGB(0, 0, 0)];
    [completeBtn addTarget:self action:@selector(rightButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    completeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *completeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:completeBtn];
    
    _draftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _draftButton.frame = CGRectMake(0, 0, 55, 44);
    [_draftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    _draftButton.tag = WPRecruitControllerActionTypeNavigationItemDrafts;
    [_draftButton normalTitle:@"草稿" Color:RGB(0, 0, 0) Font:kFONT(14)];
    _draftButton.hidden = YES;
    [_draftButton addTarget:self action:@selector(rightButtonDraftClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *draftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_draftButton];
    self.navigationItem.rightBarButtonItems = @[completeButtonItem,draftButtonItem];
}

#pragma mark - 企业招聘简历视图
- (UIScrollView *)verOneScrollView
{
    if (!_verOneScrollView) {
        _verOneScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        
        CGFloat headViewHeight = kListEdge+self.chooseComapnyView.height+kListEdge+self.headView.height+kListEdge+self.recruitView.height+kListEdge+self.addMoreResumeView.height+kListEdge;
        
        _verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, headViewHeight);
        _verOneScrollView.backgroundColor = RGB(235, 235, 235);
        
        [_verOneScrollView addSubview:self.chooseComapnyView];//请选择企业
        
        _isFirst?(self.chooseComapnyView.height = 0):0;
        
        [_verOneScrollView addSubview:self.headView];//企业名称。。。公司简介和图片
        
        [_verOneScrollView addSubview:self.recruitView];//招聘职位，工资待遇
        
        //        [_verOneScrollView addSubview:self.moreConditionView];
        
        [_verOneScrollView addSubview:self.addMoreResumeView];
        _verOneScrollView.delegate = self;
    }
    return _verOneScrollView;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark 请选择企业
- (ChooseCompanyView *)chooseComapnyView
{
    CGFloat h ;
    CGFloat w ;
    CGFloat y;
    y = ([_count isEqualToString:@"0"]?0:kListEdge);
    h = ([_count isEqualToString:@"0"])?0:kHEIGHT(43);
    w = ([_count isEqualToString:@"0"])?0:SCREEN_WIDTH;
    if (!_chooseComapnyView) {
        self.chooseComapnyView = [[ChooseCompanyView alloc]initWithFrame:CGRectMake(0, y, w, h)];
        self.chooseComapnyView.button.tag = WPRecruitControllerActionTypeChooseCompanyName;
        [self.chooseComapnyView.button addTarget:self action:@selector(chooseCompanyClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _chooseComapnyView;
}


#pragma mark 选择照片
- (UIScrollView *)photosView
{
    if (!_photosView) {
        _photosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-28, PhotoViewHeight)];
        _photosView.backgroundColor = [UIColor whiteColor];
        _photosView.showsHorizontalScrollIndicator = NO;
        
        _addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPhotoBtn.frame = CGRectMake(kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
        _addPhotoBtn.tag = WPRecruitControllerActionTypeAddPhoto;//commom_gr_tianjiazhaopian
        [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
        [_addPhotoBtn addTarget:self action:@selector(recuilistTagClick:) forControlEvents:UIControlEventTouchUpInside];
        [_photosView addSubview:_addPhotoBtn];
        
        /**< 照片墙翻页 */
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-28, _photosView.top, 28, PhotoViewHeight) ImageName:@"jinru" Target:self Action:@selector(recuilistTagClick:)];
        scrollBtn.backgroundColor = [UIColor whiteColor];
        scrollBtn.tag = WPRecruitControllerActionTypePhotoviewPage;
        [self.headView addSubview:scrollBtn];
    }
    return _photosView;
}

#pragma mark 企业名称，企业行业。。。公司简介
- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, self.chooseComapnyView.bottom+kListEdge, SCREEN_WIDTH, 0)];
        _headView.backgroundColor = RGB(235, 235, 235);
        
        // 照片
        [_headView addSubview:self.photosView];
        
        //        _headView.backgroundColor = [UIColor redColor];
        //        NSArray *titleArr = @[@"企业名称:",@"企业行业:",@"企业性质:",@"企业规模:",@"企业区域:",@"详细地点:",@"联  系 人:",@"企业官网:",@"企业描述:"];
        //        NSArray *placeHolderArr = @[@"请填写企业名称",@"请选择行业",@"请选择企业性质",@"请选择企业规模",@"请选择企业区域",@"请填写详细地点",@"请填写联系人",@"请填写企业官网",@"请填写企业描述"];
        NSArray *titleArr = @[@"企业名称:",@"企业行业:",@"企业性质:",@"企业规模:",@"联  系 人:",@"企业官网:",@"企业描述:"];
        NSArray *placeHolderArr = @[@"请填写企业名称",@"请选择行业",@"请选择企业性质",@"请选择企业规模",@"请填写联系人",@"请填写企业官网",@"请填写企业描述"];
        
        
        
        
        NSArray *styleArr = @[kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeText,kCellTypeText,kCellTypeButton];
        
        UIView *lastview = nil;
        __weak typeof(self) weakSelf = self;
        for (int i = 0; i < titleArr.count; i++) {
            CGFloat top = lastview?lastview.bottom:self.photosView.bottom+10;
            SPItemView *item = [[SPItemView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight)];
            //            item.backgroundColor = [UIColor redColor];
            item.padding = 6;
            [item setTitle:titleArr[i] placeholder:placeHolderArr[i] style:styleArr[i]];
            item.tag = WPRecruitControllerActionTypeCompanyName+i;
            if (i<=3) {
                item.tag = WPRecruitControllerActionTypeCompanyName+i;
            }
            else
            {
                item.tag = WPRecruitControllerActionTypeCompanyName+i+2;
            }
            
            //            if (i == titleArr.count-2) {
            //                item.textField.keyboardType = UIKeyboardTypeURL;
            //
            //            }
            item.SPItemBlock = ^(NSInteger tag){//点击企业的简介
                [weakSelf buttonItem:tag];
            };
            if (item.tag == WPRecruitControllerActionTypeCompanyPhone) {// autocapitalize
                item.textField.keyboardType = UIKeyboardTypeASCIICapable;
                item.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;//去掉大写
            }
            
            item.hideFromFont = ^(NSInteger tag, NSString *title){
                SPItemView *itemview = (SPItemView *)[weakSelf.view viewWithTag:tag];
                [itemview resetTitle:title];
                switch (tag) {
                    case WPRecruitControllerActionTypeCompanyName:
                        self.model.enterpriseName = title;
                        break;
                    case WPRecruitControllerActionTypePersonalName:
                        self.model.enterprisePersonName = title;
                        break;
                        //                    case WPRecruitControllerActionTypeCompanyDetailArea://企业详细地址
                        //                        self.model.enterpriseDewtailAddress = title;
                        //                        break;
                    case WPRecruitControllerActionTypeCompanyPhone:
                        self.model.enterpriseWebsite = title;
                        break;
                }
            };
            [_headView addSubview:item];
            
            lastview = item;
        }
        //公司简介
        //获取headview最后子视图的bottom，设置headview的高度
        _headView.height = lastview.bottom;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [_headView addGestureRecognizer:tap];
    }
    return _headView;
}

#pragma mark 照片信息更新
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
            [button setImage:[self.photosArr[i] originImage] forState:UIControlStateNormal];
        }
        
        //        if ([self.photoArray[i] isKindOfClass:[SPPhotoAsset class]]) {
        //            [button setImage:[self.photoArray[i] originImage] forState:UIControlStateNormal];
        //        }else{
        //            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photoArray[i] thumb_path]]];
        //            [button sd_setImageWithURL:url forState:UIControlStateNormal];
        //        }
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

#pragma mark 招聘职位，工资待遇。。。任职要求
- (WPRecruitiew *)recruitView
{
    if (!_recruitView) {
        
        _recruitView = [[WPRecruitiew alloc]initWithFrame:CGRectMake(0, self.headView.bottom+kListEdge, SCREEN_WIDTH, RecuilistHeight)];
        [_recruitView setNumber:100];
        _recruitView.telephoneShowOrHiddenBlock = ^(BOOL showed){
            showedTelephone = showed;
        };
        WS(ws);
        //        _recruitView.city.delegate = self;
        _recruitView.InputPositionRequireBlock = ^(NSInteger tag){
            ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
            editing.title = @"任职要求";
            editing.textFieldString = ws.recruitView.model.requstString;
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

#pragma mark 更多条件
//- (UIView *)moreConditionView
//{
//
//    if (!_moreConditionView) {
//        CGFloat top = self.recruitView.bottom+kListEdge;
//        _moreConditionView = [[UIView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight)];
////        _moreConditionView.backgroundColor = [UIColor redColor];
//
//        SPButton *button = [[SPButton alloc]initWithFrame:_moreConditionView.bounds title:@"更多条件(可填可不填)" ImageName:@"tianjiafeiyong" Target:self Action:@selector(showMoreConditionAction:)];
//        button.tag = WPRecruitControllerActionTypeMoreConditions;
//        button.contentLabel.textColor = [UIColor blackColor];
//        [_moreConditionView addSubview:button];
//    }
//    return _moreConditionView;
//}

#pragma mark 招聘更多职位
- (UIView *)addMoreResumeView
{
    if (!_addMoreResumeView) {
        _addMoreResumeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.recruitView.bottom+kListEdge, SCREEN_WIDTH, ItemViewHeight)];
        _addMoreResumeView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:_addMoreResumeView.bounds];
        [button setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, kHEIGHT(12), 0, 0);
        [button addTarget:self action:@selector(addMorePosition) forControlEvents:UIControlEventTouchUpInside];
        [_addMoreResumeView addSubview:button];
    }
    return _addMoreResumeView;
}

#pragma mark 内容选择视图
- (SPSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[SPSelectView alloc]initWithTop:64];
        _selectView.delegate = self;
    }
    else
    {
        _selectView.line.height = 0.5;
    }
    return _selectView;
}

#pragma mark - 展示or删除预览
- (void )AddrecPreview{
    SPRecPreview *recPreview = [[SPRecPreview alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    
    __weak typeof(self) weakSelf = self;
    recPreview.checkVideosBlock = ^(NSInteger num){
        [weakSelf checkVideos:num];
    };
    
    recPreview.checkAllVideosBlock = ^(){
        [weakSelf checkAllVideosBlock:NO];
    };
    __weak typeof(recPreview) weakRec = recPreview;
    recPreview.clickOpen = ^(){
        OpenViewController *open = [[OpenViewController alloc] init];
        open.clickComplete = ^(NSDictionary*dic,NSIndexPath*index){
            weakRec.share.subTitle.text =  dic[@"title"];
            if (index.section <= 3) {
                self.is_anoymous = [NSString stringWithFormat:@"%ld",(long)index.section];
            }
            else
            {
                self.is_anoymous = [NSString stringWithFormat:@"%ld",(long)index.section-1];
                if (index.section == 5) {
                    self.is_Look = dic[@"userID"];
                }
                else
                {
                    self.not_look = dic[@"userID"];
                }
            }
        };
        [self.navigationController pushViewController:open animated:YES];
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
    UIImage *image = [(UIButton *)[self.verOneScrollView viewWithTag:WPRecruitControllerActionTypeCompanyLogo] imageView].image;
    if (image == nil) {
        image = [UIImage imageNamed:@"back_default"];
    }
    model.logoArr = @[image];
    model.listModel = self.model;
    recPreview.model = model;
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
- (UIView *)sendbottomView
{
    if (!_sendbottomView) {
        _sendbottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _sendbottomView.backgroundColor = RGB(0, 172, 255);
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
        [button setTitle:@"发布" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = kFONT(15);
        button.tag = 90;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 4)];
        [button setImage:[UIImage imageNamed:@"qz_fabu"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"qz_fabu"] forState:UIControlStateHighlighted];
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
//- (void)showMoreConditionAction:(UIButton *)sender{
//
//    sender.selected = !sender.selected;
//
//    UIView *lastView  = nil;
//
//    SPButton *button = (SPButton *)[self.moreConditionView viewWithTag:WPRecruitControllerActionTypeMoreConditions];
//
//    if (sender.selected) {/**< 展开更多信息 */
//        NSArray *titleArr = @[@"企业电话:",@"企业Q Q:",@"企业微信:",@"企业官网:",@"企业邮箱:"];
//        NSArray *placehorderArr = @[@"请输入企业电话",@"请输入企业QQ",@"请输入企业微信",@"请输入企业官网",@"请输入企业邮箱"];
//
//        for (int i = 0; i < titleArr.count; i++) {
//            CGFloat top = lastView?lastView.bottom:0;
//            SPItemView *itemView = [[SPItemView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight)];
//            itemView.tag = i+WPRecruitControllerActionTypePhone;
//            [itemView setTitle:titleArr[i] placeholder:placehorderArr[i] style:kCellTypeText];
//            [self.moreConditionView addSubview:itemView];
//
//            WS(ws);
//            itemView.hideFromFont = ^(NSInteger tag, NSString *title){
//                SPItemView *item = (SPItemView *)[ws.moreConditionView viewWithTag:tag];
//                [item resetTitle:title];
//                button.contentLabel.text = @"删除";
//                switch (tag) {
//                    case WPRecruitControllerActionTypePhone:
//                        self.model.enterprisePhone = title;
//                        break;
//                    case WPRecruitControllerActionTypeQQ:
//                        self.model.enterpriseQq = title;
//                        break;
//                    case WPRecruitControllerActionTypeWeChat:
//                        self.model.enterpriseWebchat = title;
//                        break;
//                    case WPRecruitControllerActionTypeWebsite:
//                        self.model.enterpriseWebsite = title;
//                        break;
//                    case WPRecruitControllerActionTypeEmail:
//                        self.model.enterpriseEmail = title;
//                        break;
//                    default:
//                        break;
//                }
//            };
//
//            lastView = itemView;
//        }
//
//        button.contentLabel.text = @"收起";
//        button.subImageView.image = [UIImage imageNamed:@"shouqi"];
//        [button setContentLabelSize:@"收起" font:15];
//
//    }else{/**< 收起更多信息 */
//        for (UIView *view in self.moreConditionView.subviews) {
//            if ([view isKindOfClass:[SPItemView class]]) {
//                [view removeFromSuperview];
//            }
//        }
//        button.contentLabel.text = @"更多条件(可填可不填)";
//        button.subImageView.image = [UIImage imageNamed:@"tianjiafeiyong"];
//        [button setContentLabelSize:@"更多条件(可填可不填)" font:15];
//    }
//
//    //重置『更多条件』frame
//    button.top = lastView?lastView.bottom:0;
//
//    self.moreConditionView.height = button.bottom;
//
//    [self updateRecruitResumeFrame];
//
//}
//
//- (void)updateRecruitResumeFrame{
//    UIView *lastview = nil;
//    for (UIView *recruitView in self.verOneScrollView.subviews) {
//
//        if ([recruitView isKindOfClass:[WPRecruitiew class]]) {
//
//            if (recruitView.tag != 100) {
//                recruitView.top = (lastview?lastview.bottom:self.moreConditionView.bottom)+kListEdge;
//                lastview = recruitView;
//            }
//        }
//    }
//    CGFloat height = lastview?(lastview.bottom):(self.moreConditionView.bottom);
//
//    self.verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height+kListEdge+ItemViewHeight+kListEdge);
//
//    self.addMoreResumeView.bottom = self.verOneScrollView.contentSize.height-kListEdge;
//}





#pragma mark - 点击选择企业
-(void)chooseCompanyClick
{
    //    [[WPComInfWebViewController alloc]init].delegate = self;
    WPCompanyController *company = [[WPCompanyController alloc]init];
    company.delegate = self;
    company.isBuild = YES;
    company.choiseCompanyId = self.choiseCompanyId.length?self.choiseCompanyId:@"";
    [self.navigationController pushViewController:company animated:YES];
}

-(void)tap:(UITapGestureRecognizer *)tap
{
    [self.verOneScrollView endEditing:YES];
}

#pragma mark - 点击查看单个查看图片
-(void)checkImageClick:(UIButton *)sender
{
    
    
    //    if (sender.tag>=PhotoTag &&sender.tag <VideoTag) {//点击查看图片
    //
    //        NSMutableArray *arr = [[NSMutableArray alloc]init];
    //        for (int i = 0; i < self.photoArray.count; i++) {/**< 头像或背景图 */
    //            MJPhoto *photo = [[MJPhoto alloc]init];
    //            if ([self.photoArray[i] isKindOfClass:[PhotoVideo class]]) {
    //                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photoArray[i] original_path]]];
    //                photo.url = url;
    //            }else{
    //                photo.image = [self.photoArray[i] originImage];
    //            }
    //            photo.srcImageView = [(UIButton *)[self.photoView viewWithTag:50+i] imageView];
    //            [arr addObject:photo];
    //        }
    //        SPPhotoBrowser *brower = [[SPPhotoBrowser alloc] init];
    //        brower.delegate = self;
    //        brower.currentPhotoIndex = sender.tag-PhotoTag;
    //        brower.photos = arr;
    //        [self.navigationController pushViewController:brower animated:YES];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (sender.tag>=PhotoTag &&sender.tag <VideoTag){
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
    }
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
    _imageChanged = YES;
    [self updatePhotosView];
}
- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser coverImageAtIndex:(NSInteger)index
{
    id object = self.photosArr[index];
    [self.photosArr removeObjectAtIndex:index];
    [self.photosArr insertObject:object atIndex:0];
    [self updatePhotosView];
}

#pragma mark - 点击预览界面查看照片墙
-(void)checkAllVideosBlock:(BOOL)isEdit
{
    
    SAYVideoManagerViewController *vc = [[SAYVideoManagerViewController alloc]init];
    vc.arr = self.photosArr;
    vc.videoArr = self.videosArr;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
    //    SAYVideoManagerViewController *vc = [[SAYVideoManagerViewController alloc]init];
    //    if (_isFirst) {
    //        vc.arr = self.photosArr;
    //        vc.videoArr = self.videosArr;
    //    }else{
    //        vc.arr = self.model.photoList;
    //        vc.videoArr = self.model.videoList;
    //    }
    //
    //    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    //    [self presentViewController:navc animated:YES completion:nil];
}

#pragma mark - 查看视频
-(void)checkVideos:(NSInteger)number
{
    NSLog(@"观看视频");
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (_isFirst) {
        [arr addObject:self.videosArr];
    }else{
        if (self.model.videoList) {
            //         [arr addObject:self.model.videoList];
            [arr addObjectsFromArray:self.model.videoList];
        }
    }
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
        video.videoUrl = [NSString stringWithFormat:@"%@",asset.defaultRepresentation.url];
        //        ALAsset *asset = arr[number];
        //        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
    }else{
        
        video.isNetOrNot = YES;
        video.videoUrl =[IPADDRESS stringByAppendingString:[arr[number] original_path]];
        //        NSLog(@"%@",[IPADDRESS stringByAppendingString:[arr[number] original_path]]);
        //        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[arr[number] original_path]]];
        //        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    }
    [video showPickerVc:self];
    //指定媒体类型为文件
    //    _moviePlayerVC.moviePlayer.movieSourceType = MPMovieSourceTypeFile|MPMovieSourceTypeStreaming;
    //
    //    //通知中心
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPlaybackFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
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
        //        NSURL *url = [NSURL fileURLWithPath:self.videosArr[sender.tag-VideoTag]];
        //        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    } else {
        Dvlist *asset = self.videosArr[sender.tag-VideoTag];
        video.isNetOrNot = YES;
        video.videoUrl = [NSString stringWithFormat:@"%@%@",IPADDRESS,asset.original_path];
        //        ALAsset *asset = self.videosArr[sender.tag-VideoTag];
        //        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
    }
    [video showPickerVc:self];
    //指定媒体类型为文件
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
        _nextTop = _recruitResumeCount*RecruitResumeHeight+_recruitResumeCount*kListEdge+self.recruitView.bottom+kListEdge;
        _recruitResumeCount ++;
        _bodyNumber+=100*_recruitResumeCount;
        
        if (_recruitResumeCount == 2) {
            _addMoreResumeView.hidden = YES;
        }
        
        WS(ws);
        WPRecruitiew *recuilistView = [[WPRecruitiew alloc]initWithFrame:CGRectMake(0, _nextTop, SCREEN_WIDTH, RecruitResumeHeight)];
        recuilistView.deletePositionBlock = ^(NSInteger tag){
            
            WPRecruitiew *revc = (WPRecruitiew *)[self.verOneScrollView viewWithTag:tag];
            
            NSString *temp1 = revc.model.jobPositon;
            NSString *temp2 = revc.model.salary;
            NSString *temp3 = revc.model.epRange;
            NSString *temp4 = revc.model.workTime;
            NSString *temp5 = revc.model.sex;
            NSString *temp6 = revc.model.age;
            NSString *temp7 = revc.model.invitenumbe;
            NSString *temp8 = revc.model.workAddress;
            NSString *temp9 = revc.model.workAdS;
            NSString *temp10 = revc.model.Require;
            NSString *temp11 = revc.model.education;
            
            if ([temp1 isEqualToString:@""] && [temp2 isEqualToString:@""] && [temp3 isEqualToString:@""]&& [temp4 isEqualToString:@""] && [temp5 isEqualToString:@""]&& [temp6 isEqualToString:@""] && [temp7 isEqualToString:@""] && [temp8 isEqualToString:@""] && [temp9 isEqualToString:@""] && [temp10 isEqualToString:@""] && [temp11 isEqualToString:@""])
            {
                [ws deletePosition:tag];
            }else
            {
                [SPAlert alertControllerWithTitle:@"提示" message:@"是否确认删除" superController:self cancelButtonTitle:@"取消" cancelAction:nil defaultButtonTitle:@"确认" defaultAction:^{
                    //                    NSLog(@"点击确认");
                    [ws deletePosition:tag];
                }];
            }
        };
        
        __weak typeof(recuilistView) weakRecuilistView = recuilistView;
        recuilistView.InputPositionRequireBlock = ^(NSInteger tag){
            ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
            //            editing.attributedString = weakRecuilistView.model.requireString;
            //            editing.attributedString = [[NSAttributedString alloc] initWithAttributedString:ws.recruitView.model.requireString];
            editing.title = @"任职要求";
            editing.textFieldString = weakRecuilistView.model.requstString;
            editing.verifyClickBlock = ^(NSAttributedString *attributedString){
                //                weakRecuilistView.model.requireString = attributedString;
                weakRecuilistView.model.requstString = attributedString;
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
        
        /*
         if (_isFirst) {
         [_verOneScrollView addSubview:recuilistView];
         _verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (_recruitResumeCount+1)*(RecuilistHeight+10)+self.headView.height+ItemViewHeight+20);
         }else{
         [_verOnesScrollView addSubview:recuilistView];
         _verOnesScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (_recruitResumeCount+1)*(RecuilistHeight+10)+self.headsView.height+ItemViewHeight+10+10);
         }
         [_verOneScrollView addSubview:recuilistView];
         _verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (_bodyCount+1)*(RecuilistHeight+10)+self.headView.height+60);
         self.shareView.top = (_bodyCount+1)*RecuilistHeight+_bodyCount*10+self.headView.height+10+10;
         
         WPRecuilistView *revc = (WPRecuilistView *)[self.verOneScrollView viewWithTag:60];
         revc.deleteButton.hidden = NO;
         if (_recruitResumeCount == 1) {
         
         }
         NSMutableArray *subArr = [[NSMutableArray alloc]init];
         if (_isFirst) {
         [subArr addObjectsFromArray:self.verOneScrollView.subviews];
         }else{
         [subArr addObjectsFromArray:self.verOnesScrollView.subviews];
         }
         for (UIView *view in subArr) {
         if ([view isKindOfClass:[WPRecruitiew class]]) {
         [[(WPRecruitiew *)view deleteButton] setHidden:NO];
         }
         }*/ // 已废弃
    }
}

#pragma mark 点击删除操作
- (void)deletePosition:(NSInteger)tag
{
    //    [_recruitView.areaCity removeFromSuperview];
    //    UIView * view = [WINDOW viewWithTag:1000];
    //    [view removeFromSuperview];
    
    _recruitResumeCount--;
    CGFloat height = self.verOneScrollView.contentSize.height;
    self.verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height-RecruitResumeHeight-kListEdge);
    self.addMoreResumeView.bottom = self.verOneScrollView.contentSize.height-kListEdge;
    for (int i = 0; i <= _bodyNumber/100; i++) {
        if (i*100 == tag) {
            WPRecruitiew *revc = (WPRecruitiew *)[self.verOneScrollView viewWithTag:tag];
            [UIView animateWithDuration:0.2 animations:^{
                [revc removeFromSuperview];
            }];
        }
        if (i*100 > tag) {
            WPRecruitiew *revc = (WPRecruitiew *)[self.verOneScrollView viewWithTag:i*100];
            [UIView animateWithDuration:0.5 animations:^{
                revc.top = revc.top - ItemViewHeight*12- kListEdge;
            }];
            
        }
    }
    
    
    
    //    _bodyNumber-=100*_recruitResumeCount;
    //    _recruitResumeCount--;
    
    
    
    //    CGFloat height = self.verOneScrollView.contentSize.height;
    //    self.verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height-RecruitResumeHeight-kListEdge);
    //    self.addMoreResumeView.bottom = self.verOneScrollView.contentSize.height-kListEdge;
    
    
    _addMoreResumeView.hidden = NO;
    [MBProgressHUD createHUD:@"已删除当前职位" View:self.view];
    
    /*
     if (tag != _bodyNumber) {
     for (int i = 0; i < (_bodyNumber-tag)/10; i++) {
     if (_isFirst) {
     WPRecruitiew *revc = (WPRecruitiew *)[self.verOneScrollView viewWithTag:tag+(1+i)*10];
     revc.top = revc.top-RecuilistHeight-10;
     }else{
     WPRecruitiew *revc = (WPRecruitiew *)[self.verOnesScrollView viewWithTag:tag+(1+i)*10];
     revc.top = revc.top-RecuilistHeight-10;
     }
     }
     }
     if (_isFirst) {
     WPRecruitiew *revc = (WPRecruitiew *)[self.verOneScrollView viewWithTag:tag];
     [revc removeFromSuperview];
     _verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (_recruitResumeCount+1)*(RecuilistHeight+10)+self.headView.height+ItemViewHeight+20);
     }else{
     WPRecruitiew *revc = (WPRecruitiew *)[self.verOnesScrollView viewWithTag:tag];
     [revc removeFromSuperview];
     _verOnesScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (_recruitResumeCount+1)*(RecuilistHeight+10)+self.headsView.height+ItemViewHeight+10+10);
     }
     
     NSMutableArray *subArr = [[NSMutableArray alloc]init];
     if (_isFirst) {
     [subArr addObjectsFromArray:self.verOneScrollView.subviews];
     }else{
     [subArr addObjectsFromArray:self.verOnesScrollView.subviews];
     }
     int subCount = 0;
     for (UIView *view in subArr) {
     if ([view isKindOfClass:[WPRecruitiew class]]) {
     subCount++;
     }
     }
     if (subCount == 1) {
     for (UIView *view in subArr) {
     if ([view isKindOfClass:[WPRecruitiew class]]) {
     [[(WPRecruitiew *)view deleteButton] setHidden:YES];
     }
     }
     }*/ //已废弃
    
    
}



- (WPActionSheet *)actionSheet{
    if (!_actionSheet) {
        WS(ws);
        _actionSheet = [[WPActionSheet alloc]initWithOtherButtonTitle:_isComeFromDraft?@[@"保存",@"不保存"]:@[@"保存草稿",@"不保存草稿"] imageNames:nil top:64 actions:^(NSInteger type) {
            if (type == 1) {
                [self completeAllMessage:@"1"];
                //                [self.navigationController popViewControllerAnimated:YES];
            }
            if (type == 2) {
                [ws.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    return _actionSheet;
}

#pragma mark - 点击返回
-(void)backToFromViewController:(UIButton *)sender
{
    if(self.actionSheet.frame.origin.y < 0&&sender.selected){
        sender.selected = !sender.selected;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (_isComeFromDraft) {//是否从草稿中选择
            if ([self fromDraftChange:nil and:_draftmoldel andType:NO]) {
                [self.actionSheet showInView:self.view];
            }
            else
            {
                [_recruitView.areaCity removeFromSuperview];
                [_recruitView.subView1 removeFromSuperview];//移除窗口上的点击
                [self.navigationController popViewControllerAnimated: YES];
            }
        }
        else if (_isComeFromCompany)//是否从企业中选择
        {
            if ([self fromDraftChange:_companyModel and:nil andType:YES]) {
                [self.actionSheet showInView:self.view];
            }
            else
            {
                
                [_recruitView.areaCity removeFromSuperview];
                [_recruitView.subView1 removeFromSuperview];//移除窗口上的点击
                
                
                [self.navigationController popViewControllerAnimated: YES];
            }
        }
        else
        {
            if ([self judgeIsEdited]) {
                [self.actionSheet showInView:self.view];
            }else{
                
                [_recruitView.areaCity removeFromSuperview];
                [_recruitView.subView1 removeFromSuperview];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else{
        [self.actionSheet hideFromView:self.view];
    }
}

-(BOOL)fromDraftChange:(WPCompanyListModel*)companyModel and:(WPRecruitDraftInfoModel*)fraftModel andType:(BOOL)ischoiseCompany
{
    BOOL isOrNot = NO;
    if (![self.model.enterpriseName isEqualToString:ischoiseCompany?companyModel.enterpriseName:fraftModel.enterpriseName]) {
        return YES;
    }
    if (![self.model.dataIndustry isEqualToString:ischoiseCompany?companyModel.dataIndustry:fraftModel.dataIndustry]) {
        return YES;
    }
    if (![self.model.enterpriseProperties isEqualToString:ischoiseCompany?companyModel.enterpriseProperties:fraftModel.enterpriseProperties]) {
        return YES;
    }
    if (![self.model.enterpriseScale isEqualToString:ischoiseCompany?companyModel.enterpriseScale:fraftModel.enterpriseScale]) {
        return YES;
    }
    if (![self.model.enterpriseAddress isEqualToString:ischoiseCompany?companyModel.enterpriseAddress:fraftModel.enterpriseAddress]) {
        return YES;
    }
    if (![self.model.enterpriseDewtailAddress isEqualToString:ischoiseCompany?companyModel.enterpriseDewtailAddress:fraftModel.enterpriseDewtailAddress]) {
        return YES;
    }
    if (![self.model.enterprisePersonName isEqualToString:ischoiseCompany?companyModel.enterprisePersonName:fraftModel.enterprisePersonName]) {
        return YES;
    }
    if (![self.model.enterpriseBrief isEqualToString:ischoiseCompany?companyModel.enterpriseBrief:fraftModel.enterpriseBrief]) {
        return YES;
    }
    
    if (![self.model.enterpriseWebsite isEqualToString:ischoiseCompany?companyModel.enterpriseWebsite:fraftModel.enterpriseWebsite]) {
        return YES;
    }
    
    for (UIView *view in self.verOneScrollView.subviews) {
        if ([view isKindOfClass:[WPRecruitiew class]]) {
            WPRecruitiew *subview = (WPRecruitiew *)view;
            
            !subview.model.requstString?(subview.model.requstString=@""):0;
            
            if (![subview.model.jobPositon isEqualToString:ischoiseCompany?companyModel.jobPositon:fraftModel.jobPositon]) {
                return YES;
            }
            if (![subview.model.salary isEqualToString:ischoiseCompany?companyModel.salary:fraftModel.salary]) {
                return YES;
            }
            if (![subview.model.epRange isEqualToString:ischoiseCompany?companyModel.epRange:fraftModel.epRange]) {
                return YES;
            }
            if (![subview.model.epRange isEqualToString:ischoiseCompany?companyModel.epRange:fraftModel.epRange]) {
                return YES;
            }
            if (![subview.model.workTime isEqualToString:ischoiseCompany?companyModel.workTime:fraftModel.workTime]) {
                return YES;
            }
            if (![subview.model.education isEqualToString:ischoiseCompany?companyModel.education:fraftModel.education]) {
                return YES;
            }
            if (![subview.model.sex isEqualToString:ischoiseCompany?companyModel.sex:fraftModel.sex]) {
                return YES;
            }
            if (![subview.model.age isEqualToString:ischoiseCompany?companyModel.age:fraftModel.age]) {
                return YES;
            }
            if (![subview.model.invitenumbe isEqualToString:ischoiseCompany?companyModel.invitenumbe:fraftModel.invitenumbe]) {
                return YES;
            }
            if (![subview.model.workAddress isEqualToString:ischoiseCompany?companyModel.workAddress:fraftModel.workAddress]) {
                return YES;
            }
            if (![subview.model.workAdS isEqualToString:ischoiseCompany?companyModel.workAdS:fraftModel.workAdS]) {
                return YES;
            }
            if (![subview.model.requstString isEqualToString:ischoiseCompany?companyModel.Require:fraftModel.Require]) {
                return YES;
            }
        }
    }
    if (self.briefArray.count) {
        return YES;
    }
    return _imageChanged;
    return isOrNot;
}
#pragma mark  判断必填项是否为空
- (BOOL)canHeadViewCommit
{
    BOOL isOK = YES;
    
    
    //判断图片是否为空
    if (self.photosArr.count ==0 && self.videosArr.count == 0) {
        [self.photosView addSubview:self.redView];//将红色字添加
        isOK = NO;
        isPhotoExit = YES;
        //        return NO;
    }
    
    //判断头部
    NSArray * SPItemArray = self.headView.subviews;
    
    for (SPItemView *item in SPItemArray) {
        if ([item isKindOfClass:[SPItemView class]]) {
            if ([item textFieldIsnotNil]) {
                isOK = NO;
                isCompany = YES;
                //                return NO;
            }
        }
    }
    
    //判断招聘职位，工资待遇，企业福利。。
    NSArray * recruitViewArray = self.recruitView.subviews;
    
    for (SPItemView *item in recruitViewArray) {
        if ([item isKindOfClass:[SPItemView class]]) {
            if ([item textFieldIsnotNil]) {
                isOK = NO;
                isZhaopoin = YES;
                //                return NO;
            }
        }
    }
    
    //判断添加的职位
    for (UIView * view in _verOneScrollView.subviews) {
        if ([view isKindOfClass:[WPRecruitiew class]]) {
            WPRecruitiew * recruitView = (WPRecruitiew*)view;
            NSArray * moreArray = recruitView.subviews;
            for (SPItemView *item in moreArray) {
                if ([item isKindOfClass:[SPItemView class]]) {
                    if ([item textFieldIsnotNil]) {
                        isOK = NO;
                        if (item.tag > 400) {
                            isAddSecond = YES;
                        }
                        else
                        {
                            isAddFirst = YES;
                        }
                        //                        return NO;
                    }
                }
            }
            
        }
    }
    return isOK;
}
- (CommonTipView *)redView
{
    if (!_redView) {
        self.redView = [[CommonTipView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.redView.title = @"不能为空,至少上传一张";
        CGFloat x = SCREEN_WIDTH-8-16-8-(self.redView.size.width/2);
        self.redView.center = CGPointMake(x, self.photosView.size.height/2);
    }
    return _redView;
}
- (BOOL)canRecruitViewCommit
{
    BOOL isOK = YES;
    NSArray * recruitViewArray = self.recruitView.subviews;
    
    for (SPItemView *item in recruitViewArray) {
        if ([item isKindOfClass:[SPItemView class]]) {
            if ([item textFieldIsnotNil]) {
                isOK = NO;
            }
        }
    }
    
    return isOK;
}

#pragma mark - 点击完成或编辑
-(void)rightButtonItemClick:(UIButton *)sender
{
    
    if (![self canHeadViewCommit]) {//判断必填项是否为空
        if (isPhotoExit || isCompany) {
            CGPoint point = CGPointMake(0, 0);
            [_verOneScrollView setContentOffset:point animated:YES];
            isPhotoExit = NO;
            isCompany = NO;
            
        }
        else if (isZhaopoin)
        {
            CGPoint point = CGPointMake(0, self.headView.bottom+kListEdge);
            [_verOneScrollView setContentOffset:point animated:YES];
            isZhaopoin = NO;
        }
        else if (isAddFirst)
        {
            CGPoint point = CGPointMake(0, self.recruitView.bottom+kListEdge);
            [_verOneScrollView setContentOffset:point animated:YES];
            isAddFirst = NO;
        }
        else if (isAddSecond)
        {
            
            CGPoint point = CGPointMake(0, self.recruitView.bottom+kListEdge+self.recruitView.height);
            [_verOneScrollView setContentOffset:point animated:YES];
            isAddSecond = NO;
        }
        return;
    }
    
    //判断网址是否有效
    if (self.model.enterpriseWebsite.length) {
        NSArray *match = [self checkUrl:self.model.enterpriseWebsite];
        if (!match.count) {
            [MBProgressHUD createHUD:@"请填写有效网址" View:self.view];
            return;
        }
        //        for (NSTextCheckingResult *per in match)
        //        {
        //            NSString *urlString = [self.model.enterpriseWebsite substringWithRange:per.range];
        //            if([urlString rangeOfString:@"http"].location == NSNotFound){
        //                urlString = [@"http://" stringByAppendingString:urlString];
        //            }
        //        }
    }
    
    
    
    [self.headView endEditing:YES];
    [self.recruitView endEditing:YES];
    
    NSMutableArray *subArr = [[NSMutableArray alloc]init];
    if (_isFirst) {
        [subArr addObjectsFromArray:self.verOneScrollView.subviews];
    }else{
        //        [subArr addObjectsFromArray:self.verOnesScrollView.subviews];
    }
    //    [subArr addObjectsFromArray:self.verOneScrollView.subviews];
    
    BOOL allReady = YES;
    
    for (UIView *view in subArr) {
        if ([view isKindOfClass:[WPRecruitiew class]]) {
            [(WPRecruitiew *)view endEditing:YES];
            if ([(WPRecruitiew *)view allMessageIsComplete]) {
            }else{
                allReady = NO;
                break;
            }
        }
    }
#pragma mark 展示预览界面
    if (allReady == YES) {
        //        [self completeAllMessage];
        sender.selected = !sender.selected;
        self.sendbottomView.hidden = NO;
        [self AddrecPreview];//展示预览界面
        
        _draftButton.hidden = YES;
        self.title = @"企业招聘";
    }
    
    
    if (!sender.selected) {
        [self deleteRecPreview];
        self.sendbottomView.hidden = YES;
        if (_draftNumber.text.intValue) {
            _draftButton.hidden = NO;
        }
        else
        {
            _draftButton.hidden = YES;
        }
        //        _draftButton.hidden = NO;
        self.title = @"创建企业招聘";
    }
}
- (NSArray *)checkUrl:(NSString*)string
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:URL_REGULA
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    return matches;
}

#pragma mark  点击草稿
- (void)rightButtonDraftClick:(UIButton *)sender
{
    WPCompanyRCTController *company = [[WPCompanyRCTController alloc]init];
    company.delegate = self;
    company.choiseDraftId = self.choiseDraftId.length?self.choiseDraftId:@"";
    //    WPRecruitDraftController *company = [[WPRecruitDraftController alloc]init];
    //    company.delegate = self;
    [self.navigationController pushViewController:company animated:YES];
}
#pragma mark WPResumeDraftVC

#pragma mark - 获取草稿数量和企业个数
- (void)requestDraftCount{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    NSDictionary *params = @{@"action":@"BeforeAddJob",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        if ([json[@"status"] isEqualToString:@"0"]) {
            _count = json[@"companyCount"];
            
            if (0 != [json[@"draftCount"] integerValue]) {
                _draftButton.hidden = NO;
                _draftNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, 13, 20, 20)];
                _draftNumber.backgroundColor = RGB(0, 172, 255);
                _draftNumber.layer.cornerRadius = 10;
                _draftNumber.layer.masksToBounds = YES;
                _draftNumber.text = @"0";
                _draftNumber.font = kFONT(12);
                _draftNumber.textColor = [UIColor whiteColor];
                _draftNumber.textAlignment = NSTextAlignmentCenter;
                _draftNumber.text = json[@"draftCount"];
                [_draftButton addSubview:_draftNumber];
            }
            else
            {
                _draftButton.hidden = YES;
            }
            
            // 不区分有无简历,只区分有无选择企业
            [self.view addSubview:self.verOneScrollView];
            
        }
    } failure:^(NSError *error) {
        [self.view addSubview:self.verOneScrollView];
        //        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - 点击发布简历
-(void)completeAllMessage:(NSString *)isDraft
{
    UIButton * senderBtn = (UIButton*)[_sendbottomView viewWithTag:90];
    senderBtn.userInteractionEnabled = NO;
    
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    BOOL updateImage = YES;
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
        formDatas.name = [NSString stringWithFormat:@"photoAddress%d",i];
        formDatas.filename = [NSString stringWithFormat:@"photoAddress%d.png",i];
        formDatas.mimeType = @"image/png";
        [dataArr addObject:formDatas];
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
        formDatas.name = [NSString stringWithFormat:@"photoAddress%lu",i+self.photosArr.count];
        formDatas.filename = [NSString stringWithFormat:@"photoAddress%d.mp4",i];//+self.photosArr.count
        formDatas.mimeType = @"video/quicktime";
        [dataArr addObject:formDatas];
        if (!formDatas.data) {
            updateImage = NO;
        }
    }
    //}
    
    NSArray *subArr = self.verOneScrollView.subviews;
    NSMutableArray *jobs = [[NSMutableArray alloc]init];
    
    NSString * uniueString = [self getUniqueStrByUUID];
    int i = -1;
    for (UIView *view in subArr) {
        if ([view isKindOfClass:[WPRecruitiew class]]) {
            ++i;
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
            
            NSString * keyStr = [NSString stringWithFormat:@"guid%d",i];
            NSString * valueStr = [NSString stringWithFormat:@"%d_%@",i,[NSString stringWithFormat:@"%@-%@",kShareModel.userId,uniueString]];
            
            NSString * guid_0 = [NSString stringWithFormat:@"%d-%@-%@",i+1,kShareModel.userId,uniueString];
            
            NSDictionary *dic =@{@"job_id":_job_id,
                                 @"jobPositon":editModel.jobPositon,
                                 @"jobPositonID":editModel.jobPositonID,
                                 @"salary":editModel.salary,
                                 @"epRange":editModel.epRange,
                                 @"workTime":editModel.workTime,
                                 @"education":editModel.education,
                                 @"sex":editModel.sex,
                                 @"age":editModel.age,
                                 @"invitenumbe":editModel.invitenumbe,
                                 @"workAddressID":editModel.workAddressID,
                                 @"workAddress":editModel.workAddress,
                                 @"workAdS":editModel.workAdS,
                                 @"Tel":editModel.Tel,
                                 @"TelIsShow":showedTelephone?@"0":@"1",
                                 @"longitude":@"",//TODO:精度
                                 @"latitude":@"",//TODO:纬度
                                 @"Require":(editModel.requstString.length && (![editModel.requstString isEqualToString:@"(null)"]))?editModel.requstString:@"",
                                 keyStr:valueStr,
                                 @"guid_0":guid_0
                                 };
            [jobs addObject:dic];
        }
    }
    
    NSMutableArray *briefList = [[NSMutableArray alloc]init];
    NSDictionary * dci = @{@"txt":self.model.enterpriseBrief};
    [briefList addObject:dci];
    //        WPInterviewEducationModel *model = self.educationListArray[i];
    //    for (int i = 0; i < self.briefArray.count; i++) {
    //        if ([self.briefArray[i] isKindOfClass:[NSAttributedString class]]) {//文字
    //            NSString *text = [NSString stringWithFormat:@"%@",self.briefArray[i]];
    //            NSArray *arr = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
    //            NSMutableArray *attStr = [NSMutableArray array];
    //            NSInteger index = (arr.count - 1)/2;
    //            for (int j = 0 ; j<index; j++) {
    //                NSString *detail = arr[2*j];
    //                NSString *attribute = arr[2*j+1];
    //                NSDictionary *attibuteTex = @{@"detail" : detail,
    //                                              @"attribute" : attribute};
    //                [attStr addObject:attibuteTex];
    //            }
    //            //            NSLog(@"#####%@",attStr);
    //            NSDictionary *textDic = @{@"txt": attStr};
    //            [briefList addObject:textDic];
    //        } else { //图片
    //
    //            WPFormData *formData = [[WPFormData alloc]init];
    //            if ([self.briefArray[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
    //                MLSelectPhotoAssets *asset = self.briefArray[i];
    //                UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
    //                formData.data = UIImageJPEGRepresentation(img, 0.5);
    //            }else{
    //                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.briefArray[i]]];
    //                formData.data = [NSData dataWithContentsOfURL:url];
    //            }
    //            formData.name = [NSString stringWithFormat:@"img%d",i];
    //            formData.filename = [NSString stringWithFormat:@"img%d.jpg",i];
    //            formData.mimeType = @"application/octet-stream";
    //            [dataArr addObject:formData];//把数据流加入上传文件数组
    //            NSString *value = [NSString stringWithFormat:@"img%d",i];
    //            NSDictionary *photoDic = @{@"txt":value};
    //            [briefList addObject:photoDic];
    //        }
    //    }
    
    NSString * str = [self superview:self.verOneScrollView industry:WPRecruitControllerActionTypeCompanyArea];
    NSLog(@"%@",str);
    //    if (_isFirst) {
    NSDictionary *jsonDic = @{@"ep_id":_epId,
                              @"enterprise_name":(_isFirst?[self superview:self.verOneScrollView title:WPRecruitControllerActionTypeCompanyName]:self.model.enterpriseName),
                              
                              @"dataIndustry":(_isFirst?[self superview:self.verOneScrollView title:WPRecruitControllerActionTypeCompanyIndustry]:self.model.dataIndustry),
                              @"dataIndustry_id":(_isFirst?[self superview:self.verOneScrollView industry:WPRecruitControllerActionTypeCompanyIndustry]:self.model.dataIndustryId),
                              @"enterprise_properties":(_isFirst?[self superview:self.verOneScrollView title:WPRecruitControllerActionTypeCompanyProperty]:self.model.enterpriseProperties),
                              @"enterprise_scale":(_isFirst?[self superview:self.verOneScrollView title:WPRecruitControllerActionTypeCompanyScale]:self.model.enterpriseScale),
                              @"enterprise_brief":[(SPTextView *)[self.verOneScrollView viewWithTag:WPRecruitControllerActionTypeCompanyBrief] title],
                              
                              
                              @"enterprise_addressID":(_isFirst?[self superview:self.verOneScrollView industry:WPRecruitControllerActionTypeCompanyArea]:self.model.enterpriseAddressID),
                              @"enterprise_address":(_isFirst?[self superview:self.verOneScrollView industry:WPRecruitControllerActionTypeCompanyArea]:self.model.enterpriseAddress),
                              
                              
                              //企业具体地址
                              @"enterprise_ads":(_isFirst?[self superview:self.verOneScrollView title:WPRecruitControllerActionTypeCompanyDetailArea]:self.model.enterpriseDewtailAddress),
                              @"enterprise_personName":(_isFirst?[self superview:self.verOneScrollView title:WPRecruitControllerActionTypePersonalName]:self.model.enterprisePersonName),
                              @"enterprise_website":(_isFirst?[self superview:self.verOneScrollView title:WPRecruitControllerActionTypeCompanyPhone]:self.model.enterpriseWebsite),
                              @"enterprise_brief":self.model.enterpriseBrief,//企业简介(留着 传空就可以了)
                                                               // @"enterprise_phone":(_isFirst?[self superview:self.moreConditionView title:10]:self.model.enterprisePhone),
                              //                                  @"enterprise_qq":(_isFirst?[self superview:self.moreConditionView title:11]:self.model.enterpriseQq),
                              //                                  @"enterprise_email":(_isFirst?[self superview:self.moreConditionView title:12]:self.model.enterpriseEmail),
                              //                                  @"enterprise_webchat":(_isFirst?[self superview:self.moreConditionView title:13]:self.model.enterpriseWebchat),
                              //                                  @"enterprise_website":(_isFirst?[self superview:self.moreConditionView title:14]:self.model.enterpriseWebsite),
                              @"JobList":jobs,
                              @"epRemarkList":briefList
                              };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
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
        dataArr = nil;
    }
    
    NSString * isShow = [NSString new];
    self.is_Look.length?(isShow = @"4"):(self.not_look.length?(isShow = @"5"):(isShow = self.is_anoymous));
    WPShareModel *model = [WPShareModel sharedModel];
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/invitejob.ashx"];
    NSDictionary *params = @{@"action":@"JobInsert",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.userId,
                             @"PhotoCount":PhotoNum,
                             @"FileCount":fileCount,
                             @"isModify":(updateImage)?@"0":@"1",//(updateImage)?@"0":@"1"
                             @"status":([isDraft isKindOfClass:[NSString class]]?@"1":@"0"),
                             @"JobJsonList":jsonString,
                             (_isComeFromCompany&&[isDraft isKindOfClass:[NSString class]]?@"type":@""):(_isComeFromCompany&&[isDraft isKindOfClass:[NSString class]]?@"1":@""),
                             @"guid":uniueString,
                             @"is_show":isShow,
                             @"is_look":self.is_Look.length?self.is_Look:self.not_look
                             };
    if (![isDraft isKindOfClass:[NSString class]]) {//保存草稿时不需要保存在本地
        NSDictionary * dic = [[WPUploadShuoShuo instance] uploadMyWant:params modelList:nil photo:self.photosArr video:self.videosArr];
        [self saveMyApply:params json:dic and:uniueString];
        NSArray * jsonArray = dic[@"json"];
        if (self.uploadMyWant) {
            self.uploadMyWant(jsonArray);
        }
    }
    //    NSDictionary * dic = [[WPUploadShuoShuo instance] uploadMyWant:params modelList:nil photo:self.photosArr video:self.videosArr];
    //    [self saveMyApply:params json:dic and:uniueString];
    //    NSArray * jsonArray = dic[@"json"];
    //
    //    if (self.uploadMyWant) {
    //        self.uploadMyWant(jsonArray);
    //    }
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [WPHttpTool postWithURL:url params:params formDataArray:[NSArray arrayWithArray:dataArr] success:^(id json) {
            if ([json[@"status"] isEqualToString:@"0"]) {
                //发布成功时本地移除
                if (![isDraft isKindOfClass:[NSString class]]) {
                    [self deleteMyApply:[NSString stringWithFormat:@"%@-%@",kShareModel.userId,uniueString]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMIANSHIDATA" object:nil];
                }
                //                [self deleteMyApply:[NSString stringWithFormat:@"%@-%@",kShareModel.userId,uniueString]];
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMIANSHIDATA" object:nil];
                
            }else{
            }
        } failure:^(NSError *error) {
        }];
    });
    
    //    [WPHttpTool postWithURL:url params:params formDataArray:[NSArray arrayWithArray:dataArr] success:^(id json) {
    //        [MBProgressHUD hideHUDForView:self.view animated:YES];
    //        if ([json[@"status"] isEqualToString:@"0"]) {
    //            senderBtn.userInteractionEnabled = YES;
    //            [MBProgressHUD showSuccess:@"发布成功" toView:self.view];
    //            [self performSelector:@selector(delay) withObject:nil afterDelay:1];
    //        }else{
    //            [MBProgressHUD showError:json[@"info"] toView:self.view];
    //            senderBtn.userInteractionEnabled = YES;
    //        }
    //    } failure:^(NSError *error) {
    //        senderBtn.userInteractionEnabled = YES;
    //        [MBProgressHUD hideHUDForView:self.view animated:YES];
    //        NSLog(@"%@",error.localizedDescription);
    //    }];
}
-(void)deleteMyApply:(NSString*)guid
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [defaults objectForKey:@"UPLOAdMYWANT"];
    NSMutableArray *muarray = [NSMutableArray array];
    [muarray addObjectsFromArray:array];
    for (NSDictionary * dic in array) {
        if (dic[guid])
        {
            NSArray * array = dic[guid];
            NSDictionary * diction = array[1];
            NSArray * dataArray = diction[@"data"];
            for (NSDictionary * dictionary  in dataArray) {
                NSString *media_address = dictionary[@"media_address"];
                [[NSFileManager defaultManager] removeItemAtPath:media_address error:nil];
            }
            [muarray removeObject:dic];
        }
    }
    array = [NSArray arrayWithArray:muarray];
    [defaults setObject:array forKey:@"UPLOAdMYWANT"];
    
}
-(void)saveMyApply:(NSDictionary*)params json:(NSDictionary*)upDic and:(NSString*)string
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [defaults objectForKey:@"UPLOAdMYWANT"];
    NSMutableArray * muarrau = [NSMutableArray array];
    [muarrau addObjectsFromArray:array];
    NSDictionary * saveDic = @{[NSString stringWithFormat:@"%@-%@",kShareModel.userId,string]:@[params,upDic]};
    [muarrau addObject:saveDic];
    array = [NSArray arrayWithArray:muarrau];
    [defaults setObject:array forKey:@"UPLOAdMYWANT"];
}


- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}
- (void)delay{
    if (self.delegate) {
        [self.delegate WPRecuilistControllerDelegate];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMIANSHIDATA" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
        case WPRecruitControllerActionTypeCompanyIndustry:
            self.selectView.isIndustry = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getIndustry",@"fatherid":@"0"}];
            break;
        case WPRecruitControllerActionTypeCompanyProperty:
            [self.selectView setLocalData:[SPLocalApplyArray natureArray]];
            break;
        case WPRecruitControllerActionTypeCompanyScale:
            [self.selectView setLocalData:[SPLocalApplyArray scaleArray]];
            break;
        case WPRecruitControllerActionTypeCompanyArea:
            self.selectView.isIndustry = NO;
            self.selectView.isArea = YES;
            self.selectView.threeStage = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
        case WPRecruitControllerActionTypeCompanyBrief:
            [self pushToCompanyBrief];
            break;
        default:
            break;
    }
}
#pragma mark 点击企业描述跳到下个界面
- (void)pushToCompanyBrief{
    //    WPCompanyBriefController *brief = [[WPCompanyBriefController alloc]init];
    //    brief.delegate = self;
    //    [brief.objects addObjectsFromArray:self.briefArray];
    //    [self.navigationController pushViewController:brief animated:YES];
    ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
    //    editing.title = @"任职要求";
    __weak typeof(self) weakSelf = self;
    //    editing.attributedString = [NSString stringWithString:self.briefString];
    editing.textFieldString = self.briefString;
    editing.title = @"企业描述";
    editing.verifyClickBlock = ^(NSAttributedString *attributedString){
        //        weakSelf.recruitView.model.requireString = attributedString;
        self.briefString = attributedString;
        if (self.briefString.length) {
            SPItemView *item = (SPItemView *)[weakSelf.headView viewWithTag:WPRecruitControllerActionTypeCompanyBrief];
            [item resetTitle:@"企业描述已填写"];
            self.model.enterpriseBrief = self.briefString;
        }
        else
        {
            SPItemView *item = (SPItemView *)[weakSelf.headView viewWithTag:WPRecruitControllerActionTypeCompanyBrief];
            [item resetTitle:@""];
            self.model.enterpriseBrief = self.briefString;
        }
    };
    [weakSelf.navigationController pushViewController:editing animated:YES];
}

#pragma mark - 公司简介代理
- (void)getCompanyBrief:(NSArray *)briefArray{
    self.briefArray = briefArray;
    SPItemView *item = (SPItemView *)[self.view viewWithTag:WPRecruitControllerActionTypeCompanyBrief];
    [item resetTitle:@"企业描述已填写"];
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

#pragma mark - 选择照片或视频ActionSheet
-(void)recuilistTagClick:(UIButton *)sender
{
    
    [self.view endEditing:YES];
    
    if (sender.tag == WPRecruitControllerActionTypeAddPhoto) {
        //        WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机",@"视频"] imageNames:nil top:64];
        //        actionSheet.tag = TagPhotoSheet;
        //        [actionSheet showInView:self.view];
        
        //底部弹出框
        HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册", @"拍照", nil];// @"视频",
        sheet.tag = TagPhotoSheet;
        // 2.显示出来
        [sheet show];
        
        
    }
    if (sender.tag == WPRecruitControllerActionTypePhotoviewPage) {
        [self checkAllPhotos];
    }
    if (sender.tag == WPRecruitControllerActionTypeCompanyLogo) {
        
        //        WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机"] imageNames:nil top:64];
        //        actionSheet.tag = TagBackSheet;
        //        [actionSheet showInView:self.view];
        
        HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册", @"相机", nil];
        sheet.tag = TagBackSheet;
        // 2.显示出来
        [sheet show];
        
    }
}


- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == TagPhotoSheet) {
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
    
    if (actionSheet.tag == TagBackSheet) {
        _number = TagBackSheet;
        if (buttonIndex == 1) {
            [self fromCameraSingle:1];
        }
        if (buttonIndex == 2) {
            [self fromCameraSingle:2];
        }
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
        UIButton *button = (UIButton *)[self.view viewWithTag:WPRecruitControllerActionTypeCompanyLogo];
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
    
    
    if (self.photosArr.count == 8) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多上传8张图片" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        //        [@"您的设备不支持拍照" alertInViewController:self];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    //    UIImagePickerControllerEditedImage *image = UIImagePickerControllerEditedImage;
    //picker.delegate = self;
    //    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    picker.bk_didCancelBlock = ^(UIImagePickerController *picker){
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    picker.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
        SPPhotoAsset *asset = [[SPPhotoAsset alloc]init];
        asset.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.photosArr addObject:asset];
        _imageChanged = YES;
        [self updatePhotosView];
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)fromAlbums {
    
    if (self.photosArr.count == 8) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多上传8张图片" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 8 - self.photosArr.count;
    //        [pickerVc show];
    [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
    pickerVc.callBack = ^(NSArray *assets){
        [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        for (MLSelectPhotoAssets *asset in assets) {
            SPPhotoAsset *spAsset = [[SPPhotoAsset alloc]init];
            spAsset.asset = asset.asset;
            [photos addObject:spAsset];
        }
        [self.photosArr addObjectsFromArray:photos];
        _imageChanged = YES;
        [self updatePhotosView];
    };
}

#pragma mark - VideoSelected
-(void)videoFromCamera
{
    if (self.videosArr.count == 4)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最多上传4个视频" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
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
    [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
}

//从录制界面选择Video返回
-(void)sendBackVideoWith:(NSArray *)array
{
    [self.videosArr addObjectsFromArray:array];
    _imageChanged = YES;
    [self updatePhotosView];
}
//录制返回
-(void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
    [self.videosArr addObject:filePaht];
    _imageChanged = YES;
    [self updatePhotosView];
    [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
}
//直接选择Video返回
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [self.videosArr addObjectsFromArray:assets];
    _imageChanged = YES;
    [self updatePhotosView];
    [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
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
- (void)getCompanyInfoDreaft:(WPRecruitDraftInfoModel *)model{
    NSString * string = model.enterpriseBrief;
    string = [WPMySecurities textFromBase64String:string];
    string = [WPMySecurities textFromEmojiString:string];
    model.enterpriseBrief = string;
    
    NSString * require = model.Require;
    require = [WPMySecurities textFromBase64String:require];
    require = [WPMySecurities textFromEmojiString:require];
    model.Require = require;
    
    self.choiseCompanyId = @"";
    self.choiseDraftId = [NSString stringWithFormat:@"%@",model.jobId];
    
    _draftmoldel = model;//草稿的数据在返回时判断是否改变
    _isComeFromDraft = YES;
    _isComeFromCompany = NO;
    
    _imageViewt.hidden = YES;
    _backLabel.hidden = YES;
    _epId = model.epId;
    _job_id = model.jobId;
    self.chooseComapnyView.company = @"";
    
    self.model.enterprisePhone = model.Tel;
    self.model.enterpriseName = model.enterpriseName;
    self.model.dataIndustry = model.dataIndustry;
    self.model.dataIndustryId = model.dataIndustryId;
    self.model.enterpriseProperties = model.enterpriseProperties;
    self.model.enterpriseScale = model.enterpriseScale;
    self.model.enterpriseAddress = model.enterpriseAddress;
    self.model.enterpriseDewtailAddress = model.enterpriseDewtailAddress;
    self.model.enterpriseAddressID = model.enterpriseAddressID;
    self.model.enterprisePersonName = model.enterprisePersonName;
    self.model.enterpriseBrief = model.enterpriseBrief;
    self.model.enterprisePhone = model.enterprisePhone;
    self.model.enterpriseWebsite = model.enterpriseWebsite;
    self.model.videoList = model.videoList;
    
    //刷新照片和视频
    [self.photosArr removeAllObjects];
    [self.videosArr removeAllObjects];
    [self.photosArr addObjectsFromArray:model.photoList];
    [self.videosArr addObjectsFromArray:model.videoList];
    [self updatePhotosView];
    
    //第一部分
    NSArray *title = @[model.enterpriseName.length?model.enterpriseName:@"",model.dataIndustry.length?model.dataIndustry:@"",model.enterpriseProperties.length?model.enterpriseProperties:@"",model.enterpriseScale.length?model.enterpriseScale:@"",model.enterpriseAddress.length?model.enterpriseAddress:@"",model.enterpriseDewtailAddress.length?model.enterpriseDewtailAddress:@"",model.enterprisePersonName.length?model.enterprisePersonName:@"",model.enterpriseWebsite.length?model.enterpriseWebsite:@""];
    for (int i = WPRecruitControllerActionTypeCompanyName; i <= WPRecruitControllerActionTypeCompanyPhone; i++) {
        
        SPItemView *view = (SPItemView *)[self.verOneScrollView viewWithTag:i];
        
        [view resetTitle:title[i-WPRecruitControllerActionTypeCompanyName]];
    }
    
    
    SPItemView *textView = (SPItemView *)[self.verOneScrollView viewWithTag:WPRecruitControllerActionTypeCompanyBrief];
    if (model.enterpriseBrief.length) {
        [textView resetTitle:@"企业描述已填写"];
        self.briefString = model.enterpriseBrief;
    }
    
    //第二部分
    NSArray *recruitTitle = @[model.jobPositon.length?model.jobPositon:@"",model.salary.length?model.salary:@"",model.epRange.length?model.epRange:@"",model.workTime.length?model.workTime:@"",model.education.length?model.education:@"",model.sex.length?model.sex:@"",model.age.length?model.age:@"",(model.invitenumbe.length && ![model.invitenumbe isEqualToString:@"0"])?model.invitenumbe:@"",model.workAddress.length?model.workAddress:@"",model.workAdS.length?model.workAdS:@"",model.Tel?model.Tel:@"",model.TelIsShow.length?model.TelIsShow:@"1",model.Require.length?model.Require:@""];
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
    
    
    
    //跳转到未填写的界面
    if (![self canHeadViewCommit]) {//判断必填项是否为空
        if (isPhotoExit || isCompany) {
            CGPoint point = CGPointMake(0, 0);
            [_verOneScrollView setContentOffset:point animated:YES];
            isPhotoExit = NO;
            isCompany = NO;
        }
        else if (isZhaopoin)
        {
            CGPoint point = CGPointMake(0, self.headView.bottom+kListEdge-kHEIGHT(43));
            [_verOneScrollView setContentOffset:point animated:YES];
            isZhaopoin = NO;
        }
        else if (isAddFirst)
        {
            CGPoint point = CGPointMake(0, self.recruitView.bottom+kListEdge);
            [_verOneScrollView setContentOffset:point animated:YES];
            isAddFirst = NO;
        }
        else if (isAddSecond)
        {
            CGPoint point = CGPointMake(0, self.recruitView.bottom+kListEdge+self.recruitView.height);
            [_verOneScrollView setContentOffset:point animated:YES];
            isAddSecond = NO;
        }
    }
}
-(WPCompanyListModel*)companyModel
{
    if (!_companyModel) {
        _companyModel = [[WPCompanyListModel alloc]init];
    }
    return _companyModel;
}
#pragma mark - 选择企业后回调代理函数
- (void)getCompanyInfo:(WPCompanyListModel *)model
{
    self.companyModel = model;
    self.companyModel.epId = model.epId.length?model.epId:@"";
    self.companyModel.userId = model.userId.length?model.userId:@"";
    self.companyModel.enterpriseName = model.enterpriseName.length?model.enterpriseName:@"";
    self.companyModel.dataIndustry = model.dataIndustry.length?model.dataIndustry:@"";
    self.companyModel.dataIndustryId = model.dataIndustryId.length?model.dataIndustryId:@"";
    self.companyModel.enterpriseProperties = model.enterpriseProperties.length?model.enterpriseProperties:@"";
    self.companyModel.enterpriseScale = model.enterpriseScale.length?model.enterpriseScale:@"";
    self.companyModel.enterpriseAddressID = model.enterpriseAddressID.length?model.enterpriseAddressID:@"";
    self.companyModel.enterpriseAddress = model.enterpriseAddress.length?model.enterpriseAddress:@"";
    self.companyModel.enterpriseDewtailAddress = model.enterpriseDewtailAddress.length?model.enterpriseDewtailAddress:@"";
    self.companyModel.enterpriseAds = model.enterpriseAds.length?model.enterpriseAds:@"";
    self.companyModel.enterprisePersonName = model.enterprisePersonName.length?model.enterprisePersonName:@"";
    self.companyModel.enterprisePersonTel = model.enterprisePersonTel.length?model.enterprisePersonTel:@"";
    self.companyModel.enterpriseBrief = model.enterpriseBrief.length?model.enterpriseBrief:@"";
    self.companyModel.enterprisePersonTel = model.enterprisePersonTel.length?model.enterprisePersonTel:@"";
    self.companyModel.enterprisePhone = model.enterprisePhone.length?model.enterprisePhone:@"";
    self.companyModel.enterpriseEmail = model.enterpriseEmail.length?model.enterpriseEmail:@"";
    self.companyModel.enterpriseWebsite = model.enterpriseWebsite.length?model.enterpriseWebsite:@"";
    self.companyModel.enterpriseAddressID = model.enterpriseAddressID.length?model.enterpriseAddressID:@"";
    self.companyModel.jobPositon = model.jobPositon.length?model.jobPositon:@"";
    self.companyModel.salary = model.salary.length?model.salary:@"";
    self.companyModel.epRange = model.epRange.length?model.epRange:@"";
    self.companyModel.workTime = model.workTime.length?model.workTime:@"";
    self.companyModel.education = model.education.length?model.education:@"";
    self.companyModel.sex = model.sex.length?model.sex:@"";
    self.companyModel.age = model.age.length?model.age:@"";
    self.companyModel.invitenumbe = model.invitenumbe.length?model.invitenumbe:@"";
    self.companyModel.workAdS = model.workAdS.length?model.workAdS:@"";
    self.companyModel.workAddress = model.workAddress.length?model.workAddress:@"";
    self.companyModel.Require = model.Require.length?model.Require:@"";
    
    self.companyModel.photoList = model.photoList;
    self.companyModel.videoList = model.videoList;
    self.companyModel.epRemarkList = model.epRemarkList;
    
    
    NSString * string = model.enterpriseBrief;
    string = [WPMySecurities textFromBase64String:string];
    string = [WPMySecurities textFromEmojiString:string];
    model.enterpriseBrief = string;
    
    NSString * require = model.Require;
    require = [WPMySecurities textFromBase64String:require];
    require = [WPMySecurities textFromEmojiString:require];
    model.Require = require;
    
    _choiseCompanyId = [NSString stringWithFormat:@"%@",model.epId];
    self.choiseDraftId = @"";
    
    _isComeFromDraft = NO;
    _isComeFromCompany = YES;
    
    _imageViewt.hidden = YES;
    _backLabel.hidden = YES;
    _epId = model.epId;
    self.model = model;
    self.chooseComapnyView.company = model.enterpriseName;
    
    //    UIButton *button = (UIButton *)[self.verOneScrollView viewWithTag:WPRecruitControllerActionTypeCompanyLogo];
    //    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.QRCode]];
    //    [button sd_setImageWithURL:url forState:UIControlStateNormal];
    
    //刷新照片和视频
    [self.photosArr removeAllObjects];
    [self.videosArr removeAllObjects];
    [self.photosArr addObjectsFromArray:model.photoList];
    [self.videosArr addObjectsFromArray:model.videoList];
    [self updatePhotosView];
    
    NSArray *title = @[model.enterpriseName.length?model.enterpriseName:@"",model.dataIndustry.length?model.dataIndustry:@"",model.enterpriseProperties.length?model.enterpriseProperties:@"",model.enterpriseScale.length?model.enterpriseScale:@"",model.enterpriseAddress.length?model.enterpriseAddress:@"",model.enterpriseDewtailAddress.length?model.enterpriseDewtailAddress:@"",model.enterprisePersonName.length?model.enterprisePersonName:@"",model.enterpriseWebsite.length?model.enterpriseWebsite:@""];
    for (int i = WPRecruitControllerActionTypeCompanyName; i <= WPRecruitControllerActionTypeCompanyPhone; i++) {
        SPItemView *view = (SPItemView *)[self.verOneScrollView viewWithTag:i];
        [view resetTitle:title[i-WPRecruitControllerActionTypeCompanyName]];
    }
    
    SPItemView *textView = (SPItemView *)[self.verOneScrollView viewWithTag:WPRecruitControllerActionTypeCompanyBrief];
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
            if (str.length) {
                [arr addObject:str];
            }
            //            [arr addObject:str];
        }else{
            if (remarkModel.txtcontent.length) {
                [arr addObject:remarkModel.txtcontent];
            }
            //            [arr addObject:remarkModel.txtcontent];
        }
    }
    self.briefArray = arr;
    
    //跳到未填写的界面
    if (![self canHeadViewCommit]) {//判断必填项是否为空
        if (isPhotoExit || isCompany) {
            CGPoint point = CGPointMake(0, 0);
            [_verOneScrollView setContentOffset:point animated:YES];
            isPhotoExit = NO;
            isCompany = NO;
        }
        else if (isZhaopoin)
        {
            CGPoint point = CGPointMake(0, self.headView.bottom+kListEdge-2*kHEIGHT(43));
            [_verOneScrollView setContentOffset:point animated:YES];
            isZhaopoin = NO;
        }
        else if (isAddFirst)
        {
            CGPoint point = CGPointMake(0, self.recruitView.bottom+kListEdge);
            [_verOneScrollView setContentOffset:point animated:YES];
            isAddFirst = NO;
        }
        else if (isAddSecond)
        {
            CGPoint point = CGPointMake(0, self.recruitView.bottom+kListEdge+self.recruitView.height);
            [_verOneScrollView setContentOffset:point animated:YES];
            isAddSecond = NO;
        }
    }
}

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
    
    if (![self.model.enterpriseName isEqualToString:@""]) {
        return YES;
    }
    if (![self.model.dataIndustry isEqualToString:@""]) {
        return YES;
    }
    if (![self.model.enterpriseProperties isEqualToString:@""]) {
        return YES;
    }
    if (![self.model.enterpriseScale isEqualToString:@""]) {
        return YES;
    }
    if (![self.model.enterpriseAddress isEqualToString:@""]) {
        return YES;
    }
    if (![self.model.enterprisePersonName isEqualToString:@""]) {
        return YES;
    }
    if (![self.model.enterprisePersonTel isEqualToString:@""]) {
        return YES;
    }
    if (![self.model.enterpriseBrief isEqualToString:@""]) {
        return YES;
    }
    if (![self.model.enterpriseQq isEqualToString:@""]) {
        return YES;
    }
    if (![self.model.enterprisePhone isEqualToString:@""]) {
        return YES;
    }
    if (![self.model.enterpriseWebchat isEqualToString:@""]) {
        return YES;
    }
    if (![self.model.enterpriseWebsite isEqualToString:@""]) {
        return YES;
    }
    if (![self.model.enterpriseEmail isEqualToString:@""]) {
        return YES;
    }
    
    for (UIView *view in self.verOneScrollView.subviews) {
        
        if ([view isKindOfClass:[WPRecruitiew class]]) {
            WPRecruitiew *subview = (WPRecruitiew *)view;
            
            if (![subview.model.jobPositon isEqualToString:@""]) {
                return YES;
            }
            if (![subview.model.jobIndustry isEqualToString:@""]) {
                return YES;
            }
            if (![subview.model.jobPositon isEqualToString:@""]) {
                return YES;
            }
            if (![subview.model.salary isEqualToString:@""]) {
                return YES;
            }
            if (![subview.model.epRange isEqualToString:@""]) {
                return YES;
            }
            if (![subview.model.workTime isEqualToString:@""]) {
                return YES;
            }
            if (![subview.model.education isEqualToString:@""]) {
                return YES;
            }
            if (![subview.model.sex isEqualToString:@""]) {
                return YES;
            }
            if (![subview.model.age isEqualToString:@""]) {
                return YES;
            }
            if (![subview.model.invitenumbe isEqualToString:@""]) {
                return YES;
            }
            if (![subview.model.workAddress isEqualToString:@""]) {
                return YES;
            }
            if (![subview.model.industry isEqualToString:@""]) {
                return YES;
            }
            if (![subview.model.apply_Condition isEqualToString:@""]) {
                return YES;
            }
            if (![subview.model.Require isEqualToString:@""]) {
                return YES;
            }
            if (subview.model.requireString) {
                return YES;
            }
        }
    }
    
    if (self.briefArray.count) {
        return YES;
    }
    
    if (self.photosArr.count || self.videosArr.count) {
        return YES;
    }
    return NO;
}


@end
