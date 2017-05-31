
//
//  WPCollectTypeCell.m
//  WP
//
//  Created by CBCCBC on 16/4/7.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPCollectTypeCell.h"

@interface WPCollectTypeCell ()<UITextFieldDelegate>
@property (nonatomic , strong)UIButton *button;

@end

@implementation WPCollectTypeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.button];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel addTarget:self action:@selector(textfileValueChange) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)setNeedSelect:(BOOL)needSelect
{
    _needSelect = needSelect;
    self.titleLabel.enabled = needSelect;
    
    if (needSelect) {
        self.button.frame = CGRectMake(0, 0, 38, kHEIGHT(43));
        if (self.title) {
            self.title = self.title;
        }
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
    if (_needSelect) {
        self.titleLabel.frame = CGRectMake(self.button.right, 0, SCREEN_WIDTH-self.button.right, kHEIGHT(43));
    }else{
        self.titleLabel.frame = CGRectMake(16, 0, SCREEN_WIDTH - self.button.right, kHEIGHT(43));
    }
    
}

- (UIButton *)button
{
    if (!_button) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
        [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)buttonAction:(UIButton *)sender
{
    [self.superview endEditing:YES];
    sender.selected = !sender.selected;
    self.model.selected = sender.selected;
    self.checkboxBlock();
    
}

- (void)setModel:(CollectTypeModel *)model
{
    _model = model;
    self.title = model.type_name;
    self.button.selected = model.selected;
}

- (UITextField *)titleLabel
{
    if (!_titleLabel) {
        self.titleLabel = [[UITextField alloc]init];
        self.titleLabel.delegate = self;
        self.titleLabel.font = kFONT(15);
        self.titleLabel.enabled = NO;
    }
    return _titleLabel;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(editTypeId:andeditValue:)]) {
        [self.delegate editTypeId:_model.type_id andeditValue:textField.text];
    }
    
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if ([self.delegate respondsToSelector:@selector(editTypeId:andeditValue:)]) {
//        [self.delegate editTypeId:_model.type_id andeditValue:[NSString stringWithFormat:@"%@%@",textField.text,string]];
//    }
//    return YES;
//}
-(void)textfileValueChange
{
    if ([self.delegate respondsToSelector:@selector(editTypeId:andeditValue:)]) {
        [self.delegate editTypeId:_model.type_id andeditValue:self.titleLabel.text];
    }
}
@end
