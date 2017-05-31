//
//  WPCompanyPositionCell.m
//  WP
//
//  Created by CBCCBC on 16/3/30.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPCompanyPositionCell.h"
#import "SPLabel.h"

#define CellHeight kHEIGHT(58)

@interface WPCompanyPositionCell ()
@property (nonatomic ,strong)UIImageView *iconImageView;
@property (nonatomic ,strong)UILabel *positionLabel;
@property (nonatomic ,strong)UILabel *companyLabel;
@property (nonatomic ,strong)UILabel *against;
@property (nonatomic ,strong)UIImageView *tagView;
@property (nonatomic ,strong)UILabel *timeLabel;
@end
@implementation WPCompanyPositionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.positionLabel];
        [self.contentView addSubview:self.companyLabel];
        [self.contentView addSubview:self.against];
        [self.contentView addSubview:self.tagView];
        [self.contentView addSubview:self.timeLabel];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, CellHeight-0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [self.contentView addSubview:line];
    }
    return self;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10),(CellHeight-kHEIGHT(43))/2, kHEIGHT(43), kHEIGHT(43))];
//        self.iconImageView.image = [UIImage imageNamed:@"head_default"];
        self.iconImageView.layer.cornerRadius = 5;
        self.iconImageView.clipsToBounds = YES;
        self.iconImageView.layer.borderColor = RGB(226, 226, 226).CGColor;
        self.iconImageView.layer.borderWidth = 0.5;
    }
    return _iconImageView;
}

- (UILabel *)positionLabel
{
    if (!_positionLabel) {
        self.positionLabel = [[SPLabel alloc]initWithFrame:CGRectMake(self.iconImageView.right+10, self.iconImageView.top, SCREEN_WIDTH-120, self.iconImageView.height/2)];
        self.positionLabel.text = @"招聘：快递员 分类员";
        self.positionLabel.font = kFONT(15);
    }
    return _positionLabel;
}

- (UILabel *)companyLabel
{
    if (!_companyLabel) {
        self.companyLabel = [[SPLabel alloc]initWithFrame:CGRectMake(self.iconImageView.right+10, self.positionLabel.bottom+8, SCREEN_WIDTH-200, 15)];
        self.companyLabel.font = kFONT(12);
        self.companyLabel.text = @"合肥莱达商贸有限公司";
        self.companyLabel.textColor = RGB(153, 153, 153);
    }
    return _companyLabel;
}

- (UIImageView *)tagView
{
    if (!_tagView) {
        self.tagView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-8, CellHeight/2-7, 8, 14)];
        self.tagView.image = [UIImage imageNamed:@"jinru"];
    }
    return _tagView;
}

- (UILabel *)against
{
    if (!_against) {
        self.against = [[UILabel alloc]initWithFrame:CGRectMake(self.tagView.left-28-4, CellHeight/2-7.5, 28, 14)];
        self.against.textColor = [UIColor whiteColor];
        self.against.textAlignment = NSTextAlignmentCenter;
        self.against.backgroundColor = RGB(0, 172, 225);
        self.against.layer.cornerRadius = 7;
        self.against.layer.masksToBounds = YES;
        self.against.text = @"申请";
        self.against.font = [UIFont systemFontOfSize:11];
    }
    return _against;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        self.timeLabel = [[SPLabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60-kHEIGHT(10), _against.bottom+3, 60, 15)];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.textColor = RGB(153, 153, 153);
        self.timeLabel.font = kFONT(10);
        self.timeLabel.text = @"17分钟前";
    }
    return _timeLabel;
}

- (void)setModel:(WPPositionModel *)model
{
    _model = model;
    NSString *url = [IPADDRESS stringByAppendingString:model.logo];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    self.positionLabel.text = model.jobPositon;
    self.companyLabel.text = model.enterprise_name;
    self.timeLabel.text = model.update_Time;
}

@end
