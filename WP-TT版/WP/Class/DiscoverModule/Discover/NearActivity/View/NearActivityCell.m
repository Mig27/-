//
//  NearActivityCell.m
//  WP
//
//  Created by 沈亮亮 on 15/10/9.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "NearActivityCell.h"
#import "UIImageView+WebCache.h"

@implementation NearActivityCell

- (void)awakeFromNib {
    // Initialization code
    self.iconImage.layer.cornerRadius = 5;
    self.iconImage.clipsToBounds = YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"NearActivityCellId";
    NearActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
    }
    
    return cell;
}

- (void)setModel:(NearActivityListModel *)model
{
    NSString *url = [IPADDRESS stringByAppendingString:model.show_img];
    [self.iconImage sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    self.titleLabel.text = model.title;
    self.addresLabel.text = model.address_2;
    self.timeLabel.text = model.bigen_time;
    self.numberLabel.text = [NSString stringWithFormat:@"%@人",model.sign];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
