//
//  NewDemandViewController.h
//  WP
//
//  Created by 沈亮亮 on 15/9/23.
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

@interface DemandCategoryModel : NSObject

@property (nonatomic,copy) NSString *action;
@property (nonatomic,copy) NSString *areID;

@end

@class RecordingView;
@interface NewDemandViewController : BaseViewController<JSMessageInputViewDelegate,UIGestureRecognizerDelegate, DDEmotionsViewControllerDelegate, RecordingDelegate, PlayingDelegate>
{
    RecordingView* _recordingView;
}


@property(nonatomic,strong)JSMessageInputView *chatInputView;
@property(nonatomic,strong)ChatUtilityViewController *ddUtility;
@property(nonatomic,strong)EmotionsViewController *emotions;

@end
