//
//  zhiChangVideo.h
//  WP
//
//  Created by CC on 16/9/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
@interface zhiChangVideo : UIView
@property (nonatomic, strong)AVPlayer *player;
@property (nonatomic, strong)NSURL * playUrl;
@property (nonatomic, strong)AVPlayerLayer *playerLayer;
-(void)removPlay:(AVPlayer*)player;
@end
