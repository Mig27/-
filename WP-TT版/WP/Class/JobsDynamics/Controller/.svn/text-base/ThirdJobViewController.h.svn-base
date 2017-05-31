//
//  ThirdJobViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/1/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "JSMessageInputView.h"
#import "JSMessageTextView.h"
#import "EmotionsViewController.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "ChatUtilityViewController.h"

@class RecordingView;
@interface ThirdJobViewController : BaseViewController<JSMessageInputViewDelegate,UIGestureRecognizerDelegate,DDEmotionsViewControllerDelegate, RecordingDelegate, PlayingDelegate>
{
    RecordingView* _recordingView;
}

@property(nonatomic,strong)JSMessageInputView *chatInputView;
@property(nonatomic,strong)ChatUtilityViewController *ddUtility;
@property(nonatomic,strong)EmotionsViewController *emotions;

@end
