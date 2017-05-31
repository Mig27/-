//
//  TTChatPlusCell.m
//  WP
//
//  Created by CC on 16/6/15.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "TTChatPlusCell.h"

@interface TTChatPlusCell()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *iconName;

@end

@implementation TTChatPlusCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.autoresizesSubviews = YES;
        [self createUI];
    }
    
    return self;
}

-(void)createUI{
    [self addSubview:_imageView];
    [self addSubview:_iconName];
}


-(void)setModel:(WPChatPlusModel *)model
{
    _model = model;
    [self.imageView setImage:[UIImage imageNamed:model.icon]];
    self.iconName.text = model.iconname;
}

-(UILabel *)iconName{
    if (!_iconName) {
        _iconName = [[UILabel alloc] init];
        _iconName.textColor = RGB(127, 127, 127);
        _iconName.font = kFONT(12);
        [self.contentView addSubview:_iconName];
        [_iconName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_bottom).with.offset(kHEIGHT(10));
            make.centerX.equalTo(_imageView);
        }];
    }
    return _iconName;
}



- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView.mas_centerY).with.offset(-kHEIGHT(5));
        }];
    }
    return _imageView;
}



@end
