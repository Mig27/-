//
//  ButtonMenuTableViewCell.m
//  WP
//
//  Created by 沈亮亮 on 15/11/4.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "ButtonMenuTableViewCell.h"


@implementation ButtonMenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGSize normalSize = [@"好友圈动" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kHEIGHT(43)/2-10, SCREEN_WIDTH - 100, 20)];
        self.titleLabel.font = kFONT(15);
        self.titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLabel];
        
        self.redDot = [[UIImageView alloc] initWithFrame:CGRectMake(10+normalSize.width+2, self.titleLabel.top -3, 8, 8)];
        self.redDot.image = [UIImage imageNamed:@"discover_badgebutton"];
        self.redDot.hidden = YES;
        [self.contentView addSubview:self.redDot];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.right, kHEIGHT(43)/2 - 10, SCREEN_WIDTH - normalSize.width - 20 - 16, 20)];
        self.timeLabel.textColor = kLightColor;
        self.timeLabel.font = kFONT(12);
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLabel];
        
//        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];

        _tipView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - kHEIGHT(100)/2, kHEIGHT(43)/2 - kHEIGHT(27)/2, kHEIGHT(100), kHEIGHT(27))];
        _tipView.backgroundColor = RGB(39, 39, 39);
        
        _tipView.clipsToBounds = YES;
        _tipView.layer.cornerRadius = 5;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, kHEIGHT(27)/2-kHEIGHT(21)/2, kHEIGHT(21), kHEIGHT(21))];
//        imageView.backgroundColor = [UIColor redColor];
        imageView.image = [UIImage imageNamed:@"small_cell_picture"];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 5;
        [_tipView addSubview:imageView];
        
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(100) - 3 - 6, kHEIGHT(27)/2 - 6, 6, 12)];
        rightImageView.image = [UIImage imageNamed:@"jinru"];
        [_tipView addSubview:rightImageView];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right, 0, kHEIGHT(100) - 2 - kHEIGHT(21) - 3 -6 -6, kHEIGHT(27))];
        tipLabel.font = kFONT(10);
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.textAlignment = NSTextAlignmentRight;
        tipLabel.text = @"26条新消息";
        [_tipView addSubview:tipLabel];
        
//        self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(32)-kHEIGHT(12), (kHEIGHT(43)-kHEIGHT(32))/2, kHEIGHT(32), kHEIGHT(32))];
//        self.iconImage.layer.cornerRadius = 5;
//        self.iconImage.clipsToBounds = YES;
//        [self.contentView addSubview:self.iconImage];
        
        
//        [self.contentView addSubview:self.tipView];
//        self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 18, kHEIGHT(43)/2 - 7, 8, 14)];
//        self.rightImageView.image = [UIImage imageNamed:@"jinru"];
//        self.rightImageView.hidden = YES;
//        [self.contentView addSubview:self.rightImageView];
    }
    return self;
}

//- (UIView*)tipView
//{
//    if (!_tipView) {
//        _tipView.centerX = SCREEN_WIDTH/2;
//        _tipView.centerX = kHEIGHT(43)/2;
//    }
//    
//    return _tipView;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
