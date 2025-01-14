//
//  LewVideoController.h
//  LewVideoPlayerController
//
//  Created by deng on 15/3/5.
//  Copyright (c) 2015年 独奏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol LewVideoControllerDelegate <NSObject>


- (void)LewVideoPlayingWithCurrentTime:(CMTime)currentTime;


- (void)lewVideoReadyToPlay;

- (void)lewVideoLoadedProgress:(CGFloat)progress;
@end

@interface LewVideoController : NSObject
@property (nonatomic, strong, readonly)AVPlayer *player;
@property (nonatomic, strong, readonly)AVPlayerLayer *playerLayer;

@property (nonatomic, assign, readonly)CMTime videoDuration;
@property (nonatomic, assign) BOOL isCreat;
@property (nonatomic, assign) BOOL isNetOrNot;
@property (nonatomic, weak) id<LewVideoControllerDelegate> delegate;

- (void)seekToTime:(CMTime)time;
- (void)seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler;

+ (instancetype)videoControllerWithNetURL:(NSURL *)url;
+(instancetype)videoWithContentFiled:(NSString *)filePath;
+ (instancetype)videoControllerWithLocalURLArray:(NSArray *)urlArray;
//- (instancetype)initWithLocalURL:(NSURL *)url;
//- (instancetype)initWithLocalURLList:(NSArray *)urlList;


- (void)play;
- (void)pause;
- (void)replaceWithNewNetURL:(NSURL *)url;
- (void)cancel;
@end
