//
//  collectionMuchLabel.m
//  WP
//
//  Created by CC on 16/9/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "collectionMuchLabel.h"

@implementation collectionMuchLabel
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
//        self.pastLabel = [[UILabel alloc]initWithFrame:frame];
//        self.pastLabel.font = kFONT(14);
//        self.pastLabel.textColor = RGB(0, 0, 0);
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPres:)];
        longPress.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPress];
        
        
//        [self addSubview:self.pastLabel];
    }
    return self;
}
-(void)longPres:(UILongPressGestureRecognizer*)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        self.backgroundColor = RGB(226, 226, 226);

        UIMenuController * menuContr = [UIMenuController sharedMenuController];
        [menuContr setMenuVisible:NO];
        UIMenuItem * item = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(clickCopy)];
        menuContr.menuItems = nil;
        [menuContr setMenuItems:@[item]];
        [menuContr setTargetRect:self.frame inView:self.superview];
        [menuContr setMenuVisible:YES animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
    }
}

-(void)clickCopy
{
    UIPasteboard * pastBoard = [UIPasteboard generalPasteboard];
    [pastBoard setString:self.text];
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
-(void)WillHideMenu:(id)objc
{
    self.backgroundColor = [UIColor whiteColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
