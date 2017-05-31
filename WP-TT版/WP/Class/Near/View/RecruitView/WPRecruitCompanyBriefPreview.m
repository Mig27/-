//
//  WPRecruitCompanyBriefPreview.m
//  WP
//
//  Created by CBCCBC on 15/12/23.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPRecruitCompanyBriefPreview.h"
#import "NearShowCell.h"
#import "MLSelectPhotoAssets.h"
#import "TYAttributedLabel.h"
#import "UIImageView+WebCache.h"

@implementation WPRecruitCompanyBriefPreview

- (NSMutableArray *)array{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}

- (void)initSubViews{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *lastview = nil;
    
    NSArray *heightArr = [self getCellHeight:self.array];
    for (int i = 0; i < self.array.count; i++) {
        NearShowCell *cell = [[NearShowCell alloc]init];
        cell.btnDelete.hidden = YES;
        cell.btnUp.hidden = YES;
        cell.btnDown.hidden = YES;
        
        CGFloat height = [heightArr[i] floatValue];
        
        if ([self.array[i] isKindOfClass:[NSAttributedString class]]) {
            cell.attributedString = self.array[i];
        }else{
            cell.asset = self.array[i];
        }
        CGFloat top = lastview?lastview.bottom:0;
        cell.frame = CGRectMake(0, top+kListEdge, SCREEN_WIDTH, height);
        cell.pictureShow.frame = CGRectMake(kHEIGHT(10), 0, SCREEN_WIDTH-2*kHEIGHT(10), height);
        cell.backgroundColor = [UIColor whiteColor];
        [cell.textShow setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
        [self addSubview:cell];
        
        lastview = cell;
    }
    
    self.contentSize = CGSizeMake(SCREEN_WIDTH, lastview.bottom);
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
            height = ((SCREEN_WIDTH-2*kHEIGHT(10))/dimension.width)*dimension.height;
            NSString *str = [NSString stringWithFormat:@"%f",height];
            [heightArr replaceObjectAtIndex:i withObject:str];
        }
        if ([array[i] isKindOfClass:[NSString class]]) {
            UIImageView *imageV = [UIImageView new];
            //CGFloat height = 0;
            //__block typeof(height) weakHeight = height;
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:array[i]]];
            [imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGFloat weakHeight = ((SCREEN_WIDTH - 2*kHEIGHT(10))/image.size.width)*image.size.height;
                NSString *str = [NSString stringWithFormat:@"%f",weakHeight];
                [heightArr replaceObjectAtIndex:i withObject:str];
                
            }];
        }
    }
    return heightArr;
}

@end
