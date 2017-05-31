//
//  WPInterViewOneCell.m
//  WP
//
//  Created by CBCCBC on 15/9/18.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPInterViewTCell.h"
#import "UIImageView+WebCache.h"

@interface WPInterViewTCell ()

//@property (strong, nonatomic) WPInterviewModel *interviewModel;

@end

@implementation WPInterViewTCell

- (void)awakeFromNib {
    // Initialization code
}

#define CellHeight kHEIGHT(58)

/**
 此方法会在使用纯代码创建Cell时被调用
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)]];
        
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
        
        _nameLable = [[SPLabel alloc]initWithFrame:CGRectMake(_iconImage.right+10, _iconImage.top, SCREEN_WIDTH-120, _iconImage.height/2)];
        _nameLable.text = @"招聘：快递员 分类员";
        _nameLable.font = kFONT(15);
//        _nameLable.backgroundColor = [UIColor redColor];
//        _nameLable.verticalAlignment = VerticalAlignmentBottom;
        [self.contentView addSubview:_nameLable];
        
        _detailLable = [[SPLabel alloc]initWithFrame:CGRectMake(_iconImage.right+10, _nameLable.bottom+8, SCREEN_WIDTH-200, 15)];
        _detailLable.font = kFONT(12);
        _detailLable.text = @"合肥莱达商贸有限公司";
        _detailLable.textColor = RGB(153, 153, 153);
//        _detailLable.backgroundColor = [UIColor blueColor];
//        _detailLable.verticalAlignment = VerticalAlignmentTop;
        [self.contentView addSubview:_detailLable];
        
        _buttonArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonArrow.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-8, CellHeight/2-7, 8, 14);
        [_buttonArrow setImage:[UIImage imageNamed:@"jinru"] forState:UIControlStateNormal];
        [self addSubview:_buttonArrow];
        _imageAgainst = [[UIImageView alloc]initWithFrame:CGRectMake(_buttonArrow.left-13-4, CellHeight/2-7.5, 15, 15)];
        _imageAgainst.image = [UIImage imageNamed:@"qiang"];
        [self addSubview:_imageAgainst];
        
        _timeLable = [[SPLabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60-kHEIGHT(10), _imageAgainst.bottom+3, 60, 15)];
        _timeLable.textAlignment = NSTextAlignmentRight;
        _timeLable.textColor = RGB(153, 153, 153);
        _timeLable.font = kFONT(10);
        _timeLable.text = @"17分钟前";
        [self addSubview:_timeLable];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, CellHeight-0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [self addSubview:line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setModel:(WPInterviewListModel *)model
{
//    self.iconImage.image = [UIImage imageNamed:model.avatar];
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
    [self.iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
    self.nameLable.text = [@"求职:" stringByAppendingString:model.HopePosition];
    self.detailLable.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",model.name,model.sex,model.birthday,model.education,model.WorkTim];
    self.timeLable.text = model.updateTime;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"WPInterViewTCell";
    WPInterViewTCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        // 注意可重用标示符需要在XIB中指定
        //        cell = [[[NSBundle mainBundle] loadNibNamed:@"UIEmployOneCell" owner:nil options:nil] lastObject];
        cell = [[WPInterViewTCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(void)iconClick
{
    if (self.cellIndexPathClick) {
        self.cellIndexPathClick(self.path);
    }
}

@end
