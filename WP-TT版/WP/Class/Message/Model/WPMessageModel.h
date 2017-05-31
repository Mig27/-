//
//  WPMessageModel.h
//  WP
//
//  Created by Asuna on 15/5/20.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPMessageModel : NSObject
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,copy) NSString *iconNumber;
- (instancetype)initWithDict:(NSDictionary*)dict;
+ (instancetype)initWithDict:(NSDictionary*)dict;

+ (NSMutableArray*)messages;
@end
