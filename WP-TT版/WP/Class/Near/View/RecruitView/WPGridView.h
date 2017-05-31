//
//  WPGridView.h
//  WP
//
//  Created by CBCCBC on 16/4/14.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPGridView : UIView
@property (nonatomic ,strong)NSArray *textArray;
@property (nonatomic ,strong)UIFont *font;
@property (nonatomic ,assign)NSInteger rows;
@property (nonatomic ,strong)UIColor *itemColor;
@property (nonatomic ,strong)UIColor *textColor;
@property (nonatomic ,assign)CGFloat spacing;
@property (nonatomic ,assign)CGFloat rowSpace;
@property (nonatomic ,getter=existLine)BOOL buildLine;
- (void)finishToShow;

@end
