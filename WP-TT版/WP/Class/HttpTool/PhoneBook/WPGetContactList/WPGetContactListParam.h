//
//  WPGetContactListParam.h
//  WP
//
//  Created by Kokia on 16/5/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPGetContactListParam : NSObject

@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *mobileJson;

@end
