//
//  SPButton.m
//  WP
//
//  Created by CBCCBC on 15/9/17.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "SPButton.h"



@implementation SPButton
{
    NSString *_imageName;
    NSInteger contentFont;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSString *str = self.titleLabel.text;
        UIImageView *imageV = [[UIImageView alloc]init];
        [self addSubview:imageV];
        if ([str isEqualToString:@"删除"]) {
            imageV.image = [UIImage imageNamed:@"delet_info"];
        }
        if([str isEqualToString:@"修改"]){
            imageV.image = [UIImage imageNamed:@"detail_answer"];
        }
        if ([str isEqualToString:@"刷新"]) {
            imageV.image = [UIImage imageNamed:@"detail_apply"];
        }
        if ([str isEqualToString:@"下架"]) {
            imageV.image = [UIImage imageNamed:@"detail_comment"];
        }
        if ([str isEqualToString:@"推广"]) {
            imageV.image = [UIImage imageNamed:@"dianhua"];
        }
        imageV.frame = CGRectMake(self.height/2, 5, 10, 10);
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title ImageName:(NSString *)imageName Target:(id)target Action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//        [self setImage:[UIImage imageNamed:@"white_background"] forState:UIControlStateNormal];
//        [self setImage:[UIImage imageNamed:@"gray_background"] forState:UIControlStateHighlighted];
//        self.layer.borderColor =RGB(211, 211, 211).CGColor;
//        self.layer.borderWidth = 0.25;
        
        _imageName = imageName;
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.text = title;
        _contentLabel.font = [UIFont systemFontOfSize:15];//kFONT(15)
        [self addSubview:_contentLabel];
        
        CGSize size = [title getSizeWithFont:15 Height:20];
        
        // (frame.size.width-(size.width+20))/2;相当于图片加文字一起，然后算居中；
        _subImageView = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-size.width-20)/2, frame.size.height/2-7.5, 15, 15)];
        _subImageView.image = [UIImage imageNamed:imageName];
        
        if (![imageName isEqualToString:@""]) {
            
            [self addSubview:_subImageView];
            
            _contentLabel.frame = CGRectMake(_subImageView.right+5, frame.size.height/2-10, frame.size.width-_subImageView.right-5, 20);
            //_contentLabel.textColor = RGB(152, 152, 152);
            _contentLabel.textAlignment = NSTextAlignmentLeft;
        }else{
            _contentLabel.frame = CGRectMake(0, frame.size.height/2-10, frame.size.width, 20);
            _contentLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    return self;
}

- (void)setContentLabelSize:(NSString *)title font:(CGFloat)font{
 
    CGSize size = [title getSizeWithFont:font Height:self.height];
    if (![_imageName isEqualToString:@""]) {
        
        [self addSubview:_subImageView];
        _subImageView.frame = CGRectMake((self.width-size.width-20)/2, self.height/2-7.5, 15, 15);
        _contentLabel.frame = CGRectMake(_subImageView.right+5, self.height/2-10, self.width-_subImageView.right-5, 20);
        //_contentLabel.textColor = RGB(152, 152, 152);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = kFONT(font);
    }else{
        _contentLabel.frame = CGRectMake(0, self.height/2-10, self.width, 20);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = kFONT(font);
    }
}

- (void)setContentAlignment:(SPButtonContentAlignment)contentAlignment{
    if (contentAlignment == SPButtonContentAlignmentLeft) {
        if (![_imageName isEqualToString:@""]) {
            _subImageView.left = 10;
            _contentLabel.left = _subImageView.right+5;
        }else{
            _contentLabel.left = 10;
        }
    }
    if (contentAlignment == SPButtonContentAlignmentRight) {
        if (![_imageName isEqualToString:@""]) {
            _subImageView.left = 10;
            _contentLabel.left = _subImageView.right+5;
        }else{
            _contentLabel.left = 10;
        }
    }
}

- (void)setSelectedTitle:(NSString *)title imageName:(NSString *)imageName{
    self.contentLabel.text = title;
    self.subImageView.image = [UIImage imageNamed:imageName];
    [self setContentLabelSize:title font:15];
}

//-(void)setContentLabelText:(NSString *)title
//{
//    CGSize size = [title getSizeWithFont:17 Height:20];
//    
//    if (![_imageName isEqualToString:@""]) {
//        _contentLabel.frame = CGRectMake(imageV.right+10, 43/2-10, 100, 20);
//        _contentLabel.textColor = RGB(152, 152, 152);
//        _contentLabel.textAlignment = NSTextAlignmentLeft;
//    }else{
//        _contentLabel.frame = CGRectMake(0, 43/2-10, frame.size.width, 20);
//        _contentLabel.textAlignment = NSTextAlignmentCenter;
//    }
//}

@end
