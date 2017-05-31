//
//  WPThreeBackView.m
//  WP
//
//  Created by CC on 16/9/14.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPThreeBackView.h"


@implementation WPThreeBackView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 3*kHEIGHT(57), kHEIGHT(32)-2)];
        backView.backgroundColor = [UIColor blackColor];
        backView.layer.cornerRadius = 5;
        backView.clipsToBounds = YES;
        [self addSubview:backView];
        
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(0, 0, kHEIGHT(57), kHEIGHT(32)-2);
        [_shareBtn setImage:[UIImage imageNamed:@"zhichangshuoshuo_fenxiang"] forState:UIControlStateNormal];
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = kFONT(12);
        [_shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
        [_shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:_shareBtn];
        
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.frame = CGRectMake(kHEIGHT(57), 0, kHEIGHT(57), kHEIGHT(32)-2);
        [_commentBtn setImage:[UIImage imageNamed:@"zhichangshuoshuo_pinglun"] forState:UIControlStateNormal];
        [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = kFONT(12);
        [_commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
        [_commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
        [_commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(clickCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:_commentBtn];
        
        _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _praiseBtn.frame = CGRectMake(2*kHEIGHT(57), 0, kHEIGHT(57), kHEIGHT(32)-2);
        [_praiseBtn setImage:[UIImage imageNamed:@"zhichangshuoshuo_zan"] forState:UIControlStateNormal];//zhichangshuoshuo_zan
        [_praiseBtn setTitle:@"赞" forState:UIControlStateNormal];
        _praiseBtn.titleLabel.font = kFONT(12);
        [_praiseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
        [_praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
        [_praiseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_praiseBtn addTarget:self action:@selector(clickPraiseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:_praiseBtn];
        
        for (int i = 0 ; i < 2; i++) {
            UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*kHEIGHT(57), (kHEIGHT(32)-18)/2, 0.5, 18)];
            line.backgroundColor = RGB(255, 255, 255);
            [backView addSubview:line];
        }
        
    }
    return self;
}
-(void)setIs_good:(NSString *)is_good
{
    if (is_good.intValue)
    {
        [_praiseBtn setTitle:@"取消" forState:UIControlStateNormal];
        _praiseBtn.selected = YES;
    }
    else
    {
       [_praiseBtn setTitle:@"赞" forState:UIControlStateNormal];
        _praiseBtn.selected = NO;
    }
}
#pragma mark 点击分享
-(void)clickShareBtn:(UIButton*)btn
{
    if (self.clickShareButton) {
        self.clickShareButton(self.indexpath);
    }
}
-(void)clickCommentBtn:(UIButton*)btn
{
    if (self.clickCommentButton) {
        self.clickCommentButton(self.indexpath);
    }
}
-(void)clickPraiseBtn:(UIButton*)btn
{
        [self popOutsideWithDuration:1.0 success:^(NSString*string) {
//            if (self.clickPraiseButton) {
//                self.clickPraiseButton(self.indexpath);
//            }
        }];
//    if (self.clickPraiseButton) {
//        self.clickPraiseButton(self.indexpath);
//    }
   
}


-(void)successBack
{
    if (self.clickPraiseButton) {
        self.clickPraiseButton(self.indexpath);
    }
}
- (void) popOutsideWithDuration: (NSTimeInterval) duringTime success:(void(^)(id))Success
{
    
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.5)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.5)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_praiseBtn.imageView.layer addAnimation:animation forKey:nil];
    [self performSelector:@selector(successBack) withObject:nil afterDelay:0.5];
    
//    __weak typeof(_praiseBtn) weakSelf = _praiseBtn;
//    self.transform = CGAffineTransformIdentity;
//    [UIView animateKeyframesWithDuration: duringTime delay: 0 options: 0 animations: ^{
//        [UIView addKeyframeWithRelativeStartTime: 0
//                                relativeDuration: 1/2.0
//                                      animations: ^{
//                                          typeof(_praiseBtn.imageView) strongSelf = weakSelf.imageView;
//                                          strongSelf.transform = CGAffineTransformMakeScale(1.7, 1.7);
//                                      }];
//        [UIView addKeyframeWithRelativeStartTime: 1/2.0
//                                relativeDuration: 1/2.0
//                                      animations: ^{
//                                          typeof(_praiseBtn.imageView) strongSelf = weakSelf.imageView;
//                                          strongSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                                      }];
//    } completion: ^(BOOL finished) {
//        Success(@"");
//    }];
}

//- (void) popInsideWithDuration: (NSTimeInterval) duringTime success:(void(^)(id))Success{
  //  __weak typeof(_praiseBtn) weakSelf = _praiseBtn;
  ////  self.transform = CGAffineTransformIdentity;
  //
  //  [UIView animateKeyframesWithDuration: duringTime delay: 0 options: 0 animations: ^{
   //     [weakSelf setImage: [UIImage imageNamed: @"zhichangshuoshuo_zan"] forState: UIControlStateNormal];
   //     [UIView addKeyframeWithRelativeStartTime: 0
   //                             relativeDuration: 1 / 2.0
   //                                   animations: ^{
   //                                       typeof(_praiseBtn.imageView) strongSelf = weakSelf.imageView;
   //                                       strongSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
   //                                   }];
   //     [UIView addKeyframeWithRelativeStartTime: 1 / 2.0
  //                              relativeDuration: 1 / 2.0
  //                                    animations: ^{
  //                                        typeof(_praiseBtn.imageView) strongSelf = weakSelf.imageView;
  //                                        strongSelf.transform = CGAffineTransformMakeScale(0.5, 0.5);
  //                                    }];
  //  } completion: ^(BOOL finished) {
//        _praiseBtn.selected = NO;
   //     Success(@"");
   // }];
    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
