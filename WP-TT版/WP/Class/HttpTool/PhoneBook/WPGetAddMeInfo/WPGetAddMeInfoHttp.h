//
//  WPGetAddMeInfoHttp.h
//  WP
//
//  Created by Kokia on 16/5/16.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPGetAddMeInfoParam.h"
#import "WPGetAddMeInfoResult.h"

@interface WPGetAddMeInfoHttp : NSObject

+ (void)WPGetAddMeInfoHttpWithParam:(WPGetAddMeInfoParam *)param success:(void (^)(WPGetAddMeInfoResult *result))success failure:(void (^)(NSError *error))failure;


@end
