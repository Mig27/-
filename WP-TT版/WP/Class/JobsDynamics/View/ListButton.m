//
//  ListButton.m
//  AddChildViewController
//
//  Created by 沈亮亮 on 15/9/21.
//  Copyright (c) 2015年 XYZ. All rights reserved.
//

#import "ListButton.h"


#define BtnWitth 56
#define BtnHeight 80
#define IconHeight 36

@interface ListButton ()

@end

@implementation ListButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title icon:(NSString *)icon{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize nomalSize = [@"测试" sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
      
        CGFloat y = (BtnHeight - IconHeight - 6 - nomalSize.height)/2;
        CGFloat x = (frame.size.width - 36)/2;
//        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, y, IconHeight, IconHeight)];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, IconHeight, IconHeight)];
        image.image = [UIImage imageNamed:icon];
        [self addSubview:image];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, image.bottom + 6, frame.size.width, nomalSize.height)];
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = titleLabel;
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
