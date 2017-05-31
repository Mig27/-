//
//  WPInterviewEdltController.m
//  WP
//
//  Created by CBCCBC on 15/10/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPInterviewEditController.h"
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
#import "SPPhotoBrowser.h"
#import "MLPhotoBrowserViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <BlocksKit+UIKit.h>
//#import <ReactiveCocoa.h>
#import <CoreMedia/CoreMedia.h>
#import "MLSelectPhotoPickerViewController.h"
#import "CTAssetsPickerController.h"
#import "SAYPhotoManagerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "DBTakeVideoVC.h"
#import "SPPhotoAsset.h"
#import "WPInterView.h"
#import "WPInterviewPersonalInfoPreview.h"
#import "WPInterviewController.h"
#import "WPInterviewLightspotController.h"
#import "WPInterviewEducationController.h"
#import "WPInterviewWorkController.h"
#import "WPInterviewEducationListController.h"
#import "WPInterviewWorkListController.h"

NSString *const kNotifacationInterviewUserIsSelected = @"kNotifacationInterviewUserIsSelected";

@interface WPInterviewEditController () <SPSelectViewDelegate,WPActionSheet,UIScrollViewDelegate,WPActionSheet,callBackVideo,takeVideoBack,UINavigationControllerDelegate,CTAssetsPickerControllerDelegate,UpdateImageDelegate,SPPhotoBrowserDelegate,WPInterviewLightspotDelegate,WPInterviewEducationDelegate,WPInterviewWorkDelegate,WPInterviewEducationListDelegate,WPInterviewWorkListDelegate>

#pragma mark - 私有成员变量

#pragma mark - UI层变量
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayerVC;
@property (strong, nonatomic) UIScrollView *baseView;
@property (strong, nonatomic) UIScrollView *photosView;
@property (strong, nonatomic) SPTextView *worksView;
@property (strong, nonatomic) SPTextView *personalView;
@property (strong, nonatomic) SPSelectView *selectView;
@property (strong, nonatomic) UIButton *addPhotosBtn;
@property (strong, nonatomic) SPDateView *dateView;

@property (strong, nonatomic) UIView *bottomView;

#pragma mark - 数据层变量
@property (strong, nonatomic) NSMutableArray *photosArr;
@property (strong, nonatomic) NSMutableArray *videosArr;
@property (assign, nonatomic) NSInteger cateTag;
@property (strong, nonatomic) WPUserListModel *model;

@property (nonatomic, copy) NSString *lightspotStr;/**< 个人亮点固定内容 */
@property (nonatomic, strong) NSArray *lightspotArray;/**< 个人亮点数组 */
@property (nonatomic, strong) NSMutableArray *educationListArray;/**< 教育经历内容数组 */
@property (nonatomic, strong) NSMutableArray *workListArray;/**< 工作经历内容数组 */

@end

#pragma mark - 宏TAG
//tag列表
#define sItemTag 20
#define VideoTag 65
#define PhotoTag 50
#define TagRefreshName 100

#pragma mark - 宏-HEIGHT
//宏定义高度
//#define ItemViewHeight 48
#define WorksViewHeight 170
#define PersonalViewHeight 80

@implementation WPInterviewEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"我的简历";
    
    self.lightspotStr = @"";
    
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
    button1.selected = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
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

#pragma mark - 返回事件
- (void)backToFromViewController:(UIButton *)sender{
    WS(ws);
    if ([self judgeIsEdit]) {
        [SPAlert alertControllerWithTitle:@"提示" message:@"是否退出?" superController:self cancelButtonTitle:@"否" cancelAction:nil defaultButtonTitle:@"是" defaultAction:^{
            [ws.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 右按钮点击事件
- (void)rightItemClick:(UIButton *)sender{
//    if ([self.model.name isEqualToString:@""]||!self.model.name) {
//        [MBProgressHUD createHUD:@"请输入姓名" View:self.view];
//    }
//    else if ([self.model.sex isEqualToString:@""]||!self.model.sex) {
//        [MBProgressHUD createHUD:@"请选择性别" View:self.view];
//    }
//    else if ([self.model.cardType isEqualToString:@""]||!self.model.cardType) {
//        [MBProgressHUD createHUD:@"请选择证件类型" View:self.view];
//    }
//    else if ([self.model.cardNo isEqualToString:@""]||!self.model.cardNo) {
//        [MBProgressHUD createHUD:@"请选择证件号码" View:self.view];
//    }
//    else if ([self.model.birthday isEqualToString:@""]||!self.model.birthday) {
//        [MBProgressHUD createHUD:@"请选择出生年月" View:self.view];
//    }
//    else if ([self.model.Tel isEqualToString:@""]||!self.model.Tel) {
//        [MBProgressHUD createHUD:@"请输入手机号码" View:self.view];
//    }
//    else if ([self.model.webchat isEqualToString:@""]||!self.model.webchat) {
//        [MBProgressHUD createHUD:@"请输入微信号" View:self.view];
//    }
//    else if ([self.model.qq isEqualToString:@""]||!self.model.qq) {
//        [MBProgressHUD createHUD:@"请输入QQ号码" View:self.view];
//    }
//    else if ([self.model.email isEqualToString:@""]||!self.model.email) {
//        [MBProgressHUD createHUD:@"请输入邮箱" View:self.view];
//    }
//    else if ([self.model.industry isEqualToString:@""]||!self.model.industry) {
//        [MBProgressHUD createHUD:@"请选择行业" View:self.view];
//    }
//    else if ([self.model.Position isEqualToString:@""]||!self.model.Position) {
//        [MBProgressHUD createHUD:@"请选择职位" View:self.view];
//    }
//    else if ([self.model.companyName isEqualToString:@""]||!self.model.companyName) {
//        [MBProgressHUD createHUD:@"请输入公司名称" View:self.view];
//    }
//    else if ([self.model.nowSalaryType isEqualToString:@""]||!self.model.nowSalaryType) {
//        [MBProgressHUD createHUD:@"请选择薪资类型" View:self.view];
//    }
//    else if ([self.model.nowSalary isEqualToString:@""]||!self.model.nowSalary) {
//        [MBProgressHUD createHUD:@"请选择目前薪资" View:self.view];
//    }
//    else if ([self.model.education isEqualToString:@""]||!self.model.education) {
//        [MBProgressHUD createHUD:@"请选择学历" View:self.view];
//    }
//    else if ([self.model.WorkTime isEqualToString:@""]||!self.model.WorkTime) {
//        [MBProgressHUD createHUD:@"请选择工作年限" View:self.view];
//    }
//    else if ([self.model.marriage isEqualToString:@""]||!self.model.marriage) {
//        [MBProgressHUD createHUD:@"请选择婚姻状况" View:self.view];
//    }
//    else if ([self.model.address isEqualToString:@""]||!self.model.address) {
//        [MBProgressHUD createHUD:@"请选择现居住地" View:self.view];
//    }
//    else if ([self.model.workexperience isEqualToString:@""]||!self.model.workexperience) {
//        [MBProgressHUD createHUD:@"请输入工作经历" View:self.view];
//    }
//    else{
//        [self addNewInterview];
//    }
    sender.selected = !sender.selected;
    if (sender.selected) {//   完成
        [self addNewInterview];
        [self showPreview];
    }else{//   编辑
        [self deletePreview];
    }
}

#pragma mark - 网络层~添加招聘者信息
- (void)addNewInterview{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
//    self.model.sex = [_segment titleForSegmentAtIndex:_segment.selectedSegmentIndex];

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
        formDatas.name = [NSString stringWithFormat:@"photoAddress%lu",i+self.photosArr.count];
        formDatas.filename = [NSString stringWithFormat:@"photoAddress%lu.mp4",i+self.photosArr.count];
        formDatas.mimeType = @"video/quicktime";
        [arr addObject:formDatas];
        if (!formDatas.data) {
            updateImage = NO;
        }
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
    
    NSDictionary *dic = @{@"resume_user_id":(self.listModel?_listModel.resumeUserId:@""),
                          @"resume_id":@"",
                          @"name":self.model.name,
                          @"sex":self.model.sex,
                          //                             @"cardType":self.model.cardType,
                          //                             @"cardNo":self.model.cardNo,
                          @"birthday":self.model.birthday,
                          @"Tel":self.model.tel,
                          //                             @"webchat":self.model.webchat,
                          //                             @"qq":self.model.qq,
                          //                             @"email":self.model.email,
                          //                             @"industry":self.model.industry,
                          //                             @"industryNo":self.model.industryNo,
                          //                             @"Position":self.model.Position,
                          //                             @"PositionNo":self.model.PositionNo,
                          //                             @"companyName":self.model.companyName,
                          //                             @"nowSalaryType":self.model.nowSalaryType,
                          //                             @"nowSalary":self.model.nowSalary,
                          @"education":self.model.education,
                          @"WorkTime":self.model.workTime,
                          //                             @"marriage":self.model.marriage,
                          @"address":self.model.address,
                          @"Address_id":self.model.addressId,
                          //                             @"workexperience":self.model.workexperience,
                          @"homeTown":self.model.homeTown,
                          @"homeTown_id":self.model.homeTownId,
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
    
    NSString *PhotoNum =updateImage?[NSString stringWithFormat:@"%lu",self.photosArr.count+self.videosArr.count]:@"";
    NSString *photoCount = updateImage?[NSString stringWithFormat:@"%lu",self.photosArr.count]:@"";
    NSString *isModify =updateImage?@"1":@"0";

    NSDictionary *params = @{@"action":(self.listModel?@"UpdateResumeUser":@"AddChangeResume"),
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.userId,
                             @"photoCount":photoCount,
                             @"fileCount":PhotoNum,
                             @"isModify":isModify,
                             @"ResumeJson":jsonString
                             };
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:urlStr params:params formDataArray:arr success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([json[@"status"] isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:json[@"info"]];
            [self performSelector:@selector(delay) withObject:nil afterDelay:1];
        }else{
            [MBProgressHUD showError:json[@"info"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请重试"];
    }];
}



#pragma mark 延迟执行代理方法
- (void)delay{
    [self.delegate refreshUserListDelegate:self.model];
}

#pragma mark - 数据层 ~ Model
- (WPUserListModel *)model{
    if (!_model) {
        _model = [[WPUserListModel alloc]init];
        _model.name = _model.name?:@"";
        _model.sex = _model.sex?:@"";
        _model.birthday = _model.birthday?:@"";
        _model.education = _model.education?:@"";
        _model.workTime = _model.workTime?:@"";
        _model.homeTown = _model.homeTown?:@"";
        _model.homeTownId = _model.homeTownId?:@"";
        _model.address = _model.address?:@"";
        _model.addressId = _model.addressId?:@"";
        //    _model.workexperience = _model.workexperience?:@"";
        _model.tel = _model.tel?:@"";
        _model.lightspot = _model.lightspot?:@"";
        
        [self.photosArr addObjectsFromArray:_model.photoList];
        [self.videosArr addObjectsFromArray:_model.videoList];
    }
    return _model;
}
//- (void)setModel:(WPUserListModel *)model{
    //_model = model;
    //_model.name = _model.name?:@"";
    //_model.sex = _model.sex?:@"";
    //_model.birthday = _model.birthday?:@"";
    //_model.education = _model.education?:@"";
    //_model.workTime = _model.workTime?:@"";
    //_model.homeTown = _model.homeTown?:@"";
    //_model.homeTownId = _model.homeTownId?:@"";
    //_model.address = _model.address?:@"";
    //_model.addressId = _model.addressId?:@"";
////    _model.workexperience = _model.workexperience?:@"";
    //_model.tel = _model.tel?:@"";
    //_model.lightspot = _model.lightspot?:@"";
    
    //[self.photosArr addObjectsFromArray:_model.photoList];
    //[self.videosArr addObjectsFromArray:_model.videoList];
    
//}

- (void)initSelfModel:(WPUserListModel *)model{
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
    self.model.nowSalary = model.nowSalary;
    self.model.marriage = model.marriage;
    self.model.webchat = model.webchat;
    self.model.qq = model.qq;
    self.model.email = model.email;
    self.model.educationList = [[NSArray alloc]initWithArray:model.educationList];
    self.model.workList = [[NSArray alloc]initWithArray:model.workList];
    self.model.photoList = [[NSArray alloc]initWithArray:model.photoList];
    self.model.videoList = [[NSArray alloc]initWithArray:model.videoList];
    self.model.lightspotList = [[NSArray alloc]initWithArray:model.lightspotList];
}

#pragma mark 刷新数据回调Model
- (void)setListModel:(WPUserListModel *)listModel{
   
    //self.model = listModel;
    [self initSelfModel:listModel];
    
    _listModel = listModel;
    
    self.photosArr = [[NSMutableArray alloc]initWithArray:listModel.photoList];
    self.videosArr = [[NSMutableArray alloc]initWithArray:listModel.videoList];
    
    //初始化编辑界面数据
    SPItemView *view = (SPItemView *)[self.baseView viewWithTag:0+sItemTag];
    [view resetTitle:listModel.name];
    
    SPItemView *view1 = (SPItemView *)[self.baseView viewWithTag:1+sItemTag];
    [view1 resetTitle:[SPLocalApplyArray sexToString:listModel.sex]];
//    SPItemView *view2 = (SPItemView *)[self.baseView viewWithTag:2+sItemTag];
//    [view2 resetTitle:listModel.cardType];
//    
//    SPItemView *view3 = (SPItemView *)[self.baseView viewWithTag:3+sItemTag];
//    [view3 resetTitle:listModel.cardNo];
    
    SPItemView *view4 = (SPItemView *)[self.baseView viewWithTag:2+sItemTag];
    [view4 resetTitle:listModel.birthday];
    
    SPItemView *view5 = (SPItemView *)[self.baseView viewWithTag:InterviewEditItemTypeNowPhone];
    [view5 resetTitle:listModel.tel];
//    
//    SPItemView *view6 = (SPItemView *)[self.baseView viewWithTag:6+sItemTag];
//    [view6 resetTitle:listModel.webchat];
//    
//    SPItemView *view7 = (SPItemView *)[self.baseView viewWithTag:7+sItemTag];
//    [view7 resetTitle:listModel.qq];
//    
//    SPItemView *view8 = (SPItemView *)[self.baseView viewWithTag:8+sItemTag];
//    [view8 resetTitle:listModel.email];
//    
//    SPItemView *view9 = (SPItemView *)[self.baseView viewWithTag:9+sItemTag];
//    [view9 resetTitle:listModel.industry];
//    
//    SPItemView *view10 = (SPItemView *)[self.baseView viewWithTag:10+sItemTag];
//    [view10 resetTitle:listModel.Position];
//    
//    SPItemView *view11 = (SPItemView *)[self.baseView viewWithTag:11+sItemTag];
//    [view11 resetTitle:listModel.companyName];
//    
//    SPItemView *view12 = (SPItemView *)[self.baseView viewWithTag:12+sItemTag];
//    [view12 resetTitle:listModel.nowSalaryType];
//    
//    SPItemView *view13 = (SPItemView *)[self.baseView viewWithTag:13+sItemTag];
//    [view13 resetTitle:listModel.nowSalary];

    SPItemView *view14 = (SPItemView *)[self.baseView viewWithTag:3+sItemTag];
    [view14 resetTitle:listModel.education];
    
    SPItemView *view15 = (SPItemView *)[self.baseView viewWithTag:4+sItemTag];
    [view15 resetTitle:listModel.workTime];
    
//    SPItemView *view16 = (SPItemView *)[self.baseView viewWithTag:5+sItemTag];
//    [view16 resetTitle:listModel.marriage];
    
    SPItemView *view16 = (SPItemView *)[self.baseView viewWithTag:5+sItemTag];
    [view16 resetTitle:listModel.homeTown];
    
    SPItemView *view17 = (SPItemView *)[self.baseView viewWithTag:6+sItemTag];
    [view17 resetTitle:listModel.address];
    
//    SPItemView *view18 = (SPItemView *)[self.baseView viewWithTag:35];
//    [view7 resetTitle:listModel.Tel];
    
//    [_worksView resetTitle:listModel.workexperience];
//    [_personalView resetTitle:listModel.lightspot];
    
    [self refreshPhotos];
    
    self.lightspotStr = listModel.lightspot;
    
    NSMutableArray *arr3 = [[NSMutableArray alloc]init];
    for (WPRecruitDraftInfoRemarkModel *remarkModel in listModel.lightspotList) {
        if ([remarkModel.types isEqualToString:@"txt"]) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [arr3 addObject:str];
        }else{
            [arr3 addObject:remarkModel.txtcontent];
        }
    }
    self.lightspotArray = arr3;
    
    if (![self.lightspotStr isEqualToString:@""]|self.lightspotArray.count) {
        SPItemView *itemview = (SPItemView *)[self.view viewWithTag:8+sItemTag];
        [itemview resetTitle:@"亮点已填写"];
    }
    
    //工作经历数组反转
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < listModel.educationList.count; i++) {
        Educationlist * educationListModel = listModel.educationList[i];
        WPInterviewEducationModel *educationModel = [[WPInterviewEducationModel alloc]init];
        educationModel.epId =educationListModel.educationId;
        educationModel.beginTime = educationListModel.beginTime;
        educationModel.endTime = educationListModel.endTime;
        educationModel.schoolName = educationListModel.schoolName;
        educationModel.major = educationListModel.major;
        educationModel.education = educationListModel.education;
        educationModel.remark = educationListModel.remark;
        
        NSMutableArray *expList = [[NSMutableArray alloc]init];
        for (WPRemarkModel *remarkModel in [listModel.educationList[i] expList]) {
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
        SPItemView *itemview = (SPItemView *)[self.view viewWithTag:9+sItemTag];
        [itemview resetTitle:@"教育经历已填写"];
    }
    
    //工作经历数组反转
    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
    for (int i = 0; i < listModel.workList.count; i++) {
        Worklist * workListModel = listModel.workList[i];
        WPInterviewWorkModel *workModel = [[WPInterviewWorkModel alloc]init];
        workModel.work_id =workListModel.workId;
        workModel.beginTime = workListModel.beginTime;
        workModel.endTime = workListModel.endTime;
        workModel.epName = workListModel.epName;
        workModel.Industry_id = workListModel.industryId;
        workModel.industry = workListModel.industry;
        workModel.ep_properties = workListModel.epProperties;
        workModel.department = workListModel.department;
        workModel.position = workListModel.position;
        workModel.Industry_id = workListModel.industryId;
        workModel.position_id = workListModel.positionId;
        workModel.remark = workListModel.remark;
        workModel.salary = workListModel.salary;
        
        NSMutableArray *expList = [[NSMutableArray alloc]init];
        for (WPRemarkModel *remarkModel in [listModel.educationList[i] expList]) {
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
        SPItemView *itemview = (SPItemView *)[self.view viewWithTag:10+sItemTag];
        [itemview resetTitle:@"工作经历已填写"];
    }
    
    //默认显示预览界面
    [self showPreview];
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

#pragma mark - UI层 初始化视图

- (void)showPreview{
    WPInterviewPersonalInfoPreview *preview = [[WPInterviewPersonalInfoPreview alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    preview.model = self.model;
    preview.photosArr = self.photosArr;
    preview.videosArr = self.videosArr;
    preview.lightspotStr =self.lightspotStr;
    preview.lightspotArr = self.lightspotArray;
    preview.educationListArr = self.educationListArray;
    preview.workListArr = self.workListArray;
    [preview reloadData];
    preview.checkPhotosBlock = ^(){
        
    };
    preview.checkVideosBlock = ^(NSInteger number){
        
    };
    preview.checkAllVideosBlock = ^(){
        
    };
    
    [self.view addSubview:preview];
}

- (void)deletePreview{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[WPInterviewPersonalInfoPreview class]]) {
            [view removeFromSuperview];
        }
    }
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH-50, 0, 50, 49);
        [button setTitle:@"确认" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = kFONT(15);
        button.tag = 90;
        [button addTarget:self action:@selector(completeEditUserInfoAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(10, 49/2-9, 18, 18);
        //        deleteBtn.backgroundColor = [UIColor redColor];
        [deleteBtn setImage:[UIImage imageNamed:@"delet_info"] forState:UIControlStateNormal];
        //        deleteBtn.layer.borderColor = RGB(226, 226, 226).CGColor;
        //        deleteBtn.layer.borderWidth = 0.25;
        deleteBtn.tag = 90;
        [deleteBtn addTarget:self action:@selector(deleteCurrentUserInfoAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (!self.delegate) {
            [_bottomView addSubview:deleteBtn];
        }
    }
    return _bottomView;
}

- (void)completeEditUserInfoAction:(UIButton *)sender{
    [self addNewInterview];
}

- (void)deleteCurrentUserInfoAction:(UIButton *)sender{
    
}

- (void)setupSubViews{
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
        _baseView.contentSize = CGSizeMake(SCREEN_WIDTH, 10+PhotoViewHeight+10+18*ItemViewHeight+WorksViewHeight+10);
    }
    return _baseView;
}

#pragma mark 照片
-(UIScrollView *)photosView
{
    if (!_photosView) {
        
        _photosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, +10, SCREEN_WIDTH-30, PhotoViewHeight)];
        _photosView.backgroundColor = [UIColor whiteColor];
        _photosView.showsHorizontalScrollIndicator = NO;
        
        _addPhotosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPhotosBtn.frame = CGRectMake(10, 10, PhotoHeight, PhotoHeight);
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

#pragma mark 选择框
-(SPSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[SPSelectView alloc]initWithTop:64];
        _selectView.delegate = self;
    }
    return _selectView;
}

#pragma mark 选择日期
-(SPDateView *)dateView
{
    if (!_dateView) {
        __weak typeof(self) weakSelf = self;
        _dateView = [[SPDateView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-30, SCREEN_WIDTH, 216+30)];
        _dateView.getDateBlock = ^(NSString *dateStr){
            SPItemView *view = (SPItemView *)[weakSelf.baseView viewWithTag:sItemTag+4];
            [view resetTitle:dateStr];
            weakSelf.model.birthday = dateStr;
        };
    }
    return _dateView;
}

#pragma mark 子视图
- (void)setBodyView{
    
    __weak typeof(self) weakSelf = self;
    
    NSArray *titleArr = @[@"姓       名:",@"性       别:",@"出生年月:",@"学       历:",@"工作年限:",@"户       籍:",@"现居地址:",@"手       机:"];
    
    NSArray *placeArr =@[@"请输入姓名",@"请选择性别",@"请选择生日",@"请选择学历",@"请选择工作年限",@"请选择家乡",@"请现则居住地",@"请输入手机号"];
    
    NSArray *typeArr = @[kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeText];
    UIView *lastview = nil;
    for (int i = 0; i < titleArr.count; i++) {
        SPItemView *view = [[SPItemView alloc]initWithFrame:CGRectMake(0, i*ItemViewHeight+self.photosView.bottom+10, SCREEN_WIDTH, ItemViewHeight)];
        [view setTitle:titleArr[i] placeholder:placeArr[i] style:typeArr[i]];
        [self.baseView addSubview:view];
        view.tag = i + sItemTag;
        view.SPItemBlock = ^(NSInteger tag){
            [self buttonItem:tag];
        };
        view.hideFromFont = ^(NSInteger tag, NSString *title){
            if (tag == 0) {
               weakSelf.model.name = title;
            }
            if (tag == 7) {
                weakSelf.model.tel = title;
            }
        };
        lastview = view;
    }
    
//    NSArray *titleArr = @[@"姓       名:",@"性       别:",@"证件类型:",@"证件号码:",@"出生年月:",@"手       机:", @"微       信:",@"Q        Q:",@"邮       箱:",@"行       业:",@"职       位:",@"企业名称:",@"薪资类型:",@"目前薪资:",@"学       历:",@"工作年限:",@"婚姻情况:",@"现居住地:"];
//
//    NSArray *placeholderArr = @[@"请输入姓名",@"请选择性别",@"请选择证件类型", @"请输入证件号码",@"请选择出生年月",@"请输入手机号码",@"请输入微信号码",@"请输入QQ号码",@"请输入邮箱",@"请选择行业",@"请选择职位",@"请输入企业名称",@"请选择薪资类型",@"请选择目前薪资",@"请选择学历",@"请选择工作年限",@"请选择婚姻状况",@"请选择现居住地"];
//
//    NSArray *typeArr = @[kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeText,kCellTypeButton,kCellTypeText,kCellTypeText,kCellTypeText,kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton];
//
//    for (int i = 0; i < titleArr.count; i++) {
//            SPItemView *view = [[SPItemView alloc]initWithFrame:CGRectMake(0, i*ItemViewHeight+self.photosView.bottom+10, SCREEN_WIDTH, ItemViewHeight)];
//            [view setTitle:titleArr[i] placeholder:placeholderArr[i] style:typeArr[i]];
//            [self.baseView addSubview:view];
//            view.tag = i + sItemTag;
//            view.SPItemBlock = ^(NSInteger tag){
//                [self buttonItem:tag];
//            };
//            view.hideFromFont = ^(NSInteger tag, NSString *title){
//                switch (tag-sItemTag) {
//                    case 0:
//                        NSLog(@"姓名");
//                        weakSelf.model.name = title;
//                        break;
//                    case 3:
//                        NSLog(@"证件号");
//                        weakSelf.model.cardNo = title;
//                        break;
//                    case 5:
//                        NSLog(@"手机");
//                        weakSelf.model.Tel = title;
//                        break;
//                    case 6:
//                        NSLog(@"微信");
//                        weakSelf.model.webchat = title;
//                        break;
//                    case 7:
//                        NSLog(@"QQ");
//                        weakSelf.model.qq = title;
//                        break;
//                    case 8:
//                        NSLog(@"邮箱");
//                        weakSelf.model.email = title;
//                        break;
//                    case 11:
//                        NSLog(@"企业名称");
//                        weakSelf.model.companyName = title;
//                        break;
//                    default:
//                        break;
//                }
//            };
//    }
    
    NSArray *title = @[@"个人亮点:",@"教育经历:",@"工作经历:"];
    NSArray *placeholder = @[@"请添加个人亮点",@"请添加教育经历",@"请添加工作经历"];
    for (int i = 0; i < 3; i++) {
        SPItemView *itemview = [[SPItemView alloc]initWithFrame:CGRectMake(0, lastview.bottom, SCREEN_WIDTH, ItemViewHeight)];
        [itemview setTitle:title[i] placeholder:placeholder[i] style:kCellTypeButton];
        [self.baseView addSubview:itemview];
        itemview.tag = lastview.tag+1;
        itemview.SPItemBlock = ^(NSInteger tag){
            [weakSelf buttonItem:tag];
        };
        
        lastview = itemview;
    }
    ////工作经历
    //CGFloat worksHeight = titleArr.count*ItemViewHeight+self.photosView.bottom+10;
    //_worksView = [[SPTextView alloc]initWithFrame:CGRectMake(0, worksHeight, SCREEN_WIDTH, WorksViewHeight)];
    //[_worksView setWithTitle:@"工作经历:" placeholder:@"请填写工作经历"];
    //_worksView.hideFromFont = ^(NSString *title){
    //};
    //[self.baseView addSubview:_worksView];
    
    ////联系方式
    //SPItemView *phone = [[SPItemView alloc]initWithFrame:CGRectMake(0, _worksView.bottom+10, SCREEN_WIDTH, ItemViewHeight)];
    //[phone setTitle:@"联系方式" placeholder:@"请填写联系方式" style:kCellTypeText];
    //phone.tag = InterviewEditItemTypeNowPhone;
    //phone.textField.keyboardType = UIKeyboardTypePhonePad;
    //phone.hideFromFont = ^(NSInteger tag, NSString *title){
        //weakSelf.model.tel = title;
    //};
    //[self.baseView addSubview:phone];
    
    ////个人亮点
    //_personalView = [[SPTextView alloc]initWithFrame:CGRectMake(0, phone.bottom, SCREEN_WIDTH, PersonalViewHeight)];
    //[_personalView setWithTitle:@"个人亮点:" placeholder:@"请填写个人亮点"];
    //_personalView.hideFromFont = ^(NSString *title){
        //weakSelf.model.lightspot = title;
    //};
    //[self.baseView addSubview:_personalView];
    self.baseView.contentSize = CGSizeMake(SCREEN_WIDTH, lastview.bottom+kListEdge);
}

#pragma mark - 刷新照片墙
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
            [button sd_setImageWithURL:url forState:UIControlStateNormal];
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


#pragma mark - 交互层
#pragma mark 选择条件
-(void)buttonItem:(NSInteger)tag
{
    _cateTag = tag;
    [self.dateView hide];
    [self.view endEditing:YES];
    //NSMutableArray *EducationArr = [[NSMutableArray alloc]init];
    //NSMutableArray *WageArr = [[NSMutableArray alloc]init];
    //NSMutableArray *ExperienceArr = [[NSMutableArray alloc]init];
    //NSMutableArray *WelfareArr = [[NSMutableArray alloc]init];
    //NSMutableArray *cardTypeArr = [[NSMutableArray alloc]init];
    //NSMutableArray *sexArr = [[NSMutableArray alloc]init];
    //NSMutableArray *salaryArr = [[NSMutableArray alloc]init];
    //NSMutableArray *marrigeArr = [[NSMutableArray alloc]init];
    
    //NSArray *Education = @[@"不限",@"高中",@"技校",@"中专",@"大专",@"本科",@"硕士",@"博士"];
    //NSArray *Wage = @[@"面议",@"1000以下",@"1000-2000",@"2000-3000",@"3000-5000",@"5000-8000",@"8000-12000",@"12000-20000",@"20000以上"];
    //NSArray *Experience = @[@"不限",@"一年以下",@"1-2年",@"3-5年",@"6-8年",@"8-10年",@"10年以上"];
    //NSArray *Welfare = @[@"五险一金",@"包吃包住",@"年底双薪",@"周末双休",@"交通补助",@"加班补助"];
    //NSArray *cardType = @[@"身份证",@"护照",@"军人证",@"香港身份证",@"其他"];
    //NSArray *sex = @[@"男",@"女",@"保密"];
    //NSArray *marrige = @[@"未婚",@"已婚",@"保密"];
    //NSArray *salary = @[@"年薪",@"月薪",@"日薪",@"时薪"];
    
    //for (int i = 0; i < Education.count; i++) {
        //IndustryModel *model = [[IndustryModel alloc]init];
        //model.industryName = Education[i];
        //[EducationArr addObject:model];
    //}
    
    //for (int i = 0; i < Wage.count; i++) {
        //IndustryModel *model = [[IndustryModel alloc]init];
        //model.industryName = Wage[i];
        //model.industryID = [NSString stringWithFormat:@"%d",i+1];
        //[WageArr addObject:model];
    //}
    //for (int i = 0; i < Experience.count; i++) {
        //IndustryModel *model = [[IndustryModel alloc]init];
        //model.industryName = Experience[i];
        //model.industryID = [NSString stringWithFormat:@"%d",i+1];
        //[ExperienceArr addObject:model];
    //}
    
    //for (int i = 0; i < Welfare.count; i++) {
        //IndustryModel *model = [[IndustryModel alloc]init];
        //model.industryName = Welfare[i];
        //model.industryID = [NSString stringWithFormat:@"%d",i+1];
        //[WelfareArr addObject:model];
    //}
    //for (int i = 0; i < cardType.count; i++) {
        //IndustryModel *model = [[IndustryModel alloc]init];
        //model.industryName = cardType[i];
        //model.industryID = [NSString stringWithFormat:@"%d",i+1];
        //[cardTypeArr addObject:model];
    //}
    //for (int i = 0; i < sex.count; i++) {
        //IndustryModel *model = [[IndustryModel alloc]init];
        //model.industryName = sex[i];
        //model.industryID = [NSString stringWithFormat:@"%d",i+1];
        //[sexArr addObject:model];
    //}
    //for (int i = 0; i < marrige.count; i++) {
        //IndustryModel *model = [[IndustryModel alloc]init];
        //model.industryName = marrige[i];
        //model.industryID = [NSString stringWithFormat:@"%d",i+1];
        //[marrigeArr addObject:model];
    //}
    //for (int i = 0; i < salary.count; i++) {
        //IndustryModel *model = [[IndustryModel alloc]init];
        //model.industryName = salary[i];
        //model.industryID = [NSString stringWithFormat:@"%d",i+1];
        //[salaryArr addObject:model];
    //}
    
    switch (tag-sItemTag) {
        case 1:
            NSLog(@"性别");
            [self.selectView setLocalData:[SPLocalApplyArray sexArray]];
            break;
//        case 2:
//            NSLog(@"证件类型");
//            [self.selectView setLocalData:cardTypeArr];
//            break;
        case 2:
//            NSLog(@"出生年月");
            [self.dateView showInView:WINDOW];
            break;
//        case 9:
//            NSLog(@"行业");
//            self.selectView.isIndustry = YES;
//            self.selectView.isArea = NO;
//            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getIndustry",@"fatherid":@"0"}];
//            break;
//        case 10:
//            NSLog(@"职位");
//            self.selectView.isIndustry = NO;
//            self.selectView.isArea = NO;
//            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getPosition",@"fatherid":@"0"}];
//            break;
//        case 12:
//            NSLog(@"薪资类型");
//            [self.selectView setLocalData:salaryArr];
//            break;
//        case 13:
//            NSLog(@"目前薪资");
//            [self.selectView setLocalData:WageArr];
//            break;
        case 3:
            NSLog(@"学历");
            [self.selectView setLocalData:[SPLocalApplyArray educationArray]];
            break;
        case 4:
            NSLog(@"工作年限");
            [self.selectView setLocalData:[SPLocalApplyArray workTimeArray]];
            break;
//        case 16:
//            NSLog(@"婚姻状况");
//            [self.selectView setLocalData:marrigeArr];
//            break;
        case 5:
            NSLog(@"户籍");
            self.selectView.isIndustry = NO;
            self.selectView.isArea = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
        case 6:
            NSLog(@"现居住地");
            self.selectView.isIndustry = NO;
            self.selectView.isArea = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
        case 8:
            NSLog(@"个人亮点");
            [self interviewActionType:8];
            break;
        case 9:
            NSLog(@"教育经历");
            [self interviewActionType:9];
            break;
        case 10:
            NSLog(@"工作经历");
            [self interviewActionType:10];
            break;
        default:
            break;
    }
}

- (void)interviewActionType:(NSInteger)type{
    if (type == 8) {
        WPInterviewLightspotController *lightspot = [[WPInterviewLightspotController alloc]init];
        lightspot.delegate = self;
        [lightspot.objects addObjectsFromArray:self.lightspotArray];
        lightspot.buttonString = self.lightspotStr;
        [self.navigationController pushViewController:lightspot animated:YES];
    }
    if (type == 9) {
        //if (self.educationListArray.count) {
            WPInterviewEducationListController *educationList = [[WPInterviewEducationListController alloc]init];
            educationList.delegate = self;
            educationList.dataSources = self.educationListArray;
            [self.navigationController pushViewController:educationList animated:YES];
        //}else{
            //WPInterviewEducationController *education = [[WPInterviewEducationController alloc]init];
            //education.delegate = self;
            //[self.navigationController pushViewController:education animated:YES];
        //}
    }
    if (type == 10) {
        //if (self.workListArray.count) {
            WPInterviewWorkListController *worklist = [[WPInterviewWorkListController alloc]init];
            worklist.delegate = self;
            worklist.dataSources = self.workListArray;
            [self.navigationController pushViewController:worklist animated:YES];
        //}else{
            //WPInterviewWorkController *worklist = [[WPInterviewWorkController alloc]init];
            //worklist.delegate = self;
            //[self.navigationController pushViewController:worklist animated:YES];
        //}
    }
}

#pragma mark 选择条件回调代理函数 ~ 刷新选择内容
-(void)SPSelectViewDelegate:(IndustryModel *)model
{
    SPItemView *view = (SPItemView *)[self.baseView viewWithTag:_cateTag];
    [view resetTitle:model.industryName];
    switch (_cateTag-sItemTag) {
        case 1:
            self.model.sex = model.industryName;
            break;
//        case 2:
//            self.model.cardType = model.industryName;
//            break;
//        case 9:
//            self.model.industry = model.industryName;
//            self.model.industryNo = model.industryID;
//            break;
//        case 10:
//            self.model.Position = model.industryName;
//            self.model.PositionNo = model.industryID;
//            break;
//        case 12:
//            self.model.nowSalaryType = model.industryName;
//            break;
//        case 13:
//            self.model.nowSalary = model.industryName;
//            break;
        case 3:
            self.model.education = model.industryName;
            break;
        case 4:
            self.model.workTime = model.industryName;
            break;
//        case 16:
//            self.model.marriage = model.industryName;
//            break;
        case 5:
            self.model.homeTown = model.industryName;
            self.model.homeTownId = model.industryID;
            break;
        case 6:
            self.model.address = model.industryName;
            self.model.addressId = model.industryID;
            break;
        default:
            break;
    }
}

#pragma mark 添加照片
-(void)addPhotos:(UIButton *)sender
{
    WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机",@"视频"] imageNames:nil top:64];
    actionSheet.tag = 40;
    [actionSheet showInView:self.view];
}

#pragma mark 查看全部照片视频
-(void)photosViewClick:(UIButton *)sender
{
    [self.dateView hide];
    SAYPhotoManagerViewController *vc = [[SAYPhotoManagerViewController alloc]init];
    vc.arr = self.photosArr;
    vc.videoArr = self.videosArr;
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
        [self.photosArr addObject:asset];
        [self refreshPhotos];
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
        [self refreshPhotos];
    };
}

#pragma mark 拍摄视频
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

#pragma mark 相册选择视频
-(void)videoFromAlbums
{
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = 4-self.videosArr.count;
    picker.assetsFilter = [ALAssetsFilter allVideos];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark 从录制界面选择Video返回
-(void)sendBackVideoWith:(NSArray *)array
{
    [self.videosArr addObjectsFromArray:array];
    [self refreshPhotos];
    //    [self.interView refreshVideos];
}
#pragma mark 录制返回
-(void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
    [self.videosArr addObject:filePaht];
    [self refreshPhotos];
    //    [self.interView refreshVideos];
}
#pragma mark 直接选择Video返回
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [self.videosArr addObjectsFromArray:assets];
    [self refreshPhotos];
    //    [self.interView refreshVideos];
}

#pragma mark - 查看图片
-(void)checkImageClick:(UIButton *)sender
{
    if (sender.tag>=PhotoTag &&sender.tag <VideoTag) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < self.photosArr.count; i++) {/**< 头像或背景图 */
            MJPhoto *photo = [[MJPhoto alloc]init];
            if ([self.photosArr[i] isKindOfClass:[Pohotolist class]]) {
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
        [brower show];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag-PhotoTag inSection:0];
//        // 图片游览器
//        MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
//        // 缩放动画
//        photoBrowser.status = UIViewAnimationAnimationStatusFade;
//        // 可以删除
//        photoBrowser.editing = YES;
//        // 数据源/delegate
//        photoBrowser.delegate = self;
//        photoBrowser.dataSource = self;
//        // 当前选中的值
//        photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
//        // 展示控制器
//        [photoBrowser showPickerVc:self];
    }else{
        NSLog(@"视频");
        [self checkVideos:sender.tag-VideoTag];
    }
}

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

#pragma mark 查看视频
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

//#pragma mark 返回图片数量
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
//    UIButton *btn = (UIButton *)[self.view viewWithTag:indexPath.row+PhotoTag];
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
//    [self refreshPhotos];
//}
//
//#pragma mark <MLPhotoBrowserViewControllerDelegate>
//- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
//    [self.photosArr removeObjectAtIndex:indexPath.row];
//    [self refreshPhotos];
//}

#pragma mark - PhotoManager代理，刷新照片墙
-(void)UpdateImageDelegate:(NSArray *)arr VideoArr:(NSArray *)videoArr
{
    [self.photosArr removeAllObjects];
    [self.photosArr addObjectsFromArray:arr];
    
    [self.videosArr removeAllObjects];
    [self.videosArr addObjectsFromArray:videoArr];
    
    [self refreshPhotos];
}

#pragma mark - 个人亮点代理回调函数
- (void)getLightspotWithConstant:(NSString *)constant content:(NSArray *)contents{
    SPItemView *item = (SPItemView *)[self.view viewWithTag:8+sItemTag];
    [item resetTitle:@"亮点已填写"];
    self.lightspotStr = constant;
    self.lightspotArray = contents;
}
#pragma mark - 教育经历代理回调函数
- (void)getEducation:(WPInterviewEducationModel *)educationModel type:(WPInterviewEducationType)type{
    SPItemView *item = (SPItemView *)[self.view viewWithTag:9+sItemTag];
    [item resetTitle:@"教育经历已填写"];
    [self.educationListArray addObject:educationModel];
}

#pragma mark - 教育经历列表代理返回函数
- (void)getEducationList:(NSArray *)educationArray{
    [self.educationListArray removeAllObjects];
    [self.educationListArray addObjectsFromArray:educationArray];
    //NSLog(@"%@",describe(self.educationListArray));
}

#pragma mark - 工作经历代理回调函数
- (void)getwork:(WPInterviewWorkModel *)model type:(WPInterviewWorkType)type{
    SPItemView *item = (SPItemView *)[self.view viewWithTag:10+sItemTag];
    [item resetTitle:@"工作经历已填写"];
    [self.workListArray addObject:model];
}
#pragma mark - 工作经历列表代理返回函数
- (void)getWorkList:(NSArray *)workArray{
    [self.workListArray removeAllObjects];
    [self.workListArray addObjectsFromArray:workArray];
}

#pragma mark - 停止交互
- (void)hideSubView
{
    [self.dateView hide];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.dateView hide];
}

#pragma mark - 判断是否进行了操作
- (BOOL)judgeIsEdit{
    if (![self.model.name isEqualToString:self.listModel.name]) {
        return YES;
    }
    if (![self.model.sex isEqualToString:self.listModel.sex]) {
        return YES;
    }
    if (![self.model.birthday isEqualToString:self.listModel.birthday]) {
        return YES;
    }
    if (![self.model.education isEqualToString:self.listModel.education]) {
        return YES;
    }
    if (![self.model.workTime isEqualToString:self.listModel.workTime]) {
        return YES;
    }
    if (![self.model.homeTown isEqualToString:self.listModel.homeTown]) {
        return YES;
    }
    if (![self.model.address isEqualToString:self.listModel.address]) {
        return YES;
    }
    if (![self.model.tel isEqualToString:self.listModel.tel]) {
        return YES;
    }
    
    if (self.photosArr.count != self.listModel.photoList.count) {
        return YES;
    }else{
        for (int i = 0; i < self.photosArr.count; i++) {
            if ([self.photosArr[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                return YES;
            }
        }
    }
    
    if (self.videosArr.count != self.listModel.videoList.count) {
        return YES;
    }else{
        for (int i = 0; i < self.videosArr.count; i++) {
            if ([self.videosArr[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                return YES;
            }
        }
    }
    
    if (![self.lightspotStr isEqualToString:self.listModel.lightspot]) {
        return YES;
    }
    if (self.lightspotArray.count != self.listModel.lightspotList.count) {
        return YES;
    }else{
        for (int i = 0; i < self.lightspotArray.count; i++) {
            WPRecruitDraftInfoRemarkModel *remarkModel = self.listModel.lightspotList[i];
            if ([remarkModel.types isEqualToString:@"txt"]) {
                NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];;
                if (![self.lightspotArray[i] isEqualToAttributedString:str]) {
                    return YES;
                }
            }
            if ([remarkModel.types isEqualToString:@"img"]) {
                if ([self.lightspotArray[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                    return YES;
                }
            }
        }
    }
    
    if (self.educationListArray.count != self.listModel.educationList.count) {
        return YES;
    }else{
        for (int i = 0; i < self.educationListArray.count; i++) {
            Educationlist *educationModel = self.listModel.educationList[i];
            WPInterviewEducationModel *model = self.educationListArray[i];
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
            if (model.epList.count != educationModel.expList.count) {
                return YES;
            }else{
                for (int j = 0; j < educationModel.expList.count; j++) {
                    WPRemarkModel *remarkModel = educationModel.expList[j];
                    if ([remarkModel.types isEqualToString:@"txt"]) {
                        NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];;
                        if (![model.epList[j] isEqualToAttributedString:str]) {
                            return YES;
                        }
                    }
                    if ([remarkModel.types isEqualToString:@"img"]) {
                        if ([model.epList[j] isKindOfClass:[MLSelectPhotoAssets class]]) {
                            return YES;
                        }
                    }
                }
            }
        }
    }
    
    if (self.workListArray.count != self.listModel.workList.count) {
        return YES;
    }else{
        for (int i = 0; i < self.workListArray.count; i++) {
            Worklist *workModel = self.listModel.workList[i];
            WPInterviewWorkModel *model = self.workListArray[i];
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
            if (![model.ep_properties isEqualToString:workModel.epProperties]) {
                return YES;
            }
            if (![model.position isEqualToString:workModel.position]) {
                return YES;
            }
            for (int j = 0; j < workModel.expList.count; j++) {
                WPRemarkModel *remarkModel = workModel.expList[j];
                if ([remarkModel.types isEqualToString:@"txt"]) {
                    NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];;
                    if (![model.epList[j] isEqualToAttributedString:str]) {
                        return YES;
                    }
                }
                if ([remarkModel.types isEqualToString:@"img"]) {
                    if ([model.epList[j] isKindOfClass:[MLSelectPhotoAssets class]]) {
                        return YES;
                    }
                }
            }
        }
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
