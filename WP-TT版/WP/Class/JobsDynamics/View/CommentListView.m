//
//  CommentListView.m
//  WP
//
//  Created by 沈亮亮 on 16/3/15.
//  Copyright © 2016年 WP. All rights reserved.
//  工作圈评论

#import "CommentListView.h"
#import "MLLinkLabel.h"


@interface CommentListView ()

@property (nonatomic, assign) NSInteger touchIndex;

@end

@implementation CommentListView


- (void)layoutSubviews
{
    
    [super layoutSubviews];
    if (!self.discussArr) {
        return;
    }
//    self.backgroundColor = [UIColor cyanColor];
    UIView *lastView = nil;
    for (int i=0; i<self.discussArr.count; i++) { //把聊天的内容拼接起来
        NSDictionary *dic = self.discussArr[i];
        NSString *nick_name = dic[@"nick_name"];
        NSString *by_nick_name = dic[@"by_nick_name"];
        NSString *speak_comment_content = dic[@"speak_comment_content"];
        NSString *discussStr;
        NSMutableAttributedString *attributedStr;
        NSString *index = [NSString stringWithFormat:@"%d",i];
        if (by_nick_name.length == 0) { //没有回复人
            discussStr = [NSString stringWithFormat:@"%@ ：%@",nick_name,speak_comment_content];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:discussStr];
            [attributedStr addAttribute:NSLinkAttributeName value:index range:NSMakeRange(0,nick_name.length)];
            [attributedStr addAttribute:NSLinkAttributeName value:@"7" range:NSMakeRange(nick_name.length + 2,speak_comment_content.length)];

        } else {  //有回复人
            discussStr = [NSString stringWithFormat:@"%@ 回复 %@ ：%@",nick_name,by_nick_name,speak_comment_content];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:discussStr];
            [attributedStr addAttribute:NSLinkAttributeName value:index range:NSMakeRange(0,nick_name.length)];
            [attributedStr addAttribute:NSLinkAttributeName value:@"7" range:NSMakeRange(nick_name.length + 1,2)];
            [attributedStr addAttribute:NSLinkAttributeName value:index range:NSMakeRange(nick_name.length + 4,by_nick_name.length)];
            [attributedStr addAttribute:NSLinkAttributeName value:@"7" range:NSMakeRange(nick_name.length + 6 + by_nick_name.length,speak_comment_content.length)];

        }
        
        CGFloat bottom = lastView ? lastView.bottom + 10 : 0;
        CGFloat strH = [discussStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(12)]} context:nil].size.height;
        CGFloat x = kHEIGHT(10) + kHEIGHT(37) + 10;
        CGFloat width = SCREEN_WIDTH - 2*kHEIGHT(10) - kHEIGHT(37) - 10;
        
//        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, bottom, SCREEN_WIDTH, strH)];
        
        MLLinkLabel *linkLabel = [[MLLinkLabel alloc] initWithFrame:CGRectMake(x, bottom, width, strH)];
//        MLLinkLabel *linkLabel = [[MLLinkLabel alloc] initWithFrame:CGRectMake(x, 0, width, strH)];
        linkLabel.tag = 233 + i;
        linkLabel.font = kFONT(12);
        linkLabel.userInteractionEnabled = YES;
        linkLabel.numberOfLines = 0;
        linkLabel.attributedText = attributedStr;
        //可以从这里改颜色
        for (MLLink *link in linkLabel.links) {
            if ([link.linkValue isEqualToString:@"7"]) {
                link.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
            } else {
                link.linkTextAttributes = @{NSForegroundColorAttributeName:AttributedColor};
            }
        }
        [linkLabel invalidateDisplayForLinks];
        [self addSubview:linkLabel];
        
        [linkLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            if ([link.linkValue isEqualToString:@"7"]) {
                NSLog(@"点击回复");
//                label.backgroundColor = RGB(112, 112, 112);
//                NSLog(@"%ld****%ld",label.tag - 233, (long)self.discussIndex.row);
//                NSDictionary *discssDic = self.discussArr[label.tag - 233];
//                WPShareModel *model = [WPShareModel sharedModel];
//                NSMutableDictionary *userInfo = model.dic;
////                NSString *userid = userInfo[@"userid"];
//                NSString *user_id = discssDic[@"user_id"];
//                NSString *speak_id = discssDic[@"speak_id"];
//                NSString *sid = discssDic[@"sid"];
//                NSString *nick_name = discssDic[@"nick_name"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:[userid isEqualToString:user_id] ? @"deletDiscuss" : @"commentTopic" object:nil userInfo:@{@"user_id" : user_id,@"speak_id" : speak_id, @"sid" : sid , @"nick_name" : nick_name, @"index" : self.discussIndex}];
            } else {
//                NSLog(@"%@*****%@",linkText,link.linkValue);
//                NSDictionary *info = self.discussArr[link.linkValue.integerValue];
//                NSString *c_nick_name = info[@"nick_name"];
//                NSString *c_user_id = info[@"user_id"];
//                NSString *c_by_nick_name = info[@"by_nick_name"];
//                NSString *c_by_user_id = info[@"by_user_id"];
                
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToPersonalHomePage" object:nil userInfo:@{@"user_id" : [linkText isEqualToString:c_nick_name] ? c_user_id : c_by_user_id,@"nick_name" : [linkText isEqualToString:c_nick_name] ? c_nick_name : c_by_nick_name}];

            }
        
        }];
        lastView = linkLabel;
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(newlongPress:)];
        recognizer.minimumPressDuration = 0.5;
        [linkLabel addGestureRecognizer:recognizer];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
//        [linkLabel addGestureRecognizer:tap];
    }
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    if (self.discussCount.integerValue >6) {
        NSString *str = [NSString stringWithFormat:@"查看全部%@条评论...",self.discussCount];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10) + kHEIGHT(37) + 10, lastView.bottom + 10, SCREEN_WIDTH - 2*kHEIGHT(10) - kHEIGHT(37) - 10, normalSize.height)];
        label.font = kFONT(12);
        label.textColor = AttributedColor;
        label.text = str;
        [self addSubview:label];
        
    }
    
}

- (void)newlongPress:(UILongPressGestureRecognizer *)recognizer{
    MLLinkLabel *touchView = (MLLinkLabel *)recognizer.view;
    touchView.backgroundColor = RGB(226, 226, 226);
    self.touchIndex = recognizer.view.tag;
    //    [self addSubview:self.backView];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //        CopyCell *cell = (CopyCell *)recognizer.view;
        [touchView becomeFirstResponder];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuVisible:NO];
        //设置菜单
//                UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuItem:)];
        UIMenuItem *menuItem6 = [[UIMenuItem alloc] initWithTitle:@"呵呵" action:@selector(menuItem2:)];
//        UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(menuItem3:)];
        [menuController setMenuItems:[NSArray arrayWithObjects:menuItem6, nil]];
        //设置菜单栏位置
        [menuController setTargetRect:touchView.frame inView:touchView.superview];
        //显示菜单栏
        [menuController setMenuVisible:YES animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
    }
}

#pragma mark - 复制
- (void)menuItem2:(id)sender
{
    
}


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    BOOL can = [super canPerformAction:action withSender:sender];
//    if (action == @selector(menuItem2:)) {
//        return YES;
//    }
    if (action ==@selector(copy:)){
        //        self.backgroundColor = [UIColor whiteColor];
        return NO;
    }
    else if (action ==@selector(paste:)){
        //        self.backgroundColor = [UIColor whiteColor];
        return NO;
    }
    else if (action ==@selector(cut:)){
        return NO;
    }
    else if(action ==@selector(select:)){
        return NO;
    }
    else if (action ==@selector(delete:)){
        return NO;
    }
    return NO;
}


- (BOOL)canBecomeFirstResponder{
    return NO;
}

-(void)WillHideMenu:(id)sender

{
    MLLinkLabel *touchLabel = (MLLinkLabel *)[self viewWithTag:_touchIndex];
    touchLabel.backgroundColor = [UIColor whiteColor];
//    self.backgroundColor = RGB(235, 235, 235);
    //    [self.backView removeFromSuperview];
}

- (void)tapClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击回复");
}

#pragma mark - 计算评论的高度
+ (CGFloat)calculateHeightWithInfo:(NSArray *)arr andCount:(NSString *)count
{
    NSMutableArray *discussStrs = [NSMutableArray array];
    //默认一行的高度
    CGSize normalSize = [@"我草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    for (int i=0; i<arr.count; i++) { //把聊天的内容拼接起来
        NSDictionary *dic = arr[i];
        NSString *nick_name = dic[@"nick_name"];
        NSString *by_nick_name = dic[@"by_nick_name"];
        NSString *speak_comment_content = dic[@"speak_comment_content"];
        NSString *discussStr;
        if (by_nick_name.length == 0) {
            discussStr = [NSString stringWithFormat:@"%@ ：%@",nick_name,speak_comment_content];
        } else {
            discussStr = [NSString stringWithFormat:@"%@ 回复 %@ ：%@",nick_name,by_nick_name,speak_comment_content];
        }
        [discussStrs addObject:discussStr];
    }
    
    //计算View的高度
    if (discussStrs.count == 0) {//没有评论
        return 0;
    } else { //有评论
        CGFloat viewHeight = 0;
//        if (count.integerValue > 6) { //评论数大于6
        for (int i = 0; i<discussStrs.count; i++) {
        CGFloat strH = [discussStrs[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(12)]} context:nil].size.height;
            viewHeight = viewHeight + strH;
        }
//          viewHeight = viewHeight + normalSize.height + 10*6;
        viewHeight = count.integerValue > 6 ? (viewHeight + normalSize.height + 10*6) : (viewHeight + (discussStrs.count - 1)*10);
//        } else {  //评论数小于6
//            for (int i = 0; i<discussStrs.count; i++) {
//                CGFloat strH = [discussStrs[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(12)]} context:nil].size.height;
//                viewHeight = viewHeight + strH;
//            }
//            viewHeight = viewHeight + (discussStrs.count - 1)*10;
//        }
        return viewHeight;
    }
    
}

#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    //    NSLog(@"^^^^^^^^%@",NSStringFromCGSize(size));
    return size;
}


@end
