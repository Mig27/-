//
//  RSButton.m
//  WP
//
//  Created by 沈亮亮 on 16/3/8.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "RSButton.h"


@implementation RSButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - kHEIGHT(10) - 9, (frame.size.height - 4)/2, 9, 4)];
        self.image.userInteractionEnabled = YES;
        [self addSubview:self.image];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), 0, frame.size.width - 32, frame.size.height)];
        self.title.font = kFONT(14);
        self.title.userInteractionEnabled = YES;
        [self addSubview:self.title];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.title.textColor = RGB(0, 172, 255);
        self.image.image = [UIImage imageNamed:@"arrow_up"];
    } else {
        self.title.textColor = [UIColor blackColor];
        self.image.image = [UIImage imageNamed:@"arrow_down"];
    }
}

- (void)setLabelText:(NSString *)text
{
//    CGSize normalSize = [text sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
//    self.title.frame = CGRectMake((self.width - normalSize.width)/2, (self.height - normalSize.height)/2, normalSize.width, normalSize.height);
    self.title.text = text;
//    self.image.frame = CGRectMake(self.title.right + 6, self.height/2 - 2, 9, 4);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
