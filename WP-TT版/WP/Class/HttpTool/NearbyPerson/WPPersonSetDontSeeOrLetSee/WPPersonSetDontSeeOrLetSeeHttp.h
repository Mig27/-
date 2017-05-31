//
//  WPPersonSetDontSeeOrLetSeeHttp.h
//  WP
//
//  Created by CC on 16/6/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPPersonSetDontSeeOrLetSeeParam.h"
#import "WPPersonSetDontSeeOrLetSeeResult.h"

@interface WPPersonSetDontSeeOrLetSeeHttp : NSObject

+ (void)WPPersonSetDontSeeOrLetSeeHttpWithParam:(WPPersonSetDontSeeOrLetSeeParam *)param success:(void (^)(WPPersonSetDontSeeOrLetSeeResult *result))success failure:(void (^)(NSError *error))failure;

@end
