//
//  WPHotHeaderCell.m
//  WP
//
//  Created by CBCCBC on 15/11/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPHotHeaderCell.h"
#import "SPLabel.h"

@implementation WPHotHeaderCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        WS(ws);
        self.backgroundColor = RGB(235, 235, 235);
        SPLabel *colorLabel = [SPLabel new];
        colorLabel.backgroundColor = RGB(0, 172, 255);
        [self addSubview:colorLabel];
        [colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws).offset(10);
            make.centerY.equalTo(ws);
            make.width.equalTo(@(kHEIGHT(5)));
            make.height.equalTo(@(kHEIGHT(12)));
        }];
        
        SPLabel *titleLabel = [SPLabel new];
        titleLabel.tag = 1;
        titleLabel.font = kFONT(12);
        [self addSubview:titleLabel];
        titleLabel.verticalAlignment = VerticalAlignmentMiddle;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(ws);
            make.left.equalTo(colorLabel.mas_right).offset(6);
            make.right.equalTo(ws);
        }];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //NO.1画一条线
    CGContextSetRGBStrokeColor(context, 226.0/255.0, 226.0/255.0, 226.0/255.0, 1);//线条颜色
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 0, self.height);
    CGContextAddLineToPoint(context, SCREEN_WIDTH,self.height);
    
    CGContextStrokePath(context);
}

@end
