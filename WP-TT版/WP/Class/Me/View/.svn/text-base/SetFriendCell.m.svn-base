//
//  SetFriendCell.m
//  WP
//
//  Created by CBCCBC on 16/3/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "SetFriendCell.h"

#define kHeightForImage kHEIGHT(32)

@interface SetFriendCell ()
@property (nonatomic, strong)UIImageView *imageview;
@property (nonatomic ,strong)UILabel *title;
@end

@implementation SetFriendCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.button];
        [self addSubview:self.imageview];
        [self addSubview:self.title];
    }
    return self;
}

- (UIImageView *)imageview
{
    if (!_imageview) {
        self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.button.right , (kHEIGHT(50)-kHEIGHT(32))/2, kHeightForImage, kHeightForImage)];
        self.imageview.layer.cornerRadius = 5;
        self.imageview.layer.masksToBounds = YES;
        //        self.imageView.backgroundColor = [UIColor redColor];
    }
    return _imageview;
}

- (UILabel *)title
{
    if (!_title) {
        self.title = [[UILabel alloc]init];
        self.title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (void)setModel:(WPFriendModel *)model
{
    _model = model;
    self.title.text = model.nick_name;
    CGRect rect = [model.nick_name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFONT(15)} context:nil];
    self.title.frame = CGRectMake(self.imageview.right+10, 0, rect.size.width, kHEIGHT(50));
    
    NSString *string = [IPADDRESS stringByAppendingString:model.avatar];
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    if ([model.canSelect isEqualToString:@"1"]) {
        [self.button setImage:[UIImage imageNamed:@"common_bukexuan"] forState:UIControlStateNormal];
    }
    
    self.button.selected = model.selected;
}



- (UIButton *)button
{
    if (!_button) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(0, 0, kHEIGHT(20)+18, kHEIGHT(50));
        [self.button setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
        
        //common_bukexuan
        self.button.userInteractionEnabled = NO;  // 不和cell的点击产生冲突
    }
    return _button;
}

- (void)buttonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.model.selected = sender.selected;
    if ([self.delegate respondsToSelector:@selector(didSelectSetFriendCell:)]) {
        [self.delegate didSelectSetFriendCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
