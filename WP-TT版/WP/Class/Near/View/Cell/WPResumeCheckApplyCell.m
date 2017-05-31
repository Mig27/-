//
//  WPResumeCheckApplyCell.m
//  WP
//
//  Created by CBCCBC on 15/12/1.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPResumeCheckApplyCell.h"
#import "SPLabel.h"
#import "UIImageView+WebCache.h"

@implementation WPResumeCheckApplyCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        UIImageView *iconImageView = [[UIImageView alloc]init];
        iconImageView.layer.cornerRadius = 5;
        iconImageView.image = [UIImage imageNamed:@"head_default"];
        iconImageView.layer.masksToBounds = YES;
        iconImageView.tag = WPResumeCheckApplyCellTypeIcon;
        [self addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kHEIGHT(16.5));
            make.centerY.equalTo(self);
            make.width.height.equalTo(@(kHEIGHT(30)));
        }];
        
        SPLabel *titleLabel = [SPLabel new];
        titleLabel.text = @"绿地合肥分公司";
//        titleLabel.backgroundColor = [UIColor redColor];
        titleLabel.verticalAlignment = VerticalAlignmentTop;//让文字位于上方
        titleLabel.font = kFONT(12);
        titleLabel.tag = WPResumeCheckApplyCellTypeTitle;
//        titleLabel.textColor = RGB(127, 127, 127);
        [self addSubview:titleLabel];
        
        SPLabel *contentLabel = [SPLabel new];
        contentLabel.text = @"刚刚";
        contentLabel.verticalAlignment = VerticalAlignmentBottom;
//        contentLabel.backgroundColor = [UIColor greenColor];
        contentLabel.font = kFONT(10);
        contentLabel.textColor = RGB(127, 127, 127);
        contentLabel.tag = WPResumeCheckApplyCellTypeContent;
        [self addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(18);
            make.top.equalTo(titleLabel.mas_bottom);
            make.right.equalTo(self);
            make.bottom.equalTo(iconImageView.mas_bottom);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(18);
            make.top.equalTo(iconImageView.mas_top);
//            make.top.equalTo(self).offset(kHEIGHT(12));
            make.right.equalTo(self);
            make.bottom.equalTo(contentLabel.mas_top);
        }];
        
        SPLabel *timeLabel = [SPLabel new];
        timeLabel.tag = WPResumeCheckApplyCellTypeTime;
//        timeLabel.backgroundColor = [UIColor redColor];
        timeLabel.text = @"时间";
        timeLabel.font = kFONT(10);
        timeLabel.textColor = RGB(170, 170, 170);
        [self addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_top);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
    }
    return self;
}

- (void)setListModel:(ApplyCompanyList *)listModel{
    _listModel = listModel;
    UIImageView *iconImageView = (UIImageView *)[self viewWithTag:WPResumeCheckApplyCellTypeIcon];
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.avatar]];
    [iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    SPLabel *titleLabel = (SPLabel *)[self viewWithTag:WPResumeCheckApplyCellTypeTitle];
    titleLabel.text = listModel.jobTitle?:listModel.name;
    
    SPLabel *contentLabel = (SPLabel *)[self viewWithTag:WPResumeCheckApplyCellTypeContent];
    contentLabel.text = listModel.company?[NSString stringWithFormat:@"%@ | %@",listModel.position,listModel.company]:listModel.name;
    
    SPLabel *timeLabel = (SPLabel *)[self viewWithTag:WPResumeCheckApplyCellTypeTime];
    timeLabel.text = listModel.addTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
