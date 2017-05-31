//
//  GroupAlumDetailCommentCell.m
//  WP
//
//  Created by 沈亮亮 on 16/5/3.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GroupAlumDetailCommentCell.h"
#import "WPMySecurities.h"

@implementation GroupAlumDetailCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.userInteractionEnabled = YES;
        //        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
    }
    
    return self;
}

- (void)createUI
{
    CGSize normalSize1 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat icon_X = (kHEIGHT(37) + kHEIGHT(10) + 10 - kHEIGHT(30))/2;
    
    self.iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(icon_X, kHEIGHT(10), kHEIGHT(30), kHEIGHT(30))];
    self.iconBtn.layer.cornerRadius = 2.5;
    [self.iconBtn addTarget:self action:@selector(iconBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.iconBtn.clipsToBounds = YES;
    [self.contentView addSubview:self.iconBtn];
    
    self.titleLabel = [[MLLinkLabel alloc] init];
    self.titleLabel.frame = CGRectMake(self.iconBtn.right + icon_X, kHEIGHT(10), SCREEN_WIDTH - 100, normalSize1.height);
    self.titleLabel.font = kFONT(12);
    
    self.titleLabel.activeLinkTextAttributes = @{NSForegroundColorAttributeName:AttributedColor,NSBackgroundColorAttributeName:WPGlobalBgColor};
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80-kHEIGHT(10), kHEIGHT(10), 80, normalSize1.height)];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = RGB(170, 170, 170);
    self.timeLabel.font = kFONT(10);
    [self.contentView addSubview:self.timeLabel];
    
    
    self.subTitleLabel = [[MLLinkLabel alloc] init];
    self.subTitleLabel.font = kFONT(12);
    self.subTitleLabel.userInteractionEnabled = YES;
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.dataDetectorTypes = MLDataDetectorTypeAttributedLink;
    [self.contentView addSubview:self.subTitleLabel];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = RGB(235, 235, 235);
    [self.contentView addSubview:self.line];
}

- (void)iconBtnClick
{
    if (self.iconClickBlock) {
        self.iconClickBlock(self.currentIndex);
    }
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)setDic:(otherListModel *)dic
{
    self.timeLabel.text = dic.add_time;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,dic.avatar];//[IPADDRESS stringByAppendingString:dic.avatar];
    [self.iconBtn sd_setImageWithURL:URLWITHSTR(urlStr) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    NSString *nick_name = dic.created_nick_name;
    NSString *company = dic.company;
    NSString *position = dic.position;
    if ([position isEqualToString:@"(null)"]) {
        position = @"";
    }
    
    if ([company isEqualToString:@"(null)"]) {
        position = @"";
    }
    NSString *by_nick_name = dic.replay_nick_name;
    
    NSString *nameStr = nil;
    if (company.length && position.length) {
        nameStr = [NSString stringWithFormat:@"%@  %@ | %@",nick_name,position,company];
    }
    else
    {
        nameStr = [NSString stringWithFormat:@"%@  %@",nick_name,position.length?position:(company.length?company:@"")];
    }
    
//    NSString *nameStr = [NSString stringWithFormat:@"%@  %@ | %@",nick_name,position,company];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:nameStr];
    //    [str addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(0, nick_name.length)];
    [str addAttribute:NSLinkAttributeName value:@"7" range:NSMakeRange(0,nick_name.length)];
    [str addAttribute:NSFontAttributeName value:kFONT(10) range:NSMakeRange(nick_name.length,nameStr.length - nick_name.length)];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(127, 127, 127) range:NSMakeRange(nick_name.length,nameStr.length - nick_name.length)];
    self.titleLabel.attributedText = str;
    for (MLLink *link in self.titleLabel.links) {
        link.linkTextAttributes = @{NSForegroundColorAttributeName:AttributedColor};
    }
    [self.titleLabel invalidateDisplayForLinks];
    WS(ws);
    [self.titleLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        if (ws.iconClickBlock) {
            ws.iconClickBlock(ws.currentIndex);
        }
    }];
    
    NSString *commentStr;
    NSMutableAttributedString *commentAttStr;
    if (by_nick_name.length == 0) {
        commentStr = [NSString stringWithFormat:@"%@",[WPMySecurities textFromEmojiString:dic.comment_content]];
        commentStr = [WPMySecurities textFromBase64String:commentStr];
        if (!commentStr.length) {
          commentStr = [NSString stringWithFormat:@"%@",[WPMySecurities textFromEmojiString:dic.comment_content]];
        }
        
        commentAttStr = [[NSMutableAttributedString alloc] initWithString:commentStr];
    } else {
        
        NSString * string = [WPMySecurities textFromEmojiString:dic.comment_content];
        string = [WPMySecurities textFromBase64String:string];
        if (!string.length) {
            string = [WPMySecurities textFromEmojiString:dic.comment_content];
        }
        
        commentStr = [NSString stringWithFormat:@"回复 %@ ：%@",by_nick_name,string];
        commentAttStr = [[NSMutableAttributedString alloc] initWithString:commentStr];
        [commentAttStr addAttribute:NSLinkAttributeName value:@"7" range:NSMakeRange(3,by_nick_name.length)];
        
    }
    self.subTitleLabel.attributedText = commentAttStr;
    //可以从这里改颜色
    for (MLLink *link in self.subTitleLabel.links) {
        link.linkTextAttributes = @{NSForegroundColorAttributeName:AttributedColor};
    }
    [self.subTitleLabel invalidateDisplayForLinks];
    //    WS(ws);
    [self.subTitleLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        NSLog(@"点击人名");
        if (ws.nickNameClickBlock) {
            ws.nickNameClickBlock(ws.currentIndex);
        }
    }];
    CGFloat height = [self sizeWithString:commentStr fontSize:FUCKFONT(12)].height;
    self.subTitleLabel.frame = CGRectMake(self.titleLabel.left, self.titleLabel.bottom + 6, SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, height);
    self.line.frame = CGRectMake(0, self.subTitleLabel.bottom + kHEIGHT(10) - 0.5, SCREEN_WIDTH, 0.5);

}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"GroupAlumDetailCommentCellID";
    GroupAlumDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
        cell = [[GroupAlumDetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

+ (CGFloat)cellHeightWith:(otherListModel *)dic
{
    NSString *by_nick_name = dic.replay_nick_name;
    CGSize normalSize1 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    NSString *commentStr;
    NSString * string = [WPMySecurities textFromEmojiString:dic.comment_content];
    string = [WPMySecurities textFromBase64String:string];
    if (!string.length) {
        string = [WPMySecurities textFromEmojiString:dic.comment_content];
    }
    if (by_nick_name.length == 0) {
        commentStr = [NSString stringWithFormat:@"%@",string];
    } else {
        commentStr = [NSString stringWithFormat:@"回复 %@ ：%@",by_nick_name,string];
    }
    CGFloat height = [commentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(12)]} context:nil].size.height;
    
    return normalSize1.height + height + 6 + 2*kHEIGHT(10);
}

#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(37) - 2*kHEIGHT(10) - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
