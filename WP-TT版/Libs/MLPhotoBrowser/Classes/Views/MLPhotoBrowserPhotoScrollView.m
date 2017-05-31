//
//  MLPhotoBrowserPhotoScrollView.m
//  MLPhotoBrowser
//
//  Created by 张磊 on 14-11-14.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "MLPhotoBrowserPhotoScrollView.h"
#import "MLPhotoBrowserDatas.h"
#import "DACircularProgressView.h"
#import "UIImageView+WebCache.h"
#import "WPHttpTool.h"
#import "HJCActionSheet.h"
#import "CollectViewController.h"
#import "ReportViewController.h"
#import "MTTPhotosCache.h"
#import "WPDownLoadVideo.h"
#define iOS7gt ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 进度条的宽度/高度
static NSInteger const ZLPickerProgressViewW = 50;
static NSInteger const ZLPickerProgressViewH = 50;

// Private methods and properties
@interface MLPhotoBrowserPhotoScrollView ()<UIActionSheetDelegate,HJCActionSheetDelegate> {
    MLPhotoBrowserPhotoView *_tapView; // for background taps
    NSString *_wp_speak_click_type;
}

@property (assign,nonatomic) CGFloat progress;
// 加载完成
@property (strong,nonatomic) MLPhotoBrowserPhotoImageView *photoImageView;
@property (assign,nonatomic) BOOL isLoadingDone;
@property (strong,nonatomic) DACircularProgressView *progressView;

@end

@implementation MLPhotoBrowserPhotoScrollView

- (id)init{
    if ((self = [super init])) {
        
        // Setup
        // Tap view for background
        _tapView = [[MLPhotoBrowserPhotoView alloc] initWithFrame:self.bounds];
        _tapView.tapDelegate = self;
        _tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tapView.backgroundColor = [UIColor blackColor];
        [self addSubview:_tapView];
        
        // Image view
        _photoImageView = [[MLPhotoBrowserPhotoImageView alloc] initWithFrame:CGRectZero];
        _photoImageView.tapDelegate = self;
        _photoImageView.contentMode = UIViewContentModeCenter;
        _photoImageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_photoImageView];
        
        // Setup
        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
        [self addGestureRecognizer:longGesture];
     
        DACircularProgressView *progressView = [[DACircularProgressView alloc] init];
        progressView.hidden = YES;
        progressView.frame = CGRectMake(0, 0, ZLPickerProgressViewW, ZLPickerProgressViewH);
        progressView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
        progressView.roundedCorners = YES;
        if (iOS7gt) {
            progressView.thicknessRatio = 0.1;
            progressView.roundedCorners = NO;
        } else {
            progressView.thicknessRatio = 0.2;
            progressView.roundedCorners = YES;
        }
        
        [self addSubview:progressView];
        self.progressView = progressView;
    }
    return self;
}

- (void)longGesture:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
//        if (!self.sheet) {
//            self.sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到相册" otherButtonTitles:nil, nil];
//        }
//
//        [self.sheet showInView:self];
        
        if (self.hideCollection) {
            HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"发送给好友", @"保存图片", nil];//,@"举报"
            // 2.显示出来
            [sheet show];
        }
        else
        {
            HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"发送给好友", @"保存图片",@"收藏", nil];//,@"举报"
            // 2.显示出来
            [sheet show];
        }
        
//        HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"发送给朋友", @"保存图片",@"收藏", nil];//,@"举报"
//        // 2.显示出来
//        [sheet show];
    }
}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 0){
//        if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
//            UIImageWriteToSavedPhotosAlbum(_photoImageView.image, nil, nil, nil);
//            if (_photoImageView.image) {
//                [self showMessageWithText:@"保存成功"];
//            }
//        }else{
//            if (_photoImageView.image) {
//                [self showMessageWithText:@"没有用户权限,保存失败"];
//            }
//        }
//    }
//}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {//发送给朋友
//        [self disMissTap:nil];
//        [self performSelector:@selector(delayPush) withObject:nil afterDelay:0.2];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SENDIMAGETOWEIPINFRIENDS" object:nil userInfo:@{@"info":self.photo}];
        
    } else if (buttonIndex == 2) {
        NSLog(@"保存图片");
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            //            MJPhoto *photo = _photos[_currentPhotoIndex];
//            UIImageWriteToSavedPhotosAlbum(_photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        });
        if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImageWriteToSavedPhotosAlbum(_photoImageView.image, nil, nil, nil);
            if (_photoImageView.image) {
                [self showMessageWithText:@"保存成功"];
            }
        }else{
            if (_photoImageView.image) {
                [self showMessageWithText:@"没有用户权限,保存失败"];
            }
        }
    } else if (buttonIndex == 3) {
        NSLog(@"收藏");
//        _wp_speak_click_type = @"3";
//        [self collectOrReport];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SpecialImgCollect" object:nil userInfo:@{@"info" : self.photo}];
    } else if (buttonIndex == 4) {
        NSLog(@"举报");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SpecialImgRoport" object:nil userInfo:@{@"info" : self.photo}];
//        _wp_speak_click_type = @"4";
//        [self collectOrReport];
    }
}

#pragma mark - 获取view所在的控制器
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
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


- (void)showMessageWithText:(NSString *)text{
    UILabel *alertLabel = [[UILabel alloc] init];
    alertLabel.font = [UIFont systemFontOfSize:15];
    alertLabel.text = text;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.layer.masksToBounds = YES;
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.bounds = CGRectMake(0, 0, 100, 80);
    alertLabel.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    alertLabel.backgroundColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1.0];
    alertLabel.layer.cornerRadius = 10.0f;
    [[UIApplication sharedApplication].keyWindow addSubview:alertLabel];
    
    [UIView animateWithDuration:.5 animations:^{
        alertLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        [alertLabel removeFromSuperview];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)hideMain:(NSString*)string
{
 [[NSNotificationCenter defaultCenter] postNotificationName:@"loadImageSuccess" object:[NSString stringWithFormat:@"%@",string]];
}
- (void)setPhoto:(MLPhotoBrowserPhoto *)photo{
    _photo = photo;
    _photoImageView.image = nil;
    _photoImageView.frame = CGRectMake(0, 0, 0, 0);
    __weak typeof(self) weakSelf = self;
    if (photo.photoURL.absoluteString.length) {
        // 本地相册
        NSRange photoRange = [photo.photoURL.absoluteString rangeOfString:@"assets-library"];
        if (photoRange.location != NSNotFound)
        {
            [[MLPhotoBrowserDatas defaultPicker] getAssetsPhotoWithURL:photo.photoURL callBack:^(UIImage *obj) {
                weakSelf.isLoadingDone = YES;
                weakSelf.photoImageView.image = obj;
                [weakSelf displayImage];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loadImageSuccess" object:[NSString stringWithFormat:@"%@",photo.photoURL]];
            }];
        }
        else
        {
            //没有网络发送图片失败时点击从本地获取图片
            if (![[NSString stringWithFormat:@"%@",photo.photoURL] hasPrefix:@"http"] ) {
                NSData* data = [[MTTPhotosCache sharedPhotoCache] photoFromDiskCacheForKey:[NSString stringWithFormat:@"%@",photo.photoURL]];
                UIImage *image = [[UIImage alloc] initWithData:data];
                [_photoImageView setImage:image];
                 [self displayImage];
                return;
            }
            
            //本地文件中是否有图片
            NSArray * array = [[NSString stringWithFormat:@"%@",photo.photoURL] componentsSeparatedByString:@"/"];
            NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:pictureAddress];
            NSString * fileName = [NSString stringWithFormat:@"%@/%@",savePath,array[array.count-1]];
            NSData * imageData = [NSData dataWithContentsOfFile:fileName];
            if (imageData) {
                UIImage * image = [[UIImage alloc]initWithData:imageData];
                _photoImageView.image = image;
                self.isLoadingDone = YES;
                [weakSelf displayImage];
                
//                [self performSelector:@selector(hideMain:) withObject:photo.photoURL afterDelay:2.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loadImageSuccess" object:[NSString stringWithFormat:@"%@",photo.photoURL]];
                return;
            }
            
            
            
            UIImage *thumbImage = photo.thumbImage;
            if (thumbImage == nil) {
                thumbImage = _photoImageView.image;
                
                NSString * urlStr = [[NSString alloc]initWithFormat:@"%@",photo.photoURL];
                NSArray * array = [urlStr componentsSeparatedByString:@"/"];
                NSMutableArray * muarray = [NSMutableArray array];
                [muarray addObjectsFromArray:array];
                NSString * lastStr = array[array.count-1];
                lastStr = [@"thumbd_" stringByAppendingString:lastStr];
                NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:pictureAddress];
                NSString * fileName = [NSString stringWithFormat:@"%@/%@",savePath,lastStr];
                NSData * data = [NSData dataWithContentsOfFile:fileName];
                
                
                if (data) {
                    _photoImageView.image = [UIImage imageWithData:data];
//                    [self displayImage];
                }
                
            }else{
                _photoImageView.image = thumbImage;
            }
            _photoImageView.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeScaleAspectFit
            _photoImageView.frame = [self setPreFrame:[NSString stringWithFormat:@"%@",photo.photoURL]];
            weakSelf.progress = 0.01;
            //网络URL//thumbImage
            WPDownLoadVideo* down = [[WPDownLoadVideo alloc]init];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [down downLoadImage:[NSString stringWithFormat:@"%@",photo.photoURL] success:^(id response){
                    dispatch_async(dispatch_get_main_queue(), ^{
                       NSData * data = (NSData*)response;
                        UIImage * image = [UIImage imageWithData:data];
                        self.progress = 1;
                        if (image != nil) {
                            _photoImageView.image = image;
                            self.isLoadingDone = YES;
                            //                    _photoImageView.image = image;
                            [weakSelf displayImage];
                            [self savePhotoToLocal:image andString:[NSString stringWithFormat:@"%@",photo.photoURL]];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadImageSuccess" object:[NSString stringWithFormat:@"%@",photo.photoURL]];
                        }
                        else//未请求到图片
                        {
                            [MBProgressHUD createHUD:@"获取图片失败" View:self];
                            self.isLoadingDone = YES;
                            _photoImageView.image = [UIImage imageNamed:@"placeImage"];
                            [weakSelf displayImage];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadImageSuccess" object:[NSString stringWithFormat:@"%@",photo.photoURL]];
                        }
                    });
                } failed:^(NSError *error) {
                    [MBProgressHUD createHUD:@"获取图片失败" View:self];
                    self.isLoadingDone = YES;
//                    _photoImageView.image = [UIImage imageNamed:@"placeImage"];
                    [weakSelf displayImage];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadImageSuccess" object:nil];
                }];
            });
            
           
            
//            [_photoImageView sd_setImageWithURL:photo.photoURL placeholderImage:thumbImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                self.progress = (double)receivedSize / expectedSize;
//            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                self.progress = 1;
//                if (image != nil) {
//                    self.isLoadingDone = YES;
////                    _photoImageView.image = image;
//                     [weakSelf displayImage];
//                    [self savePhotoToLocal:image andString:[NSString stringWithFormat:@"%@",photo.photoURL]];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadImageSuccess" object:nil];
//                }
//                else//未请求到图片
//                {
//                    [MBProgressHUD createHUD:@"获取图片失败" View:self];
//                    self.isLoadingDone = YES;
//                     _photoImageView.image = [UIImage imageNamed:@"placeImage"];
//                    [weakSelf displayImage];
//                  [[NSNotificationCenter defaultCenter] postNotificationName:@"loadImageSuccess" object:nil];
//                }
//            }];
        }
    }  else if (photo.photoImage){
        self.isLoadingDone = YES;
        _photoImageView.image = photo.photoImage;
        [self displayImage];
    }
}
//将图片保存到本地
-(void)savePhotoToLocal:(UIImage*)image andString:(NSString*)urlStr
{
    NSArray * array = [urlStr componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:pictureAddress];
    NSFileManager * manger = [NSFileManager defaultManager];
    if (![manger fileExistsAtPath:savePath])
    {
        [manger createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString * fileName = [NSString stringWithFormat:@"%@/%@",savePath,array[array.count-1]];
    NSData*data = UIImageJPEGRepresentation(image, 1.0);
    [data writeToFile:fileName atomically:YES];
}



-(CGRect)setPreFrame:(NSString *)imageStr
{
    
    NSArray * array = [imageStr componentsSeparatedByString:@"_"];
    NSString * widthStr = [NSString stringWithFormat:@"%@",array[1]];
    NSString * secondStr = [NSString stringWithFormat:@"%@",array[2]];
    NSArray * array1 = [secondStr componentsSeparatedByString:@"_"];
    NSString * heightStr = [NSString stringWithFormat:@"%@",array1[0]];
    CGSize size = CGSizeMake(widthStr.floatValue, heightStr.floatValue);
    
    
    CGSize boundsSize = [UIScreen mainScreen].bounds.size;
    CGSize imageSize = size;

    CGFloat xScale = boundsSize.width / imageSize.width;
    CGFloat yScale = boundsSize.height / imageSize.height;
    CGFloat minScale = MIN(xScale, yScale);
    CGFloat maxScale = MAX(xScale, yScale);
    if (xScale >= 1 && yScale >= 1) {
        minScale = MIN(xScale, yScale);
    }
    
    CGRect frameToCenter = CGRectZero;
    if (xScale >= yScale) {
        frameToCenter = CGRectMake(0, 0, imageSize.width * maxScale, imageSize.height * maxScale);
        
    }else {
        if (minScale >= 3) {
            minScale = 3;
        }
        frameToCenter = CGRectMake(0, 0, imageSize.width * minScale, imageSize.height * minScale);
    }
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
//    CGSize boundsSize = [UIScreen mainScreen].bounds.size;
//    NSArray * array = [imageStr componentsSeparatedByString:@"_"];
//    NSString * laste = array[array.count-1];
//    NSArray * lastArray = [laste componentsSeparatedByString:@"."];
//    NSString * firstStr = lastArray[0];
//    NSString * secondStr = array[array.count-2];
//    CGSize imageSize = CGSizeMake(secondStr.floatValue, firstStr.floatValue);
//    
//    if (imageSize.width == 0 && imageSize.height == 0) {
//        return CGRectMake(0, 0, secondStr.floatValue, firstStr.floatValue);
//    }
//    
//    CGFloat xScale = boundsSize.width / imageSize.width;
//    CGFloat yScale = boundsSize.height / imageSize.height;
//    CGFloat minScale = MIN(xScale, yScale);
//    CGFloat maxScale = MAX(xScale, yScale);
//    if (xScale >= 1 && yScale >= 1) {
//        minScale = MIN(xScale, yScale);
//    }
//    
//    CGRect frameToCenter = CGRectZero;
//    if (yScale >= xScale * 2.0) {
//        frameToCenter = CGRectMake(0, 0, imageSize.width * maxScale, imageSize.height * maxScale);
//    }else {
//        if (minScale >= 3) {
//            minScale = 3;
//        }
//        frameToCenter = CGRectMake(0, 0, imageSize.width * minScale, imageSize.height * minScale);
//    }
//    
//    
//    // Horizontally
//    if (frameToCenter.size.width < boundsSize.width) {
//        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
//    } else {
//        frameToCenter.origin.x = 0;
//    }
//    
//    // Vertically
//    if (frameToCenter.size.height < boundsSize.height) {
//        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
//    } else {
//        frameToCenter.origin.y = 0;
//    }
    
    NSLog(@"设置宽和高啊：%f=====%f",frameToCenter.size.width,frameToCenter.size.height);
    
    return frameToCenter;
}
- (CGRect )setMaxMinZoomScalesForCurrentBounds:(UIImageView *)imageView {
    // Sizes
    CGSize boundsSize = [UIScreen mainScreen].bounds.size;
    CGSize imageSize = imageView.image.size;
    if (imageSize.width == 0 && imageSize.height == 0) {
        return imageView.frame;
    }
    
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);
    CGFloat maxScale = MAX(xScale, yScale);
    // use minimum of these to allow the image to become fully visible
    // Image is smaller than screen so no zooming!
    if (xScale >= 1 && yScale >= 1) {
        minScale = MIN(xScale, yScale);
    }
    
    //    if (minScale >= 3) {
    //        minScale = 3;
    //    }
    
    CGRect frameToCenter = CGRectZero;
    if (yScale >= xScale * 2.0) {
       frameToCenter = CGRectMake(0, 0, imageSize.width * maxScale, imageSize.height * maxScale);
    }else {
        if (minScale >= 3) {
            minScale = 3;
        }
        frameToCenter = CGRectMake(0, 0, imageSize.width * minScale, imageSize.height * minScale);
    }
    
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}


#pragma mark - setProgress
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    self.progressView.hidden = YES;
    if (progress == 0) return ;
    if (progress / 1.0 != 1.0) {
        [self.progressView setProgress:progress animated:YES];
    }else{
//        [self.progressView removeFromSuperview];
        self.progressView = nil;
    }
}


#pragma mark - Image
// Get and display image
- (void)displayImage {
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    
    // Get image from browser as it handles ordering of fetching
    UIImage *img = _photoImageView.image;
    if (img) {
        
        // Set image
        _photoImageView.image = img;
        _photoImageView.hidden = NO;
        
        // Setup photo frame
        CGRect photoImageViewFrame;
        photoImageViewFrame.origin = CGPointZero;
        photoImageViewFrame.size = img.size;
        _photoImageView.frame = photoImageViewFrame;
        self.contentSize = photoImageViewFrame.size;

        [self setMaxMinZoomScalesForCurrentBounds];
        
    }
    [self setNeedsLayout];
}

#pragma mark - Loading Progress
#pragma mark - Setup
- (CGFloat)initialZoomScaleWithMinScale {
    CGFloat zoomScale = self.minimumZoomScale;
    if (_photoImageView) {
        // Zoom image to fill if the aspect ratios are fairly similar
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = _photoImageView.image.size;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        CGFloat xScale = boundsSize.width / imageSize.width;

        if (ABS(boundsAR - imageAR) < 0.17) {
            zoomScale = xScale;
        }
    }
    return zoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    
//    // Reset
//    self.maximumZoomScale = 1;
//    self.minimumZoomScale = 1;
//    self.zoomScale = 1;
//    
//    // Bail if no image
//    if (_photoImageView.image == nil) return;
//    
//    // Reset position
//    _photoImageView.frame = CGRectMake(0, 0, _photoImageView.frame.size.width, _photoImageView.frame.size.height);
//    
//    // Sizes
//    CGSize boundsSize = self.bounds.size;
//    CGSize imageSize = _photoImageView.image.size;
//    
//    // Calculate Min
//    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
//    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
//    
//    CGFloat minScale = MIN(xScale, yScale);
//    CGFloat maxScale = MAX(xScale, yScale);
//    // use minimum of these to allow the image to become fully visible
//    // Image is smaller than screen so no zooming!
//    if (xScale >= 1 && yScale >= 1) {
//        minScale = MIN(xScale, yScale);
//    }
//    
//    if (xScale >= yScale * 2) {
//        // Initial zoom
//        self.maximumZoomScale = 1.0;
//        self.minimumZoomScale = maxScale;
//    }else {
//        self.maximumZoomScale = yScale;
//        self.minimumZoomScale = xScale;
//    }
//    self.zoomScale = self.minimumZoomScale;
//    
//    // If we're zooming to fill then centralise
//    if (self.zoomScale != minScale) {
//        if (yScale >= xScale) {
//            self.scrollEnabled = NO;
//        }
//    }
//    
//    // Layout
//    [self setNeedsLayout];
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    // Bail if no image
    if (_photoImageView.image == nil) return;
    // Reset position
    _photoImageView.frame = CGRectMake(0, 0, _photoImageView.frame.size.width, _photoImageView.frame.size.height);
    // Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _photoImageView.image.size;
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    if (xScale <= 1.15 && yScale <= 1.15) { //当图片是满屏的时候
        // Calculate Max
        CGFloat maxScale = 3;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // Let them go a bit bigger on a bigger screen!
            maxScale = 4;
        }
        // Image is smaller than screen so no zooming!
        if (xScale >= 1 && yScale >= 1) {
            minScale = MIN(xScale, yScale);
        }
        if (minScale >= 3) {
            minScale = 1;
        }
        // Set min/max zoom
        self.maximumZoomScale = maxScale;
        self.minimumZoomScale = minScale;
        // Initial zoom
        self.zoomScale = minScale;
    } else {
        CGFloat maxScale = MAX(xScale, yScale);
        if (xScale >= 1 && yScale >= 1) {
            minScale = MIN(xScale, yScale);
        }
    
        if (xScale >= yScale * 2) {
            self.maximumZoomScale = 1.0;
            self.minimumZoomScale = maxScale;
        }else {
            self.maximumZoomScale = yScale;
            self.minimumZoomScale = xScale;
        }
        self.zoomScale = self.minimumZoomScale;
    }
    if (self.zoomScale != minScale) {
        self.contentOffset = CGPointMake((imageSize.width * self.zoomScale - boundsSize.width) / 2.0,
                                         (imageSize.height * self.zoomScale - boundsSize.height) / 2.0);
        self.scrollEnabled = NO;
    }
    [self setNeedsLayout];
}

#pragma mark - Layout

- (void)layoutSubviews {
    // Super
    [super layoutSubviews];
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _photoImageView.frame;
    
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(_photoImageView.frame, frameToCenter))
        _photoImageView.frame = frameToCenter;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _photoImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Tap Detection
- (void)handleDoubleTap:(CGPoint)touchPoint {
    // Zoom
    if (self.zoomScale != self.minimumZoomScale && self.zoomScale != [self initialZoomScaleWithMinScale]) {
        // Zoom out
        [self setZoomScale:self.minimumZoomScale animated:YES];
        self.contentSize = CGSizeMake(self.frame.size.width, _photoImageView.image.size.height * self.minimumZoomScale);
        
//        self.contentSize = CGSizeMake(self.frame.size.width, 0);
    } else {
        
        if (self.isLoadingDone) {
            // Zoom in to twice the size
            
            CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
            CGFloat xsize = self.bounds.size.width / newZoomScale;
            CGFloat ysize = self.bounds.size.height / newZoomScale;
            [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
    }
}

- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch{
    [self disMissTap:nil];
}

#pragma mark - disMissTap
- (void) disMissTap:(UITapGestureRecognizer *)tap{
    if (self.callback){
        self.callback(nil);
    }else if ([self.photoScrollViewDelegate respondsToSelector:@selector(pickerPhotoScrollViewDidSingleClick:)]) {
        [self.photoScrollViewDelegate pickerPhotoScrollViewDidSingleClick:self];
    }
}

// Image View
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch {
    [self handleDoubleTap:[touch locationInView:imageView]];
}

- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch{
    [self disMissTap:nil];
}

- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch {
    // Translate touch location to image view location
    CGFloat touchX = [touch locationInView:view].x;
    CGFloat touchY = [touch locationInView:view].y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;
    [self handleDoubleTap:CGPointMake(touchX, touchY)];
}

@end
