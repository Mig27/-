//
//  RelevanceGroupCell.m
//  WP
//
//  Created by 沈亮亮 on 15/10/22.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "RelevanceGroupCell.h"
#import "UIButton+WebCache.h"


@implementation RelevanceGroupCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    
    return self;
}

- (void)createUI
{
    CGFloat height = kHEIGHT(72);
    CGFloat iconHeight = kHEIGHT(54);
    self.iconBtn = [[WPButton alloc] initWithFrame:CGRectMake(10, (height - iconHeight)/2, iconHeight, iconHeight)];
    self.iconBtn.layer.cornerRadius = 5;
    self.iconBtn.clipsToBounds = YES;
    [self.contentView addSubview:self.iconBtn];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, self.iconBtn.top, SCREEN_WIDTH - 100, 17)];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = kFONT(15);
    [self.contentView addSubview:self.titleLabel];
    
    self.numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.numberBtn.frame = CGRectMake(self.iconBtn.right + 10, self.titleLabel.bottom + kHEIGHT(6),24, kHEIGHT(10));
    [self.numberBtn setImage:[UIImage imageNamed:@"group_num"] forState:UIControlStateNormal];
    self.numberBtn.layer.cornerRadius = 2;
    self.numberBtn.clipsToBounds = YES;
    self.numberBtn.layer.borderWidth = 0.5;
    self.numberBtn.layer.borderColor = RGB(226, 226, 226).CGColor;
    self.numberBtn.titleLabel.font = kFONT(10);
    [self.numberBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    [self.contentView addSubview:self.numberBtn];
    
    self.descripLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, self.numberBtn.bottom + kHEIGHT(6), SCREEN_WIDTH - 100, kHEIGHT(12))];
    self.descripLabel.textColor = RGB(153, 153, 153);
    self.descripLabel.font = kFONT(12);
    [self.contentView addSubview:self.descripLabel];
}

- (void)setModel:(RelevanceGroupListModel *)model
{
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.group_icon]];
    [self.iconBtn sd_setImageWithURL:url forState:UIControlStateNormal];
    self.titleLabel.text = model.group_name;
    [self.numberBtn setTitle:[NSString stringWithFormat:@" %@",model.GroupUserSum] forState:UIControlStateNormal];
    self.descripLabel.text = model.group_cont;
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"RelevanceGroupCell";
    RelevanceGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[RelevanceGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

+(CGFloat)height
{
    return kHEIGHT(76);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
