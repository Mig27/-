//
//  titleView.m
//  WP
//
//  Created by 沈亮亮 on 15/8/28.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "titleView.h"



@implementation titleView

- (void)layoutSubviews
{
    [super layoutSubviews];
    UILabel *frontLabel = [[UILabel alloc] init];
    UILabel *backLabel = [[UILabel alloc] init];
    NSString *str1 = self.dic[@"name"];
    NSString *backStr = self.dic[@"title"];
    NSString *newStr = [str1 stringByReplacingOccurrencesOfString:@"0" withString:@"  "];
    NSString *frontStr = [NSString stringWithFormat:@"%@:",newStr];
    CGSize normalSize = [frontStr sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    frontLabel.frame = (CGRect){{10,0},normalSize};
    backLabel.frame = CGRectMake(frontLabel.right + 10, 0, SCREEN_WIDTH - 30 - normalSize.width, normalSize.height);
    if (self.needColor) {
        if ([backStr isEqualToString:@"急招聘"] || [backStr isEqualToString:@"急求职"]) {
            backLabel.textColor = RGB(10, 110, 210);
        } else {
            backLabel.textColor = RGB(255, 85, 68);
        }
    }
    frontLabel.text = frontStr;
    backLabel.text = backStr;
    frontLabel.font = [UIFont systemFontOfSize:14];
    backLabel.font = [UIFont systemFontOfSize:14];
    frontLabel.textColor = RGBColor(153, 153, 153);
    [self addSubview:frontLabel];
    [self addSubview:backLabel];

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
