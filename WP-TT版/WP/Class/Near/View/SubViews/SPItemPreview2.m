//
//  SPItemPreview2.m
//  WP
//
//  Created by CBCCBC on 15/10/26.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "SPItemPreview2.h"

@interface SPItemPreview2 ()

@property (strong, nonatomic) UILabel *contentLabel;
@property (assign, nonatomic) CGFloat itemHeight;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *line;

@end

@implementation SPItemPreview2

-(id)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content
{
    
    self = [super init];
    if (self) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;

        CGSize size = [@"卧槽尼玛:" getSizeWithFont:FUCKFONT(15) Height:self.height];
        CGSize size1 = [@"卧       槽:" getSizeWithFont:FUCKFONT(15) Height:self.height];
        CGFloat titleWidth = size.width>size1.width?size.width:size1.width;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, titleWidth, height)];
        titleLabel.text = title;
        titleLabel.font =kFONT(15);
        [self addSubview:titleLabel];
        
        CGFloat contentHeight = [SPItemPreview2 itemHeightFromContent:content]>height?[SPItemPreview2 itemHeightFromContent:content]:height;
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleWidth+10+6, 15, width-100, contentHeight)];
        _contentLabel.tag = 200;
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = content;
        _contentLabel.font = kFONT(15);
        [self addSubview:_contentLabel];
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, width, contentHeight+20);
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height - 0.5, SCREEN_WIDTH, 0.5)];
        _line.backgroundColor = RGB(226, 226, 226);
        [self addSubview:_line];
    }
    
    return self;
}

+(CGFloat)itemHeightFromContent:(NSString *)content
{
    CGSize size = [content getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH-100];
    return size.height;
}

@end
