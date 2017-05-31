//
//  MRCommonItem.h
//  闵瑞微博
//
//  Created by Asuna on 15/4/21.
//  Copyright (c) 2015年 Asuna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRCommonItem : NSObject
/** 图标 */
@property (nonatomic, copy) NSString *icon;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 子标题 */
@property (nonatomic, copy) NSString *subttile;
/** 右边的提示数字 */
@property (nonatomic, copy) NSString *badgeValue;
/** 需要跳转的控制器类名 */
@property (nonatomic, assign) Class destVc;
/** 点击这个cell想做的操作 */
@property (nonatomic, copy) void (^operation)();

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;
+ (instancetype)itemWithTitle:(NSString *)title;
@end
