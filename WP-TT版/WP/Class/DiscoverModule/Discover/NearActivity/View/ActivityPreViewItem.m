//
//  ActivityPreViewItem.m
//  WP
//
//  Created by 沈亮亮 on 15/10/22.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "ActivityPreViewItem.h"


#define iconHeight 12

@interface ActivityPreViewItem ()

@end

@implementation ActivityPreViewItem

- (id)initWithFrame:(CGRect)frame title:(NSMutableAttributedString *)title image:(NSString *)imageName text:(NSString *)text isArrow:(BOOL)isArrow
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = SCREEN_WIDTH;
        CGFloat height = frame.size.height;
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.frame = CGRectMake(10, (height - iconHeight)/2, iconHeight, iconHeight);
        imageV.image = [UIImage imageNamed:imageName];
        [self addSubview:imageV];
        
        NSString *str = title.string;
        CGSize normalSize = [str sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageV.right + 10, (height - normalSize.height)/2, normalSize.width, normalSize.height)];
        titleLabel.font = kFONT(12);
//        titleLabel.backgroundColor = [UIColor redColor];
        titleLabel.attributedText = title;
        [self addSubview:titleLabel];
        
        UILabel *textLabel = [[UILabel alloc] init];
//        textLabel.backgroundColor = [UIColor cyanColor];
        textLabel.text = text;
        textLabel.font = kFONT(12);
        textLabel.textColor = RGB(153, 153, 153);
        textLabel.textAlignment = NSTextAlignmentRight;
        if (isArrow) {
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(width - 25, (height - 15)/2, 15, 15)];
            arrow.image = [UIImage imageNamed:@"common_icon_arrow"];
//            arrow.image = [UIImage imageNamed:@"jinru"];

            [self addSubview:arrow];
            
            textLabel.frame = CGRectMake(titleLabel.right + 6, (height - normalSize.height)/2, width - 10*3 - 2*6 - iconHeight - normalSize.width - 15, normalSize.height);
        } else {
            textLabel.frame = CGRectMake(titleLabel.right + 6, (height - normalSize.height)/2, width - 10*3 - 6 - iconHeight - normalSize.width, normalSize.height);
        }
        
        [self addSubview:textLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, height - 0.5, width - 20, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [self addSubview:line];
        
        
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
