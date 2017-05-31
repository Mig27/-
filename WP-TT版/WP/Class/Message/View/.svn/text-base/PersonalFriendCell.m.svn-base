//
//  PersonalFriendCell.m
//  WP
//
//  Created by 沈亮亮 on 16/1/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "PersonalFriendCell.h"
#import "UIImageView+WebCache.h"


@implementation PersonalFriendCell

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
    self.addButton.frame = CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - kHEIGHT(36), kHEIGHT(58)/2 - kHEIGHT(18)/2, kHEIGHT(36), kHEIGHT(18));
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"link_attention"] forState:UIControlStateNormal];
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"link_attention_click"] forState:UIControlStateHighlighted];
    [self.addButton addTarget:self action:@selector(attentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.addButton.titleLabel.font = kFONT(12);
    [self.addButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.addButton];
    
}

#pragma 关注按钮点击事件
- (void)attentionBtnClick
{
    NSString *title = [self.addButton titleForState:UIControlStateNormal];
    if (self.opertionAttentionBlock) {
        self.opertionAttentionBlock(self.index,title);
    }
}

- (void)setModel:(PersonalFriendListModel *)model
{
    NSString *url = [IPADDRESS stringByAppendingString:model.avatar];
    [self.iconImage sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    self.nameLabel.text = model.nick_name;
    
    CGSize normalSize2 = [model.position sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    
    self.positionLabel.frame = CGRectMake(self.iconImage.right + 10, self.nameLabel.bottom + 8, normalSize2.width, normalSize2.height);
    self.positionLabel.text = model.position;
    
    self.line.frame = CGRectMake(self.positionLabel.right + 6, self.nameLabel.bottom + 8, 0.5, normalSize2.height);
    
    self.companyLabel.frame = CGRectMake(self.line.right + 6, self.nameLabel.bottom + 8, SCREEN_WIDTH - 120 - normalSize2.width - 13, normalSize2.height);
    self.companyLabel.text = model.company;
    
    if ([model.attention_state isEqualToString:@"0"]) {
//        [self.addButton setBackgroundImage:[UIImage imageNamed:@"link_attention"] forState:UIControlStateNormal];
//        [self.addButton setBackgroundImage:[UIImage imageNamed:@"link_attention_click"] forState:UIControlStateHighlighted];
        [self.addButton setTitle:@"关注" forState:UIControlStateNormal];
//        [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else if ([model.attention_state isEqualToString:@"1"]){
        [self.addButton setTitle:@"已关注" forState:UIControlStateNormal];
//        [self.addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.addButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [self.addButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
//        self.addButton.enabled = NO;
    }else if ([model.attention_state isEqualToString:@"2"]){
        [self.addButton setTitle:@"好友" forState:UIControlStateNormal];
//        [self.addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.addButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [self.addButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
//        self.addButton.enabled = NO;
    }
    
    NSMutableDictionary *dic = kShareModel.dic;
    if ([dic[@"userid"] isEqualToString:model.by_user_id]) {
        self.addButton.hidden = YES;
    }

}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"PersonalFriendCellID";
    PersonalFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
        cell = [[PersonalFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
