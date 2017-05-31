//
//  NearShowCell.m
//  WP
//
//  Created by 沈亮亮 on 15/10/14.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "NearShowCell.h"
#import "UIImageView+WebCache.h"

@implementation NearShowCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.pictureShow removeFromSuperview];
        [self.textShow removeFromSuperview];
        self.pictureShow = [[UIImageView alloc] init];
        self.textShow = [[TYAttributedLabel alloc] init];
        self.textShow.numberOfLines = 0;
        [self.contentView addSubview:self.pictureShow];
        [self.contentView addSubview:self.textShow];
        
        self.btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnDelete.frame = CGRectMake(10, 0, 22, 22);
        [self.btnDelete setImage:[UIImage imageNamed:@"near_act_delect"] forState:UIControlStateNormal];
        [self.btnDelete addTarget:self action:@selector(deleItem) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnDelete];
        
        self.btnUp = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnUp.frame = CGRectMake(SCREEN_WIDTH - 32, 0, 22, 22);
        [self.btnUp setImage:[UIImage imageNamed:@"move_up"] forState:UIControlStateNormal];
        [self.btnUp addTarget:self action:@selector(upClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnUp];
        
        self.btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnDown setImage:[UIImage imageNamed:@"move_down"] forState:UIControlStateNormal];
        [self.btnDown addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnDown];
    }
    return self;
}

//上移
- (void)upClick
{
    if (self.upClickBlock) {
        self.upClickBlock();
    }
}

//下移
- (void)downClick
{
    if (self.downClickBlock) {
        self.downClickBlock();
    }
}

//删除
- (void)deleItem
{
    if (self.deleteClickBlock) {
        self.deleteClickBlock();
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"NearShowCell";
    NearShowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
//        cell = [[NearShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell = [[NearShowCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    
//    self.textShow.frame = CGRectMake(10, 22, SCREEN_WIDTH - 20, 80);
////    self.textShow.backgroundColor = [UIColor redColor];
//    self.textShow.attributedText = attributedString;
    [self.textShow setAttributedText:attributedString];
    self.textShow.linesSpacing = 4;
    self.textShow.characterSpacing = -1;
    [self.textShow setFrameWithOrign:CGPointMake(10, 22) Width:SCREEN_WIDTH - 20];
//    self.textShow.backgroundColor = [UIColor cyanColor];
    CGFloat height = self.textShow.frame.size.height;
    if (height > 80) {
        self.btnDown.frame = CGRectMake(SCREEN_WIDTH - 32, height, 22, 22);
    } else {
        self.btnDown.frame = CGRectMake(SCREEN_WIDTH - 32, 102 - 22, 22, 22);
    }
}

- (void)setAsset:(MLSelectPhotoAssets *)asset
{

    if ([asset isKindOfClass:[MLSelectPhotoAssets class]])  // 相册图片
    {
        ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
        CGFloat height;
        CGSize dimension = [representation dimensions];
        height = ((SCREEN_WIDTH)/dimension.width)*dimension.height;
        //    NSLog(@"***%f----%f----%f",dimension.width,dimension.height,height);
        //    UIImage *image = [UIImage imageWithCGImage:representation.fullScreenImage];
        //    UIImage *newImage = [self fixOrientation:image];
        //    height = ((SCREEN_WIDTH - 20)/newImage.size.width)*newImage.size.height;
        self.pictureShow.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        //    self.pictureShow.image = newImage;
        self.btnDown.frame = CGRectMake(SCREEN_WIDTH - 32, height - 22, 22, 22);
        self.pictureShow.image = [UIImage imageWithCGImage:representation.fullScreenImage];
    }
    else if ([asset isKindOfClass:[NSString class]])    // 网页图片
    {
        
        NSString *imageUrl = [IPADDRESS stringByAppendingString:(NSString *)asset];
        
        _imageUrl = imageUrl;
        
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
        
        // 没有缓存
        if (!cachedImage)
        {
            
            __weak typeof (self) wSelf = self;
            
            [self.pictureShow sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                // 保存图片 到磁盘
                [[SDImageCache sharedImageCache] storeImage:image forKey:imageUrl toDisk:YES];
                
                if (imageUrl == self.imageUrl)  // 异步的
                {
                    [wSelf configPreviewImageViewWithImage:image];
                }
                
                if ([self.delegate respondsToSelector:@selector(reloadCellAtIndexPathWithUrl:)]) {
                    [self.delegate reloadCellAtIndexPathWithUrl:imageUrl];
                }
            }];
            
        }
        else
        {
            [self configPreviewImageViewWithImage:cachedImage];

        }
        
        
        
    }
}

/**
 * 加载图片成功后设置image's frame
 */
- (void)configPreviewImageViewWithImage:(UIImage *)image
{
    CGFloat height = ((SCREEN_WIDTH) / image.size.width) * image.size.height;
    
    self.pictureShow.frame = CGRectMake(0, 0, SCREEN_WIDTH , height);
    self.pictureShow.image = image;
    
    
    self.btnDown.frame = CGRectMake(SCREEN_WIDTH - 32, height - 22, 22, 22);

}


             
/*
- (void)setAsset:(MLSelectPhotoAssets *)asset
{
    //    self.imageView.backgroundColor = [UIColor redColor];
    if ([asset isKindOfClass:[MLSelectPhotoAssets class]])
    {
        ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
        CGFloat height;
        CGSize dimension = [representation dimensions];
        height = ((SCREEN_WIDTH)/dimension.width)*dimension.height;
        //    NSLog(@"***%f----%f----%f",dimension.width,dimension.height,height);
        //    UIImage *image = [UIImage imageWithCGImage:representation.fullScreenImage];
        //    UIImage *newImage = [self fixOrientation:image];
        //    height = ((SCREEN_WIDTH - 20)/newImage.size.width)*newImage.size.height;
        self.pictureShow.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        //    self.pictureShow.image = newImage;
        self.btnDown.frame = CGRectMake(SCREEN_WIDTH - 32, height - 22, 22, 22);
        self.pictureShow.image = [UIImage imageWithCGImage:representation.fullScreenImage];
    }
    if ([asset isKindOfClass:[NSString class]])
    {
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:(NSString *)asset]];
        
        [self.pictureShow sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            CGFloat height = ((SCREEN_WIDTH)/image.size.width)*image.size.height;
            self.pictureShow.frame = CGRectMake(0, 0, SCREEN_WIDTH , height);
            //    self.pictureShow.image = newImage;
            self.btnDown.frame = CGRectMake(SCREEN_WIDTH - 32, height - 22, 22, 22);
        }];
    }
}
*/

//将自动旋转的图片调成正确的位置
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
