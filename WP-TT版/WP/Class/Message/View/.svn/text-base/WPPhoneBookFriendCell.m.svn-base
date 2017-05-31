//
//  WPPhoneBookFriendCell.m
//  WP
//
//  Created by Kokia on 16/5/10.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPhoneBookFriendCell.h"

@implementation WPPhoneBookFriendCell

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
    static NSString *cellId = @"WPPhoneBookFriendCell";
    WPPhoneBookFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[WPPhoneBookFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

- (void)setModel:(WPFriendListModel *)model
{
    _model = model;
    NSString *url = [IPADDRESS stringByAppendingString:model.avatar];
    [self.icon sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    self.nameLabel.text = model.nick_name;
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
