//
//  WPDragIntoBlackListCell.m
//  WP
//
//  Created by Kokia on 16/5/12.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPDragIntoBlackListCell.h"

@implementation WPDragIntoBlackListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"WPDragIntoBlackListCell";
    WPDragIntoBlackListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[WPDragIntoBlackListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
    
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:cover];
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.width.equalTo(@120);
        make.height.equalTo(@(kHEIGHT(50)));
    }];
    
    

}

-(void)coverClick{
    if ([self.delegate respondsToSelector:@selector(WPDragIntoBlackListCellDidClickedCoverBtn:)]) {
        [self.delegate WPDragIntoBlackListCellDidClickedCoverBtn:self];
    }
}

@end
