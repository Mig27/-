//
//  WPDDChatVideo.m
//  WP
//
//  Created by CC on 16/8/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPDDChatVideo.h"

@implementation WPDDChatVideo


+(instancetype)videoWithUrl:(NSURL*)videoUrl
{
    WPDDChatVideo * video = [[WPDDChatVideo alloc]initWithSubviews:videoUrl];
    return video;
}
- (instancetype)initWithSubviews:(NSURL *)url{
    self = [super init];
    if (self) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.videoGravity = AVLayerVideoGravityResize;
        _playerLayer.frame = CGRectMake(0, 0, 50, 50);
        [self.view.layer addSublayer:_playerLayer];
        _player.volume = 0;//设置音量
        [_player play];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
-(void)setPlayUrl:(NSURL *)playUrl
{
    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:playUrl];
    self.player = [AVPlayer playerWithPlayerItem:item];
    [_player play];
}
-(void)runLoopTheMovie:(NSNotification*)notification
{
    AVPlayerItem * item = [notification object];
    [item seekToTime:kCMTimeZero];
    [_player play];
}
@end
