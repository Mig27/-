//
//  WPGroupInformationViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/4/18.
//  Copyright © 2016年 WP. All rights reserved.
//  群组控制器

#import "BaseViewController.h"
#import "MTTSessionEntity.h"
#import "ChattingModule.h"
@interface WPGroupInformationViewController : BaseViewController

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, assign) NSString *group_id;
@property (nonatomic, assign) NSString *gtype;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, assign) BOOL isComeChatting; /**< 是否来自聊天界面 */

@property (nonatomic, assign) BOOL isFromCreat;//从发现的职场群租中创建
@property (nonatomic, assign) BOOL isFromZhiChang;//从职场中点击cell

@property (nonatomic, copy) NSString * avatarStr;

@property (nonatomic, copy) NSString * groupSessionId;
@property (nonatomic, strong) NSIndexPath*index;
@property (nonatomic, strong) MTTSessionEntity * groupSession;
@property (nonatomic, strong) ChattingModule*chatMouble;
@property (nonatomic, copy) void(^joinSuccees)(NSIndexPath*index);
@end
