//
//  SPRecPreview.m
//  WP
//
//  Created by CBCCBC on 15/10/27.
//  Copyright © 2015年 WP. All rights reserved.
//


#import "SPRecPreview.h"
#import "SPPhotoAsset.h"
#import "THLabel.h"
#import "SPTitleItem.h"
#import "SPItemPreview.h"
#import "SPItemPreview3.h"
#import "SPRecSubview.h"
#import "SPShareView.h"
#import "WPRecruitiew.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SPPhotoAsset.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "TYAttributedLabel.h"
#import "MLSelectPhotoAssets.h"
#import "NearShowCell.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "WPGridView.h"
#define TagShowAllPhotos 14
#define TagPhoto 30
#define TagVideo 45
#define TagCompany 52
#define TagInfo 53


@implementation WPRecruitPreviewModel

- (NSArray *)photosArr{
    if (!_photosArr) {
        _photosArr = [[NSArray alloc]init];
    }
    return _photosArr;
}

- (NSArray *)videosArr{
    if (!_videosArr) {
        _videosArr = [[NSArray alloc]init];
    }
    return _videosArr;
}

- (NSArray *)logoArr{
    if (!_logoArr) {
        _logoArr = [[NSArray alloc]init];
    }
    return _logoArr;
}

- (NSArray *)briefArr{
    if (!_briefArr) {
        _briefArr = [[NSArray alloc]init];
    }
    return _briefArr;
}

- (NSArray *)recruitResumeArr{
    if (!_recruitResumeArr) {
        _recruitResumeArr = [[NSArray alloc]init];
    }
    return _recruitResumeArr;
}

@end

@interface SPRecPreview ()

@property (strong, nonatomic) UIScrollView *photosView;
@property (nonatomic, strong) NSMutableArray *briefCellHeightArray;


@end

@implementation SPRecPreview

- (NSMutableArray *)briefCellHeightArray{
    if (!_briefCellHeightArray) {
        _briefCellHeightArray = [[NSMutableArray alloc]init];
    }
    return _briefCellHeightArray;
}

- (void)getCellHeight{
    for (int i = 0; i < self.model.briefArr.count; i++) {
        [self.briefCellHeightArray addObject:@"0"];
    }
    for (int i = 0; i<self.model.briefArr.count; i++) {
        if ([self.model.briefArr[i] isKindOfClass:[NSAttributedString class]]) {
            //            return 102;
            TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
            [label setAttributedText:self.model.briefArr[i]];
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
            [self.briefCellHeightArray replaceObjectAtIndex:i withObject:str];
            
        }
        if ([self.model.briefArr[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
            MLSelectPhotoAssets *asset = self.model.briefArr[i];
            ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
            CGFloat height;
            CGSize dimension = [representation dimensions];
            height = ((SCREEN_WIDTH)/dimension.width)*dimension.height;
            NSString *str = [NSString stringWithFormat:@"%f",height];
            [self.briefCellHeightArray replaceObjectAtIndex:i withObject:str];
        }
        if ([self.model.briefArr[i] isKindOfClass:[NSString class]]) {
            UIImageView *imageV = [UIImageView new];
            //CGFloat height = 0;
            //__block typeof(height) weakHeight = height;
            WS(ws);
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.model.briefArr[i]]];
            [imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGFloat weakHeight = ((SCREEN_WIDTH - 20)/image.size.width)*image.size.height;
                NSString *str = [NSString stringWithFormat:@"%f",weakHeight];
                [ws.briefCellHeightArray replaceObjectAtIndex:i withObject:str];
                
            }];
        }
    }
}

- (CGFloat)getTextCellHeight:(NSAttributedString *)str{
    TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
    [label setAttributedText:str];
    label.linesSpacing = 4;
    label.characterSpacing = -1;
    [label setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
    CGFloat height;
    CGFloat textHeight = label.frame.size.height;
    height = textHeight;
    //if (textHeight < ItemViewHeight) {
    //height = ItemViewHeight;
    //} else {
    //height = height;
    //}
    return height;
}

- (void)setModel:(WPRecruitPreviewModel *)model{
    
    _model = model;
    
    self.contentSize = CGSizeMake(SCREEN_WIDTH, 2000);
    self.backgroundColor =RGB(235, 235, 235);
    
    [self addSubview:self.photosView];
    
    NSArray *companyTitleArr = @[@"企业名称:",@"企业行业:",@"企业性质:",@"企业规模:",@"企业区域:",@"详细地址:",@"联  系 人:",@"企业官网:",@"企业描述:"];

    NSArray *companyContentArr = @[_model.listModel.enterpriseName,_model.listModel.dataIndustry,_model.listModel.enterpriseProperties,_model.listModel.enterpriseScale,_model.listModel.enterpriseAddress,_model.listModel.enterpriseDewtailAddress,_model.listModel.enterprisePersonName,_model.listModel.enterpriseWebsite,_model.listModel.enterpriseBrief];
    UIView *lastView = nil;
    for (int i = 0; i < companyTitleArr.count; i++) {
//        CGFloat top = self.photosView.bottom+kListEdge;
        CGFloat top ;
        if (i == 0) {
             top = self.photosView.bottom+kListEdge;
        }
        else
        {
            if (lastView)
            {
               top = lastView.bottom;
            }
            else
            {
             top = self.photosView.bottom+kListEdge;
            }
            
        }
        
        SPItemPreview *itemPreview = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight) title:companyTitleArr[i] content:companyContentArr[i]];
//        NSString * contentStr = [NSString stringWithFormat:@"%@",companyContentArr[i]];
//        if (contentStr.length && ![contentStr isEqualToString:@"(null)"]) {
//            [self addSubview:itemPreview];
//              lastView = itemPreview;
//        }
        if ((i!=(companyContentArr.count-1))&&(![companyContentArr[i] isEqualToString:@""])) {
            [self addSubview:itemPreview];
            lastView = itemPreview;
        }
//        if ((i==(companyContentArr.count-1))&&self.model.briefStr.length) {
//            [self addSubview:itemPreview];
//            lastView = itemPreview;
//        }
    }
    
//    [self getCellHeight];
    
    //lastview为空时，lastview为photoView
    if (!lastView.bottom) {
        lastView = self.photosView;
    }

    //UIView *lastTwoView = nil;
    UIView *cellBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, lastView.bottom, SCREEN_WIDTH, 0)];
    cellBackgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:cellBackgroundView];
    if (!self.model.briefStr.length) {
        self.model.briefStr= _model.listModel.enterpriseBrief;  
    }
  
    if (self.model.briefStr.length||_model.listModel.enterpriseBrief.length) {
        NSString * briefStr = [NSString stringWithFormat:@"企业描述: %@",self.model.briefStr];
        CGSize size = [briefStr getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH-2*kHEIGHT(12)];
        UILabel * produceLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), lastView.bottom+2*kListEdge, SCREEN_WIDTH-2*kHEIGHT(12), size.height)];
        produceLabel.numberOfLines = 0;
        produceLabel.text = briefStr;
        [self addSubview:produceLabel];
        lastView = produceLabel;
    }
    
    if (cellBackgroundView.top == lastView.bottom) {
        cellBackgroundView.height = lastView.bottom-cellBackgroundView.top;
    }else{
        cellBackgroundView.height = lastView.bottom-cellBackgroundView.top+kListEdge*2;
    }
    
    // 第一组
    NSArray *recruitTitleArr = @[@"招聘职位:",@"工资待遇:",@"企业福利:",@"工作年限:",@"学历要求:",@"性别要求:",@"年龄要求:",@"招聘人数:",@"工作区域:",@"详细地址:",@"手机号码:",@"任职要求:"];
    WPRecEditModel *recruitModel = _model.recruitResumeArr[0];
    NSArray *recruitContentArr = @[recruitModel.jobPositon,recruitModel.salary,recruitModel.epRange,recruitModel.workTime,recruitModel.education,recruitModel.sex,recruitModel.age,recruitModel.invitenumbe,recruitModel.workAddress,recruitModel.workAdS,recruitModel.Tel,@""];
    UIView *recruitLastView = nil;
    for (int i = 0; i < recruitTitleArr.count; i++) {
        CGFloat top = recruitLastView?recruitLastView.bottom:cellBackgroundView.bottom+kListEdge;
        if (i == 2)
        {
            UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, 0)];
            view2.backgroundColor = [UIColor whiteColor];
            [self addSubview:view2];
            
            CGSize size = [recruitTitleArr[i] getSizeWithFont:FUCKFONT(15) Height:20];
            //添加"期望福利"
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12),kHEIGHT(12), size.width, size.height)];
            label.font = kFONT(15);
            label.text = recruitTitleArr[i];
            //添加具体的福利
            WPGridView *gridView = [[WPGridView alloc]initWithFrame:CGRectMake(label.right+6,kHEIGHT(12), SCREEN_WIDTH-label.right-6, kHEIGHT(43))];
            gridView.textArray = [recruitModel.epRange componentsSeparatedByString:@"/"];
            CGRect rect = gridView.frame;
            NSArray * array = [recruitModel.epRange componentsSeparatedByString:@"/"];
            if (array.count <= 3)
            {
                rect.size.height = label.size.height;
            }
            else
            {
                rect.size.height = kHEIGHT(43);
            }
            gridView.frame = rect;
            gridView.font = kFONT(15);
            gridView.rows = 3;
            gridView.rowSpace = 10;
            
            [gridView finishToShow];
            view2.height = gridView.height+2*kHEIGHT(12);
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, view2.height-0.5, SCREEN_WIDTH, 0.5)];
            line.backgroundColor = RGB(235, 235, 235);
            if (![recruitContentArr[i] isEqualToString:@""]) {
                [view2 addSubview:gridView];
                [view2 addSubview:label];
                [view2 addSubview: line];
                recruitLastView = view2;
            }
 
        }
        else
        {
            SPItemPreview *itemView = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight) title:recruitTitleArr[i] content:recruitContentArr[i]];
            
            if (i!=recruitContentArr.count-1&&![recruitContentArr[i] isEqualToString:@""]) {
                [self addSubview:itemView];
                recruitLastView = itemView;
            }
        
        }
//        if (i==recruitContentArr.count-1&&recruitModel.requireString) {
//            [self addSubview:itemView];
//            recruitLastView = itemView;
//        }
    }
    
    //任职要求
    if (recruitModel.requstString.length && ![recruitModel.requstString isEqualToString:@"(null)"]) {
        NSString * briefStr = [NSString stringWithFormat:@"任职要求: %@",recruitModel.requstString];
        CGSize size = [briefStr getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH-2*kHEIGHT(12)];
        UILabel * produceLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), recruitLastView.bottom+2*kListEdge, SCREEN_WIDTH-2*kHEIGHT(12), size.height)];
        produceLabel.numberOfLines = 0;
        produceLabel.text = briefStr;
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, recruitLastView.bottom, SCREEN_WIDTH, size.height+4*kListEdge)];//kHEIGHT(12)
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        [self addSubview:produceLabel];
         recruitLastView = backView;
    }
    
//    NearShowCell *cell = [[NearShowCell alloc]init];
//    cell.btnDelete.hidden = YES;
//    cell.btnUp.hidden = YES;
//    cell.btnDown.hidden = YES;
//    CGFloat height = [self getTextCellHeight:recruitModel.requstString];
//        cell.attributedString = recruitModel.requstString;
//    //CGFloat top = lastTwoView?lastTwoView.bottom:lastView.bottom;
//    cell.backgroundColor = [UIColor whiteColor];
//    cell.frame = CGRectMake(0, recruitLastView.bottom, SCREEN_WIDTH, height);
//    [cell.textShow setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH-20];
//    if (recruitModel.requireString) {
//        [self addSubview:cell];
//    }
    
//    NSArray *InfoTitleArr = @[@"企业电话:",@"企业Q Q:",@"企业微信:",@"企业官网:",@"企业邮箱:"];
//    NSArray *InfoContentArr = @[_model.listModel.enterprisePhone,_model.listModel.enterpriseQq,_model.listModel.enterpriseWebchat,_model.listModel.enterpriseWebsite,_model.listModel.enterpriseEmail];
//    UIView *InfoLastView = nil;
//    for (int i = 0; i < InfoTitleArr.count; i++) {
//        CGFloat top = InfoLastView?InfoLastView.bottom:recruitLastView.bottom+kListEdge;
//        SPItemPreview *itemView = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight) title:InfoTitleArr[i] content:InfoContentArr[i]];
//        if (![InfoContentArr[i] isEqualToString:@""]) {
//            [self addSubview:itemView];
//            InfoLastView = itemView;
//        }
//    }
    
     // 后面的几组
    UIView *recruitAllLastView = nil;
    for (int j = 1; j < _model.recruitResumeArr.count; j++) {
        NSArray *recruitTitleArr = @[@"招聘职位:",@"工资待遇:",@"企业福利:",@"工作年限:",@"学历要求:",@"性别要求:",@"年龄要求:",@"招聘人数:",@"工作区域:",@"详细地址:",@"手机号码:",@"任职要求:"];
        WPRecEditModel *recruitModel = _model.recruitResumeArr[j];
        NSArray *recruitContentArr = @[recruitModel.jobPositon,recruitModel.salary,recruitModel.epRange,recruitModel.workTime,recruitModel.education,recruitModel.sex,recruitModel.age,recruitModel.invitenumbe,recruitModel.workAddress,recruitModel.workAdS,recruitModel.Tel,recruitModel.Require];
//        UIView *recruitLastView = nil;
        for (int i = 0; i < recruitTitleArr.count; i++) {
            CGFloat top = recruitAllLastView?recruitAllLastView.bottom:recruitLastView.bottom+kListEdge;
            if (i == 2)
            {
                
                UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, 0)];
                view2.backgroundColor = [UIColor whiteColor];
                [self addSubview:view2];
                
                
                CGSize size = [recruitTitleArr[i] getSizeWithFont:FUCKFONT(15) Height:20];
                //添加"期望福利"
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12),kHEIGHT(12), size.width, size.height)];
                label.font = kFONT(15);
                label.text = recruitTitleArr[i];
                //添加具体的福利
                WPGridView *gridView = [[WPGridView alloc]initWithFrame:CGRectMake(label.right+6,kHEIGHT(12), SCREEN_WIDTH-label.right-6, kHEIGHT(43))];
                gridView.textArray = [recruitModel.epRange componentsSeparatedByString:@"/"];
                CGRect rect = gridView.frame;
                NSArray * array = [recruitModel.epRange componentsSeparatedByString:@"/"];
                if (array.count <= 3)
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
                view2.height = gridView.height+2*kHEIGHT(12);
                UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, view2.height-0.5, SCREEN_WIDTH, 0.5)];
                line.backgroundColor = RGB(235, 235, 235);
                if (![recruitContentArr[i] isEqualToString:@""]) {
                    [view2 addSubview:gridView];
                    [view2 addSubview:label];
                    [view2 addSubview:line];
                    recruitAllLastView = view2;
                }
            }
            else
            {
                if (j == 2 && i == 0) {
                    top += kListEdge;
                }
                SPItemPreview *itemView = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight) title:recruitTitleArr[i] content:recruitContentArr[i]];
                if (i!=recruitContentArr.count-1&&![recruitContentArr[i] isEqualToString:@""]) {
                    [self addSubview:itemView];
                    recruitAllLastView = itemView;
                }
            }
           
        }
        //任职要求
        if (recruitModel.requstString.length) {
            NSString * briefStr = [NSString stringWithFormat:@"任职要求: %@",recruitModel.requstString];
            CGSize size = [briefStr getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH-2*kHEIGHT(12)];
            UILabel * produceLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), recruitAllLastView.bottom+2*kListEdge, SCREEN_WIDTH-2*kHEIGHT(12), size.height)];
            produceLabel.numberOfLines = 0;
//            produceLabel.backgroundColor = [UIColor greenColor];
            produceLabel.text = briefStr;
            UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, recruitAllLastView.bottom, SCREEN_WIDTH, size.height+4*kListEdge)];//kHEIGHT(12)
            backView.backgroundColor = [UIColor whiteColor];
            [self addSubview:backView];
            [self addSubview:produceLabel];
            recruitAllLastView = backView;
        }
//        NearShowCell *cell = [[NearShowCell alloc]init];
//        cell.btnDelete.hidden = YES;
//        cell.btnUp.hidden = YES;
//        cell.btnDown.hidden = YES;
//        CGFloat height = [self getTextCellHeight:recruitModel.requireString];
//        cell.attributedString = recruitModel.requireString;
//        //CGFloat top = lastTwoView?lastTwoView.bottom:lastView.bottom;
//        cell.frame = CGRectMake(0, recruitLastView.bottom+kListEdge, SCREEN_WIDTH, height);
//        cell.backgroundColor = [UIColor whiteColor];
//        [cell.textShow setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH-20];
//        if (recruitModel.requireString) {
//            [self addSubview:cell];
//            recruitAllLastView = cell;
//        }
    }
    
    if (self.isAddShare) {
         CGFloat shareTop =recruitAllLastView?recruitAllLastView.bottom+kListEdge:(recruitLastView?recruitLastView.bottom+kListEdge:lastView.bottom+kListEdge);
        self.contentSize = CGSizeMake(SCREEN_WIDTH, shareTop);
    }
    else
    {
        CGFloat shareTop =recruitAllLastView?recruitAllLastView.bottom+kListEdge:(recruitLastView?recruitLastView.bottom+kListEdge:lastView.bottom+kListEdge);
        _share = [[SPShareView alloc]initWithFrame:CGRectMake(0, shareTop, SCREEN_WIDTH, ItemViewHeight)];
        __weak typeof(self) weakSelf = self;
        _share.publicAction = ^(){
            if (weakSelf.clickOpen) {
                weakSelf.clickOpen();
            }
        
        };
        [self addSubview:_share];
        self.contentSize = CGSizeMake(SCREEN_WIDTH, _share.bottom+kListEdge);
    }
//    CGFloat shareTop =recruitAllLastView?recruitAllLastView.bottom+kListEdge:(recruitLastView?recruitLastView.bottom+kListEdge:lastView.bottom+kListEdge);
//    _share = [[SPShareView alloc]initWithFrame:CGRectMake(0, shareTop, SCREEN_WIDTH, ItemViewHeight)];
//    [self addSubview:_share];
//    self.contentSize = CGSizeMake(SCREEN_WIDTH, _share.bottom+kListEdge);
    
    
//    THLabel *company = [[THLabel alloc]initWithFrame:CGRectMake(10, imageView.height-10-15-8-20, SCREEN_WIDTH-12, 20)];
//    company.tag = TagCompany;
//    //    company.text = @"CBC服饰合肥分公司";
//    company.text = _model.listModel.enterprisePersonName;
//    company.font = GetFont(15);
//    company.textColor = [UIColor whiteColor];
//    company.shadowColor = kShadowColor1;
//    company.shadowOffset = kShadowOffset;
//    company.shadowBlur = kShadowBlur;
//    [imageView addSubview:company];
//    
//    THLabel *message = [[THLabel alloc]initWithFrame:CGRectMake(10, imageView.height-10-15, SCREEN_WIDTH-12, 15)];
//    message.tag = TagInfo;
//    //    message.text = [NSString stringWithFormat:@"%@ %@ %@",@"服装",@"个人企业",@"300-500人"];
//    message.text = [NSString stringWithFormat:@"%@ %@ %@",_model.listModel.dataIndustry,_model.listModel.enterpriseProperties,_model.listModel.enterpriseScale];
//    message.font = GetFont(12);
//    message.textColor = [UIColor whiteColor];
//    message.shadowColor = kShadowColor1;
//    message.shadowOffset = kShadowOffset;
//    message.shadowBlur = kShadowBlur;
//    [imageView addSubview:message];
//    
//    [self addSubview:self.photosView];
//    
//    SPTitleItem *item1 = [[SPTitleItem alloc]initWithTop:self.photosView.bottom+10 title:@"企业信息"];
//    [self addSubview:item1];
//    
//    UILabel *label0 = [[UILabel alloc]initWithFrame:CGRectMake(0, item1.bottom, SCREEN_WIDTH, 43)];
//    label0.backgroundColor = [UIColor whiteColor];
//    [self addSubview:label0];
//    
//    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, item1.bottom, SCREEN_WIDTH-20, 43)];
//    //    companyLabel.text = @"CBC服饰合肥分公司";
//    companyLabel.text = _model.listModel.enterpriseName;
//    companyLabel.backgroundColor = [UIColor whiteColor];
//    [self addSubview:companyLabel];
//    
//    SPItemPreview3 *industryItem = [[SPItemPreview3 alloc]initWithTop:companyLabel.bottom title:@"企业行业:" content:_model.listModel.dataIndustry];
//    [self addSubview:industryItem];
//    
//    SPItemPreview3 *typeItem = [[SPItemPreview3 alloc]initWithTop:industryItem.bottom title:@"企业性质:" content:_model.listModel.enterpriseProperties];
//    [self addSubview:typeItem];
//    
//    SPItemPreview3 *scaleItem = [[SPItemPreview3 alloc]initWithTop:typeItem.bottom title:@"企业规模:" content:_model.listModel.enterpriseScale];
//    [self addSubview:scaleItem];
//    
//    
//    NSString *str = [_model.listModel.enterpriseBrief replaceReturn];
//    SPItemPreview3 *briefItem = [[SPItemPreview3 alloc]initWithTop:scaleItem.bottom title:@"企业简介:" content:str];
//    [self addSubview:briefItem];
//    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, briefItem.bottom, SCREEN_WIDTH, 16)];
//    label.backgroundColor = [UIColor whiteColor];
//    [self addSubview:label];
//    
//    CGFloat top = label.bottom+6;
//    for (int i = 0; i<_model.recruitResumeArr.count; i++) {
//        if (i!=0) {
//            top += [SPRecSubview returnHeight:_model.recruitResumeArr[i-1]]+6;
//        }
//        NSString *title = [NSString stringWithFormat:@"招聘信息%d",i+1];
//        SPRecSubview *recView = [[SPRecSubview alloc]initWithTop:top title:title Model:_model.recruitResumeArr[i]];
//        CGFloat height = [SPRecSubview returnHeight:_model.recruitResumeArr[i]];
//        recView.frame = CGRectMake(0, top, SCREEN_WIDTH, height);
//        [self addSubview:recView];
//    }
//    
//    CGFloat contentHeight = label.bottom+6+_model.recruitResumeArr.count*6;
//    for (int i = 0; i < _model.recruitResumeArr.count; i++) {
//        contentHeight += [SPRecSubview returnHeight:_model.recruitResumeArr[i]];
//    }
//    
//    SPShareView *shareView = [[SPShareView alloc]initWithFrame:CGRectMake(0, contentHeight, SCREEN_WIDTH, 43)];
//    shareView.isAllowEdit = NO;
//    shareView.selectedArr = self.shareArr;
//    [self addSubview:shareView];
//    self.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight+43+6);
}

-(UIScrollView *)photosView
{
    if (!_photosView) {
        _photosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH-28, PhotoViewHeight)];
        _photosView.backgroundColor = [UIColor whiteColor];
        _photosView.showsHorizontalScrollIndicator = NO;
    
        /**< 照片墙翻页 */
//        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-30, _photosView.top, 30, PhotoViewHeight) ImageName:@"common_icon_arrow" Target:self Action:@selector(recuilistTagClick:)];
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-28, _photosView.top, 28, PhotoViewHeight) ImageName:@"jinru" Target:self Action:@selector(recuilistTagClick:)];
        scrollBtn.backgroundColor = [UIColor whiteColor];
        scrollBtn.tag = TagShowAllPhotos;
        [self addSubview:scrollBtn];
        
        [self updatePhotosView];
    }
    return _photosView;
}

-(void)updatePhotosView
{
    for (UIView *view in self.photosView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < _model.photosArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
        button.tag = TagPhoto+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        if ([_model.photosArr[i] isKindOfClass:[SPPhotoAsset class]]) {
            [button setImage:[_model.photosArr[i] thumbImage] forState:UIControlStateNormal];
        }else{
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_model.photosArr[i] thumb_path]]];
            [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.photosView addSubview:button];
    }
    
    CGFloat width = _model.photosArr.count*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12);
    for (int i = 0; i < _model.videosArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+kHEIGHT(6))+width, 10, PhotoHeight, PhotoHeight);
        button.tag = TagVideo+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([_model.videosArr[i] isKindOfClass:[NSString class]]) {
            [button setImage:[UIImage getImage:_model.videosArr[i]] forState:UIControlStateNormal];
        }else if([_model.videosArr[i] isKindOfClass:[ALAsset class]]){
            ALAsset *asset = _model.videosArr[i];
            [button setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
        }else{
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_model.videosArr[i] thumb_path]]];
            [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        }
        [self.photosView addSubview:button];
        
        UIImageView *subImageV = [[UIImageView alloc]initWithFrame:CGRectMake(PhotoHeight/2-10, PhotoHeight/2-10, 20, 20)];
        subImageV.image = [UIImage imageNamed:@"video_play"];
        [button addSubview:subImageV];
    }
    
    self.photosView.contentSize = CGSizeMake((_model.videosArr.count + _model.photosArr.count)*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), PhotoViewHeight);
//    }else{
//        NSInteger count = self.photosArr.count+self.videosArr.count;
//        self.photosView.contentSize = CGSizeMake(count*(PhotoHeight+6)+PhotoHeight+10, PhotoViewHeight);
//    }
}

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
    
    if (sender.tag>=TagPhoto &&sender.tag <TagVideo) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < _model.photosArr.count; i++) {/**< 头像或背景图 */
            MJPhoto *photo = [[MJPhoto alloc]init];
            //            photo.image = [self.photosArr[i] originImage];
            if ([_model.photosArr[i] isKindOfClass:[SPPhotoAsset class]]) {
                photo.image = [_model.photosArr[i] originImage];
            }else{
                photo.url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[_model.photosArr[i] thumb_path]]];
            }
            
            photo.srcImageView = [(UIButton *)[self viewWithTag:TagPhoto+i] imageView];
            [arr addObject:photo];
        }
        MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
        brower.currentPhotoIndex = sender.tag-TagPhoto;
        brower.photos = arr;
        [brower show];
    }else{
        if (self.checkVideosBlock) {
            self.checkVideosBlock(sender.tag-TagVideo);
        }
    }
}

-(void)recuilistTagClick:(UIButton *)sender
{
    if (self.checkAllVideosBlock) {
        self.checkAllVideosBlock();
    }
}

@end
