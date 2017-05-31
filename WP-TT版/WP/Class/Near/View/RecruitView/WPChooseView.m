//
//  WPChooseView.m
//  WP
//
//  Created by CBCCBC on 16/3/11.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPChooseView.h"


@implementation WPChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
//        [self addSubview:self.button];
    }
    return self;
}

//- (UILabel *)label
//{
//    if (!_label) {
//        self.label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-200-30, (self.height-ItemViewHeight)/2, 200, ItemViewHeight)];
//        
//        _label.textAlignment = NSTextAlignmentRight;
//        self.label.font = kFONT(12);
//        
//        [self addSubview:self.label];
//    }
//    return _label;
//}

- (UIButton *)button
{
    if (!_button) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(0, 0, SCREEN_WIDTH, ItemViewHeight);
        
//        self.label = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), 0, 160, ItemViewHeight)];
//        self.label.text = @"请选择求职者";
//        self.label.font = kFONT(15);
//        [self.button addSubview:self.label];
//        self.label.userInteractionEnabled = YES;
        self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.titleBtn.frame = CGRectMake(kHEIGHT(12), 0, 160, ItemViewHeight);
        self.titleBtn.titleLabel.font = kFONT(15);
        [self.titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.button addSubview:self.titleBtn];
        
        
        
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithName:self.BuildNew?@"jinru":@"collect"]];//collect
        imageV.userInteractionEnabled = YES;
//        imageV.backgroundColor = [UIColor redColor];
        if (self.BuildNew)
        {
            imageV.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(12)-8, ItemViewHeight/2-7, 8,14);
             self.title = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(12)-8-83, 0, 80, ItemViewHeight)];
        }
        else
        {
            imageV.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(12)-15, ItemViewHeight/2-7.5, 15,15);
             self.title = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(12)-15-83, 0, 80, ItemViewHeight)];
        }
//        imageV.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(12)-8, ItemViewHeight/2-7, 8,14);
        [self.button addSubview:imageV];
        [self.button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        
//        self.title = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(12)-8-83, 0, 80, ItemViewHeight)];
        
        self.title.textAlignment = NSTextAlignmentRight;
        self.title.textColor = [UIColor grayColor];
        self.title.userInteractionEnabled = YES;
//        self.title.text = @"你好";
//        self.title.backgroundColor = [UIColor redColor];
        self.title.font = kFONT(11);
        [self.button addSubview:self.title];
    }
    return _button;
}




@end
