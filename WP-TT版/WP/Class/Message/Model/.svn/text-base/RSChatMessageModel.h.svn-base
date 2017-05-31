//
//  RSChatMessageModel.h
//  WP
//
//  Created by 沈亮亮 on 15/12/16.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSocketClinet.h"

@interface RSChatMessageModel : NSObject

@property (nonatomic, assign) NotiMessageType messageType;     /**< 消息的类型 */
@property (nonatomic, copy) NSString *meaageTime;          /**< 最后一条消息的发送时间 */
@property (nonatomic, copy) NSString *messageDetail;       /**< 最后一条消息的内容 */
@property (nonatomic, copy) NSString *avatarUrl;           /**< 聊天人头像的URL */
@property (nonatomic, copy) NSString *avatarName;          /**< 聊天人的姓名 */
@property (nonatomic, assign) NSInteger messageID;         /**< 聊天人的ID */
@property (nonatomic, assign) NSInteger noReadCount;       /**< 未读的数据数量 */
@property (nonatomic, assign) NSInteger loginID;           /**< 当前登录人的ID */
@property (nonatomic, assign) NSInteger timestamp;         /**< 时间戳（int类型，用于降序排列） */

+ (instancetype)modelwithName:(NSString *)name avatar:(NSString *)avatar no:(NSInteger)ID_no type:(NotiMessageType)type detail:(NSString *)detail time:(NSString *)time noReadCount:(NSInteger)count loginID:(NSInteger)login_ID timestamp:(NSInteger)timetamp;


@end
