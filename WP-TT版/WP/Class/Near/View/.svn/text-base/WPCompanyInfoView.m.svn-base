
//
//  WPCompanyInfoView.m
//  WP
//
//  Created by CBCCBC on 16/3/31.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPCompanyInfoView.h"
#import "SPItemPreview.h"
#import "WPRecruitDraftInfoRemarkModel.h"
#import "NearShowCell.h"
#import "WPPersonalInfoPreview.h"

#import "SPPhotoAsset.h"

#import "SPItemPreview.h"

#import "NearShowCell.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#define PhotoTag 70
#define VideoTag 85

@interface WPCompanyInfoView () <UIActionSheetDelegate>

@property (strong, nonatomic) UIScrollView *photosView;
@property (strong, nonatomic) UIScrollView *videosView;

@property (assign, nonatomic) CGFloat contentSizeHeight;

@property (nonatomic ,strong)NSArray *titleArray; // 标题数组  高度 kHEIGHT(43)
@property (nonatomic ,strong)NSArray *dataArray;  // 数据数组  遍历这个数组,并判断元素是否为空 若为空,跳过该元素
@property (nonatomic, strong)NSArray *epRemarkArray; // 图片数组  遍历该数组获取所有的图片以及公司简介信息
@property (nonatomic, strong)UIScrollView *imageView;
@property (nonatomic, strong)UIView *infoView;
@property (nonatomic, strong)UIView *introduction;
@property (nonatomic ,strong)UIScrollView *baseView;
@property (nonatomic ,strong)NSMutableArray *heightArr;
@end

@implementation WPCompanyInfoView

#pragma mark - Array 初始化
- (NSArray *)photosArr
{
    if (!_photosArr) {
        _photosArr = [NSArray arrayWithArray:self.model.photoList];
    }
    return _photosArr;
}

- (NSArray *)videosArr
{
    if (!_videosArr) {
        _videosArr = [NSArray arrayWithArray:self.model.videoList];
    }
    return _videosArr;
}

- (NSMutableArray *)lightspotArr{
    if (!_lightspotArr) {
        _lightspotArr = [[NSMutableArray alloc]init];
    }
    return _lightspotArr;
}

#pragma mark - 重新加载数据
- (void)reloadData
{
    self.backgroundColor = RGB(226, 226, 226);
    
    _contentSizeHeight = 480;
    
    [self addSubview:self.photosView];  // 照片、视频
    
    [self initWithSubView]; // 个人信息界面
}

#pragma mark - 照片、视频 选择界面
- (UIScrollView *)photosView
{
    if (!_photosView) {
        
        _photosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, self.width - 30, PhotoViewHeight)];
        _photosView.backgroundColor = [UIColor whiteColor];
        _photosView.showsHorizontalScrollIndicator = NO;
        CGFloat fileCount = self.photosArr.count + self.videosArr.count;
        
        // 照片
        // 10,第一个距左边 边距；
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
        
        // 视频
        // 前面photos的位置；
        CGFloat width = self.photosArr.count * (PhotoHeight+6) + 10;
        
        for (int i = 0; i < self.videosArr.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(i*(PhotoHeight+6)+width, 10, PhotoHeight, PhotoHeight);
            button.tag = VideoTag+i;
            button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
            
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
            
            // 播放按钮
            UIImageView *subImageV = [[UIImageView alloc] initWithFrame:CGRectMake(PhotoHeight/2-10, PhotoHeight/2-10, 20, 20)];
            subImageV.image = [UIImage imageNamed:@"video_play"];
            [button addSubview:subImageV];
        }
        
        /** 箭头按钮 */
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
    
    // top + 6 为间距，留白
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, top + 6, SCREEN_WIDTH,kHEIGHT(43) * 8)];
    view1.backgroundColor = [UIColor whiteColor];
    [self addSubview:view1];
    
    NSArray *titleArr1 = @[@"企业名称:",@"企业行业:",@"企业性质:",@"企业规模:",@"企业地点:",@"详细地址:",@"企业电话:",@"企业QQ:",@"企业微信:",@"企业官网:",@"企业邮箱:",@"联系人:",@"联系方式:",@"公司简介:"];
    NSArray *contentArr1 = @[_model.enterpriseName,_model.dataIndustryId,_model.dataIndustry,_model.enterpriseProperties,_model.enterpriseScale,_model.enterpriseAddress,_model.enterpriseAddressID,_model.enterpriseAds,_model.enterprisePhone,_model.enterpriseQq,_model.enterpriseWebchat,_model.enterpriseWebsite,_model.enterpriseEmail,_model.enterprisePersonName];
    UIView *lastviewOne = nil;
    for (int i = 0; i < titleArr1.count; i++)
    {
        // 内容不空，才显示
        if (![contentArr1[i] isEqualToString:@""])
        {
            SPItemPreview *preview = [[SPItemPreview alloc] initWithFrame:CGRectMake(0, i*(kHEIGHT(43)), SCREEN_WIDTH, kHEIGHT(43)) title:titleArr1[i] content:contentArr1[i]];
            [view1 addSubview:preview];
            lastviewOne = preview;
        }
    }
    
    view1.height = lastviewOne.bottom;
    
    CGFloat itemsHeight = view1.bottom;
    SPItemPreview *personal = [[SPItemPreview alloc] initWithFrame:CGRectMake(0, itemsHeight + 6, SCREEN_WIDTH, kHEIGHT(43)) title:@"企业简介:" content:@""];
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
    
    for (int i = 0; i < arr.count; i++)
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
    
    [self.lightspotArr removeAllObjects];
    for (WPRecruitDraftInfoRemarkModel *model in self.model.epRemarkList) {
        if ([model.types isEqualToString:@"img"]) {
            [self.lightspotArr addObject:model.txtcontent];
        }
        
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
    
    self.contentSize = CGSizeMake(SCREEN_WIDTH, lightspotBackgroundView.bottom+10);
}

- (NSArray *)getCellHeight:(NSArray *)array
{
    NSMutableArray *heightArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < array.count; i++) {
        [heightArr addObject:@"0"];
    }
    
    for (int i = 0; i<array.count; i++) {
        
        if ([array[i] isKindOfClass:[NSAttributedString class]])
        {
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
        else if ([array[i] isKindOfClass:[MLSelectPhotoAssets class]])
        {
            MLSelectPhotoAssets *asset = array[i];
            ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
            CGFloat height;
            CGSize dimension = [representation dimensions];
            height = ((SCREEN_WIDTH-kHEIGHT(10)*2)/dimension.width)*dimension.height;
            NSString *str = [NSString stringWithFormat:@"%f",height];
            [heightArr replaceObjectAtIndex:i withObject:str];
        }
        else if ([array[i] isKindOfClass:[NSString class]])
        {
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
            
            // 来源的view
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


@end
