//
//  WPPhoneBookContactCell.m
//  WP
//
//  Created by Kokia on 16/5/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPhoneBookContactCell.h"

@interface WPPhoneBookContactCell()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;



@end

@implementation WPPhoneBookContactCell

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
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, 38, kHEIGHT(43));
    [self.button setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
    self.button.userInteractionEnabled = NO;
    [self.contentView addSubview:self.button];
    

    UIImageView *icon =[[UIImageView alloc] init];
    icon.frame = CGRectMake(self.button.right, 0, kHEIGHT(32), kHEIGHT(32));
    self.icon = icon;
    self.icon.layer.cornerRadius = 5;
    self.icon.clipsToBounds = YES;
    [self.contentView addSubview:self.icon];
    
    [self.icon  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.button.mas_right);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@(kHEIGHT(32)));
        make.width.equalTo(@(kHEIGHT(32)));
    }];
    
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = kFONT(15);
    [self.contentView addSubview:self.nameLabel];
    
    
    [self.nameLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).with.offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@(SCREEN_WIDTH - kHEIGHT(32) - 80));
        make.height.equalTo(@20);
    }];
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"WPPhoneBookContactCell";
    WPPhoneBookContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[WPPhoneBookContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}


-(void)setContactModel:(WPPhoneBookContactDetailModel *)contactModel{
    _contactModel= contactModel;
    self.button.selected = contactModel.selected;
    NSString *url = [IPADDRESS stringByAppendingString:contactModel.avatar];
    [self.icon sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    self.nameLabel.text = contactModel.nick_name;

}
-(void)model:(WPPhoneBookContactDetailModel*)model selected:(NSString*)userID
{
    NSArray * array = [userID componentsSeparatedByString:@","];
    BOOL isOrNot = [array containsObject:model.user_id];
    if (isOrNot)
    {
        [self.button setImage:[UIImage imageNamed:@"group_enable"] forState:UIControlStateNormal];
        self.button.userInteractionEnabled = NO;
    }
    else
    {
        [self.button setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
        self.button.selected = model.selected;
        self.button.userInteractionEnabled = YES;
    }
}

@end
