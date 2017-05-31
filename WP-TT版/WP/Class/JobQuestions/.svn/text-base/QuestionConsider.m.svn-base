//
//  QuestionConsider.m
//  WP
//
//  Created by 沈亮亮 on 15/8/7.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "QuestionConsider.h"
#import "UIImage+MR.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "LewVideoController.h"
#import "VideoBrowser.h"

@interface QuestionConsider ()<LewVideoControllerDelegate>

@property (nonatomic,strong)NSMutableArray *imageViews;
@property (nonatomic,strong)LewVideoController *videoController;
@property (nonatomic,strong)NSString *videoUrl;
@property (nonatomic,strong)UIImageView *placeImage;

@end

@implementation QuestionConsider
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
    CGFloat width = 76;
    CGFloat line = 3;
    CGFloat y1 = 8;
    //    CGFloat y2 = 10;
    CGFloat x = 10;
    
    
    if (videoCount == 1) {
        NSString *specialUrl = [IPADDRESS stringByAppendingString:self.dicInfo[@"original_photos"][0][@"media_address"]];
        NSLog(@"有视频---%@",specialUrl);
        _videoController = [LewVideoController videoControllerWithNetURL:[NSURL URLWithString:specialUrl]];
        self.videoUrl = specialUrl;
        _videoController.player.volume = 0;
        _videoController.delegate = self;
        _videoController.playerLayer.frame = CGRectMake(58, y1, 76, 76);
        [self.layer addSublayer:_videoController.playerLayer];
        
        _placeImage = [[UIImageView alloc] initWithFrame:_videoController.playerLayer.bounds];
        _placeImage.image = [UIImage imageNamed:@"videoPlaceImage"];
        [_videoController.playerLayer addSublayer:_placeImage.layer];
        
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.frame = CGRectMake(58, y1, 76, 76);
        [playBtn addTarget:self action:@selector(videoClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playBtn];
        
        return;
    }
    
        if (index != 4 && index != 0) {
            for (int i=0; i < index; i++) {
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.tag = i + 1;
                imageView.userInteractionEnabled  = YES;
                UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
                [imageView addGestureRecognizer:tap1];
                NSString *url = [IPADDRESS stringByAppendingString:self.dicInfo[@"small_photos"][i][@"small_address"]];
//                NSString *specialUrl = [IPADDRESS stringByAppendingString:self.dicInfo[@"original_photos"][i][@"media_address"]];
                imageView.frame = CGRectMake(x + (width + line)*(i%3), y1 + (width + line)*(i/3), width, width);
                [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeImage"]];
                imageView.clipsToBounds = YES;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:imageView];
                
            }
        } else if (index == 4) {
            for (int i = 0; i< index; i++) {
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.tag = i + 1;
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
                [imageView addGestureRecognizer:tap2];
                NSString *url = [IPADDRESS stringByAppendingString:self.dicInfo[@"small_photos"][i][@"small_address"]];
                imageView.frame = CGRectMake(x + (width + line)*(i%2), y1 + (width + line)*(i/2), width, width);
                [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeImage"]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
                [self addSubview:imageView];
            }
        }
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
    [_placeImage removeFromSuperview];
    [_videoController play];
}
- (void)lewVideoLoadedProgress:(CGFloat)progress{
}

- (void)videoClick
{
    VideoBrowser *video = [[VideoBrowser alloc] init];
    video.videoUrl = self.videoUrl;
    [video show];
}

- (void)tapImage:(UITapGestureRecognizer *)tap{
    NSInteger count = [self.dicInfo[@"original_photos"] count];
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        NSString *url = [IPADDRESS stringByAppendingString:self.dicInfo[@"original_photos"][i][@"media_address"]];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url];
        UIImageView *imageV = (UIImageView *)[self viewWithTag:i+1];
        photo.srcImageView = imageV;
        [photos addObject:photo];
    }
    
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    brower.currentPhotoIndex = tap.view.tag - 1;
    brower.photos = photos;
    [brower show];
}

- (void)dealloc{
    [_videoController cancel];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
