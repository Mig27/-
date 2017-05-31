//
//  MuchCollectionFromChatDetail.h
//  WP
//
//  Created by CC on 16/9/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "MTTMessageEntity.h"
@interface MuchCollectionFromChatDetail : BaseViewController
@property (nonatomic, copy)NSString *from_user_id;
@property (nonatomic, copy) NSString * Msgid;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, assign) BOOL isFromChat;
@property (nonatomic, assign) BOOL chatClick;
@property (nonatomic, strong) NSDictionary * tranmitDic;
@property (nonatomic, copy) void (^deleteSuccess)(NSString * msgId);
@property (nonatomic, strong)MTTMessageEntity * message;
@end
