//
//  WPPhoneBookGetGroupListHttp.h
//  WP
//
//  Created by Kokia on 16/5/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPPhoneBookGetGroupListParam.h"
#import "WPPhoneBookGetGroupListResult.h"

@interface WPPhoneBookGetGroupListHttp : NSObject

+ (void)wPPhoneBookGetGroupListHttpWithParam:(WPPhoneBookGetGroupListParam *)param success:(void (^)(WPPhoneBookGetGroupListResult *result))success failure:(void (^)(NSError *error))failure;

@end
