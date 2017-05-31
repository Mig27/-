//
//  WPUpdateFriendStatusparam.h
//  WP
//
//  Created by Kokia on 16/5/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPUpdateFriendStatusparam : NSObject

@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *VerState;  //0好友 1待通过 2陌生人 3黑名单
@property (nonatomic, copy) NSString *friend_id;

@end
