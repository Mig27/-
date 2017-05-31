//
//  WPGetPBSettingInfoHttp.h
//  WP
//
//  Created by Kokia on 16/5/10.
//  Copyright © 2016年 WP. All rights reserved.
//  返回符合设置条件的对象

#import <Foundation/Foundation.h>
#import "WPGetPBSettingInfoParam.h"
#import "WPGetPBSettingInfoResult.h"

@interface WPGetPBSettingInfoHttp : NSObject

+ (void)WPGetPBSettingInfoHttpWithParam:(WPGetPBSettingInfoParam *)param success:(void (^)(WPGetPBSettingInfoResult *result))success failure:(void (^)(NSError *error))failure;

@end
