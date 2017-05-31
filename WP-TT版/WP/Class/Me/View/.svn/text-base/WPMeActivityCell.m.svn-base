//
//  WPMeActivityCell.m
//  WP
//
//  Created by CBCCBC on 16/1/8.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMeActivityCell.h"
#import "WPMeActivityModel.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface WPMeActivityCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation WPMeActivityCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithSubViews];
    }
    return self;
}

- (void)initWithSubViews{
    
    _headImageView = [UIImageView new];
    _headImageView.layer.cornerRadius = 5;
    _headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(kHEIGHT(10));
        make.width.height.equalTo(@(50));
    }];
    
    _titleLabel = [UILabel new];
    _addressLabel = [UILabel new];
    _timeLabel = [UILabel new];
    
    _timeLabel.font = kFONT(12);
    _timeLabel.textColor = RGB(178, 178, 178);
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(kHEIGHT(10));
        make.right.equalTo(self.contentView).offset(-kHEIGHT(10));
        make.bottom.equalTo(_headImageView.mas_bottom);
        make.height.equalTo(@(15));
    }];
    
    _addressLabel.font = kFONT(12);
    _addressLabel.textColor = RGB(178, 178, 178);
    [self.contentView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_timeLabel);
        make.height.equalTo(@(15));
        make.bottom.equalTo(_timeLabel.mas_top);
    }];
    
    _titleLabel.font = kFONT(15);
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView);
        make.left.right.equalTo(_timeLabel);
        make.bottom.equalTo(_addressLabel.mas_top);
    }];
}

- (void)setModel:(WPMeActivityListModel *)model{
    
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.show_img]];
    [_headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    _titleLabel.text = model.title;
    
    _addressLabel.text = model.address;
    
    _timeLabel.text = model.bigen_time;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
