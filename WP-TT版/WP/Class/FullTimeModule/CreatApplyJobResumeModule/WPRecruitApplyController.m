//
//  WPRecruitApplyController.m
//  WP
//
//  Created by CBCCBC on 16/4/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPRecruitApplyController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <BlocksKit+UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import "WPRecruiteCell.h"
#import "BaseModel.h"
#import "SPSelectView.h"
#import "SPDateView.h"
#import "SPSelectMoreView.h"
#import "WPChooseView.h"
#import "SAYPhotoManagerViewController.h"
#import "WPActionSheet.h"
#import "MLSelectPhotoPickerViewController.h"
#import "SPPhotoAsset.h"
#import "MLSelectPhotoAssets.h"
#import "DBTakeVideoVC.h"
#import "CTAssetsPickerController.h"
#import "WPResumeUserVC.h"
#import "WPResumeDraftVC.h"
#import "SPPhotoBrowser.h"
#import "WPInterviewLightspotController.h"
#import "WPInterviewEducationListController.h"
#import "WPInterviewEducationController.h"
#import "WPInterviewWorkListController.h"
#import "WPInterviewWorkController.h"
#import "WPResumePreview.h"
#import "CommonTipView.h"
#import "WPChooseResumerController.h"
#import "WPResumeWebVC.h"
#import "HJCActionSheet.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "SDWebImageManager+MJ.h"
#import "SAYVideoManagerViewController.h"
#import "UISelectCity.h"
#import "WPMySecurities.h"
#import "VideoBrowser.h"
#import "WPUploadShuoShuo.h"
#import "NSString+StringType.h"

#define VideoTag 65
#define PhotoTag 50
#define kWPRecruitCellReuse @"WPRecruitCellReuse"
@interface WPRecruitApplyController ()
<UITableViewDelegate,
UITableViewDataSource,SPSelectViewDelegate,
SPSelectMoreViewDelegate,WPActionSheet,
takeVideoBack,callBackVideo,
CTAssetsPickerControllerDelegate,
UINavigationControllerDelegate,
WPResumeUserDelegate,UITextFieldDelegate,
WPResumeDraftVCDelegate,SPPhotoBrowserDelegate,
WPInterviewLightspotDelegate,
WPInterviewEducationDelegate,
WPInterviewWorkDelegate,
WPInterviewEducationListDelegate,
WPInterviewWorkListDelegate,
WPResumeWebVCDelegate,HJCActionSheetDelegate,
UpdateImageDelegate,UIGestureRecognizerDelegate,
UISelectDelegate,
UIAlertViewDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource,
WPRecruiteCellDelegate

>
{
    BOOL telephoneShowed;//电话号码是否需要显示
    BOOL imageChanged;
    BOOL contentChanged;// 个人亮点，教育经历，工作经历是否改变
    BOOL Doingit;
    BOOL updateImage;
    BOOL willComplete;
    WPRecruiteCell *TextCell;
    NSInteger baseTag;
    NSInteger cateTag;
    BOOL addChooseView;
    BOOL isDraft;
    BOOL isShow;//判断sheet是否展示
    BOOL backFromPerson;//判断是否是从求职者界面返回的；
    NSInteger numberOfDraft;    // 草稿数量
    NSString *status;
    WPActionSheet *saveDraftActionSheet;
    NSInteger unChooseInter;//点击完成时确定必填的哪一部分没有填写
    UIPickerView * sexPickerView;
    UIView * sexBtnView;
    
}
@property (strong, nonatomic) WPResumeUserInfoModel *model;
@property (nonatomic, strong) MPMoviePlayerViewController *moviePlayerVC;
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSArray *titleArray;
@property (nonatomic , strong)NSArray *placeholderArray;
@property (nonatomic , strong)NSArray *typeArray;
@property (nonatomic , strong)NSArray *propertyArray;
@property (nonatomic , strong)NSArray *listsArray;
@property (nonatomic , strong)SPSelectView *selectView;
@property (nonatomic , strong)SPDateView *dateView;
@property (nonatomic , strong)SPSelectMoreView *selectMoreView;
@property (nonatomic , strong)UIView *photoBaseView;
@property (strong, nonatomic) UIScrollView *photoView;
@property (strong, nonatomic) UIButton *addPhotosBtn;
@property (nonatomic , strong)WPChooseView *chooseView;//选择求职者的视图
@property (nonatomic, strong) UIButton *retryBtn;
@property (nonatomic, strong) UIButton *draftButton;
@property (nonatomic ,strong) NSMutableArray *photoArray;//图片数组
@property (nonatomic ,strong) NSMutableArray *vedioArray;//视频数组
@property (nonatomic ,strong) NSArray *detailPropertyArray;
@property (nonatomic ,strong) NSArray *detailListsArray;
@property (nonatomic, copy) NSString *lightspotStr;/**< 个人亮点固定内容 */
@property (nonatomic, strong) NSArray *lightspotArray;/**< 个人亮点数组 */
@property (nonatomic, strong) NSMutableArray *educationListArray;/**< 教育经历内容数组 */
@property (nonatomic, strong) NSMutableArray *workListArray;/**< 工作经历内容数组 */
@property (nonatomic ,strong) UIView *previewBg;
@property (nonatomic ,strong)CommonTipView *redView;
@property (nonatomic, strong)UISelectCity *city;
@property (nonatomic, copy) NSString *shelvesDown;
@property (nonatomic, copy)NSString * openStr;
@property (nonatomic, strong)NSArray * proTitleList;
@property (nonatomic, copy) NSString * choiseResumeId;//从求职者中选择的简历ID
@property (nonatomic, copy) NSString * choiseDraftResumeId;//从草稿中选择的简历id
@property (nonatomic, assign)BOOL isChoised;//申请时是否选择了已有简历
@property (nonatomic, assign) BOOL changeResume;//申请是是否修改简历
@property (nonatomic, copy) NSString * is_update;
@property (nonatomic, assign) BOOL saveDraft;//是否保存草稿
@property (nonatomic, assign) BOOL nowAddress;//现居住地
@property (nonatomic, copy) NSString * isLook;
@end

@implementation WPRecruitApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //禁用滑动手势
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:@selector(clickLeft:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
  
    
    _shelvesDown = @"";
    telephoneShowed = NO;
    [self beforeAddResumeRequest];
//    [self.view addSubview:self.tableView];
   
    [self.view addSubview:self.retryBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"REFRESHDATA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWorkData:) name:@"REFRESHWORKDATA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentChanged) name:@"haseChangeD" object:nil];//用来接收个人亮点，教育经历，工作经历发生改变的通知
}
-(void)clickLeft:(id)item
{
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

-(void)contentChanged
{
    contentChanged = YES;
}
-(void)refreshData:(NSNotification*)sender
{
    NSDictionary * dic = [sender userInfo];
    NSArray * array = dic[@"nama"];
    [self.educationListArray removeAllObjects];
    [self.educationListArray addObjectsFromArray:array];
    [self.tableView reloadData];
}
-(void)refreshWorkData:(NSNotification*)notification
{
    NSDictionary * dic = [notification userInfo];
    NSArray * array = dic[@"name"];
    [self.workListArray removeAllObjects];
    [self.workListArray addObjectsFromArray:array];
    [self.tableView reloadData];
    
}
#pragma mark 进入时请求草稿的数量
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
        [self.view addSubview:self.tableView];
        [self setRightBarButton];
    } failure:^(NSError *error) {
    }];
}
#pragma mark 再次进入时改变草稿的数量
-(void)requstNumOfDraft
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                   initWithDictionary:@{@"action":@"BeforeAddResume",
                                                        @"username":kShareModel.username,
                                                        @"password":kShareModel.password,
                                                        @"user_id":kShareModel.dic[@"userid"]}];
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        if ([json[@"draftCount"] integerValue]) {
            for (UIView * view in self.navigationController.navigationBar.subviews) {
                if ([view isKindOfClass:[UIButton class]]&& view.tag == 3001) {
//                    UIButton * button = (UIButton*)view;
                    for (UIView * subView in view.subviews) {

                        if ([subView isKindOfClass:[UILabel class]] && subView.tag == 3000) {
                            UILabel * label = (UILabel*)subView;
                            label.text = [NSString stringWithFormat:@"%@",json[@"draftCount"]];
                            if (label.text.length == 1) {
                                CGRect rect = label.frame;
                                rect.size = CGSizeMake(20, 20);
                                label.frame = rect;
                                label.layer.cornerRadius = 10;
//                                [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                                    make.centerY.mas_equalTo(button.mas_centerY);
//                                    make.right.mas_equalTo(button.mas_centerX).offset(-8);
//                                    make.size.mas_equalTo(CGSizeMake(20, 20));
//                                    label.layer.cornerRadius = 10;
//                                }];
                            }
                            
                        }
                    }
                }
            }
        }
        else
        {
            for (UIView *view in self.navigationController.navigationBar.subviews) {
                if ([view isKindOfClass:[UIButton class]] && view.tag == 3001) {
                    view.hidden = YES;
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)rightBarButton:(UIButton*)sender
{
    if (sender.selected) {//申请时的编辑
        Doingit = YES;
        [self removePreview];
        for (UIView * view in self.navigationController.navigationBar.subviews) {
            if ([view isKindOfClass:[UIButton class]] && view.tag == 3000) {
                UIButton * button = (UIButton*)view;
                button.selected = !button.selected;
            }
        }
        UIButton * btn = (UIButton*)[self.view viewWithTag:3000];
        btn.selected = !btn.selected;
        
//    if (self.changeResume)
//      {
//        self.is_update = @"0";
//          _shelvesDown = @"0";//上架
//       }
//      else
//      {
//         self.is_update = @"1";//is_update//0更新1不更新
//          if (self.sid.length) {//选择的
//              _shelvesDown = @"0";//_shelvesDown//0上架1下架
//          }
//          else//手动输入
//          {
//            _shelvesDown = @"1";
//          }
//      }
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"个人求职简历已创建成功，是否发布求职申请?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//        [alert show];
    }
    else//申请时的完成
    {
        willComplete = YES;
        if ([self checkModelPropertyNil]) {//判断是否有图片
            [self.tableView reloadData];
            
            NSIndexPath*scrollIndexPath;
            if (unChooseInter == 1) {
                CGPoint contentOffSet = self.tableView.contentOffset;
                contentOffSet.y = 0;
                [self.tableView setContentOffset:contentOffSet animated:YES];
                unChooseInter = 0;
                return;
            }
            else
            {
                scrollIndexPath =  [NSIndexPath indexPathForRow:0 inSection:1];
            }
            [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            unChooseInter = 0;
            return;
        }
        sender.selected = !sender.selected;
        if (sender.selected) {
            Doingit = YES;
            [self showPreview];
            _draftButton.hidden = YES;
        }
        else
        {
            [self removePreview];
            _draftButton.hidden = NO;
        }


    }
}
#pragma mark -- 点击完成方法
- (void)rightBarButtonItemAction:(UIButton *)sender
{

    if (Doingit) {
        return;
    }
    willComplete = YES;
    if ([self checkModelPropertyNil]) {//判断是否有图片
        [self.tableView reloadData];
        
        NSIndexPath*scrollIndexPath;
        if (unChooseInter == 1) {
            CGPoint contentOffSet = self.tableView.contentOffset;
            contentOffSet.y = 0;
            [self.tableView setContentOffset:contentOffSet animated:YES];
            unChooseInter = 0;
            return;
        }
        else
        {
            scrollIndexPath =  [NSIndexPath indexPathForRow:0 inSection:1];
        }
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        unChooseInter = 0;
        return;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        Doingit = YES;
        [self showPreview];
        _draftButton.hidden = YES;
    }
    else
    {
        [self removePreview];
        if (numberOfDraft) {
         _draftButton.hidden = NO;
        }
        else
        {
           _draftButton.hidden = YES;
        }
        
    }
}

#pragma mark 点击预览界面的查看所有图片
-(void)checkAllVideosBlock:(BOOL)isEdit
{
    SAYVideoManagerViewController *vc = [[SAYVideoManagerViewController alloc]init];
    vc.arr = self.photoArray;
    vc.videoArr = self.vedioArray;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}
#pragma mark 创建预览界面
- (void)showPreview
{
    if (!self.title.length) {
       self.title = @"求职简历";
    }
    
//    isDraft = YES;
    // 预览界面Bg
    _previewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
    _previewBg.backgroundColor = RGB(235, 235, 235);
    _previewBg.tag = 1010;
    
    [self.view addSubview:_previewBg];
    
    // 预览界面
    WPResumePreview *preview = [[WPResumePreview alloc]initWithFrame:CGRectMake(0, 0, _previewBg.width, SCREEN_HEIGHT-64-49)];
//    if (!self.isBuildNew) {
//        CGRect rect = preview.frame;
//        rect.size.height = _previewBg.height;
//        preview.frame = rect;
//    }
    preview.isApply  = !self.isBuildNew;
    __weak typeof(self) weakSelf= self;
    preview.checkVideosBlock = ^(NSInteger number){
        [weakSelf checkVideos:number];
    };
    
    preview.checkPhotosBlock = ^(){
        [weakSelf checkAllVideosBlock:NO];
    };
    preview.isOpenOrNot = ^(NSString*openStr,NSString * userID,BOOL isOr){
//      self.openStr = openStr;
        self.isLook = @"";
        if ([openStr isEqualToString:@"所有人可见"]) {
             self.openStr = @"0";
        }
        else if ([openStr isEqualToString:@"仅好友可见"])
        {
            self.openStr = @"1";
        }
        else if ([openStr isEqualToString:@"仅陌生人可见"])
        {
            self.openStr = @"2";
        }
        else
        {
            if (userID.length) {
                
                self.isLook = userID;
                if (isOr) {
                    self.openStr = @"4";
                }
                else
                {
                  self.openStr = @"5";
                }
            }
            else
            {
               self.openStr = @"3";
                self.isLook = @"";
            }
           
        }
    };
    
    preview.vc = self;
    
    preview.photosArr = self.photoArray;
    preview.videosArr = self.vedioArray;
    
    preview.lightspotStr = self.lightspotStr;
    
   NSString * string = [WPMySecurities textFromBase64String:self.lightStr];
   string = [WPMySecurities textFromEmojiString:string];
    if (string.length) {
        self.lightStr = string;
    }
    preview.lightStr = self.lightStr;
//    preview.lightspotArr = self.lightspotArray;
    
    preview.educationListArr = [NSArray arrayWithArray:self.educationListArray];
    preview.workListArr = [NSArray arrayWithArray:self.workListArray];
    
    
//    __weak typeof(self) weakSelf = self;
//    
//    preview.checkPhotosBlock = ^(){
//        //        [weakSelf checkPhotos:NO];
//        //        [weakSelf checkAllVideosBlock:NO];
//    };
//    preview.checkVideosBlock = ^(NSInteger number){
//        //        [weakSelf checkVideos:number];
//    };
//    
//    preview.checkAllVideosBlock = ^(){
//        //        [weakSelf photosViewClick];
//    };
    
    preview.model = self.model;
    [preview reloadData];
    [_previewBg addSubview:preview];
    
    // 发布按钮
    UIView *sendbottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _previewBg.height - 49, _previewBg.width, 49)];
    //sendbottomView.backgroundColor = [UIColor redColor];
    
    sendbottomView.backgroundColor = RGB(0, 172, 255);
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    button.titleLabel.font = kFONT(15);
    button.tag = 90;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 4)];
    [button addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(submitResumeClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"qz_fabu"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"qz_fabu"] forState:UIControlStateHighlighted];
    [sendbottomView addSubview:button];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, sendbottomView.bottom - 0.5, sendbottomView.width, 0.5)];
    line.backgroundColor = RGB(178, 178, 178);
    [sendbottomView addSubview:line];
    
//    [_previewBg addSubview:sendbottomView];
    if (self.isBuildNew) {
       [_previewBg addSubview:sendbottomView];  
    }
    else
    {
        [button setTitle:@"确认" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
         [_previewBg addSubview:sendbottomView];
    }
    Doingit = NO;
}
-(void)clickDown:(UIButton*)sender
{
    [sender setBackgroundColor:RGB(0, 146, 217)];
}
#pragma mark 发布简历
- (void)submitResumeClick:(UIButton *)sender
{
    if (self.isBuildNew) {//创建
        sender.userInteractionEnabled = NO;
        [sender setBackgroundColor:RGB(0, 172, 255)];
        status = @"0";
        [self SubmitResume];
    }
    else//申请
    {
        if (self.changeResume)
        {
            self.is_update = @"0";
            _shelvesDown = @"0";//上架
        }
        else
        {
            self.is_update = @"1";//is_update//0更新1不更新
            if (self.detailModel) {//选择的
                _shelvesDown = @"0";//_shelvesDown//0上架1下架
            }
            else//手动输入
            {
                _shelvesDown = @"1";
            }
        }
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"个人求职简历已创建成功，是否发布求职申请?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
    }
//    sender.userInteractionEnabled = NO;
//    [sender setBackgroundColor:RGB(0, 172, 255)];
//    status = @"0";
//    [self SubmitResume];
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

#pragma mark 判断必填项有没有没填写的,YES表示有为空的
- (BOOL)checkModelPropertyNil
{
    
    BOOL commit = NO;
//    int i = 0;
    if (self.model.photoList.count ==0 && self.model.videoList.count == 0) {
        
        commit = YES;
        [self.photoView addSubview:self.redView];//将红色字添加
        unChooseInter = 1;
        return commit;
    }
//    for (NSArray *array in self.titleArray) {
//        int j = 0;
//        for (NSString *string in array) {
//            if ([self isHiddenWithString:string]) {
//                NSString *str = self.propertyArray[i][j];
//                if ([str isEqualToString:@""]) {
//                    commit = YES;
//                }
//            }
//        }
//    }
    //判断必须填写的文本框是否有没填的
    for (int i = 0 ; i < self.titleArray.count - 1; i++) {
        NSArray * array = self.titleArray[i];
        for (int j = 0 ; j < array.count; j++) {
            NSString * string = array[j];
            NSString * string1 = self.propertyArray[i][j];
            NSString * titleStr = array[j];
            if ([self isHiddenWithString:string])
            {
                if ([string1 isEqualToString:@""])
                {
                    if ([titleStr isEqualToString:@"期望职位:"]||[titleStr isEqualToString:@"期望薪资:"]||[titleStr isEqualToString:@"期望地区:"]) {
                        unChooseInter = 2;
                    }
                    else
                    {
                      unChooseInter = 1;
                    }
                    commit = YES;
                    return commit;
                }
                
            }
            if ([titleStr isEqualToString:@"手机号码:"]) {
                if (![NSString validateMobile:string1] && string1.length > 0) {
                    commit = YES;
                     return commit;
                }
            }
        }
    }
    
    
    
    return commit;
}

- (CommonTipView *)redView
{
    if (!_redView) {
        self.redView = [[CommonTipView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.redView.title = @"不能为空,至少上传一张";
        CGFloat x = SCREEN_WIDTH-8-16-8-(self.redView.size.width/2);
        self.redView.center = CGPointMake(x, self.photoView.size.height/2);
    }
    return _redView;
}

- (BOOL)isHiddenWithString:(NSString *)string
{
    NSLog(@"当前检测 == %@", string);
//    return [[string substringWithRange:NSMakeRange(0,1)] isEqualToString:@"*"];
    BOOL isOrNot = NO;
    if ([string isEqualToString:@"姓       名:"]||[string isEqualToString:@"性       别:"]||[string isEqualToString:@"出生年月:"]||[string isEqualToString:@"学       历:"]||[string isEqualToString:@"工作经验:"]||[string isEqualToString:@"期望职位:"]||[string isEqualToString:@"期望薪资:"]||[string isEqualToString:@"期望地区:"]) {
        isOrNot = YES;
    }
    else
    {
        isOrNot = NO;
    }
    return isOrNot;
}

#pragma mark -- 返回方法
- (void)backToFromViewController:(UIButton *)sender
{
//    [self.city removeFromSuperview];
    if (isDraft || !_isBuildNew) {
        
        if (isDraft)
        {
            if ([self isModelChange])
            {//从草稿中来，且界面有修改
                if (isShow)
                {
                    [self->saveDraftActionSheet hideFromView:self.view];
                    isShow = NO;
                }
                else
                {
                  [self showAction];
                }
            }
            else
            {
                [self backAction];
            }
        }
        else
        {//企业中申请时点击返回
            if (!Doingit) {//预览状态
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认取消申请?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alert.tag = 10000;
                [alert show];
//                Doingit = YES;
//               [self removePreview];
//                for (UIView * view in self.navigationController.navigationBar.subviews) {
//                    if ([view isKindOfClass:[UIButton class]] && view.tag == 3000) {
//                        UIButton * button = (UIButton*)view;
//                        button.selected = !button.selected;
//                    }
//                }
//                UIButton * btn = (UIButton*)[self.view viewWithTag:3000];
//                btn.selected = !btn.selected;
                return;
            }
            
            
            
            if (![self isModelNil])
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认取消申请?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alert.tag = 10000;
                [alert show];
            }
            else
            {
                UIView * view = [WINDOW viewWithTag:1001];
                [view removeFromSuperview];
                
              [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else{
        if ([self isModelNil]) {
            [self backAction];
        }else{
            
            if (isShow) {
                [self->saveDraftActionSheet hideFromView:self.view];
                isShow = NO;
            }
            else
            {
                if (backFromPerson) {//是从求职者界面返回时要判断界面是否有改变
                    if ([self changeOrNot]) {
                        [self showAction];
                    }
                    else
                    {
                        UIView * view = [WINDOW viewWithTag:1001];
                        [view removeFromSuperview];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                else
                {
                   [self showAction];
                }
            }
        }
    }
}
#pragma mark 判断申请时点击返回是哦福有数据
-(BOOL)backFromApply
{
    return YES;
}
-(BOOL)changeOrNot
{
    BOOL isOrNot= NO;
    for (int i = 0 ; i < self.propertyArray.count; i++) {
        NSArray * array = self.propertyArray[i];
        NSArray * array1 = self.detailPropertyArray[i];
        for (int j = 0 ; j < array.count; j++) {
            NSString * string = [NSString stringWithFormat:@"%@",array[j]];
            NSString * string1 = [NSString stringWithFormat:@"%@",array1[j]];
            if (![string isEqualToString:string1]) {
                isOrNot = YES;
                return isOrNot;
            }
        }
    }
    
    if (imageChanged) {
        return imageChanged;
    }
    
    
    return isOrNot;
}
- (void)backAction
{
    
    
    [self.city removeFromSuperview];
    
    UIView * view =[WINDOW viewWithTag:1001];
    [view removeFromSuperview];
//    NSLog(@"%@",self.navigationController.viewControllers);
    
    NSArray * viewArray = self.navigationController.viewControllers;
    if (viewArray.count>=3) {
        if ([self.navigationController.viewControllers[2] isKindOfClass:[self class]]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
//    if ([self.navigationController.viewControllers[2] isKindOfClass:[self class]]) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
//    }
}

- (void)showAction
{
    [self.dateView removeFromSuperview];
    [self.saveResumeDraftAS showInView:self.view];
}

- (WPActionSheet *)saveResumeDraftAS
{
    isShow = YES;
    NSString *string = @"";
    if (!isDraft) {
        string = @"草稿";
    }
//    if (!saveDraftActionSheet)
//    {
        saveDraftActionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[[NSString stringWithFormat:@"保存%@",string],[NSString stringWithFormat:@"不保存%@",string]] imageNames:nil top:64];
        saveDraftActionSheet.tag = 60;
        
//    }
    return saveDraftActionSheet;
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
    
    
    return imageChanged?imageChanged:contentChanged;
    
    return NO;
}

- (void)setRightBarButton
{
    if (self.isBuildNew) {
        UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize size = [@"完成" getSizeWithFont:FUCKFONT(14) Height:44];
        completeBtn.frame = CGRectMake(0, 0, size.width+5, 44);
        [completeBtn normalTitle:@"完成" Color:RGB(0, 0, 0) Font:kFONT(14)];
        [completeBtn selectedTitle:@"编辑" Color:RGB(0, 0, 0)];
        completeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [completeBtn addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *completeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:completeBtn];
        
        UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
        Button.frame = CGRectMake(0, 0, 55, 44);
        [Button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [Button normalTitle:@"草稿" Color:RGB(0, 0, 0) Font:kFONT(14)];
        Button.hidden = YES;
        Button.tag = 3001;
        _draftButton = Button;
        
        
        UILabel *countTip = ({
            UILabel *label = [UILabel new];
            
            label.backgroundColor = RGB(0, 172, 255);
            label.layer.cornerRadius = 10;
            label.layer.masksToBounds = YES;
            
            label.font = kFONT(12);
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            
            label;
        });
        countTip.tag = 3000;
        if (numberOfDraft) {
            Button.hidden = NO;
            [Button addSubview:countTip];
            countTip.text = [NSString stringWithFormat:@"%ld",numberOfDraft];
                [countTip mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(Button.mas_centerY);
                    make.right.mas_equalTo(Button.mas_centerX).offset(-8);
                    make.size.mas_equalTo(CGSizeMake(20, 20));
                    countTip.layer.cornerRadius = 10;
                }];
        }
        [Button addTarget:self action:@selector(rightDraft) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *draftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:Button];
        self.navigationItem.rightBarButtonItems = @[completeButtonItem,draftButtonItem];
    } else {
        
        UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize size = [@"预览" getSizeWithFont:FUCKFONT(14) Height:44];
        completeBtn.frame = CGRectMake(0, 0, size.width+5, 44);
        [completeBtn normalTitle:@"完成" Color:RGB(0, 0, 0) Font:kFONT(14)];
        [completeBtn selectedTitle:@"编辑" Color:RGB(0, 0, 0)];
        completeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        completeBtn.tag = 3000;
        [completeBtn addTarget:self action:@selector(rightBarButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *completeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:completeBtn];
        self.navigationItem.rightBarButtonItems = @[completeButtonItem];
//        self.title = @"申请";
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    }
    
}

#pragma mark 点击申请的确认
- (void)rightBtnClick
{
    willComplete = YES;
    if ([self checkModelPropertyNil]) {//判断是否有图片
        [self.tableView reloadData];
        
        NSIndexPath*scrollIndexPath;
        if (unChooseInter == 1) {
            CGPoint contentOffSet = self.tableView.contentOffset;
            contentOffSet.y = 0;
            [self.tableView setContentOffset:contentOffSet animated:YES];
            unChooseInter = 0;
            return;
        }
        else
        {
            scrollIndexPath =  [NSIndexPath indexPathForRow:0 inSection:1];
        }
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        unChooseInter = 0;
        return;
    }
    
    status = @"";
    if (self.detailModel.resume_id.length) {
        _shelvesDown = @"0";
         [self SubmitResume];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否同时发布到面试?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];

    }
    
//    [self SubmitResume];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000)
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
    else if (alertView.tag == 1000)
    {
      
    }
    else if (alertView.tag == 1001)
    {
        if (buttonIndex == 1) {
            self.isChoised = NO;
            self.changeResume = YES;
        }
    }
    else
    {
        if (buttonIndex == 1) {
          [self SubmitResume];
        }
//        [self SubmitResume];
    }
}
#pragma mark 点击草稿-->进入选择草稿
- (void)rightDraft
{
    WPResumeDraftVC *draft = [WPResumeDraftVC new];
    draft.delegate = self;
    draft.choiseResumeId = self.choiseDraftResumeId.length?self.choiseDraftResumeId:@"";
    [self.navigationController pushViewController:draft animated:YES];
}
#pragma mark -- 草稿页面 协议方法/从草稿页面返回时
- (void)draftReloadResumeDataWithModel:(WPResumeUserInfoModel *)model
{
    isDraft = YES;
    _choiseResumeId = @"";
    _choiseDraftResumeId = [NSString stringWithFormat:@"%@",model.resume_id];
    
    backFromPerson = NO;
    self.detailModel = model;
    telephoneShowed = model.TelIsShow.intValue?0:1;
    
    NSString * is_user = [NSString stringWithFormat:@"%@",model.is_user];
    if ([is_user isEqualToString:@"1"]) {
       self.chooseView.title.text = self.detailModel.name;
    }
    else
    {
        if (self.chooseView.title.text.length) {
            self.chooseView.title.text = @"";
        }
    }
   
    [self.educationListArray removeAllObjects];
    [self.educationListArray addObjectsFromArray:self.detailModel.educationList];
    [self.workListArray removeAllObjects];
    [self.workListArray addObjectsFromArray:self.detailModel.workList];
    self.listsArray = @[self.lightspotArray,self.educationListArray,self.workListArray];
    [self.tableView reloadData];
    
    NSString * string = [NSString stringWithFormat:@"%@",model.lightspot];
    NSString * string1 = [NSString stringWithFormat:@"%@",model.lightspotList];
    string1 = [WPMySecurities textFromBase64String:string1];
    string1 = [WPMySecurities textFromEmojiString:string1];
    if (string.length && ![string isEqualToString:@"(null)"])
    {
        self.lightspotStr = string;
    }
    else
    {
      self.lightspotStr = @"";
    }
    if (string1.length && ![string1 isEqualToString:@"(null)"])
    {
        self.lightStr = string1;
        model.lightspotList =string1;
    }
    else
    {
      self.lightStr = @"";
    }
    
    //判断哪些未填写，跳到具体位置
    willComplete = YES;
    if ([self checkModelPropertyNil])
    {//判断是否有图片
        [self.tableView reloadData];
        NSIndexPath*scrollIndexPath;
        if (unChooseInter == 1) {
            CGPoint contentOffSet = self.tableView.contentOffset;
            contentOffSet.y = 0;
            [self.tableView setContentOffset:contentOffSet animated:YES];
            unChooseInter = 0;
            return;
        }
        else
        {
            scrollIndexPath =  [NSIndexPath indexPathForRow:0 inSection:1];
        }
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        unChooseInter = 0;
    }
//    self.lightspotStr = [NSString stringWithFormat:@"%@",model.lightspot];
////    NSArray * listArray= model.lightspotList;
//    self.lightStr = [NSString stringWithFormat:@"%@",model.lightspotList];
    
}

- (WPChooseView *)chooseView
{
    if (!_chooseView)
    {
        self.chooseView = [[WPChooseView alloc]init];
//        self.chooseView.userInteractionEnabled = YES;
//        self.chooseView.label.text = self.isBuildNew ? @"选择求职者" : @"选择求职简历";
//        [self.chooseView.titleBtn setTitle:self.isBuildNew ? @"选择求职者" : @"调取已有求职简历" forState:UIControlStateNormal];//选择求职简历
        self.chooseView.BuildNew = self.isBuildNew;
        [self.chooseView addSubview:self.chooseView.button];
        [self.chooseView.titleBtn setTitle:self.isBuildNew ? @"选择求职者" : @"调取已有求职简历" forState:UIControlStateNormal];//选择求职简历
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseCompanyClick:)];
        [self.chooseView addGestureRecognizer:tap];
        [self.chooseView.button addTarget:self action:@selector(chooseCompanyClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseView.button addTarget:self action:@selector(chooseCompanyClickHeight:) forControlEvents:UIControlEventTouchDown];
        [self.chooseView.titleBtn addTarget:self action:@selector(chooseCompanyClickHeight:) forControlEvents:UIControlEventTouchDown];
        [self.chooseView.titleBtn addTarget:self action:@selector(chooseCompanyClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseView;
}
#pragma mark -- 点击 选择求职者和选择求职简历 推出的页面
- (void)chooseCompanyClick:(id)sender
{
    //    if (_isBuildNew) {
    //        WPChooseResumerController *company = [[WPChooseResumerController alloc]init];
    //        company.title = @"个人信息";
    //        [self.navigationController pushViewController:company animated:YES];
    //    }else{
    if (![sender isKindOfClass:[UIButton class]]) {
       self.chooseView.button.backgroundColor = RGB(226, 226, 226);
    }
    WPResumeUserVC *choose = [WPResumeUserVC new];
    if (_choiseResumeId.length) {
        choose.choiseResume = _choiseResumeId;
    }
    choose.title = _isBuildNew?@"求职者":@"求职简历";
    choose.delegate = self;
    choose.isRecuilist = self.isRecuilist;
    choose.isBuildNew = _isBuildNew;
    
    choose.isBuild = self.isBuild;//创建新的求职简历
    choose.isApplyFromList = self.isApplyFromList;
    choose.isApplyFromDetail = self.isApplyFromDetail;
    choose.isApplyFromDetailList = self.isApplyFromDetailList;
    choose.isFromCompanyGive = self.isFromCompanyGive;
    choose.isFromCompanyGiveList = self.isFromCompanyGiveList;
    
    choose.isFromCollection = self.isFromcollection;
    choose.isFromMuchCollection = self.isFromMuchcollection;
    
    choose.isFromMyApply = self.isFromMyApply;
    [self.navigationController pushViewController:choose animated:YES];
//    }
}
-(void)chooseCompanyClickHeight:(UIButton*)sender
{
  self.chooseView.button.backgroundColor = RGB(226, 226, 226);
}
#pragma mark -- 点击 个人亮点 推出页面
- (void)pushWPInterviewLightspotController
{
    
    if (self.isChoised) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有求职简历" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 1001;
        [alert show];
        return;
    }
    
    WPInterviewLightspotController *lightspot = [[WPInterviewLightspotController alloc]init];
    lightspot.delegate = self;
//    [lightspot.objects addObjectsFromArray:self.lightspotArray];
    lightspot.lightStr = self.lightStr;
    lightspot.buttonString = self.lightspotStr;
    [self.navigationController pushViewController:lightspot animated:YES];
}
#pragma mark -- 点击 教育经历 推出页面
- (void)pushWPInterviewEducationListController
{
    if (self.isChoised) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有求职简历" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 1001;
        [alert show];
        return;
    }
    
    
    if (self.educationListArray.count) {//教育经历已经填写
        WPInterviewEducationListController *educationList = [[WPInterviewEducationListController alloc]init];
        educationList.isApplyFromDetail = self.isApplyFromDetail;
        educationList.isAppyFromDetailList = self.isApplyFromDetailList;
        educationList.delegate = self;
        [educationList.dataSources addObjectsFromArray: self.educationListArray];
        [self.navigationController pushViewController:educationList animated:YES];
    }else{//没有填写教育经历
        WPInterviewEducationController *education = [[WPInterviewEducationController alloc]init];
        education.delegate = self;
        education.isAppyFromDetailList = self.isApplyFromDetailList;
        education.isApplyFromDetail = self.isApplyFromDetail;
        [self.navigationController pushViewController:education animated:YES];
    }
}
#pragma mark -- 点击 工作经历 推出页面
- (void)pushWPInterviewWorkListController
{
    if (self.isChoised) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有求职简历" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 1001;
        [alert show];
        return;
    }
    
    if (self.workListArray.count) {//工作经历已经填写
        WPInterviewWorkListController *worklist = [[WPInterviewWorkListController alloc]init];
        worklist.delegate = self;
        worklist.isAppyFromDetailList = self.isApplyFromDetailList;
        worklist.isApplyFromDetail = self.isApplyFromDetail;
        
        [worklist.dataSources addObjectsFromArray:self.workListArray ];
        [self.navigationController pushViewController:worklist animated:YES];
    }else{//未填写工作经历
        WPInterviewWorkController *worklist = [[WPInterviewWorkController alloc]init];
//        worklist.buildNew = YES;
        worklist.delegate = self;
        worklist.isAppyFromDetailList = self.isApplyFromDetailList;
        worklist.isApplyFromDetail = self.isApplyFromDetail;
        [self.navigationController pushViewController:worklist animated:YES];
    }
}
#pragma mark -- 从求职者界面返回的代理
- (void)reloadResumeDataWithModel:(WPResumeUserInfoModel *)model
{
    
    if (!self.isBuildNew) {//在申请状态下
        self.isChoised = YES;
    }
    
    
    NSArray * eduArray = model.educationList;
    for (Education * edu  in eduArray) {
        for (WPPathModel* model in edu.expList) {
            NSString * string = model.txtcontent;
          string = [WPMySecurities textFromBase64String:string];
           string =  [WPMySecurities textFromEmojiString:string];
            string.length?model.txtcontent = string:0;
        }
    }
    
    NSArray * worArray = model.workList;
    for (Work * wor  in worArray) {
        for (WPPathModel* model in wor.expList) {
            NSString * string = model.txtcontent;
            string = [WPMySecurities textFromBase64String:string];
            string =  [WPMySecurities textFromEmojiString:string];
            string.length?model.txtcontent = string:0;
        }
    }
    
    NSString * lightSport = model.lightspotList;
    lightSport  = [WPMySecurities textFromBase64String:lightSport];
    lightSport = [WPMySecurities textFromEmojiString:lightSport];
    model.lightspotList = lightSport;
    
    
    isDraft = NO;
    _choiseDraftResumeId = @"";
    _choiseResumeId = _isBuildNew?[NSString stringWithFormat:@"%@",model.resumeUserId]:[NSString stringWithFormat:@"%@",model.resume_id];
    
    backFromPerson = YES;
    NSArray *arr = nil;
    
    if (model.avatar.length > 0) {
        PhotoVideo *photo = [[PhotoVideo alloc]init];
        photo.thumb_path = model.avatar;
        photo.original_path = model.avatar;
        arr = [NSArray arrayWithObject:photo];
    }
    self.detailModel = model;
    self.chooseView.title.text = self.detailModel.Hope_Position;
    if (arr) {
        self.model.photoList = arr;
        [self.photoArray removeAllObjects];
        [self.photoArray addObjectsFromArray:arr];
    }
    //添加视频
    
    [self.educationListArray removeAllObjects];
    [self.workListArray removeAllObjects];
    
    [self.educationListArray addObjectsFromArray:model.educationList];
    [self.workListArray addObjectsFromArray:model.workList];
    
    for (Education * eduModel in self.educationListArray) {
        eduModel.educationStr = [NSString stringWithFormat:@"%@",[eduModel.expList[0] txtcontent]];
    }
    for (Work * workModel in self.workListArray) {
        workModel.workStr = [NSString stringWithFormat:@"%@",[workModel.expList[0] txtcontent]];
    }
    [self.tableView reloadData];
    [self updatePhotoView];
    NSString * string = [NSString stringWithFormat:@"%@",model.lightspot];
    NSString * string1 = [NSString stringWithFormat:@"%@",model.lightspotList];
    if (string.length && ![string isEqualToString:@"(null)"]) {
        self.lightspotStr = string;
    }
    else
    {
        self.lightspotStr = @"";
    }
    if (string1.length && ![string1 isEqualToString:@"(null)"]) {
        self.lightStr = string1;
    }
    else
    {
        self.lightStr = @"";
    }
    
    //判断哪些未填写，跳到具体位置
    willComplete = YES;
    if ([self checkModelPropertyNil]) {//判断是否有图片
        [self.tableView reloadData];
        NSIndexPath*scrollIndexPath;
        if (unChooseInter == 1) {
            CGPoint contentOffSet = self.tableView.contentOffset;
            contentOffSet.y = 0;
            [self.tableView setContentOffset:contentOffSet animated:YES];
            unChooseInter = 0;
            return;
        }
        else
        {
            scrollIndexPath =  [NSIndexPath indexPathForRow:0 inSection:1];
        }
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        unChooseInter = 0;
    }
    
//    self.lightspotStr = [NSString stringWithFormat:@"%@",model.lightspot];
////    if (model.lightspotList.count)
////    {
//      self.lightStr = [NSString stringWithFormat:@"%@",model.lightspotList];
//    }
    
//    self.lightStr;
//    lightspot.buttonString = self.lightspotStr;
    
}
#pragma mark -- 个人亮点 协议方法
- (void)getLightspotWithConstant:(NSString *)constant content:(NSString *)contents
{
    self.lightspotStr = constant;
    self.lightStr = contents;
//    self.lightspotArray = contents;//亮点内容
//    self.model.lightspotList = nil;
//    self.model.lightspotList = [NSArray arrayWithArray:contents];
    self.model.lightspot = constant;
    self.model.lightspotList = contents;
    [self.tableView reloadData];
}
#pragma mark 教育经历已经填写的代理
- (void)getEducationList:(NSArray *)educationArray
{
    [self.educationListArray removeAllObjects];
    [self.educationListArray addObjectsFromArray:educationArray];
    self.model.educationList = self.educationListArray;
    [self.tableView reloadData];
}
#pragma mark 教育经历未填写的代理
- (void)getEducation:(Education *)educationModel type:(WPInterviewEducationType)type
{
    [self.educationListArray addObject:educationModel];
//    self.model.educationList = nil;
    self.model.educationList = self.educationListArray;
    [self.tableView reloadData];
}


#pragma mark - 未填写工作经历的代理
- (void)getwork:(Work *)model type:(WPInterviewWorkType)type{
    [self.workListArray addObject:model];
    self.model.workList = self.workListArray;
    [self.tableView reloadData];
}
#pragma mark 已填写工作经历的代理
- (void)getWorkList:(NSArray *)workArray{
    [self.workListArray removeAllObjects];
    [self.workListArray addObjectsFromArray:workArray];
    self.model.workList = self.workListArray;
    [self.tableView reloadData];
}
#pragma mark -- 照片选择器显示代码
- (UIScrollView *)photoView{
    if (!_photoView) {
        _photoView = [[UIScrollView alloc]init];
        _photoView.backgroundColor = [UIColor whiteColor];
        _photoView.showsHorizontalScrollIndicator = NO;
    }
    return _photoView;
}
#pragma mark 求职者相片视图
- (UIView *)photoBaseView
{
    if (!_photoBaseView) {
        self.photoBaseView = [[UIView alloc]init];
        
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ItemViewHeight+8)];
        view.backgroundColor = RGB(235, 235, 235);
//        view.backgroundColor = [UIColor redColor];
        //选择求职者的视图
        self.chooseView.frame = CGRectMake(0, 8, SCREEN_WIDTH, ItemViewHeight);
        [view addSubview:self.chooseView];
        CGFloat height = 8;
        if (addChooseView) {
            height = view.bottom;
        }
        else
        {
            height = 0;
        }
        
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, PhotoViewHeight+16)];
        view2.backgroundColor = RGB(235, 235, 235);
        [view2 addSubview:self.photoView];
//        view2.backgroundColor = [UIColor redColor];
        
        [self.photoBaseView addSubview:view];
        [self.photoBaseView addSubview:view2];
        self.photoBaseView.frame = CGRectMake(0, 8, SCREEN_WIDTH, height+view2.height);
        
        self.photoView.frame = CGRectMake(0, 8, SCREEN_WIDTH-28, PhotoViewHeight);
        [self.photoView addSubview:self.addPhotosBtn];
        
        /** 照片墙翻页 */
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-28, view2.top+8, 28, PhotoViewHeight) ImageName:@"jinru" Target:self Action:@selector(photosViewClick:)];
        
        scrollBtn.backgroundColor = [UIColor whiteColor];
        
        [_photoBaseView addSubview:scrollBtn];
    }
    return _photoBaseView;
}

#pragma mark -- 推出照片墙 照片查看页面／点击查看所有的照片
-(void)photosViewClick:(UIButton *)sender
{
    
    if (self.isChoised) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有求职简历" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 1001;
        [alert show];
        return;
    }
    
    SAYPhotoManagerViewController *vc = [[SAYPhotoManagerViewController alloc]init];
    vc.arr =  self.photoArray;//将图片数组和视频数组赋值
    vc.videoArr = self.vedioArray;
    vc.isEdit = YES;
    vc.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
}
#pragma makr SAYPhotoManagerViewControllerDelegate/图片编辑返回时需要重新处理图片
-(void)UpdateImageDelegate:(NSArray *)arr VideoArr:(NSArray *)videoArr
{
    [self.photoArray removeAllObjects];
    [self.photoArray addObjectsFromArray:arr];
    self.model.photoList = arr;//判断是否有图片时用到
    [self.vedioArray removeAllObjects];
    [self.vedioArray addObjectsFromArray:videoArr];
    self.model.videoList = videoArr;//判断是否有视频时用到
    [self updatePhotoView];
}

#pragma mark 添加图片

- (UIButton *)addPhotosBtn
{
    if (!_addPhotosBtn) {
        self.addPhotosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addPhotosBtn.frame = CGRectMake(kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
//        [self.addPhotosBtn setBackgroundColor:[UIColor redColor]];
        
        [self.addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
//        [self.addPhotosBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.addPhotosBtn addTarget:self action:@selector(addPhotos:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addPhotosBtn;
}

#pragma mark - 点击添加照片
-(void)addPhotos:(UIButton *)sender
{
    if (self.isChoised) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有求职简历" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 1001;
        [alert show];
        return;
    }
    
    
    
    [TextCell.textFied resignFirstResponder];
    [self alertshow];
}

- (void)alertshow
{
    HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册",@"相机",nil];
//     HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册",@"相机",@"视频", nil];
    sheet.tag = 789;
    [sheet show];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 789) {
        if (buttonIndex == 0) {//
            
        }else if (buttonIndex == 1){//
            [self fromAlbums];
        }else if (buttonIndex == 2){//
            [self fromCamera];
        }else if (buttonIndex == 3){//
            [self videoFromCamera];
        }
    }
    else
    {
        if (buttonIndex == 1) {
            self.model.sex = @"男";
            [self.tableView reloadData];
        }
        else if (buttonIndex == 2)
        {
            self.model.sex = @"女";
            [self.tableView reloadData];
        }
    }
}

#pragma mark - WPActionSheet代理，添加照片或视频
- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (sheet.tag == 60)
    {
        if (buttonIndex == 1)
        {
            status = @"1";
            self.saveDraft = YES;
            [self SubmitResume];
            isShow = NO;
        }
        else if (buttonIndex == 2)
        {
            isShow = NO;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            isShow = NO;
        }
    }
}

#pragma mark 更新图片
- (void)updatePhotoView
{
    for (UIView *view in self.photoView.subviews) {
        [view removeFromSuperview];
    }
    
    if (self.photoArray.count + self.vedioArray.count == 0)
    {
        [_addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
    }
    else
    {
        [_addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
    }
    
    for (int i = 0; i < self.photoArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
        button.tag = PhotoTag+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        //        SPPhotoAsset *asset = ;
        //        [button setImage:[self.photosArr[i] thumbImage] forState:UIControlStateNormal];
        if ([self.photoArray[i] isKindOfClass:[SPPhotoAsset class]]) {
            [button setImage:[self.photoArray[i] originImage] forState:UIControlStateNormal];
        }else{
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photoArray[i] thumb_path]]];
            [button sd_setImageWithURL:url forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.photoView addSubview:button];
    }
    
    CGFloat width = self.photoArray.count*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12);
    
    for (int i = 0; i < self.vedioArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+kHEIGHT(6))+width, 10, PhotoHeight, PhotoHeight);
        button.tag = VideoTag+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.vedioArray[i] isKindOfClass:[NSString class]]) {
            [button setImage:[UIImage getImage:self.vedioArray[i]] forState:UIControlStateNormal];
        }else if([self.vedioArray[i] isKindOfClass:[ALAsset class]]){
            ALAsset *asset = self.vedioArray[i];
            [button setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
        }else{
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.vedioArray[i] thumb_path]]];
            [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
//            [button sd_setImageWithURL:url forState:UIControlStateNormal];
        }
        [self.photoView addSubview:button];
        
        UIImageView *subImageV = [[UIImageView alloc]initWithFrame:CGRectMake(PhotoHeight/2-10, PhotoHeight/2-10, 20, 20)];
        subImageV.image = [UIImage imageNamed:@"video_play"];
        [button addSubview:subImageV];
    }
    
    if (self.photoArray.count == 8) {//&&self.vedioArray.count == 4
        self.photoView.contentSize = CGSizeMake(8*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), PhotoViewHeight);
    }else{
        NSInteger count = self.photoArray.count+self.vedioArray.count;
        self.photoView.contentSize = CGSizeMake(count*(PhotoHeight+kHEIGHT(6))+PhotoHeight+kHEIGHT(12), PhotoViewHeight);
        _addPhotosBtn.frame = CGRectMake(count*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
        [self.photoView addSubview:_addPhotosBtn];
    }
}

#pragma mark 点击查看求职者的图片
- (void)checkImageClick:(UIButton *)sender
{
    if (self.isChoised) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有求职简历" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 1001;
        [alert show];
        return;
    }
    
    if (sender.tag>=PhotoTag &&sender.tag <VideoTag) {//点击查看图片
        
         NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < self.photoArray.count; i++) {/**< 头像或背景图 */
            MJPhoto *photo = [[MJPhoto alloc]init];
            if ([self.photoArray[i] isKindOfClass:[PhotoVideo class]]) {
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photoArray[i] original_path]]];
                photo.url = url;
            }else{
                photo.image = [self.photoArray[i] originImage];
            }
            photo.srcImageView = [(UIButton *)[self.photoView viewWithTag:50+i] imageView];
            [arr addObject:photo];
        }
        SPPhotoBrowser *brower = [[SPPhotoBrowser alloc] init];
        brower.delegate = self;
        brower.currentPhotoIndex = sender.tag-PhotoTag;
        brower.photos = arr;
        [self.navigationController pushViewController:brower animated:YES];
//        [brower show];//隐藏tabbar
    }else{//点击查看视频
        NSLog(@"视频");
        [self checkVideos:sender.tag-VideoTag];
    }
}
- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser coverImageAtIndex:(NSInteger)index
{
    id object = self.photoArray[index];
    [self.photoArray removeObjectAtIndex:index];
    [self.photoArray insertObject:object atIndex:0];
    [self updatePhotoView];
}
#pragma mark 点击图片大图显示删除图片的代理
- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser deleteImageAtIndex:(NSInteger)index{
    if (self.photoArray.count == 1)
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请至少保留一张图片" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
    }
    else
    {
       [self.photoArray removeObjectAtIndex:index];
    }
    [self updatePhotoView];
}

#pragma mark 查看视频  推出视频播放页面
-(void)checkVideos:(NSInteger)number
{
    
    if (self.isChoised) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有求职简历" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 1001;
        [alert show];
        return;
    }
    
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
        video.videoUrl =[IPADDRESS stringByAppendingString:[self.vedioArray[number] original_path]];
    }
    [video showPickerVc:self];
    
}

- (void)onPlaybackFinished
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

#pragma mark 拍照
- (void)fromCamera {
    
    if (self.photoArray.count == 8) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多上传8张图片" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        alert.tag = 1000;
        return;
    }
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        //        [@"您的设备不支持拍照" alertInViewController:self];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    //    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    picker.bk_didCancelBlock = ^(UIImagePickerController *picker){
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    picker.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//UIImagePickerControllerOriginalImage
        SPPhotoAsset *asset = [[SPPhotoAsset alloc]init];
        asset.image = image;
        [self.photoArray addObject:asset];
        self.model.photoList = self.photoArray;
        imageChanged = YES;
        [self updatePhotoView];
        //        [_recuilistApplyView removeRedView];
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark 相册
- (void)fromAlbums {
    
    if (self.photoArray.count == 8) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多上传8张图片" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        alert.tag = 1000;
        return;
    }
    
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 8 - self.model.photoList.count;//12-》8
    //        [pickerVc show];
    [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
    
    pickerVc.callBack = ^(NSArray *assets){
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        for (MLSelectPhotoAssets *asset in assets) {
            SPPhotoAsset *spAsset = [[SPPhotoAsset alloc]init];
            spAsset.asset = asset.asset;
            [photos addObject:spAsset];
        }
        [self.photoArray addObjectsFromArray:photos];
        self.model.photoList = self.photoArray;
        imageChanged = YES;
        [self updatePhotoView];
        //        [_recuilistApplyView removeRedView];
    };
}

#pragma mark 拍摄视频
-(void)videoFromCamera
{
    if (self.model.videoList.count == 4) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多上传4个视频" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag = 1000;
        [alert show];
        return;
    }
    DBTakeVideoVC *tackVedio = [[DBTakeVideoVC alloc] init];
    tackVedio.delegate = self;
    tackVedio.fileCount = 4-self.model.videoList.count;
    tackVedio.takeVideoDelegate = self;
    [self.navigationController pushViewController:tackVedio animated:YES];
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tackVedio];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
  
}

#pragma mark 相册选择视频
-(void)videoFromAlbums
{
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = 4-self.model.videoList.count;
    picker.assetsFilter = [ALAssetsFilter allVideos];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
    [self.vedioArray addObject:filePaht];
    self.model.videoList = self.vedioArray;
    imageChanged = YES;
    [self updatePhotoView];
    //    [self.interView refreshVideos];
}

-(SPSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[SPSelectView alloc]initWithTop:64];
        _selectView.delegate = self;
    }
    else
    {
        CGRect rect = _selectView.line.frame;
        rect.size.height = 0.5;
        _selectView.line.frame = rect;
    }
    return _selectView;
}

-(SPDateView *)dateView
{
    if (!_dateView) {
        __weak typeof(self) weakSelf = self;
        _dateView = [[SPDateView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-44, SCREEN_WIDTH, 216+44)];
        _dateView.getDateBlock = ^(NSString *dateStr){
            weakSelf.model.birthday = dateStr;
            [weakSelf.tableView reloadData];
        };
        NSDate * mydate = [NSDate date];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        DebugLog(@"---当前的时间的字符串 =%@",currentDateStr);
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = nil;
        comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:-16];
        [adcomps setMonth:0];
        [adcomps setDay:0];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
        NSString *beforDate = [dateFormatter stringFromDate:newdate];
        _dateView.datePickerView.maximumDate =  newdate;
    }
    return _dateView;
}

-(SPSelectMoreView *)selectMoreView
{
    if (!_selectMoreView) {
        _selectMoreView = [[SPSelectMoreView alloc]initWithTop:64];
        _selectMoreView.delegate = self;
    }
    else
    {
        CGRect rect = _selectMoreView.line.frame;
        rect.size.height = 0.5;
        _selectMoreView.line.frame = rect;
    }
    return _selectMoreView;
}

- (UISelectCity *)city
{
    if (!_city) {
        
        _city = [[UISelectCity alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _city.delegate = self;
     
        UIView * view =[WINDOW viewWithTag:1001];
        [view removeFromSuperview];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *subView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        subView1.tag = 1001;
        subView1.backgroundColor = RGBA(0, 0, 0, 0);
        [window addSubview:subView1];
        WS(ws);
        _city.touchHide =^(){
            [ws touchHide:nil];
        };
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]init];
        [tap1 addTarget:self action:@selector(touchHide:)];
        [subView1 addGestureRecognizer:tap1];
        [window addSubview:_city];
    }
    else
    {
        _city.lineLabel.height = 0.5;
    }
    return _city;
}
#pragma mark 点击弹出的视图时隐藏视图
- (void)touchHide:(UITapGestureRecognizer *)tap{
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    [self.city remove];
}

#pragma mark -- 请选择求职者页面 协议代理方法（在简历详情界面）
- (void)reloadResumeUserDataWithModel:(WPResumeUserInfoModel *)model
{
//    if (model.avatar.length>0) {
//        [self.photoArray addObject:model.avatar];
//    }
    self.detailModel = model;
    
}
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
//    [self.tableView reloadData];
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
// pickerView 每列个数
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
//    [self.tableView reloadData];
//}
////返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return _proTitleList[row];
//}
#pragma mark 点击性别，出生年月，学历，工作年限
- (void)switchValueInSectionFirstWithIndexPath:(NSInteger)row
{
    
    if (self.isChoised) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有求职简历" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 1001;
        [alert show];
        return;
    }
    
    
    switch (row) {
        case 1:
            NSLog(@"性别");
//      [self sexControlClick];
        {
            HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"男",@"女",nil];
            sheet.tag = 790;
            [sheet show];
        }
            
            break;
        case 2:
            NSLog(@"出生年月");
            [self.dateView showInView:WINDOW];
            break;
        case 3:
            NSLog(@"学历");
        {
            NSMutableArray * muarray = [[NSMutableArray alloc]init];
            NSArray * array =[SPLocalApplyArray educationArray];
            [muarray addObjectsFromArray:array];
            [muarray removeFirstObject];
            [self.selectView setLocalData:muarray];
        }
//            [self.selectView setLocalData:[SPLocalApplyArray educationArray]];
            break;
        case 4:
            NSLog(@"工作年限");
        {
            NSMutableArray * muarray = [[NSMutableArray alloc]init];
            NSArray * array = [SPLocalApplyArray workTimeArray];
            [muarray addObjectsFromArray:array];
            [muarray removeFirstObject];
            [self.selectView setLocalData:muarray];
        
        }
//            [self.selectView setLocalData:[SPLocalApplyArray workTimeArray]];
            break;
        case 5:
            NSLog(@"目前薪资");
        {
            NSMutableArray * muarray = [[NSMutableArray alloc]init];
            NSArray * array = [SPLocalApplyArray salaryArray];
            [muarray addObjectsFromArray:array];
            [muarray removeFirstObject];
            [muarray removeFirstObject];
         [self.selectView setLocalData:muarray];
        }
//            [self.selectView setLocalData:[SPLocalApplyArray salaryArray]];
            break;
        case 6:
            NSLog(@"婚姻状况");
            [self.selectView setLocalData:[SPLocalApplyArray marriageArray]];//
            break;
        case 7:
            NSLog(@"户籍");
            self.selectView.isIndustry = NO;
            self.selectView.isArea = YES;
            self.selectView.threeStage = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
            break;
        case 8:
            NSLog(@"现居住地");
        {
            self.nowAddress = YES;
            UIView *view1 = [WINDOW viewWithTag:1001];
            view1.hidden = NO;
            self.city.isArea = YES;
            self.city.isIndusty = NO;
            self.city.isCity = YES;
            self.city.isPosition = NO;
            //将定位的id保存以便于判断数组中应添加的类型
            [[NSUserDefaults standardUserDefaults] setObject:@"340100" forKey:@"LOCALID"];
            self.city.localName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCity"];
            self.city.localFatherName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localPrivince"];
            self.city.localID = @"340100";
            self.city.localFatherId = @"340000";
            SPIndexPath * indexPath = [[SPIndexPath alloc]init];
            indexPath.row = -1;
            indexPath.section = -1;
            [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":self.city.localID} citySelectedindex:indexPath];
        }
//            self.selectView.isIndustry = NO;
//            self.selectView.isArea = YES;
//            self.selectView.threeStage = YES;
//            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
        default:
            break;
    }
}

#pragma mark 点击期望薪资，地区，职位和福利
- (void)switchValueInSectionSecondWithIndexPath:(NSInteger)row
{
//    UIView *view1 = [WINDOW viewWithTag:1001];
//    view1.hidden = YES;
//    [self.city remove];
    
    if (self.isChoised) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有求职简历" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 1001;
        [alert show];
        return;
    }
    
    
    switch (row) {
        case 0:
            NSLog(@"期望职位");
            self.selectView.isIndustry = NO;
            self.selectView.isArea = NO;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getPosition",@"fatherid":@"0"}];
            break;
        case 1:
            NSLog(@"期望薪资");
        {
            NSMutableArray * muarry = [[NSMutableArray alloc]init];
            NSArray * array = [SPLocalApplyArray salaryArray];
            [muarry addObjectsFromArray:array];
            [muarry removeFirstObject];
            [self.selectView setLocalData:muarry];
        }
//            [self.selectView setLocalData:[SPLocalApplyArray salaryArray]];
            break;
        case 2:
        {
            NSLog(@"期望地区");
            self.nowAddress = NO;
            UIView *view1 = [WINDOW viewWithTag:1001];
            view1.hidden = NO;
            self.city.isArea = YES;
            self.city.isIndusty = NO;
            self.city.isCity = YES;
            self.city.isPosition = NO;
            //将定位的id保存以便于判断数组中应添加的类型
            [[NSUserDefaults standardUserDefaults] setObject:@"340100" forKey:@"LOCALID"];
            self.city.localName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCity"];
            self.city.localFatherName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localPrivince"];
            self.city.localID = @"340100";
            self.city.localFatherId = @"340000";
            SPIndexPath * indexPath = [[SPIndexPath alloc]init];
            indexPath.row = -1;
            indexPath.section = -1;
            [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":self.city.localID} citySelectedindex:indexPath];
        }
            break;
        case 3:
            NSLog(@"期望福利");
            [self.selectMoreView setLocalData:[SPLocalApplyArray welfareArray] SelectArr:nil];
            break;
        default:
            
            break;
    }
}
#pragma mark  点击选择期望地区的代理
- (void)citUiselectDelegateFatherModel:(IndustryModel *)f_model andChildModel:(IndustryModel *)c_model
{
    [self.city remove];
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    
    if (!f_model.fullname) {
        f_model.fullname = [f_model.industryName stringByReplacingOccurrencesOfString:@"全" withString:@""];
    }
    
    if (self.nowAddress) {
        self.nowAddress = NO;
        if (f_model.fullname.length && f_model.industryID) {
            self.model.address = f_model.fullname;
            self.model.addressId = f_model.industryID;
        }
    }
    else
    {
        if (f_model.fullname.length && f_model.industryID) {
            self.model.Hope_address = f_model.fullname;
            self.model.hopeAddressID = f_model.industryID;
        }
    }
    
//    if (f_model.fullname.length && f_model.industryID) {
//        self.model.Hope_address = f_model.fullname;
//        self.model.hopeAddressID = f_model.industryID;
//    }
    [_tableView reloadData];
  
}
- (void)getFirstModel:(IndustryModel *)model withTag:(NSInteger)tag
{
    switch (tag) {
        case 1:
            self.model.sex = model.industryName;
            break;
        case 3:
            self.model.education = model.industryName;
            break;
        case 4:
            self.model.workTime = model.industryName;
            break;
        case 5:
            self.model.nowSalary = model.industryName;
            break;
        case 6:
            self.model.marriage = model.industryName;
            break;
        case 7:
            self.model.homeTown = model.industryName;
            break;
        case 8:
            self.model.address = model.industryName;
            self.model.addressId = model.industryID;
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (void)getSecondModel:(IndustryModel *)model withTag:(NSInteger)tag
{
    switch (tag) {
        case 0:
            self.model.Hope_Position = model.industryName;
            self.model.hopePositionNo = model.industryID;
            break;
        case 1:
            self.model.Hope_salary = model.industryName;
            break;
        case 2:
            self.model.Hope_address = model.industryName;
            self.model.hopeAddressID = model.industryID;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

-(void)SPSelectViewDelegate:(IndustryModel *)model
{
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    switch (baseTag) {
        case 0:
            [self getFirstModel:model withTag:cateTag];
            break;
        case 1:
            [self getSecondModel:model withTag:cateTag];
            break;
        default:
            break;
    }
}

- (void)switchValueInSectionThirdWithIndexPath:(NSInteger)row
{
    switch (row) {
        case 0:
            [self pushWPInterviewLightspotController];
            break;
        case 1:
            [self pushWPInterviewEducationListController];
            break;
        case 2:
            [self pushWPInterviewWorkListController];
            break;
            
        default:
            break;
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    [TextCell textFieldIsnotNil:NO];
//    return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.isChoised) {
        [textField resignFirstResponder];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否修改已有求职简历" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 1001;
        [alert show];
        return;
    }
    
    
    
    [TextCell textFieldIsnotNil:NO];
    [self.dateView removeFromSuperview];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (90 == textField.tag ) {
        self.model.name = textField.text;

    }else if (91 == textField.tag){
        self.model.tel = textField.text;
    }
    return YES;
}
#pragma mark 设置福利
- (void)SPSelectMoreViewDelegate:(SPSelectMoreView *)selectMoreView arr:(NSArray *)arr
{
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    if (selectMoreView == _selectMoreView) {
        if (arr.count == 0) {
            self.model.Hope_welfare = @"";
        }else{
            NSString *str = [[NSString alloc]init];
            for (NSString *subStr in arr) {
                str = [NSString stringWithFormat:@"%@%@/",str,subStr];
            }
            self.model.Hope_welfare = str;
        }
    }
    [self.tableView reloadData];
}
#pragma mark -- tableView显示代码
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(43);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [TextCell resignFirstResponder];
    baseTag = indexPath.section;
    cateTag = indexPath.row;
    if (self.dateView.superview) {
        [self.dateView removeFromSuperview];
    }
    switch (indexPath.section) {
        case 0:
            [self switchValueInSectionFirstWithIndexPath:indexPath.row];
            break;
        case 1:
            [self switchValueInSectionSecondWithIndexPath:indexPath.row];
            break;
        case 2:
            [self switchValueInSectionThirdWithIndexPath:indexPath.row];
            break;
        default:
            break;
    }
}


#pragma mark 姓名，性别，出生年月
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPRecruiteCell *cell = [tableView dequeueReusableCellWithIdentifier:kWPRecruitCellReuse forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.section][indexPath.row];
    cell.placeHolder = self.placeholderArray[indexPath.section][indexPath.row];
    cell.swithEnable = NO;
    cell.openShowTelephone = NO;
    NSString *string = self.typeArray[indexPath.section][indexPath.row];
    if ([string isEqualToString:@"Text"]) {
        cell.enable = YES;
//        TextCell = cell;
        cell.textFied.tag = 90;
        cell.textFied.delegate = self;
        cell.textFied.keyboardType = UIKeyboardTypeDefault;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else  if ([string isEqualToString:@"Text_num"]) {
        cell.delegate = self;
        cell.openShowTelephone = telephoneShowed;
        cell.enable = YES;
        cell.swithEnable = YES;
//        TextCell = cell;
        cell.textFied.delegate = self;
        cell.textFied.tag = 91;
        cell.textFied.keyboardType  = UIKeyboardTypeNumberPad;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else{
        cell.enable = NO;
        cell.textFied.enabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    if (indexPath.section == 2) {
        cell.enable = NO;
        cell.textFied.enabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    if (indexPath.section < 2) {
        NSLog(@"%ld",(long)indexPath.section);
        NSString *modelString = self.propertyArray[indexPath.section][indexPath.row];
        cell.text = @"";
        if (modelString.length > 0) {
            cell.text = modelString;
            if ([cell.title isEqualToString:@"期望福利:"]) {
                cell.text = [modelString substringToIndex:modelString.length-1];
            }
            if (willComplete) {
                if ([cell.title isEqualToString:@"手机号码:"]) {
                    [cell textFieldIsnotNil:YES];
                }else{
                    [cell textFieldIsnotNil:NO];
                }
                
            }
        }else{
            if (willComplete) {
                
                [cell textFieldIsnotNil:YES];
            }
        }
    }else{
        NSArray *arr = self.listsArray[indexPath.row];//从数组中分别取出个人亮点，教育经历和工作经历三个数组
        NSString *title = self.titleArray[indexPath.section][indexPath.row];
        cell.text = @"";
        if ([title isEqualToString:@"个人亮点:"]) {
            if (self.model.lightspot.length > 0 || self.lightStr.length >0) {
                cell.text = [NSString stringWithFormat:@"%@%@",[title substringToIndex:4],@"已填写"];
            }
        }
        if (arr.count>0) {//如果数组中有数据则为已填写
            NSString *str = self.titleArray[indexPath.section][indexPath.row];
            cell.text = [NSString stringWithFormat:@"%@%@",[str substringToIndex:4],@"已填写"];
        }
        if (willComplete) {
            [cell textFieldIsnotNil:YES];
        }
    }
    
    if (willComplete)
    {
//        if (indexPath.section == 0) {
//            switch (indexPath.row) {
//                case 0:
//                {
//                    if (cell.textFied.text.length == 0) {
//                        CommonTipView * tipView = [[CommonTipView alloc] init];
//                        tipView.title = @"不能为空";
//                        CGFloat x = SCREEN_WIDTH-8-16-8-tipView.size.width/2;
//                        tipView.center = CGPointMake(x,kHEIGHT(43)/2);
//                        [cell.contentView addSubview:tipView];
//                    }
//                }
//                    break;
//                case 1:
//                {
//                    if (cell.textFied.text.length == 0) {
//                        CommonTipView * tipView = [[CommonTipView alloc] init];
//                        tipView.title = @"不能为空";
//                        CGFloat x = SCREEN_WIDTH-8-16-8-tipView.size.width/2;
//                        tipView.center = CGPointMake(x,kHEIGHT(43)/2);
//                        [cell.contentView addSubview:tipView];
//                    }
//                }
//                    break;
//                case 2:
//                {
//                    if (cell.textFied.text.length == 0) {
//                        CommonTipView * tipView = [[CommonTipView alloc] init];
//                        tipView.title = @"不能为空";
//                        CGFloat x = SCREEN_WIDTH-8-16-8-tipView.size.width/2;
//                        tipView.center = CGPointMake(x,kHEIGHT(43)/2);
//                        [cell.contentView addSubview:tipView];
//                    }
//                
//                }
//                    break;
//                case 3:
//                {
//                    if (cell.textFied.text.length == 0) {
//                        CommonTipView * tipView = [[CommonTipView alloc] init];
//                        tipView.title = @"不能为空";
//                        CGFloat x = SCREEN_WIDTH-8-16-8-tipView.size.width/2;
//                        tipView.center = CGPointMake(x,kHEIGHT(43)/2);
//                        [cell.contentView addSubview:tipView];
//                    }
//                }
//                    break;
//                case 4:
//                {
//                    if (cell.textFied.text.length == 0) {
//                        CommonTipView * tipView = [[CommonTipView alloc] init];
//                        tipView.title = @"不能为空";
//                        CGFloat x = SCREEN_WIDTH-8-16-8-tipView.size.width/2;
//                        tipView.center = CGPointMake(x,kHEIGHT(43)/2);
//                        [cell.contentView addSubview:tipView];
//                    }
//                }
//                    break;
//                default:
//                    break;
//            }
//        }
    }
    return cell;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kHEIGHT(43);
        self.tableView.tableHeaderView = self.photoBaseView;
        [self.tableView registerClass:[WPRecruiteCell class] forCellReuseIdentifier:kWPRecruitCellReuse];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
    return _tableView;
}


-(void)setDetailModel:(WPResumeUserInfoModel *)detailModel
{
    _detailModel = detailModel;
    self.model = detailModel;
    self.detailPropertyArray = @[@[self.detailModel.name,self.detailModel.sex,self.detailModel.birthday,self.detailModel.education,self.detailModel.workTime,self.detailModel.nowSalary,self.detailModel.marriage,self.detailModel.homeTown,self.detailModel.address],
                                 @[self.detailModel.Hope_Position,self.detailModel.Hope_salary,self.detailModel.Hope_address,self.detailModel.Hope_welfare,self.detailModel.tel]];
    [self.photoArray removeAllObjects];
    [self.vedioArray removeAllObjects];
    [self.photoArray addObjectsFromArray:detailModel.photoList];
    [self.vedioArray addObjectsFromArray:detailModel.videoList];
    [self updatePhotoView];
}
#pragma mark -- 系列懒加载代码
- (NSMutableArray *)educationListArray
{
    if (!_educationListArray) {
        self.educationListArray = [NSMutableArray array];
    }
    return _educationListArray;
}

- (NSArray *)lightspotArray
{
    if (!_lightspotArray) {
        self.lightspotArray = [NSArray array];
    }
    return _lightspotArray;
}

- (NSMutableArray *)workListArray
{
    if (!_workListArray) {
        self.workListArray = [NSMutableArray array];
    }
    return _workListArray;
}

- (NSArray *)propertyArray
{
    self.propertyArray = @[@[self.model.name,self.model.sex,self.model.birthday,self.model.education,self.model.workTime,self.model.nowSalary,self.model.marriage,self.model.homeTown,self.model.address],
                           @[self.model.Hope_Position,self.model.Hope_salary,self.model.Hope_address,self.model.Hope_welfare,self.model.tel]];
    return _propertyArray;
}

- (WPResumeUserInfoModel *)model
{
    if (!_model) {
        self.model = [[WPResumeUserInfoModel alloc]init];
    }
    return _model;
}

- (NSArray *)listsArray
{
    self.listsArray = @[self.lightspotArray,self.educationListArray,self.workListArray];
    return _listsArray;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        self.titleArray = @[@[@"姓       名:",@"性       别:",@"出生年月:",@"学       历:",@"工作经验:",@"目前薪资:",@"婚姻状况:",@"户       籍:",@"现居住地:"],
                            @[@"期望职位:",@"期望薪资:",@"期望地区:",@"期望福利:",@"手机号码:"],
                            @[@"个人亮点:",@"教育经历:",@"工作经历:"]];
    }
    return _titleArray;
}

- (NSArray *)placeholderArray{
    if (!_placeholderArray) {
        self.placeholderArray = @[@[@"2-4汉字或字母",@"请选择性别",@"请选择出生年月",@"请选择学历",@"请选择工作经验",@"请选择目前薪资",@"请选择婚姻状况",@"请选择户籍",@"请选择现居住地"],
                                  @[@"请选择期望职位",@"请选择期望薪资",@"请选择期望地区",@"请选择期望福利",@"请填写手机号码"],
                                  @[@"请填写个人亮点",@"请填写教育经历",@"请填写工作经历"]];
    }
    return _placeholderArray;
}

- (NSArray *)typeArray{
    if (!_typeArray) {
        self.typeArray = @[@[@"Text",@"Button",@"Button",@"Button",@"Button",@"Button",@"Button",@"Button",@"Button"],
                           @[@"Button",@"Button",@"Button",@"Button",@"Text_num"],
                           @[@"Push",@"Push",@"Push"]];
    }
    return _typeArray;
}

- (NSMutableArray *)vedioArray
{
    if (!_vedioArray) {
        self.vedioArray = [NSMutableArray array];
    }
    return _vedioArray;
}

- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        self.photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requstNumOfDraft];
    self.chooseView.button.backgroundColor = [UIColor whiteColor];
}
#pragma mark - Networking 发布简历
- (void)SubmitResume
{
    updateImage = YES;
    //上传数据流数组
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    //将图片数组转化为二进制数据
    //    NSArray *photoArr = [self formDataWithPhotoArray:self.recuilistApplyView.photosArray];
    for (int i = 0; i < self.photoArray.count; i++) {
        WPFormData *formDatas = [[WPFormData alloc]init];
        //        formDatas.data = UIImageJPEGRepresentation([self.interView.photosArr[i] originImage], 0.5);
        UIImage *image;
        if ([self.photoArray[i] isKindOfClass:[SPPhotoAsset class]]) {
            image = [self.photoArray[i] originImage];
            formDatas.data = UIImageJPEGRepresentation(image, 0.5);
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photoArray[i] original_path]]]];
            formDatas.data = data;
            
        }
        formDatas.name = [NSString stringWithFormat:@"PhotoAddress%d",i];
        formDatas.filename = [NSString stringWithFormat:@"PhotoAddress%d.png",i];
        formDatas.mimeType = @"image/png";
        [dataArr addObject:formDatas];
        if (!formDatas.data) {
            updateImage = NO;
        }
    }
    //    [dataArr addObject:photoArr];
    //将视频数组转化为二进制数据
    //    NSArray *videoArr = [self formDataWithVideoArray:self.recuilistApplyView.videosArray];
    for (int i =0; i < self.model.videoList.count; i++) {
        WPFormData *formDatas = [[WPFormData alloc]init];
        if ([self.model.videoList[i] isKindOfClass:[NSString class]]) {
            NSData *data = [NSData dataWithContentsOfFile:self.vedioArray[i]];
            formDatas.data = data;
        } else if([self.model.videoList[i] isKindOfClass:[ALAsset class]]){
            ALAsset *asset = self.vedioArray[i];
            //将视频转换成NSData
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            formDatas.data = data;
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.model.videoList[i] original_path]]]];
            formDatas.data = data;
        }
        formDatas.name = [NSString stringWithFormat:@"PhotoAddress%d",i+(int)self.photoArray.count];
        formDatas.filename = [NSString stringWithFormat:@"PhotoAddress%d.mp4",i];
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
//                WPFormData *formData = [[WPFormData alloc]init];
//                if ([self.educationListArray[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
//                    MLSelectPhotoAssets *asset = self.educationListArray[i];
//                    UIImage  *img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
//                    formData.data = UIImageJPEGRepresentation(img, 0.5);
//                }
//                if ([model.expList[i] isKindOfClass:[NSString class]]) {
//                    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.educationListArray[i]]];
//                    formData.data = [NSData dataWithContentsOfURL:url];
//                }
//                
//                formData.name = [NSString stringWithFormat:@"img%d",imageNumber];
//                formData.filename = [NSString stringWithFormat:@"img%d.jpg",imageNumber];
//                formData.mimeType = @"application/octet-stream";
//                [dataArr addObject:formData];//把数据流加入上传文件数组
//                NSString *value = [NSString stringWithFormat:@"img%d",imageNumber];
//                NSDictionary *photoDic = @{@"txt":value};
//                [contentList addObject:photoDic];
//                imageNumber++;
            }
        }
        NSString * string = [NSString stringWithFormat:@"%@",model.educationStr];
        if (string.length && ![string isEqualToString:@"(null)"]) {
        }
        else
        {
          string = @"";
        }
        NSArray * epListArray = @[@{@"txt":[NSString stringWithFormat:@"%@",string]},@{@"txt":@""}];
        NSDictionary *dic = @{@"ed_id":model.educationId,
                              @"beginTime":[NSString stringWithFormat:@"%@",model.beginTime],
                              @"endTime":[NSString stringWithFormat:@"%@",model.endTime],
                              @"schoolName":[NSString stringWithFormat:@"%@",model.schoolName],
                              @"major":[NSString stringWithFormat:@"%@",model.major],
                              @"major_id":[NSString stringWithFormat:@"%@",model.major_id],
                              //@"major_id":model.majorId,
                              @"education":[NSString stringWithFormat:@"%@",model.education],
                              @"remark":@"",
                              @"epList":epListArray};
        [educationsList addObject:dic];
    }
    NSMutableArray *workList = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.workListArray.count; i++) {
        Work *model = self.workListArray[i];
        NSString * string = [NSString stringWithFormat:@"%@",model.workStr];
        if (string.length && ![string isEqualToString:@"(null)"]) {
        }
        else
        {
         string = @"";
        }
        NSArray * epListArray = @[@{@"txt":[NSString stringWithFormat:@"%@",string]},@{@"txt":@""}];
        
        NSDictionary *dic3 = @{
                              @"beginTime":[NSString stringWithFormat:@"%@",model.beginTime],
                              @"endTime":[NSString stringWithFormat:@"%@",model.endTime],
                              @"epName":[NSString stringWithFormat:@"%@",model.epName],
                              @"Industry_id":[NSString stringWithFormat:@"%@",model.industryId],
                              @"ep_properties":[NSString stringWithFormat:@"%@",model.epProperties],
                              @"industry":[NSString stringWithFormat:@"%@",model.industry],
                              @"department":[NSString stringWithFormat:@"%@",model.department],
                              @"position":[NSString stringWithFormat:@"%@",model.position],
                              @"position_id":[NSString stringWithFormat:@"%@",model.positionId],
                              @"salary":[NSString stringWithFormat:@"%@",model.salary],
                              @"remark":@"",
                              @"epList":epListArray};
        [workList addObject:dic3];
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
    WPResumeUserInfoModel *applyModel = self.model;
    NSDictionary *jsonInfo = @{@"resume_user_id":[NSString stringWithFormat:@"%@",applyModel.resumeUserId],
                               @"resume_id":[NSString stringWithFormat:@"%@",applyModel.resume_id],    // to do
                               @"name":[NSString stringWithFormat:@"%@",applyModel.name],
                               @"sex":[NSString stringWithFormat:@"%@",applyModel.sex],
                               @"birthday":[NSString stringWithFormat:@"%@",applyModel.birthday],
                               @"education":[NSString stringWithFormat:@"%@",applyModel.education],
                               @"WorkTime":[NSString stringWithFormat:@"%@",applyModel.workTime],
                               @"homeTown_id":[NSString stringWithFormat:@"%@",applyModel.homeTownId],
                               @"homeTown":[NSString stringWithFormat:@"%@",applyModel.homeTown],
                               @"Address_id":[NSString stringWithFormat:@"%@",applyModel.addressId],
                               @"address":[NSString stringWithFormat:@"%@",applyModel.address],
                               @"Tel":[NSString stringWithFormat:@"%@",applyModel.tel],
                               @"Hope_Position":[NSString stringWithFormat:@"%@",applyModel.Hope_Position],
                               @"Hope_PositionNo":[NSString stringWithFormat:@"%@",applyModel.hopePositionNo],
                               @"Hope_salary":[NSString stringWithFormat:@"%@",applyModel.Hope_salary],
                               @"Hope_welfare":[NSString stringWithFormat:@"%@",applyModel.Hope_welfare],
                               @"Hope_address":[NSString stringWithFormat:@"%@",applyModel.Hope_address],
                               @"Hope_addressID":[NSString stringWithFormat:@"%@",applyModel.hopeAddressID],
                               @"nowSalary":[NSString stringWithFormat:@"%@",applyModel.nowSalary],
                               @"marriage":[NSString stringWithFormat:@"%@",applyModel.marriage],
                               @"webchat":[NSString stringWithFormat:@"%@",applyModel.webchat],
                               @"qq":[NSString stringWithFormat:@"%@",applyModel.qq],
                               @"email":[NSString stringWithFormat:@"%@",applyModel.email],
                               @"educationList":educationsList.count?educationsList:@[],
                               @"workList":workList.count?workList:@[],
                               @"lightspot":[NSString stringWithFormat:@"%@",self.model.lightspot],
                               @"lightspotList":[NSString stringWithFormat:@"%@",self.model.lightspotList],
                               @"TelIsShow":(telephoneShowed?@"0":@"1"), //0 显示  1 不显示
                               };
    
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (!self.sid) {//创建新的求职简历
        NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
        WPShareModel *model = [WPShareModel sharedModel];
        
        NSString * string = [self getUniqueStrByUUID];
        NSDictionary *parmas = @{@"action":@"SubmitResume",
                                 @"is_show":self.openStr,
                                 @"is_look":self.isLook,
                                 @"username":[NSString stringWithFormat:@"%@",model.username],
                                 @"password":[NSString stringWithFormat:@"%@",model.password],
                                 @"user_id":[NSString stringWithFormat:@"%@",model.dic[@"userid"]],
                                 @"fileCount":[NSString stringWithFormat:@"%d",(int)dataArr.count],
                                 @"photoCount":[NSString stringWithFormat:@"%d",(int)self.model.photoList.count],
                                 @"isModify":(updateImage?@"0":@"1"),
                                 @"ResumeJson":jsonString,
                                 @"status":status,
                                 ((backFromPerson&&status)?@"type":@""):((backFromPerson&&status)?@"1":@""),
                                 @"guid":[NSString stringWithFormat:@"%@-%@",kShareModel.userId,string]
                                 };

        
        if (!self.saveDraft) {//保存草稿时不保存在本地
            NSDictionary * upDic = [[WPUploadShuoShuo instance] uploadMyApply:parmas modelList:self.model.videoList photo:self.photoArray video:self.vedioArray];
            NSDictionary * backDic = upDic[@"json"];//显示的数据
            [self saveMyApply:parmas json:upDic and:string];
            if (self.upLoadMyApply) {
                self.upLoadMyApply(backDic);
            }
        }
//        NSDictionary * upDic = [[WPUploadShuoShuo instance] uploadMyApply:parmas modelList:self.model.videoList photo:self.photoArray video:self.vedioArray];
//        NSDictionary * backDic = upDic[@"json"];//显示的数据
//        [self saveMyApply:parmas json:upDic and:string];
//        if (self.upLoadMyApply) {
//            self.upLoadMyApply(backDic);
//        }
        
        NSArray * viewArray = self.navigationController.viewControllers;
        if (viewArray.count>=3) {
            if ([self.navigationController.viewControllers[2] isKindOfClass:[self class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMIANSHIDATA" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
            }
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
//        if ([self.navigationController.viewControllers[2] isKindOfClass:[self class]]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMIANSHIDATA" object:nil];
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//            [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
//        }

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            BOOL isData = NO;
            for (WPFormData * formatter in dataArr) {
                if (!formatter.data) {
                    isData = YES;
                    break;
                }
            }
            if (isData) {
                return ;
            }
            [WPHttpTool postSingleWithURL:str params:parmas formDataArray:dataArr success:^(id json) {
                if (![json[@"status"] integerValue]) {
                    [self deleteMyApply:[NSString stringWithFormat:@"%@-%@",kShareModel.userId,string]];
                    NSDictionary * dic = @{@"guid":json[@"guid"],@"resume_id":json[@"resume_id"],@"time":json[@"time"]};
                    if (!self.saveDraft) {
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"upLoadMyApplySuccess" object:dic];
                    }
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"upLoadMyApplySuccess" object:dic];
                }
                
            } failure:^(NSError * error) {
                UIButton * senderBtn = (UIButton*)[self.view viewWithTag:90];
                senderBtn.userInteractionEnabled = YES;
                [MBProgressHUD hideHUDForView:self.view];
                NSLog(@"%@",error.localizedDescription);
                
            }];
        });
        
//        [WPHttpTool postSingleWithURL:str params:parmas formDataArray:dataArr success:^(id json) {
//            UIButton * senderBtn = (UIButton*)[self.view viewWithTag:90];
//            senderBtn.userInteractionEnabled = YES;
//            
////            [MBProgressHUD hideHUDForView:self.view];
//            if (![json[@"status"] integerValue]) {
//                if ([self.navigationController.viewControllers[2] isKindOfClass:[self class]]) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMIANSHIDATA" object:nil];
//                    [self.navigationController popViewControllerAnimated:YES];
//                }else{
//                    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
//                }
//            }else{
//                [MBProgressHUD showError:@"上传失败，请重试" toView:self.view];
//            }
//
//        } failure:^(NSError * error) {
//            UIButton * senderBtn = (UIButton*)[self.view viewWithTag:90];
//            senderBtn.userInteractionEnabled = YES;
//            [MBProgressHUD hideHUDForView:self.view];
//            NSLog(@"%@",error.localizedDescription);
//
//        }];
    }else{//报名
        NSString *str = [IPADDRESS stringByAppendingString:@"/ios/invitejob.ashx"];
        WPShareModel *model = [WPShareModel sharedModel];
        NSDictionary *parmas = @{@"action":@"ApplicationJob",
                                 @"username":model.username,
                                 @"password":model.password,
                                 @"user_id":model.dic[@"userid"],
                                 @"job_id":self.sid,// 创建求职简历时此处为空 会崩
                                 @"fileCount":[NSString stringWithFormat:@"%d",(int)dataArr.count],
                                 @"photoCount":[NSString stringWithFormat:@"%d",(int)self.model.photoList.count],
                                 @"isModify":(updateImage?@"0":@"1"),
                                 @"ResumeJson":jsonString,
                                 @"status":status,
                                 @"shelvesDown":_shelvesDown,
                                 @"is_update":self.is_update};
        [MBProgressHUD showMessage:@"" toView:self.view];
        [WPHttpTool postWithURL:str params:parmas formDataArray:dataArr success:^(id json) {
            UIButton * senderBtn = (UIButton*)[self.view viewWithTag:90];
            senderBtn.userInteractionEnabled = YES;
            [MBProgressHUD hideHUDForView:self.view];
            if (![json[@"status"] integerValue]) {
                if (self.applySuccess) {
                    self.applySuccess();
                }
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
            UIButton * senderBtn = (UIButton*)[self.view viewWithTag:90];
            senderBtn.userInteractionEnabled = YES;
            [MBProgressHUD hideHUDForView:self.view];
            NSLog(@"%@",error.localizedDescription);
        }];
    }
}

-(void)saveMyApply:(NSDictionary*)params json:(NSDictionary*)upDic and:(NSString*)string
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [defaults objectForKey:@"UPLOAdMYAPPLY"];
    NSMutableArray * muarrau = [NSMutableArray array];
    [muarrau addObjectsFromArray:array];
    NSDictionary * saveDic = @{[NSString stringWithFormat:@"%@-%@",kShareModel.userId,string]:@[params,upDic]};
    [muarrau addObject:saveDic];
    array = [NSArray arrayWithArray:muarrau];
    [defaults setObject:array forKey:@"UPLOAdMYAPPLY"];
}
-(void)deleteMyApply:(NSString*)guid
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [defaults objectForKey:@"UPLOAdMYAPPLY"];
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
    [defaults setObject:array forKey:@"UPLOAdMYAPPLY"];
    
}

- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dateView removeFromSuperview];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark 单元格switch 开关代理
- (void)WPRecruiteCellDelegateClickeSwitchButton:(BOOL)isOepn{
    telephoneShowed = isOepn;
}
@end
