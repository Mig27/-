//
//  RSSocketClinet.h
//  WP
//
//  Created by 沈亮亮 on 15/12/9.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

typedef NS_ENUM(NSInteger, SocketDidDisConnectReason) {
    SocketDidDisConnectReasonByServer,
    SocketDidDisConnectReasonByUser
};

typedef NS_ENUM(NSInteger,NotiMessageType) {
    MessageTypeText,
    MessageTypePhoto,
    MessageTypeVideo,
    MessageTypeVoice
};

typedef void(^sendSucceed)(NotiMessageType type,id sender);
typedef void(^receiveSucceed)(NotiMessageType type,id receiver);

@interface RSSocketClinet : NSObject<AsyncSocketDelegate>
@property (nonatomic,assign)NSInteger kPORT;
@property (nonatomic, strong) AsyncSocket               *socket;
@property (nonatomic, strong) NSTimer                   *connectTimer;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, copy) sendSucceed sendSucces;  /**< 发送完成回调 */
@property (nonatomic, copy) receiveSucceed receiveSucces; /**< 接受完成回调 */
@property (nonatomic, copy) void(^sendTextSucceed)(NotiMessageType type,NSString *text);/**< 发送文本消息成功回调 */
@property (nonatomic, copy) void(^receiveTextSuccessed)(NotiMessageType type,NSString *text);/**< 接收文本消息成功回调 */
@property (nonatomic, assign) SocketDidDisConnectReason disConnectResaon; /**< 断开连接的原因 */
@property (nonatomic, assign) NotiMessageType sendMediaType; /**< 发送的消息类型 */
@property (nonatomic, assign) NotiMessageType receiveMediaType; /**< 接收的消息类型 */
@property (nonatomic, assign) id messageDetails; /**< 消息内容 */
@property (nonatomic, copy) NSString *sendText; /**< 发送的消息 */
@property (nonatomic, copy) NSString *receiveText; /**< 就收的消息内容 */

@property (nonatomic, strong) NSString *userId;    /**< 当前正在聊天的的人的ID */
@property (nonatomic, strong) NSString *avatar;    /**< 当前聊天人的头像 */
@property (nonatomic, strong) NSString *nick_name; /**< 当前聊天人的昵称 */
@property (nonatomic, copy) NSString * loginString;
@property (nonatomic, assign) BOOL isFirst;
+ (instancetype)sharedSocketClinet;

/** 连接服务器 **/
- (void)socketConnectHost;

/** 连接服务器 **/
- (void)connectServer;

/** 退出登录 **/
- (void)cutOffSocket;

/**
 *  发送消息方法
 *
 *  @param type    发送的媒体类型
 *  @param message 发送的媒体内容
 */
//- (void)sendMessageWithType:(MessageType)type andDetails:(NSString *)text;

/**
 *  发送消息方法
 *
 *  @param sender   发送人的用户名
 *  @param receiver 接收人的用户名
 *  @param type     信息的类型
 *  @param message  信息的内容
 */
- (void)sendMessageFromSender:(NSString *)sender toReceiver:(NSString *)receiver type:(NotiMessageType)type andDetails:(id)message;

-(void)sendNotificationMessage:(NSString*)message;

@end
