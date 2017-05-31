//
//  WPGetFriendListParam.h
//  WP
//
//  Created by Kokia on 16/5/10.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPGetFriendListParam : NSObject

//群ID为0的时候是从其他地方获取我的好友列表
//群ID为其他数字 是从群里面获取我的好友列表 并判断了我的好友列表中有哪些好友存在本群
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *user_id;
//@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@end
