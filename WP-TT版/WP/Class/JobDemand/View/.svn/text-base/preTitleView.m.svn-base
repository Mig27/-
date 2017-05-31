//
//  preTitleView.m
//  WP
//
//  Created by 沈亮亮 on 15/9/9.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "preTitleView.h"


@implementation preTitleView

- (void)layoutSubviews
{
    [super layoutSubviews];
    UILabel *frontLabel = [[UILabel alloc] init];
    UILabel *backLabel = [[UILabel alloc] init];
    backLabel.numberOfLines = 0;
    NSString *title = self.dic[@"title"];
    NSString *content = self.dic[@"content"];
    CGSize normalSize = [title sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    frontLabel.frame = (CGRect){{10,0},normalSize};
    CGSize size = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 - normalSize.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    backLabel.frame = CGRectMake(frontLabel.right + 10, 0, SCREEN_WIDTH - 30 - normalSize.width, size.height);
    frontLabel.text = title;
    backLabel.text = content;
    frontLabel.font = [UIFont systemFontOfSize:14];
    backLabel.font = [UIFont systemFontOfSize:14];
    frontLabel.textColor = RGBColor(153, 153, 153);
    [self addSubview:frontLabel];
    [self addSubview:backLabel];
}

#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
