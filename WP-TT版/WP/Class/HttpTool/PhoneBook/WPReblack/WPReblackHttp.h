//
//  WPReblackHttp.h
//  WP
//
//  Created by Kokia on 16/6/1.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPReblackParam.h"
#import "WPReblackResult.h"

@interface WPReblackHttp : NSObject

+ (void)WPReblackHttpWithParam:(WPReblackParam *)param success:(void (^)(WPReblackResult *result))success failure:(void (^)(NSError *error))failure;

@end
