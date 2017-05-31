//
//  SPItemPreview.m
//  WP
//
//  Created by CBCCBC on 15/9/24.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "SPItemPreview.h"

@interface SPItemPreview ()

@end

@implementation SPItemPreview

- (id)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content
{
    self = [super init];
    if (self)
    {
        NSLog(@"这一个标题是 == %@ 内容是 == %@", title, content);
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        CGSize size = [@"卧槽尼玛:" getSizeWithFont:FUCKFONT(15) Height:self.height];
        CGSize size1 = [@"卧       槽:" getSizeWithFont:FUCKFONT(15) Height:self.height];
        CGFloat titleWidth = size.width>size1.width?size.width:size1.width;
        
        self.backgroundColor = [UIColor whiteColor];
        
        // title
        UILabel *titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(kHEIGHT(12), 0, titleWidth, height)];
        titleLabel.text = title;
        titleLabel.font =kFONT(15);
        [self addSubview:titleLabel];
        
        CGFloat contentHeight = [SPItemPreview itemHeightFromContent:content];
        
        CGFloat itemHeight = contentHeight > height ? contentHeight + 25 : height;
        CGFloat contentTop = contentHeight > height ? 15 : 0;
        
        // content
        // 内容很高时，显示不了
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleWidth+10+6+4,contentTop, width-100, (contentHeight>height ? contentHeight : height))];
        
        contentLabel.numberOfLines = 0;
        contentLabel.text = content;
        contentLabel.font = kFONT(15);
//        [contentLabel setVerticalAlignment:VerticalAlignmentTop];
//        if ([title isEqualToString:@"姓       名:"]) {
////           contentLabel.backgroundColor = [UIColor greenColor];
//        }
       
        [self addSubview:contentLabel];
        
#warning 好像不起作用
        // 重新设置view 的高度
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, width, itemHeight);
        
        // 分割线
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height - 0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [self addSubview:line];
    }
    
    return self;
}

+ (CGFloat)itemHeightFromContent:(NSString *)content
{
    CGSize size = [content getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH-100];
    
    return size.height;
}

@end
