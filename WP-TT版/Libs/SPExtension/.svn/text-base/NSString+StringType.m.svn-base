
//
//  NSString+StringType.m
//  BoYue
//
//  Created by Spyer on 14/12/3.
//  Copyright (c) 2014年 X. All rights reserved.
//


#import "NSString+StringType.h"

@implementation NSString (StringType)

- (NSString *)replaceReturn{
    return [self stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
}

//返回字符串
-(NSMutableAttributedString *)addUnderLine
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc
                                                    ]initWithString:self];
    NSRange attributedRange = {0,attributedString.length};
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:attributedRange];
    return attributedString;
}

//是否为指定的字符串类型
-(BOOL)isType:(StringType)stringType
{
    NSString *regex;
    if (stringType == StringTypePhone) {
        
        regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    }
    if (stringType == StringTypePhoneNumber) {
        
        regex = @"^[0-9]\\d*$";
    }
    if (stringType == StringTypePassword) {
        
        regex = @"^[A-Za-z0-9]+$";
    }
    if (stringType == StringTypeMoney) {
        
        regex = @"^[0-9]+([.]{1}[0-9]+){0,1}$";
    }
    if (stringType == StringTypeEmail) {

        regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    }
    if (stringType == StringTypeUserName) {
        
        regex = @"(^[A-Za-z0-9]{3,20}$)";
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

//获取字体为font，宽度为width的所需要的size
-(CGSize)getSizeWithFont:(UIFont *)font Width:(CGFloat)width
{
    CGSize size;
    CGSize constrainsize = CGSizeMake(width, 2000);
    size = [self boundingRectWithSize:constrainsize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil].size;
    
    return size;
}

-(CGSize)getSizeWithFont:(CGFloat)font Height:(CGFloat)height
{
    CGSize size;
    CGSize constrainsize = CGSizeMake(2000, height);
    size = [self boundingRectWithSize:constrainsize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName] context:nil].size;
    
    return size;
}

//判断stringType是否允许输入最大长度
-(BOOL)isAllowInputWithMaxLength:(NSInteger)maxLength stringType:(StringType)stringType
{
    BOOL isAlloewInput;
    if (self.length>=1&&self.length<=maxLength)
    {
        
        if ([self isType:stringType])
        {
            isAlloewInput = YES;
        }
        else
        {
            isAlloewInput = NO;
        }
    }
    else
    {
        isAlloewInput = NO;
    }
    
    return isAlloewInput;
}

#pragma mark-判断星座
+(NSString *)getAstroWithMonth:(int)m day:(int)d{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m<1||m>12||d<1||d>31){
        return @"错误日期格式!";
    }
    if(m==2 && d>29)
    {
        return @"错误日期格式!!";
    }else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    return result;
}

-(NSString *)sex
{
    if ([self isEqualToString:@"1"]) {
        return @"男";
    }else if ([self isEqualToString:@"2"]){
        return @"女";
    }else if ([self isEqualToString:@"0"]){
        return @"保密";
    }else if ([self isEqualToString:@"保密"]){
        return @"0";
    }else if ([self isEqualToString:@"男"]){
        return @"1";
    }else if ([self isEqualToString:@"女"]){
        return @"2";
    }else{
        return @"";
    }
}

+(NSString *)collectionMessage:(BOOL)count
{
    NSString *text;
    if (count) {
        text = @"收藏成功";
    }else{
        text = @"取消收藏成功";
    }
    return text;
}
#pragma mark - 正则表达式
//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}


//车型
+ (BOOL) validateCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}


//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}


//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}


//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}


//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

@end
