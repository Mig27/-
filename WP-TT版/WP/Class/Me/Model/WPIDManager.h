//
//  WPIDManager.h
//  WP
//
//  Created by CBCCBC on 16/3/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPIDManager : NSObject


singleton_interface(WPIDManager)

- (void)requestWPIDWithWp_id:(NSString *)wp_id return:(void(^)(id json))returnVlaue;


@end
