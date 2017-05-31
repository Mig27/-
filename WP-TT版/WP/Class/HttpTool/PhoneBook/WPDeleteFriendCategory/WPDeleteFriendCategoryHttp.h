//
//  WPDeleteFriendCategoryHttp.h
//  WP
//
//  Created by Kokia on 16/5/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPDeleteFriendCategoryParam.h"
#import "WPDeleteFriendCategoryResult.h"

@interface WPDeleteFriendCategoryHttp : NSObject

+ (void)wPDeleteFriendCategoryHttpWithParam:(WPDeleteFriendCategoryParam *)param success:(void (^)(WPDeleteFriendCategoryResult *result))success failure:(void (^)(NSError *error))failure;


@end
