//
//  WPCommonCommentBodyCell.m
//  WP
//
//  Created by CBCCBC on 15/12/2.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPCommonCommentBodyCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"

@implementation WPCommonCommentBodyCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.commentLabel = [[WPHotspotLabel alloc] init];
        self.commentLabel.userInteractionEnabled = YES;
        self.commentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.commentLabel];
    }
    return self;
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
        self.commentLabel.frame = CGRectMake(kHEIGHT(10)+kHEIGHT(43)+10, 0, SCREEN_WIDTH - 70, size.height);
        
    } else {
        NSDictionary* style = @{@"body":kFONT(12),
                                @"help":[WPAttributedStyleAction styledActionWithAction:^{
                                    NSLog(@"Help action");
                                    NSString *sid = [NSString stringWithFormat:@"%@",model.replayUserId];
                                    if (self.GoToUserInfo) {
                                        self.GoToUserInfo(sid,model.replayUserName);
                                    }
                                }],
                                @"settings":[WPAttributedStyleAction styledActionWithAction:^{
                                    NSLog(@"Settings action");
                                    NSString *sid = [NSString stringWithFormat:@"%@",model.beReplayUserId];
                                    if (self.GoToUserInfo) {
                                        self.GoToUserInfo(sid,model.beReplayUserName);
                                    }
                                }],
                                @"reply":@[[WPAttributedStyleAction styledActionWithAction:^{
                                    NSLog(@"reply action");
                                    if (self.ReplyThisContent) {
                                        self.ReplyThisContent(model);
                                    }
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
        self.commentLabel.frame = CGRectMake(kHEIGHT(10)+kHEIGHT(43)+10, 0, SCREEN_WIDTH - kHEIGHT(30) - 40, size.height);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
