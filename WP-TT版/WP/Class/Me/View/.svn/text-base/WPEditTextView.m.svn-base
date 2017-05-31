//
//  WPEditTextCell.m
//  WP
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPEditTextView.h"

#import "MacroDefinition.h"

@interface WPEditTextView ()

@property (strong,nonatomic) NSIndexPath *indexPath;

@end

@implementation WPEditTextView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)setTitle:(NSString *)title placeholder:(NSString *)placeholder style:(NSString *)type
{
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 65, self.height)];
    label.text = title;
    label.font =GetFont(15);
    [self addSubview:label];
    
    if ([type isEqualToString:kCellTypeText]) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(81, 0, self.width-100, self.height)];
        _textField.placeholder = placeholder;
        _textField.font = GetFont(15);
        _textField.returnKeyType = UIReturnKeyDone;
        [self addSubview:_textField];
    }else{
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(81, 0, self.width-100-40, self.height);
        _button.titleLabel.font = GetFont(15);
        [_button setTitle:placeholder forState:UIControlStateNormal];
        [_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_button setTitleColor:RGB(205, 205, 205) forState:UIControlStateNormal];
        [self addSubview:_button];
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"common_icon_arrow"]];
        imageV.frame = CGRectMake(self.width-15-15, self.height/2-7.5, 15,15);
        [self addSubview:imageV];
    }
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height - 0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(226, 226, 226);
    [self addSubview:line];
}

@end
