//
//  WPReadSettingHttp.h
//  WP
//
//  Created by Kokia on 16/5/25.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPReadSettingParam.h"
#import "WPReadSettingResult.h"

@interface WPReadSettingHttp : NSObject

+ (void)WPReadSettingHttpWithParam:(WPReadSettingParam *)param success:(void (^)(WPReadSettingResult *result))success failure:(void (^)(NSError *error))failure;

@end
