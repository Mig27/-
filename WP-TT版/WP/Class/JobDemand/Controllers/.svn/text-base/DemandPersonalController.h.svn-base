//
//  DemandPersonalController.h
//  WP
//
//  Created by 沈亮亮 on 15/9/11.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessageInputView.h"
#import "JSMessageTextView.h"
#import "EmotionsViewController.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "ChatUtilityViewController.h"

@class RecordingView;
@interface DemandPersonalController : UIViewController<JSMessageInputViewDelegate,UIGestureRecognizerDelegate, DDEmotionsViewControllerDelegate, RecordingDelegate, PlayingDelegate, ChatUtilityViewControllerDelegate>
{
    RecordingView* _recordingView;
}


@property(nonatomic,strong)JSMessageInputView *chatInputView;
@property(nonatomic,strong)ChatUtilityViewController *ddUtility;
@property(nonatomic,strong)EmotionsViewController *emotions;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,assign) BOOL is_myself;    //是否是自己本人
@property (nonatomic,strong) NSString *sid;     //传过来的sid
@property (nonatomic,strong) NSString *style;   //说说的种类

@end
