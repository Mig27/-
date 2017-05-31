//
//  GroupAlbumCommentAndPraise.m
//  WP
//
//  Created by CC on 16/9/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GroupAlbumCommentAndPraise.h"

@implementation GroupAlbumCommentAndPraise
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 2*kHEIGHT(57), kHEIGHT(32))];
        backView.backgroundColor = [UIColor blackColor];
        backView.layer.cornerRadius = 5;
        backView.clipsToBounds = YES;
        [self addSubview:backView];
        
        
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.frame = CGRectMake(0, 0, kHEIGHT(57), kHEIGHT(32));
        [_commentBtn setImage:[UIImage imageNamed:@"zhichangshuoshuo_pinglun"] forState:UIControlStateNormal];
        [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = kFONT(12);
        [_commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
        [_commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
        [_commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(clickCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:_commentBtn];
        
        _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _praiseBtn.frame = CGRectMake(kHEIGHT(57), 0, kHEIGHT(57), kHEIGHT(32));
        [_praiseBtn setImage:[UIImage imageNamed:@"zhichangshuoshuo_zan"] forState:UIControlStateNormal];
        [_praiseBtn setTitle:@"赞" forState:UIControlStateNormal];
        _praiseBtn.titleLabel.font = kFONT(12);
        [_praiseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
        [_praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
        [_praiseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_praiseBtn addTarget:self action:@selector(clickPraiseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:_praiseBtn];
        
        
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(57), (kHEIGHT(32)-18)/2, 0.5, 18)];
        line.backgroundColor = RGB(255, 255, 255);
        [backView addSubview:line];
    }
    return self;
}

-(void)setIsGood:(NSString *)isGood
{
    if (isGood.intValue) {
        [_praiseBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    else
    {
        [_praiseBtn setTitle:@"赞" forState:UIControlStateNormal];
    }
}
-(void)clickCommentBtn:(UIButton*)sender
{
    if (self.clickCommentBtn) {
        self.clickCommentBtn(self.indexpath);
    }
}
-(void)clickPraiseBtn:(UIButton*)sender
{
//    if (self.clickPraiseBtn) {
//        self.clickPraiseBtn(self.indexpath);
//    }
    
    [self popOutsideWithDuration:1.0 success:^(NSString * string) {
//        if (self.clickPraiseBtn) {
//            self.clickPraiseBtn(self.indexpath);
//        }
    }];
}
-(void)successBack
{
    if (self.clickPraiseBtn) {
        self.clickPraiseBtn(self.indexpath);
    }
}
- (void) popOutsideWithDuration: (NSTimeInterval) duringTime success:(void(^)(id))Success{
    
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
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
