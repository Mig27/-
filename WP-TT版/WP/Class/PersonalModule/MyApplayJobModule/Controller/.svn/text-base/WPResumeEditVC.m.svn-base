//
//  WPResumeEditVC.m
//  WP
//
//  Created by Kokia on 16/3/28.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPResumeEditVC.h"

#import "SPPhotoAsset.h"

#import "MLSelectPhotoAssets.h"
#import "MLPhotoBrowserViewController.h"

#import "WPPersonalInfoPreview.h"

#import <MediaPlayer/MediaPlayer.h>


#import "SPItemView.h"

// 照片、相册、视频
#import "WPActionSheet.h"

// 选择器
#import "SPSelectView.h"

// 日期
#import "SPDateView.h"

// 照片选择器
#import "SAYPhotoManagerViewController.h"

#import "MLSelectPhotoPickerViewController.h"
#import "VideoBrowser.h"
#import "DBTakeVideoVC.h"

#import "MJPhoto.h"

#import "SPPhotoBrowser.h"

#import "WPInterviewLightspotController.h"
#import "WPInterviewEducationListController.h"
#import "WPInterviewWorkListController.h"
#import "WPPersonalManager.h"

#import "CommonTipView.h"
#import "HJCActionSheet.h"
//#import "CouldnotbenNil.h"
//#import "WPInterviewPersonalInfoPreview.h"


// tag列表
#define sItemTag 20
#define VideoTag 65
#define PhotoTag 50
#define TagRefreshName 100


// 高度
#define WorksViewHeight 170
#define PersonalViewHeight 80


@interface WPResumeEditVC ()
<UIScrollViewDelegate, WPActionSheet, SPSelectViewDelegate, callBackVideo,takeVideoBack, SPPhotoBrowserDelegate, UpdateImageDelegate, WPInterviewLightspotDelegate, WPInterviewEducationListDelegate, WPInterviewWorkListDelegate , WPPersonalManagerDelegate,UIAlertViewDelegate,HJCActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    BOOL imageChanged;
}
#pragma mark - UI层变量

@property (nonatomic, strong) MPMoviePlayerViewController *moviePlayerVC;
@property (nonatomic, strong) UIScrollView *baseView;
@property (nonatomic, strong) UIScrollView *photosView;
@property (nonatomic, strong) NSArray * proTitleList;
@property (nonatomic, strong) UIButton *addPhotosBtn;   // 图片增加按钮
@property (nonatomic, strong) SPDateView *dateView;     // 日期选择

@property (strong, nonatomic) SPSelectView *selectView; // 选择器
@property (nonatomic, strong) CommonTipView *rightView;
#pragma mark - 数据层变量
@property (nonatomic, strong) NSMutableArray *photosArr;
@property (nonatomic, strong) NSMutableArray *videosArr;
#pragma mark-判断是否修改过
@property (nonatomic ,strong) NSMutableArray *photoArray;
@property (nonatomic ,strong) NSMutableArray *vedioArray;
@property (nonatomic ,strong) NSArray *detailPropertyArray;
@property (nonatomic ,strong) NSArray *detailListsArray;
@property (nonatomic , strong)NSArray *propertyArray;
@property (nonatomic , strong)NSArray *listsArray;
/** 个人亮点固定内容 */
@property (nonatomic, copy) NSString *lightspotStr;
/** 个人亮点数组 */
@property (nonatomic, strong) NSArray *lightspotArray;
@property (nonatomic, copy) NSString *lightspotString;
/** 教育经历内容数组 */
@property (nonatomic, strong) NSMutableArray *educationListArray;
/** 单个教育经历内容数组 */
@property (nonatomic, strong) NSMutableArray *educationArray;
/** 工作经历内容数组 */
@property (nonatomic, strong) NSMutableArray *workListArray;
@property (nonatomic ,strong)NSMutableArray *viewArr;

@property (nonatomic, strong) WPResumeUserInfoModel *model; // 模型数据

@property (assign, nonatomic) NSInteger cateTag;

/** 底部更新按钮*/
@property (nonatomic, strong) UIButton *updateBtn;
@property (nonatomic ,strong)WPPersonalInfoPreview *preview;

@end

@implementation WPResumeEditVC
{
    UIPickerView * sexPickerView;
    UIView * sexBtnView;
}
#pragma mark - 添加返回按钮
-(void)createBackButton
{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 22);
    
    [back addTarget:self action:@selector(backToView:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 9, 16)];
    imageV.image = [UIImage imageNamed:@"fanhui"];
    [back addSubview:imageV];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 22)];
    title.text = @"返回";
    title.font = kFONT(14);
    [back addSubview:title];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;
}

#pragma mark-Action 用户点击了返回按钮
-(void)backToView:(UIButton *)sender
{
    [self.dateView removeView];
   // if (self.isEdit==1000)//从个人信息界面过来
  //  {
        if (![self isModelChange])
        {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认退出编辑?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
            [alert show];
//            WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"保存",@"不保存"] imageNames:nil top:64];
//            actionSheet.tag = 10;
//            [actionSheet showInView:self.view];
        }

    //}
    /*
    else
    {
        if ([self isModelNil] &&[self isModelChange]&& (self.photosArr.count ==0) )
        {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            
            WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"保存",@"不保存"] imageNames:nil top:64];
            actionSheet.tag = 10;
            [actionSheet showInView:self.view];
        }
 
    }
     */
    
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
#pragma mark -- 判断页面是否有修改或是否有编辑
- (BOOL)isModelNil  // 页面里内容是否为空 只要有一个不为空返回 NO 表示该页面编辑过,有内容 ,可以保存入草稿
{
    for (NSArray *arr in self.propertyArray) {
        int i = 0;
        for (NSString *string in arr) {
            if (![string isEqualToString:@""]) {
                return NO;
            }
            i ++ ;
        }
    }
    for (NSArray *array in self.listsArray) {
        if (array.count != 0) {
            return NO;
        }
    }
    if (self.photoArray.count > 0 || self.vedioArray .count > 0) {
        return NO;
    }
    return YES;
}

- (BOOL)isModelChange  // 判断页面内容是否有修改 发现修改即返回 YES
{
    
    int i = 0;
    for (NSArray *arr in self.propertyArray) {
        NSArray *array = self.detailPropertyArray[i];
        int j = 0;
        for (NSString *string in arr) {
            NSString *str = array[j];
            if (![string isEqualToString:str]) {
                return YES;
            }
            j ++ ;
        }
        i ++ ;
    }
    
    //判断个人亮点
    if (![self.lightspotStr isEqualToString:self.userModel.lightspot] || ![self.lightspotString isEqualToString:self.userModel.lightspotList]) {
        return YES;
    }
    
    
    //判断工作经历
    if (self.workListArray.count != self.userModel.workList.count) {
        return YES;
    }else{
        for (int i = 0; i < self.workListArray.count; i++) {
            Work *workModel = self.userModel.workList[i];
            workModel.workStr =[([self.userModel.workList[i] expList][0]) txtcontent];
            Work *model = self.workListArray[i];
            if (![model.epName isEqualToString:workModel.epName]) {
                return YES;
            }
            if (![model.beginTime isEqualToString:workModel.beginTime]) {
                return YES;
            }
            if (![model.endTime isEqualToString:workModel.endTime]) {
                return YES;
            }
            if (![model.industry isEqualToString:workModel.industry]) {
                return YES;
            }
            if (![model.epProperties isEqualToString:workModel.epProperties]) {
                return YES;
            }
            if (![model.position isEqualToString:workModel.position]) {
                return YES;
            }
            
            if (![model.workStr isEqualToString:workModel.workStr]) {
                return YES;
            }
            // 判断描述
//            WPPathModel * newModel = model.expList[0];
//            WPPathModel * oldModel = workModel.expList[0];
//            if (![newModel.txtcontent isEqualToString:oldModel.txtcontent]) {
//                return YES;
//            }
            
            
        }
    }

    //判断教育经历
    if (self.educationListArray.count != self.userModel.educationList.count) {
        return YES;
    }else{
        for (int i = 0; i < self.educationListArray.count; i++) {
            Education *educationModel = self.userModel.educationList[i];
            educationModel.educationStr =[([self.userModel.educationList[i] expList][0]) txtcontent];
            Education *model = self.educationListArray[i];
            if (![model.schoolName isEqualToString:educationModel.schoolName]) {
                return YES;
            }
            if (![model.beginTime isEqualToString:educationModel.beginTime]) {
                return YES;
            }
            if (![model.endTime isEqualToString:educationModel.endTime]) {
                return YES;
            }
            if (![model.major isEqualToString:educationModel.major]) {
                return YES;
            }
            if (![model.education isEqualToString:educationModel.education]) {
                return YES;
            }
            if (![model.educationStr isEqualToString: educationModel.educationStr]) {
                return YES;
            }
            
            
            
        }
    }
    
    //判断图片是否有改变
    if (self.photosArr.count != self.userModel.photoList.count) {
        return YES;
    }else{
        for (int i = 0; i < self.photosArr.count; i++) {
            if ([self.photosArr[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                return YES;
            }
        }
    }
    if (self.videosArr.count != self.userModel.videoList.count) {
        return YES;
    }else{
        for (int i = 0; i < self.photosArr.count; i++) {
            if ([self.photosArr[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (NSArray *)propertyArray
{
    self.propertyArray = @[@[self.model.name,self.model.sex,self.model.birthday,self.model.education,self.model.workTime,self.model.nowSalary,self.model.marriage,self.model.homeTown,self.model.address],
                           @[self.model.Hope_Position,self.model.Hope_salary,self.model.Hope_address,self.model.Hope_welfare]];
    return _propertyArray;
}
- (NSArray *)listsArray
{
    self.listsArray = @[self.lightspotArray,self.educationListArray,self.workListArray];
    return _listsArray;
}
- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        self.photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:nil];
    [self.view addGestureRecognizer:pan];
    
    
    
    if (_isPerson==100) {
         self.title=@"编辑个人信息";
    } else {
         self.title=@"创建个人信息";
    }
 
[self createBackButton ];
    
    _lightspotStr = @"";
    [self addRightBarButtonItem];
    
    //button1.selected = YES;

    if (self.personModel) {
        [self requestForPersonInfo];
        
    }
    
}

- (void)addRightBarButtonItem
{
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 50, 22);
    button1.titleLabel.font = kFONT(14);
    button1.tag = 1002;
    [button1 setTitle:@"完成" forState:UIControlStateNormal];
    [button1 setTitle:@"编辑" forState:UIControlStateSelected];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button1 addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem= rightBarItem;
}

#pragma mark - 数据层 ~ 数组初始化
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

- (NSArray *)lightspotArray{
    if (!_lightspotArray) {
        _lightspotArray = [[NSArray alloc]init];
    }
    return _lightspotArray;
}

- (NSMutableArray *)educationListArray{
    if (!_educationListArray) {
        _educationListArray = [[NSMutableArray alloc]init];
    }
    return _educationListArray;
}
- (NSMutableArray *)educationArray{
    if (!_educationArray) {
        _educationArray = [[NSMutableArray alloc]init];
    }
    return _educationArray;
}
- (NSMutableArray *)workListArray{
    if (!_workListArray) {
        _workListArray = [[NSMutableArray alloc]init];
    }
    return _workListArray;
}

- (NSMutableArray *)viewArr
{
    if (!_viewArr) {
        self.viewArr = [NSMutableArray array];
    }
    return _viewArr;
}


#pragma mark - 点击完成
- (void)rightItemClick:(UIButton *)sender
{
   
    if (self.isPersonInfo)//从个人信息界面过来时点击完成直接更新数据
    {
        [self.dateView removeView];
        if (![self couldnotCommit]) {
            return;
        }
        [self updateResumeInfo];
    }
    else
    {
        [self.dateView removeView];
//        self.title=self.model.name;
        if (![self couldnotCommit]) {
            return;
        }
        sender.selected = !sender.selected;
        
        if (sender.selected)    // 显示预览界面
        {
            //        [self addNewInterview];
            [self.view addSubview:self.preview];
            [self.view addSubview:self.updateBtn];
            [self.preview reloadData];
        }
        else
        {
            [self deletePreview];
        }
    }
//    [self.dateView removeView];
//    self.title=self.model.name;
//    if (![self couldnotCommit]) {
//        return;
//    }
//    sender.selected = !sender.selected;
//    
//    if (sender.selected)    // 显示预览界面
//    {
////        [self addNewInterview];
//        [self.view addSubview:self.preview];
//        [self.view addSubview:self.updateBtn];
//        [self.preview reloadData];
//    }
//    else
//    {
//        [self deletePreview];
//    }
    
}
#pragma mark 从个人界面推出时请求个人的信息
- (void)requestForPersonInfo
{
    WPPersonalManager *manager = [WPPersonalManager sharedManager];
    manager.delegate = self;
    [manager requestPersonInfoWithResumeUserId:self.personModel.sid];
}
//从个人信息界面返回时数据请求的代理方法
- (void)reloadData
{
    [self setupSubViews];
    self.userModel = [WPPersonalManager sharedManager].model;
}

#pragma mark - 数据层 ~ Model

- (WPResumeUserInfoModel *)model{
    if (!_model) {
        _model = [[WPResumeUserInfoModel alloc]init];
        _model.name = _model.name?:@"";
        _model.sex = _model.sex?:@"";
        _model.birthday = _model.birthday?:@"";
        _model.education = _model.education?:@"";
        _model.workTime = _model.workTime?:@"";
        _model.homeTown = _model.homeTown?:@"";
        _model.homeTownId = _model.homeTownId?:@"";
        _model.address = _model.address?:@"";
        _model.addressId = _model.addressId?:@"";

        _model.tel = _model.tel?:@"";
        _model.lightspot = _model.lightspot?:@"";
        
        [self.photosArr addObjectsFromArray:_model.photoList];
        [self.videosArr addObjectsFromArray:_model.videoList];
    }
    return _model;
}


- (void)initSelfModel:(WPResumeUserInfoModel *)model
{
    self.model.resumeUserId = model.resumeUserId;
    self.model.name = model.name;
    self.model.sex = model.sex;
    self.model.birthday = model.birthday;
    self.model.education = model.education;
    self.model.workTime = model.workTime;
    self.model.homeTown = model.homeTown;
    self.model.homeTownId = model.homeTownId;
    self.model.addressId = model.addressId;
    self.model.address = model.address;
    self.model.tel = model.tel;
    
    self.model.lightspot = model.lightspot;
    self.model.lightspotList = model.lightspotList;
    
    self.model.nowSalary = model.nowSalary;
    self.model.marriage = model.marriage;
    self.model.webchat = model.webchat;
    self.model.qq = model.qq;
    self.model.email = model.email;
    
//    self.model.lightspotList = [[NSArray alloc]initWithArray:model.lightspotList];
    self.model.photoList = [[NSArray alloc]initWithArray:model.photoList];
    self.model.videoList = [[NSArray alloc]initWithArray:model.videoList];
    
    self.model.educationList = [[NSArray alloc]initWithArray:model.educationList];
    self.model.workList = [[NSArray alloc]initWithArray:model.workList];
}

#pragma mark 刷新数据 回调Model
- (void)setUserModel:(WPResumeUserInfoModel *)userModel
{
    [self initSelfModel:userModel];
    
    _userModel = userModel;
    self.detailPropertyArray = @[@[self.userModel.name,self.userModel.sex,self.userModel.birthday,self.userModel.education,self.userModel.workTime,self.userModel.nowSalary,self.userModel.marriage,self.userModel.homeTown,self.userModel.address],
                                 @[self.userModel.Hope_Position,self.userModel.Hope_salary,self.userModel.Hope_address,self.userModel.Hope_welfare]];
    
   
    self.photosArr = [[NSMutableArray alloc]initWithArray:userModel.photoList];
    self.videosArr = [[NSMutableArray alloc]initWithArray:userModel.videoList];
    
    // 初始化 编辑界面 数据
    SPItemView *view = (SPItemView *)[self.baseView viewWithTag:0+sItemTag];
    [view resetTitle:userModel.name];
   
    
    SPItemView *view1 = (SPItemView *)[self.baseView viewWithTag:1+sItemTag];
    [view1 resetTitle:[SPLocalApplyArray sexToString:userModel.sex]];
    
    SPItemView *view2 = (SPItemView *)[self.baseView viewWithTag:2+sItemTag];
    [view2 resetTitle:userModel.birthday];
    
    SPItemView *view3 = (SPItemView *)[self.baseView viewWithTag:3+sItemTag];
    [view3 resetTitle:userModel.education];
    
    SPItemView *view4 = (SPItemView *)[self.baseView viewWithTag:4+sItemTag];
    [view4 resetTitle:userModel.workTime];
    
    SPItemView *view5 = (SPItemView *)[self.baseView viewWithTag:5+sItemTag];
    [view5 resetTitle:userModel.nowSalary];
    
    SPItemView *view6 = (SPItemView *)[self.baseView viewWithTag:6+sItemTag];
    [view6 resetTitle:userModel.marriage];
    
    SPItemView *view7 = (SPItemView *)[self.baseView viewWithTag:7+sItemTag];
    [view7 resetTitle:userModel.homeTown];
    
    SPItemView *view8 = (SPItemView *)[self.baseView viewWithTag:8+sItemTag];
    [view8 resetTitle:userModel.address];
    [self refreshPhotos];
    
    // 个人亮点
    self.lightspotStr = userModel.lightspot;
    self.lightspotString = userModel.lightspotList;
    // 个人亮点列表
//    NSMutableArray *arr3 = [[NSMutableArray alloc]init];
//    for (WPPathModel *remarkModel in userModel.lightspotList) {
//        if ([remarkModel.types isEqualToString:@"txt"]) {
//            NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//            [arr3 addObject:str];
//        }else{
//            [arr3 addObject:remarkModel.txtcontent];
//        }
//    }
//    self.lightspotArray = arr3;
    
    if (![self.lightspotStr isEqualToString:@""]|self.lightspotString.length) {
        SPItemView *itemview = (SPItemView *)[self.view viewWithTag:9+sItemTag];
        [itemview resetTitle:@"亮点已填写"];
    }
    
    // 教育经历 列表
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < userModel.educationList.count; i++) {
        Education * educationListModel = userModel.educationList[i];
        Education *educationModel = [[Education alloc]init];
        educationModel.educationId = educationListModel.educationId;
        educationModel.beginTime = educationListModel.beginTime;
        educationModel.endTime = educationListModel.endTime;
        educationModel.schoolName = educationListModel.schoolName;
        educationModel.major = educationListModel.major;
        educationModel.education = educationListModel.education;
        educationModel.remark = educationListModel.remark;
        educationModel.educationStr = [[userModel.educationList[i] expList][0] txtcontent];
//        NSMutableArray *expList = [[NSMutableArray alloc]init];
//        for (WPPathModel *remarkModel in [userModel.educationList[i] expList]) {
//            if ([remarkModel.types isEqualToString:@"txt"]) {
//                NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//                [expList addObject:str];
//            }else{
//                [expList addObject:remarkModel.txtcontent];
//            }
//        }
//        educationModel.expList = expList;
        
        educationModel.expList = [userModel.educationList[i] expList];
        
        [arr addObject:educationModel];
    }
    
    self.educationListArray = arr;
    
    if (self.educationListArray.count) {
        SPItemView *itemview = (SPItemView *)[self.view viewWithTag:10+sItemTag];
        [itemview resetTitle:@"教育经历已填写"];
    }
    
    // 工作经历数组反转
    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
    for (int i = 0; i < userModel.workList.count; i++) {
        Work * workListModel = userModel.workList[i];
        Work *workModel = [[Work alloc]init];
        workModel.workId =workListModel.workId;
        workModel.beginTime = workListModel.beginTime;
        workModel.endTime = workListModel.endTime;
        workModel.epName = workListModel.epName;
        workModel.industryId = workListModel.industryId;
        workModel.industry = workListModel.industry;
        workModel.epProperties = workListModel.epProperties;
        workModel.department = workListModel.department;
        workModel.position = workListModel.position;

        workModel.positionId = workListModel.positionId;
        workModel.remark = workListModel.remark;
        workModel.salary = workListModel.salary;
        workModel.workStr = [[workListModel expList][0] txtcontent];
        
//        NSMutableArray *expList = [[NSMutableArray alloc]init];
//        for (WPPathModel *remarkModel in [userModel.workList[i] expList]) {
//            if ([remarkModel.types isEqualToString:@"txt"]) {
//                NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//                [expList addObject:str];
//            }else{
//                [expList addObject:remarkModel.txtcontent];
//            }
//        }
//        workModel.expList = expList;
        
        workModel.expList = [userModel.workList[i] expList];
        [arr1 addObject:workModel];
    }
    
    self.workListArray = arr1;
    
    if (self.workListArray.count) {
        SPItemView *itemview = (SPItemView *)[self.view viewWithTag:11+sItemTag];
        [itemview resetTitle:@"工作经历已填写"];
    }
    
    // 默认显示预览界面
//    [self showPreview];
}


#pragma mark - UI层 显示预览界面

- (WPPersonalInfoPreview *)preview
{
    if (!_preview) {
        self.preview = [[WPPersonalInfoPreview alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
        self.preview.model = self.model;
        self.preview.photosArr = self.photosArr;
        self.preview.videosArr = self.videosArr;
        self.preview.lightspotStr =self.lightspotStr;
        self.preview.lightspotArr = self.lightspotArray;
        self.preview.educationListArr = self.educationListArray;
        self.preview.workListArr = self.workListArray;
        
        // 重新加载数据
        [self.preview reloadData];
        
        self.preview.checkPhotosBlock = ^(){
            
        };
        self.preview.checkVideosBlock = ^(NSInteger number){
            
        };
        self.preview.checkAllVideosBlock = ^(){
            
        };
        
    }
    return _preview;
}

- (UIButton *)updateBtn
{
    if (!_updateBtn) {
        _updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _updateBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
        
        _updateBtn.backgroundColor = [UIColor whiteColor];
        NSString *upload = self.setup ? @"保存":@"更新";
        [_updateBtn setTitle:upload forState:UIControlStateNormal];
        [_updateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_updateBtn setBackgroundImage:[UIImage imageWithColor:RGB(226, 226, 226) size:CGSizeMake(SCREEN_WIDTH, 44)] forState:UIControlStateHighlighted];
        
        [_updateBtn addTarget:self action:@selector(updateBtnAction:) forControlEvents:UIControlEventTouchDown];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = RGB(178, 178, 178);
        [_updateBtn addSubview:lineView];
    }
    
    return _updateBtn;
}

- (BOOL)couldnotCommit
{
    BOOL commit = YES;
    if (self.photosArr.count == 0) {
        [self.addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
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

#pragma mark  删除预览界面
- (void)deletePreview
{
    [self.preview removeFromSuperview];
    
    [self.updateBtn removeFromSuperview];
}

- (void)updateBtnAction:(UIButton *)sender
{
    
    [self updateResumeInfo];    // 更新简历信息
}


#pragma mark - 初始化界面
- (void)setupSubViews
{
    _cateTag = 0;
    [self.view addSubview:self.baseView];
    [self.baseView addSubview:self.photosView];
    [self setBodyView];
}

#pragma mark 根视图
- (UIScrollView *)baseView
{
    if (!_baseView) {
        _baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _baseView.backgroundColor = RGB(235, 235, 235);
        _baseView.contentSize = CGSizeMake(SCREEN_WIDTH, 10 + PhotoViewHeight + 10 + 18*ItemViewHeight+WorksViewHeight+10);
    }
    return _baseView;
}

#pragma mark 照片
-(UIScrollView *)photosView
{
    if (!_photosView) {
        
        _photosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, +10, SCREEN_WIDTH-28, PhotoViewHeight)];
        _photosView.backgroundColor = [UIColor whiteColor];
        _photosView.showsHorizontalScrollIndicator = NO;
        
        _addPhotosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPhotosBtn.frame = CGRectMake(10, 10, PhotoHeight, PhotoHeight);
        [_addPhotosBtn addTarget:self action:@selector(addPhotos:) forControlEvents:UIControlEventTouchUpInside];
        [_photosView addSubview:_addPhotosBtn];
        [self.addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
//        UIImageView *imageV = [[UIImageView alloc]initWithFrame:_addPhotosBtn.bounds];
//        imageV.image = [UIImage imageNamed:@"tianjia64"];
//        [_addPhotosBtn addSubview:imageV];
        
        /** 箭头 照片墙翻页 */
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-28, _photosView.top, 28, PhotoViewHeight) ImageName:@"jinru" Target:self Action:@selector(photosViewClick:)];
        
        
        
//        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-30, _photosView.top, 30, PhotoViewHeight) ImageName:@"common_icon_arrow" Target:self Action:@selector(photosViewClick:)];
        scrollBtn.backgroundColor = [UIColor whiteColor];
        [self.baseView addSubview:scrollBtn];
    }
    return _photosView;
}


#pragma mark 选择框
- (SPSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[SPSelectView alloc]initWithTop:64];
        _selectView.delegate = self;
    }
    return _selectView;
}

#pragma mark 选择日期
- (SPDateView *)dateView
{
    if (!_dateView) {
        __weak typeof(self) weakSelf = self;
        _dateView = [[SPDateView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-30, SCREEN_WIDTH, 216+30)];
        _dateView.tag=10000;
        _dateView.getDateBlock = ^(NSString *dateStr){
            SPItemView *view = (SPItemView *)[weakSelf.baseView viewWithTag:sItemTag+2];
            [view resetTitle:dateStr];
            weakSelf.model.birthday = dateStr;
        };
        
        NSString * string = self.model.birthday;
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate * date = [formatter dateFromString:string];
        if (string.length) {
            _dateView.datePickerView.date = date;
        }
    }
    return _dateView;
}

#pragma mark 子视图
- (void)setBodyView
{
    __weak typeof(self) weakSelf = self;
    
    NSArray *titleArr = @[@"姓       名:",@"性       别:",@"出生年月:",@"学       历:",
                          @"工作经验:",@"目前薪资:",@"婚姻状况:",@"户       籍:",@"现居住地:"];
    
    NSArray *placeArr = @[@"2-4个汉字或字母",@"请选择性别",@"请选择出生年月",@"请选择学历",
                         @"请选择工作经验",@"请选择目前薪资",@"请选择婚姻状况",@"请选择户籍",@"请选择现居住地"];
    
    NSArray *typeArr = @[kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeButton,
                         kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,
                         
                         kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,
                         
                         kCellTypeButton,kCellTypeButton,kCellTypeButton];
    
    UIView *lastview = nil;
    for (int i = 0; i < titleArr.count; i++) {
        SPItemView *view = [[SPItemView alloc]initWithFrame:CGRectMake(0, i*ItemViewHeight+self.photosView.bottom+10, SCREEN_WIDTH, ItemViewHeight)];
        [view setTitle:titleArr[i] placeholder:placeArr[i] style:typeArr[i]];
        
        [self.baseView addSubview:view];
        
        view.tag = i + sItemTag;
        
        view.SPItemBlock = ^(NSInteger tag){
            [weakSelf buttonItem:tag];
        };
        
        view.hideFromFont = ^(NSInteger tag, NSString *title)
        {
            if (tag == 0 + sItemTag) {
                weakSelf.model.name = title;
            }
        };
        [self.viewArr addObject:view];
        lastview = view;
    }
    
    
    
    UIView *lastview1 = [UIView new];
    lastview1.tag = sItemTag + 8;
    
    NSArray *title = @[@"个人亮点:",@"教育经历:",@"工作经历:"];
    NSArray *placeholder = @[@"请添加个人亮点",@"请添加教育经历",@"请添加工作经历"];
    for (int i = 0; i < 3; i++) {
        SPItemView *itemview = [[SPItemView alloc]initWithFrame:CGRectMake(0, i*ItemViewHeight + lastview.bottom + 10, SCREEN_WIDTH, ItemViewHeight)];
        [itemview setTitle:title[i] placeholder:placeholder[i] style:kCellTypeButton];
        [self.baseView addSubview:itemview];
        itemview.tag = lastview1.tag + 1;
        
        itemview.SPItemBlock = ^(NSInteger tag){
            [weakSelf buttonItem:tag];
        };
        
        lastview1 = itemview;
    }
    
    self.baseView.contentSize = CGSizeMake(SCREEN_WIDTH, lastview1.bottom+kListEdge);
}

#pragma mark 添加照片
-(void)addPhotos:(UIButton *)sender
{
    [self.dateView removeView];

    HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册",@"相机", nil];//,@"视频"
    sheet.tag = 789;
    [sheet show];
//    WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机",@"视频"] imageNames:nil top:64];
//    actionSheet.tag = 40;
//    [actionSheet showInView:self.view];
}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 789) {
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
    else
    {
        if (buttonIndex == 1) {
            self.model.sex = @"男";
            imageChanged=NO;
            SPItemView *view = (SPItemView *)[self.baseView viewWithTag:_cateTag];
            [view resetTitle:@"男"];
        }
        else if (buttonIndex == 2)
        {
            
            self.model.sex = @"女";
            imageChanged=NO;
            SPItemView *view = (SPItemView *)[self.baseView viewWithTag:_cateTag];
            [view resetTitle:@"女"];
        }
    }
    
}
#pragma mark 查看全部照片视频
-(void)photosViewClick:(UIButton *)sender
{
//    [self.dateView hide];
    [self.dateView removeView];
    SAYPhotoManagerViewController *vc = [[SAYPhotoManagerViewController alloc]init];
    vc.arr = self.photosArr;
    vc.videoArr = self.videosArr;
    vc.isEdit = YES;    
    vc.delegate = self;
    
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

//
//-(void)sexControlClick{
//    //设置默认为男
//    //    sexLabel.text = @"男";
//    //    sexLabel.textColor= [UIColor blackColor];
//    //性别滚筒
//    sexPickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-216, self.view.frame.size.width, 216)];
//    sexPickerView.delegate=self;
//    sexPickerView.dataSource=self;
//    
//    sexPickerView.backgroundColor=[UIColor whiteColor];
//    _proTitleList = @[@"男",@"女"];
//    [self.view addSubview:sexPickerView];
//    
//    sexBtnView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-260, SCREEN_WIDTH,44)];
//    sexBtnView.backgroundColor=[UIColor whiteColor];
//    
//    //    UILabel* label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
//    //    label1.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
//    //    [sexBtnView addSubview:label1];
//    
//    //    UILabel* label2=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
//    //    label1.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
//    //    [sexBtnView addSubview:label2];
//    [self.view addSubview:sexBtnView];
//    
//    UIButton* btn1=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);
//    [btn1 setBackgroundColor:RGB(247, 247, 247)];
//    btn1.titleLabel.font = kFONT(15);
//    btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [btn1 setTitle:@"完成" forState:UIControlStateNormal];
//    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [sexBtnView addSubview:btn1];
//    [btn1 addTarget:self action:@selector(btnClick1) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//    line.backgroundColor = RGB(160, 160, 160);
//    [btn1 addSubview:line];
//    
//    UILabel * line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
//    line2.backgroundColor = RGB(160, 160, 160);
//    [btn1 addSubview:line2];
//    
//    
//    self.model.sex = @"男";
//    SPItemView *view = (SPItemView *)[self.baseView viewWithTag:_cateTag];
//    [view resetTitle:@"男"];
//}
//-(void)btnClick1
//{
//    [sexBtnView removeFromSuperview];
//    if (sexPickerView) {
//        //移动出屏幕
//        [UIView animateWithDuration:0.3 animations:^{
//            sexPickerView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 216);
//        }];
//    }
//}
//// pickerView 每列个数
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    return [_proTitleList count];
//}
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
//// 每列宽度
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    return 40;
//}
//// 返回选中的行
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    
//    self.model.sex = _proTitleList[row];
//    imageChanged=NO;
//    SPItemView *view = (SPItemView *)[self.baseView viewWithTag:_cateTag];
//    [view resetTitle:_proTitleList[row]];
//}
////返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return _proTitleList[row];
//}
#pragma mark - 交互层
#pragma mark 选择条件
-(void)buttonItem:(NSInteger)tag
{
    _cateTag = tag;
    //此方法会自动赋值并隐藏
    //[self.dateView hide];
    //该方法只会隐藏不赋值
    [self.dateView removeView];
    [self.view endEditing:YES];
    
    switch (tag-sItemTag)
    {
        case InterviewEditItemTypeSex:
            NSLog(@"性别");
//            [self sexControlClick];
        {
            HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"男",@"女",nil];
            sheet.tag = 790;
            [sheet show];
        }
            break;

        case InterviewEditItemTypeBirthday:
            NSLog(@"出生");
            [self.dateView showInView:WINDOW];
            break;
        case InterviewEditItemTypeEducation:
            NSLog(@"学历");
            [self.selectView setLocalData:[SPLocalApplyArray educationArray]];
            break;
        case InterviewEditItemTypeWorkTimes:
            NSLog(@"工作经验");
            [self.selectView setLocalData:[SPLocalApplyArray workTimeArray]];
            break;
            
        case InterviewEditItemTypeNowSalary:
            NSLog(@"目前薪资");
            [self.selectView setLocalData:[SPLocalApplyArray salaryArray]];
            
            break;
            
        case InterviewEditItemTypeMarriage:
            NSLog(@"婚姻状况");
            [self.selectView setLocalData:[SPLocalApplyArray marriageArray]];
            break;
            
        case InterviewEditItemTypeHometown:
            NSLog(@"户籍");
            self.selectView.isIndustry = NO;
            self.selectView.isArea = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
            
        case InterviewEditItemTypeNowAddress:
            NSLog(@"现居住地");
            self.selectView.isIndustry = NO;
            self.selectView.isArea = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
            
            
        case InterviewEditItemTypeLightPoint:
            NSLog(@"个人亮点");
            [self interviewActionType:9];
            break;
        case InterviewEditItemTypeEducationList:
            NSLog(@"教育经历");
            [self interviewActionType:10];
            break;
        case InterviewEditItemTypeNowWorkList:
            NSLog(@"工作经历");
            [self interviewActionType:11];
            break;
        default:
            break;
    }
}

#pragma mark  点击个人亮点，教育经历，工作经历

- (void)interviewActionType:(NSInteger)type
{

    if (type == 9) {//个人亮点
        WPInterviewLightspotController *lightspot = [[WPInterviewLightspotController alloc]init];
        lightspot.delegate = self;
//        [lightspot.objects addObjectsFromArray:self.lightspotArray];
        lightspot.lightStr = self.lightspotString;
        lightspot.buttonString = self.lightspotStr;
        [self.navigationController pushViewController:lightspot animated:YES];
    }
    if (type == 10) {//教育经历
        //if (self.educationListArray.count) {
        WPInterviewEducationListController *educationList = [[WPInterviewEducationListController alloc]init];
        //判断是否从个人信息界面进入
        educationList.isEdit=self.isEdit;
        educationList.isFromPersonInfo = YES;
        educationList.delegate = self;
        educationList.dataSources = self.educationListArray;
        if (educationList.dataSources.count==0) {//教育经历未填写
            WPInterviewEducationController*education=[WPInterviewEducationController new];
            education.isFromPersonInfo = YES;
            [self.navigationController pushViewController:education animated:YES];
        } else {//教育经历已填写
            [self.navigationController pushViewController:educationList animated:YES];
        }
       
        //}else{
        //WPInterviewEducationController *education = [[WPInterviewEducationController alloc]init];
        //education.delegate = self;
        //[self.navigationController pushViewController:education animated:YES];
        //}
    }
    if (type == 11) {//工作经历
        //if (self.workListArray.count) {
        WPInterviewWorkListController *worklist = [[WPInterviewWorkListController alloc]init];
        NSString*iswork=  [NSString stringWithFormat:@"%ld",(long)self.isEdit];
        [[NSUserDefaults standardUserDefaults] setObject:iswork forKey:@"isworkEdit"];
        worklist.isworkEdit=_isEdit;
        worklist.delegate = self;
        worklist.isFromPersonInfo = YES;
        worklist.dataSources = self.workListArray;
        if (worklist.dataSources.count==0)//工作经历未填写
        {
            WPInterviewWorkController*work=[WPInterviewWorkController new];
            work.isFromPersonInfo = YES;
            [self.navigationController pushViewController:work animated:YES];
        }
        else//工作经历已填写
        {
           [self.navigationController pushViewController:worklist animated:YES];
        }
        
        //}else{
        //WPInterviewWorkController *worklist = [[WPInterviewWorkController alloc]init];
        //worklist.delegate = self;
        //[self.navigationController pushViewController:worklist animated:YES];
        //}
    }

}


#pragma mark - 更新照片墙
-(void)refreshPhotos
{
    for (UIView *view in self.photosView.subviews) {
        [view removeFromSuperview];
    }
    
    // 照片
    for (int i = 0; i < self.photosArr.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
        button.tag = PhotoTag+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;

        if ([self.photosArr[i] isKindOfClass:[SPPhotoAsset class]])
        {
            [button setImage:[self.photosArr[i] thumbImage] forState:UIControlStateNormal];
        }
        else
        {
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] thumb_path]]];
            [button sd_setImageWithURL:url forState:UIControlStateNormal];
        }
        
        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.photosView addSubview:button];
    }
    
    // 视频
    CGFloat width = self.photosArr.count*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12);
    for (int i = 0; i < self.videosArr.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+kHEIGHT(6))+width, 10, PhotoHeight, PhotoHeight);
        button.tag = VideoTag+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];

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
        
        // 播放按钮
        UIImageView *subImageV = [[UIImageView alloc]initWithFrame:CGRectMake(PhotoHeight/2-10, PhotoHeight/2-10, 20, 20)];
        subImageV.image = [UIImage imageNamed:@"video_play"];
        [button addSubview:subImageV];
    }
    
    if (self.photosArr.count == 8&&self.videosArr.count == 4)
    {
        self.photosView.contentSize = CGSizeMake(12*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), PhotoViewHeight);
    }
    else
    {
        NSInteger count = self.photosArr.count+self.videosArr.count;
        self.photosView.contentSize = CGSizeMake(count*(PhotoHeight+kHEIGHT(6))+PhotoHeight+kHEIGHT(12), PhotoViewHeight);
        
        // 添加图片按钮
        if (count<1) {
            [self.addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
        }else{
            [_addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
        }
        _addPhotosBtn.frame = CGRectMake(count*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
        if (count != 12) {
            [self.photosView addSubview:_addPhotosBtn];
        }
//        [self.photosView addSubview:_addPhotosBtn];
    }
}


#pragma mark 查看图片
-(void)checkImageClick:(UIButton *)sender
{
    if (sender.tag>=PhotoTag &&sender.tag <VideoTag)
    {
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < self.photosArr.count; i++)  // 头像或背景图
        {
            MJPhoto *photo = [[MJPhoto alloc]init];
            if ([self.photosArr[i] isKindOfClass:[PhotoVideo class]]) {
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] original_path]]];
                photo.url = url;
            }else{
                photo.image = [self.photosArr[i] originImage];
            }
            photo.srcImageView = [(UIButton *)[self.baseView viewWithTag:50+i] imageView];
            [arr addObject:photo];
        }
        SPPhotoBrowser *brower = [[SPPhotoBrowser alloc] init];
        brower.delegate = self;
        brower.currentPhotoIndex = sender.tag-PhotoTag;
        brower.photos = arr;
        [self.navigationController pushViewController:brower animated:YES];
//        [brower show];

    }else{
        NSLog(@"视频");
        [self checkVideos:sender.tag-VideoTag];
    }
}

#pragma mark 查看视频
-(void)checkVideos:(NSInteger)number
{
    NSLog(@"观看视频");
    VideoBrowser *video = [[VideoBrowser alloc] init];
    video.isCreat = YES;
    if ([self.vedioArray[number] isKindOfClass:[NSString class]]) {
        video.isNetOrNot = NO;
        video.videoUrl = self.vedioArray[number];
    } else if([self.vedioArray[number] isKindOfClass:[ALAsset class]]){
        ALAsset *asset = self.vedioArray[number];
        video.isNetOrNot = NO;
        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
    }else{
        video.isNetOrNot = YES;
        PhotoVideo * photoVideo = self.videosArr[number];
        video.videoUrl = [IPADDRESS stringByAppendingString:photoVideo.original_path];
//        video.videoUrl =[IPADDRESS stringByAppendingString:[self.vedioArray[number] original_path]];
    }
    [video showPickerVc:self];
//    if ([self.videosArr[number] isKindOfClass:[NSString class]])
//    {
//        NSURL *url = [NSURL fileURLWithPath:self.videosArr[number]];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
//    }
//    else if ([self.videosArr[number] isKindOfClass:[PhotoVideo class]])
//    {
//      
//    }
//    else
//    {
//        ALAsset *asset = self.videosArr[number];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
//    }
//    //指定媒体类型为文件
//    _moviePlayerVC.moviePlayer.movieSourceType = MPMovieSourceTypeFile|MPMovieSourceTypeStreaming;
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

#pragma mark - Delegate 代理

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.dateView hide];
    [self.dateView removeView];
}


#pragma mark SPPhotoBrowserDelegate
- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser deleteImageAtIndex:(NSInteger)index{
    [self.photosArr removeObjectAtIndex:index];
    [self refreshPhotos];
}

- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser coverImageAtIndex:(NSInteger)index{
    id photo = self.photosArr[index];
    [self.photosArr removeObjectAtIndex:index];
    [self.photosArr insertObject:photo atIndex:0];
    [self refreshPhotos];
}

#pragma mark  SAYPhotoManagerViewController PhotoManager代理，刷新照片墙
-(void)UpdateImageDelegate:(NSArray *)arr VideoArr:(NSArray *)videoArr
{
    [self.photosArr removeAllObjects];
    [self.photosArr addObjectsFromArray:arr];
    
    [self.videosArr removeAllObjects];
    [self.videosArr addObjectsFromArray:videoArr];
    
    [self refreshPhotos];
}

#pragma mark 选择条件 回调代理函数 ~ 刷新选择内容
-(void)SPSelectViewDelegate:(IndustryModel *)model
{
    imageChanged=NO;
    SPItemView *view = (SPItemView *)[self.baseView viewWithTag:_cateTag];
    [view resetTitle:model.industryName];
    switch (_cateTag-sItemTag) {
        case InterviewEditItemTypeSex:
            self.model.sex = model.industryName;
            break;
        case InterviewEditItemTypeBirthday:
            self.model.education = model.industryName;
            break;
            
        case InterviewEditItemTypeEducation:
            self.model.education = model.industryName;
            break;
        case InterviewEditItemTypeWorkTimes:
            self.model.workTime = model.industryName;
            break;
        case InterviewEditItemTypeNowSalary:
            self.model.nowSalary = model.industryName;
            break;
            
        case InterviewEditItemTypeMarriage:
            self.model.marriage = model.industryName;
            break;
        case InterviewEditItemTypeHometown:
            self.model.homeTown = model.industryName;
            self.model.homeTownId = model.industryID;
            break;
        case InterviewEditItemTypeNowAddress:
            self.model.address = model.industryName;
            self.model.addressId = model.industryID;
            break;
        default:
            break;
    }
}


#pragma mark WPActionSheet  Delegate
- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (sheet.tag == 40) {
        if (buttonIndex == 1) {
            [self fromAlbums];
        }
        if (buttonIndex == 2) {
            [self fromCamera];
        }
        if (buttonIndex == 3) {
            [self videoFromCamera];
        }
    }
    else
    {
        if (buttonIndex == 1) {
            //保存
            [self updateResumeInfo];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        if (buttonIndex == 2) {
            //不保存
            [self.navigationController popViewControllerAnimated:YES];
        }
       
    }
}

// 相册
- (void)fromAlbums
{
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
        
        [self refreshPhotos];
    };
}

// 拍照
- (void)fromCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
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



// 拍摄视频
- (void)videoFromCamera
{
    DBTakeVideoVC *tackVedio = [[DBTakeVideoVC alloc] init];
    tackVedio.delegate = self;
    tackVedio.fileCount = 4-self.videosArr.count;
    tackVedio.takeVideoDelegate = self;
    
    
    [self.navigationController pushViewController:tackVedio animated:YES];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tackVedio];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark DBTakeVideoVC Delegate

//  从录制界面选择Video返回
- (void)sendBackVideoWith:(NSArray *)array
{
    [self.videosArr addObjectsFromArray:array];
    [self refreshPhotos];
    //    [self.interView refreshVideos];
}

// 录制返回
- (void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
    [self.videosArr addObject:filePaht];
    [self refreshPhotos];
    //    [self.interView refreshVideos];
}

#pragma mark - WPInterviewLightspotController 个人亮点
- (void)getLightspotWithConstant:(NSString *)constant content:(NSString *)contents
{
    self.lightspotStr = constant;
//    self.lightspotArray = contents;
    self.lightspotString = contents;
    
    if (![self.lightspotStr isEqualToString:@""]|self.lightspotString.length)
    {
        SPItemView *itemview = (SPItemView *)[self.view viewWithTag:InterviewEditItemTypeLightPoint+sItemTag];
        [itemview resetTitle:@"亮点已填写"];
    }
    
}

#pragma mark  WPInterviewEducationListController 教育经历列表
- (void)getEducationList:(NSArray *)educationArray
{
    NSArray * array = [NSArray arrayWithArray:educationArray];
    [self.educationListArray removeAllObjects];
    [self.educationListArray addObjectsFromArray:array];
    if (self.educationListArray.count>0) {
        SPItemView *itemview = (SPItemView *)[self.view viewWithTag:InterviewEditItemTypeEducationList+sItemTag];
        [itemview resetTitle:@"教育经历已填写"];
   }
    else
    {
        SPItemView *itemview = (SPItemView *)[self.view viewWithTag:InterviewEditItemTypeEducationList+sItemTag];
        [itemview resetTitle:@""];
    }
       // else
//    {
//        SPItemView *itemview2 = (SPItemView *)[self.view viewWithTag:InterviewEditItemTypeEducation];
//        self.model.education = [itemview2.title isEqualToString:@"请选择教育经历"]?@"":itemview2.title;
//        
//    }
   
}
#pragma mark  WPInterviewWorkListController 工作经历
- (void)getWorkList:(NSArray *)workArray
{
    NSArray * array = [NSArray arrayWithArray:workArray];
    [self.workListArray removeAllObjects];
    [self.workListArray addObjectsFromArray:array];
    if (self.workListArray.count)
    {
        SPItemView *itemview = (SPItemView *)[self.view viewWithTag:InterviewEditItemTypeNowWorkList+sItemTag];
        [itemview resetTitle:@"工作经历已填写"];
    }
    else
    {
        SPItemView *itemview = (SPItemView *)[self.view viewWithTag:InterviewEditItemTypeNowWorkList+sItemTag];
        [itemview resetTitle:@""];
    }
}

#pragma mark - 网络层  更新求职者信息
- (void)updateResumeInfo
{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    BOOL updateImage = YES;
    
    // 照片
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
        formDatas.name = [NSString stringWithFormat:@"photoAddress%d",i];
        formDatas.filename = [NSString stringWithFormat:@"photoAddress%d.png",i];
        formDatas.mimeType = @"png";
        [arr addObject:formDatas];
        if (!formDatas.data) {
            updateImage = NO;
        }
    }
    
    // 视频
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
        formDatas.filename = [NSString stringWithFormat:@"photoAddress%lu.mp4",i+self.photosArr.count];
        formDatas.mimeType = @"video/quicktime";
        [arr addObject:formDatas];
        if (!formDatas.data) {
            updateImage = NO;
        }
    }
    
    // 教育经历
    NSMutableArray *educationsList = [[NSMutableArray alloc]init];
    int imageNumber = 0;
    for (int i = 0; i < self.educationListArray.count; i++) {
        Education *model = self.educationListArray[i];
        
        NSMutableArray *contentList = [[NSMutableArray alloc]init];
        for (int i = 0; i < model.expList.count; i++) {
            if ([model.expList[i] isKindOfClass:[NSAttributedString class]]) {//文字
                //            NSAttributedString *str = self.previewModel.textAndImage[i];
                NSString *text = [NSString stringWithFormat:@"%@",model.expList[i]];
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
                [contentList addObject:textDic];
            } else { //图片
                WPFormData *formData = [[WPFormData alloc]init];
                if ([model.expList[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                    MLSelectPhotoAssets *asset = model.expList[i];
                    UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                    formData.data = UIImageJPEGRepresentation(img, 0.5);
                }
                if ([model.expList[i] isKindOfClass:[NSString class]]) {
                    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.expList[i]]];
                    formData.data = [NSData dataWithContentsOfURL:url];
                }
                
                formData.name = [NSString stringWithFormat:@"img%d",imageNumber];
                formData.filename = [NSString stringWithFormat:@"img%d.jpg",imageNumber];
                formData.mimeType = @"application/octet-stream";
                [arr addObject:formData];//把数据流加入上传文件数组
                NSString *value = [NSString stringWithFormat:@"img%d",imageNumber];
                NSDictionary *photoDic = @{@"txt":value};
                [contentList addObject:photoDic];
                imageNumber++;
            }
            
        }
        
        NSDictionary *dic = @{@"ed_id":model.educationId,
                              @"beginTime":model.beginTime,
                              @"endTime":model.endTime,
                              @"schoolName":model.schoolName,
                              @"major":model.major,
                              @"education":model.education,
                              @"remark":@"",
                              @"epList":contentList};
        [educationsList addObject:dic];
    }
    
    // 工作经历
    NSMutableArray *workList = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.workListArray.count; i++) {
        Work *model = self.workListArray[i];
        NSMutableArray *contentList = [[NSMutableArray alloc]init];
        for (int i = 0; i < model.expList.count; i++) {
            if ([model.expList[i] isKindOfClass:[NSAttributedString class]]) {//文字
                //            NSAttributedString *str = self.previewModel.textAndImage[i];
                NSString *text = [NSString stringWithFormat:@"%@",model.expList[i]];
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
                [contentList addObject:textDic];
            } else { //图片
                WPFormData *formData = [[WPFormData alloc]init];
                if ([model.expList[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                    MLSelectPhotoAssets *asset = model.expList[i];
                    UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                    formData.data = UIImageJPEGRepresentation(img, 0.5);
                }
                if ([model.expList[i] isKindOfClass:[NSString class]]) {
                    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.expList[i]]];
                    formData.data = [NSData dataWithContentsOfURL:url];
                }
                formData.name = [NSString stringWithFormat:@"img%d",imageNumber];
                formData.filename = [NSString stringWithFormat:@"img%d.jpg",imageNumber];
                formData.mimeType = @"application/octet-stream";
                [arr addObject:formData];//把数据流加入上传文件数组
                NSString *value = [NSString stringWithFormat:@"img%d",imageNumber];
                NSDictionary *photoDic = @{@"txt":value};
                [contentList addObject:photoDic];
                imageNumber++;
            }
            
        }
        
        NSDictionary *dic = @{@"work_id":model.workId,
                              @"beginTime":model.beginTime,
                              @"endTime":model.endTime,
                              @"epName":model.epName,
                              @"Industry_id":model.industryId,
                              @"industry":model.industry,
                              
                              @"ep_properties":model.epProperties,
                              @"department":model.department,
                              
                              @"position":model.position,
                              @"position_id":model.positionId,
                              @"salary":model.salary,
                              @"remark":@"",
                              @"epList":contentList};
        [workList addObject:dic];
    }
    
    // 个人亮点
    NSMutableArray *lightspotList = [[NSMutableArray alloc]init];
    //        WPInterviewEducationModel *model = self.educationListArray[i];
    for (int i = 0; i < self.lightspotArray.count; i++) {
        if ([self.lightspotArray[i] isKindOfClass:[NSAttributedString class]]) {//文字
            //            NSAttributedString *str = self.previewModel.textAndImage[i];
            NSString *text = [NSString stringWithFormat:@"%@",self.lightspotArray[i]];
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
            [lightspotList addObject:textDic];
        } else { //图片
            //MLSelectPhotoAssets *asset = self.lightspotArray[i];
            //UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
            WPFormData *formData = [[WPFormData alloc]init];
            if ([self.lightspotArray[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                MLSelectPhotoAssets *asset = self.lightspotArray[i];
                UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                formData.data = UIImageJPEGRepresentation(img, 0.5);
            }
            if ([self.lightspotArray[i] isKindOfClass:[NSString class]]) {
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.lightspotArray[i]]];
                formData.data = [NSData dataWithContentsOfURL:url];
            }
            formData.name = [NSString stringWithFormat:@"img%d",imageNumber];
            formData.filename = [NSString stringWithFormat:@"img%d.jpg",imageNumber];
            formData.mimeType = @"application/octet-stream";
            [arr addObject:formData];//把数据流加入上传文件数组
            NSString *value = [NSString stringWithFormat:@"img%d",imageNumber];
            NSDictionary *photoDic = @{@"txt":value};
            [lightspotList addObject:photoDic];
            imageNumber++;
        }
    }
//    NSLog(@"%@,%@,%@,%@,%@,%@",self.model.name,self.model.sex,self.userModel.birthday,self.model.education,self.model.name,self.model.name)
    NSDictionary *dic = @{@"resume_user_id":(self.userModel ? _userModel.resumeUserId : @""),
                          @"resume_id":@"",
                          @"name":self.model.name,
                          @"sex":self.model.sex,
     
                          @"birthday":self.model.birthday,
                          
                          @"education":self.model.education,
                          @"WorkTime":self.model.workTime,
                          @"homeTown":self.model.homeTown,
                          @"homeTown_id":self.model.homeTownId,
                          
                          @"address":self.model.address,
                          @"Address_id":self.model.addressId,
                          
                          @"Tel":self.model.tel,
                          @"lightspot":self.lightspotStr,
                          @"nowSalary":self.model.nowSalary,
                          @"marriage":self.model.marriage,
                          @"webchat":self.model.webchat,
                          @"qq":self.model.qq,
                          @"email":self.model.email,
                          
                          @"lightspotList":lightspotList,
                          @"educationList":educationsList,
                          @"workList":workList};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *PhotoNum = updateImage ? [NSString stringWithFormat:@"%lu",self.photosArr.count+self.videosArr.count] : @"";
    NSString *photoCount = updateImage ? [NSString stringWithFormat:@"%lu",self.photosArr.count] : @"";
    NSString *isModify = updateImage ? @"0" : @"1";
    
    
    WPShareModel *model = [WPShareModel sharedModel];
    NSString *action;
    if (self.setup) {
        action = @"UpdateResumeUser";
    }else{
        action = (self.userModel ? @"UpdateResumeUser":@"AddChangeResume");
    }
    
    NSDictionary *params = @{@"action":action,
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.userId,
                             @"photoCount":photoCount,
                             @"fileCount":PhotoNum,
                             @"isModify":isModify,
                             @"ResumeJson":jsonString
                             };
    
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    NSLog(@"%@ : %@", urlStr, params);
    [WPHttpTool postWithURL:urlStr params:params formDataArray:arr success:^(id json) {
        NSLog(@"%@", json);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([json[@"status"] isEqualToString:@"0"])
        {
            [MBProgressHUD showSuccess:json[@"info"]];
            
            
            [self performSelector:@selector(delay) withObject:nil afterDelay:1];
        }
        else
        {
            [MBProgressHUD showError:json[@"info"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请重试"];
    }];
}

- (void)delay
{
    if (self.personModel) { // 判断是否有个人信息页面推出  如果不是 退返前一个页面
        NSArray *VCs = self.navigationController.viewControllers;
        self.delegate = VCs[2];
        [self.delegate reloadVCData];
        if (self.upDataSuccess) {
            self.upDataSuccess();
        }
        [self.navigationController popViewControllerAnimated:YES];
//        [self.navigationController popToViewController:VCs[2] animated:YES];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadVCData)]) {
            [self.delegate reloadVCData];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    //[self.delegate refreshUserListDelegate:self.model];
}



@end
