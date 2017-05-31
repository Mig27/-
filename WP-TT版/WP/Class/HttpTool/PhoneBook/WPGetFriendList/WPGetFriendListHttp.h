//
//  WPGetFriendListHttp.h
//  WP
//
//  Created by Kokia on 16/5/10.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPGetFriendListResult.h"
#import "WPGetFriendListParam.h"

@interface WPGetFriendListHttp : NSObject

+ (void)WPGetFriendListHttpWithParam:(WPGetFriendListParam *)param success:(void (^)(WPGetFriendListResult *result))success failure:(void (^)(NSError *error))failure;

@end
