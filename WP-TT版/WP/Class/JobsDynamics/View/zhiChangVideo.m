//
//  zhiChangVideo.m
//  WP
//
//  Created by CC on 16/9/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "zhiChangVideo.h"

@implementation zhiChangVideo
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self = [[self alloc]initWithFrame:frame];
//        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//        self.playerLayer.frame = frame;
//        [self.layer addSublayer:self.playerLayer];
//        self = [[zhiChangVideo alloc]initWithFrame:frame];
    }
    return self;
}
-(void)setPlayUrl:(NSURL *)playUrl
{
    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:playUrl];
    
    
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.playerLayer.frame = CGRectMake(0, 0, self.width, self.height);
    [self.layer addSublayer:self.playerLayer];
    self.player.volume = 0;
    [self.player play];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
-(void)dealloc
{
    self.player = nil;
}

-(void)removPlay:(AVPlayer*)player
{
    [player pause];
    [player.currentItem cancelPendingSeeks];
    [player.currentItem.asset cancelLoading];
    [player replaceCurrentItemWithPlayerItem:nil];
     
    player = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//+(instancetype)videoWithUrl:(NSURL*)videoUrl
//{
//    WPDDChatVideo * video = [[WPDDChatVideo alloc]initWithSubviews:videoUrl];
//    return video;
//}
//- (instancetype)initWithSubviews:(NSURL *)url{
//    self = [super init];
//    if (self) {
//        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
//        self.player = [AVPlayer playerWithPlayerItem:playerItem];
//        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//        _playerLayer.videoGravity = AVLayerVideoGravityResize;
//        _playerLayer.frame = CGRectMake(0, 0, 50, 50);
//        [self.view.layer addSublayer:_playerLayer];
//        _player.volume = 0;//设置音量
//        [_player play];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//    }
//    return self;
//}
//-(void)setPlayUrl:(NSURL *)playUrl
//{
//    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:playUrl];
//    self.player = [AVPlayer playerWithPlayerItem:item];
//    [_player play];
//    
//}
-(void)runLoopTheMovie:(NSNotification*)notification
{
    AVPlayerItem * item = [notification object];
    [item seekToTime:kCMTimeZero];
    [_player play];
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
@end
