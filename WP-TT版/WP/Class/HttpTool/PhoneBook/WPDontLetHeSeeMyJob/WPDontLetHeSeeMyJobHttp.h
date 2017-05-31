//
//  WPDontLetHeSeeMyJobHttp.h
//  WP
//
//  Created by Kokia on 16/5/10.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPDontLetHeSeeMyJobParam.h"
#import "WPDontLetHeSeeMyJobResult.h"

@interface WPDontLetHeSeeMyJobHttp : NSObject

+ (void)WPDontLetHeSeeMyJobHttpWithParam:(WPDontLetHeSeeMyJobParam *)param success:(void (^)(WPDontLetHeSeeMyJobResult *result))success failure:(void (^)(NSError *error))failure;

@end
