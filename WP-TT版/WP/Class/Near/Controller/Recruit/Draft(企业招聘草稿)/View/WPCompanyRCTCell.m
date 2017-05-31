//
//  WPCompanyRCTCell.m
//  WP
//
//  Created by Kokia on 16/4/19.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPCompanyRCTCell.h"
#import "WPCompanyModel.h"
@class WPCompanyListDetailModel;

@implementation WPCompanyRCTCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
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
        _nameLbl.text = @"求职：高级硬件工程师";
        _nameLbl.font = kFONT(15);
        [self.contentView addSubview:_nameLbl];
        
        _detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(_iconImage.right + padding, _nameLbl.bottom + 8, SCREEN_WIDTH - 200, 15)];
        _detailLbl.font = kFONT(12);
        _detailLbl.text = @"王尼玛 男 26 本科 6-8年";
        _detailLbl.textColor = RGB(153, 153, 153);
        [self.contentView addSubview:_detailLbl];
        
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _chooseBtn.hidden = YES;
        _chooseBtn.userInteractionEnabled = NO;
        _chooseBtn.frame = CGRectMake(0, 0, kHEIGHT(50), kHEIGHT(58));
        [_chooseBtn setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
        [_chooseBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_chooseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, kHEIGHT(10), 0, 0)];
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
        self.chooseActionBlock(self.indexPath);
    }
}


- (void)setModel:(WPCompanyListDetailModel *)model isEdit:(BOOL)edit
{
    _chooseBtn.frame = CGRectMake(0, 0, kHEIGHT(50), kHEIGHT(58));
    _model = model;
    _chooseBtn.hidden = edit ? NO : YES;
    if (edit) {
        [UIView animateWithDuration:0.3 animations:^{
            _iconImage.left = kHEIGHT(10)+kHEIGHT(10)+18;
            _nameLbl.left = _iconImage.right+kHEIGHT(10);
            _detailLbl.left = _iconImage.right+kHEIGHT(10);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            _iconImage.left = kHEIGHT(10);
            _nameLbl.left = _iconImage.right+kHEIGHT(10);
            _detailLbl.left = _iconImage.right+kHEIGHT(10);
        }];
    }
    
    if (!edit && model.itemIsSelected) {
        _chooseBtn.hidden = NO;
       _chooseBtn.frame = CGRectMake(kScreen_Width - kHEIGHT(40), 0, kHEIGHT(50), kHEIGHT(58));
        //[UIView animateWithDuration:0.3 animations:^{
        //    _iconImage.left = kHEIGHT(10)-kHEIGHT(10)-18;
          //  _nameLbl.left = _iconImage.right+kHEIGHT(10);
        //   _detailLbl.left = _iconImage.right+kHEIGHT(10);

       // }];
    }
    
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:_model.QRCode]];
    
    [self.iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    self.nameLbl.text = [@"招聘：" stringByAppendingString:_model.jobPositon];
    self.detailLbl.text = model.enterpriseName;
    
   // self.detailLbl.text = [NSString stringWithFormat:@"%@ %@ %@",_model.dataIndustry,_model.enterpriseProperties,_model.enterpriseScale];
    
    self.chooseBtn.selected =  _model.itemIsSelected;
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
