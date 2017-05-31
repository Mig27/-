//
//  WPApplyListCell.m
//  WP
//
//  Created by CBCCBC on 16/4/12.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPApplyListCell.h"

@interface WPApplyListCell ()
@property (nonatomic ,strong)UILabel *timeLabel;
@property (nonatomic ,strong)UIImageView *headImage;
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UILabel *nameLabel;
@end

@implementation WPApplyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.font = kFONT(10);
        self.timeLabel.backgroundColor = RGB(226, 226, 226);
    }
    return _timeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
