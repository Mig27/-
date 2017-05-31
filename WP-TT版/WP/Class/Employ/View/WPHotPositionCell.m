//
//  WPHotPositionCell.m
//  WP
//
//  Created by CBCCBC on 15/11/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPHotPositionCell.h"
#import "SPLabel.h"

@implementation WPHotPositionCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        WS(ws);
        
         CGSize siez = [@"哈哈哈哈哈哈..." sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
        
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)]];
//        _iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"activity_apply"]];
////        _iconImageView.frame = CGRectMake(10, self.height/2-10, 20, 20);
//        [self addSubview:_iconImageView];
////        _iconImageView .layer.cornerRadius = 5;
////        _iconImageView .layer.masksToBounds = YES;
//        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@(kHEIGHT(10)));
//            make.centerY.equalTo(ws);
//            make.width.height.equalTo(@(kHEIGHT(15)));
//        }];
        
        _titleLabel = [[SPLabel alloc]init];
        _titleLabel.font = kFONT(13);
//        _titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.frame = CGRectMake(((SCREEN_WIDTH/3)-siez.width)/2, (kHEIGHT(43)-siez.height)/2, siez.width, siez.height);
        [self addSubview:_titleLabel];

//        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_iconImageView.mas_right).offset(10);
//            make.top.right.height.equalTo(ws);
//        }];

    }
    return self;
}

@end
