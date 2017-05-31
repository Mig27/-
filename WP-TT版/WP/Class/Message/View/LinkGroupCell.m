//
//  LinkGroupCell.m
//  WP
//
//  Created by 沈亮亮 on 15/12/24.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "LinkGroupCell.h"
#import "UIImageView+WebCache.h"


@implementation LinkGroupCell

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
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, kHEIGHT(50)/2 - kHEIGHT(32)/2, kHEIGHT(32), kHEIGHT(32))];
    self.icon.layer.cornerRadius = 5;
    self.icon.clipsToBounds = YES;
    [self.contentView addSubview:self.icon];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right + 10, kHEIGHT(50)/2 - 10, SCREEN_WIDTH - kHEIGHT(32) - 80, 20)];
    self.nameLabel.font = kFONT(15);
    [self.contentView addSubview:self.nameLabel];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"linkGroupCellID";
    LinkGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
        cell = [[LinkGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

- (void)setModel:(linkGroupListModel *)model
{
    if ([model.group_icon isKindOfClass:[UIImage class]]) {
        self.icon.image = model.group_icon;
    } else {
        NSString *url = [IPADDRESS stringByAppendingString:model.group_icon];
        [self.icon sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    }
    
    self.nameLabel.text = model.group_name;
}

+ (CGFloat)cellHeight
{
    return kHEIGHT(50);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
