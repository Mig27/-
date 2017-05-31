//
//  WPInterviewController.m
//  WP
//
//  Created by CBCCBC on 15/9/21.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPInterviewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <BlocksKit+UIKit.h>
//#import <ReactiveCocoa.h>
#import "WPInterView.h"
#import "SPPreview.h"
#import "WPActionSheet.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "DBTakeVideoVC.h"
#import "CTAssetsPickerController.h"
#import "SAYPhotoManagerViewController.h"
#import "SAYVideoManagerViewController.h"
#import "WPInterviewListController.h"
#import "MLPhotoBrowserViewController.h"
#import "WPInterviewEditController.h"
#import "WPInterviewDraftController.h"
#import "WPRecruitApplyChooseController.h"
		
#import "SPPhotoAsset.h"
#import "SPPhotoBrowser.h"
#import "MJPhoto.h"
#import "IQKeyboardManager.h"
#import "SPItemView.h"
#import "SPSelectView.h"
#import "SPSelectMoreView.h"
#import "UIImageView+WebCache.h"
#import "WPInterviewLightspotController.h"
#import "WPInterviewEducationController.h"
#import "WPInterviewWorkController.h"
#import "WPInterviewEducationListController.h"
#import "WPInterviewWorkListController.h"
#import "NSString+StringType.h"

@interface WPInterviewController () <UIScrollViewDelegate,
                                    WPActionSheet,
                                    callBackVideo,
                                    takeVideoBack,
                                    UINavigationControllerDelegate,
                                    CTAssetsPickerControllerDelegate,
                                    UpdateImageDelegate,
                                    WPInterviewListControllerDelegate,
                                    SPPhotoBrowserDelegate,
                                    SPSelectViewDelegate,
                                    SPSelectMoreViewDelegate,
                                    RefreshUserListDelegate,
                                    WPInterviewDraftControllerDelegate,
                                    WPInterviewLightspotDelegate,
                                    WPInterviewEducationDelegate,
                                    WPInterviewWorkDelegate,
                                    WPInterviewEducationListDelegate,
                                    WPInterviewWorkListDelegate,
                                    WPRecruitApplyChooseUserDelegate>

@property (strong, nonatomic) UIScrollView *horScrollView;/**< 水平方向滚动根视图（弃用） */
@property (strong, nonatomic) UIScrollView *verScrollView;/**< 垂直方向混动根视图 */
@property (strong, nonatomic) UIView *bottomView;/**< 底部模板切换视图（弃用) */
@property (strong, nonatomic) UIView *indicatorView;/**< 底部模板切换指示条（弃用） */
@property (strong, nonatomic) UIView *sendbottomView;/**< 底部创建完成视图 */
@property (strong, nonatomic) WPInterView *interView;/**< 求职视图 */
@property (strong, nonatomic) UIScrollView *afterChooseUserInterview;/**< 选择求职者后的视图 */
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayerVC;/**< 视频播放 */

@property (strong, nonatomic) SPSelectView *selectview;
@property (strong, nonatomic) SPSelectMoreView *selectMoreView;
@property (strong, nonatomic) SPSelectMoreView *selectMoreView1;
@property (assign, nonatomic) NSInteger selectedNumber;

@property (strong, nonatomic) WPUserListModel *chooseUserModel;

@property (nonatomic, strong) UILabel *resumeDraftCount;

@property (nonatomic, copy) NSString *lightspotStr;/**< 个人亮点固定内容 */
@property (nonatomic, strong) NSArray *lightspotArray;/**< 个人亮点数组 */
@property (nonatomic, strong) NSMutableArray *educationListArray;/**< 教育经历内容数组 */
@property (nonatomic, strong) NSMutableArray *workListArray;/**< 工作经历内容数组 */

@property (nonatomic, strong) UIButton *draftButton;

@property (nonatomic, strong) WPActionSheet *actionSheet;
@property (nonatomic, copy) NSString *resumeUserId;
@property (nonatomic, copy) NSString *resumeId;

@end

#pragma mark - 子视图Tag汇总
//bottomView 10+i (10~12)
//interView itemView 20+i (20~29,35)
//interView shareView 30+i (30~34)
//interView photoView 50+i (50~57)
//interView VideoView 60+i (60~67)
//ActionSheet 40 ，41
//SPPreview photosView 70+i (70~77)
//SPPreview videosView 80+i (80~87)
//SPPreview duanxin ，dianhua (100,101)
//sendBottomView 90,91
//rightButton


@implementation WPInterviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(235, 235, 235);
    _selectedNumber = 1;
    
    self.lightspotStr = @"";
    
    _resumeId = @"";
    _resumeUserId = @"";
    
    [self setNavigationItem];
    
//    [self.view addSubview:self.horScrollView];
//    [self.view addSubview:self.bottomView];
//    [self.view addSubview:self.indicatorView];
    
    
//    [self.view addSubview:self.afterChooseUserInterview];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifacationInterviewUserIsSelected:) name:kNotifacationInterviewUserIsSelected object:nil];
    
    [self.view addSubview:self.interView];
    
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

-(void)setNavigationItem
{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 22);
    button.tag = 1002;
    button.titleLabel.font = kFONT(14);
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitle:@"编辑" forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(rightButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    _draftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _draftButton.frame = CGRectMake(0, 0, 55, 22);
    _draftButton.tag = 1003;
    [_draftButton normalTitle:@"草稿" Color:RGB(0, 0, 0) Font:kFONT(14)];
    [_draftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_draftButton addTarget:self action:@selector(rightButtonItemClick1:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem1 = [[UIBarButtonItem alloc]initWithCustomView:_draftButton];
    
    _resumeDraftCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, 20, 20)];
    _resumeDraftCount.layer.cornerRadius = 10;
    _resumeDraftCount.layer.masksToBounds = YES;
    _resumeDraftCount.backgroundColor = RGB(10, 110, 210);
    _resumeDraftCount.text = @"0";
    _resumeDraftCount.font = kFONT(12);
    _resumeDraftCount.textColor = [UIColor whiteColor];
    _resumeDraftCount.textAlignment = NSTextAlignmentCenter;
    [_draftButton addSubview:_resumeDraftCount];
    [self requestDraftCount];
    
    self.navigationItem.rightBarButtonItems = @[buttonItem,buttonItem1];
}

-(void)rightButtonItemClick1:(UIButton *)sender{
    WPInterviewDraftController *draft = [[WPInterviewDraftController alloc]init];
    draft.delegate = self;
    [self.navigationController pushViewController:draft animated:YES];
}

-(void)rightButtonItemClick:(UIButton *)sender
{
    
    [self.interView endEditing:YES];
    [self.interView refreshData];
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.sendbottomView.hidden = NO;
        [self showPreview];
        _draftButton.hidden = YES;
    }else{
        [self removePreview];
        self.sendbottomView.hidden = YES;
        _draftButton.hidden = NO;
    }
    
    /*
    if ([self.interView.model.name isEqualToString:@""]||!self.interView.model.name) {
        [MBProgressHUD createHUD:@"请输入姓名" View:self.view];
    }
    else if ([self.interView.model.birthday isEqualToString:@""]||!self.interView.model.birthday) {
        [MBProgressHUD createHUD:@"请选择生日" View:self.view];
    }
    else if ([self.interView.model.education isEqualToString:@""]||!self.interView.model.education) {
        [MBProgressHUD createHUD:@"请选择学历" View:self.view];
    }
    else if ([self.interView.model.expe isEqualToString:@""]||!self.interView.model.expe) {
        [MBProgressHUD createHUD:@"请选择工作经验" View:self.view];
    }
    else if ([self.interView.model.hometown isEqualToString:@""]||!self.interView.model.hometown) {
        [MBProgressHUD createHUD:@"请选择家乡" View:self.view];
    }
    else if ([self.interView.model.lifeAddress isEqualToString:@""]||!self.interView.model.lifeAddress) {
        [MBProgressHUD createHUD:@"请选择现居地址" View:self.view];
    }
    else if ([self.interView.model.position isEqualToString:@""]||!self.interView.model.position) {
        [MBProgressHUD createHUD:@"请选择职位" View:self.view];
    }
    else if ([self.interView.model.wage isEqualToString:@""]||!self.interView.model.wage) {
        [MBProgressHUD createHUD:@"请选择薪资" View:self.view];
    }
    else if ([self.interView.model.wel isEqualToString:@""]||!self.interView.model.wel) {
        [MBProgressHUD createHUD:@"请选择福利" View:self.view];
    }
    else if ([self.interView.model.area isEqualToString:@""]||!self.interView.model.area) {
        [MBProgressHUD createHUD:@"请选择地区" View:self.view];
    }
    else if ([self.interView.model.works isEqualToString:@""]||!self.interView.model.works) {
        [MBProgressHUD createHUD:@"请填写工作经历" View:self.view];
    }
    else if ([self.interView.model.phone isEqualToString:@""]||!self.interView.model.phone) {
        [MBProgressHUD createHUD:@"请填写联系方式" View:self.view];
    }
    else if ([self.interView.model.personal isEqualToString:@""]||!self.interView.model.personal) {
        [MBProgressHUD createHUD:@"请填写个人亮点" View:self.view];
    }else{
                    self.preview.hidden = NO;
    }
    */

}


-(WPInterView *)interView
{
    if (!_interView) {
        __weak typeof(self) weakSelf = self;
        _interView = [[WPInterView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        if (self.model) {
            _interView.isFirst = NO;
        }else{
            _interView.isFirst = YES;
        }
        [_interView initSubViews];
        _interView.addPhotosBlock = ^(){
            [weakSelf addPhotos];
        };
        //        _interView.addVideosBlock = ^(){
        //            [weakSelf addVideos];
        //        };
        _interView.checkPhotosBlock = ^(){
            [weakSelf checkPhotos:YES];
        };
        //        _interView.checkAllVideosBlock = ^(){
        //            [weakSelf checkAllVideosBlock:YES];
        //        };
        _interView.checkPhotoBrowerBlock = ^(NSInteger number){
            [weakSelf checkPhotoBrower:number];
        };
        
        _interView.checkVideosBlock = ^(NSInteger number){
            [weakSelf checkVideos:number];
        };
        
        _interView.ChooseUserBlock = ^(){
            [weakSelf chooseUserClick];
        };
        _interView.InterviewActionBlock = ^(WPInterViewActionType type){
            [weakSelf interviewActionType:type];
        };
    }
    return _interView;
}

- (void)setModel:(WPUserListModel *)model
{
    _model = model;
    
    //    if (![_model.name hasPrefix:@"默认·"]) {
    //        _model.name = [NSString stringWithFormat:@"默认·%@",model.name];
    //    }
    //    [self.interView updateUserData:_model];
}


- (SPSelectView *)selectview{
    if (!_selectview) {
        _selectview = [[SPSelectView alloc]initWithTop:64];
        _selectview.delegate = self;
    }
    return _selectview;
}

-(SPSelectMoreView *)selectMoreView
{
    if (!_selectMoreView) {
        _selectMoreView = [[SPSelectMoreView alloc]initWithTop:64];
        _selectMoreView.delegate = self;
    }
    return _selectMoreView;
}

-(SPSelectMoreView *)selectMoreView1
{
    if (!_selectMoreView1) {
        _selectMoreView1 = [[SPSelectMoreView alloc]initWithTop:64];
        _selectMoreView1.delegate = self;
    }
    return _selectMoreView1;
}






- (void)SPSelectViewDelegate:(IndustryModel *)model{
    SPItemView *itemView = [self.afterChooseUserInterview viewWithTag:_selectedNumber];
    [itemView resetTitle:model.industryName];
    switch (_selectedNumber) {
        case 100:
            self.interView.model.position = model.industryName;
            self.interView.model.HopePositionNo = model.industryID;
            break;
        case 101:
            self.interView.model.wage = model.industryName;
            break;
//        case 2:
//            
//            break;
        case 103:
            self.interView.model.area = model.industryName;
            self.interView.model.HopeAddressId = model.industryID;
            break;
        default:
            break;
    }
}

- (void)SPSelectMoreViewDelegate:(SPSelectMoreView *)selectMoreView arr:(NSArray *)arr{
    if (selectMoreView == _selectMoreView) {
        SPItemView *view = (SPItemView *)[self.afterChooseUserInterview viewWithTag:2+100];
        if (arr.count == 0) {
            [view resetTitle:@"请选择福利"];
            [view.button setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
            self.interView.model.wel = nil;
        }else{
            NSString *str = [[NSString alloc]init];
            for (NSString *subStr in arr) {
                str = [NSString stringWithFormat:@"%@%@/",str,subStr];
            }
            [view resetTitle:str];
            self.interView.model.wel = str;
        }
    }
    if (selectMoreView == _selectMoreView1) {
        SPItemView *view = (SPItemView *)[self.afterChooseUserInterview viewWithTag:5+100];
        if (arr.count == 0) {
            [view resetTitle:@"请选择报名条件"];
            [view.button setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
            self.interView.model.applyCondition = nil;
        }else{
            NSString *str = [[NSString alloc]init];
            for (NSString *subStr in arr) {
                str = [NSString stringWithFormat:@"%@%@/",str,subStr];
            }
            [view resetTitle:@"已设置"];
            self.interView.model.applyCondition = str;
        }
    }
}

#pragma mark - 底部 发布按钮；
-(UIView *)sendbottomView
{
    if (!_sendbottomView) {
        _sendbottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
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
        [button addTarget:self action:@selector(sendInterViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sendbottomView addSubview:button];
        
        //UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //deleteBtn.frame = CGRectMake(10, 49/2-9, 18, 18);
        //[deleteBtn setImage:[UIImage imageNamed:@"delet_info"] forState:UIControlStateNormal];
        //deleteBtn.tag = 90;
        //[deleteBtn addTarget:self action:@selector(deleteAllClick:) forControlEvents:UIControlEventTouchUpInside];
        //[_sendbottomView addSubview:deleteBtn];

        _sendbottomView.hidden = YES;
        [self.view addSubview:_sendbottomView];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_sendbottomView addSubview:line];
    }
    return _sendbottomView;
}









#pragma mark - 获取草稿数量
- (void)requestDraftCount{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":@"BeforeAddResume",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        if ([json[@"status"] isEqualToString:@"0"]) {
            _resumeDraftCount.text = json[@"draftCount"];
        }
    } failure:^(NSError *error) {
       NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - Actions
- (void)interviewActionType:(WPInterViewActionType)type{
    if (type == WPInterViewActionTypeLightspot) {
        WPInterviewLightspotController *lightspot = [[WPInterviewLightspotController alloc]init];
        lightspot.delegate = self;
        [lightspot.objects addObjectsFromArray:self.lightspotArray];
        lightspot.buttonString = self.lightspotStr;
        [self.navigationController pushViewController:lightspot animated:YES];
    }
    if (type == WPInterViewActionTypeEducationList) {
        //if (self.educationListArray.count) {
            WPInterviewEducationListController *educationList = [[WPInterviewEducationListController alloc]init];
            educationList.delegate = self;
            educationList.dataSources = self.educationListArray;
            [self.navigationController pushViewController:educationList animated:NO];
        //}else{
            //WPInterviewEducationController *education = [[WPInterviewEducationController alloc]init];
            //education.delegate = self;
            //[self.navigationController pushViewController:education animated:YES];
        //}
    }
    if (type == WPInterViewActionTypeWorkList) {
        //if (self.workListArray.count) {
            WPInterviewWorkListController *worklist = [[WPInterviewWorkListController alloc]init];
            worklist.delegate = self;
            worklist.dataSources = self.workListArray;
            [self.navigationController pushViewController:worklist animated:NO];
        //}else{
            //WPInterviewWorkController *worklist = [[WPInterviewWorkController alloc]init];
            //worklist.delegate = self;
            //[self.navigationController pushViewController:worklist animated:YES];
        //}
    }
}

-(void)exampleClick:(UIButton *)sender
{
    [self.horScrollView setContentOffset:CGPointMake((sender.tag-10)*SCREEN_WIDTH, 0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.indicatorView.left = (sender.tag-10)*SCREEN_WIDTH/3;
    }];
    [self.interView hideSubView];
}

- (WPActionSheet *)actionSheet{
    if (!_actionSheet) {
        WS(ws);
        _actionSheet = [[WPActionSheet alloc]initWithOtherButtonTitle:@[@"保存草稿",@"不保存草稿"] imageNames:nil top:64 actions:^(NSInteger type) {
            if (type == 1) {
                [ws sendInterViewClick:nil];
                [ws.navigationController popViewControllerAnimated:YES];
            }
            if (type == 2) {
                [ws.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    return _actionSheet;
}

-(void)backToFromViewController:(UIButton *)sender
{
    if(self.actionSheet.frame.origin.y < 0&&sender.selected){
        sender.selected = !sender.selected;
    }
    sender.selected = !sender.selected;
    if(sender.selected){
        if ([self judgeMessageExisted]) {
        [self.actionSheet showInView:self.view];
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
            [alertView setHidden:YES];
            break;
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

-(void)showPreview
{
    SPPreview *preview = [[SPPreview alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    __weak typeof(self) weakSelf = self;
    preview.checkPhotosBlock = ^(){
//        [weakSelf checkPhotos:NO];
        [weakSelf checkAllVideosBlock:NO];
    };
    preview.checkVideosBlock = ^(NSInteger number){
        [weakSelf checkVideos:number];
    };
    
    preview.checkAllVideosBlock = ^(){
        [weakSelf checkAllVideosBlock:NO];
    };
    
    [self.view addSubview:preview];
    
    preview.photosArr = self.interView.photosArr;
    preview.videosArr = self.interView.videosArr;
    preview.lightspotArr = self.lightspotArray;
    preview.educationListArr = self.educationListArray;
    preview.workListArr = self.workListArray;
    preview.lightspotStr = self.lightspotStr;
    preview.model = self.interView.model;
    
    [preview reloadData];
}

-(void)removePreview
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[SPPreview class]]) {
            [view removeFromSuperview];
        }
    }
}
-(void)sendInterViewClick:(UIButton*)sender
{
    NSLog(@"发布简历");
    UIButton *button = (UIButton *)[self.view viewWithTag:1002];
    button.selected = NO;
    WPShareModel *model = [WPShareModel sharedModel];
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    
    BOOL updateImage = YES;
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.interView.photosArr.count; i++) {
        WPFormData *formDatas = [[WPFormData alloc]init];
        UIImage *image;
        if ([self.interView.photosArr[i] isKindOfClass:[SPPhotoAsset class]]) {
            image = [self.interView.photosArr[i] originImage];
            formDatas.data = UIImageJPEGRepresentation(image, 0.5);
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.interView.photosArr[i] original_path]]]];
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
    
    for (int i =0; i < self.interView.videosArr.count; i++) {
        WPFormData *formDatas = [[WPFormData alloc]init];

        if ([self.interView.videosArr[i] isKindOfClass:[NSString class]]) {
            NSData *data = [NSData dataWithContentsOfFile:self.interView.videosArr[i]];
            formDatas.data = data;
        } else if([self.interView.videosArr[i] isKindOfClass:[ALAsset class]]){
            ALAsset *asset = self.interView.videosArr[i];
            //将视频转换成NSData
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            formDatas.data = data;
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.interView.videosArr[i] original_path]]]];
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
    
    NSString *PhotoNum;
    NSString *photoCount;
    NSString *isModify;
    if (updateImage) {
        PhotoNum = [NSString stringWithFormat:@"%lu",self.interView.photosArr.count+self.interView.videosArr.count];
        photoCount = [NSString stringWithFormat:@"%lu",self.interView.photosArr.count];
        isModify = @"0";
    }else{
        PhotoNum = @"";
        photoCount = @"";
        isModify = @"1";
        arr = nil;
    }
    NSMutableArray *educationsList = [[NSMutableArray alloc]init];
    int imageNumber = 0;
    for (int i = 0; i < self.educationListArray.count; i++) {
        WPInterviewEducationModel *model = self.educationListArray[i];
        NSMutableArray *contentList = [[NSMutableArray alloc]init];
        for (int i = 0; i < model.epList.count; i++) {
            if ([model.epList[i] isKindOfClass:[NSAttributedString class]]) {//文字
                //            NSAttributedString *str = self.previewModel.textAndImage[i];
                NSString *text = [NSString stringWithFormat:@"%@",model.epList[i]];
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
                if ([model.epList[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                    MLSelectPhotoAssets *asset = model.epList[i];
                    UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                    formData.data = UIImageJPEGRepresentation(img, 0.5);
                }
                if ([model.epList[i] isKindOfClass:[NSString class]]) {
                    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.epList[i]]];
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
        NSDictionary *dic = @{@"ed_id":model.epId,
                              @"beginTime":model.beginTime,
                              @"endTime":model.endTime,
                              @"schoolName":model.schoolName,
                              @"major":model.major,
                              @"major_id":model.majorId,
                              @"education":model.education,
                              @"remark":@"",
                              @"epList":contentList};
        [educationsList addObject:dic];
    }
    
    NSMutableArray *workList = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.workListArray.count; i++) {
        WPInterviewWorkModel *model = self.workListArray[i];
        NSMutableArray *contentList = [[NSMutableArray alloc]init];
        for (int i = 0; i < model.epList.count; i++) {
            if ([model.epList[i] isKindOfClass:[NSAttributedString class]]) {//文字
                //            NSAttributedString *str = self.previewModel.textAndImage[i];
                NSString *text = [NSString stringWithFormat:@"%@",model.epList[i]];
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
                if ([model.epList[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                    MLSelectPhotoAssets *asset = model.epList[i];
                    UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
                    formData.data = UIImageJPEGRepresentation(img, 0.5);
                }
                if ([model.epList[i] isKindOfClass:[NSString class]]) {
                    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.epList[i]]];
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
        NSDictionary *dic = @{@"work_id":model.work_id,
                              @"beginTime":model.beginTime,
                              @"endTime":model.endTime,
                              @"epName":model.epName,
                              @"Industry_id":model.Industry_id,
                              @"ep_properties":model.ep_properties,
                              @"industry":model.industry,
                              @"department":model.department,
                              @"position":model.position,
                              @"position_id":model.position_id,
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
            [arr addObject:formData];//把数据流加入上传文件数组
            NSString *value = [NSString stringWithFormat:@"img%d",imageNumber];
            NSDictionary *photoDic = @{@"txt":value};
            [lightspotList addObject:photoDic];
            imageNumber++;
        }
    }
    
    NSDictionary *jsonDic = @{@"resume_user_id":_resumeUserId,//创建不需要，修改需要
                              @"resume_id":_resumeId,//创建不需要，修改需要
                              @"name":self.interView.model.name,
                              @"sex":self.interView.model.sex,
                              @"birthday":self.interView.model.birthday,
                              @"education":self.interView.model.education,
                              @"WorkTime":self.interView.model.expe,
                              @"homeTown":self.interView.model.hometown,
                              @"homeTown_id":self.interView.model.homeTownId,
                              @"address":self.interView.model.lifeAddress,
                              @"Address_id":self.interView.model.AddressId,
                              @"Tel":self.interView.model.phone,
                              @"Hope_Position":self.interView.model.position,
                              @"Hope_PositionNo":self.interView.model.HopePositionNo,
                              @"Hope_salary":self.interView.model.wage,
                              @"Hope_welfare":self.interView.model.wel,
                              @"Hope_address":self.interView.model.area,
                              @"Hope_addressID":self.interView.model.HopeAddressId,
                              @"lightspot":self.lightspotStr,//回调的固定的个人亮点
                              @"nowSalary":self.interView.model.nowSalary,
                              @"marriage":self.interView.model.marriage,
                              @"webchat":self.interView.model.WeChat,
                              @"qq":self.interView.model.QQ,
                              @"email":self.interView.model.email,
                              @"lightspotList":lightspotList,
                              @"educationList":educationsList,
                              @"workList":workList};
    
//    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [NSString ]
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"action":@"SubmitResume",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.userId,
                             @"fileCount":PhotoNum,
                             @"status":sender?@"0":@"1",
                             @"photoCount":photoCount,
                             @"isModify":isModify,
                             @"ResumeJson":jsonString};

    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:str params:params formDataArray:arr success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([json[@"status"] isEqualToString:@"0"]) {
//            [MBProgressHUD showMessage:@"发布成功" toView:self.view];
            [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
            [self performSelector:@selector(delay) withObject:nil afterDelay:1];
//            [self deleteAllClick:nil];
        }else{
            [MBProgressHUD showError:json[@"info"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)delay{
    [self deleteAllClick:nil];
    if (self.delegate) {
        [self.delegate WPInterviewControllerDelegate];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)deleteAllClick:(UIButton*)sender
{
    [self.interView deleteAllDatas];
    self.sendbottomView.hidden = YES;
//    self.preview.hidden = YES;
    [self removePreview];
    UIButton *button = (UIButton *)[self.view viewWithTag:1002];
    button.selected = NO;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView == self.horScrollView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.indicatorView.left = targetContentOffset->x/3;
        }];
    }
    [self.interView hideSubView];
}

#pragma mark - 回调函数
-(void)addPhotos
{
    WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机",@"视频"] imageNames:nil top:64];
    actionSheet.tag = 40;
    [actionSheet showInView:self.view];
}

-(void)addVideos
{
    WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机"] imageNames:nil top:64];
    actionSheet.tag = 41;
    [actionSheet showInView:self.view];
}

-(void)checkPhotos:(BOOL)isEdit
{
    SAYPhotoManagerViewController *vc = [[SAYPhotoManagerViewController alloc]init];
    vc.arr = self.interView.photosArr;
    vc.videoArr = self.interView.videosArr;
    vc.isEdit = isEdit;
    vc.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
    
//    FuckViewController *fuck = [[FuckViewController alloc]init];
//    fuck.photos = self.interView.photosArr;
//    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:fuck];
//    [self presentViewController:navc animated:YES completion:nil];
}

-(void)checkAllVideosBlock:(BOOL)isEdit
{
    SAYVideoManagerViewController *vc = [[SAYVideoManagerViewController alloc]init];
    vc.arr = self.interView.photosArr;
    vc.videoArr = self.interView.videosArr;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}

- (void)checkPhotoBrower:(NSInteger)number{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < self.interView.photosArr.count; i++) {/**< 头像或背景图 */
        MJPhoto *photo = [[MJPhoto alloc]init];
        if ([self.interView.photosArr[i] isKindOfClass:[Pohotolist class]]) {
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.interView.photosArr[i] original_path]]];
            photo.url = url;
            photo.originString = [self.interView.photosArr[i] original_path];
            photo.thumbString = [self.interView.photosArr[i] thumb_path];
        }else{
            photo.image = [self.interView.photosArr[i] originImage];
        }
        photo.srcImageView = [(UIButton *)[self.interView.photosView viewWithTag:50+number] imageView];
        [arr addObject:photo];
    }
    SPPhotoBrowser *brower = [[SPPhotoBrowser alloc] init];
    brower.delegate = self;
    brower.currentPhotoIndex = number;
    brower.photos = arr;
    [brower show];
}

- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser photosArr:(NSArray *)photosArray{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i =0; i < photosArray.count; i++) {
        MJPhoto *photo = photosArray[i];
        if (!photo.image) {
            Pohotolist *imagePhoto = [[Pohotolist alloc]init];
            imagePhoto.thumb_path = photo.originString;
            imagePhoto.original_path = photo.originString;
            [arr addObject:imagePhoto];
        }else{
            SPPhotoAsset *imagePhoto = [[SPPhotoAsset alloc]init];
            imagePhoto.image = photo.image;
            [arr addObject:imagePhoto];
        }
    }
    [self.interView.photosArr removeAllObjects];
    [self.interView.photosArr addObjectsFromArray:arr];
    [self.interView refreshPhotos];
}

- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser deleteImageAtIndex:(NSInteger)index{
    [self.interView.photosArr removeObjectAtIndex:index];
    [self.interView refreshPhotos];
}

- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser coverImageAtIndex:(NSInteger)index{
    id photo = self.interView.photosArr[index];
    [self.interView.photosArr removeObjectAtIndex:index];
    [self.interView.photosArr insertObject:photo atIndex:0];
    [self.interView refreshPhotos];
}


-(void)checkVideos:(NSInteger)number
{
    NSLog(@"观看视频");
    if ([self.interView.videosArr[number] isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL fileURLWithPath:self.interView.videosArr[number]];
        _moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    } else {
        ALAsset *asset = self.interView.videosArr[number];
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

- (void)chooseUserClick
{
    WPRecruitApplyChooseController *list = [[WPRecruitApplyChooseController alloc]init];
//    list.delegate = self;
//    list.sid = self.model.
//    list.subController = @"WPInterviewController";
    list.delegate = self;
    list.title = @"我的简历";
    [self.navigationController pushViewController:list animated:YES];
}

//- (void)reloadDataWithModel:(WPRecruitApplyChooseDetailModel *)model
//{
//    
//}

#pragma mark - 选择求职者返回函数
- (void)WPInterviewListController:(WPUserListModel *)model{
//    if ([self.model.sid isEqualToString:model.sid]) {
//        model.name = [NSString stringWithFormat:@"默认·%@",model.name];
//    }
    _chooseUserModel = model;
    _resumeUserId = model.resumeUserId;
    
//    [self.view bringSubviewToFront:self.afterChooseUserInterview];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:WPInterviewAfterChooseUserViewTypeChoose];
    [button setTitle:model.name forState:UIControlStateNormal];
    
//    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:WPInterviewAfterChooseUserViewTypeIcon];
//    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.]];
//    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    UILabel *nameLabel = (UILabel *)[self.view viewWithTag:WPInterviewAfterChooseUserViewTypeName];
    nameLabel.text = model.name;
    
    UILabel *detailLabel = (UILabel *)[self.view viewWithTag:WPInterviewAfterChooseUserViewTypeInfo];
    detailLabel.text = [NSString stringWithFormat:@"%@/%@/%@/%@",model.sex,model.birthday,model.education,model.workTime];
    
    [self.interView updateUserData:model];
    
    //选择求职者后转换个人亮点，教育经历，工作经历
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
        SPItemView *itemview = (SPItemView *)[self.interView viewWithTag:WPInterViewActionTypeLightspot];
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
        SPItemView *itemview = (SPItemView *)[self.interView viewWithTag:WPInterViewActionTypeEducationList];
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
        for (WPRemarkModel *remarkModel in [model.workList[i] expList]) {
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
        SPItemView *itemview = (SPItemView *)[self.interView viewWithTag:WPInterViewActionTypeWorkList];
        [itemview resetTitle:@"工作经历已填写"];
    }
}



- (void)refreshUserListDelegate:(WPUserListModel *)model{
    [self WPInterviewListController:model];
}

-(void)UpdateImageDelegate:(NSArray *)arr VideoArr:(NSArray *)videoArr
{
    [self.interView.photosArr removeAllObjects];
    [self.interView.photosArr addObjectsFromArray:arr];
    
    [self.interView.videosArr removeAllObjects];
    [self.interView.videosArr addObjectsFromArray:videoArr];
    
    [self.interView refreshPhotos];
}

-(void)UpdateVideoDelegate:(NSArray *)arr
{
    [self.interView.videosArr removeAllObjects];
    [self.interView.videosArr addObjectsFromArray:arr];
    [self.interView refreshPhotos];
}

#pragma mark - WPActionSheet
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
        [self.interView.photosArr addObject:asset];
        [self.interView refreshPhotos];
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)fromAlbums {
    
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 12 - self.interView.photosArr.count;
//            [pickerVc show];
    [self presentViewController:pickerVc animated:YES completion:NULL];
    pickerVc.callBack = ^(NSArray *assets){
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        for (MLSelectPhotoAssets *asset in assets) {
            SPPhotoAsset *spAsset = [[SPPhotoAsset alloc]init];
            spAsset.asset = asset.asset;
            [photos addObject:spAsset];
        }
        [self.interView.photosArr addObjectsFromArray:photos];
        [self.interView refreshPhotos];
    };
}

#pragma mark - VideoSelected
-(void)videoFromCamera
{
    DBTakeVideoVC *tackVedio = [[DBTakeVideoVC alloc] init];
    tackVedio.delegate = self;
    tackVedio.fileCount = 4-self.interView.videosArr.count;
    tackVedio.takeVideoDelegate = self;
    
    [self.navigationController pushViewController:tackVedio animated:YES];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tackVedio];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(void)videoFromAlbums
{
    NSLog(@"导入视频");
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = 4-self.interView.videosArr.count;
    picker.assetsFilter = [ALAssetsFilter allVideos];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

//从录制界面选择Video返回
-(void)sendBackVideoWith:(NSArray *)array
{
    [self.interView.videosArr addObjectsFromArray:array];
    [self.interView refreshPhotos];
//    [self.interView refreshVideos];
}
//录制返回
-(void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
    [self.interView.videosArr addObject:filePaht];
    [self.interView refreshPhotos];
//    [self.interView refreshVideos];
}
//直接选择Video返回
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [self.interView.videosArr addObjectsFromArray:assets];
    [self.interView refreshPhotos];
//    [self.interView refreshVideos];
}

-(void)dealloc
{
    [self.interView hideSubView];
}

#pragma mark - 个人亮点代理回调函数
- (void)getLightspotWithConstant:(NSString *)constant content:(NSArray *)contents{
    SPItemView *item = (SPItemView *)[self.view viewWithTag:WPInterViewActionTypeLightspot];
    [item resetTitle:@"亮点已填写"];
    self.lightspotStr = constant;
    self.lightspotArray = contents;
}
#pragma mark - 教育经历代理回调函数
- (void)getEducation:(WPInterviewEducationModel *)educationModel type:(WPInterviewEducationType)type{
    SPItemView *item = (SPItemView *)[self.view viewWithTag:WPInterViewActionTypeEducationList];
    [item resetTitle:@"教育经历已填写"];
    [self.educationListArray addObject:educationModel];
}

#pragma mark - 教育经历列表代理返回函数
- (void)getEducationList:(NSArray *)educationArray{
    [self.educationListArray removeAllObjects];
    [self.educationListArray addObjectsFromArray:educationArray];
    SPItemView *item = (SPItemView *)[self.view viewWithTag:WPInterViewActionTypeEducationList];
    [item resetTitle:@"教育经历已填写"];
    //NSLog(@"%@",describe(self.educationListArray));
}

#pragma mark - 工作经历代理回调函数
- (void)getwork:(WPInterviewWorkModel *)model type:(WPInterviewWorkType)type{
    SPItemView *item = (SPItemView *)[self.view viewWithTag:WPInterViewActionTypeWorkList];
    [item resetTitle:@"工作经历已填写"];
    [self.workListArray addObject:model];
}
#pragma mark - 工作经历列表代理返回函数
- (void)getWorkList:(NSArray *)workArray{
    [self.workListArray removeAllObjects];
    [self.workListArray addObjectsFromArray:workArray];
    SPItemView *item = (SPItemView *)[self.view viewWithTag:WPInterViewActionTypeWorkList];
    [item resetTitle:@"工作经历已填写"];
}

#pragma mark - 草稿代理返回函数
- (void)returnDraftToInterviewController:(WPInterviewDraftInfoModel *)model{
    [self.interView updateUserDatafromDraft:model];
    
    _resumeId = model.resume_id;
    _resumeUserId = model.resume_user_id;
    
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
        SPItemView *itemview = (SPItemView *)[self.interView viewWithTag:WPInterViewActionTypeLightspot];
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
        SPItemView *itemview = (SPItemView *)[self.interView viewWithTag:WPInterViewActionTypeEducationList];
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
        SPItemView *itemview = (SPItemView *)[self.interView viewWithTag:WPInterViewActionTypeWorkList];
        [itemview resetTitle:@"工作经历已填写"];
    }
}

- (BOOL)judgeMessageExisted{
    if (![self.interView.model.name isEqualToString:@""]) {
        return YES;
    }
    if (![self.interView.model.sex isEqualToString:@""]) {
        return YES;
    }
    if (![self.interView.model.birthday isEqualToString:@""]) {
        return YES;
    }
    if (![self.interView.model.education isEqualToString:@""]) {
        return YES;
    }
    if (![self.interView.model.expe isEqualToString:@""]) {
        return YES;
    }
    if (![self.interView.model.hometown isEqualToString:@""]) {
        return YES;
    }
    if (![self.interView.model.lifeAddress isEqualToString:@""]) {
        return YES;
    }
    if (![self.interView.model.position isEqualToString:@""]) {
        return YES;
    }
    if (![self.interView.model.wage isEqualToString:@""]) {
        return YES;
    }
    if (![self.interView.model.wel isEqualToString:@""]) {
        return YES;
    }
    if (![self.interView.model.area isEqualToString:@""]) {
        return YES;
    }
    if (![self.interView.model.works isEqualToString:@""]) {
        return YES;
    }
    if (![self.interView.model.phone isEqualToString:@""]) {
        return YES;
    }
    if (![self.interView.model.personal isEqualToString:@""]) {
        return YES;
    }
    //if (![self.interView.model.applyCondition isEqualToString:@""]) {
        //return YES;
    //}
    if (self.interView.photosArr.count!= 0||self.interView.videosArr.count!= 0) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 - (void)goToUserEditAction:(UIButton *)sender{
 WPInterviewEditController *edit = [[WPInterviewEditController alloc]init];
 edit.delegate = self;
 [edit setupSubViews];
 edit.title = @"个人信息";
 edit.listModel = _chooseUserModel;
 [self.navigationController pushViewController:edit animated:YES];
 }
 
 
 - (void)itemButtonActions:(NSInteger)sender{
 _selectedNumber = sender;
 switch (_selectedNumber) {
 case 100:
 self.selectview.isArea = NO;
 self.selectview.isIndustry = NO;
 [self.selectview setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getPosition",@"fatherid":@"0"}];
 break;
 case 101:
 [self.selectview setLocalData:[SPLocalApplyArray salaryArray]];
 break;
 case 102:
 [self.selectMoreView setLocalData:[SPLocalApplyArray welfareArray] SelectArr:nil];
 break;
 case 103:
 self.selectview.isArea = YES;
 self.selectview.isIndustry = NO;
 [self.selectview setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
 break;
 case 105:
 [self.selectMoreView1 setLocalData:[SPLocalApplyArray interviewApplyArray] SelectArr:@[@"联系人",@"联系方式",@"企业信息"]];
 break;
 default:
 break;
 }
 }
 */



/*
 
 - (UIScrollView *)afterChooseUserInterview{
 if (!_afterChooseUserInterview)
 {
 _afterChooseUserInterview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
 _afterChooseUserInterview.backgroundColor = RGB(235, 235, 235);
 
 // 选择求职者
 UIView *chooseUserView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, ItemViewHeight)];
 chooseUserView.backgroundColor = [UIColor whiteColor];
 [_afterChooseUserInterview addSubview:chooseUserView];
 
 UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, ItemViewHeight)];
 label.text = @"请选择求职者";
 label.font = kFONT(15);
 [chooseUserView addSubview:label];
 
 UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
 button.frame = CGRectMake(120, 0, SCREEN_WIDTH-120-26, ItemViewHeight);
 button.titleLabel.font = kFONT(12);
 button.tag = WPInterviewAfterChooseUserViewTypeChoose;
 [button setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
 [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
 [button addTarget:self action:@selector(chooseUserClick) forControlEvents:UIControlEventTouchUpInside];
 [chooseUserView addSubview:button];
 
 UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
 button1.frame = CGRectMake(button.right, 0, SCREEN_WIDTH-button.right, 48);
 [button1 addTarget:self action:@selector(chooseUserClick) forControlEvents:UIControlEventTouchUpInside];
 [chooseUserView addSubview:button1];
 
 UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"jinru"]];
 imageV.frame = CGRectMake(chooseUserView.width-10-8, chooseUserView.height/2-7, 8,14);
 [chooseUserView addSubview:imageV];
 
 // 个人信息
 UIButton *userInfoView = [[UIButton alloc]initWithFrame:CGRectMake(0, chooseUserView.bottom+10, SCREEN_WIDTH, PhotoViewHeight)];
 userInfoView.backgroundColor = [UIColor whiteColor];
 [userInfoView addTarget:self action:@selector(goToUserEditAction:) forControlEvents:UIControlEventTouchUpInside];
 [_afterChooseUserInterview addSubview:userInfoView];
 
 // 照片、视频
 UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, PhotoHeight, PhotoHeight)];
 headImageView.image = [UIImage imageNamed:@"head_default"];
 headImageView.tag = WPInterviewAfterChooseUserViewTypeIcon;
 [userInfoView addSubview:headImageView];
 
 // 照片、视频 后面描述
 UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(headImageView.right+10, headImageView.bottom-15, SCREEN_WIDTH-120, 15)];
 detailLabel.textColor = RGB(175, 175, 175);
 detailLabel.text = @"男/31/本科/3-5年";
 detailLabel.font = kFONT(12);
 detailLabel.tag = WPInterviewAfterChooseUserViewTypeInfo;
 [userInfoView addSubview:detailLabel];
 
 // 姓名
 UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(headImageView.right+10, detailLabel.top-30, SCREEN_WIDTH-120, 30)];
 nameLabel.font = kFONT(15);
 nameLabel.text = @"佟丽娅";
 nameLabel.tag = WPInterviewAfterChooseUserViewTypeName;
 [userInfoView addSubview:nameLabel];
 
 UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"jinru"]];
 rightImageView.frame = CGRectMake(userInfoView.width-10-8, userInfoView.height/2-7, 8,14);
 [userInfoView addSubview:rightImageView];
 
 UILabel *userInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(rightImageView.left-100-10, userInfoView.height/2-10, 100, 20)];
 userInfoLabel.textAlignment = NSTextAlignmentRight;
 userInfoLabel.text = @"个人信息";
 userInfoLabel.textColor = RGB(175, 175, 175);
 userInfoLabel.font = kFONT(15);
 [userInfoView addSubview:userInfoLabel];
 
 
 
 //求职条件
 NSArray *titleArr = @[@"期望职位:",
 @"期望薪资:",
 @"期望福利:",
 @"期望地区:"];
 NSArray *placeArr = @[@"请选择期望职位",
 @"请选择期望薪资",
 @"请选择期望福利",
 @"请选择期望地区"];
 NSArray *typeArr = @[kCellTypeButton,
 kCellTypeButton,
 kCellTypeButton,
 kCellTypeButton];
 WS(ws);
 UIView *lastview = nil;
 for (int i = 0; i < titleArr.count; i++) {
 SPItemView *view = [[SPItemView alloc]initWithFrame:CGRectMake(0, i*ItemViewHeight+userInfoView.bottom+10, SCREEN_WIDTH, ItemViewHeight)];
 [view setTitle:titleArr[i] placeholder:placeArr[i] style:typeArr[i]];
 view.tag = i+100;
 view.SPItemBlock = ^(NSInteger tag){
 [ws itemButtonActions:tag];
 };
 lastview = view;
 
 [_afterChooseUserInterview addSubview:view];
 }
 
 SPItemView *view = [[SPItemView alloc]initWithFrame:CGRectMake(0, lastview.bottom+10, SCREEN_WIDTH, ItemViewHeight)];
 [view setTitle:@"报名条件:" placeholder:@"请选择报名条件" style:kCellTypeButton];
 [_afterChooseUserInterview addSubview:view];
 view.tag = 5+100;
 view.SPItemBlock = ^(NSInteger tag){
 [ws itemButtonActions:tag];
 };
 }
 return _afterChooseUserInterview;
 }
 
 
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
 
 -(UIView *)bottomView
 {
 if (!_bottomView) {
 _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
 _bottomView.backgroundColor = [UIColor whiteColor];
 
 NSArray *arr = @[@"模板A",@"模板B",@"模板C"];
 for (int i = 0; i < 3; i++) {
 UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
 button.frame = CGRectMake(i*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 49);
 [button setTitle:arr[i] forState:UIControlStateNormal];
 [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 //            button.layer.borderColor = RGB(226, 226, 226).CGColor;
 button.titleLabel.font = kFONT(15);
 //            button.layer.borderWidth = 0.25;
 button.tag = 10+i;
 [button addTarget:self action:@selector(exampleClick:) forControlEvents:UIControlEventTouchUpInside];
 [_bottomView addSubview:button];
 
 if (i!=0) {
 UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/3, 14, 0.5, 15)];
 line.backgroundColor = RGB(178, 178, 178);
 [_bottomView addSubview:line];
 }
 }
 UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
 line.backgroundColor = RGB(178, 178, 178);
 [_bottomView addSubview:line];
 }
 return _bottomView;
 }
 
 - (UIView *)indicatorView
 {
 if (!_indicatorView) {
 _indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-3, SCREEN_WIDTH/3, 3)];
 _indicatorView.backgroundColor = [UIColor blueColor];
 }
 return _indicatorView;
 }
 */

/*
 
 
 
- (void)notifacationInterviewUserIsSelected:(NSNotification *)object{
    WPUserListModel *model = object.object;
    _chooseUserModel = model;
 
    [self.view bringSubviewToFront:self.afterChooseUserInterview];
 
    UIButton *button = (UIButton *)[self.view viewWithTag:WPInterviewAfterChooseUserViewTypeChoose];
    [button setTitle:model.name forState:UIControlStateNormal];
 
    //    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:WPInterviewAfterChooseUserViewTypeIcon];
    //    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.user_avatar]];
    //    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
 
    UILabel *nameLabel = (UILabel *)[self.view viewWithTag:WPInterviewAfterChooseUserViewTypeName];
    nameLabel.text = model.name;
 
    UILabel *detailLabel = (UILabel *)[self.view viewWithTag:WPInterviewAfterChooseUserViewTypeInfo];
    detailLabel.text = [NSString stringWithFormat:@"%@/%@/%@/%@",model.sex,model.birthday,model.education,model.workTime];
 
    [self.interView updateUserData:model];
}

*/

@end
