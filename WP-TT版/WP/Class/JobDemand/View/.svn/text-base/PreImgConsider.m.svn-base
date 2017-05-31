//
//  PreImgConsider.m
//  WP
//
//  Created by 沈亮亮 on 15/9/10.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "PreImgConsider.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"


@implementation PreImgConsider


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.dicInfo) {
        return;
    }
    
    CGFloat width = 76;
    CGFloat line = 3;
    CGFloat x = 10;
    
    for (int i = 0; i< [self.dicInfo count]; i++) {
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.frame = CGRectMake(x + (width + line)*i, 0, width, width);
        imageV.userInteractionEnabled = YES;
        imageV.tag = i + 1;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [imageV addGestureRecognizer:tap1];
//        NSDictionary *dic = self.dicInfo[i];
        MLSelectPhotoAssets *asset = self.dicInfo[i];
//        NSString *url = [IPADDRESS stringByAppendingString:dic[@"thumb_path"]];
//        [imageV setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeImage"]];
        imageV.image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
//        imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageV];
        
    }
}

- (void)tapImage:(UITapGestureRecognizer *)tap{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.dicInfo count]];
    for (int i = 0; i<[self.dicInfo count]; i++) {
        MLSelectPhotoAssets *asset = self.dicInfo[i];
//        NSString *url = [IPADDRESS stringByAppendingString:dic[@"original_path"]];
        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString:url];
//        photo.image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
        if ([asset isKindOfClass:[UIImage class]]) {
            photo.image = (UIImage *)asset;
        } else {
            UIImage *img;
            CGFloat width = asset.asset.defaultRepresentation.dimensions.width;
            if (width <= 480) {
                img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullResolutionImage];
            } else {
                img = [UIImage imageWithCGImage:asset.asset.defaultRepresentation.fullScreenImage];
            }
            photo.image = img;
        }
      
        UIImageView *imageV = (UIImageView *)[self viewWithTag:i+1];
        photo.srcImageView = imageV;
        [photos addObject:photo];
    }
    
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    brower.currentPhotoIndex = tap.view.tag - 1;
    brower.photos = photos;
    [brower show];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
