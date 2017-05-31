//
//  WPInterviewEdltController.m
//  WP
//
//  Created by CBCCBC on 15/10/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "MyResumeEditController.h"
#import "SPTextView.h"
#import "SPItemView.h"
#import "SPSelectView.h"
#import "SPDateView.h"
#import "WPActionSheet.h"

#import "UIImage+ImageType.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MLPhotoBrowserViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <BlocksKit+UIKit.h>

#import <CoreMedia/CoreMedia.h>
#import "MLSelectPhotoPickerViewController.h"
#import "CTAssetsPickerController.h"
#import "SAYPhotoManagerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "DBTakeVideoVC.h"
#import "SPPhotoAsset.h"
#import "WPInterView.h"

@interface MyResumeEditController () <SPSelectViewDelegate,WPActionSheet,UIScrollViewDelegate,WPActionSheet,callBackVideo,takeVideoBack,UINavigationControllerDelegate,CTAssetsPickerControllerDelegate,UpdateImageDelegate,MLPhotoBrowserViewControllerDelegate,MLPhotoBrowserViewControllerDataSource>

@property (strong, nonatomic) UIScrollView *baseView;

@property (strong, nonatomic) NSMutableArray *photosArr;
@property (strong, nonatomic) NSMutableArray *videosArr;

@property (strong, nonatomic) UIScrollView *photosView;
@property (strong, nonatomic) SPTextView *worksView;
@property (strong, nonatomic) SPTextView *personalView;
@property (strong, nonatomic) UISegmentedControl *segment;
@property (strong, nonatomic) SPSelectView *selectView;
@property (strong, nonatomic) UIButton *addPhotosBtn;
@property (strong, nonatomic) SPDateView *dateView;

@property (assign, nonatomic) NSInteger cateTag;

@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayerVC;

@property (strong, nonatomic) WPInterEditModel *model;

@end

#define sItemTag 20

#define VideoTag 65
#define PhotoTag 50

#define TagRefreshName 100

#define PhotoHeight (SCREEN_WIDTH-30-6*3-10)/4
#define PhotoViewHeight PhotoHeight+20

@implementation MyResumeEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"我的简历";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = item;
    //    [self setupSubViews];
}

- (void)rightItemClick{
    if ([self.model.name isEqualToString:@""]||!self.model.name) {
        [MBProgressHUD createHUD:@"请输入姓名" View:self.view];
    }
    else if ([self.model.birthday isEqualToString:@""]||!self.model.birthday) {
        [MBProgressHUD createHUD:@"请选择生日" View:self.view];
    }
    else if ([self.model.education isEqualToString:@""]||!self.model.education) {
        [MBProgressHUD createHUD:@"请选择学历" View:self.view];
    }
    else if ([self.model.expe isEqualToString:@""]||!self.model.expe) {
        [MBProgressHUD createHUD:@"请选择工作经验" View:self.view];
    }
    else if ([self.model.hometown isEqualToString:@""]||!self.model.hometown) {
        [MBProgressHUD createHUD:@"请选择家乡" View:self.view];
    }
    else if ([self.model.lifeAddress isEqualToString:@""]||!self.model.lifeAddress) {
        [MBProgressHUD createHUD:@"请选择现居地址" View:self.view];
    }
    else if ([self.model.works isEqualToString:@""]||!self.model.works) {
        [MBProgressHUD createHUD:@"请填写工作经历" View:self.view];
    }
    else if ([self.model.phone isEqualToString:@""]||!self.model.phone) {
        [MBProgressHUD createHUD:@"请填写联系方式" View:self.view];
    }
    else if ([self.model.personal isEqualToString:@""]||!self.model.personal) {
        [MBProgressHUD createHUD:@"请填写个人亮点" View:self.view];
    }else{
        //            self.preview.hidden = NO;
        [self addNewInterview];
    }
}

- (WPInterEditModel *)model{
    if (!_model) {
        _model = [[WPInterEditModel alloc]init];
    }
    return _model;
}

- (void)setListModel:(DefaultParamsModel *)listModel{
    _listModel = listModel;
    self.photosArr = [[NSMutableArray alloc]initWithArray:listModel.Photo];
//    self.videosArr = [[NSMutableArray alloc]initWithArray:listModel.VideoList];
    
    SPItemView *view = (SPItemView *)[self.baseView viewWithTag:0+sItemTag];
    [view resetTitle:listModel.name];
    self.model.name = listModel.name;
    
    SPItemView *view1 = (SPItemView *)[self.baseView viewWithTag:1+sItemTag];
    [view1 resetTitle:listModel.birthday];
    self.model.birthday = listModel.birthday;
    
    SPItemView *view2 = (SPItemView *)[self.baseView viewWithTag:2+sItemTag];
    [view2 resetTitle:listModel.education];
    self.model.education = listModel.education;
    
    SPItemView *view3 = (SPItemView *)[self.baseView viewWithTag:3+sItemTag];
    [view3 resetTitle:listModel.workTime];
    self.model.expe = listModel.workTime;
    
    SPItemView *view4 = (SPItemView *)[self.baseView viewWithTag:4+sItemTag];
    [view4 resetTitle:listModel.homeTown];
    self.model.hometown = listModel.homeTown;
    self.model.homeTownId = listModel.homeTown_id;
    
    SPItemView *view5 = (SPItemView *)[self.baseView viewWithTag:5+sItemTag];
    [view5 resetTitle:listModel.nowAddress];
    self.model.lifeAddress = listModel.nowAddress;
    self.model.AddressId = listModel.nowAddress_id;
    
    SPItemView *view7 = (SPItemView *)[self.baseView viewWithTag:35];
    [view7 resetTitle:listModel.telPhone];
    self.model.phone = listModel.telPhone;
    
    [_worksView resetTitle:listModel.workExperience];
    self.model.works = listModel.workExperience;
    
    [_personalView resetTitle:listModel.lightspot];
    self.model.personal = listModel.lightspot;
    
    if ([listModel.sex isEqualToString:@"男"]) {
        _segment.selectedSegmentIndex = 0;
    }else{
        _segment.selectedSegmentIndex = 1;
    }
    [self refreshPhotos];
}

- (void)addNewInterview{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    self.model.sex = [_segment titleForSegmentAtIndex:_segment.selectedSegmentIndex];
    NSString *action;
    NSString *resume;
    if (self.listModel) {
        action = @"UpdateChangeResume";
        resume = _listModel.sid;
    }else{
        action = @"AddChangeResume";
        resume = @"";
    }
    
    BOOL updateImage = YES;
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
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
//        NSLog(@"1111111111");
    }
//    NSLog(@"22222222222222");
//    for (int i =0; i < self.videosArr.count; i++) {
//        WPFormData *formDatas = [[WPFormData alloc]init];
//        if ([self.videosArr[i] isKindOfClass:[NSString class]]) {
//            NSData *data = [NSData dataWithContentsOfFile:self.videosArr[i]];
//            formDatas.data = data;
//        } else if([self.videosArr[i] isKindOfClass:[ALAsset class]]){
//            ALAsset *asset = self.videosArr[i];
//            //将视频转换成NSData
//            ALAssetRepresentation *rep = [asset defaultRepresentation];
//            Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
//            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
//            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
//            formDatas.data = data;
//        }else{
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.videosArr[i] original_path]]]];
//            formDatas.data = data;
//        }
//        formDatas.name = [NSString stringWithFormat:@"PhotoAddres%lu",i+self.photosArr.count];
//        formDatas.filename = [NSString stringWithFormat:@"PhotoAddres%lu.mp4",i+self.photosArr.count];
//        formDatas.mimeType = @"video/quicktime";
//        [arr addObject:formDatas];
//        if (!formDatas.data) {
//            updateImage = NO;
//        }
//    }
    
    NSString *PhotoNum;
    NSString *photoCount;
    NSString *isModify;
    if (updateImage) {
        PhotoNum = [NSString stringWithFormat:@"%lu",self.photosArr.count+self.videosArr.count];
        photoCount = [NSString stringWithFormat:@"%lu",self.photosArr.count];
        isModify = @"1";
    }else{
        PhotoNum = @"";
        photoCount = @"";
        isModify = @"0";
        arr = nil;
    }
    
    NSDictionary *params = @{@"action":action,
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.dic[@"userid"],
                             @"resume_user_id":resume,
                             @"address":self.model.lifeAddress,
                             @"Address_id":self.model.AddressId,
                             @"birthday":self.model.birthday,
                             @"education":self.model.education,
                             @"homeTown":self.model.hometown,
                             @"homeTown_id":self.model.homeTownId,
                             @"name":self.model.name,
                             @"sex":self.model.sex,
                             @"tel":self.model.phone,
                             @"photoCount":photoCount,
                             @"photoNum":PhotoNum,
                             @"workexperience":self.model.works,
                             @"WorkTime":self.model.expe,
                             @"lightspot":self.model.personal,
                             @"isModify":isModify};
    NSLog(@"%@",params);
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:urlStr params:params formDataArray:arr success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([json[@"status"] isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"已完成"];
            [self performSelector:@selector(delay) withObject:nil afterDelay:1];
        }else{
            [MBProgressHUD showError:@"失败请重试"];
        }
//        NSLog(@"%@",json);
//        NSLog(@"%@",json[@"info"]);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请重试"];
    }];
}

- (void)delay{
    if (self.delegate) {
        [self.delegate refreshUserListDelegate];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setupSubViews{
    _cateTag = 0;
    [self.view addSubview:self.baseView];
    [self.baseView addSubview:self.photosView];
    [self setBodyView];
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

- (UIScrollView *)baseView
{
    if (!_baseView) {
        _baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _baseView.backgroundColor = RGB(235, 235, 235);
        _baseView.contentSize = CGSizeMake(SCREEN_WIDTH, PhotoViewHeight + 170 + 80 + kHEIGHT(43)*7 + 6*10 + 5*0.5);
    }
    return _baseView;
}
    
-(UIScrollView *)photosView
{
    if (!_photosView) {
        
        _photosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, +10, SCREEN_WIDTH-30, PhotoViewHeight)];
        _photosView.backgroundColor = [UIColor whiteColor];
        _photosView.showsHorizontalScrollIndicator = NO;
        
        _addPhotosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _addPhotosBtn.backgroundColor = RGB(204, 204, 204);
        _addPhotosBtn.frame = CGRectMake(10, 10, PhotoHeight, PhotoHeight);
        //        [_addPhotosBtn setImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
        [_addPhotosBtn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(102, 102, 102)] forState:UIControlStateHighlighted];
        [_addPhotosBtn addTarget:self action:@selector(addPhotos:) forControlEvents:UIControlEventTouchUpInside];
        [_photosView addSubview:_addPhotosBtn];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:_addPhotosBtn.bounds];
        imageV.image = [UIImage imageNamed:@"tianjia64"];
        [_addPhotosBtn addSubview:imageV];
        
        /**< 照片墙翻页 */
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-30, _photosView.top, 30, PhotoViewHeight) ImageName:@"common_icon_arrow" Target:self Action:@selector(photosViewClick:)];
        scrollBtn.backgroundColor = [UIColor whiteColor];
        [self.baseView addSubview:scrollBtn];
    }
    return _photosView;
}

-(SPSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[SPSelectView alloc]initWithTop:64];
        _selectView.delegate = self;
    }
    return _selectView;
}

-(SPDateView *)dateView
{
    if (!_dateView) {
        __weak typeof(self) weakSelf = self;
        _dateView = [[SPDateView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-30, SCREEN_WIDTH, 216+30)];
        _dateView.getDateBlock = ^(NSString *dateStr){
            SPItemView *view = (SPItemView *)[weakSelf.baseView viewWithTag:sItemTag+1];
            [view resetTitle:dateStr];
            weakSelf.model.birthday = dateStr;
        };
    }
    return _dateView;
}

- (void)setBodyView{
    
    __weak typeof(self) weakSelf = self;
    
    NSArray *titleArr = @[@[@"姓       名:",@"生       日:"],
                          @[@"学       历:",@"工作年限:",@"家       乡:",@"现居地址:"]];
    
    NSArray *placeArr =@[@[@"请输入姓名",@"请选择生日"],
                         @[@"请选择学历",@"请选择工作年限",@"请选择家乡",@"请现则居住地"]];
    
    NSArray *typeArr = @[@[kCellTypeText,kCellTypeButton],
                         @[kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton]];
    
    for (int i = 0; i < titleArr.count; i++) {
        for (int j = 0; j < [titleArr[i] count]; j++) {
            CGFloat top = pow(2, i+1)-2+j;
            
            SPItemView *view = [[SPItemView alloc]initWithFrame:CGRectMake(0, top*kHEIGHT(43)+i*10+self.photosView.bottom+10, SCREEN_WIDTH, kHEIGHT(43))];
            [view setTitle:titleArr[i][j] placeholder:placeArr[i][j] style:typeArr[i][j]];
            [self.baseView addSubview:view];
            view.tag = top + sItemTag;
            view.SPItemBlock = ^(NSInteger tag){
                [self buttonItem:tag];
            };
            view.hideFromFont = ^(NSInteger tag, NSString *title){
                weakSelf.model.name = title;
            };
        }
    }
    _segment = [[UISegmentedControl alloc]initWithItems:@[@"男",@"女"]];
    _segment.frame = CGRectMake(SCREEN_WIDTH-10-80, self.photosView.bottom+10+kHEIGHT(43)/2-12.5, 80, 25);
    _segment.selectedSegmentIndex = 0;
    _segment.tintColor = RGB(153, 153, 153);
    [self.baseView addSubview:_segment];
    
    //工作经历
    CGFloat worksHeight = 6*kHEIGHT(43)+1*10+self.photosView.bottom+10;
    _worksView = [[SPTextView alloc]initWithFrame:CGRectMake(0, worksHeight+10, SCREEN_WIDTH, 170)];
    [_worksView setWithTitle:@"工作经历:" placeholder:@"请填写工作经历"];
    _worksView.hideFromFont = ^(NSString *title){
//        [weakSelf setContentOffset:CGPointMake(0, weakSelf.contentSize.height - weakSelf.height) animated:YES];
        weakSelf.model.works = title;
    };
    [self.baseView addSubview:_worksView];
    
    //联系方式
    SPItemView *itemView = [[SPItemView alloc]initWithFrame:CGRectMake(0, _worksView.bottom+10, SCREEN_WIDTH, kHEIGHT(43))];
    [itemView setTitle:@"联系方式" placeholder:@"请填写联系方式" style:kCellTypeText];
    itemView.tag = 35;
    itemView.textField.keyboardType = UIKeyboardTypePhonePad;
//    CGFloat Itemtop = itemView.top;
    itemView.showToFont = ^(){
//        [weakSelf setContentOffset:CGPointMake(0, Itemtop-200) animated:YES];
        
    };
    itemView.hideFromFont = ^(NSInteger tag, NSString *title){
//        [weakSelf setContentOffset:CGPointMake(0, weakSelf.contentSize.height - weakSelf.height) animated:YES];
        weakSelf.model.phone = title;
    };
    [self.baseView addSubview:itemView];
    
    //个人亮点
    _personalView = [[SPTextView alloc]initWithFrame:CGRectMake(0, itemView.bottom, SCREEN_WIDTH, 80)];
    [_personalView setWithTitle:@"个人亮点:" placeholder:@"请填写个人亮点"];
    //    CGFloat personalTop = _personalView.top;
    _personalView.showToFont = ^(){
        //        [weakSelf setContentOffset:CGPointMake(0, personalTop-200) animated:YES];
    };
    _personalView.hideFromFont = ^(NSString *title){
        //        [weakSelf setContentOffset:CGPointMake(0, weakSelf.contentSize.height - weakSelf.height) animated:YES];
        weakSelf.model.personal = title;
    };
    [self.baseView addSubview:_personalView];
}

-(void)buttonItem:(NSInteger)tag
{
    _cateTag = tag;
    [self.dateView hide];
    [self.view endEditing:YES];
    NSMutableArray *EducationArr = [[NSMutableArray alloc]init];
    NSMutableArray *WageArr = [[NSMutableArray alloc]init];
    NSMutableArray *ExperienceArr = [[NSMutableArray alloc]init];
    NSMutableArray *WelfareArr = [[NSMutableArray alloc]init];
    
    NSArray *Education = @[@"不限",@"高中",@"技校",@"中专",@"大专",@"本科",@"硕士",@"博士"];
    NSArray *Wage = @[@"面议",@"1000以下",@"1000-2000",@"2000-3000",@"3000-5000",@"5000-8000",@"8000-12000",@"12000-2000",@"20000以上"];
    NSArray *Experience = @[@"不限",@"一年以下",@"1-2年",@"3-5年",@"6-8年",@"8-10年",@"10年以上"];
    NSArray *Welfare = @[@"不限",@"五险一金",@"包住",@"包吃",@"年底双薪",@"周末双休",@"交通补助",@"加班补助",@"餐补"];
    
    for (int i = 0; i < Education.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = Education[i];
        [EducationArr addObject:model];
    }
    
    for (int i = 0; i < Wage.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = Wage[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [WageArr addObject:model];
    }
    for (int i = 0; i < Experience.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = Experience[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [ExperienceArr addObject:model];
    }
    
    for (int i = 0; i < Welfare.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = Welfare[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [WelfareArr addObject:model];
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    switch (tag-sItemTag) {
        case 0:
            
            break;
        case 1:
            NSLog(@"生日");
            [self.dateView showInView:window];
            break;
        case 2:
            NSLog(@"学历");
            [self.selectView setLocalData:EducationArr];
            break;
        case 3:
            NSLog(@"工作年限");
            [self.selectView setLocalData:ExperienceArr];
            break;
        case 4:
            NSLog(@"家乡");
            self.selectView.isArea = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
        case 5:
            NSLog(@"现居地");
            self.selectView.isArea = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
        default:
            break;
    }
}

-(void)SPSelectViewDelegate:(IndustryModel *)model
{
    SPItemView *view = (SPItemView *)[self.baseView viewWithTag:_cateTag];
    switch (_cateTag-sItemTag) {
        case 0:
            
            break;
        case 1:
            NSLog(@"生日");
            break;
        case 2:
            NSLog(@"学历");
            [view resetTitle:model.industryName];
            self.model.education = model.industryName;
            break;
        case 3:
            NSLog(@"工作年限");
            [view resetTitle:model.industryName];
            self.model.expe = model.industryName;
            break;
        case 4:
            NSLog(@"家乡");
            [view resetTitle:model.industryName];
            self.model.hometown = model.industryName;
            self.model.homeTownId = model.industryID;
            break;
        case 5:
            NSLog(@"现居地");
            [view resetTitle:model.industryName];
            self.model.lifeAddress = model.industryName;
            self.model.AddressId = model.industryID;
            break;
        default:
            break;
    }
}

-(void)addPhotos:(UIButton *)sender
{
    WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相机",@"相册"] imageNames:nil top:0];
    actionSheet.tag = 40;
    [actionSheet showInView:self.view];
}

#pragma mark - WPActionSheet
- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (sheet.tag == 40) {
        if (buttonIndex == 1) {
            [self fromCamera];
        }
        if (buttonIndex == 2) {
            [self fromAlbums];
        }
//        if (buttonIndex == 3) {
//            [self videoFromCamera];
//        }
    }
    //    else{
    //        if (buttonIndex == 1) {
    //            [self videoFromCamera];
    //        }
    //        if (buttonIndex == 2) {
    //            [self videoFromAlbums];
    //        }
    //    }
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
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    picker.bk_didCancelBlock = ^(UIImagePickerController *picker){
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    picker.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        SPPhotoAsset *asset = [[SPPhotoAsset alloc]init];
        asset.image = image;
        [self.photosArr addObject:asset];
        [self refreshPhotos];
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:picker animated:YES completion:NULL];
}

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
        [self refreshPhotos];
    };
}

#pragma mark - VideoSelected
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
    picker.maximumNumberOfSelection = 4-self.videosArr.count;
    picker.assetsFilter = [ALAssetsFilter allVideos];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

//从录制界面选择Video返回
-(void)sendBackVideoWith:(NSArray *)array
{
    [self.videosArr addObjectsFromArray:array];
    [self refreshPhotos];
    //    [self.interView refreshVideos];
}
//录制返回
-(void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
    [self.videosArr addObject:filePaht];
    [self refreshPhotos];
    //    [self.interView refreshVideos];
}
//直接选择Video返回
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [self.videosArr addObjectsFromArray:assets];
    [self refreshPhotos];
    //    [self.interView refreshVideos];
}


-(void)photosViewClick:(UIButton *)sender
{
    [self.dateView hide];
    SAYPhotoManagerViewController *vc = [[SAYPhotoManagerViewController alloc]init];
    vc.arr = self.photosArr;
//    vc.videoArr = self.videosArr;
    vc.isEdit = YES;
    vc.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

-(void)refreshPhotos
{
    for (UIView *view in self.photosView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < self.photosArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+6)+10, 10, PhotoHeight, PhotoHeight);
        button.tag = PhotoTag+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        //        SPPhotoAsset *asset = ;
//        [button setImage:[self.photosArr[i] thumbImage] forState:UIControlStateNormal];
        if ([self.photosArr[i] isKindOfClass:[SPPhotoAsset class]]) {
            [button setImage:[self.photosArr[i] thumbImage] forState:UIControlStateNormal];
        }else{
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] thumb_path]]];
            [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
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
        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
//        if ([self.videosArr[i] isKindOfClass:[NSString class]]) {
//            [button setImage:[UIImage getImage:self.videosArr[i]] forState:UIControlStateNormal];
//        }else{
//            ALAsset *asset = self.videosArr[i];
//            [button setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
//        }
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
        _addPhotosBtn.frame = CGRectMake(count*(PhotoHeight+6)+10, 10, PhotoHeight, PhotoHeight);
        [self.photosView addSubview:_addPhotosBtn];
    }
}

-(void)checkImageClick:(UIButton *)sender
{
    if (sender.tag>=PhotoTag &&sender.tag <VideoTag) {
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
//        
//        for (int i = 0; i < self.photosArr.count; i++) {/**< 头像或背景图 */
//            MJPhoto *photo = [[MJPhoto alloc]init];
//            photo.image = [self.photosArr[i] originImage];
//            photo.srcImageView = [(UIButton *)[self.baseView viewWithTag:50+i] imageView];
//            [arr addObject:photo];
//        }
//        MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
//        brower.currentPhotoIndex = sender.tag-PhotoTag;
//        brower.photos = arr;
//        [brower show];
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
    }else{
        NSLog(@"视频");
        [self checkVideos:sender.tag-VideoTag];
    }
}

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
    UIButton *btn = (UIButton *)[self.view viewWithTag:indexPath.row+PhotoTag];
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
    [self refreshPhotos];
}

#pragma mark - <MLPhotoBrowserViewControllerDelegate>
- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
    [self.photosArr removeObjectAtIndex:indexPath.row];
    [self refreshPhotos];
}

-(void)checkVideos:(NSInteger)number
{
    NSLog(@"观看视频");
    if ([self.videosArr[number] isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL fileURLWithPath:self.videosArr[number]];
        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    } else {
        ALAsset *asset = self.videosArr[number];
        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
    }
    //指定媒体类型为文件
    _moviePlayerVC.moviePlayer.movieSourceType = MPMovieSourceTypeFile|MPMovieSourceTypeStreaming;
    
    //通知中心
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPlaybackFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [self presentViewController:_moviePlayerVC animated:YES completion:^{}];
}

- (void)onPlaybackFinished
{
    NSLog(@"onPlaybackFinished");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

-(void)UpdateImageDelegate:(NSArray *)arr VideoArr:(NSArray *)videoArr
{
    [self.photosArr removeAllObjects];
    [self.photosArr addObjectsFromArray:arr];
    
    [self.videosArr removeAllObjects];
    [self.videosArr addObjectsFromArray:videoArr];
    
    [self refreshPhotos];
}

- (void)hideSubView
{
    [self.dateView hide];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.dateView hide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
