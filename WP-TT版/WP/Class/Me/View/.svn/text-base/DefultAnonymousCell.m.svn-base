//
//  DefultAnonymousCell.m
//  WP
//
//  Created by CBCCBC on 16/3/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "DefultAnonymousCell.h"
@interface DefultAnonymousCell ()
@property (nonatomic ,strong)UIImageView *imageview;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *professional;
@property (nonatomic, strong)UILabel *defultLabel;
@property (nonatomic, strong)UILabel *anonyLabel;
@property (nonatomic, strong)UIView *line;
@end

@implementation DefultAnonymousCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.imageview];
        [self addSubview:self.nameLabel];
        [self addSubview:self.defultLabel];
        [self addSubview:self.anonyLabel];
        [self addSubview:self.button];
        
    }
    return self;
}

- (UIButton *)button
{
    if (!_button) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button .frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(20)-18, 0, kHEIGHT(20)+18, kHEIGHT(58));
        [self.button setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
        self.button.userInteractionEnabled = NO;
    }
    return _button;
}

- (void)setModel:(AnonymousModel *)model
{
    _model = model;
    NSString *url;
    if (model.photo) {
        url = [IPADDRESS stringByAppendingString:model.photo];
    }
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:url]placeholderImage:[UIImage imageNamed:@"head_default"]];
    self.nameLabel.text = model.name;
    CGSize normalSize2 = [_model.postionName sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat y = self.nameLabel.origin.y + self.nameLabel.size.height + 5;
    self.anonyLabel.frame = CGRectMake(self.nameLabel.origin.x, y, normalSize2.width, normalSize2.height);
    self.anonyLabel.text = model.postionName;
    [self.defultLabel removeFromSuperview];
    self.button.selected = model.selected;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.anonyLabel.right+6, self.anonyLabel.origin.y, 1, kHEIGHT(12))];
    view.center = CGPointMake(self.anonyLabel.right+6, self.anonyLabel.origin.y+self.anonyLabel.size.height/2);
    self.line = view;
    [self addSubview:view];
    [self addSubview:self.professional];
    view.backgroundColor = RGB(226,226,226);
    
    
}

- (CGRect)giveMeHeightWithText:(NSString *)text size:(CGSize)size font:(UIFont *)font
{
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect;
}

- (UIImageView *)imageview
{
    if (!_imageview) {
        self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(7.5), kHEIGHT(43), kHEIGHT(43))];
        self.imageview.layer.cornerRadius = 5;
        self.imageview.layer.masksToBounds = YES;
        self.imageview.image = [UIImage imageNamed:@"图层 14"];
    }
    return _imageview;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imageview.right+kHEIGHT(10), kHEIGHT(11), kHEIGHT(55), kHEIGHT(18))];
        self.nameLabel.font = kFONT(15);
        self.nameLabel.text = @"诸葛亮";
    }
    return _nameLabel;
}

- (UILabel *)defultLabel
{
    if (!_defultLabel) {
        self.defultLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.right, self.nameLabel.origin.y, kHEIGHT(90), kHEIGHT(18))];
        self.defultLabel.font = kFONT(15);
        self.defultLabel.textColor = RGB(127, 127, 127);
        self.defultLabel.text = @"(系统默认)";
    }
    return _defultLabel;
}

- (UILabel *)anonyLabel
{
    if (!_anonyLabel) {
//        CGFloat y = self.nameLabel.origin.y + self.nameLabel.size.height + 5;
        self.anonyLabel = [[UILabel alloc]init];
        self.anonyLabel.font = kFONT(12);
        self.anonyLabel.text = @"军师兼丞相";
        self.anonyLabel.textColor = RGB(127, 127, 127);
//        CGRect rect = [self giveMeHeightWithText:_model.postionName size:CGSizeMake(kHEIGHT(25), 0) font:kFONT(12)];
//        self.anonyLabel.frame = CGRectMake(self.nameLabel.origin.x, y, kHEIGHT(25), rect.size.height);
    }
    return _anonyLabel;
}

- (UILabel *)professional
{
    if (!_professional) {
        self.professional = [[UILabel alloc]initWithFrame:CGRectMake(self.anonyLabel.right+12, self.anonyLabel.origin.y, kHEIGHT(100), self.anonyLabel.size.height)];
        self.professional.font = kFONT(12);
        self.professional.textColor = RGB(127, 127, 127);
        self.professional.text = @"匿名";
    }
    return _professional;
}

@end
