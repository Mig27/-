//
//  WPJobDetailViewController.h
//  WP
//
//  Created by 沈亮亮 on 15/8/20.
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

typedef enum : NSUInteger {
    NewDetailTypeDynamic,          //职场动态
    NewDetailTypeNeed,             //奇葩需求
    NewDetailTypeEnergy,           //职场正能量
    NewDetailTypeSpit,             //职场吐槽
    NewDetailTypePsychology,       //职场心理学
    NewDetailTypeManage,           //管理智慧
    NewDetailTypePoineering,       //创业心得
    NewDetailTypeEmotion,          //情感心语
}NewDetailType;

@class RecordingView;
@interface WPJobDetailViewController : BaseViewController<JSMessageInputViewDelegate,UIGestureRecognizerDelegate, DDEmotionsViewControllerDelegate, RecordingDelegate, PlayingDelegate, ChatUtilityViewControllerDelegate>
{
    RecordingView* _recordingView;
}


@property(nonatomic,strong)JSMessageInputView *chatInputView;
@property(nonatomic,strong)ChatUtilityViewController *ddUtility;
@property(nonatomic,strong)EmotionsViewController *emotions;

@property (nonatomic, strong) NSMutableDictionary *info;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, assign) BOOL is_good;
@property (nonatomic,assign) NewDetailType type;     //详情的类别
@property (nonatomic,copy) void(^deletComplete)();   //删除完成


@end
