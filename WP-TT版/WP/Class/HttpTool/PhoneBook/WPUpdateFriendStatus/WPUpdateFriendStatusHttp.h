//
//  WPUpdateFriendStatusHttp.h
//  WP
//
//  Created by Kokia on 16/5/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPUpdateFriendStatusparam.h"
#import "WPUpdateFriendStatusResult.h"

@interface WPUpdateFriendStatusHttp : NSObject

+ (void)WPUpdateFriendStatusHttpWithParam:(WPUpdateFriendStatusparam *)param success:(void (^)(WPUpdateFriendStatusResult *result))success failure:(void (^)(NSError *error))failure;


@end
