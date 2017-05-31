//
//  WPInterviewPersonalInfoView.m
//  WP
//
//  Created by CBCCBC on 15/11/26.
//  Copyright © 2015年 WP. All rights reserved.
//


#import "WPInterviewPersonalInfoPreview.h"


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
#import "WPInterviewEducationController.h"
#import "WPInterviewWorkController.h"

#define PhotoTag 70
#define VideoTag 85

//  界面细节，需要调；
//  展示图片时，有问题；

@interface WPInterviewPersonalInfoPreview () <UIActionSheetDelegate>

@property (strong, nonatomic) UIScrollView *photosView;
@property (strong, nonatomic) UIScrollView *videosView;

/** 页面高度*/
@property (assign, nonatomic) CGFloat contentSizeHeight;

@end

@implementation WPInterviewPersonalInfoPreview

#pragma mark - Array 初始化
- (NSArray *)photosArr
{
    if (!_photosArr) {
        _photosArr = [[NSArray alloc]init];
    }
    return _photosArr;
}

- (NSArray *)videosArr
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

- (NSArray *)educationListArr{
    if (!_educationListArr) {
        _educationListArr = [[NSArray alloc]init];
    }
    return _educationListArr;
}

- (NSArray *)workListArr{
    if (!_workListArr) {
        _workListArr = [[NSArray alloc]init];
    }
    return _workListArr;
}

#pragma mark - 重新加载数据
- (void)reloadData
{
    self.backgroundColor = RGB(226, 226, 226);
    
    _contentSizeHeight = 480;
    
    [self addSubview:self.photosView];

    [self initWithSubView];
}

#pragma mark - 照片、视频 选择界面
- (UIScrollView *)photosView
{
    if (!_photosView) {
        
        _photosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, self.width - 30, PhotoViewHeight)];
        _photosView.backgroundColor = [UIColor whiteColor];
        _photosView.showsHorizontalScrollIndicator = NO;
        CGFloat fileCount = self.photosArr.count + self.videosArr.count;
        
        _photosView.contentSize = CGSizeMake(fileCount * (PhotoHeight+6) + 10, PhotoHeight);
        
        for (int i = 0; i < self.photosArr.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(i*(PhotoHeight+6)+10, 10, PhotoHeight, PhotoHeight);
            button.tag = PhotoTag+i;
            button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            if ([self.photosArr[i] isKindOfClass:[SPPhotoAsset class]])
            {
                [button setImage:[self.photosArr[i] thumbImage] forState:UIControlStateNormal];
            }
            else
            {
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] thumb_path]]];
                [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            }
            
            [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_photosView addSubview:button];
        }
        
        CGFloat width = self.photosArr.count * (PhotoHeight+6) + 10;
        
        for (int i = 0; i < self.videosArr.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(i*(PhotoHeight+6)+width, 10, PhotoHeight, PhotoHeight);
            button.tag = VideoTag+i;
            button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
            
#warning 为什么分类型对待
            if ([self.videosArr[i] isKindOfClass:[NSString class]])
            {
                [button setImage:[UIImage getImage:self.videosArr[i]] forState:UIControlStateNormal];
            }
            else if([self.videosArr[i] isKindOfClass:[ALAsset class]])
            {
                ALAsset *asset = self.videosArr[i];
                [button setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
            }
            else
            {
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.videosArr[i] thumb_path]]];
                [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            }
            
            [_photosView addSubview:button];
            
            UIImageView *subImageV = [[UIImageView alloc] initWithFrame:CGRectMake(PhotoHeight/2-10, PhotoHeight/2-10, 20, 20)];
            subImageV.image = [UIImage imageNamed:@"video_play"];
            [button addSubview:subImageV];
        }
        
        /** 箭头按钮  照片墙翻页 */
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH - 30, _photosView.top, 30, PhotoViewHeight) ImageName:@"common_icon_arrow" Target:self Action:@selector(photosViewClick:)];
        
        scrollBtn.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:scrollBtn];
    }
    return _photosView;
}

#pragma mark 个人信息界面
- (void)initWithSubView
{
    CGFloat top = self.photosView.bottom;
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, top + 6, SCREEN_WIDTH,kHEIGHT(43) * 8)];
    view1.backgroundColor = [UIColor whiteColor];
    [self addSubview:view1];
    
    NSArray *titleArr1 = @[@"姓       名:", @"性       别:", @"年       龄:",
                           @"学       历:", @"工作年限:", @"户       籍:",
                           @"现居地址:", @"手       机:"];
    NSArray *contentArr1 =@[_model.name, _model.sex, _model.birthday,
                            _model.education, _model.workTime, _model.homeTown,
                            _model.address, _model.tel];
    
    UIView *lastviewOne = nil;
    for (int i = 0; i < titleArr1.count; i++)
    {
        SPItemPreview *preview = [[SPItemPreview alloc] initWithFrame:CGRectMake(0, i*(kHEIGHT(43)), SCREEN_WIDTH, kHEIGHT(43)) title:titleArr1[i] content:contentArr1[i]];
        
        // 内容不空，才显示
        if (![contentArr1[i] isEqualToString:@""])
        {
            [view1 addSubview:preview];
            
            lastviewOne = preview;
        }
    }
    
    view1.height = lastviewOne.bottom;
    
    // 个人亮点
    CGFloat itemsHeight = view1.bottom;
    SPItemPreview *personal = [[SPItemPreview alloc] initWithFrame:CGRectMake(0, itemsHeight, SCREEN_WIDTH, kHEIGHT(43)) title:@"个人亮点" content:@""];
    [self addSubview:personal];
    
    
    // 学习能力、有亲和力；4个，间距为kListEdge=8；
    float itemWidth = (SCREEN_WIDTH - kListEdge*5)/4;
    float itemHeight = kHEIGHT(36);
    
    UIView *lastview = personal;
    NSArray *arr = [self.lightspotStr componentsSeparatedByString:SEPARATOR];
    if ([self.lightspotStr isEqualToString:@""]) {
        arr = nil;
    }
    
    UIView *lightspotBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, lastview.bottom+kListEdge, SCREEN_WIDTH, 0)];
    lightspotBackgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:lightspotBackgroundView];
    
    // 个人亮点  总高度
    CGFloat height = (arr.count/4+1)*(itemHeight+kListEdge);
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, personal.bottom, SCREEN_WIDTH, height)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    for (int i = 0; i < arr.count; i++)     // Label 学习能力、有亲和力
    {
        int row = i/4;
        int col = i%4;
        CGFloat x = kListEdge+col*(itemWidth+kListEdge);
        CGFloat y = personal.bottom+(itemHeight+kListEdge)*row;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, itemWidth, itemHeight)];
        label.backgroundColor = RGB(10, 110, 210);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.text = arr[i];
        [self addSubview:label];
        
        lastview = label;
    }
    
    // lightspotArr 始终为空；
    NSArray *lightspotHeightArr = [self getCellHeight:self.lightspotArr];
    for (int i = 0; i < self.lightspotArr.count; i++) {
        NearShowCell *cell = [[NearShowCell alloc]init];
        cell.btnDelete.hidden = YES;
        cell.btnUp.hidden = YES;
        cell.btnDown.hidden = YES;
        
        CGFloat height = [lightspotHeightArr[i] floatValue];
        
        if ([self.lightspotArr[i] isKindOfClass:[NSAttributedString class]]) {
            cell.attributedString = self.lightspotArr[i];
        }else{
            cell.asset = self.lightspotArr[i];
        }
        CGFloat top = lastview.bottom+kListEdge;
        cell.frame = CGRectMake(0, top, SCREEN_WIDTH, height);
        cell.pictureShow.frame = CGRectMake(kHEIGHT(10), 0, SCREEN_WIDTH-kHEIGHT(10)*2, height);
        cell.backgroundColor = [UIColor whiteColor];
        [cell.textShow setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
        [self addSubview:cell];
        
        lastview = cell;
    }
    
    lightspotBackgroundView.height = lastview.bottom-lightspotBackgroundView.top+kListEdge;
    
#warning 展示图片时，有问题；
    // 教育经历
    UIView *educationBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, lightspotBackgroundView.bottom, SCREEN_WIDTH, 0)];
    educationBackgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:educationBackgroundView];
    
    SPItemPreview *expe = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, lightspotBackgroundView.bottom, SCREEN_WIDTH, kHEIGHT(43)) title:@"教育经历" content:@""];
    [self addSubview:expe];
    
    UIView *educationView = expe;
    
    for (int i = 0; i < self.educationListArr.count; i++)
    {
        WPInterviewEducationModel *model = self.educationListArr[i];
        NSArray *title = @[@"学校名称:",@"在校时间:",@"专业类别:",@"学历学位:",@"专业描述:"];
        NSArray *content = @[model.schoolName,[NSString stringWithFormat:@"%@-%@",model.beginTime,model.endTime],model.major,model.education,@""];
        for (int i = 0; i < title.count; i++) {
            CGFloat top = educationView.bottom;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kListEdge, top, SCREEN_WIDTH, 30)];
            label.backgroundColor = [UIColor whiteColor];
            label.text = [NSString stringWithFormat:@"%@  %@",title[i],content[i]];
            [self addSubview:label];
            educationView = label;
        }
        
        NSArray *educaton = [self getCellHeight:model.epList];
        for (int i = 0; i < model.epList.count; i++) {
            NearShowCell *cell = [[NearShowCell alloc]init];
            cell.btnDelete.hidden = YES;
            cell.btnUp.hidden = YES;
            cell.btnDown.hidden = YES;
            
            CGFloat height = [educaton[i] floatValue];
            
            if ([model.epList[i] isKindOfClass:[NSAttributedString class]]) {
                cell.attributedString = model.epList[i];
            }else{
                cell.asset = model.epList[i];
            }
            //CGFloat top = lastview?lastview.bottom:personal.bottom;
            cell.frame = CGRectMake(0, educationView.bottom+kListEdge, SCREEN_WIDTH, height);
            cell.pictureShow.frame = CGRectMake(kHEIGHT(10), 0, SCREEN_WIDTH-kHEIGHT(10)*2, height);
            cell.backgroundColor = [UIColor whiteColor];
            [cell.textShow setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
            [self addSubview:cell];
            
            educationView = cell;
        }
        
    }
    
    educationBackgroundView.height = educationView.bottom-educationBackgroundView.top+kListEdge;
    
    // 工作经历
    UIView *workBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, educationBackgroundView.bottom, SCREEN_WIDTH, 0)];
    workBackgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:workBackgroundView];
    
    SPItemPreview *workList = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, educationBackgroundView.bottom, SCREEN_WIDTH, kHEIGHT(43)) title:@"工作经历" content:@""];
    [self addSubview:workList];
    
    UIView *worklistView = workList;
    
    for (int i = 0; i < self.workListArr.count; i++) {
        WPInterviewWorkModel *model = self.workListArr[i];
        NSArray *title = @[@"公司名称:",@"任职时间:",@"企业行业:",@"职位名称:",@"薪资待遇:",@"职位描述"];
        NSArray *content = @[model.epName,[NSString stringWithFormat:@"%@-%@",model.beginTime,model.endTime],model.industry,model.position,model.salary,@""];
        for (int i = 0; i < title.count; i++) {
            CGFloat top = worklistView.bottom;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kListEdge, top, SCREEN_WIDTH, 30)];
            label.backgroundColor = [UIColor whiteColor];
            label.text = [NSString stringWithFormat:@"%@  %@",title[i],content[i]];
            [self addSubview:label];
            worklistView = label;
        }
        
        NSArray *educaton = [self getCellHeight:model.epList];
        for (int i = 0; i < model.epList.count; i++) {
            NearShowCell *cell = [[NearShowCell alloc]init];
            cell.btnDelete.hidden = YES;
            cell.btnUp.hidden = YES;
            cell.btnDown.hidden = YES;
            
            CGFloat height = [educaton[i] floatValue];
            
            if ([model.epList[i] isKindOfClass:[NSAttributedString class]]) {
                cell.attributedString = model.epList[i];
            }else{
                cell.asset = model.epList[i];
            }
            //CGFloat top = lastview?lastview.bottom:personal.bottom;
            cell.frame = CGRectMake(0, worklistView.bottom+kListEdge, SCREEN_WIDTH, height);
            cell.pictureShow.frame = CGRectMake(kHEIGHT(10), 0, SCREEN_WIDTH-kHEIGHT(10)*2, height);
            cell.backgroundColor = [UIColor whiteColor];
            [cell.textShow setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
            [self addSubview:cell];
            
            worklistView = cell;
        }
    }
    
    workBackgroundView.height = worklistView.bottom- workBackgroundView.top+kListEdge;

    self.contentSize = CGSizeMake(SCREEN_WIDTH, workBackgroundView.bottom+10);
}

- (NSArray *)getCellHeight:(NSArray *)array
{
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
            [label setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
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
            UIImageView *imageV = [UIImageView new];
            //CGFloat height = 0;
            //__block typeof(height) weakHeight = height;
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:array[i]]];
            [imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGFloat weakHeight = ((SCREEN_WIDTH - kHEIGHT(10)*2)/image.size.width)*image.size.height;
                NSString *str = [NSString stringWithFormat:@"%f",weakHeight];
                [heightArr replaceObjectAtIndex:i withObject:str];
                
            }];
        }
    }
    return heightArr;
}



#pragma mark - 点击图片、浏览；视频播放
- (void)checkImageClick:(UIButton *)sender
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
    
    if (sender.tag >= PhotoTag && sender.tag < VideoTag)
    {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < self.photosArr.count; i++)  // 头像 或背景图
        {
            MJPhoto *photo = [[MJPhoto alloc]init];
      
            if ([self.photosArr[i] isKindOfClass:[SPPhotoAsset class]])
            {
                // 完整的图片
                photo.image = [self.photosArr[i] originImage];
            }else{
                
                photo.url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] thumb_path]]];
            }
            
            // 来源view
            photo.srcImageView = [(UIButton *)[self viewWithTag:PhotoTag+i] imageView];
            
            [arr addObject:photo];
        }
        
        MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
        brower.currentPhotoIndex = sender.tag - PhotoTag;
        brower.photos = arr;
        
        [brower show];
    }
    else
    {
        if (self.checkVideosBlock)  // 视频播放
        {
            self.checkVideosBlock(sender.tag-VideoTag);
        }
    }
}



#pragma mark - 箭头点击
- (void)photosViewClick:(UIButton *)sender
{
    if (self.checkPhotosBlock) {
        self.checkPhotosBlock();
    }
}


#pragma mark - 电话、短信，暂时无用
- (void)phoneClick:(UIButton *)sender
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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



#pragma mark - 无用
- (void)checkVideoClick:(UIButton *)sender
{
    if (self.checkVideosBlock) {
        self.checkVideosBlock(sender.tag - 80);
    }
}


- (void)videosViewClick:(UIButton *)sender
{
    if (self.checkAllVideosBlock) {
        self.checkAllVideosBlock();
    }
}

@end
