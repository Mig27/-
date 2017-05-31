//
//  WPtextFiled.m
//  WP
//
//  Created by CC on 16/11/17.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPtextFiled.h"

@implementation WPtextFiled

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
    
//    NSString * string = @"哈哈哈";
//    CGSize size = [string getSizeWithFont:kFONT(15) Width:10000000];
    
    return CGRectInset(bounds, 0,14.7);//14//(self.height-size.height)/2
}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
//    NSString * string = @"哈哈哈";
//    CGSize size = [string getSizeWithFont:kFONT(15) Width:10000000];
    return CGRectInset(bounds, 0, 14.7);
}
@end
