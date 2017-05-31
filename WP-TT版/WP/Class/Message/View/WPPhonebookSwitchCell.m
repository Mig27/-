//
//  WPPhonebookSwitchCell.m
//  WP
//
//  Created by Kokia on 16/5/24.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPhonebookSwitchCell.h"

@implementation WPPhonebookSwitchCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"WPPhonebookSwitchCell";
    WPPhonebookSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[WPPhonebookSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
    
    UISwitch *switchView = [[UISwitch alloc] init];
    self.switchView = switchView;
    switchView.onTintColor = RGB(0, 172, 255);
    [self.contentView addSubview:switchView];
    
    [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-16);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
}

@end
