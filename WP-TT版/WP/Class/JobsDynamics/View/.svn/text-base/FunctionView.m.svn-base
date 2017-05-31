//
//  FunctionView.m
//  WP
//
//  Created by 沈亮亮 on 15/7/7.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "FunctionView.h"

@interface FunctionView ()

@end

@implementation FunctionView

- (void)layoutSubviews{
    
    CGFloat hight = 32;
    CGFloat width = 143;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, hight)];
    image.image = [UIImage imageNamed:@"small_roundrect"];
    [self addSubview:image];
    NSArray *titles = @[@"评论",@"赞"];
    for (int i = 0; i<2; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(72*i, 0, 71, 32)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [image addSubview:btn];
        if (i==0) {
            _btn1 = btn;
        } else {
            _btn2 = btn;
        }

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
