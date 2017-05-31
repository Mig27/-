//
//  WPNewResumeCell.m
//  WP
//
//  Created by CBCCBC on 16/6/17.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPNewResumeCell.h"
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>
#import "WPMySecurities.h"

@implementation WPNewResumeCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

#pragma 布局UI
- (void)createUI
{
    CGSize normalSize1 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGSize normalSize2 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(10)}];
    CGFloat width = SCREEN_WIDTH - 2*kHEIGHT(10) - 20 - kHEIGHT(38) - kHEIGHT(50);
    self.iconBtn = [[WPButton alloc] initWithFrame:CGRectMake(kHEIGHT(10), 8, kHEIGHT(38), kHEIGHT(38))];
    self.iconBtn.clipsToBounds = YES;
    self.iconBtn.layer.cornerRadius = 5;
    [self.iconBtn addTarget:self action:@selector(clickphot) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.iconBtn];
    
    self.nameLabel = [[MLLinkLabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 8,width, normalSize1.height)];
    self.nameLabel.font = kFONT(12);
    [self.contentView addSubview:self.nameLabel];
    
    self.commentLabel = [[UILabel alloc] init];
    self.commentLabel.font = kFONT(12);
    [self.contentView addSubview:self.commentLabel];
    
    self.praiseImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, self.nameLabel.bottom + 8, 12, 12)];
    self.praiseImage.image = [UIImage imageNamed:@"praise_blue"];
    [self.contentView addSubview:self.praiseImage];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, self.praiseImage.bottom + 8, width, normalSize2.height)];
    self.timeLabel.font = kFONT(10);
    self.timeLabel.textColor = RGB(127, 127, 127);
    [self.contentView addSubview:self.timeLabel];
    
    self.photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - kHEIGHT(50), 8, kHEIGHT(50), kHEIGHT(50))];
    [self.contentView addSubview:self.photoImage];
    
//    self.dynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - kHEIGHT(50), 8, kHEIGHT(50), kHEIGHT(50))];
//    self.dynamicLabel.font = kFONT(12);
//    self.dynamicLabel.numberOfLines = 0;
//    [self.contentView addSubview:self.dynamicLabel];
}
-(void)clickphot
{
    if (self.clickPhoto) {
        self.clickPhoto(self.index);
    }
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    WPNewResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WPNewResumeCellId"];
    if (!cell) {
        cell = [[WPNewResumeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WPNewResumeCellId"];
    }
    return cell;
}

- (void)setModel:(DynamicNewsListModel *)model
{
    _model = model;
    CGFloat width = SCREEN_WIDTH - 2*kHEIGHT(10) - 20 - kHEIGHT(38) - kHEIGHT(50);
    CGSize normalSize2 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(10)}];
    NSString *urlStr = [IPADDRESS stringByAppendingString:model.avatar];
    [self.iconBtn sd_setBackgroundImageWithURL:URLWITHSTR(urlStr) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    NSString *nameStr = nil;//[NSString stringWithFormat:@"%@  %@ | %@",model.nick_name,model.position,model.companName]
    NSString * colorStr = nil;
    if ([model.set_type isEqualToString:@"4"])
    {
        if (self.type == NewsTypeInvite) {
            nameStr = model.companName;
            colorStr = model.companName;
        }
        else
        {
            nameStr = model.nick_name;
            colorStr = model.nick_name;
        }
    }
    else
    {
        nameStr = [NSString stringWithFormat:@"%@  %@ | %@",model.nick_name,model.position,model.companName];
        colorStr = model.nick_name;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:nameStr];
    [str addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(0, colorStr.length)];//model.nick_name
    [str addAttribute:NSFontAttributeName value:kFONT(10) range:NSMakeRange(colorStr.length,nameStr.length - colorStr.length)];//model.nick_name
    [str addAttribute:NSForegroundColorAttributeName value:RGB(127, 127, 127) range:NSMakeRange(colorStr.length,nameStr.length - colorStr.length)];//model.nick_name
    self.nameLabel.attributedText = str;
    __weak typeof(self) weakSelf = self;
    [self.nameLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        if (weakSelf.clickPhoto) {
            weakSelf.clickPhoto(weakSelf.index);
        }
    }];
    NSString * com_mentStr = model.com_content;
    NSString *description1 = [WPMySecurities textFromBase64String:com_mentStr];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    description3 = [description3 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    description3 = [description3 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSString * applyInviteStr = nil;
    if ([model.set_type isEqualToString:@"4"]) {
        if (self.type == NewsTypeInvite) {
            applyInviteStr = @"求职申请";
        }
        else
        {
          applyInviteStr = @"企业投递";
        }
    }
    //
    NSString *commentStr = [model.set_type isEqualToString:@"2"] ? @"分享" : ([model.set_type isEqualToString:@"4"] ? applyInviteStr : ([model.set_type isEqualToString:@"0"]?@"留言":description3));//model.speak_content//
    if ([model.speak_reply isEqualToString:@"1"] && ![model.by_user_name isEqualToString:kShareModel.nick_name]) {
        commentStr = [NSString stringWithFormat:@"回复%@的留言",model.by_user_name];
    }
    CGFloat height = [commentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*kHEIGHT(10) - 20 - kHEIGHT(38) - kHEIGHT(50), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(12)]} context:nil].size.height;
    self.commentLabel.frame = CGRectMake(self.iconBtn.right + 10, self.nameLabel.bottom + 8, width, height);
    self.commentLabel.numberOfLines = 1;
    
    commentStr = [model.set_type isEqualToString:@"2"] ? @"分享" : ([model.set_type isEqualToString:@"4"] ? applyInviteStr : ([model.set_type isEqualToString:@"0"]?[NSString stringWithFormat:@"留言：%@",description3]:description3));//model.speak_content//
    if ([model.speak_reply isEqualToString:@"1"] && ![model.by_user_name isEqualToString:kShareModel.nick_name]) {
        commentStr = [NSString stringWithFormat:@"回复%@的留言",model.by_user_name];
    }
    
    NSMutableAttributedString *comStr = [[NSMutableAttributedString alloc] initWithString:commentStr];
    if ([model.speak_reply isEqualToString:@"1"] && ![model.by_user_name isEqualToString:kShareModel.nick_name]) {
        [comStr addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(2, model.by_user_name.length)];//3—>2
    }
    self.commentLabel.attributedText = comStr;
    if ([model.set_type isEqualToString:@"1"]) {
        self.commentLabel.hidden = YES;
        self.praiseImage.hidden = NO;
    } else {
        self.praiseImage.hidden = YES;
        self.commentLabel.hidden = NO;
        self.timeLabel.frame = CGRectMake(self.iconBtn.right + 10, self.commentLabel.bottom + 8, width, normalSize2.height);
    }
    self.timeLabel.text = model.add_time;
    NSString *imgUrl = [IPADDRESS stringByAppendingString:model.img];
    [self.photoImage sd_setImageWithURL:URLWITHSTR(imgUrl) placeholderImage:[UIImage imageNamed:@"placeImage"]];
}

+ (CGFloat)rowHeightWithModel:(DynamicNewsListModel *)model
{
    NSString * com_mentStr = model.com_content;
    NSString *description1 = [WPMySecurities textFromBase64String:com_mentStr];
    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
    description3 = [description3 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    description3 = [description3 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *commentStr = [model.set_type isEqualToString:@"2"] ? @"分享" : ([model.set_type isEqualToString:@"4"] ? model.speak_content : @"留言");//description3
    if ([model.speak_reply isEqualToString:@"1"] && ![model.by_user_name isEqualToString:kShareModel.nick_name]) {
        commentStr = [NSString stringWithFormat:@"回复 %@ ：%@",model.by_user_name,description3];
    }
    CGSize normalSize1 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGSize normalSize2 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(10)}];
    CGFloat height = [commentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*kHEIGHT(10) - 20 - kHEIGHT(38) - kHEIGHT(50), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(12)]} context:nil].size.height;
    CGFloat commentH = height + normalSize1.height + normalSize2.height + 2*8;
    CGFloat rowHeight;
    if (commentH < kHEIGHT(50)) {
        rowHeight = kHEIGHT(50);
    } else {
        rowHeight = commentH;
    }
    return rowHeight + 2*8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
