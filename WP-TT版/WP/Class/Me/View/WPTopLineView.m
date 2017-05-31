//
//  WPTopLineView.m
//  WP
//
//  Created by CBCCBC on 16/4/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPTopLineView.h"


@interface WPTopLineView ()
@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UIButton *headerView;
@property (nonatomic , strong)UILabel *positionLabel;
//@property (nonatomic , strong)UILabel *timeLabel;
@property (nonatomic , strong)UILabel *companyLabel;
@end

@implementation WPTopLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.headerView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.positionLabel];
        [self addSubview:self.companyLabel];
//        [self addSubview:self.timeLabel];
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    NSString * col4 = dic[@"col4"];
    UIView *line = (UIView *)[self viewWithTag:1];
    line.hidden = col4.length;
    
    [self setImageToHeaderViewWithURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:dic[@"avatar"]]]];
    [self setNameToTitleLabelWithName:col4.length?[NSString stringWithFormat:@"%@-%@",dic[@"nick_name"],col4]:dic[@"nick_name"]];
    [self setPositionToPositionLabelWithPosition:col4.length?@"":dic[@"position"]];
//    [self setAdd_timeToTimeLabelWithAdd_Time:dic[@"add_time"]];
    [self setCompanyToCompanyLabelWithCompany:col4.length?@"":dic[@"companName"]];
}

//- (void)setAdd_timeToTimeLabelWithAdd_Time:(NSString *)add_time
//{
//    NSArray *time = [add_time componentsSeparatedByString:@" "];
//    NSString *string = [NSString stringWithFormat:@"收藏于 %@",time[0]];
//    CGSize size = [string getSizeWithFont:FUCKFONT(12) Height:120];
//    self.timeLabel.frame = CGRectMake(kHEIGHT(10), self.headerView.bottom + kHEIGHT(10), size.width, size.height);
//    self.timeLabel.text = string;
//}

- (void)setCompanyToCompanyLabelWithCompany:(NSString *)company
{
    CGSize size = [company getSizeWithFont:FUCKFONT(10) Height:20];
    CGFloat width = SCREEN_WIDTH-self.positionLabel.right-8-kHEIGHT(10)-6;
    
    self.companyLabel.frame = CGRectMake(self.positionLabel.right+8, 0, width, size.height);
    self.companyLabel.bottom = self.titleLabel.bottom-2;
    self.companyLabel.text = company;
}

- (void)setPositionToPositionLabelWithPosition:(NSString *)position
{
    UIView *line = (UIView *)[self viewWithTag:1];
    CGSize size = [position getSizeWithFont:FUCKFONT(10) Height:20];
    self.positionLabel.text = position;
    self.positionLabel.frame = CGRectMake(self.titleLabel.right+6, 0, size.width, size.height);
    self.positionLabel.bottom = self.titleLabel.bottom-2;
    line.frame = CGRectMake(0, 0, 0.5, size.height-2);
    line.center = CGPointMake(self.positionLabel.right+4, self.positionLabel.top+size.height/2);
}

- (void)setImageToHeaderViewWithURL:(NSURL *)URL
{
    [self.headerView sd_setImageWithURL:URL forState:UIControlStateNormal];
    
    self.headerView.frame = CGRectMake(kHEIGHT(10), kHEIGHT(10), kHEIGHT(22),kHEIGHT(22));
}

- (void)setNameToTitleLabelWithName:(NSString *)name
{
    self.titleLabel.text = name;
    CGSize size = [name getSizeWithFont:FUCKFONT(15) Height:20];
    self.titleLabel.frame = CGRectMake(0, 0, size.width, size.height);
    self.titleLabel.center = CGPointMake(self.headerView.right+10+size.width/2, self.headerView.top+self.headerView.height/2);
}

- (UIButton *)headerView
{
    if (!_headerView) {
        self.headerView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headerView.layer.cornerRadius = kHEIGHT(11);
        self.headerView.layer.masksToBounds = YES;
    }
    return _headerView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = kFONT(15);
    }
    return _titleLabel;
}

- (UILabel *)positionLabel
{
    if (!_positionLabel) {
        self.positionLabel = [[UILabel alloc]init];
        self.positionLabel.font = kFONT(10);
        self.positionLabel.textColor = RGB(127, 127, 127);
        UIView *line = [[UIView alloc]init];
        line.tag = 1;
        line.backgroundColor = RGB(127, 127, 127);
        [self addSubview:line];
    }
    return _positionLabel;
}

- (UILabel *)companyLabel
{
    if (!_companyLabel) {
        self.companyLabel = [[UILabel alloc]init];
        self.companyLabel.font = kFONT(10);
        self.companyLabel.textColor = RGB(127, 127, 127);
    }
    return _companyLabel;
}
//
//- (UILabel *)timeLabel
//{
//    if (!_timeLabel) {
//        self.timeLabel = [[UILabel alloc]init];
//        self.timeLabel.font = kFONT(12);
//        self.timeLabel.textColor = RGB(127, 127, 127);
//    }
//    return _timeLabel;
//}


@end
