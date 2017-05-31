//
//  WPRefreshCell.m
//  WP
//
//  Created by CBCCBC on 16/4/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPRefreshCell.h"
@interface WPRefreshCell ()
@property (nonatomic , strong)UILabel *timeLabel;
@property (nonatomic ,strong)UILabel *refreshLabel;

@end
@implementation WPRefreshCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UILabel *)refreshLabel
{
    if (!_refreshLabel) {
        self.refreshLabel = [[UILabel alloc]init];
        self.refreshLabel.font = kFONT(15);
    }
    return _refreshLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.font = kFONT(12);
        self.timeLabel.textColor = RGB(127, 127, 127);
    }
    return _timeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.refreshLabel];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kHEIGHT(43)-0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setModel:(WPSetRefreshModel *)model
{
    _model = model;
    self.refreshLabel.text = model.refresh_time;
    CGSize size = [model.refresh_time getSizeWithFont:FUCKFONT(15) Height:kHEIGHT(43)];
    self.refreshLabel.frame = CGRectMake(16, 0, size.width, kHEIGHT(43));
    self.timeLabel.text = model.remark;
    size = [model.remark getSizeWithFont:FUCKFONT(12) Height:kHEIGHT(43)];
    self.timeLabel.frame = CGRectMake(SCREEN_WIDTH-16-size.width, 0, size.width, kHEIGHT(43));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
