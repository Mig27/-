//
//  WPGroupCell.m
//  WP
//
//  Created by 沈亮亮 on 16/4/14.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGroupCell.h"
#import <UIImageView+WebCache.h>

@implementation WPGroupCell

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
    
    CGSize normalSize1 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize normalSize2 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat y = (kHEIGHT(72) - normalSize1.height - normalSize2.height - kHEIGHT(12) - 12)/2;
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(72)/2 - kHEIGHT(54)/2, kHEIGHT(54), kHEIGHT(54))];
    self.iconImage.clipsToBounds = YES;
    self.iconImage.layer.cornerRadius = 5;
    [self.contentView addSubview:self.iconImage];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + kHEIGHT(10), y, SCREEN_WIDTH - 140, normalSize1.height)];
    self.nameLabel.font = kFONT(15);
//    self.nameLabel.backgroundColor =[UIColor redColor];
    [self.contentView addSubview:self.nameLabel];
    
    self.sumBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom + 6, kHEIGHT(28), kHEIGHT(12))];
    self.sumBtn.clipsToBounds = YES;
    self.sumBtn.layer.cornerRadius = 2.5;
    self.sumBtn.titleLabel.font = kFONT(10);
    self.sumBtn.layer.borderColor = RGB(0, 172, 255).CGColor;
    self.sumBtn.layer.borderWidth = 0.5;
    [self.sumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sumBtn setBackgroundColor:RGB(0, 172, 255)];
    [self.sumBtn setImage:[UIImage imageNamed:@"xiaoxi_qunrenshu"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.sumBtn];
    
    self.subLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.sumBtn.bottom + 6, SCREEN_WIDTH - 3*kHEIGHT(10) - kHEIGHT(54), normalSize2.height)];
    self.subLabel.font = kFONT(12);
    self.subLabel.textColor = RGB(127, 127, 127);
    [self.contentView addSubview:self.subLabel];
    
    self.addressImg = [[UIImageView alloc] init];
    self.addressImg.image = [UIImage imageNamed:@"group_address"];
    [self.contentView addSubview:self.addressImg];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.font = kFONT(10);
    self.addressLabel.textColor = RGB(127, 127, 127);
    [self.contentView addSubview:self.addressLabel];
    
    
    self.line = [[UILabel alloc]initWithFrame:CGRectMake(0, kHEIGHT(72)-0.5, SCREEN_WIDTH, 0.5)];
    self.line.backgroundColor = RGB(227, 227, 227);
    [self.contentView addSubview:self.line];
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self.sumBtn setBackgroundColor:RGB(0, 172, 255)];
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self.sumBtn setBackgroundColor:RGB(0, 172, 255)];
}
- (void)setModel:(JobGroupListModel *)model
{
    NSString *url = [IPADDRESS stringByAppendingString:model.group_icon];
    [self.iconImage sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"bc_quntouxiang_geren"]];
    NSString *distance = [NSString stringWithFormat:@"%@km",model.Distance];
    CGSize normalSize2 = [distance sizeWithAttributes:@{NSFontAttributeName:kFONT(10)}];
    self.addressImg.frame = CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - normalSize2.width - 6 - 8, kHEIGHT(10), 8, 12);
    self.addressLabel.frame = CGRectMake(self.addressImg.right + 6, kHEIGHT(10), normalSize2.width, normalSize2.height);
    self.addressLabel.centerY = self.addressImg.centerY;
    self.addressLabel.text = distance;
    self.nameLabel.text = model.group_name;
    [self.sumBtn setTitle:[NSString stringWithFormat:@" %@",model.GroupUserSum] forState:UIControlStateNormal];
    self.subLabel.text = model.group_cont;

}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    WPGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WPGroupCellId"];
    if (!cell) {
        cell = [[WPGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WPGroupCellId"];
    }
    return cell;
}


+ (CGFloat)rowHeight
{
    return kHEIGHT(72);
}



@end
