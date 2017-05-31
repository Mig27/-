//
//  SPTextView.m
//  WP
//
//  Created by CBCCBC on 15/9/22.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "SPTextView.h"

@interface SPTextView () <UITextViewDelegate>

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIButton *button;

@end

@implementation SPTextView

-(void)setWithTitle:(NSString *)title  placeholder:(NSString *)placeholder
{
    self.backgroundColor = [UIColor whiteColor];
    
    CGSize size = [@"卧槽尼玛:" getSizeWithFont:FUCKFONT(15) Height:self.height];
    CGSize size1 = [@"卧       槽:" getSizeWithFont:FUCKFONT(15) Height:self.height];
    CGFloat width = size.width>size1.width?size.width:size1.width;
    
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, width, 20)];
    label.text = title;
    label.font =kFONT(15);
    [self addSubview:label];
    
    _text = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(label.right+6, 0, self.width-100, self.height)];
    _text.font = kFONT(15);
    _text.delegate = self;
    _text.placeholder = placeholder;
    _text.returnKeyType = UIReturnKeyDefault;
    [self addSubview:_text];
    
//    _label = [[UILabel alloc]initWithFrame:CGRectMake(3, 7, 200, 20)];
//    _label.enabled = NO;
//    _label.text = placeholder;
//    _label.font = GetFont(15);
//    _label.textColor =RGB(170, 170, 170);
//    [_text addSubview:_label];
    
//    _button = [UIButton buttonWithType:UIButtonTypeCustom];
//    _button.frame = CGRectMake(3, 7, 200, 20);
//    _button.enabled = NO;
//    [_button setTitle:placeholder  forState:UIControlStateNormal];
//    [_button setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
//    [_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    _button.titleLabel.font = GetFont(16);
//    [_text addSubview:_button];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height - 0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(226, 226, 226);
    [self addSubview:line];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [_button setHidden:NO];
    }else{
        [_button setHidden:YES];
    }
}

-(NSString *)title
{
    _title = _text.text;
    return _title;
}

-(void)resetTitle:(NSString *)title
{
    _text.text = title;
    [_button setHidden:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.showToFont) {
        self.showToFont();
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.hideFromFont) {
        self.hideFromFont(self.text.text);
    }
}

@end
