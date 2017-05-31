//
//  WPGridslistView.m
//  WP
//
//  Created by CBCCBC on 16/4/14.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGridslistView.h"
#import "WPGridView.h"

@implementation WPGridslistView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content
{
    if ([super initWithFrame:frame]) {
        
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        CGSize size = [@"卧槽尼玛:" getSizeWithFont:FUCKFONT(15) Height:self.height];
        CGSize size1 = [@"卧       槽:" getSizeWithFont:FUCKFONT(15) Height:self.height];
        CGFloat titleWidth = size.width>size1.width?size.width:size1.width;
        
        
        UILabel *titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, titleWidth, height)];
        titleLabel.text = title;
        titleLabel.font =kFONT(15);
        [self addSubview:titleLabel];
        
        WPGridView *gridView = [[WPGridView alloc]initWithFrame:CGRectMake(titleLabel.right+6, titleLabel.top, SCREEN_WIDTH-titleLabel.right-6, kHEIGHT(43))];
        gridView.font = kFONT(15);
        gridView.rows = 3;
        gridView.textArray = [content componentsSeparatedByString:@"/"];
        [gridView finishToShow];
        
        [self addSubview:gridView];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, gridView.bottom);
    }
    return self;
}


@end
