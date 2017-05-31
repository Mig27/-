//
//  WPGetNearbyPersonDataResult.h
//  WP
//
//  Created by Kokia on 16/5/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPGetNearbyPersonDataResult : NSObject

@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *user_nick_name;
@property (nonatomic, copy) NSString *PageIndex;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, copy) NSString *is_near;

@end
