//
//  UIEmployOneCell.m
//  WP
//
//  Created by Asuna on 15/5/21.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPRecruitTCell.h"
#import "UIImageView+WebCache.h"
#import "WPSchoolRecruitModel.h"

@implementation WPRecruitTCell

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
        
        _nameLable = [[SPLabel alloc]initWithFrame:CGRectMake(_iconImage.right+10, _iconImage.top, SCREEN_WIDTH-60-_iconImage.right-10, _iconImage.height/2)];
        _nameLable.text = @"招聘：快递员 分类员";
        _nameLable.font = kFONT(15);
//        _nameLable.verticalAlignment = VerticalAlignmentBottom;
//        _nameLable.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:_nameLable];
        
        _detailLable = [[SPLabel alloc]initWithFrame:CGRectMake(_iconImage.right+10, _nameLable.bottom+8, SCREEN_WIDTH-120, 15)];
        _detailLable.font = kFONT(12);
        _detailLable.text = @"合肥莱达商贸有限公司";
        _detailLable.textColor = RGB(153, 153, 153);
        [self.contentView addSubview:_detailLable];

//        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
////        _detailBtn.backgroundColor = [UIColor lightGrayColor];
//        _detailBtn.frame = CGRectMake(_iconImage.right+10, _nameLable.bottom, SCREEN_WIDTH-_iconImage.right-10,_iconImage.height/2);
//        _detailBtn.titleLabel.font = kFONT(12);
//        [_detailBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
////        [_detailBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
//        [_detailBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
////        [_detailBtn addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_detailBtn];
        
        _buttonArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonArrow.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-8, CellHeight/2-7, 8, 14);
        [_buttonArrow setImage:[UIImage imageNamed:@"jinru"] forState:UIControlStateNormal];
        [self addSubview:_buttonArrow];
        _imageAgainst = [[UIImageView alloc]initWithFrame:CGRectMake(_buttonArrow.left-32-4, CellHeight/2-7.5, 32, 15)];
        _imageAgainst.image = [UIImage imageNamed:@"baoming"];
        [self addSubview:_imageAgainst];
        
        _timeLable = [[SPLabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60-kHEIGHT(10), _imageAgainst.bottom+3, 60, 15)];
        _timeLable.textAlignment = NSTextAlignmentRight;
        _timeLable.textColor = RGB(153, 153, 153);
        _timeLable.font = kFONT(10);
        _timeLable.text = @"12-21";
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

- (void)setModel:(NSObject *)model
{
    if ([model isKindOfClass:[WPRecruitListModel class]]) {
        WPRecruitListModel *listModel = (WPRecruitListModel *)model;
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.logo]];
    [self.iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
        self.nameLable.text = [@"招聘:" stringByAppendingString:listModel.jobPositon];
    self.detailLable.text = listModel.enterpriseName;
//    [self.detailBtn setTitle:listModel.enterpriseName forState:UIControlStateNormal];
    self.timeLable.text = listModel.updateTime;
    }
    if ([model isKindOfClass:[WPSchoolRecruitListModel class]]) {
        
        _imageAgainst.hidden = YES;
        _timeLable.hidden = YES;
        
        WPSchoolRecruitListModel *listModel = (WPSchoolRecruitListModel *)model;
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.logo]];
        [self.iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
        self.nameLable.text = [@"招聘:" stringByAppendingString:listModel.enterprise_name];
            self.detailLable.text = [NSString stringWithFormat:@"%@个岗位    %@人查看",listModel.jobNumber,listModel.lookCount];
//        [self.detailBtn setTitle:[NSString stringWithFormat:@"%@个岗位    %@人查看",listModel.jobNumber,listModel.lookCount] forState:UIControlStateNormal];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"WPRecruitTCell";
    WPRecruitTCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        // 注意可重用标示符需要在XIB中指定
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"UIEmployOneCell" owner:nil options:nil] lastObject];
        cell = [[WPRecruitTCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}
-(void)layoutSubviews
{
    [super layoutSubviews];

}

- (void)detailClick
{
    if (self.detailBlock) {
        self.detailBlock(self.path);
    }
}

-(void)iconClick
{
    if (self.cellIndexPathClick) {
        self.cellIndexPathClick(self.path);
    }
}

+ (CGFloat)rowHeight
{
    return 58;
}

@end
