//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  PickerImageView.m
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "MLPhotoPickerImageView.h"
#import "MLSelectPhotoCommon.h"

@interface MLPhotoPickerImageView ()

@property (nonatomic , weak) UIView *maskView;
@property (nonatomic , weak) UIImageView *tickImageView;
@property (nonatomic , weak) UIImageView *videoView;
@property (nonatomic, strong) UIButton * selectedBtn;


@end

@implementation MLPhotoPickerImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        
    }
    return self;
}

- (UIView *)maskView{
    if (!_maskView) {
        UIView *maskView = [[UIView alloc] init];
        maskView.frame = self.bounds;
        maskView.backgroundColor = [UIColor whiteColor];
        maskView.hidden = YES;
        [self addSubview:maskView];
        self.maskView = maskView;
    }
    return _maskView;
}

- (UIImageView *)videoView{
    if (!_videoView) {
        UIImageView *videoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.bounds.size.height - 40, 30, 30)];
        videoView.image = [UIImage imageNamed:MLSelectPhotoSrcName(@"video")];
        videoView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:videoView];
        self.videoView = videoView;
    }
    return _videoView;
}
-(UIButton*)selectedBtn
{
    if (!_selectedBtn) {
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _selectedBtn.backgroundColor = [UIColor redColor];
        _selectedBtn.frame = CGRectMake(self.bounds.size.width - 50, 4, 46, 46);
        [_selectedBtn addTarget:self action:@selector(tapIage:) forControlEvents:UIControlEventTouchUpInside];
//        _selectedBtn.backgroundColor = [UIColor redColor];
        
    }
    return _selectedBtn;
}
#pragma mark 改变图片选中的图片
- (UIImageView *)tickImageView{
    if (!_tickImageView) {
        UIImageView *tickImageView = [[UIImageView alloc] init];
        tickImageView.frame = CGRectMake(self.bounds.size.width - 22, 4, 18, 18);
        tickImageView.image = [UIImage imageNamed:@"tupian_xuanze"];//MLSelectPhotoSrcName(@"AssetsPickerChecked")
//        tickImageView.hidden = YES;
        [self addSubview:tickImageView];
        self.tickImageView = tickImageView;
        
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIage:)];
//        [self.tickImageView addGestureRecognizer:tap];
        
    }
    return _tickImageView;
}
//点击图片
-(void)tapIage:(UIButton*)tapGesture
{
    if (self.tapTickImage) {
        self.tapTickImage(self.indexPath);
    }
}

- (void)setIsVideoType:(BOOL)isVideoType{
    _isVideoType = isVideoType;
    
    self.videoView.hidden = !(isVideoType);
}

- (void)setMaskViewFlag:(BOOL)maskViewFlag{
    _maskViewFlag = maskViewFlag;
    self.animationRightTick = maskViewFlag;
}

- (void)setAnimationRightTick:(BOOL)animationRightTick{
    _animationRightTick = animationRightTick;
    
//    self.tickImageView.hidden = !animationRightTick;
    if (animationRightTick) {
        [self.tickImageView setImage:[UIImage imageNamed:@"tupian_xuanze_pre"]];
    }
    else
    {
        [self.tickImageView setImage:[UIImage imageNamed:@"tupian_xuanze"]];
    }
    
    
    
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    
    if (self.isVideoType) {
        [self.videoView.layer removeAllAnimations];
        [self.videoView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    }else{
        [self.tickImageView.layer removeAllAnimations];
        [self.tickImageView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    }
    
    [self addSubview:self.selectedBtn];
    
}
@end
