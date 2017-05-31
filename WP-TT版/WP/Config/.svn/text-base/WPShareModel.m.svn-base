//
//  WPShareModel.m
//  WP
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPShareModel.h"

@implementation WPShareModel

+ (WPShareModel*)sharedModel
{
    static WPShareModel* model =  nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[WPShareModel alloc]init];
    });
    return model;
}

@end
