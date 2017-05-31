//
//  ShareOperation.h
//  WP
//
//  Created by 沈亮亮 on 15/12/31.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UMSocialSnsPlatformManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialSinaHandler.h"
@interface ShareOperation : NSObject

//+(void)shareToPlatform:(NSString *)platform presentController:(UIViewController *)controller status:(void(^)(UMSResponseCode status))status;
+(void)shareToPlatform:(UMSocialPlatformType)platform presentController:(UIViewController *)controller status:(void(^)(UMSocialShareResponse*status))status;
@end
