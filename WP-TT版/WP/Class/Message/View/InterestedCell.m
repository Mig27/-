//
//  InterestedCell.m
//  WP
//
//  Created by 沈亮亮 on 15/12/28.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "InterestedCell.h"
#import "UIImageView+WebCache.h"


@implementation InterestedCell

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
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(58)/2 - kHEIGHT(43)/2, kHEIGHT(43), kHEIGHT(43))];
    self.iconImage.layer.cornerRadius = 5;
    self.iconImage.clipsToBounds = YES;
    [self.contentView addSubview:self.iconImage];
    
    CGSize normalSize1 = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize normalSize2 = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat y = (kHEIGHT(58) - normalSize1.height - normalSize2.height - 8)/2;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + 10, y, SCREEN_WIDTH - 120, normalSize1.height)];
    self.nameLabel.font = kFONT(15);
    [self.contentView addSubview:self.nameLabel];
    
    self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + 10, self.nameLabel.bottom + 8, 40, normalSize2.height)];
    self.positionLabel.font = kFONT(12);
    self.positionLabel.textColor = RGB(153, 153, 153);
    [self.contentView addSubview:self.positionLabel];
    
    self.line = [[UILabel alloc] initWithFrame:CGRectMake(self.positionLabel.right + 6, self.nameLabel.bottom + 8, 0.5, normalSize2.height)];
    self.line.backgroundColor = RGB(153, 153, 153);
    [self.contentView addSubview:self.line];
    
    self.companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.line.right + 6, self.nameLabel.bottom + 8, 120, normalSize2.height)];
    self.companyLabel.font = kFONT(12);
    self.companyLabel.textColor = RGB(153, 153, 153);
    [self.contentView addSubview:self.companyLabel];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.frame = CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - kHEIGHT(32), y, kHEIGHT(32), kHEIGHT(18));
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"link_attention"] forState:UIControlStateNormal];
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"link_attention_click"] forState:UIControlStateHighlighted];
    self.addButton.titleLabel.font = GetFont(12);
    [self.addButton addTarget:self action:@selector(attentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.addButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.addButton];
    
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.font = kFONT(10);
    [self.contentView addSubview:self.distanceLabel];
    
    self.addressImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.distanceLabel.left - 16, self.distanceLabel.bottom - 13, 10, 13)];
    self.addressImageV.image = [UIImage imageNamed:@"small_address"];
    [self.contentView addSubview:self.addressImageV];

}

#pragma 关注按钮点击事件
- (void)attentionBtnClick
{
    NSString *title = [self.addButton titleForState:UIControlStateNormal];
    if (self.opertionAttentionBlock) {
        self.opertionAttentionBlock(self.index,title);
    }
}

- (void)setModel:(InterestedListModel *)model
{
    NSString *url = [IPADDRESS stringByAppendingString:model.avatar];
    [self.iconImage sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    self.nameLabel.text = model.name;
    
    CGSize normalSize2 = [model.position sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    
    self.positionLabel.frame = CGRectMake(self.iconImage.right + 10, self.nameLabel.bottom + 8, normalSize2.width, normalSize2.height);
    self.positionLabel.text = model.position;
    
    self.line.frame = CGRectMake(self.positionLabel.right + 6, self.nameLabel.bottom + 8, 0.5, normalSize2.height);
    
    self.companyLabel.frame = CGRectMake(self.line.right + 6, self.nameLabel.bottom + 8, SCREEN_WIDTH - 120 - normalSize2.width - 13, normalSize2.height);
    self.companyLabel.text = model.company;
    
    NSString *distance = [NSString stringWithFormat:@"%@km",model.Distance];
    CGSize normalSize3 = [distance sizeWithAttributes:@{NSFontAttributeName:kFONT(10)}];
    
    self.distanceLabel.frame = CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - normalSize3.width, self.companyLabel.bottom - normalSize3.height, normalSize3.width, normalSize3.height);
    self.distanceLabel.text = distance;
    
    self.addressImageV.frame = CGRectMake(self.distanceLabel.left - 16, self.companyLabel.bottom - 12, 10, 12);
    if ([model.isatt isEqualToString:@"0"]) {
        [self.addButton setTitle:@"关注" forState:UIControlStateNormal];
    } else if ([model.isatt isEqualToString:@"1"]){
        [self.addButton setTitle:@"已关注" forState:UIControlStateNormal];
    }else if ([model.isatt isEqualToString:@"2"]){
        [self.addButton setTitle:@"好友" forState:UIControlStateNormal];
    }


}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"InterestedCellID";
    InterestedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
        cell = [[InterestedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

+ (CGFloat)cellHeight
{
    return kHEIGHT(58);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
