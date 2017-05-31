//
//  WPInterviewWorkPreview.m
//  WP
//
//  Created by CBCCBC on 15/12/22.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPInterviewWorkPreview.h"
#import "SPItemPreview.h"
#import "WPMySecurities.h"
#import "NearShowCell.h"
#import "MLSelectPhotoAssets.h"
#import "TYAttributedLabel.h"
#import "UIImageView+WebCache.h"

@implementation WPInterviewWorkPreview

- (void)setModel:(Work *)model
{
    _model = model;
    
    self.backgroundColor = [UIColor whiteColor];
    
    NSArray *title = @[@"企业名称:",@"入职时间:",@"离职时间:",@"企业行业:",@"企业性质:",@"职位名称",@"薪资待遇"];
    NSArray *arr = @[model.epName,model.beginTime,model.endTime,model.industry,model.epProperties,model.position,model.salary];
    
    UIView *lastview = nil;
    for (int i = 0; i<title.count; i++) {
        CGFloat top = lastview ? lastview.bottom : 0;
        SPItemPreview *item = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight) title:title[i] content:arr[i]];
        
        // 内容不空，才显示
        if (![arr[i] isEqualToString:@""]) {
            [self addSubview:item];
            
            lastview = item;
        }
    }
    
    //添加职位描述
    //添加专业描述
    NSString * string = [NSString stringWithFormat:@"%@",self.model.workStr];
    if (self.workStr.length)
    {
        
    }
    else
    {
        if (string.length && ![string isEqualToString:@"(null)"])
        {
            self.workStr = [NSMutableString stringWithString:string];
        }
    }
    NSString *description1 = [WPMySecurities textFromBase64String:self.workStr];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    if (description3.length) {
        self.workStr = description3;
    }
    
    if (self.workStr.length) {
        NSString * string = [NSString stringWithFormat:@"职位描述 : %@",self.workStr];
        //        CGSize sizeToFit = [string sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
        UITextView * lightText = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        lightText.text = [NSString stringWithFormat:@"%@",string];
        lightText.font = kFONT(15);
        //                lightText.backgroundColor = [UIColor redColor];
        lightText.editable = NO;
        lightText.scrollEnabled = NO;
        //计算文本高度
        CGSize sizeToFit = [string sizeWithFont:kFONT(15) constrainedToSize:CGSizeMake(SCREEN_WIDTH-16, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect rect = lightText.frame;
        rect = CGRectMake(8, lastview.bottom+kListEdge/2+4, SCREEN_WIDTH-16, sizeToFit.height+16);
        lightText.frame = rect;
        [self addSubview:lightText];
        lastview = lightText;
    }
    self.contentSize = CGSizeMake(SCREEN_WIDTH, lastview.bottom);
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0,lastview.bottom+4, SCREEN_WIDTH, SCREEN_HEIGHT-lastview.bottom-49)];
    line1.backgroundColor = RGB(235, 235, 235);
    [self addSubview:line1];
//    NSArray *heightArr = [self getCellHeight:model.expList];
//    for (int i = 0; i < model.expList.count; i++) {
//        NearShowCell *cell = [[NearShowCell alloc]init];
//        cell.btnDelete.hidden = YES;
//        cell.btnUp.hidden = YES;
//        cell.btnDown.hidden = YES;
//        
//        CGFloat height = [heightArr[i] floatValue];
//        NSLog(@"height:%zd", height);
//        
//        if ([model.expList[i] isKindOfClass:[NSAttributedString class]]) {
//            cell.attributedString = model.expList[i];
//        }else{
//            cell.asset = model.expList[i];
//        }
//        CGFloat top = lastview.bottom;
//        cell.frame = CGRectMake(0, top+kListEdge, SCREEN_WIDTH, height);
//        cell.pictureShow.frame = CGRectMake(kHEIGHT(10), 0, SCREEN_WIDTH-2*kHEIGHT(10), height);
//        cell.backgroundColor = [UIColor whiteColor];
//        [cell.textShow setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
//        [self addSubview:cell];
//        
//        lastview = cell;
//    }
    
//    self.contentSize = CGSizeMake(SCREEN_WIDTH, lastview.bottom);
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
        else if ([array[i] isKindOfClass:[MLSelectPhotoAssets class]])
        {
            MLSelectPhotoAssets *asset = array[i];
            ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
            CGFloat height;
            CGSize dimension = [representation dimensions];
            height = ((SCREEN_WIDTH-kHEIGHT(10))/dimension.width)*dimension.height;
            NSString *str = [NSString stringWithFormat:@"%f",height];
            [heightArr replaceObjectAtIndex:i withObject:str];
        }
        else if ([array[i] isKindOfClass:[NSString class]])
        {
            /*
            UIImageView *imageV = [UIImageView new];
            CGFloat height = 0;
            __block typeof(height) weakHeight = height;
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:array[i]]];
            [imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGFloat weakHeight = ((SCREEN_WIDTH - kHEIGHT(10))/image.size.width)*image.size.height;
                NSString *str = [NSString stringWithFormat:@"%f",weakHeight];
                [heightArr replaceObjectAtIndex:i withObject:str];
            }];*/
            
            
            [heightArr replaceObjectAtIndex:i withObject:@(kCellHeight)];
        }
    }
    return heightArr;
}


- (void)update
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
        
        [self setNeedsDisplay];
    });
    

}


@end
