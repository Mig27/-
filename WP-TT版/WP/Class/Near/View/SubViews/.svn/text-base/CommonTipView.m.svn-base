//
//  CommonTipView.m
//  WP
//
//  Created by Kokia on 16/4/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "CommonTipView.h"

@interface CommonTipView ()

@property (nonatomic , strong)UILabel *label;

@property (nonatomic ,strong)UIImageView *imageView;

@end

@implementation CommonTipView


- (instancetype)init
{
    if ([super init]) {
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        self.userInteractionEnabled = NO;
    }
    
    return self;
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_tishi"]];
        self.imageView.frame = CGRectMake(0, 0, 10, 10);
    }
    
    return _imageView;
}

- (UILabel *)label
{
    if (!_label) {
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 10, 10)];
        self.label.textColor = RGB(255, 0, 0);
        self.label.font = kFONT(10);
    }
    return _label;
}


- (void)setTitle:(NSString *)title
{
    _title = title;
    self.label.text = title;
    CGSize size = [title getSizeWithFont:FUCKFONT(10) Height:10];
    
    self.imageView.center = CGPointMake(5, size.height/2);
    self.label.frame = CGRectMake(13, 0, size.width, size.height);
    
    

    CGPoint center = self.center;
    
    self.size = CGSizeMake(size.width+13, size.height);
    
    CGFloat x = SCREEN_WIDTH-8-16-8-(self.size.width/2);
    self.center = CGPointMake(x, center.y);
    
}




@end
