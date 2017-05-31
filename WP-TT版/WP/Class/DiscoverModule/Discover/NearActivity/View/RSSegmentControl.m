//
//  RSSegmentControl.m
//  WP
//
//  Created by 沈亮亮 on 15/10/13.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "RSSegmentControl.h"

@interface RSSegmentControl ()

@end

@implementation RSSegmentControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = frame.size.height/2;
        self.clipsToBounds = YES;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = RGB(226, 226, 226).CGColor;
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 0, frame.size.width/2, frame.size.height);
        [btn1 setTitle:@"文字" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont systemFontOfSize:12];
        btn1.tag = 1;
        [btn1 addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn1];
        
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height);
        [btn2 setTitle:@"图片" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont systemFontOfSize:12];
        btn2.tag = 2;
        [btn2 addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn2];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2, 0, 0.5, frame.size.height)];
        line.backgroundColor = RGB(226, 226, 226);
        [self addSubview:line];
    }
    return self;
}

- (void)segClick:(UIButton *)sender
{
    if (self.SegmentClickBlock) {
        self.SegmentClickBlock(sender.tag - 1);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
