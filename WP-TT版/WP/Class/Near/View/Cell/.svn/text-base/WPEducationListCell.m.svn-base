//
//  WPEducationListCell.m
//  WP
//
//  Created by CBCCBC on 15/12/30.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPEducationListCell.h"

@implementation WPEducationListCellModel
@end

@interface WPEducationListCell ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *contentDetailLabel;
@property (nonatomic, strong) UIButton *button;

@end

@implementation WPEducationListCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentLabel = [UILabel new];
        self.contentLabel.font = kFONT(15);
        [self.contentView addSubview:self.contentLabel];
        self.contentLabel.frame = CGRectMake(0, 12, 300, 20);
//        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.equalTo(self.contentView).offset(12);
//        }];
        
        self.contentDetailLabel = [UILabel new];
        self.contentDetailLabel.font = kFONT(12);
        self.contentDetailLabel.textColor = RGB(127, 127, 127);
        [self.contentView addSubview:self.contentDetailLabel];
        self.contentDetailLabel.frame = CGRectMake(0, self.contentLabel.bottom, 300, 20);
//        [self.contentDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.contentLabel);
//            make.top.equalTo(self.contentLabel.mas_bottom);
//            make.bottom.equalTo(self.contentView).offset(-12);
//        }];
        
        self.button = [UIButton new];
        self.button.userInteractionEnabled = NO;
        self.button.frame = CGRectMake(0, 0, kHEIGHT(50), kHEIGHT(50));
        [self.button setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
        [self.button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.button setImageEdgeInsets:UIEdgeInsetsMake(0, kHEIGHT(10), 0, 0)];
        [self.contentView addSubview:self.button];
        self.button.hidden = YES;
        [self.button addTarget:self action:@selector(clickActions:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setEdit:(BOOL)edit
{
    _edit = edit;
    if (edit) {
        self.button.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentLabel.left = kHEIGHT(10)+kHEIGHT(10)+18;
            self.contentDetailLabel.left = kHEIGHT(10)+kHEIGHT(10)+18;
        }];
//        [self.contentView addSubview:self.button];
//        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentLabel.mas_right);
//            make.right.equalTo(self.contentView).offset(-10);
//            make.centerY.equalTo(self.contentView);
//            make.width.height.mas_equalTo(22);
//        }];
    }else{
        self.button.hidden= YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentLabel.left = kHEIGHT(10);
            self.contentDetailLabel.left = kHEIGHT(10);
        }];
//        [self.button removeFromSuperview];
    }
}

- (void)clickActions:(UIButton *)sender{
    sender.selected = !sender.selected;
    int num = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"numOfEducation"]] intValue];
    if (sender.selected) {
        num++;
    }
    else
    {
        num--;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",num] forKey:@"numOfEducation"];
    if (self.SelectedItemBlock) {
        self.SelectedItemBlock(self.indexPath,sender.selected);
    }
}

- (void)updateName:(NSString *)name Info:(NSString *)info isSelected:(BOOL)isSelected{
    self.contentLabel.text = name;
    self.contentDetailLabel.text = info;
    self.button.selected = isSelected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
