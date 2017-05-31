//
//  SwitchView.m
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "SwitchView.h"
#define kswitch_x SCREEN_WIDTH-70

@interface SwitchView()
@property (nonatomic ,strong)UILabel *label;
@property (nonatomic ,strong)UILabel *detailLabel;
@end
@implementation SwitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.label = [[UILabel alloc]init];
        [self addSubview:self.label];
        self.detailLabel = [[UILabel alloc]init];
        self.detailLabel.font = kFONT(12);
        self.detailLabel.textColor = RGB(127, 127, 127);
        [self addSubview:self.detailLabel];
        self.switchView = [[UISwitch alloc]initWithFrame:CGRectMake(kswitch_x, 8, 0, 0)];
        [self.switchView addTarget:self action:@selector(transferSwitch) forControlEvents:UIControlEventValueChanged];
        self.switchView.onTintColor = RGB(0, 172, 255);
        [self addSubview:self.switchView];

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kHEIGHT(42)+0.5, SCREEN_WIDTH, 0.5)];
        [self addSubview:view];
        view.backgroundColor = RGB(216, 216, 216);
    }
    return self;
}

-(void)transferSwitch{
    if (self.switchBlock) {
       self.switchBlock(); 
    }
    
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.label.text = title;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(0, kHEIGHT(43)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    self.label.frame = CGRectMake(16, 0, rect.size.width, kHEIGHT(43));
}

- (void)setDetailTitle:(NSString *)detailTitle
{
    _detailTitle = detailTitle;
    self.detailLabel.text = detailTitle;
    CGRect rect = [detailTitle boundingRectWithSize:CGSizeMake(0, kHEIGHT(43)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    self.detailLabel.frame = CGRectMake(self.label.right+6, 0, rect.size.width, kHEIGHT(43));
}

- (void)setStatus:(NSString *)status
{
    _status = status;
    [self.switchView removeFromSuperview];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kswitch_x+4, 8, 79, 27)];
    NSLog(@"%f",label.right);
    label.font = kFONT(12);
    label.textColor = RGB(127, 127, 127);
    label.text = status;
    [self addSubview:label];
}

@end//79 * 27
