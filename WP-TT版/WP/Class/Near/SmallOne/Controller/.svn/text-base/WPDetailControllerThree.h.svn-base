//
//  WPDetailControllerThree.h
//  WP
//
//  Created by Asuna on 15/6/1.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessageInputView.h"
#import "JSMessageTextView.h"
#import "EmotionsViewController.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "ChatUtilityViewController.h"

typedef enum : NSUInteger {
    DetailTypeDynamic,          //职场动态
    DetailTypeQuestion,         //职场问答
    DetailTypeNeed,             //奇葩需求
    DetailTypeEnergy,           //职场正能量
    DetailTypeSpit,             //职场吐槽
    DetailTypePsychology,       //职场心理学
    DetailTypeManage,           //管理智慧
    DetailTypePoineering,       //创业心得
    DetailTypeEmotion,          //情感心语
}DetailType;


@class RecordingView;

@interface WPDetailControllerThree : UIViewController<JSMessageInputViewDelegate,UIGestureRecognizerDelegate, DDEmotionsViewControllerDelegate, RecordingDelegate, PlayingDelegate>
{
    RecordingView* _recordingView;
}


@property(nonatomic,strong)JSMessageInputView *chatInputView;
@property(nonatomic,strong)ChatUtilityViewController *ddUtility;
@property(nonatomic,strong)EmotionsViewController *emotions;
@property(nonatomic,strong)NSMutableDictionary *userInfo; //被评论者的信息
@property(nonatomic,assign)BOOL is_good;

@property (nonatomic,assign) DetailType type;     //详情的类别

@end
