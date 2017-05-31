//
//  SharePersonView.m
//  WP
//
//  Created by 沈亮亮 on 16/3/15.
//  Copyright © 2016年 WP. All rights reserved.
//  工作圈分享的人

#import "SharePersonView.h"
#import "MLLinkLabel.h"

#import "WPShareModel.h"

@interface SharePersonView ()

@end

@implementation SharePersonView

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.shareArr) {
        return;
    }
//    self.backgroundColor = [UIColor purpleColor];
    NSMutableArray *nameArr = [NSMutableArray array];
    for (int i = 0; i<self.shareArr.count; i++) {
        NSDictionary *dic = self.shareArr[i];
        NSString *nick_name = dic[@"nick_name"];
        [nameArr addObject:nick_name];
    }
//    NSString *originalStr = [nameArr componentsJoinedByString:@"，"];
    NSString *nameStr = [nameArr componentsJoinedByString:@"，"];
    if (self.shareCount.integerValue >3) {
        NSString *appendStr = [NSString stringWithFormat:@"...%@人",self.shareCount];
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
    
    CGFloat x = kHEIGHT(10) + kHEIGHT(37) + 10;
    CGFloat y = (self.size.height - 12)/2;
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 12, 12)];
    imageV.image = [UIImage imageNamed:@"zhichangshuoshuo_fenxiangren"];//dynamic_share
    [self addSubview:imageV];
    
    MLLinkLabel *linkLabel = [[MLLinkLabel alloc] initWithFrame:CGRectMake(imageV.right + 6, 0, SCREEN_WIDTH - x - 12 - 6 - kHEIGHT(10), self.size.height)];
    linkLabel.font = kFONT(12);
    linkLabel.userInteractionEnabled = YES;
    linkLabel.numberOfLines = 1;
    linkLabel.textColor = AttributedColor;
    linkLabel.activeLinkTextAttributes = @{NSForegroundColorAttributeName:AttributedColor,NSBackgroundColorAttributeName:WPGlobalBgColor};
    [self addSubview:linkLabel];
    linkLabel.attributedText = attributeStr;
    for (MLLink *link in linkLabel.links) {
        link.linkTextAttributes = @{NSForegroundColorAttributeName:AttributedColor};
    }
    [linkLabel invalidateDisplayForLinks];
    [linkLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        NSLog(@"点击分享的人");
        NSDictionary *info = self.shareArr[link.linkValue.integerValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToPersonalHomePage" object:nil userInfo:@{@"user_id" : info[@"user_id"],@"nick_name" : info[@"nick_name"], @"is_an" : info[@"is_an"]}];
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
