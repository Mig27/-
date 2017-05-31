//
//  MJZoomingScrollView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoView.h"
#import "MJPhoto.h"
#import "MJPhotoLoadingView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "SDImageCache.h"
#import "FDActionSheet.h"
#import "MBProgressHUD+MJ.h"
#import "WPHttpTool.h"
#import "WPShareModel.h"
#import "HJCActionSheet.h"

@interface MJPhotoView () <FDActionSheetDelegate,HJCActionSheetDelegate>
{
    BOOL _doubleTap;
    UIImageView *_imageView;
    MJPhotoLoadingView *_photoLoadingView;
    NSString *_wp_speak_click_type;
    BOOL chooseImagw;

}
@end

@implementation MJPhotoView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
		// 图片
		_imageView = [[UIImageView alloc] init];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_imageView];
        
        // 进度条
        _photoLoadingView = [[MJPhotoLoadingView alloc] init];
		
		// 属性
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longTap.minimumPressDuration = 0.5;
//        [self addGestureRecognizer:longTap];
    }
    return self;
}


- (void)longPress:(UILongPressGestureRecognizer *)gesture{
//    NSLog(@"长按");
    if(gesture.state == UIGestureRecognizerStateBegan){        
        HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"发送给好友", @"保存图片",@"收藏",@"举报", nil];
        // 2.显示出来
        [sheet show];

    }
}



- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        NSLog(@"发送给朋友");
    } else if (buttonIndex == 2) {
        NSLog(@"保存图片");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //            MJPhoto *photo = _photos[_currentPhotoIndex];
            UIImageWriteToSavedPhotosAlbum(_photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    } else if (buttonIndex == 3) {
        NSLog(@"收藏");
        _wp_speak_click_type = @"3";
        [self collectOrReport];
    } else if (buttonIndex == 4) {
        NSLog(@"举报");
        _wp_speak_click_type = @"4";
        [self collectOrReport];
    }
}

- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
//    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex == 0) {
        NSLog(@"发送给朋友");
    } else if (buttonIndex == 1) {
        NSLog(@"保存图片");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            MJPhoto *photo = _photos[_currentPhotoIndex];
            UIImageWriteToSavedPhotosAlbum(_photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    } else if (buttonIndex == 2) {
        NSLog(@"收藏");
        _wp_speak_click_type = @"3";
        [self collectOrReport];
    } else if (buttonIndex == 3) {
        NSLog(@"举报");
        _wp_speak_click_type = @"4";
        [self collectOrReport];
    }
}

- (void)collectOrReport
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"prise";
    params[@"speak_trends_id"] = _photo.sid;
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    //    params[@"nick_name"] = userInfo[@"nick_name"];
    //    params[@"user_id"] = @"108";
    //    params[@"nick_name"] = @"Jack";
    params[@"is_type"] = @"1";
    params[@"odd_domand_id"] = @"0";
    params[@"wp_speak_click_state"] = @"1";
//    if (sender.tag == 1) {       //收藏
//        params[@"wp_speak_click_type"] = @"3";
//    } else if (sender.tag == 2) {//举报
//        params[@"wp_speak_click_type"] = @"4";
//    } else if (sender.tag == 3) {//分享
//        params[@"wp_speak_click_type"] = @"2";
//    }
    params[@"wp_speak_click_type"] = _wp_speak_click_type;

    NSLog(@"******%@",params);
    
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/speak_manage.ashx"];
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSLog(@"json: %@",json);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:json[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } failure:^(NSError *error) {
        NSLog(@"error: %@",error);
    }];

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
//        MJPhoto *photo = _photos[_currentPhotoIndex];
        _photo.save = YES;
//        _saveImageBtn.enabled = NO;
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}


#pragma mark - photoSetter
- (void)setPhoto:(MJPhoto *)photo {
    _photo = photo;
    
    [self showImage];
}

#pragma mark 显示图片
- (void)showImage
{
//    _imageView.backgroundColor = [UIColor redColor];
    if (_photo.firstShow) { // 首次显示
        if (_photo.url) {
            _imageView.image = _photo.placeholder; // 占位图片
            _photo.srcImageView.image = nil;
            
            // 不是gif，就马上开始下载
            if (![_photo.url.absoluteString hasSuffix:@"gif"]) {
                __unsafe_unretained MJPhotoView *photoView = self;
                __unsafe_unretained MJPhoto *photo = _photo;
                [_imageView sd_setImageWithURL:_photo.url placeholderImage:_photo.placeholder options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    photo.image = image;
                    
                    // 调整frame参数
                    [photoView adjustFrame];
                }];
                //            [_imageView setImageWithURL:_photo.url placeholderImage:_photo.placeholder options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                //                photo.image = image;
                //
                //                // 调整frame参数
                //                [photoView adjustFrame];
                //            }];
            }
        }else{
            [self photoStartLoad];
        }
    } else {
        [self photoStartLoad];
    }

    // 调整frame参数
    [self adjustFrame];
}

#pragma mark 开始加载图片
- (void)photoStartLoad
{
    if (_photo.image) {
        self.scrollEnabled = YES;
        _imageView.image = _photo.image;
    } else {
        self.scrollEnabled = NO;
        // 直接显示进度条
        [_photoLoadingView showLoading];
        [self addSubview:_photoLoadingView];
        
        __unsafe_unretained MJPhotoView *photoView = self;
        __unsafe_unretained MJPhotoLoadingView *loading = _photoLoadingView;
        [_imageView sd_setImageWithURL:_photo.url placeholderImage:_photo.srcImageView.image options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize , NSInteger expectedSize) {
            if (receivedSize > kMinProgress) {
                loading.progress = (float)receivedSize/expectedSize;
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType , NSURL *imageUrl) {
            [photoView photoDidFinishLoadWithImage:image];
        }];
//        [_imageView setImageWithURL:_photo.url placeholderImage:_photo.srcImageView.image options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSUInteger receivedSize, long long expectedSize) {
//            if (receivedSize > kMinProgress) {
//                loading.progress = (float)receivedSize/expectedSize;
//            }
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//            [photoView photoDidFinishLoadWithImage:image];
//        }];
    }
}



#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
{
    if (image) {
        self.scrollEnabled = YES;
        _photo.image = image;
        [_photoLoadingView removeFromSuperview];
        
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
            [self.photoViewDelegate photoViewImageFinishLoad:self];
        }
    } else {
        [self addSubview:_photoLoadingView];
        [_photoLoadingView showFailure];
    }
    
    // 设置缩放比例
    [self adjustFrame];
}
#pragma mark 调整frame
- (void)adjustFrame
{
	if (_imageView.image == nil) return;
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
	
	// 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
	if (minScale > 1) {
		minScale = 1.0;
	}
	CGFloat maxScale = 1.0;
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		maxScale = maxScale / [[UIScreen mainScreen] scale];
	}
	self.maximumZoomScale = 3.0;
	self.minimumZoomScale = 1.0;
	self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = (boundsHeight-imageFrame.size.height)/2;// floorf((boundsHeight - imageFrame.size.height) / 2.0)
	} else {
        imageFrame.origin.y = 0;
	}
//     imageFrame.origin.y = ((SCREEN_HEIGHT-kHEIGHT(49)-kHEIGHT(64)-imageFrame.size.height) / 2.0);
    
    
    
    if (_photo.firstShow) { // 第一次显示的图片
        _photo.firstShow = NO; // 已经显示过了
        _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
        [UIView animateWithDuration:0.3 animations:^{
            _imageView.frame = imageFrame;
        } completion:^(BOOL finished) {
            // 设置底部的小图片
            _photo.srcImageView.image = _photo.placeholder;
            [self photoStartLoad];
        }];
    } else {
        _imageView.frame = imageFrame;
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGRect imageViewFrame = _imageView.frame;
    CGRect screenBounds = self.bounds;
    if (imageViewFrame.size.height >= screenBounds.size.height) {
            imageViewFrame.origin.y = 0.0f;
       
    } else {
           imageViewFrame.origin.y = floorf((screenBounds.size.height - _imageView.size.height*screenBounds.size.width/_imageView.size.width) / 2.0);
             _imageView.frame = imageViewFrame;
    }
    _imageView.frame = imageViewFrame;
}

#pragma mark - 手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = NO;
//    self.singleTapBlock();
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(handleSingleTap:)]) {
            [self.delegate respondsToSelector:@selector(handleSingleTap:)];
        }
        [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];//预览图片界面点击消失
    }
    
}
- (void)hide
{
    if (_doubleTap) return;
    
    // 移除进度条
//    [_photoLoadingView removeFromSuperview];
    self.contentOffset = CGPointZero;
    
    // 清空底部的小图
    _photo.srcImageView.image = nil;
    
    CGFloat duration = 0.15;
    if (_photo.srcImageView.clipsToBounds) {
        [self performSelector:@selector(reset) withObject:nil afterDelay:duration];
    }
    
    [UIView animateWithDuration:duration + 0.1 animations:^{
        _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
        
        // gif图片仅显示第0张
        if (_imageView.image.images) {
            _imageView.image = _imageView.image.images[0];
        }
        
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
            [self.photoViewDelegate photoViewSingleTap:self];
        }
    } completion:^(BOOL finished) {
        // 设置底部的小图片
        _photo.srcImageView.image = _photo.placeholder;
        
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidEndZoom:)]) {
            [self.photoViewDelegate photoViewDidEndZoom:self];
        }
    }];
}

- (void)reset
{
    _imageView.image = _photo.capture;
    _imageView.contentMode = UIViewContentModeScaleToFill;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = YES;
    
    CGPoint touchPoint = [tap locationInView:self];
//    
	if (self.zoomScale == self.maximumZoomScale) {
		[self setZoomScale:self.minimumZoomScale animated:YES];
//        self.contentSize = CGSizeMake(self.frame.size.width, 0);
	} else {
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 0, 0) animated:YES];
        self.contentSize = CGSizeMake(self.frame.size.width*3, _imageView.frame.size.height);
//        [self zoomToRect:CGRectMake(0, 0, touchPoint., <#CGFloat height#>) animated:<#(BOOL)#>];
	}
//    if (self.zoomScale != self.minimumZoomScale) {
//        
//        // Zoom out
//        [self setZoomScale:self.minimumZoomScale animated:YES];
//        self.contentSize = CGSizeMake(self.frame.size.width, 0);
//    } else {
//        
//        // Zoom in to twice the size
//        CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
//        CGFloat xsize = self.bounds.size.width / newZoomScale;
//        CGFloat ysize = self.bounds.size.height / newZoomScale;
//        [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
//        
//    }


}

- (void)dealloc
{
    // 取消请求
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"file:///abc"]];
}
@end
