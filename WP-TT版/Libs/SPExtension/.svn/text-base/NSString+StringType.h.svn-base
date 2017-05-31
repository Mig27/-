//
//  NSString+StringType.h
//  BoYue
//
//  Created by Spyer on 14/12/3.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, StringType) {
    
        StringTypeUserName,//用户名
        StringTypePhone,//手机号
        StringTypeEmail,//邮箱
        StringTypePhoneNumber,//数字0-9
        StringTypePassword,//密码
        StringTypeMoney,//钱或者积分
};


@interface NSString (StringType)

- (NSString *)replaceReturn;

-(NSMutableAttributedString *)addUnderLine;
/** 根据宽度和字体大小获得Size*/
-(CGSize)getSizeWithFont:(UIFont *)font Width:(CGFloat)width;
/** 根据高度和字体大小获得Size*/
-(CGSize)getSizeWithFont:(CGFloat)font Height:(CGFloat)height;
/** 判断字符串是否属于指定类型*/
-(BOOL)isType:(StringType)stringType;
/** 根据字符串类型判断长度是否被允许*/
-(BOOL)isAllowInputWithMaxLength:(NSInteger)maxLength stringType:(StringType)stringType;
/** 根据字符串返回性别男or女或者1or0*/
-(NSString *)sex;
/** 判断星座*/
+(NSString *)getAstroWithMonth:(int)m day:(int)d;
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;

/**根据布尔值返回信息*/
+(NSString *)collectionMessage:(BOOL)count;
@end
