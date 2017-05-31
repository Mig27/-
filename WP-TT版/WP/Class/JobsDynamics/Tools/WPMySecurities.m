//
//  WPMySecurities.m
//  WP
//
//  Created by 沈亮亮 on 16/6/2.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMySecurities.h"
#import<CommonCrypto/CommonCryptor.h>
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
#define LocalStr_None  @""

@implementation WPMySecurities

//转吗
+(NSString*)textBeBase64:(NSString*)string
{
    NSData* originData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:encodeResult options:0];
//
//    NSString* decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSASCIIStringEncoding];
    return encodeResult;
    
    
    
//    NSData * data1 = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSString * baseStr = [data1 base64EncodedStringWithOptions:0];
}

//解码
+ (NSString *)textFromBase64String:(NSString *)base64
{
    if (base64 && ![base64 isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY   改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [self dataWithBase64EncodedString:base64];
        //IOS 自带DES解密 Begin    改动了此处
        //data = [self DESDecrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return LocalStr_None;
    }
}


+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

+ (NSString *)textFromEmojiString:(NSString *)emojiStr
{
   NSDictionary *emotionUnicodeDic = @{@"[呵呵]":@"\U0001F60A",
                                       @"[嘻嘻]":@"\U0001F601",
                                       @"[哈哈]":@"\U0001F61B",
                                       @"[晕]":@"\U0001F635",
                                       @"[泪]":@"\U0001F62D",
                                       @"[馋嘴]":@"\U0001F60B",
                                       @"[抓狂]":@"\U0001F631",
                                       @"[哼]":@"\U0001F624",
                                       @"[可爱]":@"\U0001F60C",
                                       @"[怒]":@"\U0001F621",
                                       @"[困]":@"\U0001F611",
                                       @"[汗]":@"\U0001F613",
                                       @"[睡觉]":@"\U0001F634",
                                       @"[偷笑]":@"\U0001F604",
                                       @"[酷]":@"\U0001F60E",
                                       @"[吃惊]":@"\U0001F62E",
                                       @"[闭嘴]":@"\U0001F620",
                                       @"[花心]":@"\U0001F60D",
                                       @"[失望]":@"\U0001F627",
                                       @"[生病]":@"\U0001F616",
                                       @"[亲亲]":@"\U0001F618",
                                       @"[右哼哼]":@"\U0001F61A",
                                       @"[嘘]":@"\U0001F636",
                                       @"[挤眼]":@"\U0001F602",
                                       @"[酷]":@"\U0001F633",
                                       @"[感冒]":@"\U0001F637",
                                       @"[做鬼脸]":@"\U0001F60F",
                                       @"[阴险]":@"\U0001F608",
                                       @"[热吻]":@"\U0001F48B",
                                       @"[心]":@"\U00002764",
                                       @"[ok]":@"\U0001F44C",
                                       @"[不要]":@"\U0000261D",
                                       @"[弱]":@"\U0001F44E",
                                       @"[good]":@"\U0001F44D",
                                       @"[拳头]":@"\U0000270A",
                                       @"[耶]":@"\U0000270C",
                                       @"[0]":@"0️⃣",
                                       @"[1]":@"1️⃣",
                                       @"[2]":@"2️⃣",
                                       @"[3]":@"3️⃣",
                                       @"[4]":@"4️⃣",
                                       @"[5]":@"5️⃣",
                                       @"[6]":@"6️⃣",
                                       @"[7]":@"7️⃣",
                                       @"[8]":@"8️⃣",
                                       @"[9]":@"9️⃣"};
    for (NSString *key in [emotionUnicodeDic allKeys]) {
        if ([emojiStr containsString:key]) {
            emojiStr = [emojiStr stringByReplacingOccurrencesOfString:key withString:emotionUnicodeDic[key]];
        }
    }
    return emojiStr;
}
@end
