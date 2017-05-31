//
//  WPGetNearbyPersonDataHttp.h
//  WP
//
//  Created by Kokia on 16/5/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPGetNearbyPersonDataParam.h"
#import "WPGetNearbyPersonDataResult.h"

@interface WPGetNearbyPersonDataHttp : NSObject

+ (void)WPGetNearbyPersonDataHttpWithParam:(WPGetNearbyPersonDataParam *)param success:(void (^)(WPGetNearbyPersonDataResult *result))success failure:(void (^)(NSError *error))failure;

@end
