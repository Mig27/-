//
//  DDChattingMainViewController.m
//  IOSDuoduo
//
//  Created by 东邪 on 14-5-26.
//  Copyright (c) 2014年 dujia. All rights reserved.
//  消息聊天界面主界面

#import "ChattingMainViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <BlocksKit+UIKit.h>
#import "ChatUtilityViewController.h"
#import "MTTPhotosCache.h"
#import "DDGroupModule.h"
#import "DDMessageSendManager.h"
#import "MsgReadACKAPI.h"
#import "MTTDatabaseUtil.h"
#import "DDChatTextCell.h"
#import "DDChatVoiceCell.h"
#import "DDChatImageCell.h"
#import "DDChatPersonalCardCell.h"
#import "DDChattingEditViewController.h"
#import "DDPromptCell.h"
#import "UIView+Addition.h"
#import "DDMessageModule.h"
#import "RecordingView.h"
#import "TouchDownGestureRecognizer.h"
#import "DDSendPhotoMessageAPI.h"
#import "NSDictionary+JSON.h"
#import "EmotionsModule.h"
#import "RuntimeStatus.h"
#import "DDEmotionCell.h"
#import "PublicProfileViewControll.h"
#import "UnAckMessageManager.h"
#import "GetMessageQueueAPI.h"
#import "GetLatestMsgId.h"
#import "MTTPhotosCache.h"
#import "UIScrollView+PullToLoadMore.h"
#import "UIImageView+WebCache.h"
#import "MTTWebViewController.h"
#import <SVWebViewController.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MTTPhotosCache.h"
#import "ContactsViewController.h"
#import "DDUserModule.h"
#import "LCActionSheet.h"
#import "MTTUtil.h"
#import "UIImageView+WebCache.h"
#import "MTTUsersStatAPI.h"
#import "IQKeyboardManager.h"
#import "RecentUsersViewController.h"
#import "WPChattingSingleEditViewController.h"
#import "WPGroupInformationViewController.h"
#import "PersonalInfoViewController.h"
#import "PersonalInfoViewController.h"
#import "NearInterViewController.h"
#import "WPNewResumeModel.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDImageCache.h>
#import "MuchApplyAndWantCell.h"
#import "ShareDetailController.h"
#import "NewDetailViewController.h"
#import "VideoBrowser.h"
#import "DDVideoCell.h"
#import "WPRecentLinkManController.h"
#import "CollectViewController.h"
#import "MLPhotoBrowserViewController.h"
#import "WPMainController.h"
#import "inviteAndApplyCellController.h"
#import "WPGroupAlumDetailViewController.h"
#import "WPNoticeDetailViewController.h"
#import "MuchCollectionFromChatDetail.h"
#import "WPMySecurities.h"
#import "ZacharyPlayManager.h"
#import "shuoShuoVodeoClick.h"
#import "DDClientState.h"
#import "WPBlackNameModel.h"
#import "WPAddNewFriendParam.h"
#import "WPAddNewFriendHttp.h"
#import "WPAddNewFriendValidateController.h"
#import "WPPhotoAndVideoController.h"
#import "NSDate+DDAddition.h"
#import "WPChooseLinkViewController.h"
#import "WPUploadImage.h"
#import "WPSetMessageType.h"
#import "WPSetMessageType.h"
#import "modeView.h"
#import "RSSocketClinet.h"
#define shuoShuoVideo @"/shuoShuoVideo"
#import "WPDynamicGroupViewController.h"
typedef NS_ENUM(NSUInteger, DDBottomShowComponent)
{
    DDInputViewUp                       = 1,
    DDShowKeyboard                      = 1 << 1,
    DDShowEmotion                       = 1 << 2,
    DDShowUtility                       = 1 << 3
};

typedef NS_ENUM(NSUInteger, DDBottomHiddComponent)
{
    DDInputViewDown                     = 14,
    DDHideKeyboard                      = 13,
    DDHideEmotion                       = 11,
    DDHideUtility                       = 7
};
//

typedef NS_ENUM(NSUInteger, DDInputType)
{
    DDVoiceInput,
    DDTextInput
};

typedef NS_ENUM(NSUInteger, PanelStatus)
{
    VoiceStatus,
    TextInputStatus,
    EmotionStatus,
    ImageStatus
};

#define DDINPUT_MIN_HEIGHT          46.0f
#define DDINPUT_HEIGHT              self.chatInputView.size.height
#define DDINPUT_BOTTOM_FRAME        CGRectMake(0, CONTENT_HEIGHT - self.chatInputView.height + NAVBAR_HEIGHT,FULL_WIDTH,self.chatInputView.height)
#define DDINPUT_TOP_FRAME           CGRectMake(0, CONTENT_HEIGHT - self.chatInputView.height + NAVBAR_HEIGHT - WPKeyboardHeight, FULL_WIDTH, self.chatInputView.height)
#define DDUTILITY_FRAME             CGRectMake(0, CONTENT_HEIGHT + NAVBAR_HEIGHT - WPKeyboardHeight, FULL_WIDTH, WPKeyboardHeight)
#define DDEMOTION_FRAME             CGRectMake(0, CONTENT_HEIGHT + NAVBAR_HEIGHT- WPKeyboardHeight, FULL_WIDTH, WPKeyboardHeight)
#define DDCOMPONENT_BOTTOM          CGRectMake(0, CONTENT_HEIGHT + NAVBAR_HEIGHT, FULL_WIDTH, WPKeyboardHeight)

@interface ChattingMainViewController ()<UIGestureRecognizerDelegate,HPGrowingTextViewDelegate,takeVideoBack>
@property(nonatomic,assign)CGPoint inputViewCenter;
@property(nonatomic,assign)BOOL ifScrollBottom;
@property(assign)PanelStatus panelStatus;
@property(strong)NSString *chatObjectID;
@property(strong) UIButton *titleBtn ;
@property (nonatomic, strong)UIView*editBottomView;
@property (nonatomic, strong)NSMutableArray * choiseMoreArray;
@property (nonatomic, assign)BOOL isOrNotRefresh;
@property (nonatomic, copy)NSString* tranmitToUserId;//当前聊天的对方
@property (nonatomic, strong)NSIndexPath*deleteIndexpath;
@property (nonatomic, strong)MTTMessageEntity * deleteMessage;
@property (nonatomic, copy)NSString * deleteType;
@property (nonatomic, assign)BOOL isBlackNameOrNot;//是否进入黑名单
@property (nonatomic, assign) BOOL isDeleteOrNot;//把我删除而我的好友列表中还有他
@property (nonatomic, assign) int upLoadNumber;
@property (nonatomic, assign) BOOL receiveMessage;
@property (nonatomic, strong) NSMutableArray * collectionMuarray;//收藏

- (UITableViewCell*)p_textCell_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(MTTMessageEntity*)message;
- (UITableViewCell*)p_voiceCell_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(MTTMessageEntity*)message;
- (UITableViewCell*)p_promptCell_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(DDPromptEntity*)prompt;
- (void)n_receiveMessage:(NSNotification*)notification;
- (void)p_clickThRecordButton:(UIButton*)button;
- (void)p_record:(UIButton*)button;
- (void)p_willCancelRecord:(UIButton*)button;
- (void)p_cancelRecord:(UIButton*)button;
- (void)p_sendRecord:(UIButton*)button;
- (void)p_endCancelRecord:(UIButton*)button;
- (void)p_tapOnTableView:(UIGestureRecognizer*)sender;
- (void)p_hideBottomComponent;
- (void)p_enableChatFunction;
- (void)p_unableChatFunction;
@end

@implementation ChattingMainViewController

{
    TouchDownGestureRecognizer* _touchDownGestureRecognizer;
    NSString* _currentInputContent;
    UIButton *_recordButton;
    DDBottomShowComponent _bottomShowComponent;
    float _inputViewY;
    int _type;
    BOOL _wasKeyboardManagerEnabled;
    MPMoviePlayerViewController * mpPlayer;
    NSProgress * progress;
}
+(instancetype )shareInstance
{
    static dispatch_once_t onceToken;
    static ChattingMainViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [ChattingMainViewController new];
    });
    return _sharedManager;
}
//-(NSMutableArray*)choiseMoreArray
//{
//    if (!_choiseMoreArray)
//    {
//        _choiseMoreArray = [NSMutableArray array];
//    }
//    return _choiseMoreArray;
//}

- (void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
    //    UISaveVideoAtPathToSavedPhotosAlbum(NSString *videoPath, __nullable id completionTarget, __nullable SEL completionSelector, void * __nullable contextInfo)
    //保存到相册
    //    UISaveVideoAtPathToSavedPhotosAlbum(filePaht, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    [self sendLitterVideo:filePaht];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(DDINPUT_BOTTOM_FRAME, location))
    {
        return NO;
    }
    return YES;
    
}
#pragma mark 从收藏中发送说说
-(void)sendPersonDay:(NSArray*)array
{
    if (array.count == 1)
    {
        NSDictionary * dic = @{@"display_type":@"11",@"content":array[0]};//cardDic
        NSError * error = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
        NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity * personCard = [MTTMessageEntity makeMessage:cardStr Module:self.module MsgType:DDMEssageSHuoShuo];
        //        [self.tableView reloadData];
        //        [self scrollToBottomAnimated:YES];
        [[MTTDatabaseUtil instance] insertMessages:@[personCard] success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        personCard.msgContent =cardStr;
        [self sendMessage:cardStr messageEntity:personCard];
    }
    else
    {
        NSMutableArray * muarray = [NSMutableArray array];
        for ( NSDictionary * dictionary  in array)
        {
            NSDictionary * dic = @{@"display_type":@"11",@"content":dictionary};//cardDic
            NSError * error = nil;
            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
            NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            MTTMessageEntity * personCard = [MTTMessageEntity makeMessage:cardStr Module:self.module MsgType:DDMEssageSHuoShuo];
            [muarray addObject:personCard];
        }
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
        [[MTTDatabaseUtil instance] insertMessages:muarray success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        for (int i = 0 ; i < array.count; i++) {
            NSDictionary * dic = @{@"display_type":@"11",@"content":array[i]};//cardDic
            NSError * error = nil;
            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
            NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            MTTMessageEntity * personCard = muarray[i];
            personCard.msgContent = cardStr;
            [self sendMessage:cardStr messageEntity:personCard];
        }
    }
}
-(void)threadSendData:(NSDictionary*)dictionary
{
    NSLock * lock = [[NSLock alloc]init];
    [lock lock];
    NSArray * array = [dictionary allKeys];
    NSString * string = [NSString stringWithFormat:@"%@",array[0]];
    NSArray * sendArray = [dictionary objectForKey:string];
    if ([string isEqualToString:@"textarray"]) {
        [self sendTextFromCollection:sendArray];
    }
    else if ([string isEqualToString:@"shuoshuoarray"])
    {
        [self sendPersonDay:sendArray];
    }
    else if ([string isEqualToString:@"muchwang"])
    {
        [self sendMuchWant:sendArray andApply:NO];
    }
    else if ([string isEqualToString:@"muchapply"])
    {
        [self sendMuchApplyAndWant:sendArray andApply:YES];
    }
    else if ([string isEqualToString:@"applyarray"])
    {
        [self sendMyApplyAndWant:sendArray andApply:YES];
    }
    else if ([string isEqualToString:@"wantarray"])
    {
        [self sendMyWant:sendArray andApply:NO];
    }
    else if ([string isEqualToString:@"muchCollection"])//发送批量收藏
    {
        [self sendeMuchCollection:sendArray];
    }
    else
    {
        [self sendePersonalCard:sendArray];
    }
    [lock unlock];
}
//、、muchCollection
#pragma mark 从收藏中发送多种多个
-(void)sendDictionaryFromCollection:(NSDictionary*)dictionary//muchCollection
{
    NSArray * array = [dictionary allKeys];
    for (NSString * string  in array) {
        NSDictionary * dic = @{string:[dictionary objectForKey:string]};
        NSThread * thresd = [[NSThread alloc]initWithTarget:self selector:@selector(threadSendData:) object:dic];
        [thresd start];
    }
}
#pragma mark 从收藏中发送多个简历合并
-(void)sendMuchWant:(NSArray*)array andApply:(BOOL)apply
{
    if (array.count == 1)
    {
        NSDictionary * dic = @{@"display_type":@"10",@"content":array[0]};//cardDic
        NSError * error = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
        NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity * personCard = [MTTMessageEntity makeMessage:cardStr Module:self.module MsgType:DDMEssageMuchMyWantAndApply];
        //        [self.tableView reloadData];
        //        [self scrollToBottomAnimated:YES];
        [[MTTDatabaseUtil instance] insertMessages:@[personCard] success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        personCard.msgContent =cardStr;
        [self sendMessage:cardStr messageEntity:personCard];
    }
    else
    {
        NSMutableArray * muArray = [NSMutableArray array];
        for (NSDictionary * cardDic  in array)
        {
            NSDictionary * dic = @{@"display_type":@"10",@"content":cardDic};//cardDic
            NSError * error = nil;
            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
            NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            MTTMessageEntity * personCard = [MTTMessageEntity makeMessage:cardStr Module:self.module MsgType:DDMEssageMuchMyWantAndApply];
            [muArray addObject:personCard];
        }
        
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
        [[MTTDatabaseUtil instance] insertMessages:muArray success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        
        for (int i = 0 ; i < array.count; i++) {
            NSDictionary * dic = @{@"display_type":@"10",@"content":array[i]};//cardDic
            NSError * error = nil;
            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
            NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            MTTMessageEntity * personCard = muArray[i];
            personCard.msgContent = cardStr;
            [self sendMessage:cardStr messageEntity:personCard];
        }
    }
}
#pragma mark 从收藏中发送多个招聘合并
-(void)sendMuchApplyAndWant:(NSArray*)array andApply:(BOOL)apply
{
    if (array.count == 1)
    {
        NSDictionary * dic = @{@"display_type":@"10",@"content":array[0]};//cardDic
        NSError * error = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
        NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity * personCard = [MTTMessageEntity makeMessage:cardStr Module:self.module MsgType:DDMEssageMuchMyWantAndApply];
        //        [self.tableView reloadData];
        //        [self scrollToBottomAnimated:YES];
        [[MTTDatabaseUtil instance] insertMessages:@[personCard] success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        personCard.msgContent =cardStr;
        [self sendMessage:cardStr messageEntity:personCard];
    }
    else
    {
        NSMutableArray * muArray = [NSMutableArray array];
        for (NSDictionary * cardDic  in array)
        {
            NSDictionary * dic = @{@"display_type":@"10",@"content":cardDic};//cardDic
            NSError * error = nil;
            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
            NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            MTTMessageEntity * personCard = [MTTMessageEntity makeMessage:cardStr Module:self.module MsgType:DDMEssageMuchMyWantAndApply];
            [muArray addObject:personCard];
        }
        
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
        [[MTTDatabaseUtil instance] insertMessages:muArray success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        
        for (int i = 0 ; i < array.count; i++) {
            NSDictionary * dic = @{@"display_type":@"10",@"content":array[i]};//cardDic
            NSError * error = nil;
            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
            NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            MTTMessageEntity * personCard = muArray[i];
            personCard.msgContent = cardStr;
            [self sendMessage:cardStr messageEntity:personCard];
        }
    }
}
-(void)sendeMuchCollection:(NSArray*)array
{
    for (NSDictionary*dictionary in array)
    {
        NSDictionary * dic = @{@"display_type":@"15",@"content":dictionary};//cardDic
        NSError * error = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
        NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity * personCard = [MTTMessageEntity makeMessage:cardStr Module:self.module MsgType:DDMEssageMuchCollection];
        [[MTTDatabaseUtil instance] insertMessages:@[personCard] success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        
        //        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
        personCard.msgContent =cardStr;
        [self sendMessage:cardStr messageEntity:personCard];
    }
}
#pragma mark  点击发送名片
-(void)sendePersonalCard:(NSArray*)cardArray
{
    if (cardArray.count == 1)
    {
        NSDictionary * dic = @{@"display_type":@"6",@"content":cardArray[0]};//cardDic
        NSError * error = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
        NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity * personCard = [MTTMessageEntity makeMessage:cardStr Module:self.module MsgType:DDMEssagePersonalaCard];
        //        [self.tableView reloadData];
        //        [self scrollToBottomAnimated:YES];
        [[MTTDatabaseUtil instance] insertMessages:@[personCard] success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        personCard.msgContent = cardStr;
        [self sendMessage:cardStr messageEntity:personCard];
    }
    else
    {
        NSMutableArray * muArray = [NSMutableArray array];
        for (NSDictionary * dictionary in cardArray)
        {
            NSDictionary * dic = @{@"display_type":@"6",@"content":dictionary};//cardDic
            NSError * error = nil;
            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
            NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            MTTMessageEntity * personCard = [MTTMessageEntity makeMessage:cardStr Module:self.module MsgType:DDMEssagePersonalaCard];
            [muArray addObject:personCard];
        }
        
        
        [[MTTDatabaseUtil instance] insertMessages:muArray success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
        for (int i = 0 ;i < cardArray.count;i++)
        {
            NSDictionary * dic = @{@"display_type":@"6",@"content":cardArray[i]};//cardDic
            NSError * error = nil;
            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
            NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            MTTMessageEntity * personCard = muArray[i];
            personCard.msgContent = cardStr;
            [self sendMessage:cardStr messageEntity:personCard];
        }
    }
}
-(void)sendMyWant:(NSArray*)array andApply:(BOOL)apply
{
    if (array.count == 1)
    {
        NSDictionary * dic = @{@"display_type":apply?@"8":@"9",@"content":array[0]};//cardDic
        NSError * error = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
        NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity * personCard = [MTTMessageEntity makeMessage:cardStr Module:self.module MsgType:apply?DDMEssageMyApply:DDMEssageMyWant];
        //        [self.tableView reloadData];
        //        [self scrollToBottomAnimated:YES];
        [[MTTDatabaseUtil instance] insertMessages:@[personCard] success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        personCard.msgContent =cardStr;
        [self sendMessage:cardStr messageEntity:personCard];
        
    }
    else
    {
        NSMutableArray * muArray = [NSMutableArray array];
        for (NSDictionary * dictionary in array)
        {
            NSDictionary * dic = @{@"display_type":apply?@"8":@"9",@"content":dictionary};//cardDic
            NSError * error = nil;
            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
            NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            MTTMessageEntity * personCard = [MTTMessageEntity makeMessage:cardStr Module:self.module MsgType:apply?DDMEssageMyApply:DDMEssageMyWant];
            [muArray addObject:personCard];
        }
        
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
        
        for (int i = 0 ; i < array.count; i++) {
            NSDictionary * dic = @{@"display_type":apply?@"8":@"9",@"content":array[i]};//cardDic
            NSError * error = nil;
            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
            NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            MTTMessageEntity * personCard = muArray[i];
            personCard.msgContent = cardStr;
            [self sendMessage:cardStr messageEntity:personCard];
        }
    }
    
}
#pragma mark  点击发送求职和招聘
-(void)sendMyApplyAndWant:(NSArray*)array andApply:(BOOL)apply
{
    if (array.count == 1)
    {
        NSDictionary * dic = @{@"display_type":apply?@"8":@"9",@"content":array[0]};//cardDic
        NSError * error = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
        NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity * personCard = [MTTMessageEntity makeMessage:cardStr Module:self.module MsgType:apply?DDMEssageMyApply:DDMEssageMyWant];
        //        [self.tableView reloadData];
        //        [self scrollToBottomAnimated:YES];
        [[MTTDatabaseUtil instance] insertMessages:@[personCard] success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        personCard.msgContent =cardStr;
        [self sendMessage:cardStr messageEntity:personCard];
    }
    else
    {
        NSMutableArray * muArray = [NSMutableArray array];
        for (NSDictionary * dictionary in array)
        {
            NSDictionary * dic = @{@"display_type":apply?@"8":@"9",@"content":dictionary};//cardDic
            NSError * error = nil;
            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
            NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            MTTMessageEntity * personCard = [MTTMessageEntity makeMessage:cardStr Module:self.module MsgType:apply?DDMEssageMyApply:DDMEssageMyWant];
            [muArray addObject:personCard];
        }
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
        
        for (int i = 0 ; i < array.count; i++) {
            NSDictionary * dic = @{@"display_type":apply?@"8":@"9",@"content":array[i]};//cardDic
            NSError * error = nil;
            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
            NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            MTTMessageEntity * personCard = muArray[i];
            personCard.msgContent = cardStr;
            [self sendMessage:cardStr messageEntity:personCard];
        }
    }
    //    for (NSDictionary*cardDic in array) {
    //        NSDictionary * dic = @{@"display_type":apply?@"8":@"9",@"content":cardDic};//cardDic
    //        NSError * error = nil;
    //        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
    //        NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //        MTTMessageEntity * personCard = [MTTMessageEntity makeMessage:cardStr Module:self.module MsgType:apply?DDMEssageMyApply:DDMEssageMyWant];
    //        [self.tableView reloadData];
    //        [self scrollToBottomAnimated:YES];
    //        [[MTTDatabaseUtil instance] insertMessages:@[personCard] success:^{
    //            DDLog(@"消息插入DB成功");
    //        } failure:^(NSString *errorDescripe) {
    //            DDLog(@"消息插入DB失败");
    //        }];
    //        personCard.msgContent =cardStr;
    //        [self sendMessage:cardStr messageEntity:personCard];
    //    }
}
#pragma mark 从收藏中发送图片
-(void)sendPhototFromCollection:(NSString*)urlStr
{
    urlStr = [urlStr stringByReplacingOccurrencesOfString:IPADDRESS withString:@""];
    UIImageView * imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,urlStr]]];
    UIImage * image1 = imageView.image;
    
    __block MTTPhotoEnity *photo = [MTTPhotoEnity new];
    NSString *keyName = [[MTTPhotosCache sharedPhotoCache] getKeyName];
    photo.localPath=keyName;
    
    NSDictionary* messageContentDic = @{DD_IMAGE_LOCAL_KEY:photo.localPath};
    NSString* messageContent = [messageContentDic jsonString];
    
    MTTMessageEntity *message = [MTTMessageEntity makeMessage:messageContent Module:self.module MsgType:DDMessageTypeImage];
    //    [self.tableView reloadData];
    //    [self scrollToBottomAnimated:YES];
    
    
    NSData *photoData = UIImagePNGRepresentation(image1);
    [[MTTPhotosCache sharedPhotoCache] storePhoto:photoData forKey:photo.localPath toDisk:YES];
    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
        DDLog(@"消息插入DB成功");
    } failure:^(NSString *errorDescripe) {
        DDLog(@"消息插入DB失败");
    }];
    
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
    
    urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,urlStr];
    urlStr = [NSString stringWithFormat:@"%@%@",DD_MESSAGE_IMAGE_PREFIX,urlStr];
    urlStr = [NSString stringWithFormat:@"%@%@",urlStr,DD_MESSAGE_IMAGE_SUFFIX];
    
    NSString * content = [NSString stringWithFormat:@"%@",message.msgContent];
    NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSMutableDictionary * muDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    [muDic setValue:urlStr forKey:DD_IMAGE_URL_KEY];
    NSData * data1 = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * contentStr = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    message.msgContent = contentStr;
    
    [self sendMessage:urlStr messageEntity:message];
    [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
    }];
    
    //    NSDictionary* messageContentDic = @{@"display_type":@"2",@"url":[NSString stringWithFormat:@"%@%@",IPADDRESS,urlStr]};
    //    NSString* messageContent = [messageContentDic jsonString];
    //    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,urlStr]];
    //
    //    //将图片写入内存中
    //    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    //    [manager downloadImageWithURL:url options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    //    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
    //        [manager saveImageToCache:image forURL:imageURL];
    //
    //
    //        MTTMessageEntity *message = [MTTMessageEntity makeMessage:messageContent Module:self.module MsgType:DDMessageTypeImage];
    //        [self.tableView reloadData];
    //        [self scrollToBottomAnimated:YES];
    //
    //        [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
    //            DDLog(@"消息插入DB成功");
    //        } failure:^(NSString *errorDescripe) {
    //            DDLog(@"消息插入DB失败");
    //        }];
    //        [self sendMessage:urlStr messageEntity:message];
    //        [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
    //        }];
    //    }];
}
#pragma mark 从收藏中发送小视频
-(void)sendVideoFromCollection:(NSString*)videoStr
{
    NSDictionary * dic = @{@"url":videoStr};
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * content = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    MTTMessageEntity *message = [MTTMessageEntity makeMessage:content Module:self.module MsgType:DDMEssageLitterVideo];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
    
    message.msgContent = content;
    [self sendMessage:@"" messageEntity:message];
    [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
    }];
}
#pragma mark 点击发送小视频
-(void)sendLitterVideo:(NSString*)filePath
{
    
    
    NSDictionary* dic = @{DD_IMAGE_LOCAL_KEY:filePath};
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * content = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    MTTMessageEntity *message = [MTTMessageEntity makeMessage:content Module:self.module MsgType:DDMEssageLitterVideo];
    //    [self.tableView reloadData];
    //    [self scrollToBottomAnimated:YES];
    
    UIImage * image = [UIImage getImage:filePath];
    NSData * photoData = UIImageJPEGRepresentation(image, 1.0);
    [[MTTPhotosCache sharedPhotoCache] storePhoto:photoData forKey:filePath toDisk:YES];
    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
        NSLog(@"插入成功");
    } failure:^(NSString *errorDescripe) {
        NSLog(@"插入失败");
    }];
    
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
    [[DDSendPhotoMessageAPI sharedPhotoCache] uploadVideo:filePath success:^(NSString *videoUrl) {
        NSArray * array = [videoUrl componentsSeparatedByString:@","];
        videoUrl = [NSString stringWithFormat:@"%@",array[0]];
        
        
        [[MTTPhotosCache sharedPhotoCache] storePhoto:photoData forKey:videoUrl toDisk:YES];
        //将发送的视频写到本地文件
        NSArray *specialUrlArr = [videoUrl componentsSeparatedByString:@"/"];
        NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
        NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
        NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
        
        NSData * data1 = [NSData dataWithContentsOfFile:filePath];
        [data1 writeToFile:fileName1 atomically:YES];
        //获取截图并保存到本地
        
        
        [self scrollToBottomAnimated:YES];
        message.state=DDMessageSending;
        
        //        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        //        [manager saveImageToCache:image forURL:[NSURL URLWithString:videoUrl]];
        
        NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
        NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * contentDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSMutableDictionary * muDic = [[NSMutableDictionary alloc]initWithDictionary:contentDic];
        [muDic setValue:[IPADDRESS stringByAppendingString:videoUrl] forKey:DD_IMAGE_URL_KEY];
        
        NSData * dicData = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString * contentString = [[NSString alloc]initWithData:dicData encoding:NSUTF8StringEncoding];
        message.msgContent = contentString;
        [self sendMessage:videoUrl messageEntity:message];
        [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
        }];
    } failure:^(id error) {
        message.state = DDMessageSendFailure;
        NSData * videoData = [NSData dataWithContentsOfFile:filePath];
        [videoData writeToFile:filePath atomically:YES];
        
        message.msgContent = content;
        [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
            if (result)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            }
        }];
    }];
}
#pragma mark - 点击发送图片
-(void)sendImageMessage:(MTTPhotoEnity *)photo Image:(UIImage *)image
{
    NSDictionary* messageContentDic = @{DD_IMAGE_LOCAL_KEY:photo.localPath};
    NSString* messageContent = [messageContentDic jsonString];
    MTTMessageEntity *message = [MTTMessageEntity makeMessage:messageContent Module:self.module MsgType:DDMessageTypeImage];
    NSData *photoData = UIImageJPEGRepresentation(image, 0.1);
    [[MTTPhotosCache sharedPhotoCache] storePhoto:photoData forKey:photo.localPath toDisk:YES];
    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
        DDLog(@"消息插入DB成功");
    } failure:^(NSString *errorDescripe) {
        DDLog(@"消息插入DB失败");
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
    });
    
    photo=nil;
    //将图片上传获取图片的地址
    [[DDSendPhotoMessageAPI sharedPhotoCache] uploadImage:messageContentDic[DD_IMAGE_LOCAL_KEY] success:^(NSString *imageURL) {
        //将图片数据保存到本地
        NSString *urlStr = [NSString stringWithFormat:@"%@",imageURL];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"&$#@~^@[{:" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@":}]&$~@#@" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
        NSArray * array1 = [urlStr componentsSeparatedByString:@"/"];
        NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:pictureAddress];
        NSString * filePath = [NSString stringWithFormat:@"%@/%@",savePath,array1[array1.count-1]];
        [photoData writeToFile:filePath atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scrollToBottomAnimated:YES];
        });
        
        message.state=DDMessageSending;
        NSString *string = [imageURL stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
        NSDictionary* tempMessageContent = [NSDictionary initWithJsonString:message.msgContent];
        NSMutableDictionary* mutalMessageContent = [[NSMutableDictionary alloc] initWithDictionary:tempMessageContent];
        [mutalMessageContent setValue:string forKey:DD_IMAGE_URL_KEY];
        NSString* messageContent = [mutalMessageContent jsonString];
        message.msgContent = messageContent;
        
        [self sendMessage:string messageEntity:message];
        [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
        }];
    } failure:^(id error) {
        message.state = DDMessageSendFailure;
        //刷新DB
        [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
            if (result)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            }
        }];
    }];
}

#pragma mark - 返回消息主界面
- (void)backToFromViewController:(UIButton *)sender
{
    if (self.editBottomView.hidden)
    {
        if ([[self.navigationController viewControllers] containsObject:[RecentUsersViewController shareInstance]]) {
            [self.navigationController popToViewController:[RecentUsersViewController shareInstance] animated:YES];
        }else
        {
            //          [self.navigationController popViewControllerAnimated:YES];
            if (self.isFromZhiChangCreat)
            {
                
                [[self.navigationController viewControllers] enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull controler, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([NSStringFromClass([WPDynamicGroupViewController class]) isEqualToString:NSStringFromClass(controler.class)]) {
                        //                        [self.navigationController popToViewController:controler animated:YES];
                        *stop = YES;
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        return;
                    }else if ((idx + 1) == self.navigationController.viewControllers.count){
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
                
                
                //                WPMainController * main = [[WPMainController alloc]init];
                //                main.selectedIndex = 0;
                
            }
            else
            {
                NSArray * array = self.navigationController.viewControllers;
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else
    {
        self.editBottomView.hidden = YES;
        self.isMore = NO;
        [self.tableView reloadData];
        for (id objc in self.module.showingMessages)
        {
            if ([objc isKindOfClass:[MTTMessageEntity class]]) {
                MTTMessageEntity * message = (MTTMessageEntity*)objc;
                message.itemSelected = NO;
            }
            
        }
    }
    
    
    //    if ([[self.navigationController viewControllers] containsObject:[RecentUsersViewController shareInstance]]) {
    //        [self.navigationController popToViewController:[RecentUsersViewController shareInstance] animated:YES];
    //    }else
    //    {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
    //隐藏键盘
    [self p_tapOnTableView:nil];
    
    
}

- (void)textViewChanged
{
    //2016  chenchao 发送通知  让发送按钮可以点击
    //1.发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshReleaseButton" object:self userInfo:nil];
    if (self.chatInputView.textView.text.length == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshReleaseBtnWhenDelete" object:self userInfo:nil];
    }
    
    NSRange range = self.chatInputView.textView.selectedRange;
    NSInteger location = range.location;
    __block NSString* text = [self.chatInputView.textView text];
    if(location){
        __block NSRange range = NSMakeRange(location-1, 1);
        NSString* lastText =  [text substringWithRange:range];
        if([lastText isEqualToString:@"@"]){
            self.isGotoAt = YES;
            ContactsViewController *contact = [ContactsViewController new];
            contact.isFromAt=YES;
            contact.selectUser =^(MTTUserEntity *user){
                NSString *atName = [NSString stringWithFormat:@"@%@ ",user.nick];
                text = [text stringByReplacingCharactersInRange:range withString:atName];
                [self.chatInputView.textView setText:text];
            };
            [self.navigationController pushViewController:contact animated:YES];
        }
    }
}

#pragma mark - 点击发送消息
- (void)textViewEnterSend
{
    //发送消息
    NSString* text = [self.chatInputView.textView text];
    
    NSString* parten = @"\\s";
    NSRegularExpression* reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:nil];
    NSString* checkoutText = [reg stringByReplacingMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length]) withTemplate:@""];
    if ([checkoutText length] == 0)
    {
        return;
    }
    DDMessageContentType msgContentType = DDMessageTypeText;
    MTTMessageEntity *message = [MTTMessageEntity makeMessage:text Module:self.module MsgType:msgContentType];
    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
        DDLog(@"消息插入DB成功");
    } failure:^(NSString *errorDescripe) {
        DDLog(@"消息插入DB失败");
    }];
    //将字符串消息转换成字典
    NSString * contentStr = [self getStringFromDic:[NSString stringWithFormat:@"%@",message.msgContent]];
    message.msgContent = contentStr;
    
    
    //  [self.tableView reloadData];
    //  [self scrollToBottomText:YES];
    [self.chatInputView.textView setText:nil];
    [self sendMessage:text messageEntity:message];
}
#pragma mark 从收藏界面发送文字
-(void)sendTextFromCollection:(NSArray*)array
{
    if (array.count == 1)
    {
        DDMessageContentType msgContentType = DDMessageTypeText;
        MTTMessageEntity *message = [MTTMessageEntity makeMessage:array[0] Module:self.module MsgType:msgContentType];
        
        [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
        //将字符串消息转换成字典
        NSString * contentStr = [self getStringFromDic:[NSString stringWithFormat:@"%@",message.msgContent]];
        message.msgContent = contentStr;
        [self sendMessage:array[0] messageEntity:message];
    }
    else
    {
        NSMutableArray * muarray = [NSMutableArray array];
        for (NSString * string in array) {
            DDMessageContentType msgContentType = DDMessageTypeText;
            MTTMessageEntity *message = [MTTMessageEntity makeMessage:string Module:self.module MsgType:msgContentType];
            [muarray addObject:message];
        }
        
        [[MTTDatabaseUtil instance] insertMessages:muarray success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        for (int i = 0; i < array.count; i++) {
            MTTMessageEntity *message = muarray[i];
            NSString * contentStr = [self getStringFromDic:[NSString stringWithFormat:@"%@",message.msgContent]];
            message.msgContent = contentStr;
            [self sendMessage:array[i] messageEntity:message];
        }
    }
    
    //    DDMessageContentType msgContentType = DDMessageTypeText;
    //    MTTMessageEntity *message = [MTTMessageEntity makeMessage:text Module:self.module MsgType:msgContentType];
    //
    //    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
    //        DDLog(@"消息插入DB成功");
    //    } failure:^(NSString *errorDescripe) {
    //        DDLog(@"消息插入DB失败");
    //    }];
    //
    //    //将字符串消息转换成字典
    //    NSString * contentStr = [self getStringFromDic:[NSString stringWithFormat:@"%@",message.msgContent]];
    //    message.msgContent = contentStr;
    //    [self.tableView reloadData];
    //    [self sendMessage:text messageEntity:message];
}
#pragma mark 将消息的字符串转换成字典
-(NSString *)getStringFromDic:(NSString*)contentStr
{
    NSDictionary * dic = @{@"display_type":@"1",@"content":contentStr};
    NSError * erreo = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&erreo];
    NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

#pragma mark 将图片的字符串转换成字典
-(NSString *)getStringFromImageDic:(NSString*)contentStr
{
    NSDictionary * dic = @{@"display_type":@"2",@"content":contentStr};
    NSError * erreo = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&erreo];
    NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

- (void)sendPrompt:(NSString*)prompt
{
    [self.module addPrompt:prompt];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

#pragma mark  往服务器发非语音信息
-(void)sendMessage:(NSString *)msg messageEntity:(MTTMessageEntity *)message
{
    //被拉入黑名单
    if (self.isBlackNameOrNot)
    {
        DDMessageContentType msgContentType = DDMEssageLitterInviteAndApply;
        NSDictionary * dictionary = @{@"display_type":@"12",
                                      @"content":@{@"for_userid":@"",
                                                   @"for_username":@"",
                                                   @"note_type":@"8",
                                                   @"create_userid":kShareModel.userId,
                                                   @"create_username":kShareModel.username
                                                   ,
                                                   @"for_user_info_1":@"",
                                                   @"for_user_info_0":@""
                                                   }
                                      };
        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity *blackMessage = [MTTMessageEntity makeMessage:contentStr Module:self.module MsgType:msgContentType];
        [[MTTDatabaseUtil instance] insertMessages:@[blackMessage] success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        blackMessage.msgContent = contentStr;
        message.state = DDMessageSendFailure;
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
        self.module.MTTSessionEntity.lastMsg = blackMessage.msgContent;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SentMessageSuccessfull" object:self.module.MTTSessionEntity];
        return;
    }
    
    if (self.isDeleteOrNot) {
        DDMessageContentType msgContentType = DDMEssageLitterInviteAndApply;
        NSDictionary * dictionary = @{@"display_type":@"12",
                                      @"content":@{@"for_userid":@"",
                                                   @"for_username":@"",
                                                   @"note_type":@"9",
                                                   @"create_userid":kShareModel.userId,
                                                   @"create_username":kShareModel.username,
                                                   @"for_user_info_1":@"",
                                                   @"for_user_info_0":@""
                                                   }
                                      };
        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity *blackMessage = [MTTMessageEntity makeMessage:contentStr Module:self.module MsgType:msgContentType];
        [[MTTDatabaseUtil instance] insertMessages:@[blackMessage] success:^{
            DDLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            DDLog(@"消息插入DB失败");
        }];
        blackMessage.msgContent = contentStr;
        message.state = DDMessageSendFailure;
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
        self.module.MTTSessionEntity.lastMsg = blackMessage.msgContent;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SentMessageSuccessfull" object:self.module.MTTSessionEntity];
        return;
    }
    //网络未连接时发送消息失败
    DDUserState userState = [DDClientState shareInstance].userState;
    if (userState == DDUserKickout || userState==DDUserOffLine||userState==DDUserOffLineInitiative) {
        message.state = DDMessageSendFailure;
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
        
        BOOL isGroup = [self.module.MTTSessionEntity isGroup];
        if ([message isImageMessage]) {
            self.module.MTTSessionEntity.lastMsg=@"[图片]";
        }else if ([message isVoiceMessage])
        {
            self.module.MTTSessionEntity.lastMsg=@"[语音]";
        }
        else if ([message isPersonCard])
        {
            self.module.MTTSessionEntity.lastMsg = message.msgContent;
        }
        else
        {
            self.module.MTTSessionEntity.lastMsg = message.msgContent;
        }
        if (isGroup)
        {
            self.module.MTTSessionEntity.lastMesageName = kShareModel.nick_name;
        }
        self.module.MTTSessionEntity.lastMsgID=message.msgID;
        self.module.MTTSessionEntity.timeInterval=message.msgTime;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addSessionSuccess" object:nil];
        return;
    }
    
    //自己发给自己
    if ([message.senderId isEqualToString:message.toUserID]) {
        message.state = DDmessageSendSuccess;
        self.module.MTTSessionEntity.lastMsg = message.msgContent;
        self.module.MTTSessionEntity.lastMsgID=message.msgID;
        self.module.MTTSessionEntity.timeInterval=message.msgTime;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SentMessageSuccessfull" object:nil];
        [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
        } failure:^(NSString *errorDescripe) {
        }];
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
    });
    
    BOOL isGroup = [self.module.MTTSessionEntity isGroup];
    
    
    NSLog(@"%@====%@",self.module.MTTSessionEntity.lastMesageName,self.module.MTTSessionEntity.sessionID);
    
    //DDMessageSendManager 发消息 --> 网服务器(非语音)
    [[DDMessageSendManager instance] sendMessage:message isGroup:isGroup Session:self.module.MTTSessionEntity  completion:^(MTTMessageEntity* theMessage,NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            message.state= theMessage.state;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    } Error:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self scrollToBottomText:YES];
            DDClientState* clientState = [DDClientState shareInstance];
            if (clientState.networkState == DDNetWorkDisconnect) {
                [MBProgressHUD createHUD:@"请检查网络!" View:self.view];
            }
        });
        
        //        [self.tableView reloadData];
        //        [self scrollToBottomText:YES];
        //        DDClientState* clientState = [DDClientState shareInstance];
        //        if (clientState.networkState == DDNetWorkDisconnect) {
        //            [MBProgressHUD createHUD:@"请检查网络!" View:self.view];
        //        }
        
    }];
}
//----------------------------- ---------------------------------------------------------------
#pragma mark -
#pragma mark RecordingDelegate语音 发送语音
- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval
{
    NSMutableData* muData = [[NSMutableData alloc] init];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    int length = [RecorderManager sharedManager].recordedTimeInterval;
    if (length < 1 )
    {
        DDLog(@"录音时间太短");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_recordingView setHidden:NO];
            [_recordingView setRecordingState:DDShowRecordTimeTooShort];
        });
        return;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_recordingView setHidden:YES];
        });
    }
    int8_t ch[4];
    for(int32_t i = 0;i<4;i++){
        ch[i] = ((length >> ((3 - i)*8)) & 0x0ff);
    }
    [muData appendBytes:ch length:4];
    [muData appendData:data];
    DDMessageContentType msgContentType = DDMessageTypeVoice;
    MTTMessageEntity* message = [MTTMessageEntity makeMessage:filePath Module:self.module MsgType:msgContentType];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
    });
    
    BOOL isGroup = [self.module.MTTSessionEntity isGroup];
    if (isGroup) {
        message.msgType=MsgTypeMsgTypeGroupAudio;
    }else
    {
        message.msgType = MsgTypeMsgTypeSingleAudio;
    }
    [message.info setObject:@(length) forKey:VOICE_LENGTH];
    [message.info setObject:@"1" forKey:DDVOICE_PLAYED];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollToBottomAnimated:YES];
        [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
            NSLog(@"消息插入DB成功");
        } failure:^(NSString *errorDescripe) {
            NSLog(@"消息插入DB失败");
        }];
        
    });
    
    //DDMessageSendManager 发送给语音信息
    [[DDMessageSendManager instance] sendVoiceMessage:muData filePath:filePath forSessionID:self.module.MTTSessionEntity.sessionID isGroup:isGroup Message:message Session:self.module.MTTSessionEntity completion:^(MTTMessageEntity *theMessage, NSError *error) {
        if (!error)
        {
            DDLog(@"发送语音消息成功");
            [[PlayerManager sharedManager] playAudioWithFileName:@"msg.caf" playerType:DDSpeaker delegate:self];
            message.state = DDmessageSendSuccess;
            [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            }];
        }
        else
        {
            DDLog(@"发送语音消息失败");
            message.state = DDMessageSendFailure;
            [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
                
            }];
            
        }
    }];
}

#pragma mark  停止播放语音代理
- (void)playingStoped
{
    //关闭距离监听
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.titleBtn.frame=CGRectMake(0, 0, 150, 40);
        [self.titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.titleBtn addTarget:self action:@selector(titleTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return self;
}

-(void)notificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(n_receiveMessage:)
                                                 name:DDNotificationReceiveMessage
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillShowKeyboard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboard:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloginSuccess)
                                                 name:@"ReloginSuccess"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTranmitMoreSuccess) name:@"tranmitMoreMessageSuccess"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendeSamePeopl:) name:@"sendToSamePeople"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(upDateGroupSuccess:) name:@"UPDATEGROUPINFOSUCCESS"
                                               object:nil];
    //邀请别人进入是要刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ADDMEMEMBERSuccess:) name:@"INVITESUCCESS"
                                               object:nil];
    
    //发布群相册
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ADDMEMEMBERSuccess:) name:@"SENDARGUMENTSUCCESS"
                                               object:nil];
    //POPFROMINTERVIEW
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(POPFROMINTERVIEW:) name:@"POPFROMINTERVIEW"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearAllMessage)
                                                 name:@"CLEARALLCHATMESSAGE"
                                               object:nil];
    
    //加入移除黑名单或删除好友
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeOrBlack:)
                                                 name:@"DELETEORBLACKNAME"
                                               object:nil];
    //reloadPicture
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadPicture)
                                                 name:@"reloadPicture"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataAgain:) name:@"changeGroupSuccessMY" object:nil];
    
    //图片下载完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPicture1) name:@"loadThumbdImageSuccess" object:nil];
}

-(void)reloadPicture1
{
    [self.tableView reloadData];
    [self scrollToBottomText:YES];
}

-(void)reloadDataAgain:(NSNotification*)noti
{
    NSDictionary * dci = noti.userInfo;
    MTTMessageEntity * message = dci[@"message"];
    id objc = self.module.showingMessages[self.module.showingMessages.count-1];
    if ([objc isKindOfClass:[MTTMessageEntity class]]) {
        MTTMessageEntity * messag = (MTTMessageEntity*)objc;
        if (message.msgTime-messag.msgTime>300) {
            DDPromptEntity* prompt = [[DDPromptEntity alloc] init];
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:message.msgTime];
            prompt.message = [date promptDateString];
            [self.module.showingMessages addObject:prompt];
        }
    }
    [self.module.showingMessages addObject:message];
    [self.tableView reloadData];
    
}
-(void)reloadPicture
{
    [self.tableView reloadData];
}
-(void)removeOrBlack:(NSNotification*)noti
{
    NSDictionary* dic = (NSDictionary*)noti.object;
    NSString * friend_id = dic[@"friend_id"];
    NSString * friend_type = dic[@"friend_type"];
    if ([self.module.MTTSessionEntity.sessionID isEqualToString:[NSString stringWithFormat:@"user_%@",friend_id]]) {
        switch (friend_type.intValue) {
            case 0://拉入黑名单
                self.isBlackNameOrNot = YES;
                break;
            case 1://取消黑名单
                self.isBlackNameOrNot = NO;
                break;
            case 2://删除好友
                self.isDeleteOrNot = YES;
                break;
            case 3://直接添加好友成功
                self.isDeleteOrNot = NO;
                break;
            default:
                break;
        }
    }
}

-(void)clearAllMessage
{
    [self.module.showingMessages removeAllObjects];
    [self.tableView reloadData];
    
    MTTSessionEntity * deletesession = self.module.MTTSessionEntity;
    deletesession.lastMsg=@"暂无新消息";
    deletesession.lastMesageName  = @"";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMessageSuccessFull" object:deletesession];
}
-(void)POPFROMINTERVIEW:(NSNotification*)noti
{
    MTTSessionEntity * session = noti.object;
    [self showChattingContentForSession:session];
}
//相册页面操作完成,通知回调方法
-(void)ADDMEMEMBERSuccess:(NSNotification*)notifi
{
#pragma mark  消息发送成功之后,先将数据传送到服务器进行确认,确认加入成功之后,将保存到本地数据库中,然后刷新从本地数据库中再取出来数据,进行展示
    
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
    //    [self showChattingContentForSession:self.module.MTTSessionEntity];
    
}
-(void)upDateGroupSuccess:(NSNotification*)notification
{
    [self setThisViewTitle:(NSString*)notification.object] ;
}
#pragma mark 发送给同一个人
-(void)sendeSamePeopl:(NSNotification*)notifi
{
    id objc = [notifi object];
    if ([objc isKindOfClass:[NSMutableArray class]])
    {
        NSMutableArray * muarray = (NSMutableArray*)objc;
        for (MTTMessageEntity*message in muarray) {
            NSString * content = message.msgContent;
            NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            //            NSDictionary * dictionary = dic[@"content"];
            NSDictionary *dictionary = [NSDictionary dictionary];
            NSString * contentString = [NSString string];
            id objc = dic[@"content"];
            if ([objc isKindOfClass:[NSDictionary class]]) {
                dictionary = (NSDictionary*)objc;
            }
            else
            {
                contentString = (NSString*)objc;
            }
            if (dictionary.count) {
                NSData * data1 = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
                NSString * contentStr = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
                message.msgContent = contentStr;
            }
            else
            {
                
                message.msgContent = contentString;
            }
            //            NSData * data1 = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
            //            NSString * contentStr = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            //            message.msgContent = contentStr;
            message.state = DDmessageSendSuccess;
            [self.module.showingMessages addObject:message];
        }
    }
    else
    {
        MTTMessageEntity * message = (MTTMessageEntity*)[notifi object];
        NSString * content = message.msgContent;
        NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        //        NSDictionary * dictionary = dic[@"content"];
        //        NSData * data1 = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        //        NSString * contentStr = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        
        if (message.msgContentType == DDMessageTypeText || message.msgContentType == DDMessageTypeImage) {
            message.msgContent = dic[@"content"];
        }
        else
        {
            if (message.msgContentType == DDMEssageLitterVideo) {
                if (dic) {
                    NSString * urlStr = dic[@"url"];
                    [urlStr stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_PREFIX withString:@""];
                    [urlStr stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_SUFFIX withString:@""];
                    message.msgContent = urlStr;
                }
                else
                {
                    message.msgContent = [IPADDRESS stringByAppendingString:message.msgContent];
                    message.state = DDMessageSending;
                }
                
                
            }
            else
            {
                NSDictionary * dictionary = dic[@"content"];
                NSData * data1 = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
                NSString * contentStr = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
                message.msgContent = contentStr;
            }
        }
        message.state = DDmessageSendSuccess;
        [self.module.showingMessages addObject:message];
    }
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
    
}
#pragma mark发送更多成功是收到通知
-(void)receiveTranmitMoreSuccess
{
    
    self.editBottomView.hidden = YES;
    self.isMore = NO;
    [self.tableView reloadData];
    for (id objc in self.module.showingMessages)
    {
        if ([objc isKindOfClass:[MTTMessageEntity class]]) {
            MTTMessageEntity * message = (MTTMessageEntity*)objc;
            message.itemSelected = NO;
        }
        
    }
    [self scrollToBottomAnimated:YES];
}
-(void)popToMessage:(UIPanGestureRecognizer*)gesture
{
    
    //    CGFloat trantX = [gesture translationInView:self.tableView].x;
    //    if (trantX>=SCREEN_WIDTH/2) {
    [self.navigationController popToViewController:[RecentUsersViewController shareInstance] animated:YES];
    //    }
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //    if (self.isPushFromCreatQuick) {
    //        NSArray * viewArray = self.navigationController.viewControllers;
    //        NSMutableArray * muarray = [NSMutableArray array];
    //        [muarray addObjectsFromArray:viewArray];
    //        for (id objc in viewArray) {
    //            if ([objc isKindOfClass:[WPChooseLinkViewController class]]) {
    //                [muarray removeObject:objc];
    //                [self.navigationController setViewControllers:muarray];
    //            }
    //        }
    //    }
    [self notificationCenter];
    [self initialInput];
    
    [self.view addSubview:self.editBottomView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(p_tapOnTableView:)];
    self.singleTap = tap;
    [self.tableView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(p_tapOnTableView:)];
    pan.delegate = self;
    [self.tableView addGestureRecognizer:pan];
    // self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setBackgroundColor:RGB(235, 235, 235)];
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FULL_WIDTH, MTTRefreshViewHeight)];
    [headView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableHeaderView:headView];
    [self scrollToBottomAnimated:NO];
    [self initScrollView];
    
    //    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:self.module.MTTSessionEntity.sessionType == SessionTypeSessionTypeSingle ? @"chatmessagehao" : @"chatmessagequn"]
    //                                                             style:UIBarButtonItemStylePlain
    //                                                            target:self
    //                                                            action:@selector(Edit:)];
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setImage:[UIImage imageNamed:self.module.MTTSessionEntity.sessionType == SessionTypeSessionTypeSingle ? @"chatmessagehao" : @"chatmessagequn"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(Edit:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self.module addObserver:self
                  forKeyPath:@"showingMessages"
                     options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                     context:NULL];
    [self.module addObserver:self
                  forKeyPath:@"MTTSessionEntity.sessionID"
                     options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                     context:NULL];
    [self.navigationItem.titleView setUserInteractionEnabled:YES];
    self.view.backgroundColor=TTBG;
    
    if([TheRuntime.user.nick isEqualToString:@"蝎紫"]){
        UIImageView *chatBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [chatBgView setImage:[UIImage imageNamed:@"chatBg"]];
        [self.view insertSubview:chatBgView atIndex:0];
        self.tableView.backgroundView =chatBgView;
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.isGotoAt = NO;
    self.ifScrollBottom = YES;
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[ChattingMainViewController class]];
}

-(void)queryUserStat
{
    MTTUsersStatAPI *request = [MTTUsersStatAPI new];
    NSMutableArray *array = [NSMutableArray new];
    NSString *sessionId = self.module.MTTSessionEntity.sessionID;
    UInt32 uid = [MTTUserEntity localIDTopb:sessionId];
    [array addObject:@(uid)];
    [request requestWithObject:array Completion:^(NSArray *response, NSError *error) {
        //        if(response){
        //            NSMutableArray *narray = [NSMutableArray arrayWithArray:response];
        //            if([narray[0][1] intValue]== UserStatTypeUserStatusOnline){
        //            }
        //        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.isGotoAt){
        [self.chatInputView.textView setText:nil];
    }
    self.isGotoAt = NO;
    self.navigationItem.titleView=self.titleBtn;
    self.tableView.noMore =NO;
#pragma mark  判断是否在黑名单中
    self.isBlackNameOrNot = NO;
    self.isDeleteOrNot = NO;
    [[MTTDatabaseUtil instance] loadBlackNamecompletion:^(NSArray *array) {
        for (WPBlackNameModel * model in array)
        {
            if ([model.userId isEqualToString:self.module.MTTSessionEntity.sessionID]) {
                if ([model.state isEqualToString:@"2"])
                {
                    self.isDeleteOrNot = YES;//被删除
                }
                else
                {
                    self.isBlackNameOrNot = YES;//被拉黑
                }
            }
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.chatInputView.textView setEditable:YES];
    [self.navigationController.navigationBar setHidden:NO];
    if (self.ddUtility != nil)
    {
        //NSString *sessionId = self.module.MTTSessionEntity.sessionID;
        
    }
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    //移除上个controller使得滑动时返回消息界面
    if (self.isPushFromCreatQuick) {
        NSArray * viewArray = self.navigationController.viewControllers;
        NSMutableArray * muarray = [NSMutableArray array];
        [muarray addObjectsFromArray:viewArray];
        for (id objc in viewArray) {
            if ([objc isKindOfClass:[WPChooseLinkViewController class]]) {
                [muarray removeObject:objc];
                [self.navigationController setViewControllers:muarray];
            }
        }
    }
    
    if (self.isFromPersonal) {
        NSArray * array = self.navigationController.viewControllers;
        NSMutableArray * muarray = [NSMutableArray array];
        [muarray addObjectsFromArray:array];
        for (id objc in array) {
            if (![objc isKindOfClass:[[RecentUsersViewController shareInstance] class]] && ![objc isKindOfClass:[self class]]) {
                [muarray removeObject:objc];
            }
        }
        [self.navigationController setViewControllers:muarray];
    }
    
    self.isCurrentVC = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.isCurrentVC = NO;
    [self p_cancelRecord:nil];
    [self.module.ids removeAllObjects];
    //    [self p_hideBottomComponent];
    
    //[[PlayerManager sharedManager] stopPlaying];
    
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    [[PlayerManager sharedManager] stopPlaying];//停止语音播放
    //    [[ZacharyPlayManager sharedInstance] cancelAllVideo];
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    if(!self.isGotoAt){
        [super viewDidDisappear:animated];
        [self.chatInputView.textView setEditable:NO];
    }
    
}


-(void)initScrollView{
    
    __weak ChattingMainViewController *tmpSelf =self;
    //下拉加载历史数据
    [self.tableView setRefreshHandler:^{
        [tmpSelf loadHistoryRecords];
    }];
}

#pragma mark - 下拉加载更多数据
-(void)loadHistoryRecords{
    
    __weak ChattingMainViewController *tmpSelf =self;
    self.hadLoadHistory=YES;
    //    NSInteger preCount = [self.module.showingMessages count];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGFloat contentSizeHeightOld =tmpSelf.tableView.contentSize.height;
        CGFloat contentOffsetYOld =tmpSelf.tableView.contentOffset.y;
        
        
        [tmpSelf.module loadMoreHistoryCompletion:^(NSUInteger addCount,NSError *error) {
            [tmpSelf.tableView reloadData];
            CGFloat contentSizeHeightNew =tmpSelf.tableView.contentSize.height;
            CGFloat contentOffsetYNew =contentSizeHeightNew -contentSizeHeightOld +contentOffsetYOld;
            
            if (addCount == 0){
                tmpSelf.tableView.noMore =YES;
            }
            else{
                tmpSelf.tableView.noMore =NO;
                [tmpSelf.tableView setContentOffset:CGPointMake(0, contentOffsetYNew)];
            }
            [tmpSelf.tableView refreshFinished];
        }];
    });
    
}

-(void)setThisViewTitle:(NSString *)title
{
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
    [self queryUserStat];
}

#pragma mark 点击右侧 --> 查看群信息
-(IBAction)Edit:(id)sender
{
    if (self.module.MTTSessionEntity.sessionType == SessionTypeSessionTypeSingle) {
        WPChattingSingleEditViewController *singleSetting = [[WPChattingSingleEditViewController alloc] init];
        singleSetting.session = self.module.MTTSessionEntity;
        [self.navigationController pushViewController:singleSetting animated:YES];
    } else {
        [[DDGroupModule instance] getGroupInfogroupID:self.module.MTTSessionEntity.sessionID completion:^(MTTGroupEntity *group) {
            
            WPGroupInformationViewController *groupInfo = [[WPGroupInformationViewController alloc] init];
            groupInfo.isComeChatting = YES;
            
            if (group.groupCreatorId.intValue) {
                groupInfo.gtype = [group.groupCreatorId isEqualToString:kShareModel.userId]?@"1":@"2";
            }
            else
            {
                groupInfo.gtype = [group.groupCreatorId isEqualToString:[NSString stringWithFormat:@"user_%@",kShareModel.userId]]?@"1":@"2";
            }
            groupInfo.chatMouble = self.module;
            groupInfo.groupSessionId = self.module.MTTSessionEntity.sessionID;
            groupInfo.group_id = [group.objID substringFromIndex:6];
            groupInfo.groupSession = self.module.MTTSessionEntity;
            [self.navigationController pushViewController:groupInfo animated:YES];
        }];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView 滚动到底部
-(void)scrollerToBottomDirectly
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows-1 inSection:0]//(rows-1)->(rows-2)
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:NO];
        
    }
}
- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if(rows > 0) {
        //        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows-1 inSection:0]
        //                              atScrollPosition:UITableViewScrollPositionBottom
        //                                      animated:animated];
        
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:rows - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    }
}
-(void)scrollToBottomText:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows-1 inSection:0]//(rows-1)->(rows-2)
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
        
    }
}

- (ChattingModule*)module
{
    if (!_module)
    {
        _module = [[ChattingModule alloc] init];
    }
    return _module;
}

#pragma mark -
#pragma mark ActionMethods  发送sendAction 音频 voiceChange  显示表情 disFaceKeyboard
-(IBAction)sendAction:(id)sender{
    if (self.chatInputView.textView.text.length>0) {
        NSLog(@"点击发送");
        [self.chatInputView.textView setText:@""];
    }
}

#pragma mark -
#pragma mark UIGesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer.view isEqual:_tableView])
    {
        return YES;
    }
    return NO;
}

#pragma mark - EmojiFace Funcation
-(void)insertEmojiFace:(NSString *)string
{
    //显示还是需要累加的
    NSString *str;
    str = [self.chatInputView.textView.text stringByAppendingString:string];
    [self.chatInputView.textView setText:str];
}

//2016 chenchao  插入是直接发送 并不是保存在输入框中
-(void)insertYYFace:(NSString *)string
{
    DDMessageContentType msgContentType = DDMEssageEmotion; // Emotion 消失类型
    MTTMessageEntity *message = [MTTMessageEntity makeMessage:string Module:self.module MsgType:msgContentType];
    [self.tableView reloadData];
    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
        NSLog(@"消息插入DB成功");
    } failure:^(NSString *errorDescripe) {
        NSLog(@"消息插入DB失败");
    }];
    [self sendMessage:string messageEntity:message];
    
}


-(void)deleteEmojiFace
{
    EmotionsModule* emotionModule = [EmotionsModule shareInstance];
    NSString* toDeleteString = nil;
    if (self.chatInputView.textView.text.length == 0)
    {
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshReleaseBtnWhenDelete" object:self userInfo:nil];
        return;
    }
    if (self.chatInputView.textView.text.length == 1)
    {
        self.chatInputView.textView.text = @"";
    }
    else
    {
        toDeleteString = [self.chatInputView.textView.text substringFromIndex:self.chatInputView.textView.text.length - 1];
        int length = [emotionModule.emotionLength[toDeleteString] intValue];
        if (length == 0)
        {
            toDeleteString = [self.chatInputView.textView.text substringFromIndex:self.chatInputView.textView.text.length - 2];
            length = [emotionModule.emotionLength[toDeleteString] intValue];
        }
        length = length == 0 ? 1 : length;
        self.chatInputView.textView.text = [self.chatInputView.textView.text substringToIndex:self.chatInputView.textView.text.length - length];
    }
}
#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.module.showingMessages count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    id object = self.module.showingMessages[indexPath.row];
    if ([object isKindOfClass:[MTTMessageEntity class]])
    {
        MTTMessageEntity* message = object;
        if (message.msgContentType == DDMessageTypeText) {
            DDMessageContentType type = [WPSetMessageType message:message];
            if (type) {
                message.msgContentType = type;
            }
        }
        if (message.msgContentType == DDMEssagePersonalaCard || message.msgContentType == DDMEssageMyApply ||message.msgContentType == DDMEssageMyWant||message.msgContentType == DDMEssageMuchMyWantAndApply || message.msgContentType == DDMEssageSHuoShuo||message.msgContentType == DDMEssageLitteralbume||message.msgContentType == DDMEssageMuchCollection)
        {
            if (self.module.MTTSessionEntity.sessionType == SessionTypeSessionTypeGroup)
            {
                NSString* myUserID = [RuntimeStatus instance].user.objID;
                if ([message.senderId isEqualToString:myUserID])
                {
                    height = kHEIGHT(86)+10;
                }
                else
                {
                    height = kHEIGHT(86)+10+13;
                }
            }
            else
            {
                height = kHEIGHT(86)+10;
            }
        }
        else if (message.msgContentType == DDMEssageLitterVideo)
        {
            height = -20;
#pragma mark 视频的尺寸，不能删除，兄弟
            //            if (self.module.MTTSessionEntity.sessionType == SessionTypeSessionTypeGroup) {
            //                NSString* myUserID = [RuntimeStatus instance].user.objID;
            //                if ([message.senderId isEqualToString:myUserID])
            //                {
            //                    height = kHEIGHT(133)+10;//213->133
            //                }
            //                else
            //                {
            //                    height = kHEIGHT(133)+10+13;//213->133
            //                }
            //            }
            //            else
            //            {
            //              height = kHEIGHT(133)+10;//213->133
            //            }
        }
        else if (message.msgContentType == DDMEssageLitterInviteAndApply)
        {
            NSString * prompt = [inviteAndApplyCellController getTextFromString:message.msgContent];
            CGRect size = [prompt boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFONT(10),NSFontAttributeName, nil] context:nil];
            height = size.size.height+15;
        }
        else
        {
            height = [self.module messageHeight:message];
            if (self.module.MTTSessionEntity.sessionType == SessionTypeSessionTypeGroup)
            {
                NSString* myUserID = [RuntimeStatus instance].user.objID;
                if ([message.senderId isEqualToString:myUserID])
                {
                }
                else
                {
                    height = height+13;
                }
            }
        }
        if (indexPath.row != self.module.showingMessages.count-1)
        {
            id objc = self.module.showingMessages[indexPath.row+1];
            if ([objc isKindOfClass:[DDPromptEntity class]]) {
                height += 10;
            }
        }
    }
    else if([object isKindOfClass:[DDPromptEntity class]])
    {
        height = 25;
    }
    return height+10;//距离是20
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = self.module.showingMessages[indexPath.row];
    UITableViewCell* cell = nil;
    if ([object isKindOfClass:[MTTMessageEntity class]])
    {
        
        MTTMessageEntity* message = (MTTMessageEntity*)object;
        //message.msgContentType = DDMEssageMuchCollection;
        if (message.msgContentType == DDMessageTypeText) {
            DDMessageContentType type = [WPSetMessageType message:message];
            if (type) {
                message.msgContentType = type;
            }
        }
        if (message.msgContentType == DDMessageTypeText  || message.msgContentType == DDMEssageAcceptApply) {//文字
            if (message.msgContentType == DDMessageTypeText)
            {
                NSDictionary * dic = [self getLastMessage:message.msgContent];
                if (dic)
                {
                    message.msgContent = [NSString stringWithFormat:@"%@",dic[@"content"]];
                }
            }
            else
            {
                NSDictionary * dic = [self getLastMessage:message.msgContent];
                if (dic)
                {
                    WPUploadImage * opload = [[WPUploadImage alloc]init];
                    NSString * contentStr = [opload getInviteSyr:dic];
                    message.msgContent = contentStr;
                    message.senderId = message.sessionId;
                }
                else
                {
                    message.senderId = message.sessionId;
                }
                message.msgContentType = DDMEssageAcceptApply;
            }
            cell = [self p_textCell_tableView:tableView cellForRowAtIndexPath:indexPath message:message];
        }else if (message.msgContentType == DDMessageTypeVoice)//语音
        {
            cell = [self p_voiceCell_tableView:tableView cellForRowAtIndexPath:indexPath message:message];
        }
        else if(message.msgContentType == DDMessageTypeImage)//图片
        {
            cell = [self p_imageCell_tableView:tableView cellForRowAtIndexPath:indexPath message:message];
            
        }else if (message.msgContentType == DDMEssageEmotion)//表情
        {
            cell = [self p_emotionCell_tableView:tableView cellForRowAtIndexPath:indexPath message:message];
        }
        else if (message.msgContentType == DDMEssageLitterVideo)//视频
        {
#pragma mark 视频，不能删除，兄弟
            //            cell = [self p_videoCell_tableVide:tableView cellForRowAtIndexPath:indexPath message:message];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hahahahahah"];
        }
        else if (message.msgContentType == DDMEssagePersonalaCard||message.msgContentType == DDMEssageMyApply || message.msgContentType == DDMEssageMyWant || message.msgContentType == DDMEssageSHuoShuo||message.msgContentType == DDMEssageLitteralbume)//名片
        {
            cell = [self p_personCardCell_tableView:tableView cellForRowAtIndexPath:indexPath message:message];
            
        }
        else if (message.msgContentType == DDMEssageMuchMyWantAndApply|| message.msgContentType == DDMEssageMuchCollection)//多个面试和招聘
        {
            cell = [self p_muchApplyAndWantCell_tableView:tableView cellForRowAtIndexPath:indexPath message:message];
        }
        else if (message.msgContentType == DDMEssageLitterInviteAndApply)//有人邀请或群主同意
        {
            
            DDPromptEntity*prompt = [[DDPromptEntity alloc]init];
            prompt.message = [inviteAndApplyCellController getTextFromString:message.msgContent];
            cell = [self p_promptCell_tableView:tableView cellForRowAtIndexPath:indexPath message:prompt];
            
            NSString * titleSr = [inviteAndApplyCellController getTitleFromString:message.msgContent];
            if (titleSr.length) {
                [self.titleBtn setTitle:titleSr forState:UIControlStateNormal];
            }
            
            
        }
        else
        {
            cell = [self p_textCell_tableView:tableView cellForRowAtIndexPath:indexPath message:message];
        }
        
    }
    else if ([object isKindOfClass:[DDPromptEntity class]])//时间类型
    {
        DDPromptEntity* prompt = (DDPromptEntity*)object;
        cell = [self p_promptCell_tableView:tableView cellForRowAtIndexPath:indexPath message:prompt];
    }
    
    
    //    if (indexPath.row%2) {
    //        cell.backgroundColor = [UIColor redColor];
    //    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[DDVideoCell class]]) {
        DDVideoCell * cell1 = (DDVideoCell*)cell;
        [[ZacharyPlayManager sharedInstance] cancelVideo:cell1.filePath];
    }
    
    //    if (self.module.showingMessages.count) {
    //        if (indexPath.row > self.module.showingMessages.count-1) {
    //            return;
    //        }
    //        id objc = self.module.showingMessages[indexPath.row];
    //        if ([objc isKindOfClass:[MTTMessageEntity class]]) {
    //            MTTMessageEntity * message = (MTTMessageEntity*)objc;
    //            if (message.msgContentType == DDMEssageLitterVideo) {
    //                DDVideoCell * cell1 = (DDVideoCell*)cell;
    //                [[ZacharyPlayManager sharedInstance] cancelVideo:cell1.filePath];
    //            }
    //        }
    //    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y + self.tableView.height >= self.tableView.contentSize.height - 50){
        self.ifScrollBottom = YES;
    }else{
        if (self.receiveMessage && self.ifScrollBottom) {
            self.ifScrollBottom = YES;
        }
        else
        {
            self.ifScrollBottom = NO;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // 上拉弹出键盘
    //        if (scrollView.contentOffset.y < scrollView.contentSize.height -scrollView.frame.size.height +scrollView.contentInset.bottom){
    //            [self p_hideBottomComponent];
    //        }
    //        else if (scrollView.contentOffset.y > scrollView.contentSize.height -scrollView.frame.size.height +scrollView.contentInset.bottom +80) {
    //                [self.chatInputView.textView becomeFirstResponder];
    //        }
}

#pragma mark PublicAPI
- (void)loadChattingContentFromSearch:(MTTSessionEntity*)session message:(MTTMessageEntity*)message
{
    [self.module.showingMessages removeAllObjects];
    [self.tableView reloadData];
    self.module.MTTSessionEntity = nil;
    self.hadLoadHistory=YES;
    [self.module.showingMessages removeAllObjects];
    self.module.MTTSessionEntity = session;
    [self setThisViewTitle:session.name];
    [self.module loadAllHistoryCompletion:message Completion:^(NSUInteger addcount, NSError *error) {
        [self.tableView reloadData];
    }];
}


#pragma mark  从消息页面推出
- (void)showChattingContentForSession:(MTTSessionEntity*)session
{
    
    //    CONTENT_HEIGHT - DDINPUT_MIN_HEIGHT + NAVBAR_HEIGHT
    //    CGRect rect = self.ddUtility.view.frame;
    //    rect.origin.y = SCREEN_HEIGHT;
    //    self.ddUtility.view.frame = rect;
    //    if (self.chatInputView)
    //    {
    ////        [self.chatInputView.textView becomeFirstResponder];
    //        [self.chatInputView.textView setFrame:DDINPUT_BOTTOM_FRAME];
    //        [self.ddUtility.view setFrame:DDCOMPONENT_BOTTOM];
    ////        [self.emotions.view setFrame:DDEMOTION_FRAME];
    //        _bottomShowComponent = (_bottomShowComponent & DDHideUtility) | DDShowEmotion;
    //    }
    if (!self.editBottomView.hidden) {
        self.editBottomView.hidden = YES;
        self.isMore = NO;
        [self.tableView reloadData];
    }
    
    
    self.module.MTTSessionEntity = nil;
    self.hadLoadHistory=NO;
    [self p_unableChatFunction];
    [self p_enableChatFunction];
    [self.module.showingMessages removeAllObjects];
    [self.tableView reloadData];
    self.module.MTTSessionEntity = session;
    NSString * nameStr = session.name;
    NSArray * array = [nameStr componentsSeparatedByString:@","];
    NSMutableArray * muarray  = [NSMutableArray array];
    if (array.count > 3) {
        [muarray addObject:array[0]];
        [muarray addObject:array[1]];
        [muarray addObject:array[2]];
        nameStr = [muarray componentsJoinedByString:@","];
    }
    
    
    [self setThisViewTitle:nameStr];//session.name
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBtn setImage:[UIImage imageNamed:self.module.MTTSessionEntity.sessionType == SessionTypeSessionTypeSingle ? @"chatmessagehao" : @"chatmessagequn"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(Edit:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    
    [self.module preLoad:^(NSUInteger addcount, NSError *error) {
        
        [self.tableView reloadData];
        if (self.hadLoadHistory == NO) {
            [self scrollerToBottomDirectly];
        }
        
        [self.module loadMoreHistoryCompletion:^(NSUInteger addcount, NSError *error) {
            if (addcount != 0) {
                [self.tableView reloadData];
                if (self.hadLoadHistory == NO) {
                    [self scrollerToBottomDirectly];
                }
            }
            if (session.unReadMsgCount !=0 ) {//发送消息标记消息已读
                MsgReadACKAPI* readACK = [[MsgReadACKAPI alloc] init];
                if(self.module.MTTSessionEntity.sessionID){
                    [readACK requestWithObject:@[self.module.MTTSessionEntity.sessionID,@(self.module.MTTSessionEntity.lastMsgID),@(self.module.MTTSessionEntity.sessionType)] Completion:nil];
                    self.module.MTTSessionEntity.unReadMsgCount=0;
                    [[MTTDatabaseUtil instance] updateRecentSession:self.module.MTTSessionEntity completion:^(NSError *error) {
                    }];
                }
            }
        }];
        
        
    }];
    
    
#pragma mark 从消息页面推出时加载数
    //    [self.module loadMoreHistoryCompletion:^(NSUInteger addcount, NSError *error) {
    ////        for (id obj in self.module.showingMessages) {
    ////            if ([obj isKindOfClass:[MTTMessageEntity class]]) {
    ////                MTTMessageEntity * message = (MTTMessageEntity*)obj;
    ////                if (message.state == DDMessageSending) {
    ////                    message.state = DDMessageSendFailure;
    ////                }
    ////            }
    ////        }
    //
    //        [self.tableView reloadData];
    //        if (self.hadLoadHistory == NO) {
    ////            [self scrollToBottomAnimated:NO];
    //            [self scrollerToBottomDirectly];
    //        }
    //        if (session.unReadMsgCount !=0 ) {//发送消息标记消息已读
    //            MsgReadACKAPI* readACK = [[MsgReadACKAPI alloc] init];
    //            if(self.module.MTTSessionEntity.sessionID){
    //                [readACK requestWithObject:@[self.module.MTTSessionEntity.sessionID,@(self.module.MTTSessionEntity.lastMsgID),@(self.module.MTTSessionEntity.sessionType)] Completion:nil];
    //                self.module.MTTSessionEntity.unReadMsgCount=0;
    //                [[MTTDatabaseUtil instance] updateRecentSession:self.module.MTTSessionEntity completion:^(NSError *error) {
    //                }];
    //            }
    //        }
    //    }];
}
#pragma mark - Text view delegatef

- (void)viewheightChanged:(float)height
{
    [self setValue:@(self.chatInputView.origin.y) forKeyPath:@"_inputViewY"];
}
#pragma mark 将字符串转换成字典
-(NSDictionary*)getLastMessage:(NSString*)string
{
    NSData *JSONData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
#pragma mark PrivateAPI

#pragma mark 转发
-(void)tranmitMessage:(NSString*)messageContent andMessageType:(DDMessageContentType)type andToUserId:(NSString*)userId andmessage:(MTTMessageEntity*)message
{//DDMessageTypeText
    
    
    WPRecentLinkManController * person = [[WPRecentLinkManController alloc]init];
    NSArray * array = [[SessionModule instance] getAllSessions];
    NSMutableArray * muarray = [NSMutableArray arrayWithArray:array];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
    NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
    person.dataSource = muarray;
    person.toUserId = userId;
    person.display_type = [WPSetMessageType getDisPlayType:type];
    if (type == DDMEssageLitterVideo)
    {
        if (message.state == DDMessageSendFailure) {
            NSData * data = [messageContent dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (dic) {
                messageContent = dic[@"local"];
            }
        }
        [MBProgressHUD showMessage:@"" toView:self.view];
        [WPSetMessageType upLoadVideo:messageContent success:^(NSString *video) {
            [MBProgressHUD hideHUDForView:self.view];
            NSArray * array = [video componentsSeparatedByString:@","];
            person.transStr = [IPADDRESS stringByAppendingString:array[0]];
            [self.navigationController pushViewController:person animated:YES];
        } failed:^(NSError *eror) {
            [MBProgressHUD createHUD:@"视频上传失败" View:self.view];
        }];
    }
    else
    {
        person.transStr = messageContent;
        [self.navigationController pushViewController:person animated:YES];
    }
    //    WPRecentLinkManController * person = [[WPRecentLinkManController alloc]init];
    //    NSArray * array = [[SessionModule instance] getAllSessions];
    //    NSMutableArray * muarray = [NSMutableArray arrayWithArray:array];
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
    //    NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
    //    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    //    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
    //    person.dataSource = muarray;
    //    person.toUserId = userId;
    //    person.display_type = [WPSetMessageType getDisPlayType:type];
    //    person.transStr = messageContent;
    //    [self.navigationController pushViewController:person animated:YES];
}

#pragma mark 文字
- (UITableViewCell*)p_textCell_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(MTTMessageEntity*)message
{
    static NSString* identifier = @"DDChatTextCellIdentifier";
    DDChatBaseCell* cell = (DDChatBaseCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[DDChatTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.contentLabel.delegate = self;
    }
    cell.session =self.module.MTTSessionEntity;
    cell.indexPath = indexPath;
    NSString* myUserID = [RuntimeStatus instance].user.objID;
    if ([message.senderId isEqualToString:myUserID])
    {
        [cell setLocation:DDBubbleRight];
    }
    else
    {
        [cell setLocation:DDBubbleLeft];
    }
    
    if (![[UnAckMessageManager instance] isInUnAckQueue:message] && message.state == DDMessageSending && [message isSendBySelf]) {
        message.state=DDMessageSendFailure;
    }
    
    [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
        
    }];
    [cell setContent:message];
    cell.isMore = self.isMore;
    cell.itemSelected = message.itemSelected;
    cell.isBlackNameOrNot = self.isBlackNameOrNot;
    cell.isDeleteOrNot = self.isDeleteOrNot;
    __weak DDChatTextCell* weakCell = (DDChatTextCell*)cell;
    
    //点击menu上的重发
    [cell setClickMenuSendAgain:^{
        [weakCell showSending];
        [weakCell sendTextAgain:message success:^(NSString *string, MTTMessageEntity *mess) {
            [self clickSendAgainBlackName:@"1" and:message andBlackMeaage:mess andIndex:indexPath andBlockStr:string];
        }];
    }];
    
    //再次发送消息
    cell.sendAgain = ^{
        [weakCell showSending];
        [weakCell sendTextAgain:message success:^(NSString *string, MTTMessageEntity *mess) {
            [self clickSendAgainBlackName:@"1" and:message andBlackMeaage:mess andIndex:[NSIndexPath indexPathForRow:self.module.showingMessages.count-1 inSection:0] andBlockStr:string];
        }];
    };
    
    //删除
    [cell setDeleteMessage:^{
        [self setType:@"1" andMessage:message andIndexpath:indexPath];
        //从列表中删除
        //        [self deleteFromList:indexPath andMessage:message];
        //        [self.module.showingMessages removeObject:message];
        //        [self.tableView reloadData];
        //        //从数据库中删除
        //        [[MTTDatabaseUtil instance] deleteMesages:message completion:^(BOOL success) {
        //        }];
        //        //从服务器中删除
        [self deleteMessage:[NSString stringWithFormat:@"%lu",(unsigned long)message.msgID] andType:@"3"];
    }];
    
    //转发
    [cell setTranmitMessag:^{
        
        NSString * toUserId = [self getToUser:message];
        [self tranmitMessage:message.msgContent andMessageType:message.msgContentType andToUserId:toUserId andmessage:message];
    }];
    
    //更多
    //    WS(ws);
    [cell setClickMoreChoise:^{
        message.itemSelected = YES;
        [self clickMoreMessage];
    }];
    //点击更多时选择
    [cell setClickLeftBtn:^(NSIndexPath *indexPath,UIButton*sender) {
        [self changeChoiseState:indexPath andBtn:sender];
    }];
    
    //收藏
    [cell setClickCollection:^{
        [self collectiolTextAndPhotoCollectionClass:@"0" andContent:message.msgContent angImageUrl:@"" andVdUrl:@"" message:message];
    }];
    return cell;
}
#pragma mark 点击更多
-(void)clickMoreMessage
{
    [self p_hideBottomComponent];
    self.editBottomView.hidden = NO;
    self.isMore = YES;
    [self.tableView reloadData];
}
#pragma mark点击删除
-(void)setType:(NSString*)type andMessage:(MTTMessageEntity*)message andIndexpath:(NSIndexPath*)indexpath
{
    _deleteType = type;
    _deleteMessage = message;
    _deleteIndexpath = indexpath;
    [self alertShow];
}
-(void)alertShow
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除消息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 40000) {
        if (buttonIndex == 1)
        {
            [self deleteMoreMessage:self.module.showingMessages];
        }
    }
    else if (alertView.tag == 40001)
    {
        if (buttonIndex == 1) {
            
            NSArray * choiseArray = [self clickMoreTranmit:self.module.showingMessages];
            
            NSMutableArray * choisemuarray = [NSMutableArray arrayWithArray:choiseArray];
            for (NSDictionary * dictionary in choiseArray) {
                NSString * contentType = [NSString stringWithFormat:@"%@",dictionary[@"contentType"]];
                if ([contentType isEqualToString:@"11"]||[contentType isEqualToString:@"2"]) {
                    [choisemuarray removeObject:dictionary];
                }
            }
            
            if (!choisemuarray.count) {
                self.editBottomView.hidden = YES;
                self.isMore = NO;
                [self.tableView reloadData];
                for (id objc in self.module.showingMessages)
                {
                    if ([objc isKindOfClass:[MTTMessageEntity class]]) {
                        MTTMessageEntity * message = (MTTMessageEntity*)objc;
                        message.itemSelected = NO;
                    }
                    
                }
                [MBProgressHUD createHUD:@"语音/相册/公告等不能转发" View:self.view];
                return;
            }
            
            [self tranmitVideo:self.module.showingMessages];
            //            WPRecentLinkManController * person = [[WPRecentLinkManController alloc]init];
            //            NSArray * array = [[SessionModule instance] getAllSessions];
            //            NSMutableArray * muarray = [NSMutableArray arrayWithArray:array];
            //            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
            //            NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
            //            [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            //            [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
            //            person.dataSource = muarray;
            //            person.moreTranitArray = choisemuarray;
            //
            //            if (!person.moreTranitArray.count) {
            //                return;
            //            }
            //            person.toUserId = _tranmitToUserId;
            //            [self.navigationController pushViewController:person animated:YES];
        }
    }
    else if (alertView.tag == 40002 || alertView.tag == 40003){
        
        NSMutableArray * muarra = [NSMutableArray array];
        [muarra addObjectsFromArray:self.module.showingMessages];
        for (id objc in self.module.showingMessages) {
            if ([objc isKindOfClass:[MTTMessageEntity class]]) {
                MTTMessageEntity * message = (MTTMessageEntity *)objc;
                if (!message.itemSelected || (message.msgContentType == DDMEssageLitteralbume || message.msgContentType == DDMessageTypeVoice)) {
                    [muarra removeObject:message];
                }
            }
            else if ([objc isKindOfClass:[DDPromptEntity class]])
            {
                [muarra removeObject:objc];
            }
        }

        
        
        if (alertView.tag == 40003) {
            [self.collectionMuarray removeAllObjects];
            self.collectionMuarray  = muarra;
            if (!self.collectionMuarray.count) {
                [MBProgressHUD createHUD:@"请重新选择要收藏的消息" View:self.view];
                return;
            }else{
                CollectViewController * collection = [[CollectViewController alloc]init];
                collection.isCollectionFromChatMuch = YES;
                collection.collectionFromMuchArray = self.collectionMuarray;
                collection.sessionType = self.module.MTTSessionEntity.sessionType;
                collection.collectSuccessBlock= ^(){
                    self.editBottomView.hidden = YES;
                    self.isMore = NO;
                    [self.tableView reloadData];
                    for (id objc in self.module.showingMessages)
                    {
                        if ([objc isKindOfClass:[MTTMessageEntity class]]) {
                            MTTMessageEntity * message = (MTTMessageEntity*)objc;
                            message.itemSelected = NO;
                        }
                        
                    }
                    
                };
                MTTSessionEntity * session = self.module.MTTSessionEntity;
                if (session.sessionType == SessionTypeSessionTypeGroup) {
                    collection.col4 = [NSString stringWithFormat:@"%@",[session.sessionID componentsSeparatedByString:@"_"][1]];
                }
                [self.navigationController pushViewController:collection animated:YES];
            }
        }else if (alertView.tag == 40002 && buttonIndex == 1){
            [self.collectionMuarray removeAllObjects];
            self.collectionMuarray  = muarra;
            if (!self.collectionMuarray.count) {
                [MBProgressHUD createHUD:@"请重新选择要转发的消息" View:self.view];
                return;
            }else{
                [self tranmitVideo:self.collectionMuarray  ];
            }
        }
    }else{
        
        if (buttonIndex == 1)
        {
            [self deleteMessageFromDetail:_deleteIndexpath andMessage:_deleteMessage andType:_deleteType];
        }
    }
}
-(void)deleteMessageFromDetail:(NSIndexPath*)indedxPatn andMessage:(MTTMessageEntity*)message andType:(NSString*)type
{
    [self deleteFromList:indedxPatn andMessage:message];
    [self.module.showingMessages removeObject:message];
    [self.tableView reloadData];
    //从数据库中删除
    [[MTTDatabaseUtil instance] deleteMesages:message completion:^(BOOL success) {
    }];
    [self deleteMessage:[NSString stringWithFormat:@"%lu",(unsigned long)message.msgID] andType:type];
    
}
#pragma mark 文字图片视频的收藏
-(void)collectiolTextAndPhotoCollectionClass:(NSString *)class andContent:(NSString*)content angImageUrl:(NSString*)imageStr andVdUrl:(NSString*)vdUrl message:(MTTMessageEntity*)message
{
    CollectViewController * collection = [[CollectViewController alloc]init];
    collection.collect_class = class;
    collection.content = content;
    collection.user_id = kShareModel.userId;
    collection.img_url = imageStr;
    collection.vd_url = vdUrl;
    collection.jobid = @"";
    collection.url = @"";
    collection.companys = @"";
    collection.shareStr = @"";
    collection.titleArray = @"";
    MTTSessionEntity * session = self.module.MTTSessionEntity;
    if (session.sessionType == SessionTypeSessionTypeGroup) {
        collection.col4 = [NSString stringWithFormat:@"%@",[session.sessionID componentsSeparatedByString:@"_"][1]];
    }
    collection.user_id = [NSString stringWithFormat:@"%@",[message.senderId componentsSeparatedByString:@"_"][1]];
    [self.navigationController pushViewController:collection animated:YES];
}
#pragma mark 跳到收藏界面
-(void)pushToCollection:(NSString*)contentStr andUrl:(NSString*)urlStr andFlag:(NSString*)flag message:(MTTMessageEntity*)message
{
    CollectViewController * collection = [[CollectViewController alloc]init];
    collection.collectionId = contentStr;
    collection.collectionUrl = urlStr;
    collection.collectionFlag = flag;
    collection.isCollectionFromChat = YES;
    MTTSessionEntity * session = self.module.MTTSessionEntity;
    if (session.sessionType == SessionTypeSessionTypeGroup) {
        collection.col4 = [NSString stringWithFormat:@"%@",[session.sessionID componentsSeparatedByString:@"_"][1]];
    }
    collection.user_id = [NSString stringWithFormat:@"%@",[message.senderId componentsSeparatedByString:@"_"][1]];
    [self.navigationController pushViewController:collection animated:YES];
}


-(void)changeChoiseState:(NSIndexPath*)indexPath andBtn:(UIButton*)sender
{
    MTTMessageEntity* message = self.module.showingMessages[indexPath.row];
    message.itemSelected = !message.itemSelected;
    if (sender) {
        sender.selected = !sender.selected;
    }
    else
    {
        [self.tableView reloadData];
    }
    
}
- (UIView *)editBottomView{
    if (!_editBottomView) {
        _editBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, BOTTOMHEIGHT)];
        _editBottomView.backgroundColor = [UIColor whiteColor];
        
        NSArray *arr = @[@"转发",@"收藏",@"删除"];
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*(SCREEN_WIDTH/3), 0, SCREEN_WIDTH/3, BOTTOMHEIGHT);
            [button setTitle:arr[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if (i==0) {
                [button setBackgroundImage:[UIImage imageWithColor:RGB(0, 172, 255) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageWithColor:RGB(0, 146, 217) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
            }else{
                [button setBackgroundImage:[UIImage imageWithColor:RGB(255, 139, 0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageWithColor:RGB(217, 118, 0) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
            }
            
            button.titleLabel.font = kFONT(15);
            button.tag = 20000+i;
            [button addTarget:self action:@selector(editBottomClick:) forControlEvents:UIControlEventTouchUpInside];
            [_editBottomView addSubview:button];
        }
        for (int i = 1; i < 3; i++) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(i*(SCREEN_WIDTH/3), 0, 0.5, 49)];
            line.backgroundColor = [UIColor whiteColor];
            [self.editBottomView addSubview:line];
            
        }
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_editBottomView addSubview:line];
        
        _editBottomView.hidden = YES;
    }
    return _editBottomView;
}
#pragma mark 点击底部的转发
-(void)tranmitVideo:(NSArray*)array
{
    NSMutableArray * muarray = [NSMutableArray array];
    NSMutableArray * videoArray = [NSMutableArray array];
    for (id objc in array) {
        if ([objc isKindOfClass:[MTTMessageEntity class]]) {
            MTTMessageEntity * message = (MTTMessageEntity*)objc;
            if (message.itemSelected) {
                if (message.msgContentType == DDMEssageLitterVideo) {
                    [videoArray addObject:message];
                }
                else
                {
                    _tranmitToUserId = message.toUserID;
                    NSString * content = message.msgContent;
                    DDMessageContentType contentType = message.msgContentType;
                    if (contentType == DDMessageTypeImage) {
                        NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        if (dic.count) {
                            content = dic[@"url"];
                        }
                    }
                    NSDictionary * dic = @{@"content":content,@"contentType":[NSString stringWithFormat:@"%lu",(unsigned long)contentType]};
                    [muarray addObject:dic];
                }
            }
        }
    }
    if (videoArray.count)
    {
        self.upLoadNumber = 0;
        [MBProgressHUD showMessage:@"" toView:self.view];
        for (MTTMessageEntity* message in videoArray) {
            NSString *messageContent = message.msgContent;
            DDMessageContentType contentType = message.msgContentType;
            if (message.state == DDMessageSendFailure) {
                NSData * data = [messageContent dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (dic) {
                    messageContent = dic[@"local"];
                }
            }
            
            [WPSetMessageType upLoadVideo:messageContent success:^(NSString *video) {
                
                
                NSArray * array = [video componentsSeparatedByString:@","];
                NSString * string = [IPADDRESS stringByAppendingString:array[0]];
                NSDictionary * dic = @{@"content":string,@"contentType":[NSString stringWithFormat:@"%lu",(unsigned long)contentType]};
                [muarray addObject:dic];
                ;
                ++self.upLoadNumber;
                if (self.upLoadNumber == videoArray.count) {//跳转到下个界面
                    [MBProgressHUD hideHUDForView:self.view];
                    WPRecentLinkManController * person = [[WPRecentLinkManController alloc]init];
                    NSArray * array = [[SessionModule instance] getAllSessions];
                    NSMutableArray * personArray = [NSMutableArray arrayWithArray:array];
                    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
                    NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
                    [personArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                    [personArray sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
                    person.dataSource = personArray;
                    person.moreTranitArray = muarray;
                    if (!person.moreTranitArray.count) {
                        return;
                    }
                    person.toUserId = _tranmitToUserId;
                    [self.navigationController pushViewController:person animated:YES];
                }
                
                
            } failed:^(NSError *eror) {
                [MBProgressHUD createHUD:@"视频上传失败" View:self.view];
            }];
        }
    }
    else
    {
        WPRecentLinkManController * person = [[WPRecentLinkManController alloc]init];
        NSArray * array = [[SessionModule instance] getAllSessions];
        NSMutableArray * personArray = [NSMutableArray arrayWithArray:array];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
        NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
        [personArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [personArray sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
        person.dataSource = personArray;
        person.moreTranitArray = muarray;
        if (!person.moreTranitArray.count) {
            return;
        }
        person.toUserId = _tranmitToUserId;
        [self.navigationController pushViewController:person animated:YES];
    }
}
-(NSArray*)clickMoreTranmit:(NSArray*)array
{
    NSMutableArray * muarray = [NSMutableArray array];
    for (id objc in array) {
        if ([objc isKindOfClass:[MTTMessageEntity class]])
        {
            MTTMessageEntity *message = (MTTMessageEntity*)objc;
            if (message.itemSelected)
            {
                _tranmitToUserId = message.toUserID;
                NSString * content = message.msgContent;
                DDMessageContentType contentType = message.msgContentType;
                if (contentType == DDMessageTypeImage) {
                    NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if (dic.count) {
                        content = dic[@"url"];
                    }
                }
                //                if (contentType == DDMEssageLitterVideo) {//先将视频上传
                //                    NSString *messageContent = message.msgContent;
                //                    if (message.state == DDMessageSendFailure) {
                //                        NSData * data = [messageContent dataUsingEncoding:NSUTF8StringEncoding];
                //                        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                //                        if (dic) {
                //                            messageContent = dic[@"local"];
                //                        }
                //                    }
                //                    [MBProgressHUD showMessage:@"" toView:self.view];
                //                    [WPSetMessageType upLoadVideo:messageContent success:^(NSString *video) {
                //                        [MBProgressHUD hideHUDForView:self.view];
                //                        NSArray * array = [video componentsSeparatedByString:@","];
                //                        NSString * string = [IPADDRESS stringByAppendingString:array[0]];
                //                        NSDictionary * dic = @{@"content":string,@"contentType":[NSString stringWithFormat:@"%lu",(unsigned long)contentType]};
                //                        [muarray addObject:dic];
                //                    } failed:^(NSError *eror) {
                //                        [MBProgressHUD createHUD:@"视频上传失败" View:self.view];
                //                    }];
                //                }
                //                else
                //                {
                //                    NSDictionary * dic = @{@"content":content,@"contentType":[NSString stringWithFormat:@"%lu",(unsigned long)contentType]};
                //                    [muarray addObject:dic];
                //                }
                
                
                NSDictionary * dic = @{@"content":content,@"contentType":[NSString stringWithFormat:@"%lu",(unsigned long)contentType]};
                [muarray addObject:dic];
            }
        }
    }
    
    
    
    return muarray;
}
#pragma mark 点击更多的底部按钮
-(void)editBottomClick:(UIButton*)sender
{
    BOOL isOrNot = NO;
    NSArray * array = [self clickMoreTranmit:self.module.showingMessages];
    
    if (array.count >100) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"聊天记录多选不能超过100条" delegate:nil cancelButtonTitle:@"群定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableArray * muarray = [NSMutableArray arrayWithArray:array];
    for (NSDictionary * dictionary in array) {
        NSString * contentType = [NSString stringWithFormat:@"%@",dictionary[@"contentType"]];
        if ([contentType isEqualToString:@"11"]||[contentType isEqualToString:@"2"]) {
            [muarray removeObject:dictionary];
            isOrNot = YES;
        }
    }
    
    switch (sender.tag) {
        case 20000://转发
        {
            
            if (isOrNot) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择的消息中，语音/群相册/群公告不能转发" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 40002;
                [alert show];
            }
            else
            {
                [self tranmitVideo:self.module.showingMessages];
                //                WPRecentLinkManController * person = [[WPRecentLinkManController alloc]init];
                //                NSArray * array = [[SessionModule instance] getAllSessions];
                //                NSMutableArray * muarray = [NSMutableArray arrayWithArray:array];
                //                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
                //                NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
                //                [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                //                [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
                //                person.dataSource = muarray;
                //                person.moreTranitArray = [self clickMoreTranmit:self.module.showingMessages];
                //                if (!person.moreTranitArray.count) {
                //                    return;
                //                }
                //                person.toUserId = _tranmitToUserId;
                //                [self.navigationController pushViewController:person animated:YES];
                
            }
        }
            break;
        case 20001://收藏
        {
            //           [self pushToCollection:@"" andUrl:@"" andFlag:@""];
            
            int num = 0;
            for (id objc in self.module.showingMessages) {
                if ([objc isKindOfClass:[MTTMessageEntity class]]) {
                    MTTMessageEntity *messagr = (MTTMessageEntity*)objc;
                    if (messagr.itemSelected) {
                        ++num;
                    }
                }
                
            }
            
            if (num == 0) {
                return;
            }
            else if (num == 1)
            {
                if (isOrNot) {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择的消息中，语音/群相册/群公告不能收藏" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag = 40003;
                    [alert show];
                }else {
                    MTTMessageEntity * message;
                    for (id objc in self.module.showingMessages) {
                        if ([objc isKindOfClass:[MTTMessageEntity class]]) {
                            MTTMessageEntity *messagr = (MTTMessageEntity*)objc;
                            if (messagr.itemSelected) {
                                message = messagr;
                            }
                        }
                        
                    }
                    if (message.msgContentType == DDMEssagePersonalaCard||message.msgContentType == DDMEssageMyApply || message.msgContentType == DDMEssageMyWant || message.msgContentType == DDMEssageSHuoShuo||message.msgContentType == DDMEssageLitteralbume) {
                        NSString * content = message.msgContent;
                        NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        [self pushToCollection:
                         (message.msgContentType == DDMEssagePersonalaCard)?dic[@"user_id"]:(message.msgContentType == DDMEssageSHuoShuo)?dic[@"shuoshuoid"]:(message.msgContentType == DDMEssageMyWant)?dic[@"zp_id"]:dic[@"qz_id"]
                                        andUrl:
                         @""
                                       andFlag:
                         (message.msgContentType == DDMEssagePersonalaCard?@"0":(message.msgContentType==DDMEssageMyWant)?@"2":(message.msgContentType == DDMEssageSHuoShuo)?@"4":@"1") message:message];
                    }
                    else if (message.msgContentType == DDMEssageMuchMyWantAndApply)
                    {
                        NSString * content = message.msgContent;
                        NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        [self pushToCollection:dic[@"id"] andUrl:dic[@"url"] andFlag:dic[@"type"] message:message];
                    }
                    else if (message.msgContentType == DDMessageTypeText)
                    {
                        [self collectiolTextAndPhotoCollectionClass:@"0" andContent:message.msgContent angImageUrl:@"" andVdUrl:@"" message:message];
                    }
                    else if (message.msgContentType == DDMessageTypeImage)
                    {
                        NSString * urlString = message.msgContent;
                        urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_PREFIX withString:@""];
                        urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_SUFFIX withString:@""];
                        [self collectiolTextAndPhotoCollectionClass:@"1" andContent:@"" angImageUrl:urlString andVdUrl:@"" message:message];
                    }
                }
            }
            else
            {
                [self collectionMuch:self.module.showingMessages];
            }
            
            //            [self collectionMuch:self.module.showingMessages];
            
        }
            break;
        case 20002://删除
        {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 40000;
            [alert show];
        }
            break;
        default:
            break;
    }
}
#pragma mark 点击更多的收藏
-(void)collectionMuch:(NSArray*)collectionArray
{
    BOOL isExitOrNot = NO;
    NSMutableArray * muarra = [NSMutableArray array];
    [muarra addObjectsFromArray:collectionArray];
    for (id objc in collectionArray) {
        if ([objc isKindOfClass:[MTTMessageEntity class]]) {
            MTTMessageEntity * message = (MTTMessageEntity *)objc;
            if (message.msgContentType == DDMEssageLitteralbume ||message.msgContentType == DDMEssageAcceptApply||message.msgContentType == DDMEssageLitterInviteAndApply || message.msgContentType == DDMessageTypeVoice) {
                
                if (message.msgContentType == DDMEssageLitteralbume || message.msgContentType == DDMessageTypeVoice) {
                    isExitOrNot = YES;
                    [muarra removeObject:message];
                }
                if (!message.itemSelected) {
                    [muarra removeObject:message];
                }
            }
        }
        else if ([objc isKindOfClass:[DDPromptEntity class]])
        {
            [muarra removeObject:objc];
        }
            self.collectionMuarray = muarra;
    }
    if (muarra.count > 100) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"聊天记录多选不能超过100条" delegate:nil cancelButtonTitle:@"群定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    
    if (isExitOrNot) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择的消息中，语音/群相册/群公告不能收藏" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 40003;
        [alert show];
    }
    else
    {
        CollectViewController * collection = [[CollectViewController alloc]init];
        collection.isCollectionFromChatMuch = YES;
        collection.collectionFromMuchArray = self.collectionMuarray;
        collection.sessionType = self.module.MTTSessionEntity.sessionType;
        collection.collectSuccessBlock= ^(){
            self.editBottomView.hidden = YES;
            self.isMore = NO;
            [self.tableView reloadData];
            for (id objc in self.module.showingMessages)
            {
                if ([objc isKindOfClass:[MTTMessageEntity class]]) {
                    MTTMessageEntity * message = (MTTMessageEntity*)objc;
                    message.itemSelected = NO;
                }
                
            }
        };
        MTTSessionEntity * session = self.module.MTTSessionEntity;
        if (session.sessionType == SessionTypeSessionTypeGroup) {
            collection.col4 = [NSString stringWithFormat:@"%@",[session.sessionID componentsSeparatedByString:@"_"][1]];
        }
        [self.navigationController pushViewController:collection animated:YES];
        
    }
    //    CollectViewController * collection = [[CollectViewController alloc]init];
    //    collection.isCollectionFromChatMuch = YES;
    //    collection.collectionFromMuchArray = muarra;
    //    collection.sessionType = self.module.MTTSessionEntity.sessionType;
    //    collection.collectSuccessBlock= ^(){
    //        self.editBottomView.hidden = YES;
    //        self.isMore = NO;
    //        [self.tableView reloadData];
    //        for (id objc in self.module.showingMessages)
    //        {
    //            if ([objc isKindOfClass:[MTTMessageEntity class]]) {
    //                MTTMessageEntity * message = (MTTMessageEntity*)objc;
    //                message.itemSelected = NO;
    //            }
    //
    //        }
    //    };
    //    [self.navigationController pushViewController:collection animated:YES];
}
#pragma mark 点击底部的删除
-(void)deleteMoreMessage:(NSArray*)array
{
    NSMutableArray * timeArray = [NSMutableArray array];//需要删除的时间
    NSMutableArray * messageArray = [NSMutableArray array];//需要删除的消息
    for (int i = 0 ; i < array.count; i++) {
        id objc = array[i];
        if ([objc isKindOfClass:[MTTMessageEntity class]])
        {
            MTTMessageEntity * message = (MTTMessageEntity*)objc;
            if (message.itemSelected) {
                [messageArray addObject:message];
                if (i == array.count-1) {
                    id objc3 = array[i-1];
                    if ([objc3 isKindOfClass:[DDPromptEntity class]]) {
                        [timeArray addObject:objc3];
                    }
                }
                else
                {
                    id objc1 = array[i-1];
                    id objc2 = array[i+1];
                    if ([objc1 isKindOfClass:[DDPromptEntity class]] && [objc2 isKindOfClass:[DDPromptEntity class]]) {
                        [timeArray addObject:objc1];
                    }
                }
            }
        }
    }
    
    if (!messageArray.count) {
        return;
    }
    
    if (messageArray.count > 100) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"聊天记录多选不能超过100条" delegate:nil cancelButtonTitle:@"群定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    for (MTTMessageEntity*message in messageArray) {
        //从本地删除
        [[MTTDatabaseUtil instance] deleteMesages:message completion:^(BOOL success) {
        }];
        NSString * type = [NSString string];
        DDMessageContentType msgContentType = message.msgContentType;
        switch (msgContentType) {
            case DDMessageTypeVoice:
                type = @"2";
                break;
            case DDMessageTypeImage:
                type = @"3";
                break;
            default:
                type = @"1";
                break;
        }
        //从服务器中删除
        //        NSString * string = [NSString stringWithFormat:@"%lu",(unsigned long)message.msgID];
        [self deleteMessage:[NSString stringWithFormat:@"%lu",(unsigned long)message.msgID] andType:type];
    }
    //从列表中删除
    [self.module.showingMessages removeObjectsInArray:timeArray];
    [self.module.showingMessages removeObjectsInArray:messageArray];
    
    [timeArray removeAllObjects];
    if (self.module.showingMessages.count>2)
    {
        for (int i = 0 ; i < self.module.showingMessages.count-2; i++) {
            id obcj = self.module.showingMessages[i];
            id objc1 = self.module.showingMessages[i+1];
            if ([objc1 isKindOfClass:[DDPromptEntity class]]&&[obcj isKindOfClass:[DDPromptEntity class]]) {
                [timeArray addObject:obcj];
            }
        }
        
        id objc3 = self.module.showingMessages[self.module.showingMessages.count-1];
        if ([objc3 isKindOfClass:[DDPromptEntity class]]) {
            [timeArray addObject:objc3];
        }
        
    }
    if (timeArray.count)
    {
        [self.module.showingMessages removeObjectsInArray:timeArray];
    }
    
    self.editBottomView.hidden = YES;
    self.isMore = NO;
    
    
    
    [self.tableView reloadData];
    
    //改变消息界面的显示
    if (self.module.showingMessages.count)
    {
        id objc = self.module.showingMessages[self.module.showingMessages.count-1];
        if ([objc isKindOfClass:[MTTMessageEntity class]]) {
            MTTMessageEntity * lastMessage = self.module.showingMessages[self.module.showingMessages.count-1];
            MTTSessionEntity * deletesession = self.module.MTTSessionEntity;
            if (lastMessage.msgContentType == DDMessageTypeImage) {
                deletesession.lastMsg=@"[图片]";
            }
            else if (lastMessage.msgContentType == DDMessageTypeVoice)
            {
                deletesession.lastMsg=@"[语音]";
            }
            else
            {
                deletesession.lastMsg= lastMessage.msgContent;
            }
            deletesession.lastMsgID=lastMessage.msgID;
            deletesession.timeInterval=lastMessage.msgTime;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMessageSuccessFull" object:deletesession];
        }
        else
        {
            MTTSessionEntity * deletesession = self.module.MTTSessionEntity;
            deletesession.lastMsg= @"暂无新消息";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMessageSuccessFull" object:deletesession];
        }
        if (self.module.showingMessages.count == 1 && [self.module.showingMessages[0] isKindOfClass:[DDPromptEntity class]]) {
            [self.module.showingMessages removeAllObjects];
            [self.tableView reloadData];
        }
        
    }
    else
    {
        MTTSessionEntity * deletesession = self.module.MTTSessionEntity;
        deletesession.lastMsg=@"暂无新消息";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMessageSuccessFull" object:deletesession];
    }
}
-(void)deleteFromList:(NSIndexPath*)indexPath andMessage:(MTTMessageEntity*)message
{
    if (indexPath.row == self.module.showingMessages.count-1)
    {
        if (self.module.showingMessages.count == 2)
        {
            [self.module.showingMessages removeObjectAtIndex:0];
            MTTSessionEntity * deletesession = self.module.MTTSessionEntity;
            deletesession.lastMsg=@"暂无新消息";
            deletesession.lastMsgID=message.msgID;
            deletesession.timeInterval=message.msgTime;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMessageSuccessFull" object:deletesession];
        }
        else
        {
            id objc = self.module.showingMessages[indexPath.row-1];
            if ([objc isKindOfClass:[DDPromptEntity class]]) {
                
                objc = self.module.showingMessages[indexPath.row-2];
                [self.module.showingMessages removeObjectAtIndex:indexPath.row-1];
            }
            MTTMessageEntity * deleteMessage = (MTTMessageEntity*)objc;
            MTTSessionEntity * deletesession = self.module.MTTSessionEntity;
            if (deleteMessage.msgContentType == DDMessageTypeImage) {
                deletesession.lastMsg=@"[图片]";
            }
            else if (deleteMessage.msgContentType == DDMessageTypeVoice)
            {
                deletesession.lastMsg=@"[语音]";
            }
            else
            {
                deletesession.lastMsg= deleteMessage.msgContent;
            }
            deletesession.lastMsgID=deleteMessage.msgID;
            deletesession.timeInterval=deleteMessage.msgTime;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMessageSuccessFull" object:deletesession];
        }
    }
    else
    {
        id objc = self.module.showingMessages[indexPath.row-1];
        id objc1 = self.module.showingMessages[indexPath.row+1];
        if ([objc isKindOfClass:[DDPromptEntity class]]) {
            if ([objc1 isKindOfClass:[DDPromptEntity class]]) {
                [self.module.showingMessages removeObject:objc1];
            }
        }
    }
}
#pragma mark 多个招聘和面试
-(UITableViewCell*)p_muchApplyAndWantCell_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(MTTMessageEntity*)message
{
    static NSString * identifier = @"MuchApplyAndWantCellIdentifier";
    DDChatBaseCell * cell = (DDChatBaseCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MuchApplyAndWantCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.session = self.module.MTTSessionEntity;
    cell.indexPath = indexPath;
    cell.isBlackNameOrNot = self.isBlackNameOrNot;
    cell.isDeleteOrNot = self.isDeleteOrNot;
    //    cell.backgroundColor = [UIColor blackColor];
    NSString* myUserID = [RuntimeStatus instance].user.objID;
    if ([message.senderId isEqualToString:myUserID])
    {
        [cell setLocation:DDBubbleRight];
    }
    else
    {
        [cell setLocation:DDBubbleLeft];
    }
    [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
        
    }];
    [cell setContent:message];
    cell.isMore = self.isMore;
    cell.itemSelected = message.itemSelected;
    
    __weak MuchApplyAndWantCell * weakCell = (MuchApplyAndWantCell*)cell;
    //点击menu上的重发
    [cell setClickMenuSendAgain:^{
        [weakCell showSending];
        [weakCell sendeApplyAndWantAgajn:message success:^(NSString *string, MTTMessageEntity *mess) {
            [self clickSendAgainBlackName:@"1" and:message andBlackMeaage:mess andIndex:indexPath andBlockStr:string];
        }];
    }];
    [cell setSendAgain:^{//再次发送
        [weakCell showSending];
        [weakCell sendeApplyAndWantAgajn:message success:^(NSString *string, MTTMessageEntity *mess) {
            [self clickSendAgainBlackName:@"1" and:message andBlackMeaage:mess andIndex:indexPath andBlockStr:string];
        }];
    }];
    weakCell.clickImage = ^(NSIndexPath*index){
        [self clickMuchMessage:message];
    };
    
    [cell setTapInBubble:^{
        if (self.isMore) {
            [self changeChoiseState:indexPath andBtn:weakCell.choiseBtn];
            return ;
        }
        [self clickMuchMessage:message];
        //        NSString * ccontent = [NSString stringWithFormat:@"%@",message.msgContent];
        //        NSData * data = [ccontent dataUsingEncoding:NSUTF8StringEncoding];
        //        NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        //        if (dictionary.count == 2) {
        //            NSString * contentStr = dictionary[@"content"];
        //            NSData * data1 = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
        //            dictionary = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        //        }
        //
        //
        //        if (message.msgContentType == DDMEssageMuchMyWantAndApply) {//多个求职和招聘
        //            NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
        //            NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
        //            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        //
        //            ShareDetailController *detail = [[ShareDetailController alloc] init];
        //            detail.dic = [self rightShareDic:dictionary];
        //            detail.type = [dic[@"type"] isEqualToString:@"1"]?WPMainPositionTypeInterView:WPMainPositionTypeRecruit;
        //            [dic[@"type"] isEqualToString:@"1"]?(detail.title = @"求职简历"):(detail.title = @"企业招聘");
        //            detail.chatDic = [self rightShareOtherDic:message];
        //            detail.dic1 = dictionary;
        //
        //
        //            NSString * urlStr = [NSString stringWithFormat:@"%@",dictionary[@"url"]];
        //            NSString * subStr = [urlStr substringToIndex:2];
        //            if ([subStr isEqualToString:@"1/"]||[subStr isEqualToString:@"2/"]) {
        //                detail.url = [urlStr substringFromIndex:1];
        //            }
        //            else
        //            {
        //                detail.url = [NSString stringWithFormat:@"%@",dictionary[@"url"]];
        //            }
        //
        //
        //            detail.message = message;
        //            detail.isGroup = (self.module.MTTSessionEntity.sessionType == SessionTypeSessionTypeGroup);
        //            [self.navigationController pushViewController:detail animated:YES];
        //        }
        //        else
        //        {//聊天记录
        //            MuchCollectionFromChatDetail * detail = [[MuchCollectionFromChatDetail alloc]init];
        //            detail.Msgid = dictionary[@"id"];
        //            detail.chatClick = YES;
        //            detail.title = dictionary[@"title"];
        //            detail.userName = dictionary[@"from_user_name"];
        //            detail.from_user_id = dictionary[@"from_user_id"];
        //            NSString * baseStr = [WPMySecurities textBeBase64:ccontent];
        //
        //            NSDictionary * dic = @{@"content":baseStr};
        //            detail.tranmitDic = dic;
        //            detail.message = message;
        //            [self.navigationController pushViewController:detail animated:YES];
        //        }
    }];
    //转发
    [cell setTranmitMessag:^{
        
        NSString * toUserId = [self getToUser:message];
        [self tranmitMessage:message.msgContent andMessageType:message.msgContentType andToUserId:toUserId andmessage:message];
    }];
    
    [cell setDeleteMessage:^{
        [self setType:@"1" andMessage:message andIndexpath:indexPath];
    }];
    
    //更多
    [cell setClickMoreChoise:^{
        message.itemSelected = YES;
        [self clickMoreMessage];
    }];
    //点击更多时选择
    [cell setClickLeftBtn:^(NSIndexPath *indexPath,UIButton*sender) {
        [self changeChoiseState:indexPath andBtn:sender];
    }];
    
    //收藏
    [cell setClickCollection:^{
        if (message.msgContentType == DDMEssageMuchMyWantAndApply)
        {
            NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
            NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            [self pushToCollection:dic[@"id"] andUrl:dic[@"url"] andFlag:dic[@"type"] message:message];
        }
        else
        {
            [self pushCollection:message];
        }
        //        NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
        //        NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
        //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        //         [self pushToCollection:dic[@"id"] andUrl:dic[@"url"] andFlag:dic[@"type"]];
    }];
    return cell;
}
-(void)clickMuchMessage:(MTTMessageEntity*)message
{
    NSString * ccontent = [NSString stringWithFormat:@"%@",message.msgContent];
    NSData * data = [ccontent dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if (dictionary.count == 2) {
        NSString * contentStr = dictionary[@"content"];
        NSData * data1 = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
        dictionary = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
    }
    
    
    if (message.msgContentType == DDMEssageMuchMyWantAndApply) {//多个求职和招聘
        NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
        NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        ShareDetailController *detail = [[ShareDetailController alloc] init];
        detail.dic = [self rightShareDic:dictionary];
        detail.type = [dic[@"type"] isEqualToString:@"1"]?WPMainPositionTypeInterView:WPMainPositionTypeRecruit;
        [dic[@"type"] isEqualToString:@"1"]?(detail.title = @"求职简历"):(detail.title = @"企业招聘");
        detail.chatDic = [self rightShareOtherDic:message];
        detail.dic1 = dictionary;
        
        
        NSString * urlStr = [NSString stringWithFormat:@"%@",dictionary[@"url"]];
        NSString * subStr = [urlStr substringToIndex:2];
        if ([subStr isEqualToString:@"1/"]||[subStr isEqualToString:@"2/"]) {
            detail.url = [urlStr substringFromIndex:1];
        }
        else
        {
            detail.url = [NSString stringWithFormat:@"%@",dictionary[@"url"]];
        }
        
        
        detail.message = message;
        detail.isGroup = (self.module.MTTSessionEntity.sessionType == SessionTypeSessionTypeGroup);
        [self.navigationController pushViewController:detail animated:YES];
    }
    else
    {//聊天记录
        MuchCollectionFromChatDetail * detail = [[MuchCollectionFromChatDetail alloc]init];
        detail.Msgid = dictionary[@"id"];
        detail.chatClick = YES;
        detail.title = dictionary[@"title"];
        detail.userName = dictionary[@"from_user_name"];
        detail.from_user_id = dictionary[@"from_user_id"];
        NSString * baseStr = [WPMySecurities textBeBase64:ccontent];
        
        NSDictionary * dic = @{@"content":baseStr};
        detail.tranmitDic = dic;
        detail.message = message;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark点击重发时是否拉进黑名单
-(void)clickSendAgainBlackName:(NSString*)type and:(MTTMessageEntity*)message andBlackMeaage:(MTTMessageEntity*)blackMessage andIndex:(NSIndexPath*)index andBlockStr:(NSString*)string
{
    if (string.intValue)
    {
        [self deleteMessageFromDetail:index andMessage:message andType:type];
        message.msgTime = blackMessage.msgTime-1;
        [self.module.showingMessages addObject:message];
        [self.module.showingMessages addObject:blackMessage];
        [[MTTDatabaseUtil instance] insertMessages:@[message,blackMessage] success:^{
        } failure:^(NSString *errorDescripe) {
        }];
        [self.tableView reloadData];
    }
    else
    {
        if (index.row<self.module.showingMessages.count-1) {
            MTTMessageEntity * mes = self.module.showingMessages[index.row+1];
            if (mes.msgContentType == DDMEssageLitterInviteAndApply) {
                NSIndexPath * indexp = [NSIndexPath indexPathForRow:index.row+1 inSection:0];
                DDPromptCell* proCell = [self.tableView cellForRowAtIndexPath:indexp];
                if ([proCell.promptLabel.text isEqualToString:@"消息已发出,但被对方拒收了。"]||[proCell.promptLabel.text isEqualToString:@"你还不是对方的好友,添加对方为好友,成功后即可聊天\n"]) {
                    [self.module.showingMessages removeObjectAtIndex:indexp.row];
                    //                    double msgTime = [[NSDate date] timeIntervalSince1970];
                    //                    message.msgTime = msgTime;
                    [[MTTDatabaseUtil instance] deleteMesages:mes completion:^(BOOL success) {
                    }];
                    [self.tableView reloadData];
                }
            }
        }
        //发送成功时位置移动到最下面
        [self.module.showingMessages removeObject:message];
        message.state = DDmessageSendSuccess;
        [self.module.showingMessages insertObject:message atIndex:self.module.showingMessages.count];
        [self.tableView reloadData];
    }
}
-(void)pushCollection:(MTTMessageEntity*)message
{
    NSString * ccontent = [NSString stringWithFormat:@"%@",message.msgContent];
    NSData * data = [ccontent dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    CollectViewController * collection = [[CollectViewController alloc]init];
    collection.muchDic = dictionary;
    //    collection.isCollectionFromChat = YES;
    collection.collectSuccessBlock= ^(){
        //        [MBProgressHUD createHUD:@"收藏成功" View:self.view];
        
    };
    MTTSessionEntity * session = self.module.MTTSessionEntity;
    if (session.sessionType == SessionTypeSessionTypeGroup) {
        collection.col4 = [NSString stringWithFormat:@"%@",[session.sessionID componentsSeparatedByString:@"_"][1]];
    }
    //    collection.user_id = [NSString stringWithFormat:@"%@",[message.senderId componentsSeparatedByString:@"_"][1]];
    [self.navigationController pushViewController:collection animated:YES];
}
-(NSDictionary*)rightShareOtherDic:(MTTMessageEntity*)message
{
    NSString * content = message.msgContent;
    NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
    NSString * avatar_0 = [NSString stringWithFormat:@"%@",dic[@"avatar_0"]];
    NSString * avatar_1 = [NSString stringWithFormat:@"%@",dic[@"avatar_1"]];
    NSString * avatar_2 = [NSString stringWithFormat:@"%@",dic[@"avatar_2"]];
    NSString * avatar_3 = [NSString stringWithFormat:@"%@",dic[@"avatar_3"]];
    NSMutableArray * murray = [NSMutableArray array];
    avatar_0.length?[murray addObject:@{@"small_address":avatar_0}]:0;
    avatar_1.length?[murray addObject:@{@"small_address":avatar_1}]:0;
    avatar_2.length?[murray addObject:@{@"small_address":avatar_2}]:0;
    avatar_3.length?[murray addObject:@{@"small_address":avatar_3}]:0;
    
    //    NSString * classN = nil;
    //    [dic[@"type"] isEqualToString:@"1"]?(classN = @"7"):(classN = @"8");
    
    
    NSDictionary * dictionary = @{@"avatar":dic[@"avatar_0"],@"company":dic[@"title"],@"title":[NSString stringWithFormat:@"%@,%@,%@",dic[@"position_0"],dic[@"position_1"],dic[@"position_2"]],@"url":dic[@"url"],@"jobid":dic[@"id"],@"img_url":murray};
    return dictionary;
}
-(NSDictionary*)rightShareDic:(NSDictionary*)infoDic
{
    NSDictionary * dic = [[NSDictionary alloc]init];
    NSString * avatar_0 = [NSString stringWithFormat:@"%@",infoDic[@"avatar_0"]];
    NSString * avatar_1 = [NSString stringWithFormat:@"%@",infoDic[@"avatar_1"]];
    NSString * avatar_2 = [NSString stringWithFormat:@"%@",infoDic[@"avatar_2"]];
    NSString * avatar_3 = [NSString stringWithFormat:@"%@",infoDic[@"avatar_3"]];
    NSMutableArray * murray = [NSMutableArray array];
    avatar_0.length?[murray addObject:@{@"small_address":avatar_0}]:0;
    avatar_1.length?[murray addObject:@{@"small_address":avatar_1}]:0;
    avatar_2.length?[murray addObject:@{@"small_address":avatar_2}]:0;
    avatar_3.length?[murray addObject:@{@"small_address":avatar_3}]:0;
    NSDictionary * shareMsgDic = @{@"jobNo":[NSString stringWithFormat:@"%lu",(unsigned long)murray.count],@"share_title":infoDic[@"title"],@"share_url":infoDic[@"url"],@"jobPhoto":murray};
    dic = @{@"share":[infoDic[@"type"] isEqualToString:@"1"]?@"2":([infoDic[@"classN"] isEqualToString:@"2"]?infoDic[@"share"]:@"3"),
            @"jobids":infoDic[@"curId"],
            @"sid":@"",
            @"jobNo":[NSString stringWithFormat:@"%lu",(unsigned long)murray.count],@"shareMsg":shareMsgDic};
    return dic;
}

#pragma mark  名片
-(UITableViewCell*)p_personCardCell_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(MTTMessageEntity*)message
{
    static NSString * identifier = @"DDPersonCardCellIdentifier";
    DDChatBaseCell* cell = (DDChatBaseCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell =[[DDChatPersonalCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.session = self.module.MTTSessionEntity;
    cell.indexPath = indexPath;
    cell.isBlackNameOrNot = self.isBlackNameOrNot;
    cell.isDeleteOrNot = self.isDeleteOrNot;
    NSString* myUserID = [RuntimeStatus instance].user.objID;
    if ([message.senderId isEqualToString:myUserID])
    {
        [cell setLocation:DDBubbleRight];
    }
    else
    {
        [cell setLocation:DDBubbleLeft];
    }
    [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
        
    }];
    [cell setContent:message];
    cell.isMore = self.isMore;
    cell.itemSelected = message.itemSelected;
    
    __weak DDChatPersonalCardCell * weakCell = (DDChatPersonalCardCell*)cell;
    
    [cell setClickMenuSendAgain:^{
        [weakCell showSending];
        [weakCell sendePersoinCardAgajn:message success:^(NSString *string, MTTMessageEntity *mess) {
            [self clickSendAgainBlackName:@"1" and:message andBlackMeaage:mess andIndex:indexPath andBlockStr:string];
        }];
    }];
    [cell setSendAgain:^{//再次发送
        [weakCell showSending];
        [weakCell sendePersoinCardAgajn:message success:^(NSString *string, MTTMessageEntity *mess) {
            [self clickSendAgainBlackName:@"1" and:message andBlackMeaage:mess andIndex:indexPath andBlockStr:string];
        }];
    }];
    
    
    [cell setTapInBubble:^{
        if (self.isMore) {
            [self changeChoiseState:indexPath andBtn:weakCell.choiseBtn];
            return ;
        }
        
        WPNewResumeListModel * model = [[WPNewResumeListModel alloc]init];
        NSString * ccontent = [NSString stringWithFormat:@"%@",message.msgContent];
        NSData * data = [ccontent dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        switch (message.msgContentType) {
            case DDMEssagePersonalaCard:
            {
                NSString * user_id = [NSString stringWithFormat:@"%@",dictionary[@"user_id"]];
                PersonalInfoViewController * personal = [[PersonalInfoViewController alloc]init];
                personal.friendID = user_id;
                [self.navigationController pushViewController:personal animated:YES];
            }
                break;
            case DDMEssageMyApply://求职
            {
                NearInterViewController *interView = [[NearInterViewController alloc]init];
                interView.isFromChatClick = YES;
                
                interView.isRecuilist = 0;
                interView.subId = [NSString stringWithFormat:@"%@",dictionary[@"qz_id"]];
                interView.resumeId = [NSString stringWithFormat:@"%@",dictionary[@"qz_id"]];
                interView.userId = [NSString stringWithFormat:@"%@",dictionary[@"belong"]];
                WPShareModel *shareModel = [WPShareModel sharedModel];
                interView.isSelf = [dictionary[@"belong"] isEqualToString:shareModel.dic[@"userid"]];
                interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,[NSString stringWithFormat:@"%@",dictionary[@"qz_id"]],kShareModel.userId];
                
                model.resumeId = [NSString stringWithFormat:@"%@",dictionary[@"qz_id"]];
                model.HopePosition = [NSString stringWithFormat:@"%@",dictionary[@"qz_position"]];
                model.name = [NSString stringWithFormat:@"%@",dictionary[@"qz_name"]];
                model.sex = [NSString stringWithFormat:@"%@",dictionary[@"qz_sex"]];
                model.birthday = @"";
                model.education = [NSString stringWithFormat:@"%@",dictionary[@"qz_educaiton"]];
                model.WorkTim = [NSString stringWithFormat:@"%@",dictionary[@"qz_workTime"]];
                model.avatar =[NSString stringWithFormat:@"%@",dictionary[@"qz_avatar"]];
                interView.model = model;
                [self.navigationController pushViewController:interView animated:YES];
            }
                break;
            case DDMEssageMyWant://招聘
            {
                NearInterViewController *interView = [[NearInterViewController alloc]init];
                interView.isRecuilist = 1;
                interView.isFromChatClick = YES;
                interView.subId = [NSString stringWithFormat:@"%@",dictionary[@"zp_id"]];
                interView.resumeId = [NSString stringWithFormat:@"%@",dictionary[@"zp_id"]];
                interView.userId = [NSString stringWithFormat:@"%@",dictionary[@"belong"]];
                interView.isSelf = YES;
                interView.isSelf = [dictionary[@"belong"] isEqualToString:kShareModel.userId];
                interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,[NSString stringWithFormat:@"%@",dictionary[@"zp_id"]],kShareModel.userId];
                model.resumeId =[NSString stringWithFormat:@"%@",dictionary[@"qz_id"]];
                model.jobPositon =[NSString stringWithFormat:@"%@",dictionary[@"zp_position"]];
                model.avatar =[NSString stringWithFormat:@"%@",dictionary[@"zp_avatar"]];
                model.enterpriseName =[NSString stringWithFormat:@"%@",dictionary[@"cp_name"]];
                interView.model = model;
                [self.navigationController pushViewController:interView animated:YES];
            }
                break;
            case DDMEssageSHuoShuo:
            {
                NSString * content = [NSString stringWithFormat:@"%@",message.msgContent];
                NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NewDetailViewController *detail = [[NewDetailViewController alloc] init];
                NSDictionary *info = @{@"sid":dictionary[@"shuoshuoid"],@"nick_name":dictionary[@"nick_name"],@"user_id":dictionary[@"shuoshuoid"]};
                detail.info = info;
                detail.isFromCollection = YES;
                [self.navigationController pushViewController:detail animated:YES];
            }
                break;
            case DDMEssageLitteralbume:
            {
                NSString * content = [NSString stringWithFormat:@"%@",message.msgContent];
                NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                
                NSString * from_type = dictionary[@"from_type"];
                if ([from_type isEqualToString:@"1"])//相册
                {
                    NSString * name = dictionary[@"from_title"];
                    NSArray * nameArray = [name componentsSeparatedByString:@","];
                    name = nameArray[0];
                    
                    WPGroupAlumDetailViewController *detail = [[WPGroupAlumDetailViewController alloc] init];
                    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/Group_album.ashx"];
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"action"] = @"GetAlbumInfo";
                    params[@"username"] = kShareModel.username;
                    params[@"password"] = kShareModel.password;
                    params[@"album_id"] = dictionary[@"from_id"];//from_id
                    params[@"user_id"] = kShareModel.userId;
                    params[@"group_id"] = dictionary[@"from_qun_id"];
                    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
                        GroupPhotoAlumListModel*model = [GroupPhotoAlumListModel mj_objectWithKeyValues:json];
                        detail.info= model;
                        detail.isFromChat = YES;
                        detail.isOwner = NO;
                        detail.groupId = dictionary[@"from_g_id"];
                        detail.isCommetFromAlum = NO;
                        detail.albumId =dictionary[@"from_id"];
                        detail.group_id = dictionary[@"from_qun_id"];
                        detail.mouble = self.module;
                        if ([json[@"status"] isEqualToString:@"0"]) {
                            detail.isBack = YES;
                        }
                        
                        [self.navigationController pushViewController:detail animated:YES];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }
                else//公告
                {
                    WPNoticeDetailViewController *detail = [[WPNoticeDetailViewController alloc] init];
                    detail.gtype = ([[NSString stringWithFormat:@"user_%@",kShareModel.userId] isEqualToString:message.senderId])?@"1":@"0";
                    detail.noticeId = dictionary[@"from_id"];
                    GroupInformationListModel *infoModel = [[GroupInformationListModel alloc]init];
                    infoModel.group_id = [NSString stringWithFormat:@"%@",dictionary[@"from_qun_id"]];
                    detail.infoModel = infoModel;
                    detail.groupID = [NSString stringWithFormat:@"%@",dictionary[@"from_g_id"]];
                    detail.mouble = self.module;
                    detail.clickIndex = indexPath;
                    //                detail.infoModel.group_id = [NSString stringWithFormat:@"%@",dictionary[@"from_qun_id"]];
                    [self.navigationController pushViewController:detail animated:YES];
                }
            }
                break;
            default:
                
                break;
        }
    }];
    
    //转发
    [cell setTranmitMessag:^{
        
        NSString * toUserId = [self getToUser:message];
        [self tranmitMessage:message.msgContent andMessageType:message.msgContentType andToUserId:toUserId andmessage:message];
    }];
    
    //删除
    [cell setDeleteMessage:^{
        [self setType:@"1" andMessage:message andIndexpath:indexPath];
    }];
    
    [cell setClickMoreChoise:^{
        self.editBottomView.hidden = NO;
    }];
    
    //更多
    
    [cell setClickMoreChoise:^{
        message.itemSelected = YES;
        [self clickMoreMessage];
    }];
    //点击更多时选择
    [cell setClickLeftBtn:^(NSIndexPath *indexPath,UIButton*sender) {
        [self changeChoiseState:indexPath andBtn:sender];
    }];
    
    //收藏
    [cell setClickCollection:^{
        NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
        NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];//@"0"
        [self pushToCollection:(message.msgContentType == DDMEssagePersonalaCard)?dic[@"user_id"]:(message.msgContentType == DDMEssageSHuoShuo)?dic[@"shuoshuoid"]:(message.msgContentType == DDMEssageMyWant)?dic[@"zp_id"]:dic[@"qz_id"] andUrl:@"" andFlag:(message.msgContentType == DDMEssagePersonalaCard?@"0":(message.msgContentType==DDMEssageMyWant)?@"2":(message.msgContentType == DDMEssageSHuoShuo)?@"4":@"1") message:message];
    }];
    return cell;
}
-(void)stopVoice:(MTTMessageEntity*)message
{
    for (int i = 0 ; i < self.module.showingMessages.count; i++) {
        id objc = self.module.showingMessages[i];
        if ([objc isKindOfClass:[MTTMessageEntity class]]) {
            MTTMessageEntity * content =(MTTMessageEntity*)objc;
            if (content.msgContentType == DDMessageTypeVoice && message.msgContent != content.msgContent) {
                if ([[PlayerManager sharedManager] playingFileName:content.msgContent]) {
                    [[PlayerManager sharedManager] stopPlaying];
                    DDChatVoiceCell * cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    [cell1 stopVoicePlayAnimation];
                }
            }
        }
    }
}
#pragma mark 语音
- (UITableViewCell*)p_voiceCell_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(MTTMessageEntity*)message
{
    static NSString* identifier = @"DDVoiceCellIdentifier";
    DDChatBaseCell* cell = (DDChatBaseCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[DDChatVoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.session =self.module.MTTSessionEntity;
    cell.indexPath = indexPath;
    NSString* myUserID = [RuntimeStatus instance].user.objID;
    if ([message.senderId isEqualToString:myUserID])
    {
        [cell setLocation:DDBubbleRight];
    }
    else
    {
        [cell setLocation:DDBubbleLeft];
    }
    [cell setContent:message];
    cell.isMore = self.isMore;
    cell.itemSelected = message.itemSelected;
    __weak DDChatVoiceCell* weakCell = (DDChatVoiceCell*)cell;
    [(DDChatVoiceCell*)cell setTapInBubble:^{
        //当前语音在播放是点击微博放的语音需要暂停当前语音
        [self stopVoice:message];
        //播放语音
        if ([[PlayerManager sharedManager] playingFileName:message.msgContent])
        {
            [[PlayerManager sharedManager] stopPlaying];
        }
        else
        {
            [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
            
            BOOL isOrNot = kShareModel.speakMode;//[[UIDevice currentDevice] isProximityMonitoringEnabled]
            if (isOrNot)
            {//听筒模式
                
                
                NSString* fileName = message.msgContent;
                [[PlayerManager sharedManager] playAudioWithFileName:fileName playerType:DDEarPhone delegate:self];
                [message.info setObject:@"1" forKey:DDVOICE_PLAYED];
                [weakCell showVoicePlayed];
                [[MTTDatabaseUtil instance] updateVoiceMessage:message completion:^(BOOL result) {
                }];
                //                [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
                //                }];
                
                UILabel * hidelabel = (UILabel*)[self.view viewWithTag:555555];
                [hidelabel removeFromSuperview];
                UILabel * label = [modeView textAndPosition:@"已为您切换到听筒播放模式" andFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
                label.tag = 555555;
                [self.view addSubview:label];
                [self performSelector:@selector(hideLabel:) withObject:label afterDelay:2];
                
            }
            else//扬声器模式
            {
                NSString* fileName = message.msgContent;
                [[PlayerManager sharedManager] playAudioWithFileName:fileName playerType:DDSpeaker delegate:self];
                [message.info setObject:@"1" forKey:DDVOICE_PLAYED];
                [weakCell showVoicePlayed];
                [[MTTDatabaseUtil instance] updateVoiceMessage:message completion:^(BOOL result) {
                }];
                //                [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
                //                }];
            }
            //            NSString* fileName = message.msgContent;
            //            [[PlayerManager sharedManager] playAudioWithFileName:fileName delegate:self];
            //            [message.info setObject:@"1" forKey:DDVOICE_PLAYED];
            //            [weakCell showVoicePlayed];
            //            [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
            //            }];
        }
    }];
    
    
    [(DDChatVoiceCell*)cell setEarphonePlay:^{
        kShareModel.speakMode = YES;
        
        UILabel * hidelabel = (UILabel*)[self.view viewWithTag:555555];
        [hidelabel removeFromSuperview];
        UILabel * label = [modeView textAndPosition:@"已为您切换到听筒播放模式" andFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        label.tag = 555555;
        [self.view addSubview:label];
        [self performSelector:@selector(hideLabel:) withObject:label afterDelay:2];
        
        //关闭距离监听
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        [weakCell earOrSpeak:YES andMessage:message];
        
        if ([[PlayerManager sharedManager] playingFileName:message.msgContent])
        {
            NSString* fileName = message.msgContent;
            [[PlayerManager sharedManager] playAudioWithFileName:fileName playerType:DDEarPhone delegate:self];
        }
        
        //听筒播放
        //        NSString* fileName = message.msgContent;
        //        [[PlayerManager sharedManager] playAudioWithFileName:fileName playerType:DDEarPhone delegate:self];
        //        [message.info setObject:@"1" forKey:DDVOICE_PLAYED];
        //        [weakCell showVoicePlayed];
        //        [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
        //        }];
        
    }];
    
    [(DDChatVoiceCell*)cell setSpeakerPlay:^{
        kShareModel.speakMode = NO;
        UILabel * hidelabel = (UILabel*)[self.view viewWithTag:555555];
        [hidelabel removeFromSuperview];
        UILabel * label = [modeView textAndPosition:@"已为您切换到扬声器模式" andFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        label.tag = 555555;
        [self.view addSubview:label];
        [self performSelector:@selector(hideLabel:) withObject:label afterDelay:2];
        //开启距离监听
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        [weakCell earOrSpeak:NO andMessage:message];
        
        
        if ([[PlayerManager sharedManager] playingFileName:message.msgContent])
        {
            NSString* fileName = message.msgContent;
            [[PlayerManager sharedManager] playAudioWithFileName:fileName playerType:DDSpeaker delegate:self];
        }
        
        //扬声器播放
        //        NSString* fileName = message.msgContent;
        //        [[PlayerManager sharedManager] playAudioWithFileName:fileName playerType:DDSpeaker delegate:self];
        //        [message.info setObject:@"1" forKey:DDVOICE_PLAYED];
        //        [weakCell showVoicePlayed];
        //        [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
        //        }];
    }];
    
    //点击menu上的重发
    [cell setClickMenuSendAgain:^{
        [weakCell showSending];
        [weakCell sendVoiceAgain:message];
    }];
    [(DDChatVoiceCell *)cell setSendAgain:^{
        //重发
        [weakCell showSending];
        [weakCell sendVoiceAgain:message];
    }];
    
    [cell setDeleteMessage:^{
        [self setType:@"2" andMessage:message andIndexpath:indexPath];
    }];
    //转发
    [cell setTranmitMessag:^{
        [self tranmitMessage:message.msgContent andMessageType:message.msgContentType andToUserId:message.toUserID andmessage:message];
    }];
    
    [cell setClickMoreChoise:^{
        self.editBottomView.hidden = NO;
    }];
    
    //更多
    [cell setClickMoreChoise:^{
        message.itemSelected = YES;
        [self clickMoreMessage];
    }];
    //点击更多时选择
    [cell setClickLeftBtn:^(NSIndexPath *indexPath,UIButton*sender) {
        [self changeChoiseState:indexPath andBtn:sender];
    }];
    
    //收藏
    [cell setClickCollection:^{
        [self pushToCollection:@"" andUrl:@"" andFlag:@"" message:message];
    }];
    return cell;
}
-(void)hideLabel:(UILabel*)label
{
    //  [UIView animateWithDuration:0.5 animations:^{
    //      [label removeFromSuperview];
    // }];
    [UIView animateWithDuration:4 animations:^{
        label.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
    
    
}
#pragma mark  时间
- (UITableViewCell*)p_promptCell_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(DDPromptEntity*)prompt
{
    static NSString* identifier = @"DDPromptCellIdentifier";
    DDPromptCell* cell = (DDPromptCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[DDPromptCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.indexPath = indexPath;
    NSString* promptMessage = prompt.message;
    if ([promptMessage isEqualToString:@"你还不是对方的好友,添加对方为好友,成功后即可聊天\n"]) {
        [cell setPromptAttr:promptMessage];
        cell.clickPromptLabel = ^(NSIndexPath*index){//点击添加对方为好友
            //判断是否是好友，防止重复添加
            [[MTTDatabaseUtil instance] loadBlackNamecompletion:^(NSArray *array) {
                BOOL isOrNot = false;
                for (WPBlackNameModel * model in array) {
                    if ([model.userId isEqualToString:self.module.MTTSessionEntity.sessionID]) {
                        isOrNot = YES;
                    }
                }
                if (isOrNot)
                {
                    [self clickAddBtn:index];
                }
                else
                {
                    [MBProgressHUD createHUD:@"你已是对方好友，可以直接聊天" View:self.view];
                }
            }];
            //            [self clickAddBtn:index];
        };
    }
    else
    {
        [cell setprompt:promptMessage];
    }
    //    [cell setprompt:promptMessage];
    
    return cell;
}
#pragma  mark  表情
- (UITableViewCell*)p_emotionCell_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(MTTMessageEntity*)message
{
    static NSString* identifier = @"DDEmotionCellIdentifier";
    DDEmotionCell* cell = (DDEmotionCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[DDEmotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.session =self.module.MTTSessionEntity;
    cell.indexPath = indexPath;
    
    NSString* myUserID =[RuntimeStatus instance].user.objID;
    if ([message.senderId isEqualToString:myUserID])
    {
        [cell setLocation:DDBubbleRight];
    }
    else
    {
        [cell setLocation:DDBubbleLeft];
    }
    
    [cell setContent:message];
    cell.isMore = self.isMore;
    cell.itemSelected = message.itemSelected;
    
    __weak DDEmotionCell* weakCell = cell;
    
    [cell setSendAgain:^{
        [weakCell sendTextAgain:message];
        
    }];
    
    [cell setTapInBubble:^{
        
    }];
    //转发
    [cell setTranmitMessag:^{
        [self tranmitMessage:message.msgContent andMessageType:message.msgContentType andToUserId:message.toUserID andmessage:message];
    }];
    
    [cell setClickMoreChoise:^{
        self.editBottomView.hidden = NO;
    }];
    
    
    //更多
    [cell setClickMoreChoise:^{
        [self clickMoreMessage];
    }];
    //点击更多时选择
    [cell setClickLeftBtn:^(NSIndexPath *indexPath,UIButton*sender) {
        [self changeChoiseState:indexPath andBtn:sender];
    }];
    
    //收藏
    [cell setClickCollection:^{
        [self pushToCollection:@"" andUrl:@"" andFlag:@"" message:message];
    }];
    return cell;
}
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if (object == progress && [keyPath isEqualToString:@"fractionCompleted"]) {
//        NSLog(@"下载进度:%.2f%%",progress.fractionCompleted * 100);
//    }
//}
#pragma mark 视频
-(UITableViewCell*)p_videoCell_tableVide:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(MTTMessageEntity*)message
{
    static NSString * identifier = @"DDVideoCellidentifier";
    DDVideoCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[DDVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.session =self.module.MTTSessionEntity;
    cell.indexPath = indexPath;
    cell.isBlackNameOrNot = self.isBlackNameOrNot;
    cell.isDeleteOrNot = self.isDeleteOrNot;
    NSString* myUserID = [RuntimeStatus instance].user.objID;
    if ([message.senderId isEqualToString:myUserID])
    {
        [cell setLocation:DDBubbleRight];
    }
    else
    {
        [cell setLocation:DDBubbleLeft];
    }
    if (![[UnAckMessageManager instance] isInUnAckQueue:message] && message.state == DDMessageSendFailure && [message isSendBySelf]) {
        message.state=DDMessageSendFailure;
    }
    [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
    }];
    [cell setContent:message];
    cell.isMore = self.isMore;
    cell.isChioseOrNot = self.isMore;
    cell.itemSelected = message.itemSelected;
    __weak DDVideoCell* weakCell = (DDVideoCell*)cell;
    [cell setClickMenuSendAgain:^{
        [weakCell showSending];
        //        [weakCell sendVideoAgain:message];
        [weakCell sendVideoAgain:message success:^(NSString *string, MTTMessageEntity *mess) {
            message.state = DDmessageSendSuccess;
            [self clickSendAgainBlackName:@"1" and:message andBlackMeaage:mess andIndex:indexPath andBlockStr:string];
        }];
    }];
    [cell setSendAgain:^{
        [weakCell showSending];
        [weakCell sendVideoAgain:message success:^(NSString *string, MTTMessageEntity *mess) {
            message.state = DDmessageSendSuccess;
            [self clickSendAgainBlackName:@"1" and:message andBlackMeaage:mess andIndex:indexPath andBlockStr:string];
        }];
        //        [weakCell sendVideoAgain:message];
    }];
    cell.clickBack = ^(NSIndexPath*indexPath){
        if (self.isMore) {
            [self changeChoiseState:indexPath andBtn:weakCell.choiseBtn];
            return ;
        }
        [self getVideoAndPhotoPath:indexPath andImageIndex:nil];
    };
    
    [cell setDeleteMessage:^{
        [self setType:@"1" andMessage:message andIndexpath:indexPath];
    }];
    
    //转发
    [cell setTranmitMessag:^{
        NSString * toUserId = [self getToUser:message];
        [self tranmitMessage:message.msgContent andMessageType:message.msgContentType andToUserId:toUserId andmessage:message];
    }];
    
    [cell setClickMoreChoise:^{
        self.editBottomView.hidden = NO;
    }];
    
    //更多
    
    [cell setClickMoreChoise:^{
        message.itemSelected = YES;
        [self clickMoreMessage];
    }];
    
    //点击更多时选择
    [cell setClickLeftBtn:^(NSIndexPath *indexPath,UIButton*sender) {
        [self changeChoiseState:indexPath andBtn:sender];
    }];
    
    //收藏
    [cell setClickCollection:^{
        NSString * content = message.msgContent;
        NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSString * videStr;
        if (dic) {
            
            videStr =dic[@"url"];
            if (![videStr hasPrefix:@"http"]) {
                videStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"url"]];
            }
        }
        else
        {
            videStr =content;
            if (![videStr hasPrefix:@"http"]) {
                videStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"url"]];
            }
            //          videStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,content];
        }
        
        
        [self collectiolTextAndPhotoCollectionClass:@"2" andContent:@"" angImageUrl:@"" andVdUrl:videStr message:message];
    }];
    return cell;
}
#pragma  mark 图片
- (UITableViewCell*)p_imageCell_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(MTTMessageEntity*)message
{
    static NSString* identifier = @"DDImageCellIdentifier";
    DDChatImageCell* cell = (DDChatImageCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[DDChatImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.session =self.module.MTTSessionEntity;
    cell.indexPath = indexPath;
    NSString* myUserID =[RuntimeStatus instance].user.objID;
    if ([message.senderId isEqualToString:myUserID])
    {
        [cell setLocation:DDBubbleRight];
    }
    else
    {
        [cell setLocation:DDBubbleLeft];
    }
    [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
    }];
    [cell setContent:message];
    cell.isMore = self.isMore;
    cell.itemSelected = message.itemSelected;
    cell.isBlackNameOrNot = self.isBlackNameOrNot;//是否是黑名单
    cell.isDeleteOrNot = self.isDeleteOrNot;
    __weak DDChatImageCell* weakCell = cell;
    [cell setClickMenuSendAgain:^{
        [weakCell showSending];
        [weakCell sendImageAgain:message success:^(NSString *string, MTTMessageEntity *mess) {
            [self clickSendAgainBlackName:@"3" and:message andBlackMeaage:mess andIndex:indexPath andBlockStr:string];
        }];
    }];
    [cell setSendAgain:^{
        [weakCell showSending];
        [weakCell sendImageAgain:message success:^(NSString *string, MTTMessageEntity *mess) {
            [self clickSendAgainBlackName:@"3" and:message andBlackMeaage:mess andIndex:indexPath andBlockStr:string];
        }];
    }];
    
    [cell setTapInBubble:^{//点击图片
        
        if (self.isMore) {
            [self changeChoiseState:indexPath andBtn:weakCell.choiseBtn];
            return ;
        }
        [self getVideoAndPhotoPath:nil andImageIndex:indexPath];
    }];
    [cell setPreview:cell.tapInBubble];
    //删除
    [cell setDeleteMessage:^{
        [self setType:@"3" andMessage:message andIndexpath:indexPath];
    }];
    //转发
    [cell setTranmitMessag:^{
        NSString * string = message.msgContent;
        NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString * toUserId = [self getToUser:message];
        NSString * sendStr = nil;
        if (message.state == DDMessageSendFailure) {
            WPUploadImage * upload = [[WPUploadImage alloc]init];
            [upload upLoadImage:dic[@"local"] success:^(NSString *imageStr) {
                [self tranmitMessage:imageStr andMessageType:message.msgContentType andToUserId:toUserId andmessage:message];
            } failed:^(NSError *error) {
                [MBProgressHUD showMessage:@"上传失败"];
            }];
        }
        else
        {
            
            sendStr = dic[@"url"];
            if (!sendStr) {
                sendStr = string;
            }
            [self tranmitMessage:sendStr andMessageType:message.msgContentType andToUserId:toUserId andmessage:message];
        }
    }];
    [cell setClickMoreChoise:^{
        self.editBottomView.hidden = NO;
    }];
    //更多
    [cell setClickMoreChoise:^{
        message.itemSelected = YES;
        [self clickMoreMessage];
    }];
    //点击更多时选择
    [cell setClickLeftBtn:^(NSIndexPath *indexPath,UIButton*sender) {
        [self changeChoiseState:indexPath andBtn:sender];
    }];
    
    //收藏
    [cell setClickCollection:^{
        NSString * urlString = message.msgContent;
        urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_PREFIX withString:@""];
        urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_SUFFIX withString:@""];
        
        NSData * data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (dic.count && [dic[@"url"] length]) {
            urlString =  dic[@"url"];
        }
        
        [self collectiolTextAndPhotoCollectionClass:@"1" andContent:@"" angImageUrl:urlString andVdUrl:@"" message:message];
    }];
    return cell;
}
-(NSString*)getToUser:(MTTMessageEntity*)message
{
    NSString * toUserId;
    NSString* myUserID =[RuntimeStatus instance].user.objID;
    if ([message.senderId isEqualToString:myUserID]) {
        toUserId = message.toUserID;
    }
    else
    {
        toUserId = message.senderId;
    }
    return toUserId;
}
#pragma mark点击图片是获取图片和视频
-(void)getVideoAndPhotoPath:(NSIndexPath*)videoIndex andImageIndex:(NSIndexPath*)imageIndex
{
    WPPhotoAndVideoController *PV = [[WPPhotoAndVideoController alloc]init];
    PV.fromChatNotCreat = YES;
    NSMutableArray * PVArray = [NSMutableArray array];
    NSMutableArray * originalArray = [NSMutableArray array];
    NSString * currentVideo = nil;
    MLPhotoBrowserPhoto * currentImage = nil;
    NSIndexPath * choise = videoIndex?videoIndex:imageIndex;
    MTTMessageEntity * messag = self.module.showingMessages[choise.row];
    //    for (id obj in self.module.showingMessages)
    //    {
    for (int i = 0 ; i < self.module.showingMessages.count; i++)
    {
        id obj = self.module.showingMessages[i];
        if ([obj isKindOfClass:[MTTMessageEntity class]])
        {
            NSMutableArray * imageUrlArray = [NSMutableArray array];
            NSURL * url = nil;
            MTTMessageEntity * message = (MTTMessageEntity*)obj;
            BOOL isOrNot = NO;
            if (message == messag) {
                isOrNot = YES;
            }
            if (message.msgContentType == DDMessageTypeImage)
            {//图片
                NSString* urlString = message.msgContent;
                urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_PREFIX withString:@""];
                urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_SUFFIX withString:@""];
                NSString * crrentString= nil;
                if([urlString rangeOfString:@"\"local\" : "].length >0)
                {
                    NSData* data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    crrentString = [[NSString stringWithFormat:@"%@",dic[@"url"]] length]?dic[@"url"]:dic[@"local"];
                    NSString *urlStrr = [dic[@"url"] stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
                    url = [NSURL URLWithString:urlStrr.length?urlStrr:dic[@"local"]];
                    [dic[@"url"] length]?[originalArray addObject:dic[@"url"]]:dic[@"local"];
                }
                else
                {
                    [originalArray addObject:urlString];
                    crrentString = urlString;
                    NSString *urlStr = [urlString stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
                    url = [NSURL URLWithString:urlStr];//urlString
                }
                if(url)
                {
                    DDChatImageCell * imageCell = nil;
                    if (imageIndex) {
                        imageCell  = [self.tableView cellForRowAtIndexPath:imageIndex];
                    }
                    [imageUrlArray addObject:url];
                    MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
                    photo.photoURL = url;
                    photo.user_id = [NSString stringWithFormat:@"%@",[messag.senderId componentsSeparatedByString:@"_"][1]];
                    
                    UIImageView * imageView = imageCell.msgImgView;//
                    if (imageIndex) {
                        photo.toView = imageView;
                        
                    }
                    
                    [PVArray addObject:photo];
                    if (isOrNot) {
                        currentImage = photo;
                        PV.currentStr = crrentString;
                    }
                }
            }
            else if (message.msgContentType == DDMEssageLitterVideo)//视频
            {
                NSString * contentStr = [NSString stringWithFormat:@"%@",message.msgContent];
                NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                if (dictionary)
                {
                    NSArray * arr = [dictionary[@"url"] componentsSeparatedByString:@":"];
                    if (arr)
                    {
                        if (![arr[0] isEqualToString:@"http"])
                        {
                            contentStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,dictionary[@"url"]];
                            if (isOrNot)
                            {
                                currentVideo = contentStr;
                            }
                        }
                        else
                        {
                            contentStr = dictionary[@"url"];
                            if (isOrNot)
                            {
                                currentVideo = contentStr;
                            }
                        }
                    }
                    else
                    {
                        contentStr = dictionary[@"local"];
                        if (isOrNot) {
                            currentVideo = contentStr;
                        }
                    }
                }
                else
                {
                    NSArray * conArra = [contentStr componentsSeparatedByString:@":"];
                    if (![conArra[0] isEqualToString:@"http"])
                    {
                        contentStr = [IPADDRESS stringByAppendingString:contentStr];
                        if (isOrNot) {
                            currentVideo = contentStr;
                        }
                    }
                    else
                    {
                        if (isOrNot)
                        {
                            currentVideo = contentStr;
                        }
                    }
                }
                if (contentStr.length) {
                    [originalArray addObject:contentStr];
                    [PVArray addObject:contentStr];
                }
            }
        }
    }
    //        }
    
    NSArray * array = PVArray;
    for (NSUInteger i = 0 ; i < array.count; i++) {
        if (imageIndex)
        {
            id obj = array[i];
            if ([obj isKindOfClass:[MLPhotoBrowserPhoto class]]) {
                MLPhotoBrowserPhoto * browse = (MLPhotoBrowserPhoto*)obj;
                if (browse == currentImage) {
                    PV.currentPage = i;
                }
            }
        }
        else
        {
            id obj = array[i];
            if ([obj isKindOfClass:[NSString class]]) {
                NSString * string = (NSString*)obj;
                if (string == currentVideo) {
                    PV.currentPage = i;
                }
            }
        }
    }
    PV.firstPage = PV.currentPage;
    PV.videoAndPhotoArr =PVArray;
    PV.isNeedShow = YES;
    PV.videoPhotoOriginalArr = originalArray;
    PV.isFirst = YES;
    [PV showPhotoVideo:self];
}
-(void)clickAddBtn:(NSIndexPath*)addIndex
{
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/personal_info_new.ashx",IPADDRESS];
    NSDictionary * dictionary = @{@"action":@"FriendValidate",@"user_id":kShareModel.userId,@"friend_id":[self.module.MTTSessionEntity.sessionID componentsSeparatedByString:@"_"][1]};
    [WPHttpTool postWithURL:urlStr params:dictionary success:^(id json) {
        NSString * friendValidate = [NSString stringWithFormat:@"%@",json[@"friendValidate"]];
        switch (friendValidate.intValue) {
            case 0://需要好友验证
            {
                WPAddNewFriendValidateController *addValidate = [[WPAddNewFriendValidateController alloc] init];
                addValidate.fuser_id = [self.module.MTTSessionEntity.sessionID componentsSeparatedByString:@"_"][1];
                addValidate.name = kShareModel.nick_name;
                addValidate.friend_mobile = @"";
                [self.navigationController pushViewController:addValidate animated:YES];
            }
                break;
            case 1://直接添加
            {
                [self addFriendDirectionary];
            }
                break;
            default:
                break;
        }
    } failure:^(NSError *error) {
    }];
}
-(void)addFriendDirectionary
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    WPAddNewFriendParam *param = [[WPAddNewFriendParam alloc] init];
    param.action = @"AddFriend";
    param.username = model.username;
    param.password = model.password;
    param.user_id = userInfo[@"userid"];
    param.fuser_id = [self.module.MTTSessionEntity.sessionID componentsSeparatedByString:@"_"][1];
    param.friend_mobile = @"";
    param.is_fjob = @"false";
    param.is_fcircle = @"false";
    param.is_fresume = @"false";
    param.belongGroup = @"";
    param.exec = @"1";
    param.is_show = nil;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WPAddNewFriendHttp WPAddNewFriendHttpWithParam:param success:^(WPAddNewFriendResult *result) {
        if (result.status.intValue == 0) {
            
            //从本地移除
            self.isDeleteOrNot = NO;
            WPBlackNameModel * model = [[WPBlackNameModel alloc]init];
            model.userId = self.module.MTTSessionEntity.sessionID;
            [[MTTDatabaseUtil instance] removeFromBlackName:@[model] completion:^(BOOL success) {
            }];
            [MBProgressHUD hideHUDForView:self.view];
            //添加成功后发送消息
            //            NSDictionary * dic = @{@"display_type":@"14",
            //                                   @"content":@{@"from_name":kShareModel.nick_name.length?kShareModel.nick_name:kShareModel.username,
            //                                                @"from_id":[NSString stringWithFormat:@"%@",[self.module.MTTSessionEntity.sessionID componentsSeparatedByString:@"_"][1]],
            //                                                @"to_id":kShareModel.userId}
            //                                   };
            NSDictionary * dic = @{@"display_type":@"14",
                                   @"content":@{@"from_name":kShareModel.nick_name.length?kShareModel.nick_name:kShareModel.username,
                                                @"from_id":kShareModel.userId,
                                                @"to_id":[NSString stringWithFormat:@"%@",[self.module.MTTSessionEntity.sessionID componentsSeparatedByString:@"_"][1]],
                                                @"from_type":@"1"}
                                   };
            NSError * error = nil;
            NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted  error:&error];
            NSString * cardStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            MTTMessageEntity * message = [MTTMessageEntity makeMessage:cardStr Module:self.module MsgType:DDMEssageAcceptApply];
            [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
                DDLog(@"消息插入DB成功");
            } failure:^(NSString *errorDescripe) {
                DDLog(@"消息插入DB失败");
            }];
            message.state = DDmessageSendSuccess;
            [self.tableView reloadData];
            [self scrollToBottomText:YES];
            
            message.msgContent = cardStr;
            [[DDMessageSendManager instance] sendMessage:message isGroup:NO Session:self.module.MTTSessionEntity  completion:^(MTTMessageEntity* theMessage,NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    message.state= theMessage.state;
                });
            } Error:^(NSError *error) {
            }];
        }else{
            [MBProgressHUD createHUD:result.info View:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力哦"];
    }];
}
-(void)deleteMessage:(NSString *)messageId andType:(NSString*)typeStr
{
    MTTSessionEntity * session = self.module.MTTSessionEntity;
    NSString * string = (session.sessionType == SessionTypeSessionTypeSingle)?@"2":@"1";
    
    messageId = [NSString stringWithFormat:@"%@:%@",messageId,typeStr];
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/delmsg.ashx",IPADDRESS];
    NSDictionary * dic = @{@"action":@"delgchatmsg",
                           @"TallType":string,
                           @"MsgID":messageId,
                           @"username":kShareModel.username,
                           @"password":kShareModel.password};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        NSLog(@"删除成功:%@",json);
    } failure:^(NSError *error) {
        
    }];
}
- (void)onPlaybackFinished
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}
//-(NSString*)isOrNotThumPhoto:(NSString*)photoStr
//{
//    NSString * finalStr = [NSString string];
//    NSString * urlStr =photoStr;
//    NSString * thumStr = @"thumbd_";
//    for (int i = 0 ; i < urlStr.length-7; i++) {
//        NSString * subStr = [urlStr substringWithRange:NSMakeRange(i, thumStr.length)];
//        if ([subStr isEqualToString:thumStr])
//        {
//            NSString * subFirstStr = [urlStr substringToIndex:i];
//            NSString * subSecStr = [urlStr substringFromIndex:i+thumStr.length];
//            finalStr  = [NSString stringWithFormat:@"%@%@",subFirstStr,subSecStr];
//
//            NSArray * array = [finalStr componentsSeparatedByString:@"_"];
//            if ([photoStr hasSuffix:@".jpg"])
//            {
//               finalStr = [NSString stringWithFormat:@"%@.jpg",array[0]];
//            }
//            else
//            {
//              finalStr = [NSString stringWithFormat:@"%@.png",array[0]];
//            }
//
//            return finalStr;
//        }
//    }
//    return photoStr;
//}
- (void)p_clickThRecordButton:(UIButton*)button
{
    [self.chatInputView.emotionbutton setBackgroundImage:[UIImage imageNamed:@"common_biaoqing"] forState:UIControlStateNormal];
    [self.chatInputView.emotionbutton setBackgroundImage:[UIImage imageNamed:@"chat_biaoqing_pre"] forState:UIControlStateHighlighted];
    self.chatInputView.emotionbutton.tag = 0;
    
    switch (button.tag) {
        case DDVoiceInput:
            //开始录音
            [self p_hideBottomComponent];
            [button setBackgroundImage:[UIImage imageNamed:@"chat_jp"] forState:UIControlStateNormal];//dd_input_normal
            button.tag = DDTextInput;
            [self.chatInputView willBeginRecord];
            [self.chatInputView.textView resignFirstResponder];
            _currentInputContent = self.chatInputView.textView.text;
            if ([_currentInputContent length] > 0)
            {
                [self.chatInputView.textView setText:nil];
            }
            break;
        case DDTextInput:
            //开始输入文字
            [button setBackgroundImage:[UIImage imageNamed:@"chat_yy"] forState:UIControlStateNormal];//common_yuyin
            [button setBackgroundImage:[UIImage imageNamed:@"chat_yy_pre"] forState:UIControlStateHighlighted];
            button.tag = DDVoiceInput;
            [self.chatInputView willBeginInput];
            _currentInputContent = self.chatInputView.textView.text;
            if ([_currentInputContent length] > 0)
            {
                [self.chatInputView.textView setText:_currentInputContent];
            }
            [self.chatInputView.textView becomeFirstResponder];
            break;
    }
}

#pragma  mark 点击录制语音
- (void)p_record:(UIButton*)button
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.chatInputView.recordButton setHighlighted:YES];
    //    [self.chatInputView.buttonTitle setText:@"松开发送"];
    if (![[self.view subviews] containsObject:_recordingView])
    {
        [self.view addSubview:_recordingView];
    }
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:DDShowVolumnState];
    [[RecorderManager sharedManager] setDelegate:self];
    [[RecorderManager sharedManager] startRecording];
    
}

- (void)p_willCancelRecord:(UIButton*)button
{
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:DDShowCancelSendState];
    DDLog(@"will cancel record");
}

- (void)p_cancelRecord:(UIButton*)button
{
    [self.chatInputView.recordButton setHighlighted:NO];
    //    [self.chatInputView.buttonTitle setText:@"按住说话"];
    [_recordingView setHidden:YES];
    [[RecorderManager sharedManager] cancelRecording];
    DDLog(@"cancel record");
}

- (void)p_sendRecord:(UIButton*)button
{
    [self.chatInputView.recordButton setHighlighted:NO];
    //    [self.chatInputView.buttonTitle setText:@"按住说话"];
    [[RecorderManager sharedManager] stopRecording];
    DDLog(@"send record");
}


- (void)p_endCancelRecord:(UIButton*)button
{
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:DDShowVolumnState];
}

- (void)tapOnPreShow:(UIGestureRecognizer*)sender
{
    NSString* nick = [RuntimeStatus instance].user.nick;
    NSDictionary *dict = @{@"nick":nick};
    [self removeImage];
    [self sendImageMessage:_preShowPhoto Image:_preShowImage];
}

#pragma mark  点击table时隐藏键盘
- (void)p_tapOnTableView:(UIGestureRecognizer*)sender
{
    [self removeImage];
    if (_bottomShowComponent)
    {
        //键盘的表情什么的都复原
        [self.chatInputView.voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_yy"] forState:UIControlStateNormal];//common_yuyin
        [self.chatInputView.voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_yy_pre"] forState:UIControlStateHighlighted];
        
        self.chatInputView.voiceButton.tag = DDVoiceInput;
        [self.chatInputView.emotionbutton setBackgroundImage:[UIImage imageNamed:@"chat_biaoqing"] forState:UIControlStateNormal];//common_biaoqing
        [self.chatInputView.emotionbutton setBackgroundImage:[UIImage imageNamed:@"chat_biaoqing_pre"] forState:UIControlStateHighlighted];
        
        self.chatInputView.emotionbutton.tag = 0;
        [self p_hideBottomComponent];
    }
}

#pragma mark - 键盘移到原来的位置
- (void)p_hideBottomComponent
{
    _bottomShowComponent = _bottomShowComponent & 0;
    //隐藏所有
    
    [self.chatInputView.textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        [self.ddUtility.view setFrame:DDCOMPONENT_BOTTOM];
        [self.emotions.view setFrame:DDCOMPONENT_BOTTOM];
        [self.chatInputView setFrame:DDINPUT_BOTTOM_FRAME];
    }];
    
    [self setValue:@(self.chatInputView.origin.y) forKeyPath:@"_inputViewY"];
    [self.view endEditing:YES];
    
}

- (void)p_enableChatFunction
{
    [self.chatInputView setUserInteractionEnabled:YES];
}

- (void)p_unableChatFunction
{
    [self.chatInputView setUserInteractionEnabled:NO];
}

- (void)p_popViewController
{
    
    [self p_hideBottomComponent];
    //[self.navigationController popViewControllerAnimated:YES];
    self.title=@"";
    [self setThisViewTitle:@""];
}

#pragma mark -
#pragma mark DDEmotionViewCOntroller Delegate点击发送表情
- (void)emotionViewClickSendButton
{
    [self textViewEnterSend];
}

- (void)levelMeterChanged:(float)levelMeter
{
    [_recordingView setVolume:levelMeter];
}
#pragma mark -
#pragma mark - KVO
#pragma mark - tableView的偏移

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if (object == progress && [keyPath isEqualToString:@"fractionCompleted"]) {
        NSLog(@"下载进度:%.2f%%",progress.fractionCompleted * 100);
    }

    
    if ([keyPath isEqualToString:@"MTTSessionEntity.sessionID"]) {
        if ([change objectForKey:@"new"] !=nil) {
            [self setThisViewTitle:self.module.MTTSessionEntity.name];
        }
    }
    //    if ([keyPath isEqualToString:@"showingMessages"]) {
    //
    //        dispatch_async(dispatch_get_main_queue(), ^{
    ////            [self.tableView reloadData];
    //            if (self.hadLoadHistory == NO) {
    //                [self scrollToBottomAnimated:NO];
    //            }
    //        });
    //    }
    if ([keyPath isEqualToString:@"_inputViewY"])
    {
        float maxY = FULL_HEIGHT - DDINPUT_MIN_HEIGHT;
        float gap = maxY - _inputViewY;
        [UIView animateWithDuration:0.25 animations:^{
            _tableView.contentInset = UIEdgeInsetsMake(_tableView.contentInset.top, 0, gap/*+DDINPUT_MIN_HEIGHT*/, 0);
            
            if (_bottomShowComponent & DDShowEmotion)
            {
                [self.emotions.view setTop:self.chatInputView.bottom];
            }
            if (_bottomShowComponent & DDShowUtility)
            {
                [self.ddUtility.view setTop:self.chatInputView.bottom];
            }
            
        } completion:^(BOOL finished) {
            
        }];
        if (gap != 0)
        {
            [self scrollToBottomAnimated:NO];
        }
    }
    
}
@end

@implementation ChattingMainViewController(ChattingInput)

#pragma mark - 初始化聊天框
- (void)initialInput
{
    CGRect inputFrame = CGRectMake(0, CONTENT_HEIGHT - DDINPUT_MIN_HEIGHT + NAVBAR_HEIGHT,FULL_WIDTH,DDINPUT_MIN_HEIGHT);
    self.chatInputView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    [self.chatInputView setBackgroundColor:RGBA(247, 247, 247, 1.0)];//0.9->1.0
    //    self.chatInputView.backgroundColor = [UIColor redColor];
    
    
    [self.view addSubview:self.chatInputView];
    //    if (_bottomShowComponent & DDShowUtility) {
    //        [self.chatInputView.textView becomeFirstResponder];
    //        _bottomShowComponent = _bottomShowComponent & DDHideUtility;
    //    }
    
    
    self.chatInputView.emotionbutton.tag = 0;
    //    self.chatInputView.textView.delegate = self;
    [self.chatInputView.emotionbutton addTarget:self
                                         action:@selector(showEmotions:)
                               forControlEvents:UIControlEventTouchUpInside];
    
    [self.chatInputView.showUtilitysbutton addTarget:self
                                              action:@selector(showUtilitys:)
                                    forControlEvents:UIControlEventTouchDown];
    
    [self.chatInputView.voiceButton addTarget:self
                                       action:@selector(p_clickThRecordButton:)
                             forControlEvents:UIControlEventTouchUpInside];
    
    
    _touchDownGestureRecognizer = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:nil];
    __weak ChattingMainViewController* weakSelf = self;
    _touchDownGestureRecognizer.touchDown = ^{
        [weakSelf p_record:nil];
    };
    
    _touchDownGestureRecognizer.moveInside = ^{
        [weakSelf p_endCancelRecord:nil];
    };
    
    _touchDownGestureRecognizer.moveOutside = ^{
        [weakSelf p_willCancelRecord:nil];
    };
    
    _touchDownGestureRecognizer.touchEnd = ^(BOOL inside){
        if (inside)
        {
            [weakSelf p_sendRecord:nil];
        }
        else
        {
            [weakSelf p_cancelRecord:nil];
        }
    };
    [self.chatInputView.recordButton addGestureRecognizer:_touchDownGestureRecognizer];
    _recordingView = [[RecordingView alloc] initWithState:DDShowVolumnState];
    [_recordingView setHidden:YES];
    [_recordingView setCenter:CGPointMake(FULL_WIDTH/2, self.view.centerY)];
    [self addObserver:self forKeyPath:@"_inputViewY" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - 聊天框添加加号点击
-(IBAction)showUtilitys:(id)sender
{
    [self.chatInputView.voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_yy"] forState:UIControlStateNormal];//common_yuyin
    [self.chatInputView.voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_yy_pre"] forState:UIControlStateHighlighted];
    self.chatInputView.voiceButton.tag = DDVoiceInput;
    [self.chatInputView.emotionbutton setBackgroundImage:[UIImage imageNamed:@"chat_biaoqing"] forState:UIControlStateNormal];//chat_biaoqing//common_biaoqing
    [self.chatInputView.emotionbutton setBackgroundImage:[UIImage imageNamed:@"chat_biaoqing_pre"] forState:UIControlStateHighlighted];
    self.chatInputView.emotionbutton.tag = 0;
    [self.chatInputView willBeginInput];
    //    if ([_currentInputContent length] > 0)
    //    {
    //        [self.chatInputView.textView setText:_currentInputContent];
    //    }
    
    if (self.ddUtility == nil)
    {
        self.ddUtility = [TTChatPlusScrollViewController new];
        NSString *sessionId = self.module.MTTSessionEntity.sessionID;
        if(self.module.isGroup){
            self.ddUtility.userId = 0;
        }else{
            self.ddUtility.userId = [MTTUserEntity localIDTopb:sessionId];
        }
        [self addChildViewController:self.ddUtility];
        self.ddUtility.view.frame=CGRectMake(0, self.view.size.height,FULL_WIDTH , 280);
        [self.view addSubview:self.ddUtility.view];
    }
    //    [self.ddUtility setShakeHidden];
    
    if (_bottomShowComponent & DDShowKeyboard)
    {
        //显示的是键盘,这是需要隐藏键盘，显示插件，不需要动画
        _bottomShowComponent = (_bottomShowComponent & 0) | DDShowUtility;
        [self.chatInputView.textView resignFirstResponder];
        [self.ddUtility.view setFrame:DDUTILITY_FRAME];
        [self.emotions.view setFrame:DDCOMPONENT_BOTTOM];
    }
    else if (_bottomShowComponent & DDShowUtility)
    {
        //插件面板本来就是显示的,这时需要隐藏所有底部界面
        //[self p_hideBottomComponent];
        [self.chatInputView.textView becomeFirstResponder];
        _bottomShowComponent = _bottomShowComponent & DDHideUtility;
    }
    else if (_bottomShowComponent & DDShowEmotion)
    {
        //显示的是表情，这时需要隐藏表情，显示插件
        [self.emotions.view setFrame:DDCOMPONENT_BOTTOM];
        [self.ddUtility.view setFrame:DDUTILITY_FRAME];
        _bottomShowComponent = (_bottomShowComponent & DDHideEmotion) | DDShowUtility;
    }
    else
    {
        //这是什么都没有显示，需用动画显示插件
        _bottomShowComponent = _bottomShowComponent | DDShowUtility;
        [UIView animateWithDuration:0.25 animations:^{
            [self.ddUtility.view setFrame:DDUTILITY_FRAME];
            [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(DDINPUT_TOP_FRAME.origin.y) forKeyPath:@"_inputViewY"];
    }
    
    // 判断最后一张照片是不是90s内
    
    //    ALAssetsLibrary *assetsLibrary;
    //    assetsLibrary = [[ALAssetsLibrary alloc] init];
    //    __block NSDate *lastDate = [[NSDate alloc] initWithTimeInterval:-90 sinceDate:[NSDate date]];
    //    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
    //        if (group) {
    //            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
    //                if (result) {
    //                    NSDate *date= [result valueForProperty:ALAssetPropertyDate];
    //                    if ([date compare:lastDate] == NSOrderedDescending) {
    //                        lastDate = date;
    //                        _lastPhoto = result;
    //                    }
    //                }
    //            }];
    //        }else{
    //            if(_lastPhoto && ([[MTTUtil getLastPhotoTime] compare:lastDate] != NSOrderedSame)){
    //                [MTTUtil setLastPhotoTime:lastDate];
    //                //10s后隐藏界面
    //                [self performSelector:@selector(removeImage) withObject:nil afterDelay:10];
    //                _preShow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, SCREEN_HEIGHT-WPKeyboardHeight - 110 - 50, 67, 110)];
    //                [_preShow setTag:10000];
    //                [_preShow setUserInteractionEnabled:YES];
    //                UIImage *preShowBg = [UIImage imageNamed:@"chat_bubble_pre_image"];
    //                preShowBg = [preShowBg stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    //                [_preShow setImage:preShowBg];
    //
    //                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnPreShow:)];
    //                [_preShow addGestureRecognizer:tap];
    //
    //                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(4, 5, 60, 30)];
    //                [label setText:@"你可能要发送的图片:"];
    //                [label setFont:systemFont(12)];
    //                [label setNumberOfLines:0];
    //
    //                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 40, 60, 60)];
    //                UIImage *image=[UIImage imageWithCGImage:_lastPhoto.aspectRatioThumbnail];
    //                [imgView setImage:image];
    //                [imgView setContentMode:UIViewContentModeScaleAspectFill];
    //                [imgView setClipsToBounds:YES];
    //                [imgView.layer setBorderColor:RGB(229, 229, 229).CGColor];
    //                [imgView.layer setBorderWidth:1];
    //                [imgView.layer setCornerRadius:5];
    //                [_preShow addSubview:label];
    //                [_preShow addSubview:imgView];
    //                [self.view addSubview:_preShow];
    //
    //                _preShowPhoto = [MTTPhotoEnity new];
    //                ALAssetRepresentation* representation = [_lastPhoto defaultRepresentation];
    //                NSURL* url = [representation url];
    //                _preShowPhoto.localPath=url.absoluteString;
    //                _preShowImage = nil;
    //                if (representation == nil) {
    //                    CGImageRef thum = [_lastPhoto aspectRatioThumbnail];
    //                    _preShowImage = [[UIImage alloc]initWithCGImage:thum];
    //                }else
    //                {
    //                    _preShowImage =[[UIImage alloc]initWithCGImage:[[_lastPhoto defaultRepresentation] fullScreenImage]];
    //                }
    //                NSString *keyName = [[MTTPhotosCache sharedPhotoCache] getKeyName];
    //
    //                _preShowPhoto.localPath=keyName;
    //            }
    //        }
    //    } failureBlock:^(NSError *error) {
    //        NSLog(@"Group not found!\n");
    //    }];
    
}

-(void)removeImage
{
    _lastPhoto = nil;
    [_preShow removeFromSuperview];
}

#pragma mark - HPGrowingTextViewDelegate
//- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
//{
//    [self.chatInputView.emotionbutton setImage:[UIImage imageNamed:@"common_biaoqing"] forState:UIControlStateNormal];
//    self.chatInputView.emotionbutton.tag = 0;
//    [self.chatInputView.voiceButton setImage:[UIImage imageNamed:@"common_yuyin"] forState:UIControlStateNormal];
//    self.chatInputView.voiceButton.tag = DDVoiceInput;
//}

#pragma mark - 当textView进入编辑状态
- (void)textViewBeginEditing
{
    [self.chatInputView.emotionbutton setBackgroundImage:[UIImage imageNamed:@"chat_biaoqing"] forState:UIControlStateNormal];//common_biaoqing
    [self.chatInputView.emotionbutton setBackgroundImage:[UIImage imageNamed:@"chat_biaoqing_pre"] forState:UIControlStateHighlighted];
    self.chatInputView.emotionbutton.tag = 0;
    
    [self.chatInputView.voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_yy"] forState:UIControlStateNormal];//common_yuyin
    [self.chatInputView.voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_yy_pre"] forState:UIControlStateHighlighted];
    self.chatInputView.voiceButton.tag = DDVoiceInput;
    
}

#pragma mark -  表情按钮点击事件
-(IBAction)showEmotions:(id)sender
{
    [self.chatInputView.voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_yy"] forState:UIControlStateNormal];//common_yuyin
    [self.chatInputView.voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_yy_pre"] forState:UIControlStateHighlighted];
    
    self.chatInputView.voiceButton.tag = DDVoiceInput;
    [self.chatInputView willBeginInput];
    //    if ([_currentInputContent length] > 0)
    //    {
    //        [self.chatInputView.textView setText:_currentInputContent];
    //    }
    
    self.chatInputView.emotionbutton.tag = (self.chatInputView.emotionbutton.tag+1)%2;
    if (self.chatInputView.emotionbutton.tag == 0) {
        [self.chatInputView.emotionbutton setBackgroundImage:[UIImage imageNamed:@"chat_biaoqing"] forState:UIControlStateNormal];//common_biaoqing
        
        [self.chatInputView.emotionbutton setBackgroundImage:[UIImage imageNamed:@"chat_biaoqing_pre"] forState:UIControlStateHighlighted];
        //        [self.chatInputView.textView becomeFirstResponder];
        //        return;
    } else {
        [self.chatInputView.emotionbutton setBackgroundImage:[UIImage imageNamed:@"chat_jp"]forState:UIControlStateNormal];//dd_input_normal
        [self.chatInputView.emotionbutton setBackgroundImage:[UIImage imageNamed:@"chat_jp_pre"] forState:UIControlStateHighlighted];
    }
    
    if (self.emotions == nil) {
        self.emotions = [EmotionsViewController new];
        [self.emotions.view setBackgroundColor:[UIColor whiteColor]];
        self.emotions.view.frame=DDCOMPONENT_BOTTOM;
        self.emotions.delegate = self;
        [self.view addSubview:self.emotions.view];
    }
    if (_bottomShowComponent & DDShowKeyboard)
    {
        //显示的是键盘,这是需要隐藏键盘，显示表情，不需要动画
        _bottomShowComponent = (_bottomShowComponent & 0) | DDShowEmotion;
        [self.chatInputView.textView resignFirstResponder];
        [self.emotions.view setFrame:DDEMOTION_FRAME];
        [self.ddUtility.view setFrame:DDCOMPONENT_BOTTOM];
    }
    else if (_bottomShowComponent & DDShowEmotion)
    {
        //表情面板本来就是显示的,这时需要隐藏所有底部界面
        [self.chatInputView.textView becomeFirstResponder];
        _bottomShowComponent = _bottomShowComponent & DDHideEmotion;
    }
    else if (_bottomShowComponent & DDShowUtility)
    {
        //显示的是插件，这时需要隐藏插件，显示表情
        [self.ddUtility.view setFrame:DDCOMPONENT_BOTTOM];
        [self.emotions.view setFrame:DDEMOTION_FRAME];
        _bottomShowComponent = (_bottomShowComponent & DDHideUtility) | DDShowEmotion;
    }
    else
    {
        //这是什么都没有显示，需用动画显示表情
        _bottomShowComponent = _bottomShowComponent | DDShowEmotion;
        [UIView animateWithDuration:0.25 animations:^{
            [self.emotions.view setFrame:DDEMOTION_FRAME];
            [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(DDINPUT_TOP_FRAME.origin.y) forKeyPath:@"_inputViewY"];
    }
}
#pragma mark - KeyBoardNotification
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    
    CGRect keyboardRect;
    keyboardRect = [(notification.userInfo)[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    _bottomShowComponent = _bottomShowComponent | DDShowKeyboard;
    [UIView animateWithDuration:0.25 animations:^{
        [self.chatInputView setFrame:CGRectMake(0, keyboardRect.origin.y - DDINPUT_HEIGHT, self.view.size.width, DDINPUT_HEIGHT)];
    }];
    [self setValue:@(keyboardRect.origin.y - DDINPUT_HEIGHT) forKeyPath:@"_inputViewY"];
    
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    CGRect keyboardRect;
    keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    _bottomShowComponent = _bottomShowComponent & DDHideKeyboard;
    if (_bottomShowComponent & DDShowUtility)
    {
        //显示的是插件
        [UIView animateWithDuration:0.25 animations:^{
            [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(self.chatInputView.origin.y) forKeyPath:@"_inputViewY"];
    }
    else if (_bottomShowComponent & DDShowEmotion)
    {
        //显示的是表情
        [UIView animateWithDuration:0.25 animations:^{
            [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(self.chatInputView.origin.y) forKeyPath:@"_inputViewY"];
        
    }
    else
    {
        [self p_hideBottomComponent];
    }
}

-(IBAction)titleTap:(id)sender
{
    if ([self.module.MTTSessionEntity isGroup]) {
        return;
    }
    [self.module getCurrentUser:^(MTTUserEntity *user) {
        //        PublicProfileViewControll *profile = [PublicProfileViewControll new];
        //        profile.title=user.nick;
        //        profile.user=user;
        //        [self.navigationController pushViewController:profile animated:YES];
        PersonalInfoViewController *info = [[PersonalInfoViewController alloc] init];
        info.friendID = [user.objID substringFromIndex:5];
        info.newType = NewRelationshipTypeFriend;
        //            [self.navigationController pushViewController:info animated:YES];
        //            PublicProfileViewControll *public = [PublicProfileViewControll new];
        //            public.user=user;
        //        [self.navigationController pushViewController:info animated:YES];
    }];
}
#pragma mark 在当前界面收到消息时更新界面
- (void)n_receiveMessage:(NSNotification*)notification
{
    //    if (![self.navigationController.topViewController isEqual:self])
    //    {
    //        //当前不是聊天界面直接返回
    //        return;
    //    }
    
    MTTMessageEntity* message = [notification object];
    
    //改变内容
    //    if (message.msgContentType == DDMessageTypeText) {
    //        NSString * messageConten = [NSString stringWithFormat:@"%@",message.msgContent];
    //        NSDictionary * dic = [self getLastMessage:messageConten];
    //        message.msgContent = [NSString stringWithFormat:@"%@",dic[@"content"]];
    //    }
    
    
    UIApplicationState state =[UIApplication sharedApplication].applicationState;
    if (state == UIApplicationStateBackground) {
        if([message.sessionId isEqualToString:self.module.MTTSessionEntity.sessionID])
        {
            [self.module addShowMessage:message];
            [self.module updateSessionUpdateTime:message.msgTime];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self scrollToBottomAnimated:YES];
            });
        }
        return;
    }
    //显示消息
    self.receiveMessage = YES;
    if([message.sessionId isEqualToString:self.module.MTTSessionEntity.sessionID])
    {
        [self.module addShowMessage:message];
        [self.module updateSessionUpdateTime:message.msgTime];
        [self.tableView reloadData];
        
        //        [self.tableView beginUpdates];
        //        [self.tableView insertRowAtIndexPath:[NSIndexPath indexPathForRow:self.module.showingMessages.count-1 inSection:0] withRowAnimation:UITableViewRowAnimationNone];
        //        [self.tableView endUpdates];
        
        
        [[DDMessageModule shareInstance] sendMsgRead:message];
        if(self.ifScrollBottom){
            //            [self.tableView scrollToBottom];
            [self scrollToBottomAnimated:YES];
            self.receiveMessage = NO;
        }
    }
}
- (void)recordingTimeout
{
    
}

- (void)recordingStopped  //录音机停止采集声音
{
    
}

- (void)recordingFailed:(NSString *)failureInfoString
{
    
}

- (void)levelMeterChanged:(float)levelMeter
{
    [_recordingView setVolume:levelMeter];
}

#pragma mark  重新登陆成功时加载新数据
-(void)reloginSuccess
{
    [self.module getNewMsg:^(NSUInteger addcount, NSError *error) {
        [self.tableView reloadData];
    }];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    NSArray *res = [phoneNumber componentsSeparatedByString:LINK_SPLIT];
    if([res count] == 2){
        if([res[0] isEqualToString:NICK_SPLIT]){
            MTTUserEntity *user = [[DDUserModule shareInstance] getUserByNick:res[1]];
            PublicProfileViewControll *public = [PublicProfileViewControll new];
            public.user=user;
            [self.navigationController pushViewController:public animated:YES];
        }
        if([res[0] isEqualToString:PHONE_SPLIT]){
            NSString *phone = [res[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *title = [NSString stringWithFormat:@"%@%@",phone,@"可能是一个电话号码,你可以"];
            self.phoneNumber = phone;
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:title
                                                           buttonTitles:@[@"呼叫",@"复制"]
                                                         redButtonIndex:-1
                                                               delegate:self];
            sheet.tag = 10000;
            [sheet show];
        }
        if([res[0] isEqualToString:EMAIL_SPLIT]){
            self.email = res[1];
            NSString *title = [NSString stringWithFormat:@"%@%@%@",@"向",self.email,@"发送邮件"];
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:title
                                                           buttonTitles:@[@"使用默认邮件账户",@"复制"]
                                                         redButtonIndex:-1
                                                               delegate:self];
            sheet.tag = 10001;
            [sheet show];
        }
    }
}


#pragma mark - LCActionSheetDelegate
- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 10000){
        if(buttonIndex == 0){
            if(!self.phoneNumber.length){
                return;
            }
            NSString *phone =[NSString stringWithFormat:@"tel:%@",self.phoneNumber];
            NSURL *url = [NSURL URLWithString:phone];
            [[UIApplication sharedApplication] openURL:url];
        }
        if(buttonIndex == 1){
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = self.phoneNumber;
        }
    }
    if(actionSheet.tag == 10001){
        if (!self.email.length) {
            return;
        }
        if(buttonIndex == 0){
            NSString *email =[NSString stringWithFormat:@"mailto:%@",self.email];
            NSURL *url = [NSURL URLWithString:email];
            [[UIApplication sharedApplication] openURL:url];
        }
        if(buttonIndex == 1){
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = self.email;
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    [self p_tapOnTableView:gestureRecognizer];
//    return YES;
//}

@end
