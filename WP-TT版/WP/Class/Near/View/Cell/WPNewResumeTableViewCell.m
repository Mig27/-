//
//  WPNewResumeTableViewCell.m
//  WP
//
//  Created by CBCCBC on 16/6/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPNewResumeTableViewCell.h"
#import "UIImageView+WebCache.h"

#import "WPNewResumeController.h"
#define CellHeight kHEIGHT(58)

@implementation WPNewResumeTableViewCell
{
    UIImageView *_selectedImageView;  // 编辑状态，选中图片
}

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
//    _nameLabel = [[SPLabel alloc]initWithFrame:CGRectMake(_iconImage.right+10, _iconImage.top, SCREEN_WIDTH-120, _iconImage.height/2)];
    _nameLabel = [[SPLabel alloc]initWithFrame:CGRectMake(kHEIGHT(10)+kHEIGHT(43)+kHEIGHT(12), _iconImage.top, SCREEN_WIDTH-120, _iconImage.height/2)];
    _nameLabel.text = @"招聘：快递员 分类员";
    _nameLabel.font = kFONT(15);
    //        _nameLable.backgroundColor = [UIColor redColor];
    //        _nameLable.verticalAlignment = VerticalAlignmentBottom;
    [self.contentView addSubview:_nameLabel];
    
    _detailLabel = [[SPLabel alloc]initWithFrame:CGRectMake(kHEIGHT(10)+kHEIGHT(43)+kHEIGHT(12), _nameLabel.bottom+8, SCREEN_WIDTH-200, 15)];
    _detailLabel.font = kFONT(12);
    _detailLabel.text = @"合肥莱达商贸有限公司";
    _detailLabel.textColor = RGB(127, 127, 127);
    //        _detailLable.backgroundColor = [UIColor blueColor];
    //        _detailLable.verticalAlignment = VerticalAlignmentTop;
    [self.contentView addSubview:_detailLabel];
    
    _buttonArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonArrow.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-8, CellHeight/2-7, 8, 14);
    [_buttonArrow setImage:[UIImage imageNamed:@"jinru"] forState:UIControlStateNormal];
    [self.contentView addSubview:_buttonArrow];
    
    //        _imageAgainst = [[UIImageView alloc]initWithFrame:CGRectMake(_buttonArrow.left-13-4, CellHeight/2-7.5, 15, 15)];
    //        _imageAgainst.image = [UIImage imageNamed:@"qiang"];
    //        [self addSubview:_imageAgainst];
    
    self.against = [[UIButton alloc]initWithFrame:CGRectMake(_buttonArrow.left-13-4, CellHeight/2-7.5, 14, 14)];
    self.against.titleLabel.textColor = [UIColor whiteColor];
//    self.against.textAlignment = NSTextAlignmentCenter;
    [self.against setBackgroundImage:[UIImage creatUIImageWithColor:RGB(0, 172, 225)] forState:UIControlStateNormal];
//    self.against.backgroundColor = RGB(0, 172, 225);
    self.against.layer.cornerRadius = 7;
    self.against.layer.masksToBounds = YES;
    self.against.userInteractionEnabled = NO;
    self.against.titleLabel.font = kFONT(7);
    //        [self addSubview:self.against];
    
    _timeLabel = [[SPLabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60-kHEIGHT(10), _against.bottom+3, 60, 15)];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = RGB(170, 170, 170);
    _timeLabel.font = kFONT(10);
    _timeLabel.text = @"17分钟前";
    [self.contentView addSubview:_timeLabel];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, CellHeight-0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(226, 226, 226);
    [self.contentView addSubview:line];

}

- (void)setStatus:(NSString *)status
{
    _status = status;
//    self.against.text = status;
    [self.against setTitle:status forState:UIControlStateNormal];
    if (status.length == 2) {
        self.against.frame = CGRectMake(_buttonArrow.left-13-4-14, CellHeight/2-7.5, 25, 14);
    }
    [self addSubview:self.against];
}

-(void)setModel:(WPNewResumeListModel *)model
{
    _model = model;
    if (_model.type == WPMainPositionTypeInterView) {
        
        NSData * data1 = [NSData dataWithContentsOfFile:_model.avatar];
        if (data1) {
            self.iconImage.image = [UIImage imageWithData:data1];
        }
        else
        {
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:_model.avatar]];
            NSData * data = [self imageData:_model.avatar];
            if (data) {
                self.iconImage.image = [UIImage imageWithData:data];
            }
            else
            {
                [self.iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"touxiang_geren"]];
            }
        }
        
//        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:_model.avatar]];
//        NSData * data = [self imageData:_model.avatar];
//        if (data) {
//            self.iconImage.image = [UIImage imageWithData:data];
//        }
//        else
//        {
//          [self.iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
//        }
        self.nameLabel.text = [@"求职：" stringByAppendingString:_model.HopePosition];
        self.detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",_model.name,_model.sex,_model.birthday,_model.education,_model.WorkTim];
    }
    if (_model.type == WPMainPositionTypeRecruit) {
        
        NSData * data1 = [NSData dataWithContentsOfFile:_model.logo];
        if (data1) {
            self.iconImage.image = [UIImage imageWithData:data1];
        }
        else
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IPADDRESS,_model.logo]];//[IPADDRESS stringByAppendingString:_model.logo]
            NSData * data = [self imageData:_model.logo];
            if (data) {
                self.iconImage.image = [UIImage imageWithData:data];
            }
            else
            {
                [self.iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"touxaing_qiye"]];
            }
        }
        
//        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:_model.logo]];
//        NSData * data = [self imageData:_model.logo];
//        if (data) {
//            self.iconImage.image = [UIImage imageWithData:data];
//        }
//        else
//        {
//          [self.iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
//        }
        
//        [self.iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
        self.nameLabel.text = [@"招聘：" stringByAppendingString:_model.jobPositon];
        self.detailLabel.text = _model.enterpriseName;
    }
    //    self.bu
    self.timeLabel.text = _model.updateTime;
    _selectedImageView.image = [UIImage imageNamed:_model.isSelected?@"common_xuanzhong":@"common_xuanze"];
    [self.against removeFromSuperview];
}
-(void)setCanSlected:(BOOL)canSlected
{
    if (canSlected) {
        _selectedImageView.image = [UIImage imageNamed:@"group_enable"];
    }
    else
    {
      _selectedImageView.image = [UIImage imageNamed:_model.isSelected?@"common_xuanzhong":@"common_xuanze"];
    }
}
-(NSData*)imageData:(NSString*)imageStr
{
    NSArray * pathArray = [imageStr componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSData * data = [NSData dataWithContentsOfFile:fileName1];
    return data;
}
- (void)exchangeSubViewFrame:(BOOL)isEdit{
    
    CGFloat y = isEdit?(kHEIGHT(10)*2+18):kHEIGHT(10);
    
//    [UIView animateWithDuration:0.1 animations:^{
        _iconImage.left = y;
        _nameLabel.left = _iconImage.right+10;
        _detailLabel.left = _iconImage.right+10;
        _selectedImageView.hidden = !isEdit;
//    }];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    WPNewResumeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WPNewResumeTableViewCellId"];
    if (!cell) {
        cell = [[WPNewResumeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WPNewResumeTableViewCellId"];
    }
    return cell;
}

#pragma mark - UIGestureDelegate
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

+ (CGFloat)rowHeight
{
    return kHEIGHT(58);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
