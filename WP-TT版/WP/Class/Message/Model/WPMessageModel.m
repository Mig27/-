//
//  WPMessageModel.m
//  WP
//
//  Created by Asuna on 15/5/20.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPMessageModel.h"

@implementation WPMessageModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)initWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSMutableArray *)messages
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tgs.plist" ofType:nil]];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self initWithDict:dict]];
    }
    return arrayM;
}

@end
