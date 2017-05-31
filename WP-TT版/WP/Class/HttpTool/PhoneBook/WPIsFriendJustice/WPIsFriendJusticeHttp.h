//
//  WPIsFriendJusticeHttp.h
//  WP
//
//  Created by CC on 16/6/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPIsFriendJusticeParam.h"
#import "WPIsFriendJusticeResult.h"

@interface WPIsFriendJusticeHttp : NSObject

+ (void)WPIsFriendJusticeHttpWithParam:(WPIsFriendJusticeParam *)param success:(void (^)(WPIsFriendJusticeResult *result))success failure:(void (^)(NSError *error))failure;


@end
