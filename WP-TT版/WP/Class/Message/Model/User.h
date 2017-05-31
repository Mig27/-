//
//  User.h
//  JKBaseModel
//
//  Created by zx_04 on 15/6/24.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"
#import "RSSocketClinet.h"

typedef NS_ENUM(NSInteger,MessageFrom) {
    MessageFromSelf,
    MessageFromOpposite
};

@interface User : JKDBModel

@property (nonatomic, assign) MessageFrom messageFrom;     /**< 消息的来源 */
@property (nonatomic, assign) NotiMessageType messageType;     /**< 消息的类型 */
@property (nonatomic, copy) NSString *meaageTime;          /**< 消息的发送时间 */
@property (nonatomic, copy) NSString *messageDetail;       /**< 消息的内容 */
@property (nonatomic, assign) NSInteger messageID;         /**< 存的消息的ID */
@property (nonatomic, assign) NSInteger login_ID;          /**< 登录人的ID */
@property (nonatomic, assign) NSInteger timestamp;         /**< 时间戳 */

/** 账号 */
@property (nonatomic, copy)     NSString                    *account;
/** 名字 */
@property (nonatomic, copy)     NSString                    *name;
/** 性别 */
@property (nonatomic, copy)     NSString                    *sex;
/** 头像地址 */
@property (nonatomic, copy)     NSString                    *portraitPath;
/** 手机号码 */
@property (nonatomic, copy)     NSString                    *moblie;
/** 简介 */
@property (nonatomic, copy)     NSString                    *descn;
/** 年龄 */
@property (nonatomic, assign)  int                          age;

@property (nonatomic, assign)   int                        height;

@property (nonatomic, assign)   int                        field1;

@property (nonatomic, assign)   int                        field2;


@end
