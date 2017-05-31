//
//  WPRecruitApplyCell.m
//  WP
//
//  Created by CBCCBC on 15/11/9.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPRecruitApplyCell.h"
#import "UIImageView+WebCache.h"
#import "WPRecruitApplyChooseModel.h"
#import "WPInterviewApplyChooseModel.h"

#define CellHeight kHEIGHT(58)
#define EditTag 104
#define ChooseTag 105

@implementation WPRecruitApplyCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)]];
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10),(CellHeight-kHEIGHT(43))/2, kHEIGHT(43), kHEIGHT(43))];
        _iconImage.image = [UIImage imageNamed:@"head_default"];
        _iconImage.layer.cornerRadius = 5;
        _iconImage.clipsToBounds = YES;
        _iconImage.layer.borderColor = RGB(226, 226, 226).CGColor;
        _iconImage.layer.borderWidth = 0.5;
        [self addSubview:_iconImage];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = _iconImage.frame;
        [button addTarget:self action:@selector(iconClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        _nameLable = [[SPLabel alloc]initWithFrame:CGRectMake(_iconImage.right+10, _iconImage.top, SCREEN_WIDTH-120, _iconImage.height/2)];
        _nameLable.text = @"招聘：快递员 分类员";
        _nameLable.font = kFONT(15);
        _nameLable.verticalAlignment = VerticalAlignmentBottom;
        [self addSubview:_nameLable];
        
        _detailLable = [[SPLabel alloc]initWithFrame:CGRectMake(_iconImage.right+10, _nameLable.bottom+8, SCREEN_WIDTH-200, 15)];
        _detailLable.font = kFONT(12);
        _detailLable.text = @"合肥莱达商贸有限公司";
        _detailLable.textColor = RGB(127, 127, 127);
        _detailLable.verticalAlignment = VerticalAlignmentTop;
        [self addSubview:_detailLable];
        
        self.buttonArrow = [UIButton buttonWithType:UIButtonTypeCustom];
//        _buttonArrow.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-18, CellHeight/2-9, 18, 18);
//        [_buttonArrow setImage:[UIImage imageNamed:@"userinfo_unselected"] forState:UIControlStateNormal];
//        [_buttonArrow setImage:[UIImage imageNamed:@"userinfo_selected"] forState:UIControlStateSelected];
//        [self addSubview:_buttonArrow];
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.buttonArrow.titleLabel.font = kFONT(13);
        self.buttonArrow.tag = ChooseTag;
        self.buttonArrow.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(44), GetHeight(0), kHEIGHT(44), kHEIGHT(58));
        [self.buttonArrow setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.buttonArrow setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kHEIGHT(12))];
        [self.buttonArrow setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];//userinfo_unselected
        [self.buttonArrow setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];//userinfo_selected
        [self.buttonArrow setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        [self.buttonArrow setImage:[UIImage imageNamed:@"gray_background"] forState:UIControlStateHighlighted];
        [self.buttonArrow addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.buttonArrow];
    }
    return self;
}

- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag == EditTag) {
        sender.selected = !sender.selected;
    }
    if (sender.tag == ChooseTag) {
        sender.selected = !sender.selected;
        if (self.ChooseCurrentRecruitApplyBlock) {
            self.ChooseCurrentRecruitApplyBlock(self.tag);
        }
    }
}

-(void)setModel:(NSObject *)model
{
    if ([model isKindOfClass:[WPRecruitApplyChooseListModel class]]) {
        WPRecruitApplyChooseListModel *listModel = (WPRecruitApplyChooseListModel*)model;
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.avatar]];
        [self.iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
        self.nameLable.text = listModel.postion;
        self.detailLable.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",listModel.name,listModel.sex,listModel.age,listModel.education,listModel.WorkTime];
        self.imageAgainst.image = listModel.itemIsSelected?[UIImage imageNamed:@"common_xuanzhong"]:[UIImage imageNamed:@"common_xuanze"];
        UIButton *button = (UIButton *)[self viewWithTag:ChooseTag];
        button.selected = listModel.itemIsSelected;
    }else{
        WPInterviewApplyListModel *listModel = (WPInterviewApplyListModel*)model;
        NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:listModel.avatar]];
        [self.iconImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
        self.nameLable.text = [NSString stringWithFormat:@"招聘 : %@",listModel.postion];
        self.detailLable.text = listModel.ep_name;
        self.imageAgainst.image = listModel.itemIsSelected?[UIImage imageNamed:@"common_xuanzhong"]:[UIImage imageNamed:@"common_xuanze"];
        UIButton *button = (UIButton *)[self viewWithTag:ChooseTag];
        button.selected = listModel.itemIsSelected;
    }
    
}

//+(instancetype)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *ID = @"WPRecruitApplyCell";
//    
//    WPRecruitApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    
//    cell.tag = indexPath.row+1;
//    
//    if (cell == nil) {
//        // 注意可重用标示符需要在XIB中指定
//        cell = [[WPRecruitApplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    
//    return cell;
//}

-(void)iconClick
{
    if (self.cellIndexPathClick) {
        self.cellIndexPathClick(self.path);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
