//
//  AddLinkButton.m
//  WP
//
//  Created by 沈亮亮 on 15/12/25.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "AddLinkButton.h"


@interface AddLinkButton ()

@end

@implementation AddLinkButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title icon:(NSString *)icon
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize normalSize = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
        CGFloat height = frame.size.height;
        CGFloat width = frame.size.width;
        CGFloat x = width/2 - kHEIGHT(18)/2;
        CGFloat y = (height - kHEIGHT(18) - 8 -normalSize.height)/2;
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, kHEIGHT(18), kHEIGHT(18))];
        iconImage.image = [UIImage imageNamed:icon];
        [self addSubview:iconImage];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImage.bottom + 8, width, normalSize.height)];
        titleLabel.text = title;
        titleLabel.textColor = RGB(153, 153, 153);
        titleLabel.font = GetFont(12);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
