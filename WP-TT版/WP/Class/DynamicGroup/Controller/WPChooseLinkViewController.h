//
//  WPChooseLinkViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/5/7.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupInformationModel.h"
#import "ChattingModule.h"
typedef NS_ENUM(NSInteger,ChooseLinkType) {
    ChooseLinkTypeCreateChat = 1,        //发起群聊
    ChooseLinkTypeChatGroup,         //聊天群组的添加
    ChooseLinkTypeDynamicGroup,      //职场群组的添加
};

@interface WPChooseLinkViewController : BaseViewController

@property (nonatomic, strong) GroupInformationListModel *model;
@property (nonatomic, copy) void (^inviteSuccessBlock)();
@property (nonatomic, assign) BOOL isComeFromChatting;  /**< 是否来自聊天的添加好友 */
@property (nonatomic, strong) NSString *currentUserId;  /**< 当前聊天人的user_id */
@property (nonatomic, assign) ChooseLinkType addType;   /**< 添加联系人的类别 */
@property (nonatomic, copy)NSString * display_type;
@property (nonatomic, copy)NSString * tranmitStr;
@property (nonatomic, assign)BOOL isFromTrnmit;//从转发界面来
@property (nonatomic, assign) BOOL isFromChat;//从聊天界面发送名片

@property (nonatomic, strong)NSArray * moreTranitArray;
@property (nonatomic, copy)NSString * toUserId;

@property (nonatomic, copy)NSString *groupId;
@property (nonatomic, strong)ChattingModule*chatMouble;
@property (nonatomic, assign)BOOL isFromSingle;
@property (nonatomic, copy)NSString * numOfMemember;//从职场群组中添加时已有的群成员数
@property (nonatomic, assign) BOOL fromChatNotCreat;

@end
