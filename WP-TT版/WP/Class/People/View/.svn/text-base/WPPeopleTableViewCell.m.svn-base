//
//  WPPeopleTableViewCell.m
//  WP
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPeopleTableViewCell.h"

@implementation WPPeopleTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat R  = (CGFloat) 153/255.0;
        CGFloat G = (CGFloat) 153/255.0;
        CGFloat B = (CGFloat) 153/255.0;
        CGFloat alpha = (CGFloat) 1.0;
        
        
        _photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9, 43, 43)];
        _photoImage.image = [UIImage imageNamed:@"near_cell_one"];
        [self addSubview:_photoImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(63, 12, 100, 14)];
        _nameLabel.text = @"范冰冰";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:_nameLabel];
        
        _positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(63, 35, 32, 12)];
        _positionLabel.text = @"经理";
        _positionLabel.textColor = [UIColor colorWithRed:R green:G blue:B alpha:alpha];
        _positionLabel.textAlignment = NSTextAlignmentLeft;
        _positionLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_positionLabel];
        
        _oneImage = [[UIImageView alloc] initWithFrame:CGRectMake(95, 35, 1, 12)];
        _oneImage.image = [UIImage imageNamed:@"短灰色竖线"];
        [self addSubview:_oneImage];
        
        _companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(103, 35, 150, 12)];
        _companyLabel.text = @"莱达商贸有限公司";
        _companyLabel.textColor = [UIColor colorWithRed:R green:G blue:B alpha:alpha];
        _companyLabel.textAlignment = NSTextAlignmentLeft;
        _companyLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_companyLabel];
        
        _location = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 76, 12, 10, 12)];
        _location.image = [UIImage imageNamed:@"地址"];
        [self addSubview:_location];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 60, 12, 50, 12)];
        _locationLabel.text = @"0.1km";
        _locationLabel.textColor = [UIColor colorWithRed:R green:G blue:B alpha:alpha];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_locationLabel];

        
    }
    return self;
}


- (void)awakeFromNib {
    

    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
