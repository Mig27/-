//
//  WPPeopleInviteTableViewCell.m
//  WP
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPeopleInviteTableViewCell.h"

@implementation WPPeopleInviteTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 43, 43)];
        _photoImage.image = [UIImage imageNamed:@"near_cell_one"];
        _photoImage.layer.cornerRadius = 10;
        [self addSubview:_photoImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(63, 12, 150, 14)];
        _nameLabel.text = @"范冰冰";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:_nameLabel];
        
        _kindLabel = [[UILabel alloc] initWithFrame:CGRectMake(63, 34, 150, 12)];
        _kindLabel.text = @"手机通讯录";
        _kindLabel.textAlignment = NSTextAlignmentLeft;
        _kindLabel.textColor = RGBColor(153, 153, 153);
        _kindLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_kindLabel];
        
        _inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - 52, 19, 42, 20)];
        [_inviteButton setTitle:@"邀请" forState:UIControlStateNormal];
        _inviteButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_inviteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_inviteButton setBackgroundImage:[UIImage imageNamed:@"邀请按钮"] forState:UIControlStateNormal];
        [_inviteButton setBackgroundImage:[UIImage imageNamed:@"邀请按钮"] forState:UIControlStateHighlighted];
        [self addSubview:_inviteButton];
        
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
