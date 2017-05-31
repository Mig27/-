//
//  GetValidationView.m
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GetValidationView.h"
#import "UIImage+autoGenerate.h"

#define kLine RGB(226, 226, 226)

@implementation GetValidationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        CGFloat buttonx = SCREEN_WIDTH - kHEIGHT(76)-16;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 47, kHEIGHT(43))];
        label.text = @"+86";
        label.textColor = RGB(0, 172, 255);
        [self addSubview:label];
        
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(63, 0, 0.5, kHEIGHT(43))];
        view1.backgroundColor = kLine;
        [self addSubview:view1];
        
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(64+kHEIGHT(10), 0, buttonx-view1.right-16-kHEIGHT(10), kHEIGHT(43))];
        self.textField.placeholder = @"新手机号";
        [self addSubview:self.textField];
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(self.textField.right, 0, 0.5, kHEIGHT(43))];
        view2.backgroundColor = kLine;
        [self addSubview:view2];
        
        self.button = [[UIButton alloc]initWithFrame:CGRectMake(buttonx, kHEIGHT(8.5), kHEIGHT(76), kHEIGHT(26))];
        [self.button setBackgroundImage:[UIImage imageWithColor:RGB(0, 172, 255) size:CGSizeMake(kHEIGHT(76), kHEIGHT(26))] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageWithColor:RGB(0, 146, 217) size:CGSizeMake(kHEIGHT(76), kHEIGHT(26))] forState:UIControlStateHighlighted];
        [self.button setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.button.titleLabel.font = kFONT(12);
        [self addSubview:self.button];
        self.button.layer.cornerRadius = 5;
        self.button.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setTaget:(id)taget action:(SEL)action
{
    [self.button addTarget:taget action:action forControlEvents:UIControlEventTouchDown];
}



@end
