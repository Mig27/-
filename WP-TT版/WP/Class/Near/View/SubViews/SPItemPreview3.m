//
//  SPItemPreview3.m
//  WP
//
//  Created by CBCCBC on 15/10/27.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "SPItemPreview3.h"

#define ItemWidth (SCREEN_WIDTH-81)

@implementation SPItemPreview3

- (id)initWithTop:(CGFloat)top title:(NSString *)title content:(NSString *)content{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 65, 20)];
        label.text = title;
        label.font =GetFont(15);
        label.textColor = RGB(153, 153, 153);
        [self addSubview:label];
        
        CGFloat height = [self returnHeight:content];
        
        if (height <= 20) {
            height = 20;
        }
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(81, 10, ItemWidth, height)];
        contentLabel.text = content;
        contentLabel.font = GetFont(15);
        contentLabel.numberOfLines = 0;
//        contentLabel.backgroundColor = [UIColor redColor];
        [self addSubview:contentLabel];
        
        self.frame = CGRectMake(0, top, SCREEN_WIDTH, height+10);
    }
    return self;
}

- (CGFloat)returnHeight:(NSString *)content{
    CGSize size = [content getSizeWithFont:[UIFont systemFontOfSize:15] Width:ItemWidth];
    return size.height;
}

@end
