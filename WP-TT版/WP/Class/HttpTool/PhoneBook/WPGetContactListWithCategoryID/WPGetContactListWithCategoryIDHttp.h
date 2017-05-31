//
//  WPGetContactListWithCategoryIDHttp.h
//  WP
//
//  Created by Kokia on 16/5/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPGetContactListWithCategoryIDParam.h"
#import "WPGetContactListWithCategoryIDResult.h"

@interface WPGetContactListWithCategoryIDHttp : NSObject

+ (void)WPGetContactListWithCategoryIDHttpWithParam:(WPGetContactListWithCategoryIDParam *)param success:(void (^)(WPGetContactListWithCategoryIDResult *result))success failure:(void (^)(NSError *error))failure;


@end
