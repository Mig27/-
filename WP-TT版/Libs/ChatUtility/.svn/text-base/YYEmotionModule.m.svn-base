//
//  YYEmotionModule.m
//  WP
//
//  Created by CC on 16/6/15.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "YYEmotionModule.h"

@interface YYEmotionModule ()

@end

@implementation YYEmotionModule
+ (instancetype)shareInstance
{
    static YYEmotionModule* g_emotionsModule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_emotionsModule = [[YYEmotionModule alloc] init];
    });
    return g_emotionsModule;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self yyEmotion];
    }
    return self;
}

-(void)yyEmotion{
    
    _emotionUnicodeDic = @{@"[牙牙撒花]":@"tt_yaya_e1",
                           @"[牙牙尴尬]":@"tt_yaya_e2",
                           @"[牙牙大笑]":@"tt_yaya_e3",
                           @"[牙牙组团]":@"tt_yaya_e4",
                           @"[牙牙凄凉]":@"tt_yaya_e5",
                           @"[牙牙吐血]":@"tt_yaya_e6",
                           @"[牙牙花痴]":@"tt_yaya_e7",
                           @"[牙牙疑问]":@"tt_yaya_e8",
                           @"[牙牙爱心]":@"tt_yaya_e9",
                           @"[牙牙害羞]":@"tt_yaya_e10",
                           @"[牙牙牙买碟]":@"tt_yaya_e11",
                           @"[牙牙亲一下]":@"tt_yaya_e12",
                           @"[牙牙大哭]":@"tt_yaya_e13",
                           @"[牙牙愤怒]":@"tt_yaya_e14",
                           @"[牙牙挖鼻屎]":@"tt_yaya_e15",
                           @"[牙牙嘻嘻]":@"tt_yaya_e16",
                           @"[牙牙漂漂]":@"tt_yaya_e17",
                           @"[牙牙冰冻]":@"tt_yaya_e18",
                           @"[牙牙傲娇]":@"tt_yaya_e19",
                           
                           };
    _unicodeEmotionDic = [[NSMutableDictionary alloc] init];
    [_emotionUnicodeDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [_unicodeEmotionDic setValue:key forKey:obj];
    }];
    
    _emotions = [[NSMutableArray alloc] initWithArray:[_emotionUnicodeDic allKeys]];
    
    _emotionLength = [[NSMutableDictionary alloc] init];
    [_emotions enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSString *string = _emotionUnicodeDic[obj];
        [_emotionLength setValue:@([string length]) forKeyPath:obj];
    }];
}

@end
