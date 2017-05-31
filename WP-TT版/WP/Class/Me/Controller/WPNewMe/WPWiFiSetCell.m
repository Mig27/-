//
//  WPWiFiSetCell.m
//  WP
//
//  Created by CC on 16/9/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPWiFiSetCell.h"

@implementation WPWiFiSetCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 200, kHEIGHT(43))];
        self.nameLabel.userInteractionEnabled = YES;
        self.nameLabel.font = kFONT(15);
        [self.contentView addSubview:self.nameLabel];
        
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectBtn.frame = CGRectMake(SCREEN_WIDTH-16-36, (kHEIGHT(43)-36)/2, 36, 36);
        [self.selectBtn setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateNormal];
        self.selectBtn.hidden = YES;
        self.selectBtn.userInteractionEnabled = YES;
        self.selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.contentView addSubview:self.selectBtn];
    }
    return self;
}
-(void)setNameStr:(NSString *)nameStr
{
    self.nameLabel.text = nameStr;
}
-(void)setWifiStr:(NSString *)wifiStr
{
    if ([wifiStr isEqualToString:self.nameLabel.text]) {
        self.selectBtn.hidden = NO;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
