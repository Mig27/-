//
//  WPBlackListDeleteWithBatchHttp.h
//  WP
//
//  Created by Kokia on 16/5/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPBlackListDeleteWithBatchParam.h"
#import "WPBlackListDeleteWithBatchResult.h"

@interface WPBlackListDeleteWithBatchHttp : NSObject

+ (void)WPBlackListDeleteWithBatchHttpWithParam:(WPBlackListDeleteWithBatchParam *)param success:(void (^)(WPBlackListDeleteWithBatchResult *result))success failure:(void (^)(NSError *error))failure;


@end
