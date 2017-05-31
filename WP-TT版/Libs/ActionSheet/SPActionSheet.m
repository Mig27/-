    //
//  BackgroundButton.m
//  test
//
//  Created by CBCCBC on 15/9/16.
//  Copyright (c) 2015年 Spyer. All rights reserved.
//

#import "SPActionSheet.h"
#import "MacroDefinition.h"

@implementation SPActionSheet
{
    NSString *_title;
}
-(instancetype)initWithTitle:(NSString *)title delegate:(id<SPActionSheetDelegate>)delegate
{
    self = [super init];
    if (self) {
        _title = title;
        self.delegate = delegate;
    }
    return self;
}

-(void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.frame = window.bounds;
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
    }];
    
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.4];
}

-(void)delay
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:_title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(50, SCREEN_HEIGHT/2-15, SCREEN_WIDTH-100, 30);
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [self addSubview:button];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

-(void)buttonClick
{
    if (self.delegate) {
        [self.delegate SPActionSheetDelegate];
        [self removeFromSuperview];
    }
}

@end
