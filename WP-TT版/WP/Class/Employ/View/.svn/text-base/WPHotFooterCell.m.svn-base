//
//  WPHotFooterCell.m
//  WP
//
//  Created by CBCCBC on 15/11/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPHotFooterCell.h"
#import "SPLabel.h"

@implementation WPHotFooterCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        WS(ws);
        self.backgroundColor = RGB(235, 235, 235);
        _titleButton = [[UIButton alloc]init];
        _titleButton.titleLabel.font = kFONT(13);
        [self addSubview:_titleButton];
        
        _titleButton.backgroundColor = [UIColor whiteColor];
        [_titleButton setTitle:@"查看全部" forState:UIControlStateNormal];
        [_titleButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
        [_titleButton setBackgroundImage:[UIImage imageNamed:@"gray_background"] forState:UIControlStateHighlighted];
        [_titleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_titleButton addTarget:self action:@selector(checkAllDataClick:) forControlEvents:UIControlEventTouchUpInside];
//        _titleButton.frame = CGRectMake(0, 0.5, self.width, kHEIGHT(38));
        
        [_titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(ws);
            make.top.equalTo(ws).offset(0.5);
            if (ws.height != 10) {
              make.height.equalTo(ws);
            }else{
                make.height.equalTo(@(0.5));
            }
        }];
    }
    return self;
}
-(void)setIsFoot:(BOOL)isFoot
{
    if (isFoot) {
//        CGRect rect = _titleButton.frame;
//        rect.size.height -= 8;
//        _titleButton.frame = rect;
        
//        [_titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self);
//            make.top.equalTo(self).offset(0.5);
//            if (self.height != 10) {
//                make.height.equalTo(self).offset(-8);
//            }else{
//                make.height.equalTo(@(0.5));
//            }
//        }];
    }
    else
    {
//        CGRect rect = _titleButton.frame;
//        rect.size.height -= self.height;
//        _titleButton.frame = rect;
        
        
//        [_titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self);
//            make.top.equalTo(self).offset(0.5);
//            if (self.height != 10) {
//                make.height.equalTo(self);
//            }else{
//                make.height.equalTo(@(0.5));
//            }
//        }];
    }
}
- (void)checkAllDataClick:(UIButton *)sender{
    if (self.checkAllData) {
        self.checkAllData(self.indexPath,sender.selected);
    }
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //NO.1画一条线
    CGContextSetRGBStrokeColor(context, 226.0/255.0, 226.0/255.0, 226.0/255.0, 1);//线条颜色
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, SCREEN_WIDTH,0);
    
    CGContextStrokePath(context);
}

@end
