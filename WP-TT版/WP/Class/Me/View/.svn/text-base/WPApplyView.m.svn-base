
//
//  WPApplyView.m
//  WP
//
//  Created by CBCCBC on 16/4/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPApplyView.h"

@interface WPApplyView ()

@end

@implementation WPApplyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.companyLabel];
//        self.backgroundColor = RGB(235, 235, 235);
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kHEIGHT(43), kHEIGHT(43))];
        self.imageView.image = [UIImage imageNamed:@""];
//        [self addSubview:self.imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGFloat height = [@"蛋疼不疼" getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH].height;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(43)+10, 3, SCREEN_WIDTH-kHEIGHT(63)-10, height)];
        self.titleLabel.font = kFONT(15);
//        [self addSubview:self.titleLabel];
//        self.titleLabel.text = @"";
    }
    return _titleLabel;
}

- (UILabel *)companyLabel
{
    if (!_companyLabel) {
        CGFloat height = [@"蛋疼不疼" getSizeWithFont:kFONT(12) Width:SCREEN_WIDTH].height;
        self.companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(43)+10, self.titleLabel.bottom+10, SCREEN_WIDTH-kHEIGHT(63)-10, height)];
        self.companyLabel.font = kFONT(12);
        self.companyLabel.textColor = RGB(127, 127, 127);
//        [self addSubview:self.companyLabel];
//        self.companyLabel.text = @"";
    }
    return _companyLabel;
}

 - (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
//    self.titleLabel.textColor = [UIColor redColor];
    
}
- (void)setCompany:(NSString *)company
{
    _company = company;
    self.companyLabel.text = company;
}

- (void)setImage:(NSString *)image
{
    _image = image;
    NSString *string = [IPADDRESS stringByAppendingString:image];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:string]placeholderImage:[UIImage imageNamed:@"head_default"]];
}

@end
