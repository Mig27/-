//
//  WPMenuButton.m
//  WP
//
//  Created by Kokia on 16/5/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMenuButton.h"

@implementation WPMenuButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 16, (frame.size.height - 4)/2, 9, 4)];
        self.image.userInteractionEnabled = YES;
        [self addSubview:self.image];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, frame.size.width - 32, frame.size.height)];
        self.title.textAlignment = NSTextAlignmentCenter;
        if (SCREEN_WIDTH == 320) {
            self.title.font = [UIFont systemFontOfSize:14];
        } else {
            self.title.font = [UIFont systemFontOfSize:16];
        }
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
    CGSize normalSize = [text sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
    CGFloat width = self.width > normalSize.width ? normalSize.width : self.width;
    
    self.title.frame = CGRectMake((self.width - width)/2, (self.height - normalSize.height)/2, width, normalSize.height);
    self.title.text = text;
    self.image.frame = CGRectMake(self.title.right + 6, self.height/2 - 2, 9, 4);
}


@end
