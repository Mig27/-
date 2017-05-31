//
//  ConditionCell.m
//  WP
//
//  Created by 沈亮亮 on 15/10/21.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "ConditionCell.h"

@implementation ConditionCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat height = kHEIGHT(43);
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (height - 20)/2, 200, 20)];
        self.titleLabel.font = kFONT(15);
        self.titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLabel];
        
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectBtn.frame = CGRectMake(SCREEN_WIDTH - 31, (height - 21)/2, 21, 21);
        [self.selectBtn setImage:[UIImage imageNamed:@"是否匿名"] forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"是匿名"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.selectBtn];
    }
    
    return self;
}

- (void)setBtnIsSelect:(BOOL)btnIsSelect
{
    self.selectBtn.selected = btnIsSelect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
