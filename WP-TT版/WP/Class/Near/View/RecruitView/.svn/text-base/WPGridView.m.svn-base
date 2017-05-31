//
//  WPGridView.m
//  WP
//
//  Created by CBCCBC on 16/4/14.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGridView.h"

@interface WPGridView ()
@property (nonatomic ,strong)NSMutableArray *itemsArray;
@end

@implementation WPGridView

- (instancetype)init
{
    if ([super init]) {
        [self initItemShowStyle];
    }
    return self;
}

- (void)initItemShowStyle
{
    self.font = [UIFont systemFontOfSize:17];
    self.rows = 1;
    self.textColor = [UIColor blackColor];
    self.itemColor = [UIColor clearColor];
    self.textArray = @[@"这是一个自定义的GridView"];
    self.spacing = 3.0f;
    self.rowSpace = 0.0f;
    self.buildLine = NO;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self initItemShowStyle];
    }
    return self;
}

- (void)addItemsToView
{
    for (NSString *string in self.textArray) {
        UILabel *item = [[UILabel alloc]init];
        item.font = self.font;
        item.text = string;
        item.textColor = self.textColor;
        item.backgroundColor = self.itemColor;
        [self.itemsArray addObject:item];
        [self addSubview:item];
    }
}

- (void)layoutSubviews
{
    CGFloat x = self.frame.size.width / _rows;
    CGFloat width = self.frame.size.width/_rows-_spacing;
    CGFloat height = [@"蛋疼" getSizeWithFont:self.font Width:width].height;
    int i = 0;
    for (UILabel *item in self.itemsArray) {
        item.frame = CGRectMake((i%_rows)*x, (i/_rows)*(height+_rowSpace), width, height);
        i++;
    }
}

- (void)finishToShow
{
    [self addItemsToView];
}

- (NSMutableArray *)itemsArray
{
    if (!_itemsArray) {
        self.itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}
















@end
