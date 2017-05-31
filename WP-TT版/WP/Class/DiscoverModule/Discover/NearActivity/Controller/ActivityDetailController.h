//
//  ActivityDetailController.h
//  WP
//
//  Created by 沈亮亮 on 15/10/26.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "JSMessageInputView.h"
#import "JSMessageTextView.h"
#import "EmotionsViewController.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "ChatUtilityViewController.h"


@class RecordingView;
@interface ActivityDetailController : BaseViewController<JSMessageInputViewDelegate,UIGestureRecognizerDelegate, DDEmotionsViewControllerDelegate, RecordingDelegate, PlayingDelegate, ChatUtilityViewControllerDelegate>
{
    RecordingView* _recordingView;
}


@property(nonatomic,strong)JSMessageInputView *chatInputView;
@property(nonatomic,strong)ChatUtilityViewController *ddUtility;
@property(nonatomic,strong)EmotionsViewController *emotions;

@property (nonatomic,strong) NSString *game_id;  //活动的id

@end
