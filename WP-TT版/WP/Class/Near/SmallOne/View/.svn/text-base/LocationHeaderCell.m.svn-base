//
//  LocationHeaderCell.m
//  WP
//
//  Created by 沈亮亮 on 16/5/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "LocationHeaderCell.h"

@implementation LocationHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), 0, 200, kHEIGHT(58))];
        self.titleLabel.font = kFONT(15);
        self.titleLabel.textColor = RGB(0, 172, 255);//AttributedColor
        self.titleLabel.text = @"不显示位置";
//        self.titleLabel.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"LocationHeaderCellID";
    LocationHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
        cell = [[LocationHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
