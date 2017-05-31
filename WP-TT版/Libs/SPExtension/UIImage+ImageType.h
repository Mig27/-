//
//  UIImage+ImageType.h
//  ShopStore
//
//  Created by Spyer on 15/3/18.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageType)

+(NSString *)generateUuidString;
/** 保存图片到沙盒中*/
+ (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName;
/** 图片旋转*/
+ (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView;
/**吧图片缩放至指定大小*/
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
/**吧图片缩放至指定大小*/
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
/**图片缩放至指定宽度或高度的大小*/
+(CGSize)scaleWithImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height;

/**创建图片或者背景色的ImageView*/
+(UIImageView *)createUIImageViewWithOrignalX:(CGFloat)orignalX OrignalY:(CGFloat)orignalY Width:(CGFloat)width Height:(CGFloat)height BackgroundColor:(UIColor *)backgroundColor ImageName:(NSString *)imageName;
/**创建图片或者背景色的ImageView*/
+(UIImageView *)createUIImageViewWithFrame:(CGRect)frame BackgroundColor:(UIColor *)backgroundColor ImageName:(NSString *)imageName;

+(UIImage*)creatUIImageWithColor:(UIColor*)color;

/**获取本地视频的缩略图*/
+(UIImage *)getImage:(NSString *)videoURL;

+(UIImage *)scaleImage:(UIImage *)image toWidth:(int)toWidth toHeight:(int)toHeight;

@end
