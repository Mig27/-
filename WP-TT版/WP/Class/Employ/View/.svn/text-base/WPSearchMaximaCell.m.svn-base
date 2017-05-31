//
//  WPSearchMaximaCell.m
//  WP
//
//  Created by CBCCBC on 15/11/19.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPSearchMaximaCell.h"
#import "WPSearchMaximaModel.h"
#import "WPRecommendYourselfModel.h"
#import "UIImageView+WebCache.h"
#import "SPLabel.h"

#define CellHeight kHEIGHT(71)

@interface WPSearchMaximaCell ()

@property (strong ,nonatomic) UIImageView *iconImageView;/**<头像 */
@property (strong ,nonatomic) UIImageView *arrowImageView;/**< 箭头图片 */
@property (strong ,nonatomic) UIImageView *stateImageView;/**< 状态图片 */
@property (strong, nonatomic) SPLabel *positionLabel;/**< 职位 */
@property (strong, nonatomic) SPLabel *salaryLabel;/**< 工资 */
@property (strong, nonatomic) SPLabel *comapnyLabel;/**< 公司 */
@property (strong, nonatomic) SPLabel *timeLabel;/**< 时间 */


@end

@implementation WPSearchMaximaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)]];
        
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

- (void)iconClick{
    if (self.cellIndexPathClick) {
        self.cellIndexPathClick(self.indexPath);
    }
}

//- (void)detailClick{
//    if (self.detailBlock) {
//        self.detailBlock(self.indexPath);
//    }
//}

- (void)setModel:(NSObject *)model{
    if ([model isKindOfClass:[WPSearchMaximaListModel class]]) {
        WPSearchMaximaListModel* listModel  = (WPSearchMaximaListModel *)model;
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.logo]];
        [_iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
        _positionLabel.text = [@"招聘:" stringByAppendingString:listModel.jobPositon];
        _salaryLabel.text = listModel.salary;
        _timeLabel.text = listModel.distanceTime;
        _comapnyLabel.text = listModel.epName;
        _stateImageView.frame = CGRectMake(_arrowImageView.left-32-4, CellHeight/2-7.5, 32, 15);
        _stateImageView.image = [UIImage imageNamed:@"baoming"];
    }
    if ([model isKindOfClass:[WPRecommendYourselfListModel class]]) {
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
}

+ (instancetype)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"WPSearchMaximaCell";
    WPSearchMaximaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WPSearchMaximaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.indexPath = indexPath;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
