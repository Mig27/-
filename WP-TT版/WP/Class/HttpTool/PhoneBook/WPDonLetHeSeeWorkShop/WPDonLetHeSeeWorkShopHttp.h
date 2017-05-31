//
//  WPDonLetHeSeeWorkShopHttp.h
//  WP
//
//  Created by Kokia on 16/5/10.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPDonLetHeSeeWorkShopParam.h"
#import "WPDonLetHeSeeWorkShopResult.h"

@interface WPDonLetHeSeeWorkShopHttp : NSObject

+ (void)WPDonLetHeSeeWorkShopHttpWithParam:(WPDonLetHeSeeWorkShopParam *)param success:(void (^)(WPDonLetHeSeeWorkShopResult *result))success failure:(void (^)(NSError *error))failure;

@end
