//
//  ChooseCompanyView.m
//  WP
//
//  Created by CBCCBC on 16/3/7.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "ChooseCompanyView.h"
@interface ChooseCompanyView ()
@property (nonatomic ,strong)UILabel *label;
@property (nonatomic ,strong)UILabel *companyLabel;

@end

@implementation ChooseCompanyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), 0, 120, kHEIGHT(43))];
        self.label.text = @"选择企业信息";
        self.label.font = kFONT(15);
        [self addSubview:self.label];
        
//        [UIImage imageWithName:@"jinru"]];
//        _rightImageView.frame = CGRectMake(self.width-kHEIGHT(12)-8, self.height/2-7, 8,14);
        
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"jinru"]];
        self.imageView.frame = CGRectMake(self.width-kHEIGHT(12)-8, self.height/2-7, 8,14);
        [self addSubview:self.imageView];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 43);
//        button.tag = WPRecruitControllerActionTypeChooseCompanyName;
        [self.button normalTitle:@"" Color:RGB(153, 153, 153) Font:kFONT(15)];
        [self.button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//        [button addTarget:self action:@selector(chooseCompanyClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        
        self.companyLabel = [[UILabel alloc]init];
        self.companyLabel.font = kFONT(12);
        self.companyLabel.textColor = RGB(127, 127, 127);
        [self addSubview:self.companyLabel];
    }
    return self;
}

- (void)setCompany:(NSString *)company
{
    _company = company;
    self.companyLabel.text = company;
    CGRect rect = [company boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    self.companyLabel.frame = CGRectMake(self.imageView.frame.origin.x-rect.size.width, self.imageView.frame.origin.y, rect.size.width, 15);
}


@end
