//
//  LocationCell.m
//  WP
//
//  Created by 沈亮亮 on 15/7/30.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "LocationCell.h"
#import "UIViewExt.h"

@implementation LocationCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    
    return self;
}

- (void)createUI
{
    self.nameLabel  = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, SCREEN_WIDTH - 10, 15)];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.nameLabel];
    
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.nameLabel.bottom + 8, SCREEN_WIDTH - 10, 12)];
    self.locationLabel.font = [UIFont systemFontOfSize:12];
    self.locationLabel.textColor = RGBColor(153, 153, 153);
    [self.contentView addSubview:self.locationLabel];
}

- (void)setLocationWith:(NSDictionary *)dic
{
    self.nameLabel.text = dic[@"name"];
    self.locationLabel.text = dic[@"address"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
