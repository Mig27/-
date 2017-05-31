//
//  WPNewFullSearchCell.m
//  WP
//
//  Created by CBCCBC on 16/1/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPNewFullSearchCell.h"
#import "WPSearchMaximaModel.h"
#import "WPRecommendYourselfModel.h"
#import "UIImageView+WebCache.h"
#import "SPLabel.h"
#import "WPNewSearchResumeModel.h"

#define CellHeight kHEIGHT(71)

@interface WPNewFullSearchCell ()

@property (strong ,nonatomic) UIImageView *iconImageView;/**<头像 */
@property (strong ,nonatomic) UIImageView *arrowImageView;/**< 箭头图片 */
@property (strong ,nonatomic) UIImageView *stateImageView;/**< 状态图片 */
@property (strong, nonatomic) SPLabel *positionLabel;/**< 职位 */
@property (strong, nonatomic) SPLabel *salaryLabel;/**< 工资 */
@property (strong, nonatomic) SPLabel *comapnyLabel;/**< 公司 */
@property (strong, nonatomic) SPLabel *timeLabel;/**< 时间 */

@end

@implementation WPNewFullSearchCell
{
    UIImageView *_selectedImageView;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)]];
        
        _selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10), CellHeight/2-12.5, 25, 25)];
        _selectedImageView.hidden = YES;
        [self.contentView addSubview:_selectedImageView];
        
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10),(CellHeight-kHEIGHT(57))/2, kHEIGHT(57), kHEIGHT(57))];
        _iconImageView.image = [UIImage imageNamed:@"head_default"];
        _iconImageView.layer.cornerRadius = 5;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.borderColor = RGB(226, 226, 226).CGColor;
        _iconImageView.layer.borderWidth = 0.5;
        [self addSubview:_iconImageView];
        
        //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //button.frame = _iconImageView.frame;
        //[button addTarget:self action:@selector(iconClick) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:button];
        
        _positionLabel = [[SPLabel alloc]initWithFrame:CGRectMake(_iconImageView.right+10, _iconImageView.top, SCREEN_WIDTH-120, _iconImageView.height/3)];
        _positionLabel.text = @"寻求：总经理";
        _positionLabel.font = kFONT(15);
        [self addSubview:_positionLabel];
        
        _salaryLabel = [[SPLabel alloc]initWithFrame:CGRectMake(_iconImageView.right+10, _positionLabel.bottom, SCREEN_WIDTH-200, _iconImageView.height/3)];
        _salaryLabel.font = kFONT(14);
        _salaryLabel.text = @"50-60万";
        _salaryLabel.textColor = RGB(36, 140, 245);
        [self addSubview:_salaryLabel];
        
        _comapnyLabel = [[SPLabel alloc]initWithFrame:CGRectMake(_iconImageView.right+10, _salaryLabel.bottom, SCREEN_WIDTH-200, _iconImageView.height/3)];
        _comapnyLabel.font = kFONT(12);
        _comapnyLabel.text = @"合肥莱达商贸有限公司";
        _comapnyLabel.textColor = RGB(153, 153, 153);
        [self addSubview:_comapnyLabel];
        
        //        UIButton *companyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        companyButton.frame = _comapnyLabel.frame;
        //        [companyButton addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
        //        [self addSubview:companyButton];
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-8, CellHeight/2-7, 8, 14)];
        _arrowImageView.image = [UIImage imageNamed:@"jinru"];
        [self addSubview:_arrowImageView];
        _stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_arrowImageView.left-32-4, CellHeight/2-7.5, 32, 15)];
        _stateImageView.image = [UIImage imageNamed:@"baoming"];
        [self addSubview:_stateImageView];
        
        _timeLabel = [[SPLabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60-kHEIGHT(10), _stateImageView.bottom+3, 60, 15)];
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

- (void)setModel:(NSObject *)model{
    WPNewSearchResumeListModel *listModel = (WPNewSearchResumeListModel *)model;
    if (listModel.type == WPMainPositionTypeRecruit) {
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.logo]];
        [_iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
        _positionLabel.text = [@"招聘:" stringByAppendingString:listModel.jobPositon];
        _salaryLabel.text = listModel.salary;
        _timeLabel.text = listModel.distanceTime;
        _comapnyLabel.text = listModel.epName;
        _stateImageView.frame = CGRectMake(_arrowImageView.left-32-4, CellHeight/2-7.5, 32, 15);
        _stateImageView.image = [UIImage imageNamed:@"baoming"];
    }
    if (listModel.type == WPMainPositionTypeInterView) {
        WPRecommendYourselfListModel* listModel  = (WPRecommendYourselfListModel *)model;
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.avatar]];
        [_iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
        _positionLabel.text = [@"求职:" stringByAppendingString:listModel.HopePosition];
        _salaryLabel.text = listModel.hopeSalary;
        _timeLabel.text = listModel.distanceTime;
        _comapnyLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",listModel.name,listModel.sex,listModel.education,listModel.WorkTime];
        _stateImageView.frame = CGRectMake(_arrowImageView.left-13-4, CellHeight/2-6.5, 13, 13);
        _stateImageView.image = [UIImage imageNamed:@"qiang"];
    }
    _selectedImageView.image = [UIImage imageNamed:listModel.isSelected?@"userinfo_selected":@"userinfo_unselected"];
}

- (void)exchangeSubViewFrame:(BOOL)isEdit{
    
    CGFloat y = isEdit?(kHEIGHT(10)*2+25):kHEIGHT(10);
    
    [UIView animateWithDuration:0.1 animations:^{
        
        _iconImageView.left = y;
        _positionLabel.left = _iconImageView.right+10;
        _comapnyLabel.left = _iconImageView.right+10;
        _salaryLabel.left = _iconImageView.right+10;
        _selectedImageView.hidden = !isEdit;
    }];
}

@end
