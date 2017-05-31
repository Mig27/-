//
//  WPGetFriendInfoHttp.h
//  WP
//
//  Created by Kokia on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPGetFriendInfoParam.h"
#import "WPGetFriendInfoResult.h"

@interface WPGetFriendInfoHttp : NSObject

+ (void)WPGetFriendInfoHttpWithParam:(WPGetFriendInfoParam *)param success:(void (^)(WPGetFriendInfoResult *result))success failure:(void (^)(NSError *error))failure;

@end
