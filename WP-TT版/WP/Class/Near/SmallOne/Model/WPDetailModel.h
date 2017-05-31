//
//  WPDetailModel.h
//  WP
//
//  Created by Asuna on 15/5/28.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPDetailModel : NSObject
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *detail;

- (instancetype)initWithDict:(NSDictionary*)dict;
+ (instancetype)initWithDict:(NSDictionary*)dict;

//+ (NSMutableArray*)messages;
@end
