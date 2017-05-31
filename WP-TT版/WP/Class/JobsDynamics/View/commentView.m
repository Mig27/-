//
//  commentView.m
//  WP
//
//  Created by 沈亮亮 on 15/6/18.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "commentView.h"

@interface commentView()


@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation commentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WPColor(73, 97, 156);
        [self addSubview:self.buttonGood];
        [self addSubview:self.imageView];
        [self addSubview:self.buttonComment];
        
    }
    return self;
}

-(void)commentClick:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(comment:)]) {
        [self.delegate comment:(int)sender.tag];
    }
   self.hidden = YES;
}

-(void)goodClick:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(good:)]) {
        [self.delegate good:(int)sender.tag];
    }
    self.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat commentX = 0;
    CGFloat commentY = 0;
    CGFloat commentWidth = self.frame.size.width/2 -1;
    CGFloat commentHeight = self.frame.size.height;
    
    self.buttonComment.frame = CGRectMake(commentX, commentY, commentWidth, commentHeight);
    
    self.imageView.frame = CGRectMake(commentWidth, 0, 2, commentHeight);
    
    CGFloat goodX = commentWidth +2;
    CGFloat goodY = 0;
    CGFloat goodWidth = commentWidth;
    CGFloat goodHeight = commentHeight;
    self.buttonGood.frame = CGRectMake(goodX, goodY, goodWidth, goodHeight);
}
//懒加载
- (UIButton *)buttonComment
{
    if (_buttonComment == nil) {
        _buttonComment = [[UIButton alloc]init];
        [_buttonComment setImage:[UIImage imageNamed:@"small_message"] forState:UIControlStateNormal];
        [_buttonComment setTitle:@"评论" forState:UIControlStateNormal];
        [_buttonComment addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchDown];
    }
    return _buttonComment;
}

- (UIButton *)buttonGood
{
    if (_buttonGood == nil) {
        _buttonGood = [[UIButton alloc]init];
        [_buttonGood setImage:[UIImage imageNamed:@"small_good"] forState:UIControlStateNormal];
        [_buttonGood setTitle:@"赞" forState:UIControlStateNormal];
        [_buttonGood addTarget:self action:@selector(goodClick:) forControlEvents:UIControlEventTouchDown];
    }
    return  _buttonGood;
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"small_bounds"]];
    }
    return _imageView;
}
@end
