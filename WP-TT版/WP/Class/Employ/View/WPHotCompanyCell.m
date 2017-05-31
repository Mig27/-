//
//  WPHotCompanyCell.m
//  WP
//
//  Created by CBCCBC on 15/11/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPHotCompanyCell.h"
#import "Masonry.h"
#import "SPLabel.h"

@implementation WPHotCompanyCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH)/4+2, self.height+1)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        
        
        CGFloat width = (SCREEN_WIDTH)/4;
        CGSize siez = [@"哈哈哈ha..." sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
        
//        WS(ws);
        self.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)]];
//        _iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"activity_apply"]];
        _iconImageView = [[UIImageView alloc]init];
        [self addSubview:_iconImageView];
        _iconImageView.layer.cornerRadius = 5;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.frame = CGRectMake((width-kHEIGHT(45))/2, 20, kHEIGHT(45), kHEIGHT(45));
//        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@((width-kHEIGHT(45))/2));
//            make.width.height.equalTo(@(kHEIGHT(45)));
//            make.top.equalTo(@(20));
//        }];
        
        
        
        _titleLabel = [SPLabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.font = kFONT(12);
        [self addSubview:_titleLabel];
        _titleLabel.frame = CGRectMake((width-siez.width)/2, _iconImageView.bottom+6, siez.width, siez.height);
//        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_iconImageView.mas_bottom).offset(6);
//            make.centerX.equalTo(_iconImageView.mas_centerX);
//            make.width.equalTo(@(siez.width));
//            make.height.equalTo(@(siez.height));
//        }];

    }
    return self;
}

@end
