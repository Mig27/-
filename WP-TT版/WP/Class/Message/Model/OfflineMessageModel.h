//
//  OfflineMessageModel.h
//  WP
//
//  Created by 沈亮亮 on 16/1/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface OfflineMsgModel : BaseModel

@property (nonatomic, strong) NSString *MsgEnd;       /**< 最后一条数据 */
@property (nonatomic, strong) NSString *MsgTime;      /**< 最后一条数据的发送时间 */
@property (nonatomic, strong) NSString *avatar;       /**< 头像 */
@property (nonatomic, strong) NSString *friendid;     /**< 发消息人的ID */
@property (nonatomic, strong) NSString *nick_name;    /**< 发消息人的昵称 */
@property (nonatomic, strong) NSString *noMsg;        /**< 未读消息的数量 */
@property (nonatomic, strong) NSString *type;         /**< 最后一条未读消息的类型 */
@property (nonatomic, strong) NSArray *MsgList;      /**< 未读消息列表 */
@property (nonatomic, strong) NSString *btime;       /**< 时间戳 */

@end

@interface OfflineMessageModel : BaseModel

@property (nonatomic, strong) NSArray *MsgBegin;

@end

@interface OfflineMsgListModel : BaseModel

@property (nonatomic, copy) NSString *Msg;          /**< 消息内容 */
@property (nonatomic, copy) NSString *MsgTime;      /**< 消息时间 */
@property (nonatomic, copy) NSString *friendid;     /**< 离线消息发送者的ID */
@property (nonatomic, copy) NSString *myid;         /**< 自己的ID */
@property (nonatomic, copy) NSString *type;         /**< 消息的类别 */
@property (nonatomic, copy) NSString *Mtime;        /**< 时间戳 */

@end
