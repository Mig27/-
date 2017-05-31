//
//  WPMessageAlertCell.m
//  WP
//
//  Created by 沈亮亮 on 16/4/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMessageAlertCell.h"

@implementation WPMessageAlertCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,0, 150, kHEIGHT(43))];
        self.titleLabel.font = kFONT(15);
        [self.contentView addSubview:self.titleLabel];
        
        self.selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 18, kHEIGHT(43)/2 - 9, 18, 18)];
        self.selectBtn.userInteractionEnabled = NO;
        [self.selectBtn setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.selectBtn];
        
    }
    return self;
}

- (void)setTitleString:(NSString *)titleString
{
    self.titleLabel.text = titleString;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    WPMessageAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WPMessageAlertCellId"];
    if (!cell) {
        cell = [[WPMessageAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WPMessageAlertCellId"];
    }
    return cell;
}


+ (CGFloat)rowHeight
{
    return kHEIGHT(43);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
