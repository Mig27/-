//
//  WPNewResumeHeaderView.m
//  WP
//
//  Created by CBCCBC on 16/6/17.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPNewResumeHeaderView.h"

@implementation WPNewResumeHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.userInteractionEnabled = YES;
    self.backgroundColor = RGB(235, 235, 235);
    CGSize normalSize = [@"新的消息通知" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    CGFloat x = (SCREEN_WIDTH - kHEIGHT(24) - 8 - normalSize.width - 6 - 15)/2;
    //        UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        tipBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(36));
    //        tipBtn.backgroundColor = [UIColor whiteColor];
    //        [tipBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    //        [tipBtn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
    //        [self addSubview:tipBtn];
    UIView *tipBtn = [UIView new];
    tipBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(36));
    tipBtn.backgroundColor = [UIColor whiteColor];
    //        [tipBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    //        [tipBtn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)] forState:UIControlStateHighlighted];
    [self addSubview:tipBtn];
    self.backView = tipBtn;
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, kHEIGHT(36)/2 - kHEIGHT(27)/2, kHEIGHT(27), kHEIGHT(27))];
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = 5;
    self.iconImageView.image = [UIImage imageNamed:@"small_cell_picture"];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [tipBtn addSubview:self.iconImageView];
    self.iconImageView.centerY = kHEIGHT(36)/2;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.right + 8, kHEIGHT(36)/2 - normalSize.height/2, normalSize.width, normalSize.height)];
    tipLabel.text = @"新的消息通知";
    tipLabel.font = kFONT(14);
    [tipBtn addSubview:tipLabel];
    
    self.badgBtn = [[WPBadgeButton alloc] initWithFrame:CGRectMake(tipLabel.right + 6, (kHEIGHT(36) - 14)/2, 15, 15)];
    self.badgBtn.badgeValue = @"2";
    [tipBtn addSubview:self.badgBtn];
    self.badgBtn.centerY = kHEIGHT(36)/2;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self addGestureRecognizer:tap];

}

- (void)configeWith:(NSString *)avatar count:(NSString *)count
{
    if (avatar == nil || avatar.length == 0) {
        avatar = @"";
    }
    NSString *rul = [IPADDRESS stringByAppendingString:avatar];
    [self.iconImageView sd_setImageWithURL:URLWITHSTR(rul) placeholderImage:[UIImage imageNamed:@"small_cell_picture"]];
    self.badgBtn.badgeValue = count;
}

- (void)click
{
    if (self.clickBlock) {
        self.clickBlock();
    }
    self.backView.backgroundColor = RGB(226, 226, 226);
    [self performSelector:@selector(delay) afterDelay:0.5];
}

- (void)delay
{
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = RGB(235, 235, 235);
}


@end
