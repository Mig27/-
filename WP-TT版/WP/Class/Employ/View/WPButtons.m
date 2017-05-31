//
//  WPButtons.m
//  WP
//
//  Created by CBCCBC on 16/3/30.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPButtons.h"
@interface WPButtons ()
@property (nonatomic ,strong)UIButton *company;
@property (nonatomic ,strong)UIButton *position;
@property (nonatomic ,strong)UIView *line;
@end

@implementation WPButtons

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.position];
        [self addSubview:self.company];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
        
        line.backgroundColor = RGB(226, 226, 226);
        [self addSubview:line];
        
        [self addSubview:self.line];
    }
    return self;
}

- (UIView *)line
{
    if (!_line) {
        self.line = [[UIView alloc]initWithFrame:CGRectMake(0, 44-2, SCREEN_WIDTH/2, 2)];
        self.line.backgroundColor = RGB(0, 172, 255);
    }
    return _line;
}

- (UIButton *)company
{
    if (!_company) {
        self.company = [UIButton buttonWithType:UIButtonTypeCustom];
        self.company.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 44);
        [self.company setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.company.backgroundColor = [UIColor whiteColor];
        [self.company setTitleColor:RGB(0, 172, 255) forState:UIControlStateSelected];
//        [self.company setTitleColor:RGB(0, 172, 255) forState:UIControlStateHighlighted];
        [self.company setTitle:@"全部职位" forState:UIControlStateNormal];
        self.company.titleLabel.font = kFONT(14);
        self.company.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        self.company.selected = YES;
        [self.company setImage:[UIImage imageNamed:@"common_quanbuzhiweihui"] forState:UIControlStateNormal];
        [self.company setImage:[UIImage imageNamed:@"common_quanbuzhiweilan"] forState:UIControlStateSelected];
//        [self.company setImage:[UIImage imageNamed:@"common_quanbuzhiweilan"] forState:UIControlStateHighlighted];
        [self.company addTarget:self action:@selector(companyAndPositionButtonAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _company;
}

- (UIButton *)position
{
    if (!_position) {
        self.position = [UIButton buttonWithType:UIButtonTypeCustom];
        self.position.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 44);
        [self.position setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.position.backgroundColor = [UIColor whiteColor];
        [self.position setTitleColor:RGB(0, 172, 255) forState:UIControlStateSelected];
        [self.position setTitleColor:RGB(0, 172, 255) forState:UIControlStateHighlighted];
        [self.position setTitle:@"企业简介" forState:UIControlStateNormal];
        self.position.titleLabel.font = kFONT(14);
        self.position.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [self.position setImage:[UIImage imageNamed:@"common_qiyexinxihui"] forState:UIControlStateNormal];
        [self.position setImage:[UIImage imageNamed:@"common_qiyexinxilan"] forState:UIControlStateSelected];
        [self.position addTarget:self action:@selector(companyAndPositionButtonAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _position;
}

- (void)setIsLeft:(BOOL)isLeft
{
    [self removeLineWithIsLeft:isLeft];
    
}

- (void)removeLineWithIsLeft:(BOOL)status
{
    [self resetButtonSelectedWithSelected:status];
    CGFloat x;
    if (status) {
        x = SCREEN_WIDTH/2;
    }else{
        x = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.line.frame = CGRectMake(x, 44-2, SCREEN_WIDTH/2, 2);
    }];
}

- (void)resetButtonSelectedWithSelected:(BOOL)selected
{
    self.company.selected = !selected;
    self.position.selected = selected;
}

- (void)companyAndPositionButtonAction:(UIButton *)sender
{
    BOOL status = [sender.titleLabel.text isEqualToString:@"企业简介"];
    [self removeLineWithIsLeft:status];
}

- (void)addTargate:(id)targate action:(SEL)action
{
    [self.position addTarget:targate action:action forControlEvents:UIControlEventTouchDown];
    [self.company addTarget:targate action:action forControlEvents:UIControlEventTouchDown];
}


@end
