//
//  WPNearByPersonCell.m
//  WP
//
//  Created by Kokia on 16/5/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPNearByPersonCell.h"

@implementation WPNearByPersonCell

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
    
    CGSize normalSize1 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize normalSize2 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat y = (kHEIGHT(58) - normalSize1.height - normalSize2.height - 8)/2;
    self.iconImage = [[UIImageView alloc] init]; //WithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(72)/2 - kHEIGHT(54)/2, kHEIGHT(43), kHEIGHT(43))
    self.iconImage.clipsToBounds = YES;
    self.iconImage.layer.cornerRadius = 5;
    [self.contentView addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(kHEIGHT(10));
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@(kHEIGHT(43)));
    }];
    
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + kHEIGHT(10), y, SCREEN_WIDTH - 100, normalSize1.height)];
    self.nameLabel.font = kFONT(15);
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(y);
        make.left.equalTo(self.iconImage.mas_right).with.offset(kHEIGHT(10));
    }];
    
    
    self.subLabel = [[UILabel alloc] init];
    self.subLabel.font = kFONT(12);
    self.subLabel.textColor = RGB(127, 127, 127);
    [self.subLabel sizeToFit];
    [self.contentView addSubview:self.subLabel];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(8);
        make.height.equalTo(@(normalSize2.height));
   
    }];
    
    UIView *verticalLine = [[UIView alloc] init];
    self.verticalLine = verticalLine;
    self.verticalLine.backgroundColor = RGB(226, 226, 226);
    [self.contentView addSubview:verticalLine];
    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subLabel.mas_right).with.offset(6);
        make.centerY.equalTo(self.subLabel.mas_centerY);
        make.width.equalTo(@0.5);
        make.height.equalTo(@(12));
    }];
    
    
//    self.companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.verticalLine.right + 6, self.nameLabel.bottom + 8, SCREEN_WIDTH - 3*kHEIGHT(10) - kHEIGHT(54), normalSize2.height)];
    self.companyLabel = [[UILabel alloc]init];
    self.companyLabel.font = kFONT(12);
    self.companyLabel.textColor = RGB(127, 127, 127);
    [self.companyLabel sizeToFit];
//    self.companyLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.companyLabel];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verticalLine.mas_right).with.offset(6);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(8);
        make.height.equalTo(@(normalSize2.height));
    }];
    
    self.addressImg = [[UIImageView alloc] init];
    self.addressImg.image = [UIImage imageNamed:@"group_address"];
    [self.contentView addSubview:self.addressImg];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.font = kFONT(10);
    self.addressLabel.textColor = RGB(127, 127, 127);
    [self.contentView addSubview:self.addressLabel];
}
- (void)setModel:(WPNearbyPersonModel *)model
{
    NSString *url = [IPADDRESS stringByAppendingString:model.avatar];
    [self.iconImage sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    NSString *distance = [NSString stringWithFormat:@"%@km",model.Distance];
    CGSize normalSize2 = [distance sizeWithAttributes:@{NSFontAttributeName:kFONT(10)}];
    self.addressImg.frame = CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - normalSize2.width - 6 - 8, kHEIGHT(10), 8, 12);
    self.addressLabel.frame = CGRectMake(self.addressImg.right + 6, kHEIGHT(10), normalSize2.width, normalSize2.height);
    self.addressLabel.centerY = self.addressImg.centerY;
    self.addressLabel.text = distance;
    self.companyLabel.text = model.company;
    self.nameLabel.text = model.name;
    self.subLabel.text = model.Hope_Position;
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, kHEIGHT(58)-0.5, SCREEN_WIDTH,0.5)];
    line.backgroundColor = RGB(235, 235, 235);
    [self.contentView addSubview:line];
    
    CGSize positionSize = [model.Hope_Position sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verticalLine.mas_right).with.offset(6);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(8);
        make.height.equalTo(@(normalSize2.height));
        make.width.equalTo(@(SCREEN_WIDTH-kHEIGHT(30)-positionSize.width-kHEIGHT(54)-kHEIGHT(30)));
    }];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    WPNearByPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WPNearByPersonCell"];
    if (!cell) {
        cell = [[WPNearByPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WPNearByPersonCell"];
    }
    return cell;
}
+ (CGFloat)rowHeight
{
    return kHEIGHT(58);
}
@end
