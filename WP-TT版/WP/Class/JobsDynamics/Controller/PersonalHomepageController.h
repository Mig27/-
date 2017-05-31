//
//  PersonalHomepageController.h
//  WP
//
//  Created by 沈亮亮 on 15/7/30.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessageInputView.h"
#import "JSMessageTextView.h"
#import "EmotionsViewController.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "ChatUtilityViewController.h"
#import "BaseViewController.h"


@protocol updataImage <NSObject>

- (void)updateImageWith:(UIImage *)image;

@end

@class RecordingView;

@interface PersonalHomepageController : BaseViewController<JSMessageInputViewDelegate,UIGestureRecognizerDelegate, DDEmotionsViewControllerDelegate, RecordingDelegate, PlayingDelegate>
{
    RecordingView* _recordingView;
}


@property(nonatomic,strong)JSMessageInputView *chatInputView;
@property(nonatomic,strong)ChatUtilityViewController *ddUtility;
@property(nonatomic,strong)EmotionsViewController *emotions;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,assign) BOOL is_myself;    //是否是自己本人
@property (nonatomic,strong) NSString *sid;     //传过来的sid
@property (nonatomic,strong) NSString *speak_type; //说说的类型，1为职场动态。。。。后期需要传过来
@property (nonatomic,assign)id<updataImage> delegate;

@end
