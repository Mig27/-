//
//  WPSelectButton.m
//  WP
//
//  Created by 沈亮亮 on 15/10/12.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPSelectButton.h"


@implementation WPSelectButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 16, (frame.size.height - 4)/2, 9, 4)];
        self.image.userInteractionEnabled = YES;
        [self addSubview:self.image];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, frame.size.width - 32, frame.size.height)];
        self.title.textAlignment = NSTextAlignmentCenter;
//        self.title.backgroundColor = [UIColor cyanColor];
//        self.title.font = GetFont(14);
        if (SCREEN_WIDTH == 320) {
            self.title.font = [UIFont systemFontOfSize:14];
        } else {
            self.title.font = [UIFont systemFontOfSize:16];
        }
        self.title.userInteractionEnabled = YES;
        [self addSubview:self.title];
        
        self.readDot = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 14,(frame.size.height - 4)/2, 8, 8)];
        self.readDot.image = [UIImage imageNamed:@"discover_badgebutton"];
//        self.readDot.backgroundColor = [UIColor redColor];
//        self.readDot.clipsToBounds = YES;
//        self.readDot.layer.cornerRadius = self.readDot.frame.size.width/2;
        self.readDot.hidden = YES;
        [self addSubview:self.readDot];
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
-(void)setIsHideOrNot:(BOOL)isHideOrNot
{
    self.readDot.hidden = !isHideOrNot;
}
- (void)setLabelText:(NSString *)text
{
    CGSize normalSize = [text sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    CGFloat width = self.width > normalSize.width ? normalSize.width : self.width;
    
    self.title.frame = CGRectMake((self.width - width)/2, (self.height - normalSize.height)/2, width, normalSize.height);
    self.readDot.frame = CGRectMake(self.title.right, self.title.top - 4, 8, 8);
    self.title.text = text;
    self.image.frame = CGRectMake(self.title.right + 6, self.height/2 - 2, 9, 4);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
