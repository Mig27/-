//
//  WPBlackLIstCell.m
//  WP
//
//  Created by Kokia on 16/5/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPBlackLIstCell.h"

@interface WPBlackLIstCell()


@property (nonatomic,strong) UIButton *cover;


@end

@implementation WPBlackLIstCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    
    return self;
}


//重写set方法
-(void)setIsEditStatue:(BOOL)isEditStatue{
    _isEditStatue = isEditStatue;
    if (isEditStatue == YES) {
        self.button.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.icon.left = kHEIGHT(10)+kHEIGHT(10)+18;
            self.nameLabel.left = self.icon.right+10;
        }];
    }else{
        self.button.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.icon.left = kHEIGHT(10);
            self.nameLabel.left = self.icon.right+10;
        }];
    }
    
}

-(void)setIsSeleted:(BOOL)isSeleted{
    _isSeleted = isSeleted;
    if (isSeleted == YES) {
        self.button.selected = isSeleted;
    }else{
        self.button.selected = isSeleted;
    }
}

//- (void)buttonAction:(UIButton *)sender
//{
//    sender.selected = !sender.selected;
//    self.cover.selected = sender.selected;
//    self.model.selected = sender.selected;
////    self.check();
//    if ([self.delegate respondsToSelector:@selector(didSelectWPBlackLIstCell:)]) {
//        [self.delegate didSelectWPBlackLIstCell:self];
//    }
//}


- (void)createUI
{
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(50)/2 - kHEIGHT(32)/2, kHEIGHT(32), kHEIGHT(32))];
    self.icon.layer.cornerRadius = 5;
    self.icon.clipsToBounds = YES;
    [self.contentView addSubview:self.icon];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right + 10, kHEIGHT(50)/2 - 10, SCREEN_WIDTH - kHEIGHT(32) - 80, 20)];
    self.nameLabel.font = kFONT(15);
    [self.contentView addSubview:self.nameLabel];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
//    [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.button.userInteractionEnabled = NO;
    self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:self.button];
    self.button.frame = CGRectMake(0, 0, 40, kHEIGHT(50));
    [self.button setImageEdgeInsets:UIEdgeInsetsMake(0, kHEIGHT(10), 0, 0)];
    
    
//    [self.button  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView.mas_right);
//        make.centerY.height.equalTo(self.contentView);
//        make.width.equalTo(@100);
//    }];
    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"WPBlackLIstCell";
    WPBlackLIstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[WPBlackLIstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

- (void)setModel:(WPFriendModel *)model
{
    _model = model;
    NSString *imageUrl = [IPADDRESS stringByAppendingString:model.avatar];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    if (model.post_remark.length >0) {
        self.nameLabel.text = model.post_remark;
    }else{
        self.nameLabel.text = model.nick_name;
    }
    _isSeleted = model.selected;
    
}

+ (CGFloat)cellHeight
{
    return kHEIGHT(50);
}





@end
