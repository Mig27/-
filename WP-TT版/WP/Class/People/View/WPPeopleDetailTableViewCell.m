//
//  WPPeopleDetailTableViewCell.m
//  WP
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPeopleDetailTableViewCell.h"

@implementation WPPeopleDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

        _photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12.5, 18, 18)];
        [self addSubview:_photoImage];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 0, 60, 43)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = RGBColor(153, 153, 153);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(113, 0, kScreenW-113, 43)];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_contentLabel];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-150, 0, 120, 43)];
        _commentLabel.textAlignment = NSTextAlignmentRight;
        _commentLabel.font = [UIFont systemFontOfSize:12];
        _commentLabel.textColor = RGBColor(170, 170, 170);
        [self addSubview:_commentLabel];
        
        _arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 20, 15, 10, 13)];
        _arrowImage.image = [UIImage imageNamed:@"选择"];
        [self addSubview:_arrowImage];
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
