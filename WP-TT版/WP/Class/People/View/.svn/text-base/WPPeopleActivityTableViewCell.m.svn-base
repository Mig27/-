//
//  WPPeopleActivityTableViewCell.m
//  WP
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPeopleActivityTableViewCell.h"

@implementation WPPeopleActivityTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12.5, 85, 85)];
        _photoImage.image = [UIImage imageNamed:@"near_cell_one"];
        [self addSubview:_photoImage];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 15, kScreenW - 115, 38)];
        _titleLabel.text = @"合肥范冰冰粉丝社区2015年首次聚会，相约6月！";
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:_titleLabel];
        
        _locationImage = [[UIImageView alloc] initWithFrame:CGRectMake(105, 63, 12, 12)];
        _locationImage.image = [UIImage imageNamed:@"附近的活动地点"];
        [self addSubview:_locationImage];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 63, 150, 12)];
        _locationLabel.text = @"香溪酒店";
        _locationLabel.textColor = RGBColor(153, 153, 153);
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_locationLabel];
        
        _timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(105, 83, 12, 12)];
        _timeImage.image = [UIImage imageNamed:@"时间"];
        [self addSubview:_timeImage];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 83, 150, 12)];
        _timeLabel.text = @"周六 05-30 19:00";
        _timeLabel.textColor = RGBColor(153, 153, 153);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_timeLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 90, 80, 50, 14)];
        _numLabel.text = @"120人";
        _numLabel.textColor = RGBColor(255, 0, 0);
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [self addSubview:_numLabel];
        
        _baomingLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 40, 83, 30, 12)];
        _baomingLabel.text = @"报名";
        _baomingLabel.textColor = RGBColor(153, 153, 153);
        _baomingLabel.textAlignment = NSTextAlignmentLeft;
        _baomingLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_baomingLabel];
        

        
        
    }
    return self;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
