//
//  CommentCell.m
//  WP
//
//  Created by 沈亮亮 on 15/8/21.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "CommentCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"


@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.commentLabel = [[MLLinkLabel alloc] init];
        self.commentLabel.font = kFONT(12);
        self.commentLabel.userInteractionEnabled = YES;
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.dataDetectorTypes = MLDataDetectorTypeAttributedLink;
        [self.contentView addSubview:self.commentLabel];
    }
    return self;
}

- (void)confignDataWith:(NSDictionary *)dic
{
    
    if ([dic[@"by_nick_name"] length] == 0) {
        NSDictionary* style = @{@"body":[UIFont systemFontOfSize:12],
                                 @"help":[WPAttributedStyleAction styledActionWithAction:^{
                                     NSLog(@"Help action");
                                 }],
                                 @"link": RGBColor(90, 118, 172)};
        NSString *string = [NSString stringWithFormat:@"<help>%@</help> : %@",dic[@"nick_name"],dic[@"speak_comment_content"]];
        self.commentLabel.attributedText = [string attributedStringWithStyleBook:style];
        NSString *str = [NSString stringWithFormat:@"%@ : %@",dic[@"nick_name"],dic[@"speak_comment_content"]];
        CGSize size = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        self.commentLabel.frame = CGRectMake(60, 0, SCREEN_WIDTH - 70, size.height);

    } else {
        
        NSString *nick_name = dic[@"nick_name"];
        NSString *nick_name1 = [nick_name stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
        NSString *nick_name2 = [nick_name1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
        
        NSString *by_nick_name = dic[@"by_nick_name"];
        NSString *by_nick_name1 = [by_nick_name stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
        NSString *by_nick_name2 = [by_nick_name1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];

        NSString *speak_comment_content = dic[@"speak_comment_content"];
        NSString *speak_comment_content1 = [speak_comment_content stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
        NSString *speak_comment_content2 = [speak_comment_content1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
        NSString *speak_comment_content3 = [speak_comment_content2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
        NSString *string = [NSString stringWithFormat:@"%@ 回复 %@ : %@",nick_name2,by_nick_name2,speak_comment_content3];
        CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - kHEIGHT(30) - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFONT(12)} context:nil].size;
        self.commentLabel.frame = CGRectMake(kHEIGHT(30) + 30, 0, SCREEN_WIDTH - kHEIGHT(30) - 40, size.height);
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:string];
        [attrStr addAttribute:NSLinkAttributeName value:@"http://google.com" range:NSMakeRange(0, nick_name2.length)];
        [attrStr addAttribute:NSLinkAttributeName value:@"dudl@qq.com" range:NSMakeRange(nick_name2.length + 4, by_nick_name2.length)];
        self.commentLabel.attributedText = attrStr;
        [self.commentLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            if ([linkText isEqualToString:nick_name2]) {
                NSLog(@"回复人");
            } else {
                NSLog(@"被回复人");
            }
        }];

    }
    
}

- (void)confignDataWithModel:(WPResumeCheckReplayCommentListModel *)model{
    if ([model.beReplayUserName length] == 0) {
        NSDictionary* style = @{@"body":[UIFont systemFontOfSize:12],
                                @"help":[WPAttributedStyleAction styledActionWithAction:^{
                                    NSLog(@"Help action");
                                }],
                                @"link": RGBColor(90, 118, 172)};
        NSString *string = [NSString stringWithFormat:@"<help>%@</help> : %@",model.beReplayUserName,model.replayCommentContent];
        self.commentLabel.attributedText = [string attributedStringWithStyleBook:style];
        NSString *str = [NSString stringWithFormat:@"%@ : %@",model.replayUserName,model.replayCommentContent];
        CGSize size = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        self.commentLabel.frame = CGRectMake(60, 0, SCREEN_WIDTH - 70, size.height);
        
    } else {
        NSDictionary* style = @{@"body":kFONT(12),
                                @"help":[WPAttributedStyleAction styledActionWithAction:^{
                                    NSLog(@"Help action");
                                    NSString *sid = [NSString stringWithFormat:@"%@",model.replayUserId];
                                    [self.delegate jumpToPersonalPageWith:sid andNickName:model.replayUserName];
                                }],
                                @"settings":[WPAttributedStyleAction styledActionWithAction:^{
                                    NSLog(@"Settings action");
                                    NSString *sid = [NSString stringWithFormat:@"%@",model.beReplayUserId];
                                    [self.delegate jumpToPersonalPageWith:sid andNickName:model.beReplayUserName];
                                }],
                                @"reply":@[[WPAttributedStyleAction styledActionWithAction:^{
                                    NSLog(@"reply action");
                                    [self.delegate commentTopicWith:nil];
                                }],[UIColor blackColor]],
                                @"link": RGBColor(90, 118, 172)};
        
        NSString *nick_name = model.replayUserName;
        NSString *nick_name1 = [nick_name stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
        NSString *nick_name2 = [nick_name1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
        
        NSString *by_nick_name = model.beReplayUserName;
        NSString *by_nick_name1 = [by_nick_name stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
        NSString *by_nick_name2 = [by_nick_name1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
        
        NSString *speak_comment_content = model.replayCommentContent;
        NSString *speak_comment_content1 = [speak_comment_content stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
        NSString *speak_comment_content2 = [speak_comment_content1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
        NSString *speak_comment_content3 = [speak_comment_content2 stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
        //        NSString *string = [NSString stringWithFormat:@"<help>%@</help> <reply>回复</reply> <settings>%@</settings> : <reply>%@</reply>",dic[@"nick_name"],dic[@"by_nick_name"],dic[@"speak_comment_content"]];
        NSString *string = [NSString stringWithFormat:@"<help>%@</help> <reply>回复</reply> <settings>%@</settings> : <reply>%@</reply>",nick_name2,by_nick_name2,speak_comment_content3];
        self.commentLabel.attributedText = [string attributedStringWithStyleBook:style];
        NSString *str = [NSString stringWithFormat:@"%@ 回复 %@ : %@",model.replayUserName,model.beReplayUserName,model.replayCommentContent];
        CGSize size = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - kHEIGHT(30) - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFONT(12)} context:nil].size;
        self.commentLabel.frame = CGRectMake(kHEIGHT(30) + 30, 0, SCREEN_WIDTH - kHEIGHT(30) - 40, size.height);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
