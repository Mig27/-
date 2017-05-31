//
//  WPAddMePeopleCell.m
//  WP
//
//  Created by Kokia on 16/5/16.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPAddMePeopleCell.h"

@interface WPAddMePeopleCell()

@property (nonatomic,strong) UILabel *titleLabel; //新的好友
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UIImageView *icon2;
@property (nonatomic,strong) UIImageView *icon3;
@property (nonatomic,strong) UIImageView *icon4;
@property (nonatomic,strong) UIImageView *icon5;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *descLabel;

@end

@implementation WPAddMePeopleCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"WPAddMePeopleCell";
    WPAddMePeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[WPAddMePeopleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createNewUI];
    }
    return self;
}

- (void)createNewUI{
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
    
    UIImageView *icon2 = [[UIImageView alloc] init];
    self.icon2 = icon2;
    icon2.layer.masksToBounds = YES;
    icon2.layer.cornerRadius = 5;
    [self.contentView addSubview:icon2];
    
    [icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).with.offset(kHEIGHT(8));
        make.top.equalTo(titleLbl.mas_bottom).with.offset(6);
        make.width.equalTo(@(kHEIGHT(40)));
        make.height.equalTo(@(kHEIGHT(40)));
    }];
    
    UIImageView *icon3 = [[UIImageView alloc] init];
    self.icon3 = icon3;
    icon3.layer.masksToBounds = YES;
    icon3.layer.cornerRadius = 5;
    [self.contentView addSubview:icon3];
    
    [icon3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon2.mas_right).with.offset(kHEIGHT(8));
        make.top.equalTo(titleLbl.mas_bottom).with.offset(6);
        make.width.equalTo(@(kHEIGHT(40)));
        make.height.equalTo(@(kHEIGHT(40)));
    }];
    
    UIImageView *icon4 = [[UIImageView alloc] init];
    self.icon4 = icon4;
    icon4.layer.masksToBounds = YES;
    icon4.layer.cornerRadius = 5;
    [self.contentView addSubview:icon4];
    
    [icon4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon3.mas_right).with.offset(kHEIGHT(8));
        make.top.equalTo(titleLbl.mas_bottom).with.offset(6);
        make.width.equalTo(@(kHEIGHT(40)));
        make.height.equalTo(@(kHEIGHT(40)));
    }];
    
    UIImageView *icon5 = [[UIImageView alloc] init];
    self.icon5 = icon5;
    icon5.layer.masksToBounds = YES;
    icon5.layer.cornerRadius = 5;
    [self.contentView addSubview:icon5];
    
    [icon5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon4.mas_right).with.offset(kHEIGHT(8));
        make.top.equalTo(titleLbl.mas_bottom).with.offset(6);
        make.width.equalTo(@(kHEIGHT(40)));
        make.height.equalTo(@(kHEIGHT(40)));
    }];

    WPBadgeButton *badgeButton = [[WPBadgeButton alloc] init];
    badgeButton.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataList.count];
    [self.contentView addSubview:badgeButton];
    self.badgeButton = badgeButton;
    [badgeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-kHEIGHT(10));
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@16);
        
    }];
    
    
}


-(void)setDataList:(NSMutableArray *)dataList{
    _dataList = dataList;
    NSMutableArray *imgArr = [NSMutableArray array];
    for (int i = 0; i<self.dataList.count; i++) {
        WPToAddListFriendModel *model = self.dataList[i];
        NSString *url = [IPADDRESS stringByAppendingString:model.avatar];
        [imgArr addObject:url];
    }
    NSLog(@"imgArr%@",imgArr);
    switch (imgArr.count) {
        case 2:
            [self.icon sd_setImageWithURL:URLWITHSTR(imgArr[0]) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
            [self.icon2 sd_setImageWithURL:URLWITHSTR(imgArr[1]) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
            self.icon3.hidden = YES;
            self.icon4.hidden = YES;
            self.icon5.hidden = YES;
            break;
        case 3:
            [self.icon sd_setImageWithURL:URLWITHSTR(imgArr[0]) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
            [self.icon2 sd_setImageWithURL:URLWITHSTR(imgArr[1]) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
            [self.icon3 sd_setImageWithURL:URLWITHSTR(imgArr[2]) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
            self.icon4.hidden = YES;
            self.icon5.hidden = YES;
            break;
        case 4:
            [self.icon sd_setImageWithURL:URLWITHSTR(imgArr[0]) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
            [self.icon2 sd_setImageWithURL:URLWITHSTR(imgArr[1]) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
            [self.icon3 sd_setImageWithURL:URLWITHSTR(imgArr[2]) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
            [self.icon4 sd_setImageWithURL:URLWITHSTR(imgArr[3]) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
            self.icon5.hidden = YES;
            break;
        case 5:
            [self.icon sd_setImageWithURL:URLWITHSTR(imgArr[0]) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
            [self.icon2 sd_setImageWithURL:URLWITHSTR(imgArr[1]) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
            [self.icon3 sd_setImageWithURL:URLWITHSTR(imgArr[2]) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
            [self.icon4 sd_setImageWithURL:URLWITHSTR(imgArr[3]) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
            [self.icon5 sd_setImageWithURL:URLWITHSTR(imgArr[4]) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
            break;
            
        default:
            break;
    }
    self.badgeButton.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataList.count];
}


@end
