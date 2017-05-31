//
//  FriendCell.m
//  WP
//
//  Created by CBCCBC on 16/3/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "FriendCell.h"


#define kHeightForImage kHEIGHT(54)
#define CELL_WIDTH (SCREEN_WIDTH-18*5)/4
@interface FriendCell()
@property (nonatomic ,strong)UIImageView *imageView;
@property (nonatomic ,strong)UILabel *title;
@end
@implementation FriendCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.title];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_WIDTH)];
        self.imageView.layer.cornerRadius = 5;
        self.imageView.layer.masksToBounds = YES;
//        self.imageView.backgroundColor = [UIColor redColor];
    }
    return _imageView;
}

- (void)setModel:(WPFriendModel *)model
{
    self.title.text = model.nick_name;
    NSString *string = [IPADDRESS stringByAppendingString:model.avatar];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"head_default"]];
}

- (UILabel *)title
{
    if (!_title) {
        CGRect rect = [@"刘德华啊" boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFONT(12)} context:nil];
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(0), CELL_WIDTH+8, CELL_WIDTH, rect.size.height)];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.font = kFONT(12);
    }
    return _title;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = _image;
}

- (void)setName:(NSString *)name
{
    _name = name;
    self.title.text = _name;
}

@end
