//
//  WPDontSeeHisJobHttp.h
//  WP
//
//  Created by Kokia on 16/5/10.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPDontSeeHisJobResult.h"
#import "WPDontSeeHisJobParam.h"

@interface WPDontSeeHisJobHttp : NSObject

+ (void)WPDontSeeHisJobHttpWithParam:(WPDontSeeHisJobParam *)param success:(void (^)(WPDontSeeHisJobResult *result))success failure:(void (^)(NSError *error))failure;

@end
