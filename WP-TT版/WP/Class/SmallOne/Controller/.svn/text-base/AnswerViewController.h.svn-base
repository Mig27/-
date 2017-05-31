//
//  AnswerViewController.h
//  WP
//
//  Created by 沈亮亮 on 15/8/19.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessageInputView.h"
#import "JSMessageTextView.h"
#import "EmotionsViewController.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "ChatUtilityViewController.h"

@protocol refreshList <NSObject>

- (void)refreshList;

@end

@class RecordingView;
@interface AnswerViewController : UIViewController<JSMessageInputViewDelegate,UIGestureRecognizerDelegate, DDEmotionsViewControllerDelegate, RecordingDelegate, PlayingDelegate, ChatUtilityViewControllerDelegate>
{
    RecordingView* _recordingView;
}
@property(nonatomic,strong)JSMessageInputView *chatInputView;
@property(nonatomic,strong)ChatUtilityViewController *ddUtility;
@property(nonatomic,strong)EmotionsViewController *emotions;

@property (nonatomic, strong) NSMutableDictionary *info;
@property (nonatomic, assign) id<refreshList> delegate;

@end
