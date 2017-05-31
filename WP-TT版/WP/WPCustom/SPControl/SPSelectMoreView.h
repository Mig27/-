//
//  SPSelectMoreView.h
//  WP
//
//  Created by CBCCBC on 15/10/18.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndustryModel.h"
@class SPSelectMoreView;
@protocol SPSelectMoreViewDelegate <NSObject>

-(void)SPSelectMoreViewDelegate:(SPSelectMoreView *)selectMoreView arr:(NSArray *)arr;

@end

@interface SPSelectMoreView : UIView

@property (assign, nonatomic) id <SPSelectMoreViewDelegate> delegate;
@property (strong, nonatomic)UILabel* line;
@property (strong, nonatomic) NSMutableArray *selectArr;

-(id)initWithTop:(CGFloat)top;

/**
 * 本地数据操作
 *
 *  @param arr 给定的数组数据
 */
-(void)setLocalData:(NSArray *)arr SelectArr:(NSArray *)selectArr;

/**
 *  移除视图
 */
-(void)remove;

@end
