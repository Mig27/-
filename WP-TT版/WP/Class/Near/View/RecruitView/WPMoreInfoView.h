//
//  WPMoreInfoView.h
//  WP
//
//  Created by CBCCBC on 16/3/11.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPMoreInfoView : UIView

@property (nonatomic , strong)NSMutableArray *viewArr;
@property (nonatomic , assign)CGFloat leftCorner;
- (instancetype)initWithTop:(CGFloat)top;

@end
