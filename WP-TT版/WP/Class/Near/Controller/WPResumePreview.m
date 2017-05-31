//
//  WPResumePreview.m
//  WP
//
//  Created by Kokia on 16/3/31.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPResumePreview.h"

#import "WPRecruitApplyController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "SPItemPreview.h"
#import "UIButton+WebCache.h"
#import "SPItemView.h"
#import "SPItemPreview2.h"
#import "SPShareView.h"
#import "TYAttributedLabel.h"
#import "MLSelectPhotoAssets.h"
#import "NearShowCell.h"
#import "SPPhotoAsset.h"
#import "UIImageView+WebCache.h"
//#import "WPInterviewEducationController.h"
//#import "WPInterviewWorkController.h"
#import "WPGridView.h"
#import "WPGridslistView.h"

#import "OpenViewController.h"

#define PhotoTag 70
#define VideoTag 85

@interface WPResumePreview () <UIActionSheetDelegate>
{
    CGFloat right;
}
@property (strong, nonatomic) UIScrollView *photosView;
@property (strong, nonatomic) UIScrollView *videosView;
//@property (strong, nonatomic) SPItemView *phone;
//@property (strong, nonatomic) SPItemPreview2 *personal;
//@property (strong, nonatomic) SPItemPreview2 *expe;

@property (assign, nonatomic) CGFloat contentSizeHeight;

@end

@implementation WPResumePreview


-(NSArray *)photosArr
{
    if (!_photosArr) {
        _photosArr = [[NSArray alloc]init];
    }
    return _photosArr;
}

-(NSArray *)videosArr
{
    if (!_videosArr) {
        _videosArr = [[NSArray alloc]init];
    }
    return _videosArr;
}

- (NSArray *)lightspotArr{
    if (!_lightspotArr) {
        _lightspotArr = [[NSArray alloc]init];
    }
    return _lightspotArr;
}

//- (NSArray *)educationListArr{
//    if (!_educationListArr) {
//        _educationListArr = [[NSArray alloc]init];
//    }
//    return _educationListArr;
//}
//
//- (NSArray *)workListArr{
//    if (!_workListArr) {
//        _workListArr = [[NSArray alloc]init];
//    }
//    return _workListArr;
//}

//- (void)setModel:(WPResumeUserInfoModel *)model
//{
////    _model = [[WPResumeUserInfoModel alloc]init];
//    _model = model;
//    
////    self.photosArr = model.photoList;
////    self.videosArr = model.videoList;
////    
////    self.lightspotStr = model.lightspot;
////    self.lightspotArr = model.lightspotList;
////    
////    self.educationListArr = model.educationList;
////    self.workListArr = model.workList;
//    
//}

#pragma mark - 加载界面 刷新数据
- (void)reloadData
{
    self.backgroundColor = RGB(235, 235, 235);
    _contentSizeHeight = 480;
    [self addSubview:self.photosView];
    [self showSubViews];
}

-(UIScrollView *)photosView
{
    if (!_photosView) {
        
        _photosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kListEdge, self.width-30, PhotoViewHeight)];
        _photosView.backgroundColor = [UIColor whiteColor];
        _photosView.showsHorizontalScrollIndicator = NO;
        CGFloat fileCount = self.photosArr.count+self.videosArr.count;
        _photosView.contentSize = CGSizeMake(fileCount*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), PhotoHeight);
        
        for (int i = 0; i < self.photosArr.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
            button.tag = PhotoTag+i;
            button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            if ([self.photosArr[i] isKindOfClass:[SPPhotoAsset class]]) {
                [button setImage:[self.photosArr[i] originImage] forState:UIControlStateNormal];//thumbImage
            }else{
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] thumb_path]]];
                [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
            [_photosView addSubview:button];
        }
        
        CGFloat width = self.photosArr.count*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12);
        for (int i = 0; i < self.videosArr.count; i++) {
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
            [_photosView addSubview:button];
            
            UIImageView *subImageV = [[UIImageView alloc]initWithFrame:CGRectMake(PhotoHeight/2-10, PhotoHeight/2-10, 20, 20)];
            subImageV.image = [UIImage imageNamed:@"video_play"];
            [button addSubview:subImageV];
        }
        /**< 照片墙翻页 */
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-30, _photosView.top, 30, PhotoViewHeight) ImageName:@"common_icon_arrow" Target:self Action:@selector(photosViewClick:)];
        scrollBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:scrollBtn];
    }
    return _photosView;
}

- (void)showSubViews
{
//    NSLog(@"%@", _model);
    
    CGFloat top = self.photosView.bottom;
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, top+kListEdge, SCREEN_WIDTH,kHEIGHT(43)*7)];
    view1.backgroundColor = [UIColor whiteColor];
    [self addSubview:view1];
    
    NSArray *titleArr1 = @[@"姓       名:",@"性       别:",@"出生年月:",@"学       历:",@"工作年限:",
                           @"目前薪资:",@"婚姻状况:",@"户       籍:",@"现居地址:",@"手机号码:"];
    NSArray *contentArr1 =@[_model.name,_model.sex,_model.birthday,_model.education,_model.workTime,
                            _model.nowSalary,_model.marriage,_model.homeTown,_model.address,_model.tel];
    
    UIView *lastviewOne = nil;
    for (int i = 0; i < titleArr1.count; i++) {
        CGFloat top = lastviewOne?lastviewOne.bottom:0;
        SPItemPreview *preview = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, kHEIGHT(43)) title:titleArr1[i] content:contentArr1[i]];
        if (![contentArr1[i] isEqualToString:@""]) {
            [view1 addSubview:preview];
            lastviewOne = preview;
        }
    }
    
    // 当lastViewOne不存在时，重置view1的top
    view1.top = lastviewOne?(top+kListEdge):top;
    view1.height = lastviewOne?lastviewOne.bottom:0;
//    lastviewOne.backgroundColor = [UIColor blackColor];
    
    // 当view1高度为0时，取消view1和view2之间的edge
    CGFloat view2Top = (view1.height == 0)?(view1.bottom):(view1.bottom+kListEdge);
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view2Top, SCREEN_WIDTH,0)];
    view2.backgroundColor = [UIColor whiteColor];
    [self addSubview:view2];
    
    NSArray *titleArr2 = @[@"期望职位:",@"期望薪资:",@"期望地区:",@"期望福利:"];
    NSArray *contentArr2 = @[_model.Hope_Position,_model.Hope_salary,_model.Hope_address,_model.Hope_welfare];
    UIView *lastViewTwo = nil;
    for (int i = 0; i < titleArr2.count; i++) {
        CGFloat top = lastViewTwo?lastViewTwo.bottom:0;
        if (i < 3) {
            SPItemPreview *preview = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, kHEIGHT(43)) title:titleArr2[i] content:contentArr2[i]];
            if (![contentArr2[i] isEqualToString:@""]) {
                [view2 addSubview:preview];
                lastViewTwo = preview;
            }
        }else{//期望福利
//            WPGridlistView *gridView = []
            CGSize size = [titleArr2[i]getSizeWithFont:FUCKFONT(15) Height:20];
            //添加"期望福利"
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), top+13, size.width, size.height)];
            label.font = kFONT(15);
            label.text = titleArr2[i];
            //添加具体的福利
            WPGridView *gridView = [[WPGridView alloc]initWithFrame:CGRectMake(label.right+6, top+13, SCREEN_WIDTH-label.right-6, kHEIGHT(43))];
            gridView.textArray = [_model.Hope_welfare componentsSeparatedByString:@"/"];
            CGRect rect = gridView.frame;
            NSArray * array = [_model.Hope_welfare componentsSeparatedByString:@"/"];
            if (array.count <= 4)
            {
                rect.size.height = label.size.height;
            }
            else
            {
                rect.size.height = kHEIGHT(43);
            }
            gridView.frame = rect;
            
//            gridView.backgroundColor = [UIColor redColor];
            gridView.font = kFONT(15);
            gridView.rows = 3;
            gridView.rowSpace = 10;
            
            [gridView finishToShow];
            if (![contentArr2[i] isEqualToString:@""])
            {
                [view2 addSubview:gridView];
                [view2 addSubview:label];
                lastViewTwo = gridView;
            }
        }
    }
    // 当lastViewTwo不存在时，设置view2高度为0
    view2.top = (lastViewTwo&&view1.height==0)?(view2.top+kListEdge):view2.top;
    if ([contentArr2[3] isEqualToString:@""]) {
         view2.height = lastViewTwo?(lastViewTwo.bottom):0;
    }
    else
    {
      view2.height = lastViewTwo?(lastViewTwo.bottom+13):0;
    }
    
   
    
    
    // 个人亮点
    UIView *lastviewThree = nil;
    // 当view2的高度为0时，取消间距edge
    CGFloat itemsHeight = view2.height?(view2.bottom+kListEdge):view2.bottom;
    UIView *lightspotBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, itemsHeight, SCREEN_WIDTH, 0)];
    SPItemPreview *personal = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, itemsHeight, SCREEN_WIDTH, kHEIGHT(38)) title:@"个人亮点" content:@""];
    if ((self.lightStr.length)||self.lightspotStr.length) {
        [self addSubview:personal];
        lastviewThree = personal;
    }
    NSArray *arr = [self.lightspotStr componentsSeparatedByString:SEPARATOR];
    if ([self.lightspotStr isEqualToString:@""]) {
        arr = nil;
    }
    
    //添加亮点总结
    CGSize size = [@"亮点总结:" getSizeWithFont:FUCKFONT(15) Height:20];
     UIView * backview1 = [[UIView alloc]initWithFrame:CGRectMake(0, personal.bottom, SCREEN_WIDTH, 0)];
    if (arr.count) {
       
        backview1.backgroundColor = [UIColor whiteColor];
        [self addSubview:backview1];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), 13, size.width, size.height)];
        label.text = @"亮点总结:";
        label.font = kFONT(15);
        [backview1 addSubview:label];
        WPGridView *gridView = [[WPGridView alloc]initWithFrame:CGRectMake(label.right+6, 13, SCREEN_WIDTH-label.right-6, kHEIGHT(43))];
        gridView.textArray = arr;
        CGRect rect = gridView.frame;
        NSArray * array = arr;
        if (array.count <= 3)
        {
            rect.size.height = label.size.height+13;
        }
        else if(array.count>3 && array.count <=6)
        {
            rect.size.height = kHEIGHT(43)+13;
        }
        else if (array.count > 6 && array.count <= 9)
        {
            rect.size.height = kHEIGHT(43) + label.size.height+26;
        }
        else
        {
            rect.size.height = kHEIGHT(43)*2+26;
        }
        gridView.frame = rect;
        
        //            gridView.backgroundColor = [UIColor redColor];
        gridView.font = kFONT(15);
        gridView.rows = 3;
        gridView.rowSpace = 10;
        [gridView finishToShow];
        [backview1 addSubview:gridView];
        CGRect rect1 = backview1.frame;
        rect1.size.height = gridView.size.height+13;
        backview1.frame = rect1;
        lastviewThree = backview1;
    }
#pragma mark 添加亮点描述
    
    CGFloat lightTop = lastviewThree?lastviewThree.bottom:view2.bottom+kListEdge;
    
    UILabel * lightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, lightTop, 100, 100)];
    lightLabel.font = kFONT(15);
    lightLabel.numberOfLines = 0;
//    if (self.lightStr.length) {
//       
//        lightLabel.backgroundColor = [UIColor greenColor];
//    }
    NSString * string = [NSString stringWithFormat:@"亮点描述: %@",self.lightStr];
    lightLabel.text = string;
    CGSize sizeToFit = [string sizeWithFont:kFONT(15) constrainedToSize:CGSizeMake(SCREEN_WIDTH-16, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect rect = lightLabel.frame;
    rect = CGRectMake(kHEIGHT(12), lastviewThree.bottom+kListEdge, SCREEN_WIDTH-16, sizeToFit.height+kListEdge);
    lightLabel.frame = rect;
    
    //亮点描述的背景颜色
    UIView * back = [[UIView alloc]initWithFrame:CGRectMake(0, lastviewThree.bottom, SCREEN_WIDTH, sizeToFit.height+kListEdge*3)];
    back.backgroundColor = [UIColor whiteColor];
    //亮点总结下的下划线
    UIView * lightline = [[UIView alloc]initWithFrame:CGRectMake(kHEIGHT(12), back.frame.origin.y, SCREEN_WIDTH-2*kHEIGHT(12), 1)];
    lightline.backgroundColor = [UIColor colorWithRed:233/256.0 green:233/256.0 blue:233/256.0 alpha:1.0];
//    [back addSubview:lightline];

    
    if (self.lightStr.length && ![self.lightStr isEqualToString:@"(null)"]) {
        [self addSubview:back];
        [self addSubview:lightline];
         [self addSubview:lightLabel];
        lastviewThree = back;
    }
    
    lightspotBackgroundView.height = lastviewThree?(lastviewThree.bottom-personal.top):0;

    CGFloat eduHeight = lastviewThree?lastviewThree.bottom + kListEdge:view2.bottom+kListEdge;
    
    UIView *educationBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, eduHeight, SCREEN_WIDTH, 0)];
    educationBackgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:educationBackgroundView];
    
    
    UIView *lastViewFour = nil;
    for (int i = 0; i < self.educationListArr.count; i++) {
        UILabel * firstLabel = [[UILabel alloc]init];
        firstLabel.backgroundColor = [UIColor whiteColor];
        UIView * vi = [UIView new];

//        SPItemPreview * persong = [[SPItemPreview alloc]init];
        if (i == 0) {
//            if (self.educationListArr.count == 1) {
//                persong = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, eduHeight, SCREEN_WIDTH, kHEIGHT(38)) title:@"教育经历" content:@""];
//            }
//            else
//            {
//              persong = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, eduHeight, SCREEN_WIDTH, kHEIGHT(38)) title:@"教育经历1" content:@""];
//            }
            
            
            if (self.lightStr.length) {
              vi = [[UIView alloc]initWithFrame:CGRectMake(0, eduHeight, SCREEN_WIDTH, kHEIGHT(38))];
                 firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), eduHeight, SCREEN_WIDTH, kHEIGHT(38))];// eduHeight+kListEdge
                
                
            }
            else
            {
                vi = [[UIView alloc]initWithFrame:CGRectMake(0, eduHeight, SCREEN_WIDTH, kHEIGHT(38))];
                firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), eduHeight, SCREEN_WIDTH, kHEIGHT(38))];
            }
            
            vi.backgroundColor = [UIColor whiteColor];
            
           
            if (self.educationListArr.count == 1) {
               firstLabel.text = @"教育经历";
//                firstLabel.backgroundColor = [UIColor redColor];
            }
            else
            {
              firstLabel.text = @"教育经历1";
            }
//            firstLabel.text = @"教育经历1";
            firstLabel.font = kFONT(15);
            firstLabel.textAlignment = NSTextAlignmentLeft;
        }
        else
        {
            UILabel * backView = [[UILabel alloc]initWithFrame:CGRectMake(0, lastViewFour.bottom, SCREEN_WIDTH, kListEdge/2)];
            backView.backgroundColor = RGB(235, 235, 235);
            [self addSubview: backView];
            lastViewFour = backView;

//            persong = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, lastViewFour.bottom+kListEdge/2, SCREEN_WIDTH, kHEIGHT(38)) title:[NSString stringWithFormat:@"教育经历%d",i+1] content:@""];
            
            
            vi = [[UIView alloc]initWithFrame:CGRectMake(0, lastViewFour.bottom+kListEdge/2, SCREEN_WIDTH, kHEIGHT(38))];
            vi.backgroundColor = [UIColor whiteColor];
            firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), lastViewFour.bottom+kListEdge/2, SCREEN_WIDTH, kHEIGHT(38))];
            firstLabel.text = [NSString stringWithFormat:@"教育经历%d",i+1];
            firstLabel.font = kFONT(15);
            firstLabel.textAlignment = NSTextAlignmentLeft;
         }
        
        if (self.educationListArr.count != 0) {
            [self addSubview:vi];
            [self addSubview:firstLabel];
            lastViewFour = vi;
//            [self addSubview:persong];
//            lastViewFour = persong;
        }
        UILabel * line4 = [[UILabel alloc]initWithFrame:CGRectMake(0, firstLabel.bottom-2, SCREEN_WIDTH, 1)];
        line4.backgroundColor = [UIColor colorWithRed:233/256.0 green:233/256.0 blue:233/256.0 alpha:1.0];
        [self addSubview:line4];
        
        Education *model = self.educationListArr[i];
        
        NSArray *title = @[@"学校名称:",@"在校时间:",@"专业类别:",@"学历学位:"];
        NSArray *content = @[model.schoolName,[NSString stringWithFormat:@"%@至%@",model.beginTime,model.endTime],model.major,model.education];
        for (int i = 0; i < title.count; i++) {
            CGFloat top = lastViewFour?lastViewFour.bottom:0;
             SPItemPreview *preview = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, kHEIGHT(43)) title:title[i] content:content[i]];
            if (![content[i] isEqualToString:@""] && ![content[i] isEqualToString:@"至"]) {
                [self addSubview:preview];
                lastViewFour = preview;
//                [self addSubview:line];
//                lastViewFour = label;
            }
        }
        
        UILabel * line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lastViewFour.bottom-2, SCREEN_WIDTH, 1)];
        line2.backgroundColor = [UIColor colorWithRed:233/256.0 green:233/256.0 blue:233/256.0 alpha:1.0];
        NSString * educationStr = [NSString stringWithFormat:@"专业描述: %@",model.educationStr];
        CGSize sizeToFit1 = [educationStr sizeWithFont:kFONT(15) constrainedToSize:CGSizeMake(SCREEN_WIDTH-16, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel * strLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), lastViewFour.bottom+kListEdge, SCREEN_WIDTH-kHEIGHT(12)*2, sizeToFit1.height+kListEdge)];
        strLabel.backgroundColor = [UIColor whiteColor];
        strLabel.text = educationStr;
        strLabel.font = kFONT(15);
        strLabel.numberOfLines = 0;
//        strLabel.backgroundColor = [UIColor redColor];
        strLabel.textAlignment = NSTextAlignmentLeft;
        //专业描述的背景颜色
        UIView * backview = [[UIView alloc]initWithFrame:CGRectMake(0, lastViewFour.bottom, SCREEN_WIDTH, sizeToFit1.height+kListEdge*3)];
        backview.backgroundColor = [UIColor whiteColor];
        if (model.educationStr.length && ![model.educationStr isEqualToString:@"(null)"]) {
//            [self addSubview:line2];
            [self addSubview:backview];
           [self addSubview:strLabel];
            lastViewFour = backview;
        }
        
    }
    
    UIView *lastViewFive = nil;
    
    CGFloat workTop = lastViewFour?lastViewFour.bottom:(lastviewThree?lastviewThree.bottom:view2.bottom);
    for (int i = 0; i < self.workListArr.count; i++) {
        UILabel * workLabel = [UILabel new];
        UIView * vie = [UIView new];
        
        
        workLabel.backgroundColor = [UIColor whiteColor];
        if (i == 0) {
            if (self.lightStr.length)
            {
              workLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), workTop+kListEdge, SCREEN_WIDTH, kHEIGHT(38))];
                vie = [[UIView alloc]initWithFrame:CGRectMake(0, workTop+kListEdge, SCREEN_WIDTH, kHEIGHT(38))];
            }
            else
            {
                workLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), workTop+kListEdge, SCREEN_WIDTH, kHEIGHT(38))];
                vie = [[UIView alloc]initWithFrame:CGRectMake(0, workTop+kListEdge, SCREEN_WIDTH, kHEIGHT(38))];
            }
            if (self.educationListArr.count) {
                NSInteger inter = self.educationListArr.count;
                Education *model = self.educationListArr[inter - 1];
            }
            else
            {
            
            }
            vie.backgroundColor = [UIColor whiteColor];
            
            
            if (self.workListArr.count == 1) {
               workLabel.text = @"工作经历";
            }
            else
            {
              workLabel.text = @"工作经历1";
            }
//            workLabel.text = @"工作经历1";
            workLabel.font = kFONT(15);
            workLabel.textAlignment = NSTextAlignmentLeft;
        }
        else
        {
            
            Work * workModel = self.workListArr[i-1];
            if (workModel.workStr.length && ![workModel.workStr isEqualToString:@"(null)"]) {
              vie = [[UIView alloc]initWithFrame:CGRectMake(0, lastViewFive.bottom+kListEdge, SCREEN_WIDTH, kHEIGHT(38))];
                workLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), lastViewFive.bottom+kListEdge, SCREEN_WIDTH, kHEIGHT(38))];
            }
            else
            {
                vie = [[UIView alloc]initWithFrame:CGRectMake(0, lastViewFive.bottom+kListEdge, SCREEN_WIDTH, kHEIGHT(38))];
                workLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), lastViewFive.bottom+kListEdge, SCREEN_WIDTH, kHEIGHT(38))];
            }
            
            vie.backgroundColor = [UIColor whiteColor];
            
            workLabel.text = [NSString stringWithFormat:@"工作经历%d",i+1];
            workLabel.font = kFONT(15);
            workLabel.textAlignment = NSTextAlignmentLeft;
        }
        if (self.workListArr.count) {
            [self addSubview:vie];
            [self addSubview:workLabel];
            lastViewFive = workLabel;
        }
        UILabel * line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, workLabel.bottom-2, SCREEN_WIDTH, 1)];
        line1.backgroundColor = [UIColor colorWithRed:233/256.0 green:233/256.0 blue:233/256.0 alpha:1.0];
        [self addSubview:line1];
        
        
        
        Work *model = self.workListArr[i];
        
        NSArray *title = @[@"公司名称:",@"任职时间:",@"企业行业:",@"职位名称:",@"薪资待遇:"];
        NSArray *content = @[model.epName,[NSString stringWithFormat:@"%@至%@",model.beginTime,model.endTime],model.industry,model.position,model.salary];
        for (int i = 0; i < title.count; i++) {
            CGFloat top = lastViewFive?lastViewFive.bottom:0;
            SPItemPreview *preview = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, kHEIGHT(43)) title:title[i] content:content[i]];
            if (![content[i] isEqualToString:@""] && ![content[i] isEqualToString:@"至"]) {
                [self addSubview:preview];
                lastViewFive = preview;
            }
        }
        
        
        NSString * workStr = [NSString stringWithFormat:@"职位描述: %@",model.workStr];
        CGSize sizeToFit2 = [workStr sizeWithFont:kFONT(15) constrainedToSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(12)*2, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        UILabel * worLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), lastViewFive.bottom+kListEdge, SCREEN_WIDTH-kHEIGHT(12)*2, sizeToFit2.height+kListEdge)];
        worLabel1.text = workStr;
        worLabel1.font = kFONT(15);
        worLabel1.numberOfLines = 0;
        worLabel1.backgroundColor = [UIColor whiteColor];
        worLabel1.textAlignment = NSTextAlignmentLeft;
        UIView * backaView = [[UIView alloc]initWithFrame:CGRectMake(0, lastViewFive.bottom, SCREEN_WIDTH,  sizeToFit2.height+kListEdge*3)];
        backaView.backgroundColor = [UIColor whiteColor];
        
        if (model.workStr.length && ![model.workStr isEqualToString:@"(null)"]) {
            [self addSubview:backaView];
            [self addSubview:worLabel1];
            
            lastViewFive = backaView;
        }
    }
    
    CGFloat shareTop = lastViewFive?lastViewFive.bottom+kListEdge:(lastViewFour?lastViewFour.bottom+kListEdge:(lastviewThree?lastviewThree.bottom+kListEdge:view2.bottom+kListEdge));
    
    Education * model= nil;
    if (self.educationListArr.count) {
        NSInteger inter = self.educationListArr.count;
         model = self.educationListArr[inter-1];
    }
    
    Work * model1 = nil;
    if (self.workListArr.count) {
        NSInteger inter = self.workListArr.count;
        model1 = self.workListArr[inter - 1];
    }
    
    if (self.isApply) {
       self.contentSize = CGSizeMake(SCREEN_WIDTH, shareTop);
    }
    else
    {
        SPShareView *shareView = [[SPShareView alloc]initWithFrame:CGRectMake(0, shareTop, SCREEN_WIDTH, kHEIGHT(43))];
        __weak typeof(shareView) weakView = shareView;
        shareView.publicAction = ^(){
            OpenViewController *open = [OpenViewController new];
            open.titleString = weakView.subTitle.text;
            /*open.openDidselectBlock = ^(NSDictionary *dic,NSInteger index){
                __strong typeof(shareView) strongView = weakView;
                strongView.subTitle.text = dic[@"subTitle"];
                NSString * userId = [NSString new];
                BOOL isOr = YES;
                if (index>3) {
                    userId = dic[@"userID"];
                    if (index != 4) {
                        isOr = NO;
                    }
                }
                else
                {
                  userId = @"";
                }
                if (self.isOpenOrNot) {
                    self.isOpenOrNot(dic[@"subTitle"],userId,isOr);
                }
                
            };*/
            open.clickComplete = ^(NSDictionary * dic,NSIndexPath * index){
                __strong typeof(shareView) strongView = weakView;
                strongView.subTitle.text = dic[@"title"];
                NSString * userId = [NSString new];
                BOOL isOr = YES;
                if (index.row>3) {
                    userId = dic[@"userID"];
                    if (index.row != 4) {
                        isOr = NO;
                    }
                }
                else
                {
                    userId = @"";
                }
                if (self.isOpenOrNot) {
                    self.isOpenOrNot(dic[@"title"],userId,isOr);
                }
            };
            
            [self.vc.navigationController pushViewController:open animated:YES];
        };
        [self addSubview:shareView];
        self.contentSize = CGSizeMake(SCREEN_WIDTH, shareView.bottom+kListEdge);
    }
    
//    SPShareView *shareView = [[SPShareView alloc]initWithFrame:CGRectMake(0, shareTop, SCREEN_WIDTH, kHEIGHT(43))];
//    __weak typeof(shareView) weakView = shareView;
//    shareView.publicAction = ^(){
//        OpenViewController *open = [OpenViewController new];
//        open.titleString = weakView.subTitle.text;
//        open.openDidselectBlock = ^(NSDictionary *dic,NSInteger index){
//            __strong typeof(shareView) strongView = weakView;
//            strongView.subTitle.text = dic[@"subTitle"];
//            if (self.isOpenOrNot) {
//                self.isOpenOrNot(dic[@"subTitle"]);
//            }
//            
//        };
//        [self.vc.navigationController pushViewController:open animated:YES];
//    };
//    [self addSubview:shareView];
//    self.contentSize = CGSizeMake(SCREEN_WIDTH, shareView.bottom+kListEdge);
}

- (NSArray *)getCellHeight:(NSArray *)array{
    NSMutableArray *heightArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < array.count; i++) {
        [heightArr addObject:@"0"];
    }
    for (int i = 0; i<array.count; i++) {
        if ([array[i] isKindOfClass:[NSAttributedString class]]) {
            //            return 102;
            TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
            [label setAttributedText:array[i]];
            label.linesSpacing = 4;
            label.characterSpacing = -1;
            [label setFrameWithOrign:CGPointMake(0, 0) Width:SCREEN_WIDTH - right - 10];
            CGFloat height;
            CGFloat textHeight = label.frame.size.height;
            height = textHeight;
            //if (textHeight > 80) {
            //height = textHeight + 22;
            //} else {
            //height = 102;
            //}
            NSString *str = [NSString stringWithFormat:@"%f",height];
            [heightArr replaceObjectAtIndex:i withObject:str];
            
        }
        if ([array[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
            MLSelectPhotoAssets *asset = array[i];
            ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
            CGFloat height;
            CGSize dimension = [representation dimensions];
            height = ((SCREEN_WIDTH-kHEIGHT(10)*2)/dimension.width)*dimension.height;
            NSString *str = [NSString stringWithFormat:@"%f",height];
            [heightArr replaceObjectAtIndex:i withObject:str];
        }
        if ([array[i] isKindOfClass:[NSString class]]) {
            
            /*
            UIImageView *imageV = [UIImageView new];
            //CGFloat height = 0;
            //__block typeof(height) weakHeight = height;
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:array[i]]];
            [imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGFloat weakHeight = ((SCREEN_WIDTH - kHEIGHT(10)*2)/image.size.width)*image.size.height;
                NSString *str = [NSString stringWithFormat:@"%f",weakHeight];
                [heightArr replaceObjectAtIndex:i withObject:str];
                
            }];
             */
            
            // 根据当前row的imgURL作为Key 获取图片缓存
            NSString *imgURL = [IPADDRESS stringByAppendingString:array[i]];
            
            UIImage *img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
            
            if (!img) {
                img = [UIImage resizedImageWithName:@"gray_background.png"];
            }
            
            CGFloat height = img.size.height * kScreenW/img.size.width; // Image宽度为屏幕宽度 ，计算宽高比求得对应的高度
            NSString *str = [NSString stringWithFormat:@"%f",height];
            
            [heightArr replaceObjectAtIndex:i withObject:str];
        }
    }
    return heightArr;
}

-(void)phoneClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        //        NSLog(@"电话");
        NSString *str = [NSString stringWithFormat:@"呼叫:%@",_model.tel];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:str, nil];
        actionSheet.tag = 200;
        [actionSheet showInView:self];
    }
    if (sender.tag ==101) {
        //        NSLog(@"短信");
        NSString *str = [NSString stringWithFormat:@"发短信至:%@",_model.tel];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:str, nil];
        actionSheet.tag = 201;
        [actionSheet showInView:self];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 200) {
        if (buttonIndex == 0) {
            NSString *telUrl=[NSString stringWithFormat:@"tel://%@",_model.tel];//添加电话号码
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
        }
    }
    if (actionSheet.tag == 201) {
        if (buttonIndex == 0) {
            NSString *telUrl=[NSString stringWithFormat:@"sms://%@",_model.tel];//添加电话号码
            //            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@sms://13888888888]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
        }
    }
    
}
#pragma mark 点击预览界面的图片和视频
-(void)checkImageClick:(UIButton *)sender
{
    //    NSMutableArray *arr = [[NSMutableArray alloc]init];
    //
    //    for (int i = 0; i < self.photosArr.count; i++) {/**< 头像或背景图 */
    //        MJPhoto *photo = [[MJPhoto alloc]init];
    //        photo.image = [self.photosArr[i] originImage];
    //        photo.srcImageView = [(UIButton *)[self viewWithTag:70+i] imageView];
    //        [arr addObject:photo];
    //    }
    //    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //    brower.currentPhotoIndex = sender.tag-70;
    //    brower.photos = arr;
    //    [brower show];
    //    if ([_newPhotolist[i] isKindOfClass:[SPPhotoAsset class]]) {
    //        [dragBtn setImage:[_newPhotolist[i] thumbImage] forState:UIControlStateNormal];
    //    }else{
    //        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_newPhotolist[i] thumb_path]]];
    //        [dragBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    //    }
    
    if (sender.tag>=PhotoTag &&sender.tag <VideoTag) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < self.photosArr.count; i++) {/**< 头像或背景图 */
            MJPhoto *photo = [[MJPhoto alloc]init];
            //            photo.image = [self.photosArr[i] originImage];
            if ([self.photosArr[i] isKindOfClass:[SPPhotoAsset class]]) {
                photo.image = [self.photosArr[i] originImage];
            }else{
                photo.url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] thumb_path]]];
            }
            
            photo.srcImageView = [(UIButton *)[self viewWithTag:PhotoTag+i] imageView];
            [arr addObject:photo];
        }
        MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
        brower.currentPhotoIndex = sender.tag-PhotoTag;
        brower.photos = arr;
        [brower show];
    }else{
        if (self.checkVideosBlock) {
            self.checkVideosBlock(sender.tag-VideoTag);
        }
    }
}

-(void)checkVideoClick:(UIButton *)sender
{
    if (self.checkVideosBlock) {
        self.checkVideosBlock(sender.tag - 80);
    }
}

#pragma mark 查看所有的图片
-(void)photosViewClick:(UIButton *)sender
{
    if (self.checkPhotosBlock) {
        self.checkPhotosBlock();
    }
}

-(void)videosViewClick:(UIButton *)sender
{
    if (self.checkAllVideosBlock) {
        self.checkAllVideosBlock();
    }
}

@end
