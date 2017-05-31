//
//  PersonalInfoViewController.h
//  WP
//
//  Created by 沈亮亮 on 15/12/31.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "LinkManModel.h"
@interface PersonalInfoViewController : BaseViewController

@property (nonatomic, copy) NSString *friendID;
@property (nonatomic, assign) RelationshipType type;  // 之前的关系
@property (nonatomic, assign) NewRelationshipType newType; /**< 与当前登录人的关系 */
@property (nonatomic, strong) NSIndexPath*index;
@property (nonatomic, copy) NSString *skipType;

@property (nonatomic, copy) NSString *comeFromVc; // 删除好友时候返回不同页面

@property (nonatomic, copy) NSString *add_fuser_state;
@property (nonatomic, copy) NSString *form_state;

@property (nonatomic, strong) NSIndexPath *ccindex; //这样是为了pop的时候刷新指定的一行数据
@property (nonatomic, strong)LinkManListModel*personalinfoModel;


@property (nonatomic, copy) NSString *FriendVC; // 1为真   只有新的好友页面进入的时候需要显示验证消息
@property (nonatomic, assign)BOOL isFromChat;//发送名片
@property (nonatomic, copy) void(^refresh)(NSIndexPath*index);
@property (nonatomic, copy) void(^pushFromBlack)();
@property (nonatomic, copy) void(^acceptFriends)(NSIndexPath* index);
@property (nonatomic, copy) void (^addFriendsSuccess)(NSIndexPath*index);
@end
