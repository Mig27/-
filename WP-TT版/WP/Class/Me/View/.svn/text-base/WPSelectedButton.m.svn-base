//
//  WPSelectedButton.m
//  WP
//
//  Created by CBCCBC on 16/3/29.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPSelectedButton.h"

@interface WPSelectedButton ()


@end

@implementation WPSelectedButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
       
            [self addSubview:self.selected];
            [self addSubview:self.delete];
        [self addSubview:self.numLabel];
        self.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [self addSubview:line];
    }
    return self;
}

- (UIButton *)selected{
    if (!_selected) {
        self.selected = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selected.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, 49);
        [self.selected setTitle:@"全选" forState:UIControlStateNormal];
        self.selected.contentEdgeInsets = UIEdgeInsetsMake(0, kHEIGHT(12), 0, 0);
        self.selected.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.selected setTitle:@"取消全选" forState:UIControlStateSelected];
        [self.selected setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.selected.titleLabel.font = kFONT(15);
    }
    return _selected;
}

- (void)setDeleteTarget:(id)deleteTarget deleteAction:(SEL)deleteAction
{
    [self.delete addTarget:deleteTarget action:deleteAction forControlEvents:UIControlEventTouchDown];
}

- (void)setSelectedTarget:(id)selectedTarget selectedAction:(SEL)selectedAction
{
    [self.selected addTarget:selectedTarget action:selectedAction forControlEvents:UIControlEventTouchDown];
}

- (UIButton *)delete{
    if (!_delete) {
        self.delete = [UIButton buttonWithType:UIButtonTypeCustom];
        self.delete.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(20)-30, 0, kHEIGHT(20)+30, 49);
//        [self.delete setBackgroundColor: [UIColor redColor]];
        [self.delete setTitle:@"删除" forState:UIControlStateNormal];
        self.delete.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kHEIGHT(10));
        self.delete.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.delete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.delete setTitleColor:RGB(0, 172, 255) forState:UIControlStateSelected];
        self.delete.titleLabel.font = kFONT(15);
    }
    return _delete;
}

-(UILabel*)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.delete.frame.origin.x-49/2, (49-49/2)/2, 49/2, 49/2)];
        _numLabel.layer.cornerRadius = 49/4;
        _numLabel.clipsToBounds = YES;
        _numLabel.backgroundColor = RGB(0, 172, 255);
        _numLabel.hidden = YES;
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.textColor = [UIColor whiteColor];
        
        [_numLabel.layer removeAllAnimations];
        CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaoleAnimation.duration = 0.25;
        scaoleAnimation.autoreverses = YES;
        scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
        scaoleAnimation.fillMode = kCAFillModeForwards;
        [_numLabel.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
        
    }
    else
    {
        [_numLabel.layer removeAllAnimations];
        CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaoleAnimation.duration = 0.25;
        scaoleAnimation.autoreverses = YES;
        scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
        scaoleAnimation.fillMode = kCAFillModeForwards;
        [_numLabel.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    
    }
    return _numLabel;
}
@end
