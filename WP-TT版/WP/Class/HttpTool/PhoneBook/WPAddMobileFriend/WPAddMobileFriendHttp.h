//
//  WPAddMobileFriendHttp.h
//  WP
//
//  Created by Kokia on 16/5/11.
//  Copyright © 2016年 WP. All rights reserved.
//  添加手机好友

#import <Foundation/Foundation.h>
#import "WPAddMobileFriendParam.h"
#import "WPAddMobileFriendResult.h"

@interface WPAddMobileFriendHttp : NSObject

+ (void)WPAddMobileFriendHttpWithParam:(WPAddMobileFriendParam *)param success:(void (^)(WPAddMobileFriendResult *result))success failure:(void (^)(NSError *error))failure;
@end
