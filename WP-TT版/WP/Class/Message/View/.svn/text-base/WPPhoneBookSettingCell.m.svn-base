//
//  WPPhoneBookSettingCell.m
//  WP
//
//  Created by Kokia on 16/5/12.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPhoneBookSettingCell.h"

@interface WPPhoneBookSettingCell()


@property (nonatomic, strong) UIImageView *arrowImg;

@end

@implementation WPPhoneBookSettingCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"WPPhoneBookSettingCell";
    WPPhoneBookSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[WPPhoneBookSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.font = kFONT(15);
    self.titleLbl = titleLbl;
    [self.contentView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(16);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    UIImageView *arrowImg = [[UIImageView alloc] init];
    arrowImg.image = [UIImage imageNamed:@"jinru"];
    self.arrowImg = arrowImg;
    [self.contentView addSubview:arrowImg];
    
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-16);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    UILabel * detailLbl = [[UILabel alloc] init];
    detailLbl.font = kFONT(12);
    detailLbl.textColor = RGB(127, 127, 127);
    self.detailLbl = detailLbl;
    [self.contentView addSubview:detailLbl];
    [detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImg.mas_left).with.offset(-8);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
}


@end
