//
//  WPGroupInformationCell3.m
//  WP
//
//  Created by 沈亮亮 on 16/4/19.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGroupInformationCell3.h"

@implementation WPGroupInformationCell3

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
    self.itemLabel = [[UILabel alloc] init];
    self.itemLabel.font = kFONT(15);
    [self.contentView addSubview:self.itemLabel];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = kFONT(12);
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    self.nameLabel.textColor = RGB(127, 127, 127);
    [self.contentView addSubview:self.nameLabel];
    
//    self.nameLabel.backgroundColor = [UIColor redColor];
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.font = kFONT(12);
    self.tipLabel.textColor = RGB(127, 127, 127);
    self.tipLabel.text = @"群组名称不会出现在职场群组里面";
    [self.contentView addSubview:self.tipLabel];
    
    self.mySwitch = [[UISwitch alloc] init];
    self.mySwitch.onTintColor = RGB(0, 172, 255);
    [self.mySwitch addTarget:self action:@selector(switchClick) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.mySwitch];
}

- (void)setItemStr:(NSString *)itemStr
{
    self.itemLabel.text = itemStr;
    CGFloat height;
    if (self.isCloaking) {
        height = kHEIGHT(58);
    } else {
        height = kHEIGHT(43);
    }
    
    CGSize normalSize1 = [@"群组隐身" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize normalSize2 = [@"群组隐身" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];

    CGFloat y = (kHEIGHT(58) - normalSize1.height - normalSize2.height - 8)/2;
    
    if (self.isNick && !self.isCloaking) {
        self.itemLabel.frame = CGRectMake(16, 0, 100, kHEIGHT(43));
        self.mySwitch.hidden = YES;
        self.nameLabel.frame = CGRectMake(SCREEN_WIDTH - 20 - 8 - 200 - 4, 0, 200, kHEIGHT(43));
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
        return;
    } else if (!self.isNick && self.isCloaking) {
        self.mySwitch.frame = CGRectMake(SCREEN_WIDTH - 16 - 51, (kHEIGHT(58) - 31)/2, 51, 31);
        self.itemLabel.frame = CGRectMake(16, y, 100, normalSize1.height);
        self.tipLabel.frame = CGRectMake(16, self.itemLabel.bottom + 8, 300, normalSize2.height);
    } else if (!self.isNick && !self.isCloaking) {
        self.mySwitch.frame = CGRectMake(SCREEN_WIDTH - 16 - 51, (kHEIGHT(43) - 31)/2, 51, 31);
        self.itemLabel.frame = CGRectMake(16, 0, 100, kHEIGHT(43));
    }

}

- (void)switchClick
{
    if (self.mySwitch.isOn) {
        NSLog(@"打开");
    } else {
        NSLog(@"关闭");
    }
    if (self.switchActionBlock) {
        self.switchActionBlock(self.index,self.mySwitch.isOn ? @"1" : @"0");//0-1
    }
}

- (void)setNickName:(NSString *)nickName
{
//    NSLog(@"%@",nickName);
    self.nameLabel.text = nickName;
    if (nickName.length == 0) {
        self.nameLabel.text = kShareModel.nick_name;
    }
}

- (void)setIsOn:(NSString *)isOn
{
    if ([isOn isEqualToString:@"1"]) {
        self.mySwitch.on = YES;//no
    } else {
        self.mySwitch.on = NO;//yes
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    WPGroupInformationCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"WPGroupInformationCell3Id"];
    if (!cell) {
        cell = [[WPGroupInformationCell3 alloc] init];
    }
    return cell;
}


+ (CGFloat)rowHeightIscloaking:(BOOL)cloaking
{
    if (cloaking) {
        return kHEIGHT(58);
    }
    return kHEIGHT(43);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
