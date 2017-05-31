//
//  SPLocalApplyArray.h
//  WP
//
//  Created by CBCCBC on 15/11/25.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPLocalApplyArray : NSObject
/**
 *  性别没有限制
 *
 *  @return
 */
+ (NSArray *)sexWithNoLimitArray;
/**
 *  性别
 *
 *  @return 返回性别数组
 */
+ (NSArray *)sexArray;
/**
 *  年龄
 *
 *  @return 年龄
 */
+ (NSArray *)ageArray;
/**
 *  学历
 *
 *  @return 学历
 */
+ (NSArray *)educationArray;
+(NSArray*)noLimitEducationArray;
/**
 *  工作年限
 *
 *  @return 工作年限
 */
+ (NSArray *)workTimeArray;
/**
 *  工资
 *
 *  @return 工资
 */
+ (NSArray *)salaryArray;
/**
 *  婚姻状况
 *
 *  @return 婚姻状况
 */
+ (NSArray *)marriageArray;
/**
 *  福利
 *
 *  @return 福利
 */
+ (NSArray *)welfareArray;
+ (NSArray *)unLimitWelfareArray;

/**
 *  公司性质
 *
 *  @return 公司性质
 */
+ (NSArray *)natureArray;
/**
 *  公司规模
 *
 *  @return 公司规模
 */
+ (NSArray *)scaleArray;
/**
 *  求职报名条件
 *
 *  @return 求职报名条件
 */
+ (NSArray *)interviewApplyArray;
/**
 *  转换性别内容为1，0
 *
 *  @param sex 传入内容
 *
 *  @return 返回数字性别
 */
+(NSString *)sexToNumber:(id)sex;
/**
 *  转换性别内容为男，女
 *
 *  @param sex 传入内容
 *
 *  @return 返回汉字性别
 */
+(NSString *)sexToString:(id)sex;

@end
