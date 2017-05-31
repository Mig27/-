//
//  WPAddMePersonCell.m
//  WP
//
//  Created by Kokia on 16/5/16.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPAddMePersonCell.h"

@interface WPAddMePersonCell()

@property (nonatomic,strong) UILabel *titleLabel; //新的好友
@property (nonatomic,strong) UIImageView *icon;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *descLabel;

@end

@implementation WPAddMePersonCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"WPAddMePersonCell";
    WPAddMePersonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[WPAddMePersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
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
        //新的好友
        UILabel * titleLbl = [[UILabel alloc] init];
        titleLbl.font = kFONT(12);
        self.titleLabel = titleLbl;
        titleLbl.text = @"新的好友";
        titleLbl.textColor = RGB(127, 127, 127);
        [self.contentView addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(kHEIGHT(10));
            make.top.equalTo(self.contentView.mas_top).with.offset(6);
        }];
        
        //加我为好友的人头像
        UIImageView *icon = [[UIImageView alloc] init];
        self.icon = icon;
        icon.layer.masksToBounds = YES;
        icon.layer.cornerRadius = 5;
        [self.contentView addSubview:icon];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(kHEIGHT(10));
            make.top.equalTo(titleLbl.mas_bottom).with.offset(6);
            make.width.equalTo(@(kHEIGHT(40)));
            make.height.equalTo(@(kHEIGHT(40)));
        }];
        
        // 加我为好友的姓名
        UILabel * nameLabel = [[UILabel alloc] init];
        nameLabel.font = kFONT(15);
        nameLabel.textColor = [UIColor blackColor];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).with.offset(kHEIGHT(10));
            make.top.equalTo(icon.mas_top).with.offset(4);
        }];
        
        UILabel * descLabel = [[UILabel alloc] init];
        descLabel.font = kFONT(12);
        descLabel.textColor = RGB(127, 127, 127);
        self.descLabel = descLabel;
        descLabel.text = @"请求添加你为好友";
        [self.contentView addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_left);
            make.top.equalTo(nameLabel.mas_bottom).with.offset(8);
        }];
        
        WPBadgeButton *badgeButton = [[WPBadgeButton alloc] init];
        badgeButton.badgeValue = @"1";
        badgeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:badgeButton];
        self.badgeButton = badgeButton;
        [badgeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-kHEIGHT(10));
            make.centerY.equalTo(self.contentView);
        }];
}

-(void)setModel:(WPToAddListFriendModel *)model{
    _model = model;
     NSString *url = [IPADDRESS stringByAppendingString:model.avatar];
    [self.icon sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    self.nameLabel.text = model.nick_name;
    if (model.fremark.length == 0 || model.fremark == nil) {
        self.descLabel.text = @"请求添加你为好友";
    }else{
        self.descLabel.text = model.fremark;
    }
}


@end
