//
//  WPDontLetHeSeeMyRecruitHttp.h
//  WP
//
//  Created by Kokia on 16/5/10.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPDontLetHeSeeMyRecruitParam.h"
#import "WPDontLetHeSeeMyRecruitResult.h"

@interface WPDontLetHeSeeMyRecruitHttp : NSObject

+ (void)WPDontLetHeSeeMyRecruitHttpWithParam:(WPDontLetHeSeeMyRecruitParam *)param success:(void (^)(WPDontLetHeSeeMyRecruitResult *result))success failure:(void (^)(NSError *error))failure;

@end
