//
//  ApplyAndWantTableViewCell.m
//  WP
//
//  Created by CC on 16/8/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "ApplyAndWantTableViewCell.h"

@implementation ApplyAndWantTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = 5;
        _iconImageView.image = [UIImage imageNamed:@"head_default"];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.frame = CGRectMake(kHEIGHT(12), (kHEIGHT(58)-kHEIGHT(43))/2, kHEIGHT(43), kHEIGHT(43));
        [self addSubview:_iconImageView];
        
        _titleLabel = [SPLabel new];
        _titleLabel.text = @"绿地合肥分公司";
        _titleLabel.font = kFONT(15);
        //        titleLabel.tag = 11;
        _titleLabel.verticalAlignment = VerticalAlignmentTop;
        _titleLabel.frame = CGRectMake(_iconImageView.right+10, _iconImageView.top, SCREEN_WIDTH-_iconImageView.right-10-kHEIGHT(50), kHEIGHT(43)/2);
        [self addSubview:_titleLabel];
        
        
        _contentLabel = [SPLabel new];
        _contentLabel.text = @"刚刚";
        _contentLabel.font = kFONT(12);
        _contentLabel.verticalAlignment = VerticalAlignmentBottom;
        _contentLabel.textColor = RGB(127, 127, 127);
        _contentLabel.frame = CGRectMake(_iconImageView.right+10, _titleLabel.bottom, _titleLabel.width, _titleLabel.height);
        [self addSubview:_contentLabel];
     
        
        _timeLabel = [SPLabel new];
        _timeLabel.text = @"时间";
        _timeLabel.font = kFONT(10);
//        _timeLabel.backgroundColor = [UIColor redColor];
        _timeLabel.textColor = RGB(170, 170, 170);
        _timeLabel.frame = CGRectMake(SCREEN_WIDTH-60-22-kHEIGHT(12)-kHEIGHT(8), _iconImageView.top,60, 20);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.verticalAlignment = VerticalAlignmentTop;
        [self addSubview:_timeLabel];
        
        
        _selectbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectbtn.frame = CGRectMake(SCREEN_WIDTH - kHEIGHT(12) - 22, 0,kHEIGHT(12)+22, kHEIGHT(58));
        //        _choiseBtn.tag = 500000;
        [_selectbtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//        [_selectbtn setBackgroundColor:[UIColor greenColor]];
        [self addSubview:_selectbtn];
        [_selectbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kHEIGHT(12))];
        [_selectbtn setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [_selectbtn setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
        [_selectbtn addTarget:self action:@selector(choiseCell:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  self;
}
-(void)choiseCell:(UIButton*)sender
{
    if (self.choiseCell) {
        self.choiseCell(self.indexPath);
    }
}
- (void)setListModel:(NearPersonalListModel *)listModel andApply:(BOOL)apply{
    
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,listModel.avatar]] placeholderImage:[UIImage imageNamed:@"head_default"]];
    _titleLabel.text = [NSString stringWithFormat:@"%@",listModel.position];

    _contentLabel.text = apply?[NSString stringWithFormat:@"%@ %@ %@ %@",listModel.nike_name,listModel.sex,listModel.education,listModel.worktime]:[NSString stringWithFormat:@"%@",listModel.enterprise_name];
    _timeLabel.text = listModel.updateTime;
    _selectbtn.selected = listModel.isSelected;
    
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
