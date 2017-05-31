//
//  WPMySecurities.h
//  WP
//
//  Created by 沈亮亮 on 16/6/2.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPMySecurities : NSObject

//加密
+(NSString*)textBeBase64:(NSString*)string;
/**
 *  base64解密
 *
 *  @param base64 解密前的base64字符串
 *
 *  @return 解密后的字符串
 */
+ (NSString *)textFromBase64String:(NSString *)base64;
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
/**
 *  将安卓端字符串中的emoji表情替换回来
 *
 *  @param emjioStr 安卓端带字符串的文字
 *
 *  @return 将emoji替换成功后的文字
 */
+ (NSString *)textFromEmojiString:(NSString *)emojiStr;

@end
