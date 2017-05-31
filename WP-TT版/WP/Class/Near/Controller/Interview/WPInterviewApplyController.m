//
//  WPInterviewApplyController.m
//  WP
//
//  Created by CBCCBC on 15/11/10.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPInterviewApplyController.h"
#import "WPInterviewApplyChooseController.h"
#import "WPInterviewApplyView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <BlocksKit+UIKit.h>
//#import <ReactiveCocoa.h>
#import <CoreMedia/CoreMedia.h>
#import "MLSelectPhotoPickerViewController.h"
#import "CTAssetsPickerController.h"
#import "SAYPhotoManagerViewController.h"
#import "DBTakeVideoVC.h"
#import "MLSelectPhotoAssets.h"
#import "SPPhotoAsset.h"
#import "WPActionSheet.h"
#import "WPCompanyListModel.h"
#import "WPInterviewApplyChooseModel.h"
#import "WPCompanyBriefController.h"
#import "ActivityTextEditingController.h"
#import "SPItemView.h"
#import "PYActionSheet.h"
#import "HJCActionSheet.h"
#import "SPPhotoBrowser.h"
#import "WPcompanyInfoViewController.h"
#import "WPMySecurities.h"
#import "VideoBrowser.h"
#import "SPRecPreview.h"
#import "WPRecruitiew.h"
@interface WPInterviewApplyController () <WPActionSheet,callBackVideo,takeVideoBack,CTAssetsPickerControllerDelegate,UpdateImageDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WPInterviewApplyChooseUserDelegate,WPCompanyBriefDelegate,UIAlertViewDelegate,HJCActionSheetDelegate,getCompamyInfo>

@property (strong, nonatomic) WPInterviewApplyView *interviewApplyView;
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayerVC;
@property (copy, nonatomic) NSArray *applyArray;
@property (copy, nonatomic) NSString *applyCondition;
@property (strong, nonatomic) UIButton *retryBtn;

@property (nonatomic, strong) NSArray *briefArray;
@property (nonatomic, strong) NSString *jobstatus; /**< 招聘状态 */

@property (nonatomic, assign)BOOL isPhoto;
@property (nonatomic, assign)BOOL isCompany;
@property (nonatomic, assign)BOOL isZhaoPin;

@property (nonatomic, copy) NSString * companyInfo;//选择的企业招聘id

@property (nonatomic, assign) BOOL isChoised;//选择的
@property (nonatomic, assign) BOOL changeResume;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) SPRecPreview *recPreview;
@property (nonatomic, copy) NSString * is_update;
@property (nonatomic, strong) UIButton * bottomBtn;

@end

@implementation WPInterviewApplyController
{
    BOOL telephoneShowed;   //手机号码显示或隐藏
}
#pragma mark -- 该页面推出有全职 点击cell->面试 点击cell->求职简历 点击抢人->

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:nil];
    [self.view addGestureRecognizer:pan];
    
    
    
    self.title = @"抢人";
    telephoneShowed = NO;
    WS(ws);
    _interviewApplyView = [[WPInterviewApplyView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    //判断哪些必填项没有数据
    _interviewApplyView.telephoneNumShowOrHiddenBlock = ^(BOOL showed){
        telephoneShowed = showed;
    };
    _interviewApplyView.isPhoto= ^(BOOL isOrNot){
        _isPhoto = isOrNot;
    };
    _interviewApplyView.isCompany= ^(BOOL isOrNot){
        _isCompany = isOrNot;
    };
    _interviewApplyView.isZhaoPin= ^(BOOL isOrNot){
        _isZhaoPin = isOrNot;
    };
    
    __weak typeof(self) weakSele = self;
    _interviewApplyView.clickImage = ^(NSArray *imageArray,NSInteger firstInter,NSInteger secondInter){
                SPPhotoBrowser *brower = [[SPPhotoBrowser alloc] init];
                brower.delegate = weakSele;
                brower.currentPhotoIndex = firstInter-secondInter;
                brower.photos = imageArray;
        [ws.navigationController pushViewController:brower animated:YES];
    };
    _interviewApplyView.addPhotoBlock = ^(){
        [ws addPhotos];
    };
    _interviewApplyView.addBackBlock = ^(){
        [ws addBackView];
    };
    
    _interviewApplyView.checkVideoBlock = ^(NSInteger videoTag){
        [ws checkVideos:videoTag];
    };
    _interviewApplyView.checkALlBlock = ^(){
        [ws photosViewClick];
    };
    
    
    _interviewApplyView.InterviewApplyBlock = ^(WPInterviewType type){
        [ws pushSubViewController:type];
    };
    
#pragma mark 点击  选择招聘信息
    __weak typeof(_interviewApplyView) weakSelf = _interviewApplyView;
    _interviewApplyView.pushSubController = ^(){
        weakSelf.chooseView.backgroundColor = RGB(226, 226, 226);;
        WPInterviewApplyChooseController *choose = [[WPInterviewApplyChooseController alloc]init];
        choose.choiseJobId = ws.companyInfo;
        
        choose.sid = ws.sid;
        choose.isFix = ws.isFix;
        choose.delegate = ws;
        choose.isFromDetail = ws.isFromDetail;
        choose.isFromList = ws.isFromList;
        
        choose.personIsFromDetail = ws.personIsFromDetail;
        choose.personDetailList = ws.personDetailList;
        
         choose.personalApply = ws.personalApply;//从个人申请中抢人
        choose.personalApplyList = ws.personalApplytList;
        choose.isFromMyRob = ws.isFromMyRob;
        
        choose.isFromMyRobList = ws.isFromMyRobList;
        choose.isFromCollection = ws.isFromCollection;
        choose.isFromMuchCollection = ws.isFromMuchCollection;
        
        [ws.navigationController pushViewController:choose animated:YES];
    };
    [self requestGetApplyCondition];
    _retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _retryBtn.size = CGSizeMake(100, 50);
    _retryBtn.center = self.view.center;
    _retryBtn.hidden = YES;
    [_retryBtn setTitle:@"点击重试" forState:UIControlStateNormal];
    [_retryBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
    [_retryBtn addTarget:self action:@selector(requestGetApplyCondition) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_retryBtn];
}
-(UIButton*)bottomBtn
{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
        [_bottomBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        _bottomBtn.titleLabel.font = kFONT(15);
        [_bottomBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
        [_bottomBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 4)];
        [_bottomBtn addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
        [_bottomBtn addTarget:self action:@selector(submitResumeClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_bottomBtn setImage:[UIImage imageNamed:@"qz_fabu"] forState:UIControlStateNormal];
//        [_bottomBtn setImage:[UIImage imageNamed:@"qz_fabu"] forState:UIControlStateHighlighted];
        [_bottomBtn setBackgroundColor:RGB(0, 172, 255)];
    }
    return _bottomBtn;
}
-(void)clickDown:(UIButton*)sender
{
    [sender setBackgroundColor:RGB(0, 146, 217)];
}
#pragma mark 发布简历
- (void)submitResumeClick:(UIButton *)sender
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"企业招聘信息已创建成功，是否发布给求职者？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 298;
    [alert show];

}
#pragma mark  点击查看单个图片的代理
- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser deleteImageAtIndex:(NSInteger)index{
    [_interviewApplyView.photosArray removeObjectAtIndex:index];
    [_interviewApplyView updatePhotoView];
}

- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser coverImageAtIndex:(NSInteger)index{
    id photo = _interviewApplyView.photosArray[index];
    [_interviewApplyView.photosArray removeObjectAtIndex:index];
    [_interviewApplyView.photosArray insertObject:photo atIndex:0];
    [_interviewApplyView updatePhotoView];
}


- (void)getCompanyInfoWithModel:(WPInterviewApplyChooseDetailModel *)model
{
    _detailModel = model;
}

- (void)setDetailModel:(WPInterviewApplyChooseDetailModel *)detailModel{
    _detailModel = detailModel;
}

- (void)requestGetApplyCondition{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"ClickSign",@"username":model.username,@"password":model.password,@"user_id":model.dic[@"userid"],@"resume_id":@"",@"ep_id":@""};
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([json[@"status"] isEqualToString:@"0"]) {
            _retryBtn.hidden = YES;
            WPInterviewApplyChooseModel *model = [WPInterviewApplyChooseModel mj_objectWithKeyValues:json];
            [self setupSubView:model];
        }else{
            _retryBtn.hidden = NO;
            [self.view bringSubviewToFront:_retryBtn];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        _retryBtn.hidden = NO;
        [self.view bringSubviewToFront:_retryBtn];
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)setupSubView:(WPInterviewApplyChooseModel *)model{
    
    self.applyCondition = model.apply_Condition;
    if ([model.apply_Condition hasPrefix:@"/"]) {
        model.apply_Condition = [model.apply_Condition substringFromIndex:1];
    }
    if ([model.apply_Condition hasSuffix:@"/"]) {
        model.apply_Condition = [model.apply_Condition substringToIndex:model.apply_Condition.length-1];
    }
    NSArray *array = [model.apply_Condition componentsSeparatedByString:@"/"];
    self.applyArray = [WPInterviewApplyView getApplyConditionIndexesInArray:array];
    [_interviewApplyView startLayoutSubViews:model];
    if (_detailModel) {
       _interviewApplyView.listModel = _detailModel;
    }
    
    [self.view addSubview:_interviewApplyView];
    
    [self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"完成"];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
}

//- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
//{
//    
//}
- (NSArray *)applyArray{
    if (!_applyArray) {
        _applyArray = [[NSArray alloc]init];
    }
    return _applyArray;
}

- (NSArray *)briefArray{
    if (!_briefArray) {
        _briefArray = [[NSArray alloc]init];
    }
    return _briefArray;
}

- (void)backToFromViewController:(UIButton *)sender{
    if (self.isEdit) {
        [SPAlert alertControllerWithTitle:@"提示" message:@"确认取消抢人?" superController:self cancelButtonTitle:@"取消" cancelAction:nil defaultButtonTitle:@"确认" defaultAction:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
//        self.isEdit = NO;
//        [self.recPreview removeFromSuperview];
//        [self.bottomBtn removeFromSuperview];
//        [self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"完成"];
//        return;
    }
    
    
    
    if ([self judgeMessageExisted]) {
        [SPAlert alertControllerWithTitle:@"提示" message:@"确认取消抢人?" superController:self cancelButtonTitle:@"取消" cancelAction:nil defaultButtonTitle:@"确认" defaultAction:^{
            [self.navigationController popViewControllerAnimated:YES];
//            if ([self.navigationController.viewControllers[2] isKindOfClass:[self class]]) {
//                [self.navigationController popViewControllerAnimated:YES];
//            }else{
//                [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
//            }
        }];
    }else{
//        if (self.isFix)
//        {
            [self.navigationController popViewControllerAnimated:YES];
//        }
//        else
//        {
//            if ([self.navigationController.viewControllers[2] isKindOfClass:[self class]]) {
//                [self.navigationController popViewControllerAnimated:YES];
//            }else{
//                [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
//            }
//        }
    }
    //[self saveResumeDraft];
}

- (void)pushSubViewController:(WPInterviewType)type{
    if (type == WPInterviewTypeCompanyBrief) {
        WS(ws);
        ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
        editing.title = @"企业描述";
        editing.textFieldString = ws.interviewApplyView.model.companyBrief;
        editing.verifyClickBlock = ^(NSAttributedString *attributedString){
            ws.interviewApplyView.model.companyBrief = attributedString;
            if (ws.interviewApplyView.model.companyBrief.length) {
                SPItemView *item = (SPItemView *)[ws.interviewApplyView viewWithTag:WPInterviewApplyViewActionTypeCompanyBrief];
                [item resetTitle:@"企业描述已填写"];
            }
            else
            {
                SPItemView *item = (SPItemView *)[ws.interviewApplyView viewWithTag:WPInterviewApplyViewActionTypeCompanyBrief];
                [item resetTitle:@""];
            }
        };
        [ws.navigationController pushViewController:editing animated:YES];
//        WPCompanyBriefController *brief = [[WPCompanyBriefController alloc]init]
//        brief.delegate = self;
//        [brief.objects addObjectsFromArray:self.briefArray];
//        [self.navigationController pushViewController:brief animated:YES];
    }
    if (type == WPInterviewTypeRequire) {
        WS(ws);
        ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
        editing.attributedString = ws.interviewApplyView.model.requireString;
        //            editing.attributedString = [[NSAttributedString alloc] initWithAttributedString:ws.recruitView.model.requireString];
        editing.title = @"任职要求";
        editing.textFieldString = ws.interviewApplyView.model.requstString;
        editing.verifyClickBlock = ^(NSAttributedString *attributedString){
            ws.interviewApplyView.model.requstString = attributedString;
            if (ws.interviewApplyView.model.requstString.length) {
                SPItemView *item = (SPItemView *)[ws.interviewApplyView viewWithTag:WPInterviewApplyViewActionTypeCompanyEmail];
                [item resetTitle:@"任职要求已填写"];
            }
            else
            {
                SPItemView *item = (SPItemView *)[ws.interviewApplyView viewWithTag:WPInterviewApplyViewActionTypeCompanyEmail];
                [item resetTitle:@""];
            }
           
        };
        [ws.navigationController pushViewController:editing animated:YES];
    }
}

#pragma mark 点击完成 / 点击编辑 ---> 右上角按钮
- (void)rightButtonAction:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"完成"])//点击完成
    {
        if ([_interviewApplyView isAnyItemIsNil]) {
            if (_isPhoto || _isCompany) {
                CGPoint point = CGPointMake(0, 0);
                [_interviewApplyView.baseView setContentOffset:point animated:YES];
                _isPhoto = NO;
                _isCompany = NO;
            }
            else if (_isZhaoPin)
            {
                CGPoint point = CGPointMake(0, _interviewApplyView.photoBaseView.bottom+kListEdge);
                [_interviewApplyView.baseView setContentOffset:point animated:YES];
                _isZhaoPin = NO;
            }
            return;
        }
        [self AddrecPreview];
        [self.view addSubview:self.bottomBtn];
        [self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"编辑"];
    }
    else//点击编辑
    {
        self.isEdit = NO;
        [self.recPreview removeFromSuperview];
        [self.bottomBtn removeFromSuperview];
        [self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"完成"];
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"企业招聘信息已创建成功，是否发布给求职者？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//        alert.tag = 298;
//        [alert show];
        
        
//        NSString * shelvesDown = nil;
//        if (_interviewApplyView.changeResume) {//修改简历
//            self.is_update = @"0";
//            shelvesDown = @"0";
//        }
//        else
//        {
//          self.is_update = @"1";
//            if (self.isChoised) {
//                shelvesDown = @"0";
//            }
//            else
//            {
//              shelvesDown = @"1";
//            }
//        }
//        self.jobstatus = @"0";
//        [self commitActionWithShelvesDown:shelvesDown];
    }
}

- (void )AddrecPreview{
    self.isEdit = YES;
   self.recPreview = [[SPRecPreview alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    self.recPreview.isAddShare = YES;
    __weak typeof(self) weakSelf = self;
    self.recPreview.checkVideosBlock = ^(NSInteger num){
//        [weakSelf checkVideos:num];
    };
    
    self.recPreview.checkAllVideosBlock = ^(){
//        [weakSelf checkAllVideosBlock:NO];
    };
    
    NSMutableArray *recruitArr = [[NSMutableArray alloc]init];
    WPRecEditModel * editModel = [[WPRecEditModel alloc]init];
    editModel.jobPositon = _interviewApplyView.model.recruitPosition.length?_interviewApplyView.model.recruitPosition:@"";
    editModel.jobIndustry = @"";
    editModel.salary = _interviewApplyView.model.recruitSalary.length?_interviewApplyView.model.recruitSalary:@"";
    editModel.epRange = _interviewApplyView.model.companyWelfare.length?_interviewApplyView.model.companyWelfare:@"";
    editModel.workTime = _interviewApplyView.model.workTime.length?_interviewApplyView.model.workTime:@"";
    editModel.education = _interviewApplyView.model.education.length?_interviewApplyView.model.education:@"";
    editModel.sex = _interviewApplyView.model.sex.length?_interviewApplyView.model.sex:@"";
    editModel.age = _interviewApplyView.model.age.length?_interviewApplyView.model.age:@"";
    editModel.Tel = _interviewApplyView.model.telphone.length?_interviewApplyView.model.telphone:@"";
    editModel.invitenumbe = _interviewApplyView.model.recruitNumber.length?_interviewApplyView.model.recruitNumber:@"";
    editModel.workAddress = _interviewApplyView.model.workAddress.length?_interviewApplyView.model.workAddress:@"";
    editModel.workAdS = _interviewApplyView.model.workAddressDetail.length?_interviewApplyView.model.workAddressDetail:@"";
    editModel.requstString = _interviewApplyView.model.requstString.length?_interviewApplyView.model.requstString:@"";
    [recruitArr addObject:editModel];
    
    
    
    WPRecruitPreviewModel *model = [[WPRecruitPreviewModel alloc]init];
    model.photosArr = self.interviewApplyView.photosArray;
    model.videosArr = self.interviewApplyView.videosArray;
    model.recruitResumeArr = recruitArr;
    WPCompanyListModel * listModel = [[WPCompanyListModel alloc]init];
    listModel.epId = @"";
    listModel.userId = @"";
    listModel.enterpriseName = _interviewApplyView.model.companyName.length?_interviewApplyView.model.companyName:@"";
    listModel.dataIndustry = _interviewApplyView.model.companyIndusty.length?_interviewApplyView.model.companyIndusty:@"";
    listModel.dataIndustryId = _interviewApplyView.model.companyIndustyId.length?_interviewApplyView.model.companyIndustyId:@"";
    listModel.enterpriseProperties = _interviewApplyView.model.companyProperties.length?_interviewApplyView.model.companyProperties:@"";
    listModel.enterpriseScale = _interviewApplyView.model.companyScale.length?_interviewApplyView.model.companyScale:@"";
    listModel.enterprisePersonName = _interviewApplyView.model.personName.length?_interviewApplyView.model.personName:@"";
    listModel.enterpriseAddress = @"";
    listModel.enterpriseDewtailAddress = @"";
    listModel.enterpriseBrief = _interviewApplyView.model.companyBrief.length?_interviewApplyView.model.companyBrief:@"";
    listModel.enterpriseWebsite = _interviewApplyView.model.companyWesite.length?_interviewApplyView.model.companyWesite:@"";
    listModel.jobPositon = _interviewApplyView.model.recruitPosition.length?_interviewApplyView.model.recruitPosition:@"";
    listModel.salary = _interviewApplyView.model.recruitSalary.length?_interviewApplyView.model.recruitSalary:@"";
    listModel.epRange = _interviewApplyView.model.companyWelfare.length?_interviewApplyView.model.companyWelfare:@"";
    listModel.workTime = _interviewApplyView.model.workTime.length?_interviewApplyView.model.workTime:@"";
    listModel.education = _interviewApplyView.model.education.length?_interviewApplyView.model.education:@"";
    listModel.enterprisePhone = _interviewApplyView.model.telphone.length?_interviewApplyView.model.telphone:@"";
    listModel.sex = _interviewApplyView.model.sex.length?_interviewApplyView.model.sex:@"";
    listModel.age = _interviewApplyView.model.age.length?_interviewApplyView.model.age:@"";
    listModel.invitenumbe = _interviewApplyView.model.recruitNumber.length?_interviewApplyView.model.recruitNumber:@"";
    listModel.workAdS = _interviewApplyView.model.workAddressDetail.length?_interviewApplyView.model.workAddressDetail:@"";
    listModel.workAddress = _interviewApplyView.model.workAddress.length?_interviewApplyView.model.workAddress:@"";
    listModel.Require = _interviewApplyView.model.requstString.length?_interviewApplyView.model.requstString:@"";
    model.listModel = listModel;
    self.recPreview.model = model;
    [self.view addSubview:self.recPreview];
}



- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 298 && buttonIndex == 1) {
        NSString * shelvesDown = nil;
        if (_interviewApplyView.changeResume) {//修改简历
            self.is_update = @"0";
            shelvesDown = @"0";
        }
        else
        {
            self.is_update = @"1";
            if (self.isChoised) {
                shelvesDown = @"0";
            }
            else
            {
                shelvesDown = @"1";
            }
        }
        self.jobstatus = @"0";
        [self commitActionWithShelvesDown:shelvesDown];
    }
    
    
    NSLog(@"%ld",buttonIndex);
//    NSString *shelvesDown;
//    if (buttonIndex) {
//        shelvesDown = @"0";
//        self.jobstatus = @"0";
//        
//    }else{
//         shelvesDown = @"1";
//        self.jobstatus = @"0";
//    }
//    [self commitActionWithShelvesDown:shelvesDown];
}

- (void)commitActionWithShelvesDown:(NSString *)shelvesDown
{
    [self applyWithshelvesDown:shelvesDown];
    if (self.delegate && [self.delegate respondsToSelector:@selector(isAlready)]) {
        [self.delegate isAlready];
    }
}

#pragma mark - 报名
- (void)applyWithshelvesDown:(NSString *)shelvesDown{
    
    BOOL updateImage = YES;
    
    //上传数据流数组
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
//    WPFormData *formDatas = [[WPFormData alloc]init];
//    formDatas.data = UIImageJPEGRepresentation(_interviewApplyView.backBtn.imageView.image, 0.5);
//    formDatas.name = @"background";
//    formDatas.filename = @"background.png";
//    formDatas.mimeType = @"image/png";
//    (formDatas.data?[arr addObject:formDatas]:0);
    
    for (int i = 0; i < self.interviewApplyView.photosArray.count; i++) {
        WPFormData *formDatas = [[WPFormData alloc]init];
        //        formDatas.data = UIImageJPEGRepresentation([self.interView.photosArr[i] originImage], 0.5);
        UIImage *image;
        if ([self.interviewApplyView.photosArray[i] isKindOfClass:[SPPhotoAsset class]]) {
            image = [self.interviewApplyView.photosArray[i] originImage];
            formDatas.data = UIImageJPEGRepresentation(image, 0.5);
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.interviewApplyView.photosArray[i] original_path]]]];
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
    
    for (int i =0; i < self.interviewApplyView.videosArray.count; i++) {
        WPFormData *formDatas = [[WPFormData alloc]init];
        if ([self.interviewApplyView.videosArray[i] isKindOfClass:[NSString class]]) {
            NSData *data = [NSData dataWithContentsOfFile:self.interviewApplyView.videosArray[i]];
            formDatas.data = data;
        } else if([self.interviewApplyView.videosArray[i] isKindOfClass:[ALAsset class]]){
            ALAsset *asset = self.interviewApplyView.videosArray[i];
            //将视频转换成NSData
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            formDatas.data = data;
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.interviewApplyView.videosArray[i] original_path]]]];
            formDatas.data = data;
        }
        formDatas.name = [NSString stringWithFormat:@"photoAddress%lu",i+self.interviewApplyView.photosArray.count];
        formDatas.filename = [NSString stringWithFormat:@"photoAddress%lu.mp4",i+self.interviewApplyView.photosArray.count];
        formDatas.mimeType = @"video/quicktime";
        [arr addObject:formDatas];
        if (!formDatas.data) {
            updateImage = NO;
        }
    }
    
    NSMutableArray *briefList = [[NSMutableArray alloc]init];
    
    //        WPInterviewEducationModel *model = self.educationListArray[i];
//    for (int i = 0; i < self.briefArray.count; i++) {
//        if ([self.briefArray[i] isKindOfClass:[NSAttributedString class]]) {//文字
//            NSString *text = [NSString stringWithFormat:@"%@",self.briefArray[i]];
//            NSArray *arr = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
//            //            NSLog(@"%@----%lu",arr,(unsigned long)arr.count);
//            NSMutableArray *attStr = [NSMutableArray array];
//            NSInteger index = (arr.count - 1)/2;
//            for (int j = 0 ; j<index; j++) {
//                NSString *detail = arr[2*j];
//                NSString *attribute = arr[2*j+1];
//                NSDictionary *attibuteTex = @{@"detail" : detail,
//                                              @"attribute" : attribute};
//                [attStr addObject:attibuteTex];
//            }
//            NSDictionary *textDic = @{@"txt": attStr};//attStr
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
//            [arr addObject:formData];//把数据流加入上传文件数组
//            NSString *value = [NSString stringWithFormat:@"img%d",i];
//            NSDictionary *photoDic = @{@"txt":value};
//            [briefList addObject:photoDic];
//        }
//    }
    WPInterviewApplyModel *model = _interviewApplyView.model;
    NSDictionary * dic = @{@"txt":model.companyBrief};
    [briefList addObject:dic];
    
    //转换成字典上传
    NSString *text = [NSString stringWithFormat:@"%@",model.requireString];
    NSArray *arr1 = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
    NSMutableArray *attStr = [NSMutableArray array];
    NSInteger index = (arr1.count - 1)/2;
    for (int j = 0 ; j<index; j++) {
        NSString *detail = arr1[2*j];
        NSString *attribute = arr1[2*j+1];
        NSDictionary *attibuteTex = @{@"detail" : detail,
                                      @"attribute" : attribute};
        [attStr addObject:attibuteTex];
    }
    
    NSDictionary *jsonInfo = @{
//                               @"ep_id":(_interviewApplyView.listModel.ep_id?_interviewApplyView.listModel.ep_id:@""),
                               @"job_id":self.jobId.length?self.jobId:@"",//self.sid
//                               @"resume_id":self.sid,
                               @"workTime":model.workTime.length?model.workTime:@"",
                               @"education":model.education.length?model.education:@"",
                               @"sex":model.sex.length?model.sex:@"",
                               @"age":model.age.length?model.age:@"",
                               @"jobPositon":model.recruitPosition.length?model.recruitPosition:@"",
                               @"jobPositonID":model.recruitPositionId.length?model.recruitPositionId:@"",
                               @"salary":model.recruitSalary.length?model.recruitSalary:@"",
                               @"epRange":model.companyWelfare.length?model.companyWelfare:@"",
                               @"workAddress":model.workAddress.length?model.workAddress:@"",
                               @"workAddressID":model.workAddressId.length?model.workAddressId:@"",
                               @"workAdS":model.workAddressDetail.length?model.workAddressDetail:@"",
                               @"invitenumbe":model.recruitNumber.length?model.recruitNumber:@"",
                               @"longitude":@"",
                               @"latitude":@"",
                               @"Tel":model.companyPhone.length?model.companyPhone:model.telphone,
                               @"TelIsShow":telephoneShowed?@"0":@"1",
                               @"Require":model.requstString.length?model.requstString:@"",
                               @"ep_id":(_interviewApplyView.listModel.ep_id.length?_interviewApplyView.listModel.ep_id:@""),
                               @"enterprise_name":model.companyName.length?model.companyName:@"",
                               @"dataIndustry":model.companyIndusty.length?model.companyIndusty:@"",
                               @"dataIndustry_id":model.companyIndustyId.length?model.companyIndustyId:@"",
                               @"enterprise_properties":model.companyProperties.length?model.companyProperties:@"",
                               @"enterprise_scale":model.companyScale.length?model.companyScale:@"",
                               @"enterprise_addressID": model.companyAddressId.length?model.companyAddressId:@"",
                               @"enterprise_address": model.companyAddress.length?model.companyAddress:@"",
                               @"enterprise_ads":model.companyDetailAddress.length?model.companyDetailAddress:@"",
                               @"enterprise_personName": model.personName.length?model.personName:@"",
                               @"enterprise_personTel": model.telphone.length?model.telphone:@"",
                               @"enterprise_brief":model.companyBrief.length?model.companyBrief:@"",
//                               @"industry":model.recruitIndusty,
//                               @"Industry_id":model.recruitIndustyId,
//                               @"enterprise_phone": model.companyPhone,
//                               @"enterprise_qq": model.companyQQ,
//                               @"enterprise_email": model.companyEmail,
//                               @"enterprise_webchat": model.companyWeChat,
                               @"enterprise_website": model.companyWesite.length?model.companyWesite:@"",
                               @"epRemarkList":briefList,
                               };

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    WPShareModel *shareModel = [WPShareModel sharedModel];
    NSDictionary *parmas = @{@"action":@"ApplicationResume",
                             @"username":shareModel.username,
                             @"password":shareModel.password,
                             @"user_id":shareModel.userId,
                             @"resume_id":self.sid,
                             @"background":@"",
                             @"FileCount":[NSString stringWithFormat:@"%d",(int)arr.count],
                             @"PhotoCount":[NSString stringWithFormat:@"%d",(int)self.interviewApplyView.photosArray.count],
                             @"isModify":(updateImage?@"0":@"1"),
                             @"JobJsonList":jsonString,
                             @"shelvesDown":shelvesDown,
                             @"jobstatus" : self.jobstatus,
                             @"is_update":self.is_update};
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:str params:parmas formDataArray:(updateImage?arr:nil) success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (![json[@"status"] integerValue]) {
//            if ([self.delegate respondsToSelector:@selector(interviewApplyDelegate)]) {
//                [self.delegate interviewApplyDelegate];
//            }
//            [self.navigationController popViewControllerAnimated:YES];
            
            if (self.robSuccess) {
                self.robSuccess();
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationApplySucceed" object:nil];
            if ([self.navigationController.viewControllers[2] isKindOfClass:[self class]]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
            }
        }else{
            [MBProgressHUD showError:json[@"info"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",error.localizedDescription);
    }];
    
}


#pragma mark 保存简历草稿
- (void)saveResumeDraft
{
    WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"保存草稿",@"不保存草稿",@"取消"] imageNames:nil top:64];
    actionSheet.tag = 60;
    [actionSheet showInView:self.view];
}

#pragma mark 点击添加照片
-(void)addPhotos
{
//    WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机",@"视频"] imageNames:nil top:64];
//    actionSheet.tag = 40;
//    [actionSheet showInView:self.view];
    [self alertshow];
}
- (void)alertshow
{
    HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册",@"相机",@"视频", nil];
    
    [sheet show];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//  
        
    }else if (buttonIndex == 1){//
        [self fromAlbums];
    }else if (buttonIndex == 2){//
        [self fromCamera:0];
    }else if (buttonIndex == 3){//
        [self videoFromCamera];
    }
}
- (void)addBackView{
    WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机"] imageNames:nil top:64];
    actionSheet.tag = 50;
    [actionSheet showInView:self.view];
}

#pragma mark 查看全部照片视频
-(void)photosViewClick
{
    SAYPhotoManagerViewController *vc = [[SAYPhotoManagerViewController alloc]init];
    vc.arr = _interviewApplyView.photosArray;
    vc.videoArr = _interviewApplyView.videosArray;
    vc.isEdit = YES;
    vc.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

#pragma mark - WPActionSheet代理，添加照片或视频
- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (sheet.tag == 40)
    {
        if (buttonIndex == 1) {
            [self fromAlbums];
        }
        if (buttonIndex == 2) {
            [self fromCamera:0];
        }
        if (buttonIndex == 3) {
            [self videoFromCamera];
        }
    }
    else if (sheet.tag == 50)
    {
        if (buttonIndex == 2) {
            [self fromCameraSingle:2];
        }
        if (buttonIndex == 1) {
            [self fromCameraSingle:1];
        }
    }
    else if (sheet.tag == 60)
    {
        if (buttonIndex == 1)
        {
            NSLog(@"保存草稿");
        }
        else if (buttonIndex == 2)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark 拍照
- (void)fromCamera:(NSInteger)backImage {
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
        if (backImage) {
            [_interviewApplyView updateBackView:image];
        }else{
            SPPhotoAsset *asset = [[SPPhotoAsset alloc]init];
            asset.image = image;
            [_interviewApplyView.photosArray addObject:asset];
            [_interviewApplyView updatePhotoView];
            [picker dismissViewControllerAnimated:YES completion:NULL];
        }
    };
    [self presentViewController:picker animated:YES completion:NULL];
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
    int width = image.size.width;
    int height = GetHeight(width);
    UIImage *image1 = [UIImage scaleToSize:image size:CGSizeMake(width, height)];
    [_interviewApplyView updateBackView:image1];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 相册
- (void)fromAlbums {
    
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 12 - _interviewApplyView.photosArray.count;
    //        [pickerVc show];
    [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
    pickerVc.callBack = ^(NSArray *assets){
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        for (MLSelectPhotoAssets *asset in assets) {
            SPPhotoAsset *spAsset = [[SPPhotoAsset alloc]init];
            spAsset.asset = asset.asset;
            [photos addObject:spAsset];
        }
        [_interviewApplyView.photosArray addObjectsFromArray:photos];
        [_interviewApplyView updatePhotoView];
    };
}

#pragma mark 拍摄视频
-(void)videoFromCamera
{
    DBTakeVideoVC *tackVedio = [[DBTakeVideoVC alloc] init];
    tackVedio.delegate = self;
    tackVedio.fileCount = 4-_interviewApplyView.videosArray.count;
    tackVedio.takeVideoDelegate = self;
    [self.navigationController pushViewController:tackVedio animated:YES];
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tackVedio];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark 相册选择视频
-(void)videoFromAlbums
{
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = 4-_interviewApplyView.videosArray.count;
    picker.assetsFilter = [ALAssetsFilter allVideos];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark 从录制界面选择Video返回
-(void)sendBackVideoWith:(NSArray *)array
{
    [_interviewApplyView.videosArray addObjectsFromArray:array];
    [_interviewApplyView updatePhotoView];
    //    [self.interView refreshVideos];
}
#pragma mark 录制返回
-(void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
    [_interviewApplyView.videosArray addObject:filePaht];
    [_interviewApplyView updatePhotoView];
    //    [self.interView refreshVideos];
}
#pragma mark 直接选择Video返回
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [_interviewApplyView.videosArray addObjectsFromArray:assets];
    [_interviewApplyView updatePhotoView];
    //    [self.interView refreshVideos];
}

#pragma mark 查看视频
-(void)checkVideos:(NSInteger)number
{
    NSLog(@"观看视频");
 
//    if ([_interviewApplyView.videosArray[number] isKindOfClass:[NSString class]]) {
//        NSURL *url = [NSURL fileURLWithPath:_interviewApplyView.videosArray[number]];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
//    } else if([_interviewApplyView.videosArray[number] isKindOfClass:[ALAsset class]]){
//        ALAsset *asset = _interviewApplyView.videosArray[number];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
//    }else{
//        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_interviewApplyView.videosArray[number] original_path]]];
//        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
//    }
//    //指定媒体类型为文件
//    _moviePlayerVC.moviePlayer.movieSourceType = MPMovieSourceTypeFile|MPMovieSourceTypeStreaming;
//    
//    //通知中心
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPlaybackFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    
//    [self presentViewController:_moviePlayerVC animated:YES completion:^{}];
    
    VideoBrowser *video = [[VideoBrowser alloc] init];
    video.isCreat = YES;
    if ([_interviewApplyView.videosArray[number] isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL fileURLWithPath:_interviewApplyView.videosArray[number]];
        //        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
        video.isNetOrNot = NO;
        video.videoUrl = _interviewApplyView.videosArray[number];
    } else if([_interviewApplyView.videosArray[number] isKindOfClass:[ALAsset class]]){
        ALAsset *asset = _interviewApplyView.videosArray[number];
        video.isNetOrNot = NO;
        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
    }else{
        video.isNetOrNot = YES;
        video.videoUrl =[IPADDRESS stringByAppendingString:[_interviewApplyView.videosArray[number] original_path]];
        //        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.vedioArray[number] original_path]]];
        //        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    }
     [video showPickerVc:self];
    
}

- (void)onPlaybackFinished
{
    NSLog(@"onPlaybackFinished");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

#pragma mark - PhotoManager代理，刷新照片墙
-(void)UpdateImageDelegate:(NSArray *)arr VideoArr:(NSArray *)videoArr
{
    [_interviewApplyView.photosArray removeAllObjects];
    [_interviewApplyView.photosArray addObjectsFromArray:arr];
    
    [_interviewApplyView.videosArray removeAllObjects];
    [_interviewApplyView.videosArray addObjectsFromArray:videoArr];
    
    [_interviewApplyView updatePhotoView];
}

#pragma mark - 选择招聘简历回调函数
- (void)controller:(WPInterviewApplyChooseController *)controller Model:(WPInterviewApplyChooseDetailModel *)model{
    
    self.isChoised = YES;
    _interviewApplyView.isChoised = YES;
    
    if ([model.invitenumbe isEqualToString:@"0"]) {
        model.invitenumbe = @"";
    }
    _interviewApplyView.title.text = model.jobPositon;
    
    NSString * string = [WPMySecurities textFromBase64String:model.enterprise_brief];
    string = [WPMySecurities textFromEmojiString:string];
    if (string.length) {
        model.enterprise_brief = string;
    }
    
    NSString * string1 = [WPMySecurities textFromBase64String:model.Require];
    string1 = [WPMySecurities textFromEmojiString:string1];
    if (string1.length) {
        model.Require = string1;
    }
    
//    NSArray * array = model.epRemarkList;
//    for (WPRemarkModel*model in array) {
//        NSString * string = model.txtcontent;
//        string = [WPMySecurities textFromBase64String:string];
//        string = [WPMySecurities textFromEmojiString:string];
//        model.txtcontent = string;
//    }
    
    
    self.companyInfo = [NSString stringWithFormat:@"%@",model.job_id];
//    self.sid = [NSString stringWithFormat:@"%@",model.job_id];
    self.jobId = [NSString stringWithFormat:@"%@",model.job_id];
    self.interviewApplyView.listModel = model;
    WPInterviewApplyModel * interModel = self.interviewApplyView.model;
    
    interModel.companyName = model.enterprise_name;
    interModel.companyIndusty = model.dataIndustry;
    interModel.companyProperties = model.enterprise_properties;
    interModel.companyScale = model.enterprise_scale;
    interModel.companyAddress = model.enterprise_address;
    interModel.companyDetailAddress = model.enterprise_ads;
    interModel.personName = model.enterprise_personName;
    interModel.companyWesite = model.enterprise_website;
    interModel.companyBrief = model.enterprise_brief;
    interModel.recruitPosition = model.jobPositon;
    interModel.recruitSalary = model.salary;
    interModel.companyWelfare = model.epRange;
    interModel.workTime = model.workTime;
    interModel.education = model.education;
    interModel.sex = model.sex;
    interModel.age = model.age;
    interModel.recruitNumber = model.invitenumbe;
    interModel.workAddress = model.workAddress;
    interModel.workAddressDetail = model.workAdS;
    interModel.companyPhone = model.enterprise_phone;
    interModel.telphone = model.enterprise_phone;
    interModel.requstString = model.Require;
  
    //self.briefArray = model.epRemarkList;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (WPRemarkModel *remarkModel in model.epRemarkList) {
        if ([remarkModel.types isEqualToString:@"txt"]) {
            NSString * string = remarkModel.txtcontent;
            string = [WPMySecurities textFromBase64String:string];
            string = [WPMySecurities textFromEmojiString:string];
            remarkModel.txtcontent = string;
            
            NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [arr addObject:string];
        }else{
            NSString * string = remarkModel.txtcontent;
            string = [WPMySecurities textFromBase64String:string];
            string = [WPMySecurities textFromEmojiString:string];
            remarkModel.txtcontent = string;
            [arr addObject:remarkModel.txtcontent];
        }
    }
    self.briefArray = arr;
}

#pragma mark - 获取企业简介
- (void)getCompanyBrief:(NSArray *)briefArray{
    self.briefArray = briefArray;
    SPItemView *item = (SPItemView *)[self.interviewApplyView viewWithTag:WPInterviewApplyViewActionTypeCompanyBrief];
    [item resetTitle:@"企业简介已填写"];
}

#pragma mark - 判断
- (BOOL)isComplete:(NSString *)exist title:(NSString *)title type:(BOOL)isClick content:(NSString *)content{
    NSString *isContent = (isClick?title:@"");
    if ([exist integerValue]&&(!content||[content isEqualToString:isContent])) {
        return NO;
    }
    return YES;
}

- (BOOL)judgeMessageExisted{
    if (![self.interviewApplyView.model.companyName isEqualToString:@""]) {
        return YES;
    }
    if (![self.interviewApplyView.model.companyIndusty isEqualToString:@""]) {
        return YES;
    }
    if (![self.interviewApplyView.model.companyProperties isEqualToString:@""]) {
        return YES;
    }
    if (![self.interviewApplyView.model.companyScale isEqualToString:@""]) {
        return YES;
    }
    if (![self.interviewApplyView.model.companyAddress isEqualToString:@""]) {
        return YES;
    }
    if (![self.interviewApplyView.model.personName isEqualToString:@""]) {
        return YES;
    }
    if (![self.interviewApplyView.model.telphone isEqualToString:@""]) {
        return YES;
    }
    if (![self.interviewApplyView.model.recruitPosition isEqualToString:@""]) {
        return YES;
    }
    if (![self.interviewApplyView.model.recruitSalary isEqualToString:@""]) {
        return YES;
    }
    if (![self.interviewApplyView.model.companyWelfare isEqualToString:@""]) {
        return YES;
    }
    if (![self.interviewApplyView.model.workAddress isEqualToString:@""]) {
        return YES;
    }
    if (![self.interviewApplyView.model.companyPhone isEqualToString:@""]) {
        return YES;
    }
    if (![self.interviewApplyView.model.companyQQ isEqualToString:@""]) {
        return YES;
    }
    if (![self.interviewApplyView.model.companyWeChat isEqualToString:@""]) {
        return YES;
    }
    if (![self.interviewApplyView.model.companyWesite isEqualToString:@""]) {
        return YES;
    }
    if (![self.interviewApplyView.model.companyEmail isEqualToString:@""]) {
        return YES;
    }
    if (self.interviewApplyView.model.requireString) {
        return YES;
    }
    if (self.interviewApplyView.photosArray.count||self.interviewApplyView.videosArray.count) {
        return YES;
    }
    return NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIButton * button = (UIButton*)[_interviewApplyView.chooseView viewWithTag:200];
    [button setBackgroundColor:[UIColor whiteColor]];
}
// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
}
@end
