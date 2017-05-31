//
//  WPCompanyEditController.m
//  WP
//
//  Created by CBCCBC on 15/10/9.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPCompanyEditController.h"

#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "DBTakeVideoVC.h"
#import "CTAssetsPickerController.h"
#import "SAYPhotoManagerViewController.h"
#import "SAYVideoManagerViewController.h"
#import "WPCompanyController.h"
#import "WPCompanyBriefController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <BlocksKit+UIKit.h>
#import "WPImageModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "MLPhotoBrowserViewController.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "SPPhotoBrowser.h"
#import "SPPhotoAsset.h"

#import "SPActionSheet.h"
#import "WPActionSheet.h"

#import "SPItemView.h"
#import "SPTextView.h"
#import "SPSelectView.h"
#import "WPCompanyPreview.h"

#import "WPCompanyInfoView.h"

#import "WPCompanyManager.h"
#import "HJCActionSheet.h"
#import "ActivityTextEditingController.h"
typedef NS_ENUM(NSInteger, WPCompanyEditActionType) {
    WPCompanyEditActionTypeCompanyName = 20,
    WPCompanyEditActionTypeIndustry ,
    WPCompanyEditActionTypeNature ,
    WPCompanyEditActionTypeScale ,
    WPCompanyEditActionTypeArea ,
    WPCompanyEditActionTypeDetailArea,
//    WPCompanyEditActionTypePhone = 26,
//    WPCompanyEditActionTypeQQ = 27,
//    WPCompanyEditActionTypeWeChat = 28,
//    WPCompanyEditActionTypeWebsite = 29,
//    WPCompanyEditActionTypeEmail = 30,
    WPCompanyEditActionTypePersonalName ,
    WPCompanyEditActionTypeWebsite,
//    WPCompanyEditActionTypePersonalTel = 32,
    WPCompanyEditActionTypeCompanyInfo ,
};


@interface WPCompanyEditController ()
<SPSelectViewDelegate,WPActionSheet,
SPActionSheetDelegate,callBackVideo,
takeVideoBack,CTAssetsPickerControllerDelegate,
UpdateImageDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
SPPhotoBrowserDelegate,WPCompanyBriefDelegate,
WPCompanyManagerDelegate,
HJCActionSheetDelegate
>

@property (strong, nonatomic) UIScrollView *verOneScrollView;
@property (strong, nonatomic) UIView *headView;

@property (strong, nonatomic) SPSelectView *selectView;
@property (assign, nonatomic) NSInteger selectNum;
@property (assign, nonatomic) NSInteger number;

@property (strong, nonatomic) UIScrollView *photosView;
@property (strong, nonatomic) UIScrollView *videosView;

@property (strong, nonatomic) NSMutableArray *photosArr;
@property (strong, nonatomic) NSMutableArray *videosArr;
@property (nonatomic, strong) NSMutableArray *logoArr;

@property (nonatomic, strong) NSArray *briefArray;/**< 公司简介数组 */

@property (nonatomic ,strong)UIButton *updateBtn;
@property (strong, nonatomic) UIButton *addPhotoBtn;
@property (strong, nonatomic) UIButton *addVideoBtn;

@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayerVC;

@property (nonatomic, assign) BOOL isUpdate;
@property (nonatomic, copy) NSString * companyBrief;//企业简介
@property (nonatomic, strong)WPCompanyInfoView *companyInfoView;
@property (nonatomic, strong)CommonTipView*rightView;
@property (nonatomic, strong)NSMutableArray*viewArr;

@end

#define TagAddPhoto 53
#define TagShowAllPhotos 54
#define TagAddVideo 55
#define TagShowAllVideos 56
#define TagAddLogo 57
#define TagBack 58
#define TagPhotoSheet 59
#define TagVideoSheet 60
#define TagLogoSheet 61
#define TagBackSheet 62

#define PhotoTag 60
#define VideoTag 65

//#define PHOTOHEIGHT (SCREEN_WIDTH-30-6*3-10)/4
//#define PHOTOVIEWHEIGHT PHOTOHEIGHT+20
//#define ItemViewHeight 48

@implementation WPCompanyEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:nil];
    [self.view addGestureRecognizer:pan];
    
    
    // Do any additional setup after loading the view.
    if (_isCompany==100) {
         self.title = @"编辑企业信息";
    } else {
         self.title = @"创建企业信息";
    }
   
    
    _number = 0;
    
    _isUpdate = NO;
    
    [self setNavbarItem];
    [self.view addSubview:self.verOneScrollView];
    
}
-(NSMutableArray*)viewArr
{
    if (!_viewArr) {
        _viewArr = [[NSMutableArray alloc]init];
    }
    return _viewArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)briefArray{
    if (!_briefArray) {
        _briefArray = [[NSArray alloc]init];
    }
    return _briefArray;
}

//- (void)showPreview{
//    WPCompanyPreview *preview = [[WPCompanyPreview alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
//    preview.briefArray = self.briefArray;
//    UIButton *button = (UIButton *)[self.view viewWithTag:TagBack];
//#pragma mark -- 被注释掉的bug a1(存在问题,button的image为空对象 相关页面:WPCompanyPreview)
////    preview.logoArray = @[button.imageView.image];
//
//    self.listModel?:[self initWithListModel];
//    preview.model = self.listModel;
//
//    [self.view addSubview:preview];
//}

- (void)initWithListModel{
    
    WPCompanyListModel *model = [[WPCompanyListModel alloc]init];
    
    model.itemIsSelected = NO;
    model.epId = @"";
    model.userId = @"";
    model.QRCode = @"";
    model.enterpriseName = @"";
    model.dataIndustry = @"";
    model.dataIndustryId = @"";
    model.enterpriseProperties = @"";
    model.enterpriseScale = @"";
    model.enterpriseAddressID = @"";
    model.enterpriseAddress = @"";
    model.enterpriseAds = @"";
    model.enterprisePersonName = @"";
    model.enterprisePersonTel = @"";
    model.enterpriseBrief = @"";
    model.enterprisePhone = @"";
    model.enterpriseQq = @"";
    model.enterpriseEmail = @"";
    model.enterpriseWebchat = @"";
    model.enterpriseWebsite = @"";
    model.photoList = [[NSArray alloc]init];
    model.videoList = [[NSArray alloc]init];
    model.epRemarkList = [[NSArray alloc]init];
    
    self.listModel = model;
}

- (void)deletePreview{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[WPCompanyPreview class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)setNavbarItem/**< 初始化导航栏 */
{
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 50, 22);
    [button1 normalTitle:@"完成" Color:RGB(0, 0, 0) Font:kFONT(14)];
    [button1 selectedTitle:@"编辑" Color:RGB(0, 0, 0)];
    //[button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    //    [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    button1.selected = _edit;
    [button1 addTarget:self action:@selector(rightButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem= rightBarItem;
}

#pragma mark 企业名称，行业性质
-(UIScrollView *)verOneScrollView
{
    if (!_verOneScrollView) {
        _verOneScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, GetHeight(SCREEN_WIDTH)+PhotoViewHeight+10+ItemViewHeight*4+170+10);
        _verOneScrollView.backgroundColor = RGB(235, 235, 235);
        
        [_verOneScrollView addSubview:self.photosView];
        //        [_verOneScrollView addSubview:self.videosView];
        
        /*
         UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         backBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, GetHeight(SCREEN_WIDTH));
         //        backBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
         //        [backBtn setImage:[UIImage imageNamed:@"defaultBG"] forState:UIControlStateNormal];
         [backBtn setImage:[UIImage imageNamed:@"back_default"] forState:UIControlStateNormal];
         [backBtn addTarget:self action:@selector(recuilistTagClick:) forControlEvents:UIControlEventTouchUpInside];
         backBtn.tag = TagBack;
         [_verOneScrollView addSubview:backBtn];
         */ // 大图 已废弃
#pragma Mark -- 企业信息
//        NSArray *titleArr = @[@"企业名称:",@"企业行业:",@"企业性质:",@"企业规模:",@"企业地点:",@"详细地址:",@"企业电话:",@"企业QQ:",@"企业微信:",@"企业官网:",@"企业邮箱:",@"联系人:",@"联系方式:",@"公司简介:"];
//        NSArray *placeHolderArr = @[@"请填写企业名称",@"请选择行业",@"请选择企业性质",@"请选择企业规模",@"请选择企业地点",@"请填写详细地址",@"请填写企业电话",@"请填写企业QQ",@"请填写企业微信",@"请填写企业官网",@"请填写企业邮箱",@"请填写联系人",@"请填写联系方式",@"请输入公司简介"];
//        NSArray *styleArr = @[kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeText,kCellTypeText,kCellTypeText,kCellTypeText,kCellTypeText,kCellTypeText,kCellTypeText,kCellTypeText,kCellTypeButton];
        
//        NSArray *titleArr = @[@"企业名称:",@"企业行业:",@"企业性质:",@"企业规模:",@"企业区域:",@"详细地址:",@"联  系 人:",@"企业官网:",@"企业简介:"];
//        NSArray *placeHolderArr = @[@"请填写企业名称",@"请选择行业",@"请选择企业性质",@"请选择企业规模",@"请选择企业地点",@"请填写详细地址",@"请填写联系人",@"请填写企业官网",@"请输入企业简介"];
        
        NSArray *titleArr = @[@"企业名称:",@"企业行业:",@"企业性质:",@"企业规模:",@"联  系 人:",@"企业官网:",@"企业简介:"];
        NSArray *placeHolderArr = @[@"请填写企业名称",@"请选择行业",@"请选择企业性质",@"请选择企业规模",@"请填写联系人",@"请填写企业官网",@"请输入企业简介"];
        
        
        
        NSArray *styleArr = @[kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeText,kCellTypeText,kCellTypeButton];
        WS( ws);
        for (int i = 0; i < titleArr.count; i++) {
            SPItemView *item = [[SPItemView alloc]initWithFrame:CGRectMake(0, i*ItemViewHeight+self.photosView.bottom+10, SCREEN_WIDTH, ItemViewHeight)];
            [item setTitle:titleArr[i] placeholder:placeHolderArr[i] style:styleArr[i]];
            if (i <=3) {
              item.tag = WPCompanyEditActionTypeCompanyName+i;
            }
            else
            {
              item.tag = WPCompanyEditActionTypeCompanyName+i+2;
            }
            
            if (item.tag == WPCompanyEditActionTypeWebsite) {
                item.textField.keyboardType=UIKeyboardTypeASCIICapable;
            }
//            ((i == WPCompanyEditActionTypePhone-WPCompanyEditActionTypeCompanyName||i ==WPCompanyEditActionTypeQQ-WPCompanyEditActionTypeCompanyName||i ==WPCompanyEditActionTypePersonalTel-WPCompanyEditActionTypeCompanyName)?(item.textField.keyboardType = UIKeyboardTypePhonePad):0);
            item.SPItemBlock = ^(NSInteger tag){
                [ws buttonItem:tag];
            };
            item.hideFromFont = ^(NSInteger tag, NSString *title){
                SPItemView *itemView = (SPItemView *)[self.view viewWithTag:tag];
                [itemView resetTitle:title];
            };
            [_verOneScrollView addSubview:item];
            [self.viewArr addObject:item];
        }
        ////公司简介
        //SPTextView *worksView = [[SPTextView alloc]initWithFrame:CGRectMake(0, ItemViewHeight*12+self.photosView.bottom+10, SCREEN_WIDTH, 170)];
        //worksView.tag = WPCompanyEditActionTypeCompanyInfo;
        //[worksView setWithTitle:@"公司简介:" placeholder:@"请填写公司简介"];
        //worksView.hideFromFont = ^(NSString *title){
        
        //};
        //[_verOneScrollView addSubview:worksView];
        CGFloat height = ItemViewHeight*9+self.photosView.bottom+10;
        _verOneScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height+8);
    }
    return _verOneScrollView;
}

-(SPSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[SPSelectView alloc]initWithTop:64];
        _selectView.delegate = self;
    }
    return _selectView;
}

- (void)buttonItem:(NSInteger)tag
{
    _selectNum = tag;
    [self.verOneScrollView endEditing:YES];
    
    switch (tag) {
        case WPCompanyEditActionTypeIndustry:
            self.selectView.isIndustry = YES;
            self.selectView.isArea = NO;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getIndustry",@"fatherid":@"0"}];
            break;
        case WPCompanyEditActionTypeNature:
            [self.selectView setLocalData:[SPLocalApplyArray natureArray]];
            break;
        case WPCompanyEditActionTypeScale:
            [self.selectView setLocalData:[SPLocalApplyArray scaleArray]];
            break;
        case WPCompanyEditActionTypeArea:
            self.selectView.isIndustry = NO;
            self.selectView.isArea = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
        case WPCompanyEditActionTypeCompanyInfo:
            [self pushToCompanyBrief];
        default:
            break;
    }
}

#pragma mark点击企业简介
- (void)pushToCompanyBrief{
    
    
    
    ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
    editing.title = @"企业简介";
    if (self.companyBrief.length) {
        editing.textFieldString = self.companyBrief;
    }
    editing.verifyClickBlock = ^(NSAttributedString *attributedString){
        self.companyBrief = attributedString;
        SPItemView * item = (SPItemView*)[self.view viewWithTag:WPCompanyEditActionTypeCompanyInfo];
        if (self.companyBrief.length)
        {
            [item resetTitle:@"企业简介已填写"];
        }
        else
        {
         [item resetTitle:@""];
        }
       
    };
    [self.navigationController pushViewController:editing animated:YES];
//    WPCompanyBriefController *brief = [[WPCompanyBriefController alloc]init];
//    brief.delegate = self;
//    [brief.objects addObjectsFromArray:self.briefArray];
//    [self.navigationController pushViewController:brief animated:YES];
}

-(void)SPSelectViewDelegate:(IndustryModel *)model
{
    SPItemView *item = (SPItemView *)[self.verOneScrollView viewWithTag:_selectNum];
    [item resetTitle:model.industryName];
    switch (_selectNum) {
        case WPCompanyEditActionTypeIndustry:
            item.industryId = model.industryID;
            break;
        case WPCompanyEditActionTypeNature:
            break;
        case WPCompanyEditActionTypeScale:
            break;
        case WPCompanyEditActionTypeArea:
            item.industryId = model.industryID;
            break;
        default:
            break;
    }
}

//退出未修改,要做判断
-(void)backToFromViewController:(UIButton *)sender{
    if (_isUpdate) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if ([self judgeIsEdit]) {
            WS(ws);
            [SPAlert alertControllerWithTitle:@"提示" message:@"确认退出编辑?" superController:self cancelButtonTitle:@"取消" cancelAction:nil defaultButtonTitle:@"确认" defaultAction:^{
                [ws.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (WPCompanyInfoView *)companyInfoView
{
    if (!_companyInfoView) {
        self.companyInfoView = [[WPCompanyInfoView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
        self.companyInfoView.model = self.listModel;
        [self.companyInfoView reloadData];
    }
    return _companyInfoView;
}

- (UIButton *)updateBtn
{
    if (!_updateBtn) {
        _updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _updateBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
        
        _updateBtn.backgroundColor = [UIColor whiteColor];
//        NSString *upload = self.setup ? @"更新":@"提交";
        [_updateBtn setTitle:@"更新" forState:UIControlStateNormal];
        [_updateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_updateBtn setBackgroundImage:[UIImage imageWithColor:RGB(226, 226, 226) size:CGSizeMake(SCREEN_WIDTH, 44)] forState:UIControlStateHighlighted];
        
        [_updateBtn addTarget:self action:@selector(updateBtnAction:) forControlEvents:UIControlEventTouchDown];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = RGB(178, 178, 178);
        [_updateBtn addSubview:lineView];
    }
    
    return _updateBtn;
}

- (void)updateBtnAction:(UIButton *)sender
{
    [self updateCompanyInfo];
}

- (BOOL)couldnotCommit
{
    BOOL commit = YES;
    if (self.photosArr.count == 0) {
//        [self.addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
        commit = NO;
        [self.photosView addSubview:self.rightView];
    }
    for (SPItemView *view in self.viewArr) {
        if ([view textFieldIsnotNil]) {
            commit = NO;
        }
    }
    return commit;
}

- (CommonTipView *)rightView
{
    if (!_rightView) {
        self.rightView = [[CommonTipView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.rightView.title = @"不能为空,至少上传一张";
        CGFloat x = SCREEN_WIDTH-8-16-8-(self.rightView.size.width/2);
        self.rightView.center = CGPointMake(x, self.photosView.size.height/2);
    }
    return _rightView;
}
#pragma mark 点击完成
-(void)rightButtonItemClick:(UIButton *)sender
{

    
    if (![self couldnotCommit]) {
        return;
    }
    
    [self updateCompanyInfo];

//    
//    sender.selected = !sender.selected;
//    if (!sender.selected) {
//        [self deletePreview];
//        [self.companyInfoView removeFromSuperview];
//        
//    }else{
//        [self.view addSubview:self.updateBtn];
//        [self.companyInfoView reloadData];
//        [self.view addSubview:self.companyInfoView];
////        [self updateCompanyInfo];
//    }
//    //    if ([[(SPItemView *)[self.view viewWithTag:20] title] isEqualToString:@""]) {
//    //        [MBProgressHUD alertView:@"" Message:@"请填写企业名称"];
//    //    }else if ([[(SPItemView *)[self.view viewWithTag:21] title] isEqualToString:@"请选择行业"]){
//    //        [MBProgressHUD alertView:@"" Message:@"请选择行业"];
//    //    }else if ([[(SPItemView *)[self.view viewWithTag:22] title] isEqualToString:@"请选择企业性质"]){
//    //        [MBProgressHUD alertView:@"" Message:@"请选择企业性质"];
//    //    }else if ([[(SPItemView *)[self.view viewWithTag:23] title] isEqualToString:@"请选择企业规模"]){
//    //        [MBProgressHUD alertView:@"" Message:@"请选择企业规模"];
//    //    }else if ([[(SPTextView *)[self.view viewWithTag:33] title] isEqualToString:@""]){
//    //        [MBProgressHUD alertView:@"" Message:@"请填写公司简介"];
//    //    }else{
//    
//    //    }
}

- (void)updateCompanyInfo{
    WPShareModel *shareModel = [WPShareModel sharedModel];
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
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
        updateImage = NO;
    }else{
        PhotoNum = @"";
        photoCount = @"";
        arr = nil;
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
    
    NSString *enterprise_name = [self itemTitle:WPCompanyEditActionTypeCompanyName]?[self itemTitle:WPCompanyEditActionTypeCompanyName]:@"";
    NSString *dataIndustry = [self itemTitle:WPCompanyEditActionTypeIndustry]?[self itemTitle:WPCompanyEditActionTypeIndustry]:@"";
    NSString *dataIndustry_id = [self itemIndustryId:WPCompanyEditActionTypeIndustry]?[self itemIndustryId:WPCompanyEditActionTypeIndustry]:@"";
    NSString *enterprise_scale = [self itemTitle:WPCompanyEditActionTypeScale]?[self itemTitle:WPCompanyEditActionTypeScale]:@"";
    NSString *enterprise_properties = [self itemTitle:WPCompanyEditActionTypeNature]?[self itemTitle:WPCompanyEditActionTypeNature]:@"";
    NSString *enterprise_addressID = [self itemIndustryId:WPCompanyEditActionTypeArea]?[self itemIndustryId:WPCompanyEditActionTypeArea]:@"";
    NSString *enterprise_address = [self itemTitle:WPCompanyEditActionTypeArea]?[self itemTitle:WPCompanyEditActionTypeArea]:@"";
    NSString *enterprise_ads = [self itemTitle:WPCompanyEditActionTypeDetailArea]?[self itemTitle:WPCompanyEditActionTypeDetailArea]:@"";
    NSString *enterprise_personName = [self itemTitle:WPCompanyEditActionTypePersonalName]?[self itemTitle:WPCompanyEditActionTypePersonalName]:@"";
//    NSString *enterprise_personTel = [self itemTitle:WPCompanyEditActionTypePhone]?[self itemTitle:WPCompanyEditActionTypePhone]:@"";
//    NSString *enterprise_phone = [self itemTitle:WPCompanyEditActionTypePhone]?[self itemTitle:WPCompanyEditActionTypePhone]:@"";
//    NSString *enterprise_qq = [self itemTitle:WPCompanyEditActionTypeQQ]?[self itemTitle:WPCompanyEditActionTypeQQ]:@"";
//    NSString *enterprise_email = [self itemTitle:WPCompanyEditActionTypeEmail]?[self itemTitle:WPCompanyEditActionTypeEmail]:@"";
//    NSString *enterprise_webchat = [self itemTitle:WPCompanyEditActionTypeWeChat]?[self itemTitle:WPCompanyEditActionTypeWeChat]:@"";
    NSString *enterprise_website = [self itemTitle:WPCompanyEditActionTypeWebsite]?[self itemTitle:WPCompanyEditActionTypeWebsite]:@"";
    
    NSDictionary *dic = @{@"ep_id":(self.listModel?_listModel.epId:@""),
                          @"enterprise_name":enterprise_name,
                          @"dataIndustry":dataIndustry,
                          @"dataIndustry_id":dataIndustry_id,
                          @"enterprise_scale":enterprise_scale,
                          @"enterprise_properties":enterprise_properties,
                          @"enterprise_addressID":enterprise_addressID,
                          @"enterprise_address":enterprise_address,
                          @"enterprise_ads":enterprise_ads,
                          @"enterprise_personName":enterprise_personName,
                          @"enterprise_personTel":@"",
                          @"enterprise_brief":@"",//弃用了，暂时不需要
                          @"enterprise_phone":@"",
                          @"enterprise_qq":@"",
                          @"enterprise_email":@"",
                          @"enterprise_webchat":@"",
                          @"enterprise_website":enterprise_website,
                          @"epRemarkList":briefList
                          };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{@"action":@"UpdateCompanyInfo",
                             @"username":shareModel.username,
                             @"password":shareModel.password,
                             @"user_id":shareModel.userId,
                             @"FileCount":PhotoNum,
                             @"PhotoCount":photoCount,
                             @"isModify":[NSString stringWithFormat:@"%d",updateImage],
                             @"status":@"0",
                             @"JsonList":jsonString
                             };
    NSLog(@"%d",updateImage);
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:strUrl params:params formDataArray:arr success:^(id json) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([json[@"status"] isEqualToString:@"0"]) {
            
            [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
            [self performSelector:@selector(delay) withObject:nil afterDelay:1];
            
        }else{
            
            [MBProgressHUD showError:json[@"info"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)delay{
    _isUpdate = YES;
    if (self.upDateSuccess) {
        self.upDateSuccess();
    }
    if (self.delegate) {
        [self.delegate RefreshCompanyInfo];
//        [self.navigationController popViewControllerAnimated:YES];
    }
     [self.navigationController popViewControllerAnimated:YES];
}

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

-(UIScrollView *)photosView
{
    if (!_photosView) {
        
        //        CGFloat height = (SCREEN_WIDTH-30-2*3)/4+16;
        _photosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, GetHeight(16), SCREEN_WIDTH-28, PhotoViewHeight)];
        _photosView.backgroundColor = [UIColor whiteColor];
        _photosView.showsHorizontalScrollIndicator = NO;
        
        _addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _addPhotoBtn.backgroundColor = RGB(204, 204, 204);
        _addPhotoBtn.frame = CGRectMake(10, 10, PhotoHeight, PhotoHeight);
        _addPhotoBtn.tag = TagAddPhoto;
        //        [_addPhotoBtn setImage:[UIImage imageNamed:@"addPhoto"] forState:UIControlStateNormal];
        [_addPhotoBtn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(102, 102, 102)] forState:UIControlStateHighlighted];
        [_addPhotoBtn addTarget:self action:@selector(recuilistTagClick:) forControlEvents:UIControlEventTouchUpInside];
        [_photosView addSubview:_addPhotoBtn];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:_addPhotoBtn.bounds];
        imageV.image = [UIImage imageNamed:@"tianjia64"];
        [_addPhotoBtn addSubview:imageV];
        
        /**< 照片墙翻页 */
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-28, _photosView.top, 28, PhotoViewHeight) ImageName:@"jinru" Target:self Action:@selector(recuilistTagClick:)];
//        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-30, _photosView.top, 30, PhotoViewHeight) ImageName:@"common_icon_arrow" Target:self Action:@selector(recuilistTagClick:)];
        scrollBtn.backgroundColor = [UIColor whiteColor];
        scrollBtn.tag = TagShowAllPhotos;
        [self.verOneScrollView addSubview:scrollBtn];
    }
    return _photosView;
}

- (void)setCompanyModel:(CompanyModel *)companyModel
{
    _companyModel = companyModel;
    WPCompanyManager *manager = [WPCompanyManager sharedManager];
    manager.delegate = self;
    [manager requestCompanyWithEp_id:companyModel.ep_id];
}

- (void)reloadData
{
    self.listModel = [WPCompanyManager sharedManager].model;
}

-(void)setListModel:(WPCompanyListModel *)listModel
{
    _listModel = listModel;
    
    WPCompanyListModel *model = listModel;
    UIButton *backBtn = (UIButton *)[self.view viewWithTag:TagBack];
    if (model.QRCode) {
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.QRCode]];
        [backBtn sd_setImageWithURL:url forState:UIControlStateNormal];
    }
    
    
    self.photosArr = [[NSMutableArray alloc]initWithArray:model.photoList];
    self.videosArr = [[NSMutableArray alloc]initWithArray:model.videoList];
    [self updatePhotosView];
    
    [[self itemWithTag:WPCompanyEditActionTypeCompanyName] resetTitle:model.enterpriseName];
    
    [[self itemWithTag:WPCompanyEditActionTypeIndustry] setIndustryId:model.dataIndustryId];
    [[self itemWithTag:WPCompanyEditActionTypeIndustry] resetTitle:model.dataIndustry];
    
    [[self itemWithTag:WPCompanyEditActionTypeNature] resetTitle:model.enterpriseProperties];
    
    [[self itemWithTag:WPCompanyEditActionTypeScale] resetTitle:model.enterpriseScale];
    
    [[self itemWithTag:WPCompanyEditActionTypeArea] resetTitle:model.enterpriseAddress];
    [[self itemWithTag:WPCompanyEditActionTypeArea] setIndustryId:model.enterpriseAddressID];
    
    [[self itemWithTag:WPCompanyEditActionTypeDetailArea] resetTitle:model.enterpriseAds];
    
//    [[self itemWithTag:WPCompanyEditActionTypePhone] resetTitle:model.enterprisePhone];
    
//    [[self itemWithTag:WPCompanyEditActionTypeQQ] resetTitle:model.enterpriseQq];
    
//    [[self itemWithTag:WPCompanyEditActionTypeWeChat] resetTitle:model.enterpriseWebchat];
//
    [[self itemWithTag:WPCompanyEditActionTypeWebsite] resetTitle:model.enterpriseWebsite];
    
//    [[self itemWithTag:WPCompanyEditActionTypeEmail] resetTitle:model.enterpriseEmail];
    
    [[self itemWithTag:WPCompanyEditActionTypePersonalName] resetTitle:model.enterprisePersonName];
    
//    [[self itemWithTag:WPCompanyEditActionTypePersonalTel] resetTitle:model.enterprisePersonTel];
    
    //NSString *str = [model.enterpriseBrief replaceReturn];
    SPTextView *textView = (SPTextView *)[self.view viewWithTag:WPCompanyEditActionTypeCompanyInfo];
    [textView resetTitle:@"公司简介已填写"];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (WPRecruitDraftInfoRemarkModel *remarkModel in listModel.epRemarkList) {
        if ([remarkModel.types isEqualToString:@"txt"]) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [arr addObject:str];
        }else{
            [arr addObject:remarkModel.txtcontent];
        }
    }
    self.briefArray = [[NSArray alloc]initWithArray:arr];
    
    //    [self showPreview];
}

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
        button.frame = CGRectMake(i*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
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
    
    if (self.photosArr.count == 8&&self.videosArr.count == 4) {
        self.photosView.contentSize = CGSizeMake(12*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), PhotoViewHeight);
    }else{
        NSInteger count = self.photosArr.count+self.videosArr.count;
        self.photosView.contentSize = CGSizeMake(count*(PhotoHeight+kHEIGHT(6))+PhotoHeight+kHEIGHT(12), PhotoViewHeight);
        _addPhotoBtn.frame = CGRectMake(count*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
        if (count != 12) {
           [self.photosView addSubview:_addPhotoBtn];  
        }
//        [self.photosView addSubview:_addPhotoBtn];
    }
    
}

#pragma mark 点击查看图片
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
//#pragma mark - 每个组展示什么图片,需要包装下MLPhotoBrowserPhoto
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
//#pragma mark - <MLPhotoBrowserViewControllerDelegate>
//- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser coverPhotoAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIImage *photo = self.photosArr[indexPath.row];
//    [self.photosArr removeObjectAtIndex:indexPath.row];
//    [self.photosArr insertObject:photo atIndex:0];
//    [self updatePhotosView];
//}
//
//#pragma mark - <MLPhotoBrowserViewControllerDelegate>
//- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
//    [self.photosArr removeObjectAtIndex:indexPath.row];
//    [self updatePhotosView];
//}
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

-(void)recuilistTagClick:(UIButton *)sender
{
    
    
    [self.view endEditing:YES];
    if (sender.tag == TagAddPhoto) {//点击添加图片
        HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册",@"相机", nil];//,@"视频"
        [sheet show];
//        WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机",@"视频"] imageNames:nil top:64];
//        actionSheet.tag = TagPhotoSheet;
//        [actionSheet showInView:self.view];
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
        //SPActionSheet *action = [[SPActionSheet alloc]initWithTitle:@"更换背景封面" delegate:self];
        //[action show];
        WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机"] imageNames:nil top:64];
        actionSheet.tag = TagBackSheet;
        [actionSheet showInView:self.view];
    }
    if (sender.tag == TagAddLogo) {
        WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机"] imageNames:nil top:64];
        actionSheet.tag = TagLogoSheet;
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
        if (buttonIndex == 2) {
            [self fromCameraSingle:2];
        }
        if (buttonIndex == 1) {
            [self fromCameraSingle:1];
        }
    }
}

//-(void)SPActionSheetDelegate
//{
//    WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机"] imageNames:nil top:64];
//    actionSheet.tag = TagBackSheet;
//    [actionSheet showInView:self.view];
//}

-(void)tap:(UITapGestureRecognizer *)tap
{
    [self.verOneScrollView endEditing:YES];
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

#pragma mark - Photos
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
#pragma mark 选择图片
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

#pragma mark - VideoSelected 视频
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
    vc.isEdit = YES;
    vc.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

-(void)checkAllVideos
{
    SAYVideoManagerViewController *vc = [[SAYVideoManagerViewController alloc]init];
    vc.arr = self.videosArr;
    //    vc.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

-(void)UpdateImageDelegate:(NSArray *)arr VideoArr:(NSArray *)videoArr
{
    [self.photosArr removeAllObjects];
    [self.photosArr addObjectsFromArray:arr];
    [self updatePhotosView];
}

-(void)UpdateVideoDelegate:(NSArray *)arr
{
    [self.videosArr removeAllObjects];
    [self.videosArr addObjectsFromArray:arr];
    [self updatePhotosView];
}

#pragma mark - 返回公司简介数组
- (void)getCompanyBrief:(NSArray *)briefArray{
    self.briefArray = briefArray;
    
}

#pragma mark - 返回itemview属性
- (SPItemView *)itemWithTag:(NSInteger)tag{
    SPItemView *itemview = (SPItemView *)[self.view viewWithTag:tag];
    return itemview;
}

- (NSString *)itemTitle:(NSInteger)tag{
    SPItemView *itemview = (SPItemView *)[self.view viewWithTag:tag];
    return itemview.title;
}

- (NSString *)itemIndustryId:(NSInteger)tag{
    SPItemView *itemview = (SPItemView *)[self.view viewWithTag:tag];
    return itemview.industryId;
}

#pragma mark - 判断是否操作了
- (BOOL)judgeIsEdit{
    if (![[self itemTitle:WPCompanyEditActionTypeCompanyName] isEqualToString:self.listModel.enterpriseName]&&![[self itemTitle:WPCompanyEditActionTypeCompanyName] isEqualToString:@""]) {
        return YES;
    }
    if (![[self itemTitle:WPCompanyEditActionTypeIndustry] isEqualToString:self.listModel.dataIndustry]&&![[self itemTitle:WPCompanyEditActionTypeIndustry] isEqualToString:@"请选择行业"]) {
        return YES;
    }
    if (![[self itemTitle:WPCompanyEditActionTypeNature] isEqualToString:self.listModel.enterpriseProperties]&&![[self itemTitle:WPCompanyEditActionTypeNature] isEqualToString:@"请选择企业性质"]) {
        return YES;
    }
    if (![[self itemTitle:WPCompanyEditActionTypeScale] isEqualToString:self.listModel.enterpriseScale]&&![[self itemTitle:WPCompanyEditActionTypeScale] isEqualToString:@"请选择企业规模"]) {
        return YES;
    }
//    if (![[self itemTitle:WPCompanyEditActionTypeArea] isEqualToString:self.listModel.enterpriseAddress]&&![[self itemTitle:WPCompanyEditActionTypeArea] isEqualToString:@"请选择企业地点"]) {
//        NSLog(@"------%@   ----%@ ---", [self itemTitle:WPCompanyEditActionTypeArea], self.listModel.enterpriseAddress);
   //     return YES;
//    }
  //  if (![[self itemTitle:WPCompanyEditActionTypeDetailArea] isEqualToString:self.listModel.enterpriseAds]&&![[self itemTitle:WPCompanyEditActionTypeDetailArea] isEqualToString:@""]) {
    //    return YES;
    //}
//    if (![[self itemTitle:WPCompanyEditActionTypePhone] isEqualToString:self.listModel.enterprisePhone]&&![[self itemTitle:WPCompanyEditActionTypePhone] isEqualToString:@""]) {
//        return YES;
//    }
//    if (![[self itemTitle:WPCompanyEditActionTypeQQ] isEqualToString:self.listModel.enterpriseQq]&&![[self itemTitle:WPCompanyEditActionTypeQQ] isEqualToString:@""]) {
//        return YES;
//    }
//    if (![[self itemTitle:WPCompanyEditActionTypeWeChat] isEqualToString:self.listModel.enterpriseWebchat]&&![[self itemTitle:WPCompanyEditActionTypeWeChat] isEqualToString:@""]) {
//        return YES;
//    }
    if (![[self itemTitle:WPCompanyEditActionTypeWebsite] isEqualToString:self.listModel.enterpriseWebsite]&&![[self itemTitle:WPCompanyEditActionTypeWebsite] isEqualToString:@""]) {
        return YES;
    }
    if (![[self itemTitle:WPCompanyEditActionTypePersonalName] isEqualToString:self.listModel.enterprisePersonName]&&![[self itemTitle:WPCompanyEditActionTypePersonalName] isEqualToString:@""]) {
        return YES;
    }
//    if (![[self itemTitle:WPCompanyEditActionTypePersonalTel] isEqualToString:self.listModel.enterprisePersonTel]&&![[self itemTitle:WPCompanyEditActionTypePersonalTel] isEqualToString:@""]) {
//        return YES;
//    }
    
    if (self.photosArr.count != self.listModel.photoList.count&&self.photosArr.count != 0) {
        return YES;
    }else{
        for (int i = 0; i < self.photosArr.count; i++) {
            if (![self.photosArr[i] isKindOfClass:[Pohotolist class]]) {
                return YES;
            }
        }
    }
    
    if (self.videosArr.count != self.listModel.videoList.count&&self.videosArr.count != 0) {
        return YES;
    }else{
        for (int i = 0; i < self.videosArr.count; i++) {
            if (![self.videosArr[i] isKindOfClass:[Dvlist class]]) {
                return YES;
            }
        }
    }
    
    if (self.briefArray.count != self.listModel.epRemarkList.count && self.briefArray.count != 0) {
        return YES;
    }else{
        for (int i = 0; i < self.briefArray.count; i++) {
            
            WPRecruitDraftInfoRemarkModel *remarkModel = self.listModel.epRemarkList[i];
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

@end
