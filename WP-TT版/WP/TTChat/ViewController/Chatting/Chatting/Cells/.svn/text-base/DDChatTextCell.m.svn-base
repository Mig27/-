//
//  DDChatTextCell.m
//  IOSDuoduo
//
//  Created by 独嘉 on 14-5-28.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import "DDChatTextCell.h"
#import "UIView+Addition.h"
#import "MTTDatabaseUtil.h"
#import "DDMessageSendManager.h"
#import "SessionModule.h"
#import <Masonry/Masonry.h>
#import "MTTBubbleModule.h"
#import "DDUserModule.h"
#import "WPMySecurities.h"
#import "ChattingMainViewController.h"
#import "WPRecentLinkManController.h"
static int const fontsize = 16;

@interface DDChatTextCell(PrivateAPI)

- (void)layoutLeftLocationContent:(NSString*)content;
- (void)layoutRightLocationContent:(NSString*)content;

@end

@implementation DDChatTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentLabel setFont:systemFont(fontsize)];

        [self.contentLabel setNumberOfLines:0];
        [self.contentLabel setBackgroundColor:[UIColor clearColor]];
        self.contentLabel.adjustsFontSizeToFitWidth = YES;
        self.contentLabel.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.contentLabel];
        
        
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setContent:(MTTMessageEntity*)content
{
    [super setContent:content];
    [self.choiseBtn removeFromSuperview];
    [self.contentView addSubview:self.choiseBtn];
    // 过滤空格回车
    NSString *labelContent = [content.msgContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    labelContent = [WPMySecurities textFromEmojiString:labelContent];
    UIColor *linkColor;
    UIColor *textColor;
    
    if (!labelContent) {
        return;
    }
    
    
    switch (self.location)
    {
        case DDBubbleLeft:
        {
            linkColor = self.leftConfig.linkColor;
            textColor = self.leftConfig.textColor;
        }
            break;
        case DDBubbleRight:
        {
            linkColor = self.rightConfig.linkColor;
//            textColor = self.rightConfig.textColor;
            textColor = [UIColor blackColor];
        }
            break;
    }

    // 设置全局字体颜色
    [self.contentLabel setTextColor:textColor];
    [self.contentLabel setText:labelContent];

    //设置行间距（有问题）
    /*
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelContent];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:0.5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelContent length])];
    self.contentLabel.attributedText = attributedString;
    [self.contentLabel sizeToFit];
    */
    
    
    
    //link字符样式
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
    [linkAttributes setValue:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [linkAttributes setValue:(__bridge id)linkColor.CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    self.contentLabel.linkAttributes = linkAttributes;
    //点击link样式
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)linkColor.CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    self.contentLabel.activeLinkAttributes = mutableActiveLinkAttributes;
    
    // url识别
    NSArray *match = [self checkUrl:labelContent];
    for (NSTextCheckingResult *per in match)
    {
        NSString *urlString = [labelContent substringWithRange:per.range];
        if([urlString rangeOfString:@"http"].location == NSNotFound){
            urlString = [@"http://" stringByAppendingString:urlString];
        }
        NSURL *url = [NSURL URLWithString:urlString];
        [self.contentLabel addLinkToURL:url withRange:per.range];
    }
    // 花名
    NSArray *nickMatch = [self checkNickname:labelContent];
    for (NSTextCheckingResult *per in nickMatch)
    {
        NSInteger location = per.range.location;
        if(location+2 < labelContent.length){
            NSRange range = NSMakeRange(per.range.location, 3);
            NSRange nickRange = NSMakeRange(per.range.location+1, 2);
            NSString *nickName = [labelContent substringWithRange:nickRange];
            NSArray *allUsersNick = [[DDUserModule shareInstance] getAllUsersNick];
            NSUInteger index = [allUsersNick indexOfObject:nickName];
            NSString *linkName = [NSString stringWithFormat:@"%@%@%@",NICK_SPLIT,LINK_SPLIT,nickName];
            if(index != NSNotFound){
                [self.contentLabel addLinkToPhoneNumber:linkName withRange:range];
            }
        }
    }
    
    // 电话手机号码
    NSArray *phoneMatch = [self checkPhone:labelContent];
    for (NSTextCheckingResult *per in phoneMatch)
    {
        NSString *phone = [labelContent substringWithRange:per.range];
        NSString *linkName = [NSString stringWithFormat:@"%@%@%@",PHONE_SPLIT,LINK_SPLIT,phone];
        [self.contentLabel addLinkToPhoneNumber:linkName withRange:per.range];
    }
    
    // 邮箱识别
    NSArray *emailMatch = [self checkEmail:labelContent];
    for (NSTextCheckingResult *per in emailMatch)
    {
        NSString *email = [labelContent substringWithRange:per.range];
        NSString *linkName = [NSString stringWithFormat:@"%@%@%@",EMAIL_SPLIT,LINK_SPLIT,email];
        [self.contentLabel addLinkToPhoneNumber:linkName withRange:per.range];
    }
}

- (NSArray *)checkNickname:(NSString*)string
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    return matches;
}

- (NSArray *)checkUrl:(NSString*)string
{
    if (!string) {
        return nil;
    }
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:URL_REGULA
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    return matches;
}

- (NSArray *)checkPhone:(NSString*)string
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:PHONE_REGULA
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    return matches;
}

- (NSArray *)checkEmail:(NSString*)string
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:EMAIL_REGULA
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    return matches;
}


#pragma mark - DDChatCellProtocol
- (CGSize)sizeForContent:(MTTMessageEntity*)message
{
    int with = (int)(2*CHATH(97));//SCREEN_WIDTH - kHEIGHT(72)*2//(int)kHEIGHT(90)*2
    message.msgContent = [WPMySecurities textFromEmojiString:message.msgContent];
    NSString* content = [message.msgContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CGRect size = [content boundingRectWithSize:CGSizeMake(with, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:systemFont(fontsize),NSFontAttributeName, nil] context:nil];//systemFont(fontsize)
    if(size.size.width>with){
        return CGSizeMake(with, size.size.height);
    }
    size.size.height = size.size.height+1;
    size.size.width = size.size.width+1;
    
//    int with = (int)(2*CHATH(97));
//    message.msgContent = [WPMySecurities textFromEmojiString:message.msgContent];
//    NSString* content = [message.msgContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    CGSize size = [content getSizeWithFont:systemFont(fontsize) Width:with];
//    if(size.width>with){
//        return CGSizeMake(with, size.height);
//    }
//    size.height = size.height+1;
//    size.width = size.width+1;

    return size.size;
}

- (float)contentUpGapWithBubble
{
    switch (self.location)
    {
        case DDBubbleLeft:
            return self.leftConfig.inset.top;
        case DDBubbleRight:
            return self.rightConfig.inset.top;
    }
}

- (float)contentDownGapWithBubble
{
    switch (self.location)
    {
        case DDBubbleLeft:
            return self.leftConfig.inset.bottom;
        case DDBubbleRight:
            return self.rightConfig.inset.bottom;
    }
}

- (float)contentLeftGapWithBubble
{
    switch (self.location)
    {
        case DDBubbleLeft:
            return self.leftConfig.inset.left;
        case DDBubbleRight:
            return self.rightConfig.inset.left;
    }
}

- (float)contentRightGapWithBubble
{
    switch (self.location)
    {
        case DDBubbleLeft:
            return self.leftConfig.inset.right;
        case DDBubbleRight:
            return self.rightConfig.inset.right;
    }
}

- (void)layoutContentView:(MTTMessageEntity*)content
{
    CGSize size = [self sizeForContent:content];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubbleImageView.mas_left).offset([self contentLeftGapWithBubble]);
        make.top.equalTo(self.bubbleImageView.mas_top).offset([self contentUpGapWithBubble]+1);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+3));
    }];
}

- (float)cellHeightForMessage:(MTTMessageEntity*)message
{
    [super cellHeightForMessage:message];
    CGSize size = [self sizeForContent:message];
    float height = [self contentUpGapWithBubble] + [self contentDownGapWithBubble] + size.height + 10;//dd_bubbleUpDown->10->20
    return height;
}

#pragma mark -
#pragma mark DDMenuImageView Delegate
//复制
- (void)clickTheCopy:(MenuImageView*)imageView
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.contentLabel.text;
}

- (void)clickTheEarphonePlay:(MenuImageView*)imageView
{
}

- (void)clickTheSpeakerPlay:(MenuImageView*)imageView
{
}
//点击再次发送
- (void)clickTheSendAgain:(MenuImageView*)imageView
{
    if (self.sendAgain)
    {
        self.sendAgain();
    }
}
//点击背景
- (void)tapTheImageView:(MenuImageView*)imageView
{
    //子类去继承
    [super tapTheImageView:imageView];
}

-(void)sendTextAgain:(MTTMessageEntity *)message success:(void(^)(NSString*,MTTMessageEntity*))Success
{
    if (self.isBlackNameOrNot||self.isDeleteOrNot)//被加入黑名单
    {
        DDMessageContentType msgContentType = DDMEssageLitterInviteAndApply;
        NSDictionary * dictionary = @{@"display_type":@"12",
                                      @"content":@{@"for_userid":@"",
                                                   @"for_username":@"",
                                                   @"note_type":self.isBlackNameOrNot?@"8":@"9",
                                                   @"create_userid":kShareModel.userId,
                                                   @"create_username":kShareModel.username,
                                                   @"for_user_info_1":@"",
                                                   @"for_user_info_0":@""
                                                   }
                                      };
        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity *blackMessage =[MTTMessageEntity makeMessage:contentStr session:message.sessionId MsgType:msgContentType];
        Success(@"1",blackMessage);
        return;
    }
    
//    double msgTime = [[NSDate date] timeIntervalSince1970];
//    message.msgTime = msgTime;
//    ChattingModule * mouble = [[ChattingModule alloc]init];
//    mouble.MTTSessionEntity = self.session;
//    [mouble updateSessionUpdateTime:message.msgTime];
    
    
    
    message.state = DDMessageSending;
    [self showSending];
    NSString * content = [NSString stringWithFormat:@"%@",message.msgContent];
    NSDictionary * dictionary = @{@"display_type":@"1",@"content":content};
    NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    content = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    message.msgContent = content;
    
    [[DDMessageSendManager instance] sendMessage:message isGroup:[message isGroupMessage]  Session:[[SessionModule instance] getSessionById:message.sessionId] completion:^(MTTMessageEntity* theMessage,NSError *error) {
        [self showSendSuccess];
        Success(@"0",nil);
    } Error:^(NSError *error) {
        [self showSendFailure];
    }];
}
@end
