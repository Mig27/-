//
//  WPDragIntoBlackListHttp.h
//  WP
//
//  Created by Kokia on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPDragIntoBlackListParam.h"
#import "WPDragIntoBlackListResult.h"

@interface WPDragIntoBlackListHttp : NSObject

+ (void)WPDragIntoBlackListHttpWithParam:(WPDragIntoBlackListParam *)param success:(void (^)(WPDragIntoBlackListResult *result))success failure:(void (^)(NSError *error))failure;

@end
