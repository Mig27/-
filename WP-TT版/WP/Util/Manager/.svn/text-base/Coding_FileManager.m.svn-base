//
//  Coding_FileManager.m
//  WPkeyboard
//
//  Created by Kokia on 16/3/8.
//  Copyright © 2016年 Kokia. All rights reserved.
//

#import "Coding_FileManager.h"

@implementation Coding_FileManager

+ (AFURLSessionManager *)af_manager{
    static AFURLSessionManager *_af_manager = nil;
    static dispatch_once_t af_onceToken;
    dispatch_once(&af_onceToken, ^{
        _af_manager= [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return _af_manager;
}

@end
