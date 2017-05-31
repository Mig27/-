//
//  WPGroupSettingCell.m
//  WP
//
//  Created by 沈亮亮 on 16/4/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGroupSettingCell.h"

@implementation WPGroupSettingCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,0 , 150, kHEIGHT(43))];
        self.titleLabel.font = kFONT(15);
        [self.contentView addSubview:self.titleLabel];
        
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 8 - 100 - 4, 0, 100, kHEIGHT(43))];
        self.subTitleLabel.textColor = RGB(127, 127, 127);
        self.subTitleLabel.font = kFONT(12);
        self.subTitleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.subTitleLabel];
//        self.subTitleLabel.backgroundColor = [UIColor redColor];
        
        
        
        self.messageSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 51, (kHEIGHT(43) - 31)/2, 51, 31)];
        [self.messageSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        self.messageSwitch.hidden = YES;
        self.messageSwitch.onTintColor = RGB(0, 172, 255);
        [self.contentView addSubview:self.messageSwitch];
    }
    return self;
}
-(void)valueChanged:(UISwitch*)messageSwitch
{
    messageSwitch.on = !messageSwitch.on;
    if (self.mssageSwitch) {
        self.mssageSwitch(messageSwitch.isOn);
    }
}
- (void)setDict:(NSDictionary *)dict
{
    self.titleLabel.text = dict[@"title"];
    self.subTitleLabel.text = dict[@"subTitle"];
//    NSLog(@"%@++++++%@",dict[@"title"],dict[@"subTitle"]);
//    if ([self.titleLabel.text isEqualToString:@"消息免打扰"])
//    {
//        self.messageSwitch.hidden = NO;
//    }
//    else
//    {
//        self.messageSwitch.hidden = YES;
//    }
    if ([dict[@"isArr"] isEqualToString:@"1"]) {
     self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
    }
}
-(void)setSwitchState:(BOOL)switchState
{
    self.messageSwitch.on = switchState;

}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    WPGroupSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WPGroupSettingCellId"];
    if (!cell) {
        cell = [[WPGroupSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WPGroupSettingCellId"];
    }
    return cell;
}


+ (CGFloat)rowHeight
{
    return kHEIGHT(43);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
