//
//  WPPeopleConnectionTableViewCell.m
//  WP
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPeopleWorkTableViewCell.h"

@implementation WPPeopleWorkTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat R  = (CGFloat) 153/255.0;
        CGFloat G = (CGFloat) 153/255.0;
        CGFloat B = (CGFloat) 153/255.0;
        CGFloat alpha = (CGFloat) 1.0;
        
        
        _photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9, 54, 54)];
        _photoImage.image = [UIImage imageNamed:@"near_cell_one"];
        [self addSubview:_photoImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(74, 13, 100, 14)];
        _nameLabel.text = @"范冰冰";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:_nameLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(74, 32, 36, 12)];
        _numLabel.text = @"273";
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.textColor = [UIColor colorWithRed:R green:G blue:B alpha:alpha];
        _numLabel.font = [UIFont systemFontOfSize:12.0];
        _numLabel.backgroundColor = [UIColor clearColor];
        _numLabel.layer.borderColor = [UIColor colorWithRed:R green:G blue:B alpha:alpha].CGColor;
        _numLabel.layer.cornerRadius = 3.0;
        _numLabel.layer.borderWidth = 0.5;
        [self addSubview:_numLabel];
        
        _numImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 1, 10, 10)];
        _numImage.image = [UIImage imageNamed:@"人数"];
        [_numLabel addSubview:_numImage];

        _positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(74, 49, 200, 12)];
        _positionLabel.text = @"行业交流群，共同分享学习。";
        _positionLabel.textColor = [UIColor colorWithRed:R green:G blue:B alpha:alpha];
        _positionLabel.textAlignment = NSTextAlignmentLeft;
        _positionLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_positionLabel];

        
        _location = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 76, 49, 10, 12)];
        _location.image = [UIImage imageNamed:@"地址"];
        [self addSubview:_location];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 60, 49, 50, 12)];
        _locationLabel.text = @"0.1km";
        _locationLabel.textColor = [UIColor colorWithRed:R green:G blue:B alpha:alpha];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_locationLabel];
        
        
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
