//
//  WPRecuilistApplyController.m
//  WP
//
//  Created by CBCCBC on 15/11/6.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPRecruitApplyController.h"
#import "WPRecruitApplyChooseController.h"
#import "WPRecruitApplyView.h"
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
//#import "WPRecruitApplyChooseModel.h"
#import "WPInterviewLightspotController.h"
#import "WPInterviewEducationController.h"
#import "WPInterviewWorkController.h"
#import "WPInterviewEducationListController.h"
#import "WPInterviewWorkListController.h"
#import "RequestManager.h"
#import "SPItemView.h"
#import "WPResumeWebVC.h"
#import "WPResumePreview.h"

#import "RequestManager.h"

#import "WPInterviewDraftController.h"

#import "WPResumeDraftVC.h"

#import "WPResumeUserVC.h"
#import "HJCActionSheet.h"



@interface WPRecruitApplyController () <WPActionSheet,callBackVideo,takeVideoBack,CTAssetsPickerControllerDelegate,UpdateImageDelegate,UINavigationControllerDelegate,WPResumeDraftVCDelegate,WPResumeUserDelegate,WPInterviewLightspotDelegate,WPInterviewEducationDelegate,WPInterviewWorkDelegate,WPInterviewEducationListDelegate,WPInterviewWorkListDelegate,WPResumeWebVCDelegate,HJCActionSheetDelegate>
{
    BOOL isDraft;
    BOOL updateImage;
    BOOL addChooseView;          // 是否选择
    NSInteger numberOfDraft;    // 草稿数量
    NSString *status;
    WPActionSheet *saveDraftActionSheet;     // 是否保存草稿
}

@property (nonatomic, strong) WPRecruitApplyView *recuilistApplyView;

@property (nonatomic, strong) MPMoviePlayerViewController *moviePlayerVC;
@property (nonatomic, copy) NSArray *applyArray;
@property (nonatomic, copy) NSString *applyCondition;
@property (nonatomic, strong) UIButton *retryBtn;

@property (nonatomic, copy) NSString *lightspotStr;/**< 个人亮点固定内容 */
@property (nonatomic, strong) NSArray *lightspotArray;/**< 个人亮点数组 */
@property (nonatomic, strong) NSMutableArray *educationListArray;/**< 教育经历内容数组 */
@property (nonatomic, strong) NSMutableArray *workListArray;/**< 工作经历内容数组 */

/** 草稿 */
@property (nonatomic, strong) UIButton *draftButton;
/** 发布 */
@property (nonatomic, strong) UIView *sendbottomView;

/** 预览界面背景*/
@property (nonatomic, strong) UIView *previewBg;

@end

@implementation WPRecruitApplyController
#pragma mark -- 该页面由 全职 -> 企业招聘 -> 点击申请职位 推出


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"创建求职简历";
    
    addChooseView = NO;
    numberOfDraft = 0;
    
    self.lightspotStr = @"";
    
//    [self.view addSubview:self.recuilistApplyView];
    
    [self beforeAddResumeRequest];
    //[self setRightBarButton];
    
    [self.view addSubview:self.retryBtn];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.recuilistApplyView.dateView hide];
}

- (void)beforeAddResumeRequest
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                   initWithDictionary:@{@"action":@"BeforeAddResume",
                                                        @"username":kShareModel.username,
                                                        @"password":kShareModel.password,
                                                        @"user_id":kShareModel.dic[@"userid"]}];
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        if ([json[@"resumeCount"] integerValue]) {
            addChooseView = YES;
        }
        if ([json[@"draftCount"] integerValue]) {
            numberOfDraft = [json [@"draftCount"] integerValue];
        }
        
        [self.view addSubview:self.recuilistApplyView];
        
        [self setRightBarButton];
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - 简历编辑 界面

- (WPRecruitApplyView *)recuilistApplyView
{
    if (!_recuilistApplyView) {
        WS(ws);
        ws.recuilistApplyView = [[WPRecruitApplyView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        
        ws.recuilistApplyView.addChooseView = addChooseView;
        ws.recuilistApplyView.addPhotoBlock = ^(){
            [ws addPhotos];
        };
        ws.recuilistApplyView.checkVideoBlock = ^(NSInteger videoTag){
            [ws checkVideos:videoTag];
        };
        ws.recuilistApplyView.checkALlBlock = ^(){
            [ws photosViewClick];
        };
        
        ws.recuilistApplyView.RecruitApplyViewBlock = ^(WPRecruitApplyViewType type){
            [ws pushToSubViewController:type];
        };
        
        ws.recuilistApplyView.pushSubController = ^(){
            
//            WPRecruitApplyChooseController *choose = [[WPRecruitApplyChooseController alloc]init];
//            choose.sid = ws.sid;
//            choose.delegate = ws;
            
            WPResumeUserVC *choose = [WPResumeUserVC new];
            choose.delegate = self;
//            WPResumeWebVC *VC = [[WPResumeWebVC alloc]init];
//            VC.delegate = ws;
            [ws.navigationController pushViewController:choose animated:YES];
        };
        
        if (_detailModel) {
            _recuilistApplyView.listModel = _detailModel;
        }
        
    }
    return _recuilistApplyView;
}

- (void)reloadWithModel:(WPResumeUserInfoModel *)model
{
    [self reloadResumeUserDataWithModel:model];
}

#pragma mark - 设置导航右边按钮
- (void)setRightBarButton
{
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(0, 0, 32, 44);
//    completeBtn.tag = WPRecruitControllerActionTypeNavigationItemComplete;
    [completeBtn normalTitle:@"完成" Color:RGB(0, 0, 0) Font:kFONT(14)];
    
    [completeBtn selectedTitle:@"编辑" Color:RGB(0, 0, 0)];
    [completeBtn addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *completeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:completeBtn];
    
    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
    Button.frame = CGRectMake(0, 0, 55, 44);
    [Button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    Button.tag = WPRecruitControllerActionTypeNavigationItemDrafts;
    [Button normalTitle:@"草稿" Color:RGB(0, 0, 0) Font:kFONT(14)];
    
    _draftButton = Button;
    
    
    UILabel *countTip = ({
        UILabel *label = [UILabel new];
        
        label.backgroundColor = RGB(10, 110, 210);
        label.layer.cornerRadius = 7;
        label.layer.masksToBounds = YES;

        label.font = kFONT(12);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        label;
    });
    
    if (numberOfDraft) {
        [Button addSubview:countTip];
        
        countTip.text = [NSString stringWithFormat:@"%ld",numberOfDraft];
        
        CGFloat width = [countTip.text getSizeWithFont:FUCKFONT(12) Height:20].width;
        
        [countTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(Button.mas_centerY);
            make.right.mas_equalTo(Button.mas_centerX).offset(-8);
            
            make.size.mas_equalTo(CGSizeMake(width + 8.0, 20));
        }];
        
    }
    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 13, 20, 20)];
//    label.backgroundColor = RGB(10, 110, 210);
//    label.layer.cornerRadius = 10;
//    label.layer.masksToBounds = YES;
//    label.text = [NSString stringWithFormat:@"%ld",numberOfDraft];
//    label.font = kFONT(12);
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    if (numberOfDraft) {
//        [Button addSubview:label];
//    }
    
    [Button addTarget:self action:@selector(rightDraft) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *draftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:Button];
    self.navigationItem.rightBarButtonItems = @[completeButtonItem,draftButtonItem];
    
}


- (void)rightDraft
{
//    WPInterviewDraftController *draft = [[WPInterviewDraftController alloc]init];
//    draft.delegate = self;
    
    WPResumeDraftVC *draft = [WPResumeDraftVC new];
    draft.delegate = self;
    
    [self.navigationController pushViewController:draft animated:YES];
}

- (void)rightBarButtonItemAction:(UIButton *)sender
{
    if (![self couldnotCommit]) {
        return;
    }
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        [self showPreview];
        _draftButton.hidden = YES;
    }
    else
    {
        [self removePreview];
        _draftButton.hidden = NO;
    }
}

#pragma mark 显示预览界面
- (void)showPreview
{
    // 预览界面Bg
    _previewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
    _previewBg.backgroundColor = RGB(235, 235, 235);
    _previewBg.tag = 1010;
    
    [self.view addSubview:_previewBg];
    
    
    // 预览界面
    WPResumePreview *preview = [[WPResumePreview alloc]initWithFrame:CGRectMake(0, 0, _previewBg.width, _previewBg.height -49)];
   
    preview.vc = self;
    
    preview.photosArr = self.recuilistApplyView.photosArray;
    preview.videosArr = self.recuilistApplyView.videosArray;
    
    preview.lightspotStr = self.lightspotStr;
    preview.lightspotArr = self.lightspotArray;
    
    preview.educationListArr = self.educationListArray;
    preview.workListArr = self.workListArray;
    
    
    __weak typeof(self) weakSelf = self;
    
    preview.checkPhotosBlock = ^(){
        //        [weakSelf checkPhotos:NO];
        //        [weakSelf checkAllVideosBlock:NO];
    };
    preview.checkVideosBlock = ^(NSInteger number){
        //        [weakSelf checkVideos:number];
    };
    
    preview.checkAllVideosBlock = ^(){
        //        [weakSelf photosViewClick];
    };
    
    preview.model = self.recuilistApplyView.listModel;
    
    [preview reloadData];
    
    [_previewBg addSubview:preview];
    

    
    
    // 发布按钮
    UIView *sendbottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _previewBg.height - 49, _previewBg.width, 49)];
    //sendbottomView.backgroundColor = [UIColor redColor];

    sendbottomView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(sendbottomView.width/2 - 7 -25, sendbottomView.height/2-7, 14, 14)];
    imageView.image = [UIImage imageNamed:@"publish"];
    [sendbottomView addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(imageView.right, 0, 50, 49);
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = kFONT(15);
    button.tag = 90;
    [button addTarget:self action:@selector(submitResumeClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendbottomView addSubview:button];
    
    //UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //deleteBtn.frame = CGRectMake(10, 49/2-9, 18, 18);
    //[deleteBtn setImage:[UIImage imageNamed:@"delet_info"] forState:UIControlStateNormal];
    //deleteBtn.tag = 90;
    //[deleteBtn addTarget:self action:@selector(deleteAllClick:) forControlEvents:UIControlEventTouchUpInside];
    //[_sendbottomView addSubview:deleteBtn];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, sendbottomView.bottom - 0.5, sendbottomView.width, 0.5)];
    line.backgroundColor = RGB(178, 178, 178);
    [sendbottomView addSubview:line];
    
    [_previewBg addSubview:sendbottomView];
    
}

- (void)removePreview
{
    for (UIView *view in self.view.subviews) {
//        if ([view isKindOfClass:[WPResumePreview class]]) {
//            [view removeFromSuperview];
//        }
        
        if (view.tag == 1010) {
            [view removeFromSuperview];
        }
    }
}

/*
- (void)addSendbottomView
{
    _sendbottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 49)];
    _sendbottomView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-14-10, _sendbottomView.height/2-7, 14, 14)];
    imageView.image = [UIImage imageNamed:@"publish"];
    [_sendbottomView addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(imageView.right, 0, 50, 49);
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = kFONT(15);
    button.tag = 90;
    [button addTarget:self action:@selector(submitResumeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sendbottomView addSubview:button];
    
    //UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //deleteBtn.frame = CGRectMake(10, 49/2-9, 18, 18);
    //[deleteBtn setImage:[UIImage imageNamed:@"delet_info"] forState:UIControlStateNormal];
    //deleteBtn.tag = 90;
    //[deleteBtn addTarget:self action:@selector(deleteAllClick:) forControlEvents:UIControlEventTouchUpInside];
    //[_sendbottomView addSubview:deleteBtn];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(178, 178, 178);
    [_sendbottomView addSubview:line];
    
    [_previewBg addSubview:_sendbottomView];
}
*/


#pragma mark 发布简历
- (void)submitResumeClick:(UIButton *)sender
{
    status = @"0";
    [self SubmitResume];
}



- (void)setDetailModel:(WPResumeUserInfoModel *)detailModel{
    _detailModel = detailModel;
    //    self.recuilistApplyView.listModel = _detailModel;
}

- (void)backToFromViewController:(UIButton *)sender
{
    
    if (![self judgeIsEdit]) {
        if ([self.navigationController.viewControllers[2] isKindOfClass:[self class]]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
        }
    }else{
        [self.recuilistApplyView.dateView removeFromSuperview];
        
        [self.saveResumeDraftAS showInView:self.view];

    }
    
    
}


#pragma mark - 个人亮点、教育经历、工作经历、
- (void)pushToSubViewController:(WPRecruitApplyViewType)type
{
    if (type == WPRecruitApplyViewTypeLightspot)
    {
        WPInterviewLightspotController *lightspot = [[WPInterviewLightspotController alloc]init];
        lightspot.delegate = self;
        [lightspot.objects addObjectsFromArray:self.lightspotArray];
        lightspot.buttonString = self.lightspotStr;
        [self.navigationController pushViewController:lightspot animated:YES];
    }
    else if (type == WPRecruitApplyViewTypeEducationList)
    {
        if (self.educationListArray.count) {
            WPInterviewEducationListController *educationList = [[WPInterviewEducationListController alloc]init];
            educationList.delegate = self;
            educationList.dataSources = self.educationListArray;
            [self.navigationController pushViewController:educationList animated:NO];
        }else{
            WPInterviewEducationController *education = [[WPInterviewEducationController alloc]init];
            education.delegate = self;
            [self.navigationController pushViewController:education animated:YES];
        }
    }
    else if (type == WPRecruitApplyViewTypeWorkList)
    {
        if (self.workListArray.count) {
            WPInterviewWorkListController *worklist = [[WPInterviewWorkListController alloc]init];
            worklist.delegate = self;
            worklist.dataSources = self.workListArray;
            [self.navigationController pushViewController:worklist animated:NO];
        }else{
            WPInterviewWorkController *worklist = [[WPInterviewWorkController alloc]init];
            worklist.delegate = self;
            [self.navigationController pushViewController:worklist animated:YES];
        }
    }
}



// 将图片数组转化为二进制数据
- (NSArray *)formDataWithPhotoArray:(NSArray *)array{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        WPFormData *formDatas = [[WPFormData alloc]init];
        //        formDatas.data = UIImageJPEGRepresentation([self.interView.photosArr[i] originImage], 0.5);
        UIImage *image;
        if ([array[i] isKindOfClass:[SPPhotoAsset class]]) {
            image = [array[i] originImage];
            formDatas.data = UIImageJPEGRepresentation(image, 0.5);
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:[array[i] original_path]]]];
            formDatas.data = data;
        }
        formDatas.name = [NSString stringWithFormat:@"PhotoAddres%d",i];
        formDatas.filename = [NSString stringWithFormat:@"PhotoAddres%d.png",i];
        formDatas.mimeType = @"image/png";
        [arr addObject:formDatas];
        if (!formDatas.data) {
            updateImage = NO;
        }
    }
    return arr;
}

// 将视频数组转化为二进制数据
- (NSArray *)formDataWithVideoArray:(NSArray *)array
{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i =0; i < array.count; i++) {
        WPFormData *formDatas = [[WPFormData alloc]init];
        if ([array[i] isKindOfClass:[NSString class]]) {
            NSData *data = [NSData dataWithContentsOfFile:array[i]];
            formDatas.data = data;
        } else if([array[i] isKindOfClass:[ALAsset class]]){
            ALAsset *asset = array[i];
            //将视频转换成NSData
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            formDatas.data = data;
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:[array[i] original_path]]]];
            formDatas.data = data;
        }
        formDatas.name = [NSString stringWithFormat:@"VideoAddres%d",i];
        formDatas.filename = [NSString stringWithFormat:@"VideoAddres%d.mp4",i];
        formDatas.mimeType = @"video/quicktime";
        [arr addObject:formDatas];
        if (!formDatas.data) {
            updateImage = NO;
        }
    }
    return arr;
}

- (BOOL)couldnotCommit
{
    BOOL commit = YES;
//    if (!((self.recuilistApplyView.photosArray.count != 0) || (self.recuilistApplyView.videosArray.count != 0))) {
//        commit = NO;
//    }
    if ([self.recuilistApplyView couldnotCommit])
    {
        commit = NO;
    }
    return commit;
}

#pragma mark 保存简历草稿
- (WPActionSheet *)saveResumeDraftAS
{
    NSString *string = @"";
    if (!isDraft) {
        string = @"草稿";
    }
    if (!saveDraftActionSheet)
    {
        saveDraftActionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[[NSString stringWithFormat:@"保存%@",string],[NSString stringWithFormat:@"不保存%@",string]] imageNames:nil top:64];
        saveDraftActionSheet.tag = 60;
       
    }
    
    return saveDraftActionSheet;
}


#pragma mark - 添加照片
-(void)addPhotos
{
//    WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机",@"视频"] imageNames:nil top:64];
//    actionSheet.tag = 40;
//    [actionSheet showInView:self.view];

    //底部弹出框
    HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册", @"拍照", @"视频", nil];
    sheet.tag = 40;
    // 2.显示出来
    [sheet show];
    
}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 40) {
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
}

#pragma mark 查看全部照片视频
-(void)photosViewClick
{
    SAYPhotoManagerViewController *vc = [[SAYPhotoManagerViewController alloc]init];
    vc.arr = _recuilistApplyView.photosArray;
    vc.videoArr = _recuilistApplyView.videosArray;
    vc.isEdit = YES;
    vc.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

#pragma mark - WPActionSheet代理，添加照片或视频
- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (sheet.tag == 40) {
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
    else if (sheet.tag == 60)
    {
        if (buttonIndex == 1)
        {
            status = @"1";
            [self SubmitResume];
        }
        else if (buttonIndex == 2)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    picker.bk_didCancelBlock = ^(UIImagePickerController *picker){
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    picker.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        SPPhotoAsset *asset = [[SPPhotoAsset alloc]init];
        asset.image = image;
        [_recuilistApplyView.photosArray addObject:asset];
        [_recuilistApplyView updatePhotoView];
        [_recuilistApplyView removeRedView];
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
    pickerVc.minCount = 12 - _recuilistApplyView.photosArray.count;
    //        [pickerVc show];
    [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
    
    pickerVc.callBack = ^(NSArray *assets){
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        for (MLSelectPhotoAssets *asset in assets) {
            SPPhotoAsset *spAsset = [[SPPhotoAsset alloc]init];
            spAsset.asset = asset.asset;
            [photos addObject:spAsset];
        }
        [_recuilistApplyView.photosArray addObjectsFromArray:photos];
        [_recuilistApplyView updatePhotoView];
        [_recuilistApplyView removeRedView];
    };
}

#pragma mark 拍摄视频
-(void)videoFromCamera
{
    DBTakeVideoVC *tackVedio = [[DBTakeVideoVC alloc] init];
    tackVedio.delegate = self;
    tackVedio.fileCount = 4-_recuilistApplyView.videosArray.count;
    tackVedio.takeVideoDelegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tackVedio];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    [_recuilistApplyView removeRedView];
}

#pragma mark 相册选择视频
-(void)videoFromAlbums
{
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = 4-_recuilistApplyView.videosArray.count;
    picker.assetsFilter = [ALAssetsFilter allVideos];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark 从录制界面选择Video返回
-(void)sendBackVideoWith:(NSArray *)array
{
    [_recuilistApplyView.videosArray addObjectsFromArray:array];
    [_recuilistApplyView updatePhotoView];
    //    [self.interView refreshVideos];
}
#pragma mark 录制返回
-(void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
    [_recuilistApplyView.videosArray addObject:filePaht];
    [_recuilistApplyView updatePhotoView];
    //    [self.interView refreshVideos];
}
#pragma mark 直接选择Video返回
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [_recuilistApplyView.videosArray addObjectsFromArray:assets];
    [_recuilistApplyView updatePhotoView];
    //    [self.interView refreshVideos];
}

#pragma mark 查看视频  推出视频播放页面
-(void)checkVideos:(NSInteger)number
{
    NSLog(@"观看视频");
    //    if ([_recuilistApplyView.videosArray[number] isKindOfClass:[NSString class]]) {
    //        NSURL *url = [NSURL fileURLWithPath:_recuilistApplyView.videosArray[number]];
    //        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    //    } else {
    //        ALAsset *asset = _recuilistApplyView.videosArray[number];
    //        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
    //
    if ([_recuilistApplyView.videosArray[number] isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL fileURLWithPath:_recuilistApplyView.videosArray[number]];
        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    } else if([_recuilistApplyView.videosArray[number] isKindOfClass:[ALAsset class]]){
        ALAsset *asset = _recuilistApplyView.videosArray[number];
        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:asset.defaultRepresentation.url];
    }else{
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_recuilistApplyView.videosArray[number] original_path]]];
        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
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

#pragma mark PhotoManager代理，刷新照片墙
-(void)UpdateImageDelegate:(NSArray *)arr VideoArr:(NSArray *)videoArr
{
    [_recuilistApplyView.photosArray removeAllObjects];
    [_recuilistApplyView.photosArray addObjectsFromArray:arr];
    
    [_recuilistApplyView.videosArray removeAllObjects];
    [_recuilistApplyView.videosArray addObjectsFromArray:videoArr];
    
    [_recuilistApplyView updatePhotoView];
}



#pragma mark - 用户选择，填充简历代理 WPResumeUserDelegate
- (void)reloadResumeDataWithModel:(WPResumeUserInfoModel *)model
{
    // WPPathModel与WPInterviewWorkListController里的内容不匹配；
    
    [self reloadModelData:model];
    
    [_recuilistApplyView setChooseViewName:model.name];
    
}

- (void)reloadResumeUserDataWithModel:(WPResumeUserInfoModel *)model
{
    // WPPathModel与WPInterviewWorkListController里的内容不匹配；
    self.detailModel = model;
    [self reloadModelData:model];
    
    [_recuilistApplyView setChooseViewName:model.name];
    
}

#pragma mark WPResumeDraftVC
- (void)draftReloadResumeDataWithModel:(WPResumeUserInfoModel *)model
{
    isDraft = YES;
    self.detailModel = model;
    [self reloadModelData:model];
}

- (void)reloadModelData:(WPResumeUserInfoModel *)model
{
    
    [self UpdateImageDelegate:model.photoList VideoArr:model.videoList];
    
    self.recuilistApplyView.listModel = model;
    
    // 个人亮点
    self.lightspotStr = model.lightspot;
    
    // 个人亮点列表
    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
    for (WPPathModel *remarkModel in model.lightspotList) {
        if ([remarkModel.types isEqualToString:@"txt"]) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [arr1 addObject:str];
        }else{
            [arr1 addObject:remarkModel.txtcontent];
        }
    }
    self.lightspotArray = arr1;
    
    if (![self.lightspotStr isEqualToString:@""]|self.lightspotArray.count) {
        SPItemView *itemview = (SPItemView *)[self.view viewWithTag:WPRecruitApplyViewActionTypeLightPoint];
        [itemview resetTitle:@"亮点已填写"];
    }
    
    // 教育经历 列表
    NSMutableArray *arr2 = [[NSMutableArray alloc]init];
    for (int i = 0; i < model.educationList.count; i++) {
        Education * educationListModel = model.educationList[i];
        Education *educationModel = [[Education alloc]init];
        educationModel.educationId = educationListModel.educationId;
        educationModel.beginTime = educationListModel.beginTime;
        educationModel.endTime = educationListModel.endTime;
        educationModel.schoolName = educationListModel.schoolName;
        educationModel.major = educationListModel.major;
        educationModel.education = educationListModel.education;
        educationModel.remark = educationListModel.remark;
        
        NSMutableArray *expList = [[NSMutableArray alloc]init];
        for (WPPathModel *remarkModel in [model.educationList[i] expList]) {
            if ([remarkModel.types isEqualToString:@"txt"]) {
                NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                [expList addObject:str];
            }else{
                [expList addObject:remarkModel.txtcontent];
            }
        }
        educationModel.expList = expList;
        
        [arr2 addObject:educationModel];
    }
    
    self.educationListArray = arr2;
    
    if (self.educationListArray.count) {
        SPItemView *itemview = (SPItemView *)[self.view viewWithTag:WPRecruitApplyViewActionTypeEducationList];
        [itemview resetTitle:@"教育经历已填写"];
    }
    
    
    // 工作经历数组反转
    NSMutableArray *arr3 = [[NSMutableArray alloc]init];
    for (int i = 0; i < model.workList.count; i++) {
        Work * workListModel = model.workList[i];
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
        
        NSMutableArray *expList = [[NSMutableArray alloc]init];
        for (WPPathModel *remarkModel in [model.workList[i] expList]) {
            if ([remarkModel.types isEqualToString:@"txt"]) {
                NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                [expList addObject:str];
            }else{
                [expList addObject:remarkModel.txtcontent];
            }
        }
        workModel.expList = expList;
        
        [arr3 addObject:workModel];
    }
    
    self.workListArray = arr3;
    
    if (self.workListArray.count) {
        SPItemView *itemview = (SPItemView *)[self.view viewWithTag:WPRecruitApplyViewActionTypeWorkList];
        [itemview resetTitle:@"工作经历已填写"];
    }

}


#pragma mark - 选择简历后返回代理函数
/*
- (void)controller:(WPRecruitApplyChooseController *)controller Model:(WPRecruitApplyChooseDetailModel *)model{
    self.recuilistApplyView.listModel = model;
    
    self.lightspotStr = model.lightspot;
    
    NSMutableArray *arr3 = [[NSMutableArray alloc]init];
    for (WPRecruitDraftInfoRemarkModel *remarkModel in model.lightspotList) {
        if ([remarkModel.types isEqualToString:@"txt"]) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [arr3 addObject:str];
        }else{
            [arr3 addObject:remarkModel.txtcontent];
        }
    }
    self.lightspotArray = arr3;
    
    if (![self.lightspotStr isEqualToString:@""]|self.lightspotArray.count) {
        SPItemView *itemview = (SPItemView *)[self.recuilistApplyView viewWithTag:WPRecruitApplyViewActionTypeLightPoint];
        [itemview resetTitle:@"亮点已填写"];
    }
    
    //工作经历数组反转
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < model.educationList.count; i++) {
        Educationlist * listModel = model.educationList[i];
        WPInterviewEducationModel *educationModel = [[WPInterviewEducationModel alloc]init];
        educationModel.epId =listModel.educationId;
        educationModel.beginTime = listModel.beginTime;
        educationModel.endTime = listModel.endTime;
        educationModel.schoolName = listModel.schoolName;
        educationModel.major = listModel.major;
        educationModel.education = listModel.education;
        educationModel.remark = listModel.remark;
        
        NSMutableArray *expList = [[NSMutableArray alloc]init];
        for (WPRemarkModel *remarkModel in [model.educationList[i] expList]) {
            if ([remarkModel.types isEqualToString:@"txt"]) {
                NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                [expList addObject:str];
            }else{
                [expList addObject:remarkModel.txtcontent];
            }
        }
        educationModel.epList = expList;
        
        [arr addObject:educationModel];
    }
    
    self.educationListArray = arr;
    
    if (self.educationListArray.count) {
        SPItemView *itemview = (SPItemView *)[self.recuilistApplyView viewWithTag:WPRecruitApplyViewActionTypeEducationList];
        [itemview resetTitle:@"教育经历已填写"];
    }
    
    //工作经历数组反转
    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
    for (int i = 0; i < model.workList.count; i++) {
        Worklist * listModel = model.workList[i];
        WPInterviewWorkModel *workModel = [[WPInterviewWorkModel alloc]init];
        workModel.work_id =listModel.workId;
        workModel.beginTime = listModel.beginTime;
        workModel.endTime = listModel.endTime;
        workModel.epName = listModel.epName;
        workModel.Industry_id = listModel.industryId;
        workModel.industry = listModel.industry;
        workModel.ep_properties = listModel.epProperties;
        workModel.department = listModel.department;
        workModel.position = listModel.position;
        workModel.Industry_id = listModel.industryId;
        workModel.position_id = listModel.positionId;
        workModel.remark = listModel.remark;
        workModel.salary = listModel.salary;
        
        NSMutableArray *expList = [[NSMutableArray alloc]init];
        for (WPRemarkModel *remarkModel in [model.educationList[i] expList]) {
            if ([remarkModel.types isEqualToString:@"txt"]) {
                NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                [expList addObject:str];
            }else{
                [expList addObject:remarkModel.txtcontent];
            }
        }
        workModel.epList = expList;
        
        [arr1 addObject:workModel];
    }
    
    self.workListArray = arr1;
    
    if (self.workListArray.count) {
        SPItemView *itemview = (SPItemView *)[self.recuilistApplyView viewWithTag:WPRecruitApplyViewActionTypeWorkList];
        [itemview resetTitle:@"工作经历已填写"];
    }
}
*/


#pragma mark - 个人亮点
- (void)getLightspotWithConstant:(NSString *)constant content:(NSArray *)contents{
    SPItemView *item = (SPItemView *)[self.recuilistApplyView viewWithTag:WPRecruitApplyViewActionTypeLightPoint];
    [item resetTitle:@"亮点已填写"];
    self.lightspotStr = constant;
    self.lightspotArray = contents;
}
#pragma mark - 教育经历
- (void)getEducation:(Education *)educationModel type:(WPInterviewEducationType)type{
    SPItemView *item = (SPItemView *)[self.recuilistApplyView viewWithTag:WPRecruitApplyViewActionTypeEducationList];
    [item resetTitle:@"教育经历已填写"];
    [self.educationListArray addObject:educationModel];
}

#pragma mark 教育经历列表
- (void)getEducationList:(NSArray *)educationArray{
    [self.educationListArray removeAllObjects];
    [self.educationListArray addObjectsFromArray:educationArray];
    //NSLog(@"%@",describe(self.educationListArray));
}

#pragma mark - 工作经历
- (void)getwork:(Work *)model type:(WPInterviewWorkType)type{
    SPItemView *item = (SPItemView *)[self.recuilistApplyView viewWithTag:WPRecruitApplyViewActionTypeWorkList];
    [item resetTitle:@"工作经历已填写"];
    [self.workListArray addObject:model];
}
#pragma mark 工作经历列表
- (void)getWorkList:(NSArray *)workArray{
    [self.workListArray removeAllObjects];
    [self.workListArray addObjectsFromArray:workArray];
}

#pragma mark - 判断是否填写完成
- (BOOL)isComplete:(NSString *)exist title:(NSString *)title type:(BOOL)isClick content:(NSString *)content{
    NSString *isContent = (isClick?title:@"");
    if ([exist integerValue]&&(!content||[content isEqualToString:isContent])) {
        return NO;
    }
    return YES;
}

- (BOOL)judgeIsEdit{
    WPResumeUserInfoModel *applyModel = self.recuilistApplyView.listModel;
    if (![applyModel.name isEqualToString:@""]) {
        return YES;
    }
    if (![applyModel.sex isEqualToString:@""]) {
        return YES;
    }
    if (![applyModel.birthday isEqualToString:@""]) {
        return YES;
    }
    if (![applyModel.education isEqualToString:@""]) {
        return YES;
    }
    if (![applyModel.homeTown isEqualToString:@""]) {
        return YES;
    }
    if (![applyModel.workTime isEqualToString:@""]) {
        return YES;
    }
    if (![applyModel.address isEqualToString:@""]) {
        return YES;
    }
    if (![applyModel.tel isEqualToString:@""]) {
        return YES;
    }
    if (![applyModel.hopePosition isEqualToString:@""]) {
        return YES;
    }
    if (![applyModel.hopeSalary isEqualToString:@""]) {
        return YES;
    }
    if (![applyModel.hopeWelfare isEqualToString:@""]) {
        return YES;
    }
    if (![applyModel.hopeAddress isEqualToString:@""]) {
        return YES;
    }
    if (self.recuilistApplyView.photosArray.count!= 0||self.recuilistApplyView.videosArray.count!= 0) {
        return YES;
    }
    if (![self.lightspotStr isEqualToString:@""]) {
        return YES;
    }
    if (self.lightspotArray.count) {
        return YES;
    }
    if (self.educationListArray.count) {
        return YES;
    }
    if (self.workListArray.count) {
        return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view resignFirstResponder];
}
#pragma mark -- 懒加载数组
- (NSArray *)applyArray{
    if (!_applyArray) {
        _applyArray = [[NSArray alloc]init];
    }
    return _applyArray;
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

- (NSMutableArray *)workListArray{
    if (!_workListArray) {
        _workListArray = [[NSMutableArray alloc]init];
    }
    return _workListArray;
}


#pragma mark - Networking 发布简历
- (void)SubmitResume
{
    updateImage = YES;
    //上传数据流数组
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    //将图片数组转化为二进制数据
    //    NSArray *photoArr = [self formDataWithPhotoArray:self.recuilistApplyView.photosArray];
    for (int i = 0; i < self.recuilistApplyView.photosArray.count; i++) {
        WPFormData *formDatas = [[WPFormData alloc]init];
        //        formDatas.data = UIImageJPEGRepresentation([self.interView.photosArr[i] originImage], 0.5);
        UIImage *image;
        if ([self.recuilistApplyView.photosArray[i] isKindOfClass:[SPPhotoAsset class]]) {
            image = [self.recuilistApplyView.photosArray[i] originImage];
            formDatas.data = UIImageJPEGRepresentation(image, 0.5);
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.recuilistApplyView.photosArray[i] original_path]]]];
            formDatas.data = data;
        }
        formDatas.name = [NSString stringWithFormat:@"PhotoAddres%d",i];
        formDatas.filename = [NSString stringWithFormat:@"PhotoAddres%d.png",i];
        formDatas.mimeType = @"image/png";
        [dataArr addObject:formDatas];
        if (!formDatas.data) {
            updateImage = NO;
        }
    }
    
    //    [dataArr addObject:photoArr];
    //将视频数组转化为二进制数据
    //    NSArray *videoArr = [self formDataWithVideoArray:self.recuilistApplyView.videosArray];
    for (int i =0; i < self.recuilistApplyView.videosArray.count; i++) {
        WPFormData *formDatas = [[WPFormData alloc]init];
        if ([self.recuilistApplyView.videosArray[i] isKindOfClass:[NSString class]]) {
            NSData *data = [NSData dataWithContentsOfFile:self.recuilistApplyView.videosArray[i]];
            formDatas.data = data;
        } else if([self.recuilistApplyView.videosArray[i] isKindOfClass:[ALAsset class]]){
            ALAsset *asset = self.recuilistApplyView.videosArray[i];
            //将视频转换成NSData
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            formDatas.data = data;
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.recuilistApplyView.videosArray[i] original_path]]]];
            formDatas.data = data;
        }
        formDatas.name = [NSString stringWithFormat:@"VideoAddres%d",i];
        formDatas.filename = [NSString stringWithFormat:@"VideoAddres%d.mp4",i];
        formDatas.mimeType = @"video/quicktime";
        [dataArr addObject:formDatas];
        if (!formDatas.data) {
            updateImage = NO;
        }
    }
    //    [dataArr addObject:videoArr];
    
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
                [dataArr addObject:formData];//把数据流加入上传文件数组
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
                              //@"major_id":model.majorId,
                              @"education":model.education,
                              @"remark":@"",
                              @"epList":contentList};
        [educationsList addObject:dic];
    }
    
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
                [dataArr addObject:formData];//把数据流加入上传文件数组
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
                              @"ep_properties":model.epProperties,
                              @"industry":model.industry,
                              @"department":model.department,
                              @"position":model.position,
                              @"position_id":model.positionId,
                              @"salary":model.salary,
                              @"remark":@"",
                              @"epList":contentList};
        [workList addObject:dic];
    }
    
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
            [dataArr addObject:formData];//把数据流加入上传文件数组
            NSString *value = [NSString stringWithFormat:@"img%d",imageNumber];
            NSDictionary *photoDic = @{@"txt":value};
            [lightspotList addObject:photoDic];
            imageNumber++;
        }
    }
    
    WPResumeUserInfoModel *applyModel = self.recuilistApplyView.listModel;
    
    NSDictionary *jsonInfo = @{@"resume_user_id":applyModel.resumeUserId,
                               @"resume_id":@"",    // to do
                               @"name":applyModel.name,
                               @"sex":applyModel.sex,
                               @"birthday":applyModel.birthday,
                               @"education":applyModel.education,
                               @"WorkTime":applyModel.workTime,
                               @"homeTown_id":applyModel.homeTownId,
                               @"homeTown":applyModel.homeTown,
                               @"Address_id":applyModel.addressId,
                               @"address":applyModel.address,
                               @"Tel":applyModel.tel,
                               @"Hope_Position":applyModel.hopePosition,
                               @"Hope_PositionNo":applyModel.hopePositionNo,
                               @"Hope_salary":applyModel.hopeSalary,
                               @"Hope_welfare":applyModel.hopeWelfare,
                               @"Hope_address":applyModel.hopeAddress,
                               @"Hope_addressID":applyModel.hopeAddressID,
                               @"nowSalary":applyModel.nowSalary,
                               @"marriage":applyModel.marriage,
                               @"webchat":applyModel.webchat,
                               @"qq":applyModel.qq,
                               @"email":applyModel.email,
                               @"educationList":educationsList,
                               @"workList":workList,
                               @"lightspot":self.lightspotStr,
                               @"lightspotList":lightspotList,
                               };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@d",self.sid);
    if (!self.sid) {
        NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
        WPShareModel *model = [WPShareModel sharedModel];
        NSDictionary *parmas = @{@"action":@"SubmitResume",
                                 @"username":model.username,
                                 @"password":model.password,
                                 @"user_id":model.dic[@"userid"],
                                 @"fileCount":[NSString stringWithFormat:@"%d",(int)dataArr.count],
                                 @"photoCount":[NSString stringWithFormat:@"%d",(int)self.recuilistApplyView.photosArray.count],
                                 @"isModify":(updateImage?@"0":@"1"),
                                 @"ResumeJson":jsonString,
                                 @"status":status};
        
        [MBProgressHUD showMessage:@"" toView:self.view];
        [WPHttpTool postWithURL:str params:parmas formDataArray:dataArr success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
            
            if (![json[@"status"] integerValue]) {
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationApplySucceed" object:nil];
                if ([self.navigationController.viewControllers[2] isKindOfClass:[self class]]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
                }
            }else{
                [MBProgressHUD showError:@"上传失败，请重试" toView:self.view];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            NSLog(@"%@",error.localizedDescription);
        }];
    }else{
        NSString *str = [IPADDRESS stringByAppendingString:@"/ios/invitejob.ashx"];
        WPShareModel *model = [WPShareModel sharedModel];
        NSDictionary *parmas = @{@"action":@"ApplicationJob",
                                 @"username":model.username,
                                 @"password":model.password,
                                 @"user_id":model.dic[@"userid"],
                                 @"job_id":self.sid,// 创建求职简历时此处为空 会崩
                                 @"fileCount":[NSString stringWithFormat:@"%d",(int)dataArr.count],
                                 @"photoCount":[NSString stringWithFormat:@"%d",(int)self.recuilistApplyView.photosArray.count],
                                 @"isModify":(updateImage?@"0":@"1"),
                                 @"ResumeJson":jsonString,
                                 @"status":status};
        
        [MBProgressHUD showMessage:@"" toView:self.view];
        [WPHttpTool postWithURL:str params:parmas formDataArray:dataArr success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
            
            if (![json[@"status"] integerValue]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationApplySucceed" object:nil];
                if ([self.navigationController.viewControllers[2] isKindOfClass:[self class]]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
                }
            }else{
                [MBProgressHUD showError:@"报名失败，请重试" toView:self.view];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            NSLog(@"%@",error.localizedDescription);
        }];
    }
    
}


@end
