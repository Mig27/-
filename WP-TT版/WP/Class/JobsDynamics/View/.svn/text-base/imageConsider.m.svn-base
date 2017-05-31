//
//  imageConsider.m
//  WP
//
//  Created by 沈亮亮 on 15/7/3.
//  Copyright (c) 2015年 WP. All rights reserved.
//  显示图片

#import "imageConsider.h"
#import "UIImage+MR.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "LewVideoController.h"
#import "VideoBrowser.h"
#import "RSPhotoView.h"
#import "MLPhotoBrowserAssets.h"
#import "MLPhotoBrowserViewController.h"
#import "NewDetailViewController.h"
#import "zhiChangVideo.h"
#import "ZacharyPlayManager.h"
#import "WPDownLoadVideo.h"
#import "SDDemoItemView.h"
#import "SDLoopProgressView.h"
#import "WPPhotoAndVideoController.h"
#import "WPViewShuoShuoVideo.h"
#define shuoShuoVideo @"/shuoShuoVideo"
@interface imageConsider ()<LewVideoControllerDelegate>

@property (nonatomic,strong)NSMutableArray *imageViews;
@property (nonatomic,strong)LewVideoController *videoController;
@property (nonatomic,strong)NSString *videoUrl;
@property (nonatomic,strong)UIImageView *placeImage;
@property (nonatomic, strong) UIView *longTouchView;   /**< 长按的view */
@property (nonatomic, strong)NSMutableArray * images;
@property (nonatomic, copy) NSString * fileStr;

@property (nonatomic, strong)NSMutableArray * dataAndPathArr;
@property (nonatomic, strong)UIActivityIndicatorView * activieyView;
@property (nonatomic, strong)NSProgress * videoProgress;
@property (nonatomic, strong)SDDemoItemView * videoItem;
@end

@implementation imageConsider


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        //        self.video = [[zhiChangVideo alloc]init];
        //        [self addSubview:self.video];
    }
    return self;
}
-(NSMutableArray *)images
{
    if (!_images) {
        _images = [[NSMutableArray alloc]init];
    }
    return _images;
}
-(NSMutableArray*)dataAndPathArr{
    if (!_dataAndPathArr) {
        _dataAndPathArr = [NSMutableArray array];
    }
    return _dataAndPathArr;
}
//-(zhiChangVideo*)video
//{
//    if (!_video) {
//        _video = [[zhiChangVideo alloc]init];
//    }
//    return _video;
//}


// AVFoundation 捕捉视频帧，很多时候都需要把某一帧转换成 image
//- (CGImageRef)imageFromSampleBufferRef:(CMSampleBufferRef)sampleBufferRef
//{
//    // 为媒体数据设置一个CMSampleBufferRef
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBufferRef);
//    // 锁定 pixel buffer 的基地址
//    CVPixelBufferLockBaseAddress(imageBuffer, 0);
//    // 得到 pixel buffer 的基地址
//    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
//    // 得到 pixel buffer 的行字节数
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//    // 得到 pixel buffer 的宽和高
//    size_t width = CVPixelBufferGetWidth(imageBuffer);
//    size_t height = CVPixelBufferGetHeight(imageBuffer);
//
//    // 创建一个依赖于设备的 RGB 颜色空间
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//
//    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphic context）对象
//    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    //根据这个位图 context 中的像素创建一个 Quartz image 对象
//    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
//    // 解锁 pixel buffer
//    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
//
//    // 释放 context 和颜色空间
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    // 用 Quzetz image 创建一个 UIImage 对象
//    // UIImage *image = [UIImage imageWithCGImage:quartzImage];
//
//    // 释放 Quartz image 对象
//    //    CGImageRelease(quartzImage);
//    return quartzImage;
//
//}
//-(void)getImage:(NSString*)specialUrl
//{
////    NSString * filePath = [[NSBundle mainBundle] initWithPath:specialUrl];
//    // 获取媒体文件路径的URL，必须用fileURLWithPath:来获取文件 URL
////    NSURL *fileUrl = [NSURL fileURLWithPath:@"/var/mobile/Containers/Data/Application/638E3D2D-DC75-4249-B449-E1EFF3E463A3/tmp/videos/20160928111009merge.mp4"];//fileSystemRepresentation
////    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileUrl options:nil];
//
////    NSString * filePath = [NSString stringWithFormat:@"file://%@",specialUrl];
//    NSArray *specialUrlArr = [specialUrl componentsSeparatedByString:@"/"];
//
//    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
//    NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
//    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
//    NSURL * fileUrl = [NSURL fileURLWithPath:fileName1];
//
//
//
//
//
////    NSURL * fileUrl = [NSURL URLWithString:@"file:///Users/kokia/Library/Developer/CoreSimulator/Devices/78F84EC5-E5CC-45DC-8E75-1000C968B638/data/Containers/Data/Application/AA081D72-FB2D-40B2-A9E1-3FA9C9FAF242/tmp/CFNetworkDownload_yruKAm.tmp"];
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileUrl options:nil];
//    NSError *error = nil;
//    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
//    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
//    AVAssetTrack *videoTrack =[videoTracks objectAtIndex:0];
//    int m_pixelFormatType;
//    //     视频播放时，
//    m_pixelFormatType = kCVPixelFormatType_32BGRA;
//    // 其他用途，如视频压缩
//    //    m_pixelFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange;
//
//    NSMutableDictionary *options = [NSMutableDictionary dictionary];
//    [options setObject:@(m_pixelFormatType) forKey:(id)kCVPixelBufferPixelFormatTypeKey];
//    AVAssetReaderTrackOutput *videoReaderOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:options];
//    [reader addOutput:videoReaderOutput];
//    [reader startReading];
//    while ([reader status] == AVAssetReaderStatusReading && videoTrack.nominalFrameRate > 0) {
//        // 读取 video sample
//        CMSampleBufferRef videoBuffer = [videoReaderOutput copyNextSampleBuffer];
//        //                [self.delegate mMoveDecoder:self onNewVideoFrameReady:videoBuffer];
//
//        // 根据需要休眠一段时间；比如上层播放视频时每帧之间是有间隔的,这里的 sampleInternal 我设置为0.001秒
//        [NSThread sleepForTimeInterval:0.001];
//        CGImageRef cgimage = [self imageFromSampleBufferRef:videoBuffer];
//        if (!(__bridge id)(cgimage)) { return; }
//        [self.images addObject:((__bridge id)(cgimage))];
//        CGImageRelease(cgimage);
//    }
//}

-(void)setUrlVideo
{
    NSString *specialUrl = [IPADDRESS stringByAppendingString:self.dicInfo[@"original_photos"][0][@"media_address"]];
    self.video.playUrl = [NSURL URLWithString:specialUrl];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!self.dicInfo) {
        return;
    }
    self.imageViews = [NSMutableArray array];
    
    NSInteger count = [self.dicInfo[@"original_photos"] count];
    if (count>0) {
        for (int i = 0; i < count; i++) {
            NSString *urlStr = [IPADDRESS stringByAppendingString:self.dicInfo[@"original_photos"][i][@"media_address"]];
            [self.imageViews addObject:urlStr];
        }
    }
    NSInteger videoCount = [self.dicInfo[@"videoCount"] integerValue];
    NSInteger index = [self.dicInfo[@"small_photos"] count];
    //    CGFloat width = kHEIGHT(76);
    CGFloat width;
    CGFloat videoWidth;
    if (SCREEN_WIDTH == 320) {
        width = 74;
        //        videoWidth = 140;
        videoWidth = 112;
    } else if (SCREEN_WIDTH == 375) {
        width = 79;
        //        videoWidth = 164;
        videoWidth = 131;//136
    } else {
        width = 86;
        //        videoWidth = 172;
        videoWidth = 145;//150
    }
    CGFloat line = 3;
    //    CGFloat y1 = 8;
    CGFloat y1 = 0;
    CGFloat x;
    if (self.condiderType == ConsiderLayoutTypeQuestion) {
        x = 10;
    } else {
        x = kHEIGHT(10) + kHEIGHT(37) + 10;
    }
    
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[RSPhotoView class]]) {
            RSPhotoView * view1 = (RSPhotoView*)view;
            [view1 removeFromSuperview];
        }
    }
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    if (videoCount == 1) {
        
        NSString *specialUrl = [IPADDRESS stringByAppendingString:self.dicInfo[@"original_photos"][0][@"media_address"]];
        self.videoUrl = specialUrl;
        RSPhotoView *video = [[RSPhotoView alloc] initWithFrame:CGRectMake(x, y1, videoWidth/3*4, videoWidth)];//videoWidth
        //        video.tag = -1;
        NSString *url = [IPADDRESS stringByAppendingString:self.dicInfo[@"small_photos"][0][@"small_address"]];
        [video sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeImage"]];
        video.userInteractionEnabled = YES;
        video.contentMode = UIViewContentModeScaleAspectFill;
        video.clipsToBounds = YES;
        [self addSubview:video];
        
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickVideo)];
        video.userInteractionEnabled = YES;
        [video addGestureRecognizer:tap1];
        
        
        self.video = [[zhiChangVideo alloc]initWithFrame:CGRectMake(x, y1,videoWidth/3*4,videoWidth)];
        UITapGestureRecognizer * tapVideo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickVideo)];
        [self.video addGestureRecognizer:tapVideo];
        [self addSubview:self.video];
        
        
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.frame = CGRectMake(x, y1,videoWidth/3*4,videoWidth);//videoWidth->videoWidth/3*4
        [playBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
        playBtn.enabled = NO;
        playBtn.userInteractionEnabled = YES;
        [self addSubview:playBtn];
        
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        recognizer.minimumPressDuration = 0.5;
        self.video.tag = -1;
        [self.video addGestureRecognizer:recognizer];//video
        
        self.videoItem = [[SDDemoItemView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.videoItem.center = self.video.center;
        self.videoItem.progressViewClass = [SDLoopProgressView class];
        self.videoItem.hidden = YES;
        [self addSubview:self.videoItem];
        
        
        
        NSString * videoString = self.dicInfo[@"original_photos"][0][@"media_address"];
        NSData * data = [NSData dataWithContentsOfFile:videoString];
        if (data) {
            playBtn.hidden = YES;
            self.fileStr = videoString;
            [self reloadStart];
            return;
        }
        if (self.workNetState)//自动播放
        {
            
            playBtn.hidden = YES;
            NSArray *specialUrlArr = [specialUrl componentsSeparatedByString:@"/"];
            NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
            NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
            NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
            NSFileManager * manger = [NSFileManager defaultManager];
            if ([manger fileExistsAtPath:fileName1]) {//本地有直接播放
                self.fileStr = fileName1;
                [self reloadStart];
            }
            else//本地没有需要下载
            {
                [self downLoadVideo:self.videoUrl success:^(id response) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"videoLoadSuccess" object:self.index];
                    });
                } failed:^(NSError *error) {
                } progress:^(NSProgress *progreee) {
                }];
            }
            return;
        }
        else
        {
            NSFileManager * fileManger = [NSFileManager defaultManager];
            NSArray *specialUrlArr = [self.videoUrl componentsSeparatedByString:@"/"];
            NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
            NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
            NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
            BOOL isOrNot = [fileManger fileExistsAtPath:fileName1];
            if (isOrNot)//本地有视频直接播放
            {
                playBtn.hidden = YES;
                self.fileStr = fileName1;
                [self reloadStart];
            }
            else//本地无视频时
            {
                playBtn.hidden = NO;
                playBtn.enabled = YES;
            }
        }
        return;
    }
    if (index != 4 && index != 0) {
        for (int i=0; i < index; i++) {
            RSPhotoView *imageView = [[RSPhotoView alloc] init];
            imageView.backgroundColor = RGB(221, 221, 221);
            
            imageView.tag = i + 1;
            imageView.userInteractionEnabled  = YES;
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            [imageView addGestureRecognizer:tap1];
            UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            recognizer.minimumPressDuration = 0.5;
            [imageView addGestureRecognizer:recognizer];
            
            NSString * imageString = self.dicInfo[@"small_photos"][i][@"small_address"];
            NSData * imageData = [NSData dataWithContentsOfFile:imageString];
            NSLog(@"当前图片字符串位置 == %@", imageString);
            if (imageData) {
                NSLog(@"本地已经有数据了");
                imageView.image = [UIImage imageWithData:imageData];
            }
            else
            {
                NSString *url = [IPADDRESS stringByAppendingString:self.dicInfo[@"small_photos"][i][@"small_address"]] ;
                //                    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageWithName:@"tupian_shibai"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //                        CGFloat max = image.size.width>image.size.height?image.size.width:image.size.height;
                //                        if (max < 50) {
                //                            NSString * string = [url stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
                //                            string = [string stringByReplacingOccurrencesOfString:@"thumb_" withString:@""];
                //                            [imageView sd_setImageWithURL:[NSURL URLWithString:string]];
                //                        }
                //
                //                    }];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    CGFloat max = image.size.width>image.size.height?image.size.width:image.size.height;
                    if (max < 50) {
                        NSString * string = [url stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
                        string = [string stringByReplacingOccurrencesOfString:@"thumb_" withString:@""];
                        [imageView sd_setImageWithURL:[NSURL URLWithString:string]];
                    }
                }];
                 
            }
            imageView.frame = CGRectMake(x + (width + line)*(i%3), y1 + (width + line)*(i/3), width, width);
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:imageView];
            
        }
    } else if (index == 4) {
        for (int i = 0; i< index; i++) {
            RSPhotoView *imageView = [[RSPhotoView alloc] init];
            imageView.backgroundColor = RGB(221, 221, 221);
            imageView.tag = i + 1;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            [imageView addGestureRecognizer:tap2];
            UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            recognizer.minimumPressDuration = 0.5;
            [imageView addGestureRecognizer:recognizer];
            imageView.userInteractionEnabled = YES;
            
            NSString * imageString = self.dicInfo[@"small_photos"][i][@"small_address"];
            NSData * data = [NSData dataWithContentsOfFile:imageString];
            if (data) {
                imageView.image = [UIImage imageWithData:data];
            }
            else
            {
                NSString *url = [IPADDRESS stringByAppendingString:self.dicInfo[@"small_photos"][i][@"small_address"]] ;
                //                    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageWithName:@"tupian_shibai"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //                        CGFloat max = image.size.width>image.size.height?image.size.width:image.size.height;
                //                        if (max < 50) {
                //                            NSString * string = [url stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
                //                            string = [string stringByReplacingOccurrencesOfString:@"thumb_" withString:@""];
                //                            [imageView sd_setImageWithURL:[NSURL URLWithString:string]];
                //                        }
                //
                //                    }];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:url]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    CGFloat max = image.size.width>image.size.height?image.size.width:image.size.height;
                    if (max < 50) {
                        NSString * string = [url stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
                        string = [string stringByReplacingOccurrencesOfString:@"thumb_" withString:@""];
                        [imageView sd_setImageWithURL:[NSURL URLWithString:string]];
                    }
                }];
            }
            imageView.frame = CGRectMake(x + (width + line)*(i%2), y1 + (width + line)*(i/2), width, width);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [self addSubview:imageView];
        }
    }
    
    
    //    if (videoCount == 1) {
    //        NSString *specialUrl = [IPADDRESS stringByAppendingString:self.dicInfo[@"original_photos"][0][@"media_address"]];
    //        self.videoUrl = specialUrl;
    //        RSPhotoView *video = [[RSPhotoView alloc] initWithFrame:CGRectMake(x, y1, videoWidth/3*4, videoWidth)];//videoWidth
    ////        video.tag = -1;
    //        NSString *url = [IPADDRESS stringByAppendingString:self.dicInfo[@"small_photos"][0][@"small_address"]];
    //        [video sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeImage"]];
    //        video.userInteractionEnabled = YES;
    //        video.contentMode = UIViewContentModeScaleAspectFill;
    //        video.clipsToBounds = YES;
    //        [self addSubview:video];
    //
    //        self.video = [[zhiChangVideo alloc]initWithFrame:CGRectMake(x, y1,videoWidth/3*4,videoWidth)];
    //        UITapGestureRecognizer * tapVideo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickVideo)];
    //        [self.video addGestureRecognizer:tapVideo];
    //        [self addSubview:self.video];
    //
    //
    //        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        playBtn.frame = CGRectMake(x, y1,videoWidth/3*4,videoWidth);//videoWidth->videoWidth/3*4
    //        [playBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
    //        [playBtn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
    //        playBtn.enabled = NO;
    //        playBtn.userInteractionEnabled = YES;
    //        [self addSubview:playBtn];
    ////        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoClick)];
    ////        [video addGestureRecognizer:tap1];
    //
    //        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    //        recognizer.minimumPressDuration = 0.5;
    //        self.video.tag = -1;
    //        [self.video addGestureRecognizer:recognizer];//video
    //
    //        self.videoItem = [[SDDemoItemView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    //        self.videoItem.center = self.video.center;
    //        self.videoItem.progressViewClass = [SDLoopProgressView class];
    //        self.videoItem.hidden = YES;
    //        [self addSubview:self.videoItem];
    //        if (self.workNetState)//自动播放
    //        {
    //
    //             playBtn.hidden = YES;
    //            NSArray *specialUrlArr = [specialUrl componentsSeparatedByString:@"/"];
    //            NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    //            NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
    //            NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    //            NSFileManager * manger = [NSFileManager defaultManager];
    //            if ([manger fileExistsAtPath:fileName1]) {//本地有直接播放
    //                self.fileStr = fileName1;
    //                [self reloadStart];
    //            }
    //            else//本地没有需要下载
    //            {
    //                [self downLoadVideo:self.videoUrl success:^(id response) {
    //                    self.fileStr = fileName1;
    //                    [self reloadStart];
    //
    //                } failed:^(NSError *error) {
    //                } progress:^(NSProgress *progreee) {
    //
    //                }];
    //            }
    ////            self.fileStr = fileName1;
    ////            [self reloadStart];
    //            return;
    //        }
    //        else
    //        {
    //            NSFileManager * fileManger = [NSFileManager defaultManager];
    //            NSArray *specialUrlArr = [self.videoUrl componentsSeparatedByString:@"/"];
    //            NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    //            NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
    //            NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    //            BOOL isOrNot = [fileManger fileExistsAtPath:fileName1];
    //            if (isOrNot)//本地有视频直接播放
    //            {
    //                playBtn.hidden = YES;
    //                self.fileStr = fileName1;
    //                [self reloadStart];
    //            }
    //            else//本地无视频时
    //            {
    //                playBtn.hidden = NO;
    //                playBtn.enabled = YES;
    //            }
    //
    //
    ////            playBtn.hidden = NO;
    ////            playBtn.enabled = YES;
    //        }
    //
    //
    //        return;
    //    }
    //
    //    if (index != 4 && index != 0) {
    //        for (int i=0; i < index; i++) {
    //            RSPhotoView *imageView = [[RSPhotoView alloc] init];
    //            imageView.tag = i + 1;
    //            imageView.userInteractionEnabled  = YES;
    //            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    //            [imageView addGestureRecognizer:tap1];
    //            UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    //            recognizer.minimumPressDuration = 0.5;
    //            [imageView addGestureRecognizer:recognizer];
    //
    //            NSString * urlstr = [self localUrl:[IPADDRESS stringByAppendingString:self.dicInfo[@"original_photos"][i][@"media_address"]]];
    //            if (urlstr.length)
    //            {
    //                NSData * data = [NSData dataWithContentsOfFile:urlstr];
    //                imageView.image = [UIImage imageWithData:data];
    //            }
    //            else
    //            {
    //                NSString *url = [IPADDRESS stringByAppendingString:self.dicInfo[@"small_photos"][i][@"small_address"]] ;
    //              [imageView sd_setImageWithURL:[NSURL URLWithString:[url stringByReplacingOccurrencesOfString:@"thumb_" withString:@"thumbd_"]] placeholderImage:[UIImage imageNamed:@"placeImage"]];
    //            }
    //            imageView.frame = CGRectMake(x + (width + line)*(i%3), y1 + (width + line)*(i/3), width, width);
    //            imageView.clipsToBounds = YES;
    //            imageView.contentMode = UIViewContentModeScaleAspectFill;
    //            [self addSubview:imageView];
    //
    //        }
    //    } else if (index == 4) {
    //        for (int i = 0; i< index; i++) {
    //            RSPhotoView *imageView = [[RSPhotoView alloc] init];
    //            imageView.tag = i + 1;
    //            imageView.userInteractionEnabled = YES;
    //            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    //            [imageView addGestureRecognizer:tap2];
    //            UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    //            recognizer.minimumPressDuration = 0.5;
    //            [imageView addGestureRecognizer:recognizer];
    //            imageView.userInteractionEnabled = YES;
    //
    //            NSString * urlstr = [self localUrl:[IPADDRESS stringByAppendingString:self.dicInfo[@"original_photos"][i][@"media_address"]]];
    //            if (urlstr.length)
    //            {
    //                NSData * data = [NSData dataWithContentsOfFile:urlstr];
    //                imageView.image = [UIImage imageWithData:data];
    //            }
    //            else
    //            {
    //                NSString *url = [IPADDRESS stringByAppendingString:self.dicInfo[@"small_photos"][i][@"small_address"]] ;
    //                [imageView sd_setImageWithURL:[NSURL URLWithString:[url stringByReplacingOccurrencesOfString:@"thumb_" withString:@"thumbd_"]] placeholderImage:[UIImage imageNamed:@"placeImage"]];
    //            }
    //            imageView.frame = CGRectMake(x + (width + line)*(i%2), y1 + (width + line)*(i/2), width, width);
    //            imageView.contentMode = UIViewContentModeScaleAspectFill;
    //            imageView.clipsToBounds = YES;
    //            [self addSubview:imageView];
    //        }
    //    }
}

//判断本地是否有图片
-(NSString * )localUrl:(NSString*)urlStr
{
    //    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"thumb_" withString:@""];
    NSArray * array = [urlStr componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:pictureAddress];
    NSString * fileName = [NSString stringWithFormat:@"%@/%@",savePath,array[array.count-1]];
    NSFileManager * mager = [NSFileManager defaultManager];
    if ([mager fileExistsAtPath:fileName])
    {
        return fileName;
    }
    else
    {
        return @"";
    }
}

-(void)reloadStart
{
    __weak typeof(self) weakSelf=self;
    [[ZacharyPlayManager sharedInstance]startWithLocalPath:self.fileStr WithVideoBlock:^(CGImageRef imageData, NSString *filePath) {
        if ([filePath isEqualToString:weakSelf.fileStr]) {
            self.video.layer.contents=(__bridge id _Nullable)(imageData);
        }
    }];
    
    [[ZacharyPlayManager sharedInstance]reloadVideo:^(NSString *filePath) {
        MAIN(^{
            if ([filePath isEqualToString:weakSelf.fileStr]) {
                [weakSelf reloadStart];
            }
        });
    } withFile:self.fileStr];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    UIView* view = recognizer.view;
    self.longTouchView = view;
    if (view.tag<0)
    {
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            [self.video becomeFirstResponder];
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            //设置菜单
            //        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuItem:)];
            UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(menuItem2:)];
            //            UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(menuItem3:)];
            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem2, nil]];//menuItem3,
            //设置菜单栏位置
            [menuController setTargetRect:self.video.frame inView:self.video.superview];
            //显示菜单栏
            [menuController setMenuVisible:YES animated:YES];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
        }
    }
    else
    {
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            [view becomeFirstResponder];
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            //设置菜单
            //        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuItem:)];
            UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(menuItem2:)];
            //            UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(menuItem3:)];
            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem2, nil]];//menuItem3,
            //设置菜单栏位置
            [menuController setTargetRect:view.frame inView:view.superview];
            //显示菜单栏
            [menuController setMenuVisible:YES animated:YES];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
        }
    }
}
-(NSMutableArray*)videoArray

{
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}
#pragma mark - 收藏
- (void)menuItem2:(id)sender
{
    NSInteger touchTag = self.longTouchView.tag;
    
    //    NSInteger touchTag = self.video.tag;
    if (touchTag == -1) {//收藏视频
        
        NSString * speak_comment_state = self.dicInfo[@"speak_comment_state"];
        NSDictionary *userInfo = @{@"collect_class" : @"2",
                                   @"user_id" : self.dicInfo[@"user_id"],
                                   @"content" : @"",
                                   @"img_url" : self.dicInfo[@"small_photos"][0][@"small_address"],
                                   @"vd_url" : self.dicInfo[@"original_photos"][0][@"media_address"],
                                   @"jobid" : @"",
                                   @"url" : @"",
                                   @"isNiMing":speak_comment_state,
                                   @"dic":self.dicInfo};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"collect" object:nil userInfo:userInfo];
        
    } else {
        NSString * speak_comment_state = self.dicInfo[@"speak_comment_state"];
        
        NSDictionary *userInfo = @{@"collect_class" : @"1",
                                   @"user_id" : self.dicInfo[@"user_id"],
                                   @"content" : @"",
                                   @"img_url" : self.dicInfo[@"small_photos"][touchTag - 1][@"small_address"],//small_photos//small_address
                                   @"vd_url" : self.dicInfo[@"original_photos"][touchTag - 1][@"media_address"],
                                   @"jobid" : @"",
                                   @"url" : @"",
                                   @"isNiMing":speak_comment_state,
                                   @"dic":self.dicInfo};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"collect" object:nil userInfo:userInfo];
    }
}

#pragma mark - 举报
- (void)menuItem3:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"report" object:nil userInfo:@{@"sid" : self.dicInfo[@"sid"]}];
}

-(void)WillHideMenu:(id)sender
{
}


#pragma mark - delegate
- (void)LewVideoPlayingWithCurrentTime:(CMTime)currentTime{
    CGFloat progress = CMTimeGetSeconds(currentTime)/CMTimeGetSeconds(_videoController.videoDuration);
    if (progress == 1) {
        [_videoController seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
            if (finished) {
                [_videoController play];
            }
        }];
    }
}
- (void)lewVideoReadyToPlay{
    //    NSLog(@"视频加载完成");
    [_placeImage removeFromSuperview];
    [_videoController play];
}
- (void)lewVideoLoadedProgress:(CGFloat)progress{
    //    NSLog(@"视频加载进度： %@",@(progress));
}

- (void)videoClick:(UIButton*)sender
{
    
    //    UIMenuController *menuController = [UIMenuController sharedMenuController];
    //    [menuController setMenuVisible:NO];
    
    
    
    sender.hidden = YES;
    //需要下载就下不需要下载直接播放
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSArray *specialUrlArr = [self.videoUrl componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    BOOL isOrNot = [fileManger fileExistsAtPath:fileName1];
    if (isOrNot)
    {//视频已经下载，直接播放
        self.fileStr = fileName1;
        [self reloadStart];
    }
    else//视频未下载
    {
        [self.activieyView startAnimating];
        [self downLoadVideo:self.videoUrl success:^(id response) {
            self.fileStr = fileName1;
            [self reloadStart];
            
        } failed:^(NSError *error) {
            sender.hidden = NO;
        } progress:^(NSProgress *progreee) {
            
        }];
        
        //        WPDownLoadVideo * downLoad = [[WPDownLoadVideo alloc]init];
        //     [downLoad downLoadVideo:self.videoUrl success:^(id response) {
        //
        //         [self performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:NO];
        //
        //         self.fileStr = fileName1;
        //         [self reloadStart];
        //     } failed:^(NSError *error) {
        //         [self performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:NO];
        //
        //         sender.hidden = NO;
        //     } progress:^(NSProgress *progreee) {
        //
        //     }];
    }
    
    //    VideoBrowser *video = [[VideoBrowser alloc] init];
    //    video.videoUrl = self.videoUrl;
    //    video.user_id = self.dicInfo[@"user_id"];
    //    video.img_url = self.dicInfo[@"small_photos"][0][@"small_address"];
    //    video.vd_url = self.dicInfo[@"original_photos"][0][@"media_address"];
    //    [video show];
}
-(void)downLoadVideo:(NSString * )filePath success:(void(^)(id response))success failed:(void(^)(NSError*error))failed progress:(void(^)(NSProgress*progreee))progress
{
    NSArray * pathArray = [filePath componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",pathArray[pathArray.count-1]];
    //        [self downloadFileURL:path savePath:savePath fileName:fileName tag:1];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName1]) {
        return;
    }
    //<1>获取下载的文件的路径
    NSString * string = filePath;
    //<2>如果下载的文件路径中存在中文 不能转换成NSURL 所以必须转码
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //<3>将字符串网址转化成NSURL
    NSURL * url = [NSURL URLWithString:string];
    //<4>封装成请求对象
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    //<5>创建下载管理者对象
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //参数是监控进度的变化 也就是KVO
    NSProgress * tempProgress = nil;
    //<6>创建下载任务
    /*
     1、请求对象的指针
     2、下载进度的对象指针
     3、下载的文件的存放的路径
     */
    NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:&tempProgress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
        NSData * data = [NSData dataWithContentsOfURL:targetPath];
        [data writeToFile:fileName1 atomically:YES];
        
        if (data)
        {
            if (success) {
                success(data);
            }
        }
        else
        {
            NSError * error =  nil;
            if (failed) {
                failed(error);
            }
            
        }
        return targetPath;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@",error.description);
    }];
    _videoProgress = tempProgress;
    //    NSLog(@"下载：%f",videoProgress.fractionCompleted);
    //<8>开始下载
    [task resume];
    [_videoProgress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == _videoProgress&&[keyPath isEqualToString:@"fractionCompleted"]) {
        //        NSLog(@"%.2f%%",videoProgress.fractionCompleted*100);
        NSString * pro = [NSString stringWithFormat:@"%f",_videoProgress.fractionCompleted];
        [self performSelectorOnMainThread:@selector(hideActivity:) withObject:pro waitUntilDone:NO];
    }
}


-(void)hideActivity:(NSString*)progress
{
    self.videoItem.hidden = NO;
    self.videoItem.progressView.progress = progress.floatValue;
}
-(void)clickVideo
{
    UIMenuController * menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO];
    
    NSArray *specialUrlArr = [self.videoUrl componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
    
    WPViewShuoShuoVideo * video = [[WPViewShuoShuoVideo alloc]init];
    video.videoStr = self.videoUrl;
    video.user_id = self.dicInfo[@"user_id"];
    video.img_url = self.dicInfo[@"small_photos"][0][@"small_address"];
    video.vd_url = self.dicInfo[@"original_photos"][0][@"media_address"];
    [video showPickerVc:[self viewController]];
}

-(void)downLoadThumbdImage:(NSString*)imageStr
{
    imageStr = [self getImageStr:imageStr];
    NSString* string = [self localUrl:imageStr];
    //本地中没有缩略图
    if (!string.length) {
        WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
        if (![imageStr hasPrefix:@"http"]) {
            imageStr = [IPADDRESS stringByAppendingString:imageStr];
        }
        [down downLoadImage:imageStr success:^(id response) {
        } failed:^(NSError *error) {
        }];
    }
}

#pragma mark   点击图片进行加载---

- (void)tapImage:(UITapGestureRecognizer *)tap{
    UIViewController *controller = [self viewController];
    NSLog(@"self ---- %@", controller);
    if ([[controller class] isEqual:[NewDetailViewController class]]) {
        NewDetailViewController *detail = (NewDetailViewController *)controller;
        [detail keyBoardDismiss];
    }
    
    NSInteger count = [self.dicInfo[@"original_photos"] count];
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        NSString *url = [IPADDRESS stringByAppendingString:self.dicInfo[@"original_photos"][i][@"media_address"]];
        MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:url];
        UIImageView *imageV = (UIImageView *)[self viewWithTag:i+1];
        NSString * imageStr = [self localUrl:url];
        if (imageStr.length) {    //1. 判断本地是否有原图
            NSData * data = [NSData dataWithContentsOfFile:imageStr];
            imageV.image = [UIImage imageWithData:data];
        }
        else
        {
            NSString * imageString = [self getImageStr:url];
            imageString = [self localUrl:imageString];
            if (imageString.length) {    //2. 本地没有原图,则将链接拼接,在本地查找是否有缩略图
                NSData * data = [NSData dataWithContentsOfFile:imageString];
                imageV.image = [UIImage imageWithData:data];
            }
            else
            {
                //3. 如果本地连缩略图都没有的话,直接通过网络进行加载图片
                [imageV sd_setImageWithURL:[NSURL URLWithString:[self getImageStr:url]]];
            }
        }
        
        photo.user_id = self.dicInfo[@"user_id"];
        photo.sid = self.dicInfo[@"sid"];
        photo.toView = imageV;
        [photos addObject:photo];
    }
    
    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
    photoBrowser.isDetail = self.isDetail;
    
    //缩放动画
    photoBrowser.status = UIViewAnimationAnimationStatusZoom;
    photoBrowser.photos = photos;
    photoBrowser.isNeedShow = YES;
    photoBrowser.currentStr = [IPADDRESS stringByAppendingString:self.dicInfo[@"small_photos"][tap.view.tag - 1][@"small_address"]];
    photoBrowser.reloadIndex = self.index;
    
    //当前选中的值
    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:tap.view.tag - 1 inSection:0];
    
    //展示控制器
    [photoBrowser showPickerVc:[self viewController]];
//      [photoBrowser show];
}

-(NSString *)getImageStr:(NSString*)imageStr
{
    NSArray * array = [imageStr componentsSeparatedByString:@"/"];
    NSMutableArray * muarry = [NSMutableArray array];
    [muarry addObjectsFromArray:array];
    NSString * lastStr = array[array.count-1];
    lastStr = [@"thumbd_" stringByAppendingString:lastStr];
    [muarry replaceObjectAtIndex:array.count-1 withObject:lastStr];
    lastStr = [muarry componentsJoinedByString:@"/"];
    return lastStr;
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


- (void)dealloc{
    //    [_videoController cancel];
    //    [[ZacharyPlayManager sharedInstance]cancelAllVideo];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end
