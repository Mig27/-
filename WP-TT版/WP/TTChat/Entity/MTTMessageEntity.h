//
//  MTTMessageEntity.h
//  IOSDuoduo
//
//  Created by 独嘉 on 14-5-26.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChattingModule;
@class DDDataInputStream;
@class IMMsgData;
#import "IMBaseDefine.pb.h"
typedef NS_ENUM(NSUInteger, DDMessageType)
{
    MESSAGE_TYPE_SINGLE =1,                 //单个人会话消息
    MESSAGE_TYPE_TEMP_GROUP  =2,                     //临时群消息.
};
typedef NS_ENUM(NSUInteger, DDMessageContentType)
{
    DDMessageTypeText   =0,
    DDMessageTypeImage  =1,
    DDMessageTypeVoice  =2,
    DDMEssageEmotion    =3,
    DDMEssagePersonalaCard = 4,
     DDMEssageMyApply = 5,//求职
     DDMEssageMyWant = 6,//招聘
    DDMEssageMuchMyWantAndApply = 7,//多个招聘和求职
    DDMEssageSHuoShuo = 8,//说说
    DDMEssageLitterVideo = 9,//小视频
    DDMEssageLitterInviteAndApply=10,//邀请和申请加入群
    DDMEssageLitteralbume=11,//群相册和公告
    DDMEssageAcceptApply=12,//接受申请时发出的消息
    DDMEssageMuchCollection=13,//收藏的聊天记录
    DDMEssageDeleteOrBlackName = 14,//删除或加入黑名单
    DDMEssageRemind = 15,//好友消息提醒功能
    DDMEssageNotification = 16,//给安卓发送添加好友的推送消息
    MSG_TYPE_AUDIO	= 100,
    MSG_TYPE_GROUP_AUDIO = 101,
};

typedef NS_ENUM(NSUInteger, DDMessageState)
{
    DDMessageSending =0,
    DDMessageSendFailure =1,
    DDmessageSendSuccess =2
};

//语音
#define VOICE_LENGTH                        @"voiceLength"
#define DDVOICE_PLAYED                      @"voicePlayed"
#define EARORSPEAK                          @"earOrSpeak"//声音模式

//voice
#define DD_IMAGE_LOCAL_KEY                  @"local"
#define DD_IMAGE_URL_KEY                    @"url"

//商品
#define DD_COMMODITY_ORGPRICE               @"orgprice"
#define DD_COMMODITY_PICURL                 @"picUrl"
#define DD_COMMODITY_PRICE                  @"price"
#define DD_COMMODITY_TIMES                  @"times"
#define DD_COMMODITY_TITLE                  @"title"
#define DD_COMMODITY_URL                    @"URL"
#define DD_COMMODITY_ID                     @"CommodityID"

@interface MTTMessageEntity : NSObject
@property(assign) NSUInteger  msgID;           //MessageID
@property(nonatomic,assign) MsgType msgType;              //消息类型
@property(nonatomic,assign) NSTimeInterval msgTime;             //消息收发时间
@property(nonatomic,strong) NSString* sessionId;        //会话id，
@property(assign)NSUInteger seqNo;
@property(nonatomic,strong) NSString* senderId;         //发送者的Id,群聊天表示发送者id
@property(nonatomic,strong) NSString* msgContent;       //消息内容,若为非文本消息则是json
@property(nonatomic,strong) NSString* toUserID;     //发消息的用户ID
@property(nonatomic,strong) NSMutableDictionary* info;     //一些附属的属性，包括语音时长
@property(assign)DDMessageContentType msgContentType;
@property(nonatomic,strong) NSString* attach;
@property (nonatomic, copy)NSString * avatarStr;
@property (nonatomic, copy)NSString *senderName;//发送人的名称
@property(assign)SessionType sessionType;
@property (nonatomic,assign)BOOL itemSelected;
@property(nonatomic,assign) DDMessageState state;       //消息发送状态
- (MTTMessageEntity*)initWithMsgID:(NSUInteger )ID msgType:(MsgType)msgType msgTime:(NSTimeInterval)msgTime sessionID:(NSString*)sessionID senderID:(NSString*)senderID msgContent:(NSString*)msgContent toUserID:(NSString*)toUserID;
+(MTTMessageEntity *)makeMessage:(NSString *)content Module:(ChattingModule *)module MsgType:(DDMessageContentType )type;
+(MTTMessageEntity*)makeMessage:(NSString*)content session:(NSString*)sessionId MsgType:(DDMessageContentType)type;
+(MTTMessageEntity *)makeMessageFromStream:(DDDataInputStream *)bodyData;
-(BOOL)isGroupMessage;
-(SessionType)getMessageSessionType;
-(BOOL)isImageMessage;
-(BOOL)isVoiceMessage;
-(BOOL)isSendBySelf;
-(BOOL)isPersonCard;
+(MTTMessageEntity *)makeMessageFromPB:(MsgInfo *)info SessionType:(SessionType)sessionType;
+(MTTMessageEntity *)makeMessageFromPBData:(IMMsgData *)data;
@end
