//
//  UIImage+ImageType.m
//  ShopStore
//
//  Created by Spyer on 15/3/18.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "UIImage+ImageType.h"
#import "NSString+StringType.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@implementation UIImage (ImageType)

//随机生成图片字符串名称
+ (NSString *)generateUuidString
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // transfer ownership of the string
    // to the autorelease pool
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}

#pragma mark - 保存图片至沙盒
+ (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImagePNGRepresentation(currentImage);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

+ (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 0.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 1000;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView.layer addAnimation:animation forKey:nil];
    return imageView;
}

#pragma mark-缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

+ (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)toSize{
//    // 创建一个bitmap的context
//    // 并把它设置成为当前正在使用的context
//    UIGraphicsBeginImageContext(size);
//    // 绘制改变大小的图片
//    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    // 从当前context中创建一个改变大小后的图片
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    // 使当前的context出堆栈
//    UIGraphicsEndImageContext();
//    // 返回新的改变大小后的图片
//    return scaledImage;
    
    int toWidth = toSize.width;
    int toHeight = toSize.height;
    int width= image.size.width;
    int height=image.size.height;
    int x=(width-toWidth)/2;
    int y=(height-toHeight)/2;
    
//    if (image.size.width<toWidth)
//    {
//        width = toWidth;
//        height = image.size.height*(toWidth/image.size.width);
//        y = (height - toHeight)/2;
//    }
//    else if (image.size.height<toHeight)
//    {
//        height = toHeight;
//        width = image.size.width*(toHeight/image.size.height);
//        x = (width - toWidth)/2;
//    }
//    else if (image.size.width>toWidth)
//    {
//        width = toWidth;
//        height = image.size.height*(toWidth/image.size.width);
//        y = (height - toHeight)/2;
//    }
//    else if (image.size.height>toHeight)
//    {
//        height = toHeight;
//        width = image.size.width*(toHeight/image.size.height);
//        x = (width - toWidth)/2;
//    }
//    else
//    {
//        height = toHeight;
//        width = toWidth;
//    }
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize subImageSize = CGSizeMake(toWidth, toHeight);
    CGRect subImageRect = CGRectMake(x, y, toWidth, toHeight);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return subImage;
}

#pragma mark-等比缩放成指定宽度或者高度的图片
+(CGSize)scaleWithImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height
{
    CGSize oldSize = image.size;
    CGSize newSize;
    if (0 == width && 0 != height) {
        
        newSize.height = height;
        newSize.width = newSize.height*oldSize.width/oldSize.height;
    }
    if (0 == height && 0 != width) {
        newSize.width = width;
        newSize.height = newSize.width*oldSize.height/oldSize.width;
    }
    
    return newSize;
}

+(UIImageView *)createUIImageViewWithOrignalX:(CGFloat)orignalX OrignalY:(CGFloat)orignalY Width:(CGFloat)width Height:(CGFloat)height BackgroundColor:(UIColor *)backgroundColor ImageName:(NSString *)imageName
{
    if (backgroundColor == nil) {
        backgroundColor = [UIColor clearColor];
    }
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(orignalX, orignalY, width, height);
    imageView.backgroundColor = backgroundColor;
    if (imageName != nil) {
        if ([imageName hasPrefix:@"http"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
        }else{
            imageView.image = [UIImage imageNamed:imageName];
        }
    }
    return imageView;
}

+(UIImageView *)createUIImageViewWithFrame:(CGRect)frame BackgroundColor:(UIColor *)backgroundColor ImageName:(NSString *)imageName
{
    if (backgroundColor == nil) {
        backgroundColor = [UIColor clearColor];
    }
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = frame;
    imageView.backgroundColor = backgroundColor;
    if (imageName != nil) {
        if ([imageName hasPrefix:@"http"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
        }else{
            imageView.image = [UIImage imageNamed:imageName];
        }
    }
    return imageView;
}
+(UIImage*)creatUIImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

// 获取本地视频的缩略图
+(UIImage *)getImage:(NSString *)videoURL

{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

+(UIImage *)scaleImage:(UIImage *)image toWidth:(int)toWidth toHeight:(int)toHeight{
    int width=0;
    int height=0;
    int x=0;
    int y=0;
    
    if (image.size.width<toWidth)
    {
        width = toWidth;
        height = image.size.height*(toWidth/image.size.width);
        y = (height - toHeight)/2;
    }
    else if (image.size.height<toHeight)
    {
        height = toHeight;
        width = image.size.width*(toHeight/image.size.height);
        x = (width - toWidth)/2;
    }
    else if (image.size.width>toWidth)
    {
        width = toWidth;
        height = image.size.height*(toWidth/image.size.width);
        y = (height - toHeight)/2;
    }
    else if (image.size.height>toHeight)
    {
        height = toHeight;
        width = image.size.width*(toHeight/image.size.height);
        x = (width - toWidth)/2;
    }
    else
    {
        height = toHeight;
        width = toWidth;
    }
    NSLog(@">>>>>>>>>>>%d %d",width,height);
    NSLog(@"%d %d",toWidth,toHeight);
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize subImageSize = CGSizeMake(toWidth, toHeight);
    CGRect subImageRect = CGRectMake(x, y, toWidth, toHeight);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return subImage;
}

@end
