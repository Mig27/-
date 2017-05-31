
//
//  WPResumeUserCell.m
//  WP
//
//  Created by Kokia on 16/3/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPResumeUserCell.h"

@implementation WPResumeUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)]];
        
        
        CGFloat cellHeight = kHEIGHT(58);
        
        CGFloat padding = kHEIGHT(10);
        
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(padding, (cellHeight - kHEIGHT(43)) / 2, kHEIGHT(43), kHEIGHT(43))];
        _iconImage.image = [UIImage imageNamed:@"head_default"];
        _iconImage.layer.cornerRadius = 5;
        _iconImage.clipsToBounds = YES;
        _iconImage.layer.borderColor = RGB(226, 226, 226).CGColor;
        _iconImage.layer.borderWidth = 0.5;
        [self.contentView addSubview:_iconImage];
        
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(_iconImage.right + padding, _iconImage.top, SCREEN_WIDTH - 120, _iconImage.height / 2)];
        _nameLbl.text = @"工程师";
        _nameLbl.font = kFONT(15);
        [self.contentView addSubview:_nameLbl];
        
        _detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(_iconImage.right + padding, _nameLbl.bottom + 8, SCREEN_WIDTH - _nameLbl.left - 22-padding*2, 15)];
        _detailLbl.font = kFONT(12);
        _detailLbl.text = @"男 黑龙江佳木斯抚远县 6-8年";
        _detailLbl.textColor = RGB(127, 127, 127);
        [self.contentView addSubview:_detailLbl];
        
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseBtn.frame = CGRectMake(SCREEN_WIDTH - 44, 0, 44,cellHeight);
        [_chooseBtn setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
        [_chooseBtn setImageEdgeInsets:UIEdgeInsetsMake((cellHeight-22)/2, 10, (cellHeight-22)/2,10)];
        [_chooseBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_chooseBtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kHEIGHT(58)-0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [self.contentView addSubview:line];
        
    }
    
    return self;
}

- (void)btnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (self.chooseActionBlock) {
        self.chooseActionBlock(self.tag);  // tag为cell的indexPath.row
    }
}


- (void)setModel:(WPResumeUserInfoModel *)model
{
    _model = model;
    
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:_model.avatar]];
    
    [self.iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    if (!self.isReume) {
        self.nameLbl.text = _model.name;
        
        self.detailLbl.text = [NSString stringWithFormat:@"%@ %@ %@", _model.sex, _model.education, _model.workTime];
    } else {
        self.nameLbl.text = [NSString stringWithFormat:@"求职 : %@",_model.postion];
        self.detailLbl.text = [NSString stringWithFormat:@"%@ %@ %@ %@",_model.name, _model.sex, _model.education, _model.workTime];
    }
    
    self.chooseBtn.selected =  _model.itemIsSelected;

}


@end
