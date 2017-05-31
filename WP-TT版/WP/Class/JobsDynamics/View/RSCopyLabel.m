//
//  RSCopyLabel.m
//  WP
//
//  Created by 沈亮亮 on 16/3/24.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "RSCopyLabel.h"
#import "WPHttpTool.h"
#import "WPMySecurities.h"

@interface RSCopyLabel ()

@end

@implementation RSCopyLabel


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self attachTapHandler];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self attachTapHandler];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)attachTapHandler{
        
    //    self.userInteractionEnabled =YES;  //用户交互的总开关
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    recognizer.minimumPressDuration = 0.5;
    [self addGestureRecognizer:recognizer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [tap requireGestureRecognizerToFail:recognizer];
    [self addGestureRecognizer:tap];
    
}

- (void)onTap
{
    if (self.type) {
        return;
    }
    self.backgroundColor = WPGlobalBgColor;//WPGlobalBgColor
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
    if (self.isDetail) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideThreeButton" object:nil];
        return;
    }
    if (self.copyType == RSCopyTypeDynamic) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shareJumpToDynamic" object:nil userInfo:@{@"sid" : self.dic[@"sid"],@"nick_name" : self.dic[@"nick_name"],@"index" : self.selectIndex}];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AlumJumpToDetail" object:nil userInfo:@{@"index" : self.selectIndex}];
    }
}

- (void)delay
{
    self.backgroundColor = [UIColor whiteColor];
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer{
    self.backgroundColor = WPGlobalBgColor;//WPGlobalBgColor
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDETHREEVIEW" object:nil];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //        CopyCell *cell = (CopyCell *)recognizer.view;
        [self becomeFirstResponder];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
//        [menuController setMenuVisible:NO];
        //设置菜单
        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuItem:)];
        UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(menuItem2:)];
        UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(menuItem3:)];
        NSMutableArray *array = [NSMutableArray array];
        if (self.type) {
            [array addObject:menuItem1];
        }else{
            [array addObjectsFromArray:@[menuItem1,menuItem2]];//',menuItem3
        }
        [menuController setMenuItems:array];
        //设置菜单栏位置
        [menuController setTargetRect:self.frame inView:self.superview];
        //显示菜单栏
        [menuController setMenuVisible:YES animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
    }
}

#pragma mark - 复制
- (void)menuItem:(id)sender
{
    if (self.type) {
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = self.text;
    }else{
        if (self.copyType == RSCopyTypeDynamic) {
            NSString *description = self.dic[@"speak_comment_content"];
            NSString *description1 = [WPMySecurities textFromBase64String:description];
            NSString *description3 = [WPMySecurities textFromEmojiString:description1];
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = description3;
        } else {
            NSString *description = self.model.remark;
//            NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
//            NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
//            NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
            NSString *description1 = [WPMySecurities textFromBase64String:description];
            NSString *description3 = [WPMySecurities textFromEmojiString:description1];
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = description3;

        }
    }
}

#pragma mark - 收藏
- (void)menuItem2:(id)sender
{
//    NSLog(@"%@",self.dic);
    if (self.copyType == RSCopyTypeDynamic) {
        NSString * speak_comment_state = self.dic[@"speak_comment_state"];
        
        NSString *description = self.dic[@"speak_comment_content"];
//        NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
//        NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
//        NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
        NSString *description1 = [WPMySecurities textFromBase64String:description];
        NSString *description3 = [WPMySecurities textFromEmojiString:description1];
        NSDictionary *userInfo = @{@"collect_class" : @"0",
                                   @"user_id" : self.dic[@"user_id"],
                                   @"content" : description3,
                                   @"img_url" : @"",
                                   @"vd_url" : @"",
                                   @"jobid" : @"",
                                   @"url" : @"",
                                   @"isNiMing":speak_comment_state,
                                   @"dic":self.dic};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"collect" object:nil userInfo:userInfo];
    } else {
        NSString *description = self.model.remark;
//        NSString *description1 = [description stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
//        NSString *description2 = [description1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
//        NSString *description3 = [description2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
        NSString *description1 = [WPMySecurities textFromBase64String:description];
        NSString *description3 = [WPMySecurities textFromEmojiString:description1];
        NSDictionary *userInfo = @{@"collect_class" : @"0",
                                   @"user_id" : self.model.created_user_id,
                                   @"content" : description3,
                                   @"img_url" : @"",
                                   @"vd_url" : @"",
                                   @"jobid" : @"",
                                   @"url" : @""};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"alumCollect" object:nil userInfo:userInfo];
    }
}

#pragma mark - 举报
- (void)menuItem3:(id)sender
{
    if (self.copyType == RSCopyTypeDynamic) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"report" object:nil userInfo:@{@"sid" : self.dic[@"sid"]}];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"alumReport" object:nil userInfo:@{@"sid" : self.model.albumnId}];
    }

}

-(void)WillHideMenu:(id)sender

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
