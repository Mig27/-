//
//  WPSysTimeTableViewCell.m
//  WP
//
//  Created by CC on 17/2/4.
//  Copyright © 2017年 WP. All rights reserved.
//

#import "WPSysTimeTableViewCell.h"

@implementation WPSysTimeTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.timeLabe = [UILabel new];
        //self.timeLabe.backgroundColor = RGBA(100, 100, 100, 0.2);
        self.timeLabe.font = kFONT(12);
        self.timeLabe.layer.cornerRadius = 5;
        self.timeLabe.clipsToBounds = YES;
        self.timeLabe.textAlignment = NSTextAlignmentCenter;
        self.timeLabe.textColor = RGB(127, 127, 127);
        [self.contentView addSubview:self.timeLabe];
        
        self.backgroundColor = RGB(247, 247, 247);
        
    }
    return self;
}
-(void)setTimeString:(NSString *)timeString
{
    self.timeLabe.text = timeString;
    CGSize timeSize = [timeString getSizeWithFont:kFONT(12) Width:SCREEN_WIDTH-2*kHEIGHT(10)];
    self.timeLabe.frame = CGRectMake(0, 10, timeSize.width+6, timeSize.height+3);
    self.timeLabe.centerX = (SCREEN_WIDTH)/2;
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
