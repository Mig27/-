//
//  WPJobViewController.h
//  WP
//
//  Created by 沈亮亮 on 15/7/2.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessageInputView.h"
#import "JSMessageTextView.h"
#import "EmotionsViewController.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "ChatUtilityViewController.h"

typedef enum : NSUInteger{
    JobTypeDynamic,         //职场动态
    JobTypePositiveEnergy,  //职场正能量
    JobTypeSpit,            //职场吐槽
    JobTypePsychology,      //职场心理学
    JobTypeManage,          //管理智慧
    JobTypePoineering,      //创业心得
    JobTypeEmotion,         //情感心语
}JobType;

@class RecordingView;
@interface WPJobViewController : UIViewController<JSMessageInputViewDelegate,UIGestureRecognizerDelegate,DDEmotionsViewControllerDelegate, RecordingDelegate, PlayingDelegate, ChatUtilityViewControllerDelegate>
{
    RecordingView* _recordingView;
}

@property (strong, nonatomic) id detailItem;
@property(nonatomic,strong)JSMessageInputView *chatInputView;
@property(nonatomic,strong)ChatUtilityViewController *ddUtility;
@property(nonatomic,strong)EmotionsViewController *emotions;
@property(nonatomic,assign)JobType reqJobType;
@property(nonatomic,strong)NSString *title;


@end
