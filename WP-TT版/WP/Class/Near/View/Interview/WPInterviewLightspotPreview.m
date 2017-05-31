//
//  WPInterviewLightspotPreview.m
//  WP
//
//  Created by CBCCBC on 15/12/21.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPInterviewLightspotPreview.h"
#import "NearShowCell.h"
#import "MLSelectPhotoAssets.h"
#import "TYAttributedLabel.h"
#import "UIImageView+WebCache.h"
#import "ActivityTextEditingController.h"
#import "WPMySecurities.h"

#define ButtonWidth ((SCREEN_WIDTH-5*ButtonEdge)/4)
#define ButtonHeight kHEIGHT(36)
#define ButtonEdge kHEIGHT(10)
@interface WPInterviewLightspotPreview ()
{
    CGFloat right;
}
@end

@implementation WPInterviewLightspotPreview

- (NSArray *)lightspotArr{
    if (!_lightspotArr) {
        _lightspotArr = [[NSArray alloc]init];
    }
    return _lightspotArr;
}

- (void)initSubview{
    
    self.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = [self.lightspotStr componentsSeparatedByString:SEPARATOR];
    CGFloat itemWidth = (SCREEN_WIDTH-ButtonEdge*5)/4;
    CGFloat itemHeight = kHEIGHT(36);
    if ([self.lightspotStr isEqualToString:@""]) {
        arr = nil;
    }
    UIView *lastview = nil;
    for (int i = 0; i < arr.count; i++) {
        CGFloat row = i/4;
        CGFloat col = i%4;
//        CGFloat x = kListEdge+col*(itemWidth+kListEdge);
//        CGFloat y = kListEdge+row*(itemHeight+kListEdge);
        CGFloat x = (col+1)*ButtonEdge+col*ButtonWidth;
        CGFloat y = (row+1)*ButtonEdge+row*ButtonHeight;
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, ButtonWidth, ButtonHeight)];//itemWidth,itemHeight
//        label.backgroundColor = RGB(0, 172, 255);
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = [UIColor whiteColor];
//        label.font = kFONT(12);
//        label.layer.cornerRadius = 5;
//        label.layer.masksToBounds = YES;
//        label.text = arr[i];
//        [self addSubview:label];
        UIButton *label = [UIButton buttonWithType:UIButtonTypeCustom];//itemWidth,itemHeight
        label.frame = CGRectMake(x, y, ButtonWidth, ButtonHeight);
        [label setBackgroundColor:RGB(0, 172, 255)];
     
        [label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        label.titleLabel.font = kFONT( 12);
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        [label setTitle:arr[i] forState:UIControlStateNormal];
        [self addSubview:label];

        lastview = label;
    }
    
    UIView * line = nil;
    if (arr.count) {
        line = [[UIView alloc]initWithFrame:CGRectMake(0, lastview.bottom+ButtonEdge-4, SCREEN_WIDTH, 8)];
        line.backgroundColor = RGB(235, 235, 235);
     [self addSubview:line];
    }
//    [self addSubview:line];
#pragma makr 添加亮点描述
    NSString *description1 = [WPMySecurities textFromBase64String:self.lightStr];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    if (description3.length) {
        self.lightStr = description3;
    }
    
    if (self.lightStr.length) {
        NSString * string = [NSString stringWithFormat:@"亮点描述：%@",self.lightStr];
//        CGSize sizeToFit = [string sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
        UILabel * lightText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        lightText.text = [NSString stringWithFormat:@"%@",string];
        lightText.font = kFONT(15);
        lightText.numberOfLines = 0;
        CGSize sizeToFit = [string getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH-2*kHEIGHT(12)];
        CGRect rect = lightText.frame;
         rect = CGRectMake(kHEIGHT(12), line.bottom+ButtonEdge/2+3+4, SCREEN_WIDTH-2*kHEIGHT(12), sizeToFit.height);
        lightText.frame = rect;
        [self addSubview:lightText];
        lastview = lightText;
        
        if (lastview.bottom+9-line.bottom<kHEIGHT(43)) {
            lightText.top = (kHEIGHT(43)-sizeToFit.height)/2+line.bottom;
        }
    }
//    lastview.backgroundColor = [UIColor redColor];
    self.contentSize = CGSizeMake(SCREEN_WIDTH, lastview.bottom-5);
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0,lastview.bottom+9+4, SCREEN_WIDTH, SCREEN_HEIGHT-lastview.bottom-49)];//8->kHEIGHT(10)
    line1.backgroundColor = RGB(235, 235, 235);
    [self addSubview:line1];
    
    if ((line1.top-line.bottom < kHEIGHT(43))&&self.lightStr.length) {
        line1.top = line.bottom+kHEIGHT(43);
        
    }
    
    
    
//    UILabel *label;
//    if (self.lightspotArr.count>0) {
//        CGSize size = [@"亮点描述:" getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH];
//        label = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(10), line.bottom+ButtonEdge, size.width, size.height)];
//        label.font = kFONT(15);
//        label.text = @"亮点描述:";
//        [self addSubview:label];
//    }
//    NSArray *heightArr = [self getCellHeight:self.lightspotArr];
//    for (int i = 0; i < self.lightspotArr.count; i++) {
//        NearShowCell *cell = [[NearShowCell alloc]init];
//        cell.btnDelete.hidden = YES;
//        cell.btnUp.hidden = YES;
//        cell.btnDown.hidden = YES;
//        
//        CGFloat height = [heightArr[i] floatValue];
//        
//        if ([self.lightspotArr[i] isKindOfClass:[NSAttributedString class]]) {
//            ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
////            editing.verifyClickBlock = ^(NSAttributedString *attributedString){
////                //                    NSLog(@"****%@",attributedString);
////                [weakSelf.objects insertObject:attributedString atIndex:index];
////                //                    NSLog(@"####%@",weakSelf.objects);
////                [weakSelf.tableView reloadData];
////                [weakSelf updateHeight];
////            };
//            cell.attributedString = self.lightspotArr[i];
//        }else{
//            cell.asset = self.lightspotArr[i];
//        }
//        CGFloat top = label.bottom;
//        if (i == 0) {
//            cell.frame = CGRectMake(label.right, label.top, SCREEN_WIDTH - label.right, height);
//        }else{
//            cell.frame = CGRectMake(0, top+ButtonEdge+(i-1)*(height+ButtonEdge), SCREEN_WIDTH, height);
//        }
//        cell.pictureShow.frame = CGRectMake(kHEIGHT(10), 0, SCREEN_WIDTH-2*kHEIGHT(10), height);
//        cell.backgroundColor = [UIColor whiteColor];
//        [cell.textShow setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
//        [self addSubview:cell];
//        
//        lastview = cell;
//    }
    
//    self.contentSize = CGSizeMake(SCREEN_WIDTH, lastview.bottom);
}

//- (NSArray *)getCellHeight:(NSArray *)array{
//    NSMutableArray *heightArr = [[NSMutableArray alloc]init];
//    for (int i = 0; i < array.count; i++) {
//        [heightArr addObject:@"0"];
//    }
//    for (int i = 0; i<array.count; i++) {
//        if ([array[i] isKindOfClass:[NSAttributedString class]]) {
//            //            return 102;
//            TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
//            [label setAttributedText:array[i]];
//            label.linesSpacing = 4;
//            label.characterSpacing = -1;
//            [label setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
//            CGFloat height;
//            CGFloat textHeight = label.frame.size.height;
//            height = textHeight;
//            //if (textHeight > 80) {
//            //height = textHeight + 22;
//            //} else {
//            //height = 102;
//            //}
//            NSString *str = [NSString stringWithFormat:@"%f",height];
//            [heightArr replaceObjectAtIndex:i withObject:str];
//            
//        }
//        if ([array[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
//            MLSelectPhotoAssets *asset = array[i];
//            ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
//            CGFloat height;
//            CGSize dimension = [representation dimensions];
//            height = ((SCREEN_WIDTH-2*kHEIGHT(10))/dimension.width)*dimension.height;
//            NSString *str = [NSString stringWithFormat:@"%f",height];
//            [heightArr replaceObjectAtIndex:i withObject:str];
//        }
//        if ([array[i] isKindOfClass:[NSString class]]) {
//            
//            /*
//            UIImageView *imageV = [UIImageView new];
//            //CGFloat height = 0;
//            //__block typeof(height) weakHeight = height;
//            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:array[i]]];
//            [imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                CGFloat weakHeight = ((SCREEN_WIDTH - 2*kHEIGHT(10))/image.size.width)*image.size.height;
//                NSString *str = [NSString stringWithFormat:@"%f",weakHeight];
//                [heightArr replaceObjectAtIndex:i withObject:str];
//                
//            }];*/
//            
//            [heightArr replaceObjectAtIndex:i withObject:@(kCellHeight)];
//        }
//    }
//    return heightArr;
//}

@end
