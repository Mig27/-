//
//  WPDiscoverButton.m
//  WP
//
//  Created by Asuna on 15/5/22.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPDiscoverButton.h"
#import "WPBadgeButton.h"
#define MRTitleButtonImageW 17
#define MRMARGIN 13

@interface WPDiscoverButton()
@property (strong,nonatomic) WPBadgeButton *badgeButton;
@end

@implementation WPDiscoverButton
+ (instancetype)titleButton
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 高亮的时候不要自动调整图标
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.imageView.contentMode = UIViewAutoresizingNone;//UIViewContentModeCenter;
        self.imageView.layer.cornerRadius = 2;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.layer.cornerRadius = 0;
        
        // 背景
        [self setBackgroundColor:WPColor(255, 255, 255)];
        [self setBackgroundImage:[UIImage resizedImageWithName:@"discover_button"] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
//        // 添加一个提醒数字按钮
//        WPBadgeButton *badgeButton = [[WPBadgeButton alloc] init];
//        badgeButton.badgeValue = @"10";
//        badgeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
//        [self addSubview:badgeButton];
//        self.badgeButton = badgeButton;

    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = MRTitleButtonImageW;
    CGFloat imageH = MRTitleButtonImageW;
    
    CGFloat imageX = MRMARGIN;
    CGFloat imageY = MRMARGIN;
    return CGRectMake(imageX, imageY, imageW, imageH);
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = MRMARGIN ;
    CGFloat titleX = MRTitleButtonImageW + 2*MRMARGIN;
    CGFloat titleW = contentRect.size.width - titleX;
    CGFloat titleH = MRTitleButtonImageW;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

 - (void)layoutSubviews
{
  
//    self.badgeButton.frame  = CGRectMake(CGRectGetMaxX(self.imageView.frame)-7, CGRectGetMinY(self.imageView.frame)-7, 22, 18);
    [super layoutSubviews];
}
//- (void)setTitle:(NSString *)title forState:(UIControlState)state
//{
//    CGFloat titleWidth =  [title sizeWithFont:self.titleLabel.font].width;
//    
//    CGRect frame = self.frame;
//    frame.size.width = titleWidth + MRTitleButtonImageW + 5;
//    self.frame = frame;
//    
//    [super setTitle:title forState:state];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
