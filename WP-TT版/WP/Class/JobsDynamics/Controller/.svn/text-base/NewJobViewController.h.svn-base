//
//  NewJobViewController.h
//  WP
//
//  Created by 沈亮亮 on 15/9/24.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "JSMessageInputView.h"
#import "JSMessageTextView.h"
#import "EmotionsViewController.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "ChatUtilityViewController.h"

@interface JobDynamicModel : NSObject

@end

@class RecordingView;
@interface NewJobViewController : BaseViewController<JSMessageInputViewDelegate,UIGestureRecognizerDelegate,DDEmotionsViewControllerDelegate, RecordingDelegate, PlayingDelegate, ChatUtilityViewControllerDelegate>
{
    RecordingView* _recordingView;
}

@property(nonatomic,strong)JSMessageInputView *chatInputView;
@property(nonatomic,strong)ChatUtilityViewController *ddUtility;
@property(nonatomic,strong)EmotionsViewController *emotions;

@end
