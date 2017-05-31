//
//  WPCompanyPreview.m
//  WP
//
//  Created by CBCCBC on 15/12/9.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPCompanyPreview.h"

#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "WPCompanyListModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SPPhotoAsset.h"
#import "SPItemPreview.h"
#import "TYAttributedLabel.h"
#import "MLSelectPhotoAssets.h"
#import "NearShowCell.h"

#define PhotoTag 200
#define VideoTag 300

@interface WPCompanyPreview ()

@property (strong, nonatomic) UIScrollView *photosView;

@property (strong, nonatomic) NSMutableArray *photosArr;
@property (strong, nonatomic) NSMutableArray *videosArr;

@property (nonatomic, strong) NSArray *cellHeightArray;

@end

@implementation WPCompanyPreview

- (void)setModel:(WPCompanyListModel *)model{
    _model = model;
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GetHeight(SCREEN_WIDTH))];
#pragma mark -- 被注释掉的bug a0(数组中元素为空对象 , 相关页面:WPCompanyEditController)
//    imageView.image = self.logoArray[0];
    //NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.QRCode]];
    //[imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"back_default"]];
    [self addSubview:imageView];
    
    [self addSubview:self.photosView];
    
    NSArray *title = @[@"企业名称:",@"企业行业:",@"企业性质:",@"企业规模:",@"企业地点:",@"详细地点:",@"企业电话:",@"企业Q Q:",@"企业微信:",@"企业官网:",@"企业邮箱:",@"联  系 人:",@"联系方式:",@"企业简介:"];
    NSArray *content = @[model.enterpriseName,model.dataIndustry,model.enterpriseProperties,model.enterpriseScale,model.enterpriseAddress,model.enterpriseAds,model.enterprisePhone,model.enterpriseQq,model.enterpriseWebchat,model.enterpriseWebsite,model.enterpriseEmail,model.enterprisePersonName,model.enterprisePersonTel,@""];

    UIView *lastview = nil;
    for (int i = 0 ; i < title.count; i++) {
        CGFloat top = lastview?lastview.bottom:self.photosView.bottom+kListEdge;
        SPItemPreview *itemView = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight) title:title[i] content:content[i]];
        if (![content[i] isEqualToString:@""]) {
            [self addSubview:itemView];
            lastview = itemView;
        }
    }
    
    if (self.briefArray.count) {
        self.cellHeightArray = [self getCellHeight];
        for (int i = 0; i < self.briefArray.count; i++) {
            NearShowCell *cell = [[NearShowCell alloc]init];
            cell.btnDelete.hidden = YES;
            cell.btnUp.hidden = YES;
            cell.btnDown.hidden = YES;
            
            CGFloat height = [self.cellHeightArray[i] floatValue];
            
            if ([self.briefArray[i] isKindOfClass:[NSAttributedString class]]) {
                cell.attributedString = self.briefArray[i];
            }else{
                cell.asset = self.briefArray[i];
            }
            //CGFloat top = lastTwoView?lastTwoView.bottom:lastView.bottom;
            cell.frame = CGRectMake(0, lastview.bottom+kListEdge, SCREEN_WIDTH, height);
            cell.pictureShow.frame = CGRectMake(kHEIGHT(10), 0, SCREEN_WIDTH-kHEIGHT(10)*2, height);
            [cell.textShow setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
            [self addSubview:cell];
            
            lastview = cell;
        }
    }else{
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (WPRecruitDraftInfoRemarkModel *remarkModel in self.model.epRemarkList) {
            if ([remarkModel.types isEqualToString:@"txt"]) {
                NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                [arr addObject:str];
            }else{
                [arr addObject:remarkModel.txtcontent];
            }
        }
        self.cellHeightArray = [self getCellHeight:model];
        
        for (int i = 0; i < self.model.epRemarkList.count; i++) {
            NearShowCell *cell = [[NearShowCell alloc]init];
            cell.btnDelete.hidden = YES;
            cell.btnUp.hidden = YES;
            cell.btnDown.hidden = YES;
            
            CGFloat height = [self.cellHeightArray[i] floatValue];
            
            if ([arr[i] isKindOfClass:[NSAttributedString class]]) {
                cell.attributedString = arr[i];
            }else{
                cell.asset = arr[i];
            }
            //CGFloat top = lastTwoView?lastTwoView.bottom:lastView.bottom;
            cell.frame = CGRectMake(0, lastview.bottom+kListEdge, SCREEN_WIDTH, height);
            [cell.textShow setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
            cell.pictureShow.frame = CGRectMake(kHEIGHT(10), 0, SCREEN_WIDTH-kHEIGHT(10)*2, height);
            [self addSubview:cell];
            
            lastview = cell;
        }
    }
    
    self.contentSize = CGSizeMake(SCREEN_WIDTH, lastview.bottom+kListEdge);
    
    [self.photosArr addObjectsFromArray:self.model.photoList];
    [self.videosArr addObjectsFromArray:self.model.videoList];
    [self updatePhotosView];
    
}

- (NSArray *)getCellHeight:(WPCompanyListModel *)model{
    NSMutableArray *cellHeightArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < model.epRemarkList.count; i++) {
        [cellHeightArray addObject:@"0"];
    }
    
    //self.briefArray = model.epRemarkList;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (WPRecruitDraftInfoRemarkModel *remarkModel in model.epRemarkList) {
        if ([remarkModel.types isEqualToString:@"txt"]) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [arr addObject:str];
        }else{
            [arr addObject:remarkModel.txtcontent];
        }
    }
    
    for (int i = 0; i<arr.count; i++) {
        if ([arr[i] isKindOfClass:[NSAttributedString class]]) {
            //            return 102;
            TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
            [label setAttributedText:arr[i]];
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
            [cellHeightArray replaceObjectAtIndex:i withObject:str];
            
        }
        if ([arr[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
            MLSelectPhotoAssets *asset = arr[i];
            ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
            CGFloat height;
            CGSize dimension = [representation dimensions];
            height = ((SCREEN_WIDTH-kHEIGHT(10)*2)/dimension.width)*dimension.height;
            NSString *str = [NSString stringWithFormat:@"%f",height];
            [cellHeightArray replaceObjectAtIndex:i withObject:str];
        }
        if ([arr[i] isKindOfClass:[NSString class]]) {
            
            
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:arr[i]]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            CGFloat weakHeight = ((SCREEN_WIDTH - kHEIGHT(10)*2)/image.size.width)*image.size.height;
            NSString *str = [NSString stringWithFormat:@"%f",weakHeight];
            [cellHeightArray replaceObjectAtIndex:i withObject:str];
            NSLog(@"==============%@",image);
            
            //UIImageView *imageV = [UIImageView new];
            //[imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //CGFloat weakHeight = ((SCREEN_WIDTH - kHEIGHT(10)*2)/image.size.width)*image.size.height;
                //NSString *str = [NSString stringWithFormat:@"%f",weakHeight];
                //[cellHeightArray replaceObjectAtIndex:i withObject:str];
            //}];
        }
    }
    return cellHeightArray;
}

- (NSArray *)getCellHeight{
    NSMutableArray *cellHeightArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.briefArray.count; i++) {
        [cellHeightArray addObject:@"0"];
    }
    
    //self.briefArray = model.epRemarkList;
    //NSMutableArray *arr = [[NSMutableArray alloc]init];
    //for (WPRecruitDraftInfoRemarkModel *remarkModel in self.briefArray) {
        //if ([remarkModel.types isEqualToString:@"txt"]) {
            //NSAttributedString *str = [[NSAttributedString alloc] initWithData:[remarkModel.txtcontent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            //[arr addObject:str];
        //}else{
            //[arr addObject:remarkModel.txtcontent];
        //}
    //}
    
    for (int i = 0; i<self.briefArray.count; i++) {
        if ([self.briefArray[i] isKindOfClass:[NSAttributedString class]]) {
            //            return 102;
            TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
            [label setAttributedText:self.briefArray[i]];
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
            [cellHeightArray replaceObjectAtIndex:i withObject:str];
            
        }
        if ([self.briefArray[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
            MLSelectPhotoAssets *asset = self.briefArray[i];
            ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
            CGFloat height;
            CGSize dimension = [representation dimensions];
            height = ((SCREEN_WIDTH)/dimension.width)*dimension.height;
            NSString *str = [NSString stringWithFormat:@"%f",height];
            [cellHeightArray replaceObjectAtIndex:i withObject:str];
        }
        if ([self.briefArray[i] isKindOfClass:[NSString class]]) {
            
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.briefArray[i]]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            CGFloat weakHeight = ((SCREEN_WIDTH - kHEIGHT(10)*2)/image.size.width)*image.size.height;
            NSString *str = [NSString stringWithFormat:@"%f",weakHeight];
            [cellHeightArray replaceObjectAtIndex:i withObject:str];
            //UIImageView *imageV = [UIImageView new];
            ////CGFloat height = 0;
            ////__block typeof(height) weakHeight = height;
            //NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.briefArray[i]]];
            //[imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //CGFloat weakHeight = ((SCREEN_WIDTH - 20)/image.size.width)*image.size.height;
                //NSString *str = [NSString stringWithFormat:@"%f",weakHeight];
                //[cellHeightArray replaceObjectAtIndex:i withObject:str];
                
            //}];
        }
    }
    return cellHeightArray;
}

- (NSMutableArray *)photosArr{
    if (!_photosArr) {
        _photosArr = [[NSMutableArray alloc]init];
    }
    return _photosArr;
}

- (NSMutableArray *)videosArr{
    if (!_videosArr) {
        _videosArr = [[NSMutableArray alloc]init];
    }
    return _videosArr;
}

- (NSArray *)logoArray{
    if (!_logoArray) {
        _logoArray = [[NSArray alloc]init];
    }
    return _logoArray;
}

- (NSArray *)briefArray{
    if (!_briefArray) {
        _briefArray = [[NSArray alloc]init];
    }
    return _briefArray;
}

- (NSArray *)cellHeightArray{
    if (!_cellHeightArray) {
        _cellHeightArray = [[NSArray alloc]init];
    }
    return _cellHeightArray;
}

-(UIScrollView *)photosView
{
    if (!_photosView) {
        
        //        CGFloat height = (SCREEN_WIDTH-30-2*3)/4+16;
        _photosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, GetHeight(SCREEN_WIDTH), SCREEN_WIDTH-30, PhotoViewHeight)];
        _photosView.backgroundColor = [UIColor whiteColor];
        _photosView.showsHorizontalScrollIndicator = NO;
        
        /**< 照片墙翻页 */
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-30, _photosView.top, 30, PhotoViewHeight) ImageName:@"common_icon_arrow" Target:self Action:@selector(recuilistTagClick:)];
        scrollBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:scrollBtn];
    }
    return _photosView;
}

- (void)recuilistTagClick:(UIButton *)sender{
    if (self.CompanyEditPreviewCheckAllPhotosAndVideosBlock) {
        self.CompanyEditPreviewCheckAllPhotosAndVideosBlock();
    }
}

-(void)updatePhotosView
{
    for (UIView *view in self.photosView.subviews) {
        [view removeFromSuperview];
    }
    
    //    for (int i = 0; i < self.photosArr.count; i++) {
    //        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //        button.frame = CGRectMake(i*(64+2)+10, 10, 64, 64);
    //        button.tag = 30+i;
    //        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //        [button setImage:self.photosArr[i] forState:UIControlStateNormal];
    //        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
    //        [self.photosView addSubview:button];
    //    }
    //    if (self.photosArr.count == 8) {
    //        self.photosView.contentSize = CGSizeMake(8*(64+2)+10, 64);
    //    }else{
    //        self.photosView.contentSize = CGSizeMake(self.photosArr.count*(64+2)+64+10, 64);
    //        _addPhotoBtn.frame = CGRectMake(self.photosArr.count*(64+2)+10, 10, 64, 64);
    //        [self.photosView addSubview:_addPhotoBtn];
    //    }
    for (int i = 0; i < self.photosArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+6)+10, 10, PhotoHeight, PhotoHeight);
        button.tag = PhotoTag+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        //        SPPhotoAsset *asset = ;
        if ([self.photosArr[i] isKindOfClass:[Pohotolist class]]) {
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] thumb_path]]];
            [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        }else{
            [button setImage:[self.photosArr[i] thumbImage] forState:UIControlStateNormal];
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
        [button addTarget:self action:@selector(checkVideoClick:) forControlEvents:UIControlEventTouchUpInside];
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
    }
    
}

- (void)checkImageClick:(UIButton *)sender{
    if (self.CompanyEditPreviewCheckSinglePhotoBlock) {
        self.CompanyEditPreviewCheckSinglePhotoBlock(sender.tag-PhotoTag);
    }
}

- (void)checkVideoClick:(UIButton *)sender{
    if (self.CompanyEditPreviewCheckSingleVideoBlock) {
        self.CompanyEditPreviewCheckSingleVideoBlock(sender.tag-VideoTag);
    }
}

@end
