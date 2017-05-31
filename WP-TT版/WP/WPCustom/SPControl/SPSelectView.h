//
//  LocalView.h
//  WP
//
//  Created by CBCCBC on 15/9/18.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndustryModel.h"

typedef void (^SPSelectViewBlock)(IndustryModel *model);


@protocol SPSelectViewDelegate <NSObject>

-(void)SPSelectViewDelegate:(IndustryModel *)model;

@end

@interface SPSelectView : UIView

@property (assign, nonatomic) id <SPSelectViewDelegate> delegate;
@property (assign, nonatomic) BOOL isArea;
@property (assign, nonatomic) BOOL isIndustry;
@property (nonatomic, strong)UILabel* line;

@property (nonatomic, assign) BOOL threeStage;//只需要省市区
@property (nonatomic, assign)BOOL personalInfoPosition;//选择个人资料中的职位

-(id)initWithTop:(CGFloat)top;

/**
 *  通过给定的网络地址和参数格式进行网络请求
 *
 *  @param urlStr 请求地址
 *  @param params 上传参数
 */
-(void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params;

/**
 * 本地数据操作
 *
 *  @param arr 给定的数组数据
 */
-(void)setLocalData:(NSArray *)arr;


/**
 *  通过给定的网络地址和参数格式进行网络请求
 *
 *  @param urlStr 请求地址
 *  @param params 上传参数
 *  @param block  回调函数
 */
-(void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params block:(SPSelectViewBlock)block;


/**
 *  本地数据操作
 *
 *  @param arr   本地数组
 *  @param block 回调函数
 */
-(void)setLocalData:(NSArray *)arr block:(SPSelectViewBlock)block;

/**
 *  移除视图
 */
-(void)remove;

@end
