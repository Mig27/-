//
//  WPPhoneBookFriendCategoryCell.m
//  WP
//
//  Created by Kokia on 16/5/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPhoneBookFriendCategoryCell.h"

@interface WPPhoneBookFriendCategoryCell()<UITextFieldDelegate>
@property (nonatomic,strong)UIButton *button;

@end

@implementation WPPhoneBookFriendCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.button];
        [self.contentView addSubview:self.titleLabel];
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
    sender.selected = !sender.selected;
    self.model.selected = sender.selected;
}

- (void)setModel:(WPPhoneBookFriendCategoryModel *)model
{
    _model = model;
    self.title = model.typename;
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
        [self.delegate editTypeId:_model.id andeditValue:textField.text];
    }
}




@end
