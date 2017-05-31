//
//  WPDDChatVideo.h
//  WP
//
//  Created by CC on 16/8/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface WPDDChatVideo : UIViewController
@property (nonatomic, strong)AVPlayer *player;

@property (nonatomic, strong)NSURL * playUrl;
@property (nonatomic, strong)AVPlayerLayer *playerLayer;
@property (nonatomic, assign)CMTime videoDuration;// 视频总时长
+(instancetype)videoWithUrl:(NSURL*)videoUrl;



@end
