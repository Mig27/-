//
//  WPRemarkSettingHttp.h
//  WP
//
//  Created by Kokia on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPRemarkSettingParam.h"
#import "WPRemarkSettingResult.h"

@interface WPRemarkSettingHttp : NSObject

+ (void)WPRemarkSettingHttpWithParam:(WPRemarkSettingParam *)param success:(void (^)(WPRemarkSettingResult *result))success failure:(void (^)(NSError *error))failure;

@end
