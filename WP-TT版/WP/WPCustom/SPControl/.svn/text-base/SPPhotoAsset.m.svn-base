//
//  SPPhotoAsset.m
//  WP
//
//  Created by CBCCBC on 15/10/12.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "SPPhotoAsset.h"
#import "UIImage+ImageType.h"

@implementation SPPhotoAsset


// 缩略图
- (UIImage *)thumbImage
{
    if (self.asset) {
        return [UIImage imageWithCGImage:[self.asset thumbnail]];
    }else{
        return [UIImage thumbnailWithImageWithoutScale:self.image size:CGSizeMake(125, 125)];
    }
}

// 原图
- (UIImage *)originImage
{
    
    if (self.asset) {
        return [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
    }else{
        return self.image;
    }
}

@end
