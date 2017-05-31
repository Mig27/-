//
//  InputView.m
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "InputView.h"

@implementation InputView

- (instancetype)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeholder
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-32, frame.size.height)];
        self.textField.placeholder = placeholder;
        [self addSubview:self.textField];
    }
    return self;
}

@end
