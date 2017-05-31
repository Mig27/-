//
//  SPButton1.m
//  WP
//
//  Created by CBCCBC on 15/10/27.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "SPButton1.h"
#import "MacroDefinition.h"
#import "NSString+StringType.h"


@implementation SPButton1

{
    NSString *_imageName;
    
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
        [self setImage:[UIImage imageNamed:@"white_background"] forState:UIControlStateNormal];
//        [self setImage:[UIImage imageNamed:@"gray_background"] forState:UIControlStateHighlighted];
        //        self.layer.borderColor =RGB(211, 211, 211).CGColor;
        //        self.layer.borderWidth = 0.25;
        
        _imageName = imageName;
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.text = title;
        _contentLabel.font = GetFont(15);
        [self addSubview:_contentLabel];
        CGSize size = [title getSizeWithFont:15 Height:20];
        self.mageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height/2-6, 12, 12)];
        self.mageView.image = [UIImage imageNamed:imageName];
        if (![imageName isEqualToString:@""]) {
            [self addSubview:self.mageView];
            _contentLabel.frame = CGRectMake(self.mageView.right+5, frame.size.height/2-10, frame.size.width-self.mageView.right-5, 20);
            _contentLabel.textColor = RGB(0, 0, 0);
            _contentLabel.textAlignment = NSTextAlignmentLeft;
        }else{
            _contentLabel.frame = CGRectMake(0, frame.size.height/2/2-10, frame.size.width, 20);
            _contentLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    return self;
}

- (void)setContentLabelSize:(NSString *)title font:(CGFloat)font{
    
    CGSize size = [title getSizeWithFont:font Height:self.height];
    if (![_imageName isEqualToString:@""]) {
        
        [self addSubview:self.mageView];
        self.mageView.frame = CGRectMake(0, self.height/2-7.5, 15, 15);
        _contentLabel.frame = CGRectMake(self.mageView.right+5, self.height/2-10, self.width-self.mageView.right-5, 20);
        _contentLabel.textColor = RGB(0, 0, 0);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = GetFont(font);
    }else{
        _contentLabel.frame = CGRectMake(0, self.height/2/2-10, self.width, 20);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = GetFont(font);
    }
}

- (void)setContentAlignment:(SPButtonContentAlignment)contentAlignment{
    if (contentAlignment == SPButtonContentAlignmentLeft) {
        if (![_imageName isEqualToString:@""]) {
            self.mageView.left = 0;
            _contentLabel.left = self.mageView.right+5;

        }else{
            _contentLabel.left = 10;
        }
    }
    if (contentAlignment == SPButtonContentAlignmentRight) {
        if (![_imageName isEqualToString:@""]) {
            self.mageView.left = 0;
            _contentLabel.left = self.mageView.right+5;

        }else{
            _contentLabel.left = 10;
        }
    }
}

- (void)setContentLabelTitle:(NSString *)title font:(CGFloat)font
{
    self.contentLabel.text = title;
    [self setContentLabelSize:title font:font];
}
-(void)titleColor:(UIColor*)color
{
//    self.contentLabel.textColor = [UIColor redColor];
}
-(void)setContentLabelTextColor:(UIColor*)color
{
    self.contentLabel.textColor = color;

}
@end
