//
//  NewInputView.m
//  WP
//
//  Created by CBCCBC on 16/3/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "NewInputView.h"
#import "NSString+StringType.h"
@interface NewInputView()
@property (nonatomic ,strong)UILabel *label;
@end
@implementation NewInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.label];
        [self addSubview:self.textField];
        self.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kHEIGHT(0), kHEIGHT(42.5), SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [self addSubview:line];
    }
    return self;
}

- (void)setTitle:(NSString *)title placeholder:(NSString *)placeholder
{
    CGSize labelSize = [title getSizeWithFont:FUCKFONT(15) Height:kHEIGHT(43)];
    self.label.text = title;
    self.label.frame = CGRectMake(16, 0, labelSize.width, kHEIGHT(43));
    self.textField.frame = CGRectMake(self.label.right+6, 0, SCREEN_WIDTH - self.label.right, kHEIGHT(43));
    self.textField.placeholder = placeholder;
}

- (UITextField *)textField
{
    if (!_textField) {
        self.textField = [[WPtextFiled alloc]initWithFrame:CGRectMake(16, 1, 0, kHEIGHT(43))];
    }
    return _textField;
}

- (UILabel *)label
{
    if (!_label) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 0, kHEIGHT(43))];
    }
    return _label;
}


@end
