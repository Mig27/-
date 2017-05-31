//
//  WPMeApplyCell.m
//  WP
//
//  Created by CBCCBC on 16/1/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMeApplyCell.h"
#import "SPLabel.h"
#import "UIImageView+WebCache.h"
#import "WPMeApplyViewController.h"



@implementation WPMeApplyCell


- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = 5;
        _iconImageView.image = [UIImage imageNamed:@"head_default"];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.frame = CGRectMake(kHEIGHT(10), (kHEIGHT(58)-kHEIGHT(43))/2, kHEIGHT(43), kHEIGHT(43));
        [self addSubview:_iconImageView];
//        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(kHEIGHT(12));
//            make.centerY.equalTo(self);
//            make.width.height.equalTo(@(kHEIGHT(43)));
//        }];
        
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
//        contentLabel.tag = 12;
        [self addSubview:_contentLabel];
        
//        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_iconImageView.mas_right).offset(10);
//            make.top.equalTo(_titleLabel.mas_bottom);
//            make.right.equalTo(self);
//            make.bottom.equalTo(_iconImageView.mas_bottom);
//        }];
//        
//        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_iconImageView.mas_right).offset(10);
//            make.top.equalTo(_iconImageView.mas_top);
//            make.right.equalTo(self);
//            make.bottom.equalTo(_contentLabel.mas_top);
//        }];
        
        _timeLabel = [SPLabel new];
//        timeLabel.tag = 13;
        _timeLabel.text = @"时间";
//        CGSize size = [_timeLabel.text getSizeWithFont:FUCKFONT(12) Height:20];
        _timeLabel.font = kFONT(10);
//        _timeLabel.backgroundColor = [UIColor redColor];
        _timeLabel.textColor = RGB(170, 170, 170);
        _timeLabel.frame = CGRectMake(SCREEN_WIDTH-80-kHEIGHT(12), _iconImageView.top,80, 20);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.verticalAlignment = VerticalAlignmentTop;
        [self addSubview:_timeLabel];
//        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(_iconImageView.mas_top);
//                make.right.equalTo(self.mas_right).offset(-kHEIGHT(12));
//            }];

       
        
        //添加按钮
         _choiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _choiseBtn.frame = CGRectMake(0, 0, 40, kHEIGHT(58));//SCREEN_WIDTH - kHEIGHT(12) - 22
//        _choiseBtn.tag = 500000;
        [_choiseBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [_choiseBtn setBackgroundColor:[UIColor greenColor]];
        [self addSubview:_choiseBtn];
        [_choiseBtn setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [_choiseBtn setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
        [_choiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, kHEIGHT(10), 0, 0)];
        [_choiseBtn addTarget:self action:@selector(choiseCell:) forControlEvents:UIControlEventTouchUpInside];
        if (self.isEdit) {
            _choiseBtn.hidden = NO;
        }
        else
        {
            _choiseBtn.hidden = YES;
        }
    }
    return self;
}

#pragma mark 点击cell上的按钮
-(void)choiseCell:(UIButton*)sender
{
    sender.selected = !sender.selected;
    NSUserDefaults * numDefault = [NSUserDefaults standardUserDefaults];
    NSString * string = [NSString stringWithFormat:@"%@",[numDefault objectForKey:@"numberOfCompany"]];//取出选中的个数
    int num = string.intValue;
    if (sender.selected) {
        num++;
    }
    else
    {
        num--;
    }
    [numDefault setObject:[NSString stringWithFormat:@"%d",num] forKey:@"numberOfCompany"];
    
    if (self.choiseCell) {
        self.choiseCell(self.indexPath);
    }
}
- (void)setListModel:(WPMeGrablistModel *)listModel{
    _listModel = listModel;
    UIImageView *iconImageView = (UIImageView *)[self viewWithTag:10];
    
    if (_listModel.logo == nil) {
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.avatar]];
        [iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    }else{
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.logo]];
        [iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    }
    
    
//    SPLabel *titleLabel = (SPLabel *)[self viewWithTag:11];
    if (listModel.sex == nil) {
        _titleLabel.text = [NSString stringWithFormat:@"招聘: %@",listModel.postion];
    }else{
        _titleLabel.text = [NSString stringWithFormat:@"求职: %@",listModel.postion];
    }
    
//    SPLabel *contentLabel = (SPLabel *)[self viewWithTag:12];
    if (listModel.sex == nil) {
        _contentLabel.text = listModel.name;
    }else{
       _contentLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",listModel.name,listModel.sex,listModel.education,listModel.workTime];
    }
    
//    SPLabel *timeLabel = (SPLabel *)[self viewWithTag:13];
    _timeLabel.text = listModel.sign_time;
    
}
- (void)setListModel:(WPMeGrablistModel *)listModel andEdit:(BOOL)edit
{
    _listModel = listModel;
    if (_listModel.logo == nil) {
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.avatar]];
        [_iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    }else{
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.logo]];
        [_iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    }
    
    
    if (listModel.sex == nil) {
        _titleLabel.text = [NSString stringWithFormat:@"招聘: %@",listModel.postion];
    }else{
        _titleLabel.text = [NSString stringWithFormat:@"求职: %@",listModel.postion];
    }
    
    if (listModel.sex == nil) {
        _contentLabel.text = listModel.name;
    }else{
        _contentLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",listModel.name,listModel.sex,listModel.education,listModel.workTime];
    }
    
    _timeLabel.text = listModel.sign_time;
    if (edit) {
        [UIView animateWithDuration:0.3 animations:^{
//          _timeLabel.left = SCREEN_WIDTH-80-kHEIGHT(12)-kHEIGHT(30);
            _iconImageView.left = kHEIGHT(10)+kHEIGHT(10)+18;
            _titleLabel.left = _iconImageView.right+10;
            _contentLabel.left = _iconImageView.right+10;
            _choiseBtn.hidden = NO;
            _choiseBtn.selected = listModel.selected;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
//          _timeLabel.left = SCREEN_WIDTH-80-kHEIGHT(12);
            _iconImageView.left = kHEIGHT(10);
            _titleLabel.left = _iconImageView.right+10;
            _contentLabel.left = _iconImageView.right+10;
            _choiseBtn.hidden = YES;
            _choiseBtn.selected = listModel.selected;
        }];
    }
}

- (void)setModel:(SignModel *)model andEdit:(BOOL)edit
{
    _model = model;
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
    [_iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    _titleLabel.text = model.jobTitle;
    _contentLabel.text = model.name;
    _timeLabel.text = model.add_time;
    if (!edit) {
        [UIView animateWithDuration:0.3 animations:^{
            _iconImageView.left = kHEIGHT(12);
            _titleLabel.left = _iconImageView.right+10;
            _contentLabel.left = _iconImageView.right+10;
            _choiseBtn.hidden = edit?NO:YES;
            _choiseBtn.selected = model.selected;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            _iconImageView.left = kHEIGHT(12)+kHEIGHT(10)+18;
            _titleLabel.left = _iconImageView.right+10;
            _contentLabel.left = _iconImageView.right+10;
            _choiseBtn.hidden = edit?NO:YES;
            _choiseBtn.selected = model.selected;
        }];
    }
    
    
//    UIButton * button = (UIButton*)[self viewWithTag:500000];
//    _choiseBtn.hidden = edit?NO:YES;
//    _choiseBtn.selected = model.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
