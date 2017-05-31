//
//  WPGetPersonPhotoListHttp.h
//  WP
//
//  Created by Kokia on 16/5/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPGetPersonPhotoListParam.h"
#import "WPGetPersonPhotoListResult.h"

@interface WPGetPersonPhotoListHttp : NSObject

+ (void)WPGetPersonPhotoListHttpWithParam:(WPGetPersonPhotoListParam *)param success:(void (^)(WPGetPersonPhotoListResult *result))success failure:(void (^)(NSError *error))failure;

@end
