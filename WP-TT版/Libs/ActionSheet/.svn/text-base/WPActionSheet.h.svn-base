//
//  WPActionSheet.h
//  test
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 Spyer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WPActionSheet;
@protocol WPActionSheet <NSObject>

//-(void)WPActionSheetAtIndex:(NSInteger)index;
- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

typedef void(^WPActionSheetType)(NSInteger type);

@interface WPActionSheet : UIView

-(instancetype)initWithDelegate:(id<WPActionSheet>)delegate otherButtonTitle:(NSArray *)otherTitles imageNames:(NSArray *)imageNames top:(CGFloat)top;
-(void)showInView:(UIView *)view;
-(void)hideFromView:(UIView *)view;
- (void)showInViewSpecial:(UIView *)view;
-(instancetype)initWithOtherButtonTitle:(NSArray *)otherTitles imageNames:(NSArray *)imageNames top:(CGFloat)top actions:(WPActionSheetType) type;

@property (assign, nonatomic) id <WPActionSheet> delegate;
@property (copy, nonatomic) void (^touchToHide)();

/**
 *  类方法创建WPActionSheet type从『1』开始
 *
 *  @param superView   父视图
 *  @param otherTitles 其他按钮
 *  @param imageNames  其他按钮图片
 *  @param top         起始高度
 *  @param type        类型
 */
+(void)superView:(UIView *)superView otherButtonTitle:(NSArray *)otherTitles imageNames:(NSArray *)imageNames top:(CGFloat)top actions:(WPActionSheetType) type;

/**
 *  类方法移除ActionSheet
 *
 *  @param superView 父视图
 */
+(void)removeFromsuperView:(UIView *)superView;

@end
