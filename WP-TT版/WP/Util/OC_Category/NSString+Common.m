//
//  NSString+Common.m
//  WPkeyboard
//
//  Created by Kokia on 16/3/8.
//  Copyright © 2016年 Kokia. All rights reserved.
//

#import "NSString+Common.h"

#import <CommonCrypto/CommonDigest.h>



@implementation NSString (Common)


- (NSString *)md5Str
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


- (NSString *)trimWhitespace
{
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    return str;
}

- (BOOL)isEmpty
{
    return [[self trimWhitespace] isEqualToString:@""];
}

// 是否包含语音解析的图标
- (BOOL)hasListenChar
{
    BOOL hasListenChar = NO;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    for (length = [self length]; length > 0; length--) {
        if (charBuffer[length -1] == 65532) {//'\U0000fffc'
            hasListenChar = YES;
            break;
        }
    }
    return hasListenChar;
}

#pragma mark emotion_monkey
+ (NSDictionary *)emotion_monkey_dict {
    static NSDictionary *_emotion_monkey_dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emotion_monkey_dict = @{
                                 //猴子大表情
                                 @"coding_emoji_01": @"哈哈",
                                 @"coding_emoji_02": @"吐",
                                 @"coding_emoji_03": @"压力山大",
                                 @"coding_emoji_04": @"忧伤",
                                 @"coding_emoji_05": @"坏人",
                                 @"coding_emoji_06": @"酷",
                                 @"coding_emoji_07": @"哼",
                                 @"coding_emoji_08": @"你咬我啊",
                                 @"coding_emoji_09": @"内急",
                                 @"coding_emoji_10": @"32个赞",
                                 @"coding_emoji_11": @"加油",
                                 @"coding_emoji_12": @"闭嘴",
                                 @"coding_emoji_13": @"wow",
                                 @"coding_emoji_14": @"泪流成河",
                                 @"coding_emoji_15": @"NO!",
                                 @"coding_emoji_16": @"疑问",
                                 @"coding_emoji_17": @"耶",
                                 @"coding_emoji_18": @"生日快乐",
                                 @"coding_emoji_19": @"求包养",
                                 @"coding_emoji_20": @"吹泡泡",
                                 @"coding_emoji_21": @"睡觉",
                                 @"coding_emoji_22": @"惊讶",
                                 @"coding_emoji_23": @"Hi",
                                 @"coding_emoji_24": @"打发点咯",
                                 @"coding_emoji_25": @"呵呵",
                                 @"coding_emoji_26": @"喷血",
                                 @"coding_emoji_27": @"Bug",
                                 @"coding_emoji_28": @"听音乐",
                                 @"coding_emoji_29": @"垒码",
                                 @"coding_emoji_30": @"我打你哦",
                                 @"coding_emoji_31": @"顶足球",
                                 @"coding_emoji_32": @"放毒气",
                                 @"coding_emoji_33": @"表白",
                                 @"coding_emoji_34": @"抓瓢虫",
                                 @"coding_emoji_35": @"下班",
                                 @"coding_emoji_36": @"冒泡",
                                 @"coding_emoji_38": @"2015",
                                 @"coding_emoji_39": @"拜年",
                                 @"coding_emoji_40": @"发红包",
                                 @"coding_emoji_41": @"放鞭炮",
                                 @"coding_emoji_42": @"求红包",
                                 @"coding_emoji_43": @"新年快乐",
                                 //猴子大表情 Gif
                                 @"coding_emoji_gif_01": @"奔月",
                                 @"coding_emoji_gif_02": @"吃月饼",
                                 @"coding_emoji_gif_03": @"捞月",
                                 @"coding_emoji_gif_04": @"打招呼",
                                 @"coding_emoji_gif_05": @"悠闲",
                                 @"coding_emoji_gif_06": @"赏月",
                                 @"coding_emoji_gif_07": @"中秋快乐",
                                 @"coding_emoji_gif_08": @"爬爬",
                                 };
    });
    return _emotion_monkey_dict;
}
- (NSString *)emotionMonkeyName{
    return [NSString emotion_monkey_dict][self];
}



@end
