//
//  DDChattingMainViewController.h
//  IOSDuoduo
//  群聊天 主页面 
//  Created by 东邪 on 14-5-26.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import "MTTBaseViewController.h"
#import "JSMessageInputView.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "JSMessageTextView.h"
#import "MTTMessageEntity.h"
#import "ChattingModule.h"
#import "EmotionsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <TTTAttributedLabel.h>
#import "MTTPhotosCache.h"
#import "LCActionSheet.h"
#import "DDChatImagePreviewViewController.h"
#import "TTChatPlusScrollViewController.h"

typedef void(^TimeCellAddBlock)(bool isok);
@class ChatUtilityViewController;
@class EmotionsViewController;
@class MTTSessionEntity;
@class RecordingView;
@class Photo;
@interface ChattingMainViewController : BaseViewController<UITextViewDelegate, JSMessageInputViewDelegate,UITableViewDataSource,UITableViewDelegate,RecordingDelegate,PlayingDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,DDEmotionsViewControllerDelegate,UINavigationControllerDelegate,TTTAttributedLabelDelegate,LCActionSheetDelegate>{
    
    RecordingView* _recordingView;
}
@property(nonatomic,strong)ChattingModule* module;
@property(nonatomic,strong)TTChatPlusScrollViewController *ddUtility;
@property(nonatomic,strong)JSMessageInputView *chatInputView;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
@property(nonatomic,weak)IBOutlet UITableView *tableView;
@property(nonatomic,strong)EmotionsViewController *emotions;
@property (assign, nonatomic, readonly) UIEdgeInsets originalTableViewContentInset;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) NSMutableArray* images;
@property (nonatomic, strong) UIImageView* preShow;
@property (nonatomic, strong) ALAsset *lastPhoto;
@property (nonatomic, strong) MTTPhotoEnity *preShowPhoto;
@property (nonatomic, strong) UIImage *preShowImage;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *email;
@property (assign)BOOL hadLoadHistory;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, assign) BOOL isPushFromCreatQuick;//从快速创建中条道消息界面
@property (nonatomic, assign)BOOL isFromZhiChangCreat;//从职场中创建
@property (nonatomic, assign) BOOL isFromPersonal;
@property (nonatomic, assign) BOOL isCurrentVC;
// 去@页面
@property (assign)BOOL isGotoAt;
+(instancetype )shareInstance;

- (void)sendImageMessage:(MTTPhotoEnity *)photo Image:(UIImage *)image;
- (void)sendPrompt:(NSString*)prompt;
-(void)removeImage;
-(void)sendePersonalCard:(NSArray*)cardArray;
-(void)sendMyApplyAndWant:(NSArray*)array andApply:(BOOL)apply;
-(void)sendMyWant:(NSArray*)array andApply:(BOOL)apply;
-(void)sendTextFromCollection:(NSArray*)array;
-(void)sendPhototFromCollection:(NSString*)urlStr;
-(void)sendMuchApplyAndWant:(NSArray*)array andApply:(BOOL)apply;
-(void)sendPersonDay:(NSArray*)array;
-(void)sendMuchWant:(NSArray*)array andApply:(BOOL)apply;
-(void)sendDictionaryFromCollection:(NSDictionary*)dictionary;
-(void)sendLitterVideo:(NSString*)filePath;
-(void)sendVideoFromCollection:(NSString*)videoStr;
-(void)sendeMuchCollection:(NSArray*)array;
-(void)sendMessage:(NSString *)msg messageEntity:(MTTMessageEntity *)message;
/**
 *  任意页面跳转到聊天界面并开始一个会话
 *
 *  @param session 传入一个会话实体
 */
- (void)loadChattingContentFromSearch:(MTTSessionEntity*)session message:(MTTMessageEntity*)message;
- (void)showChattingContentForSession:(MTTSessionEntity*)session;
- (void)insertEmojiFace:(NSString *)string;
- (void)insertYYFace:(NSString *)string;
- (void)deleteEmojiFace;
- (void)p_popViewController;
- (void)scrollToBottomAnimated:(BOOL)isOrNot;
@end


@interface ChattingMainViewController(ChattingInput)
- (void)initialInput;
@end
