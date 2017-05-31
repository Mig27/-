//
//  WPNewFullCell.m
//  WP
//
//  Created by CBCCBC on 16/1/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPNewFullCell.h"
#import "UIImageView+WebCache.h"

#import "WPNewResumeController.h"
#define CellHeight kHEIGHT(58)

@implementation WPNewFullCell
{
    UIImageView *_selectedImageView;  // 编辑状态，选中图片
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)]];
        
        _selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10), CellHeight/2-9, 18, 18)];
        _selectedImageView.hidden = YES;
        [self.contentView addSubview:_selectedImageView];
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10),(CellHeight-kHEIGHT(43))/2, kHEIGHT(43), kHEIGHT(43))];
        _iconImage.image = [UIImage imageNamed:@"head_default"];
        _iconImage.layer.cornerRadius = 5;
        _iconImage.clipsToBounds = YES;
        _iconImage.layer.borderColor = RGB(226, 226, 226).CGColor;
        _iconImage.layer.borderWidth = 0.5;
        [self.contentView addSubview:_iconImage];
        
        //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //button.frame = _iconImage.frame;
        //[button addTarget:self action:@selector(iconClick) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:button];
        
        _nameLabel = [[SPLabel alloc]initWithFrame:CGRectMake(_iconImage.right+10, _iconImage.top, SCREEN_WIDTH-120, _iconImage.height/2)];
        _nameLabel.text = @"招聘：快递员 分类员";
        _nameLabel.font = kFONT(15);
        //        _nameLable.backgroundColor = [UIColor redColor];
        //        _nameLable.verticalAlignment = VerticalAlignmentBottom;
        [self.contentView addSubview:_nameLabel];
        
        _detailLabel = [[SPLabel alloc]initWithFrame:CGRectMake(_iconImage.right+10, _nameLabel.bottom+8, SCREEN_WIDTH-200, 15)];
        _detailLabel.font = kFONT(12);
        _detailLabel.text = @"合肥莱达商贸有限公司";
        _detailLabel.textColor = RGB(153, 153, 153);
        //        _detailLable.backgroundColor = [UIColor blueColor];
        //        _detailLable.verticalAlignment = VerticalAlignmentTop;
        [self.contentView addSubview:_detailLabel];
        
        _buttonArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonArrow.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-8, CellHeight/2-7, 8, 14);
        [_buttonArrow setImage:[UIImage imageNamed:@"jinru"] forState:UIControlStateNormal];
        [self addSubview:_buttonArrow];
        
//        _imageAgainst = [[UIImageView alloc]initWithFrame:CGRectMake(_buttonArrow.left-13-4, CellHeight/2-7.5, 15, 15)];
//        _imageAgainst.image = [UIImage imageNamed:@"qiang"];
//        [self addSubview:_imageAgainst];
        
        self.against = [[UILabel alloc]initWithFrame:CGRectMake(_buttonArrow.left-13-4, CellHeight/2-7.5, 14, 14)];
        self.against.textColor = [UIColor whiteColor];
        self.against.textAlignment = NSTextAlignmentCenter;
        self.against.backgroundColor = RGB(0, 172, 225);
        self.against.layer.cornerRadius = 7;
        self.against.layer.masksToBounds = YES;
        
        self.against.font = kFONT(7);
//        [self addSubview:self.against];
        
        _timeLabel = [[SPLabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60-kHEIGHT(10), _against.bottom+3, 60, 15)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = RGB(153, 153, 153);
        _timeLabel.font = kFONT(10);
        _timeLabel.text = @"17分钟前";
        [self addSubview:_timeLabel];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, CellHeight-0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [self addSubview:line];
    }
    return self;
}


- (void)setStatus:(NSString *)status
{
    _status = status;
    self.against.text = status;
    if (status.length == 2) {
        self.against.frame = CGRectMake(_buttonArrow.left-13-4-14, CellHeight/2-7.5, 25, 14);
    }
    [self addSubview:self.against];
}

-(void)setModel:(WPNewResumeListModel *)model
{
    _model = model;
    if (_model.type == WPMainPositionTypeInterView) {
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:_model.avatar]];
        [self.iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
        self.nameLabel.text = [@"求职:" stringByAppendingString:_model.HopePosition];
        self.detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",_model.name,_model.sex,_model.birthday,_model.education,_model.WorkTim];
    }
    if (_model.type == WPMainPositionTypeRecruit) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,_model.logo]];//[IPADDRESS stringByAppendingString:_model.logo]
        [self.iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
        self.nameLabel.text = [@"招聘:" stringByAppendingString:_model.jobPositon];
        self.detailLabel.text = _model.enterpriseName;
    }
//    self.bu
    self.timeLabel.text = _model.updateTime;
    _selectedImageView.image = [UIImage imageNamed:_model.isSelected?@"common_xuanzhong":@"common_xuanze"];
    [self.against removeFromSuperview];
}

- (void)exchangeSubViewFrame:(BOOL)isEdit{
    
    CGFloat y = isEdit?(kHEIGHT(10)*2+25):kHEIGHT(10);
    
    [UIView animateWithDuration:0.1 animations:^{
       
        _iconImage.left = y;
        _nameLabel.left = _iconImage.right+10;
        _detailLabel.left = _iconImage.right+10;
        _selectedImageView.hidden = !isEdit;
    }];
}

@end
