//
//  SPTitleItem.m
//  WP
//
//  Created by CBCCBC on 15/10/27.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "SPTitleItem.h"

#define ItemHeights 32

@implementation SPTitleItem

- (id)initWithTop:(CGFloat)top title:(NSString *)title{
    self = [super initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemHeights)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, ItemHeights/2-7.5, 3, 15)];
        label.backgroundColor = RGB(153, 153, 153);
        [self addSubview:label];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(label.right+6, ItemHeights/2-10, SCREEN_WIDTH-label.right-6, 20)];
        label1.text = title;
        label1.textColor = RGB(153, 153, 153);
        [self addSubview:label1];
    }
    return self;
}

@end
