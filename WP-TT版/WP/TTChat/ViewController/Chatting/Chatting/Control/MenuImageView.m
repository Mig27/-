//
//  DDMenuImageView.m
//  IOSDuoduo
//
//  Created by 独嘉 on 14-6-12.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import "MenuImageView.h"
#import "ChattingMainViewController.h"

@implementation MenuImageView
{
    DDImageShowMenu _showMenu;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self attachTapHandler];
    }
    return self;
}

- (void)setShowMenu:(DDImageShowMenu)menu
{
    _showMenu = menu;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)canBecomeFirstResponder{
    return YES;
}

//"反馈"关心的功能
//DDShowEarphonePlay                      = 1,        //听筒播放
//DDShowSpeakerPlay                       = 1 << 1,   //扬声器播放
//DDShowSendAgain                         = 1 << 2,   //重发
//DDShowCopy                              = 1 << 3,   //复制
//DDShowPreview                           = 1 << 4,   //图片预览
//DDShowMore                              = 1 << 5,   //更多
//DDShowtransferText                      = 1 << 6,   //转文字
//DDShowRevoke                            = 1 << 7,   //撤回
//DDShowDelete                            = 1 << 8,   //删除
//DDShowTransmit                          = 1 << 9,   //转发
//DDShowCollect                           = 1 << 10,  //收藏
//DDShowAdd                               = 1 << 11,  //添加
//DDShowLookup                            = 1 << 12   //查看

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ((_showMenu & DDShowEarphonePlay) && action == @selector(earphonePlay:))
    {
        return YES;
    }
    else if ((_showMenu & DDShowSendAgain) && action == @selector(sendAgain:))
    {
        return YES;
    }
    else if (_showMenu & DDShowSpeakerPlay && action == @selector(speakerPlay:))
    {
        return YES;
    }
    else if ((_showMenu & DDShowCopy) && action == @selector(copyString:))
    {
        return YES;
    }
//    else if (_showMenu & DDShowPreview && action == @selector(imagePreview:))
//    {
//        return YES;
//    }
    else if ((_showMenu & DDShowTransmit) && action == @selector(transmit:))
    {
        return YES;
    }
    else if ((_showMenu & DDShowCollect) && action == @selector(collect:))
    {
        return YES;
    }
//    else if (_showMenu & DDShowtransferText && action == @selector(copyString:))
//    {
//        return YES;
//    }
//    else if (_showMenu & DDShowRevoke && action == @selector(earphonePlay:))
//    {
//        return YES;
//    }
    else if ((_showMenu & DDShowDelete) && action == @selector(deleteOption:))
    {
        return YES;
    }
    else if ((_showMenu & DDShowMore) && action == @selector(more:))
    {
        return YES;
    }
    return NO;
}

//UILabel默认是不接收事件的，我们需要自己添加touch事件
-(void)attachTapHandler{
    self.userInteractionEnabled = YES;  //用户交互的总开关
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    touch.numberOfTapsRequired = 1;
    [self addGestureRecognizer:touch];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    press.minimumPressDuration = 0.5;
    [self addGestureRecognizer:press];
    
    [[ChattingMainViewController shareInstance].singleTap requireGestureRecognizerToFail:press];
}

//同上
-(void)awakeFromNib{
    [super awakeFromNib];
    [self attachTapHandler];
}

-(void)handleTap:(UIGestureRecognizer*) recognizer{
    if ([self.delegate respondsToSelector:@selector(tapTheImageView:)])
    {
        [self.delegate tapTheImageView:self];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //   TSTableViewCell *cell = (TSTableViewCell *)recognizer.view;
        [self showTheMenu];
    }
}

- (void)showTheMenu
{
    [self becomeFirstResponder];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyString:)];
    UIMenuItem *sendAgain = [[UIMenuItem alloc] initWithTitle:@"重发" action:@selector(sendAgain:)];
    UIMenuItem *earphonePlayItem = [[UIMenuItem alloc] initWithTitle:@"听筒" action:@selector(earphonePlay:)];
    UIMenuItem *speakerPlayItem = [[UIMenuItem alloc] initWithTitle:@"扬声器播放" action:@selector(speakerPlay:)];
//    UIMenuItem *previewItem = [[UIMenuItem alloc] initWithTitle:@"预览" action:@selector(imagePreview:)];

    UIMenuItem *moreItem = [[UIMenuItem alloc] initWithTitle:@"更多..." action:@selector(more:)];
//    UIMenuItem *transferText = [[UIMenuItem alloc] initWithTitle:@"转文字" action:@selector(sendAgain:)];
//    UIMenuItem *revokeItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(earphonePlay:)];
    UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteOption:)];
    UIMenuItem *transmitItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(transmit:)];
    UIMenuItem *collectItem = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(collect:)];
    
    
    
    
//    UIMenuItem *addItem = [[UIMenuItem alloc] initWithTitle:@"添加" action:@selector(sendAgain:)];
//    UIMenuItem *lookupItem = [[UIMenuItem alloc] initWithTitle:@"查看" action:@selector(earphonePlay:)];

    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:nil];
//    [menu setMenuItems:[NSArray arrayWithObjects:copyItem,sendAgain,earphonePlayItem, speakerPlayItem,previewItem,transferText,moreItem,revokeItem,deleteItem,transmitItem,collectItem,addItem,lookupItem, nil]];
    
    [menu setMenuItems:[NSArray arrayWithObjects:copyItem,earphonePlayItem,speakerPlayItem,transmitItem,sendAgain,collectItem,deleteItem,moreItem, nil]];
    
    
    [menu setTargetRect:self.frame inView:self.superview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
    NSLog(@"menuItems:%@",menu.menuItems);
//    [[UIApplication sharedApplication] sendAction:@selector(becomeFirstResponder)to:nil from:self forEvent:nil];
}

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

#pragma mark - menu selecter
- (void)earphonePlay:(id)sender
{
    //听筒播放
    if ([self.delegate respondsToSelector:@selector(clickTheEarphonePlay:)])
    {
        [self.delegate clickTheEarphonePlay:self];
    }
}

- (void)speakerPlay:(id)sender
{
    //扬声器播放
    if ([self.delegate respondsToSelector:@selector(clickTheSpeakerPlay:)])
    {
        [self.delegate clickTheSpeakerPlay:self];
    }
}

- (void)sendAgain:(id)sender
{
    //重发
    if ([self.delegate respondsToSelector:@selector(clickTheSendAgain:)])
    {
        [self.delegate clickTheSendAgain:self];
    }
}

- (void)copyString:(id)sender
{
    //复制
    if ([self.delegate respondsToSelector:@selector(clickTheCopy:)])
    {
        [self.delegate clickTheCopy:self];
    }
}

- (void)imagePreview:(id)sender
{
    //图片预览
    if ([self.delegate respondsToSelector:@selector(clickThePreview:)])
    {
        [self.delegate clickThePreview:self];
    }
}

#pragma mark - 转发
- (void)transmit:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clickTheTransmit:)]) {
        [self.delegate clickTheTransmit:self];
    }
}

#pragma mark - 收藏
- (void)collect:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clickTheCollect:)])
    {
        [self.delegate clickTheCollect:self];
    }
}

#pragma mark - 删除
- (void)deleteOption:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clickTheDelete:)]) {
        [self.delegate clickTheDelete:self];
    }
}

#pragma mark - 更多
- (void)more:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clickTheMore:)]) {
        [self.delegate clickTheMore:self];
    }
}

@end
