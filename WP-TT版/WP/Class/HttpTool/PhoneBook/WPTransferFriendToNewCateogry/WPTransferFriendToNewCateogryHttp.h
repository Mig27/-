//
//  WPTransferFriendToNewCateogryHttp.h
//  WP
//
//  Created by Kokia on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPTransferFriendToNewCateogryParam.h"
#import "WPTransferFriendToNewCateogryResult.h"

@interface WPTransferFriendToNewCateogryHttp : NSObject

+ (void)WPTransferFriendToNewCateogryHttpWithParam:(WPTransferFriendToNewCateogryParam *)param success:(void (^)(WPTransferFriendToNewCateogryResult *result))success failure:(void (^)(NSError *error))failure;

@end
