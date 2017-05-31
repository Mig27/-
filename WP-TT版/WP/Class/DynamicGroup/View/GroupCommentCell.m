//
//  GroupCommentCell.m
//  WP
//
//  Created by 沈亮亮 on 16/4/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GroupCommentCell.h"
#import "WPMySecurities.h"

@implementation GroupCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellAccessoryNone;
        [self createUI];
        //        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
    }
    
    return self;
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)createUI
{
    self.commentLabel = [[MLLinkLabel alloc] init];
    self.commentLabel.font = kFONT(12);
    self.commentLabel.userInteractionEnabled = YES;
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.dataDetectorTypes = MLDataDetectorTypeAttributedLink;
    [self.contentView addSubview:self.commentLabel];
}

- (void)setDic:(CommentListModel *)dic
{
    NSString *nick_name = dic.created_nick_name;
    NSString *by_nick_name = dic.replay_nick_name;
    NSString *speak_comment_content = [WPMySecurities textFromEmojiString:dic.comment_content];
    speak_comment_content = [WPMySecurities textFromBase64String:speak_comment_content];
    if (!speak_comment_content.length) {
        speak_comment_content = [WPMySecurities textFromEmojiString:dic.comment_content];
    }
    
    
    NSString *discussStr;
    NSMutableAttributedString *attributedStr;
    NSString *index = [NSString stringWithFormat:@"%d",1];
    if (by_nick_name.length == 0) { //没有回复人
        discussStr = [NSString stringWithFormat:@"%@ ：%@",nick_name,speak_comment_content];
        attributedStr = [[NSMutableAttributedString alloc] initWithString:discussStr];
        [attributedStr addAttribute:NSLinkAttributeName value:index range:NSMakeRange(0,nick_name.length)];
        
    } else {  //有回复人
        discussStr = [NSString stringWithFormat:@"%@ 回复 %@ ：%@",nick_name,by_nick_name,speak_comment_content];
        attributedStr = [[NSMutableAttributedString alloc] initWithString:discussStr];
        [attributedStr addAttribute:NSLinkAttributeName value:index range:NSMakeRange(0,nick_name.length)];
        [attributedStr addAttribute:NSLinkAttributeName value:index range:NSMakeRange(nick_name.length + 4,by_nick_name.length)];
        
    }
    
    CGFloat strH = [discussStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(12)]} context:nil].size.height;
    CGFloat x = kHEIGHT(10) + kHEIGHT(37) + 10;
    CGFloat width = SCREEN_WIDTH - 2*kHEIGHT(10) - kHEIGHT(37) - 10;
    if (self.dataSource.count == 1) {
        self.commentLabel.frame = CGRectMake(x, 0, width, strH);
    } else {
        if (self.currentIndex.row == 0) {
            self.commentLabel.frame = CGRectMake(x, 0, width, strH);
        } else  {
            self.commentLabel.frame = CGRectMake(x, 5, width, strH);
        }
    }
    
    self.commentLabel.attributedText = attributedStr;
    self.commentLabel.activeLinkTextAttributes = @{NSForegroundColorAttributeName:AttributedColor,NSBackgroundColorAttributeName:WPGlobalBgColor};
    
    for (MLLink *link in self.commentLabel.links) {
        link.linkTextAttributes = @{NSForegroundColorAttributeName:AttributedColor};
    }
    [self.commentLabel invalidateDisplayForLinks];
    [self.commentLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
//        NSDictionary *info = dic;
//        NSString *c_nick_name = info[@"nick_name"];
//        NSString *c_user_id = info[@"user_id"];
//        NSString *c_by_nick_name = info[@"by_nick_name"];
//        NSString *c_by_user_id = info[@"by_user_id"];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToPersonalHomePage" object:nil userInfo:@{@"user_id" : [linkText isEqualToString:c_nick_name] ? c_user_id : c_by_user_id,@"nick_name" : [linkText isEqualToString:c_nick_name] ? c_nick_name : c_by_nick_name}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"alumPersonal" object:nil userInfo:@{@"user_id" : dic.created_user_id,@"nick_name" : dic.created_nick_name}];
        
    }];

}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"GroupCommentCellID";
    GroupCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[GroupCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

+ (CGFloat)cellHeightWithIndex:(NSIndexPath *)index andDatasource:(NSArray *)data
{
   CommentListModel *dic = data[index.row];
    NSString *by_nick_name = dic.replay_nick_name;
    NSString *nick_name = dic.created_nick_name;
    //    CGSize normalSize1 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    NSString *commentStr;
    NSString * string = [WPMySecurities textFromEmojiString:dic.comment_content];
    string = [WPMySecurities textFromEmojiString:string];
    string = [WPMySecurities textFromBase64String:string];
    if (!string.length) {
        string = [WPMySecurities textFromEmojiString:dic.comment_content];
    }
    
    
    if (by_nick_name.length == 0) {
        commentStr = [NSString stringWithFormat:@"%@ ：%@",nick_name,string];
    } else {
        commentStr = [NSString stringWithFormat:@"%@ 回复 %@ ：%@",nick_name,by_nick_name,string];
    }
    CGFloat height = [commentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(12)]} context:nil].size.height;
    CGFloat cellHeight;
    if (data.count == 1) {
        cellHeight = height;
    } else {
        if (index.row == 0 || index.row == data.count - 1) {
            cellHeight = height + 5;
        } else {
            cellHeight = height + 10;//10
        }
    }
    return cellHeight;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
