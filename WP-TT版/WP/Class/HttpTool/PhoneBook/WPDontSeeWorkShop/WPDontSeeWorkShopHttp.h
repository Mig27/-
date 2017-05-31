//
//  WPDontSeeWorkShopHttp.h
//  WP
//
//  Created by Kokia on 16/5/10.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPDontSeeWorkShopParam.h"
#import "WPDontSeeWorkShopResult.h"

@interface WPDontSeeWorkShopHttp : NSObject

+ (void)WPDontSeeWorkShopHttpWithParam:(WPDontSeeWorkShopParam *)param success:(void (^)(WPDontSeeWorkShopResult *result))success failure:(void (^)(NSError *error))failure;


@end
