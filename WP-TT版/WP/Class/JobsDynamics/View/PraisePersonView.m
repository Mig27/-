//
//  PraisePersonView.m
//  WP
//
//  Created by 沈亮亮 on 16/3/15.
//  Copyright © 2016年 WP. All rights reserved.
//  工作圈点赞的人

#import "PraisePersonView.h"
#import "MLLinkLabel.h"


@interface PraisePersonView ()

@end

@implementation PraisePersonView

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.praiseArr) {
        return;
    }
//    self.backgroundColor = [UIColor redColor];
    NSMutableArray *nameArr = [NSMutableArray array];
    for (int i = 0; i<self.praiseArr.count; i++) {
        NSDictionary *dic = self.praiseArr[i];
        NSString *nick_name = dic[@"nick_name"];
        [nameArr addObject:nick_name];
    }
//    NSString *originalStr = [nameArr componentsJoinedByString:@"，"];
    NSString *nameStr = [nameArr componentsJoinedByString:@"，"];
    if (self.praiseCount.integerValue >3) {
        NSString *appendStr = [NSString stringWithFormat:@"...%@人",self.praiseCount];
        nameStr = [nameStr stringByAppendingString:appendStr];
    }
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:nameStr];
    NSInteger location = 0;
    for (int i=0; i<nameArr.count; i++) {
        NSString *nickName = nameArr[i];
        NSString *index = [NSString stringWithFormat:@"%d",i];
        [attributeStr addAttribute:NSLinkAttributeName value:index range:NSMakeRange(location,nickName.length)];
        location = location + nickName.length + 1;
    }
//    [attributeStr addAttribute:NSLinkAttributeName value:@"dudl@qq.com" range:NSMakeRange(originalStr.length,nameStr.length - originalStr.length)];

    CGFloat x = kHEIGHT(10) + kHEIGHT(37) + 10;
    CGFloat y = (self.size.height - 12)/2;
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 12, 12)];
    imageV.image = [UIImage imageNamed:@"zhichangshuoshuo_zanren"];//small_good
    [self addSubview:imageV];
    
    MLLinkLabel *linkLabel = [[MLLinkLabel alloc] initWithFrame:CGRectMake(imageV.right + 6, 0, SCREEN_WIDTH - x - 12 - 6 - kHEIGHT(10), self.size.height)];
    linkLabel.font = kFONT(12);
    linkLabel.textColor = AttributedColor;
    linkLabel.userInteractionEnabled = YES;
    linkLabel.numberOfLines = 1;
    linkLabel.activeLinkTextAttributes = @{NSForegroundColorAttributeName:AttributedColor,NSBackgroundColorAttributeName:WPGlobalBgColor};
    [self addSubview:linkLabel];
    linkLabel.attributedText = attributeStr;
    for (MLLink *link in linkLabel.links) {
        link.linkTextAttributes = @{NSForegroundColorAttributeName:AttributedColor};
    }
    [linkLabel invalidateDisplayForLinks];
    [linkLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        NSLog(@"点击赞的人");
        NSDictionary *info = self.praiseArr[link.linkValue.integerValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToPersonalHomePage" object:nil userInfo:@{@"user_id" : info[@"user_id"],@"nick_name" : info[@"nick_name"]}];

    }];

}

+ (CGFloat)calculateHeightWithInfo:(NSArray *)arr
{
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    if (arr.count == 0) {
        return 0;
    } else {
        return normalSize.height;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
