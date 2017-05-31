//
//  groupCommentTableViewCell.m
//  WP
//
//  Created by CC on 16/9/10.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "groupCommentTableViewCell.h"
#import "WPMySecurities.h"

@implementation groupCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
    [self.iconBtn addTarget:self action:@selector(clickIconImage) forControlEvents:UIControlEventTouchUpInside];
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
-(void)clickIconImage
{
    if (self.clickIcon) {
        self.clickIcon(self.index);
    }
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    groupCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"groupCommentTableViewCellId"];
    if (!cell) {
        cell = [[groupCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupCommentTableViewCellId"];
    }
    return cell;
}
-(void)setModel:(DynamicNewsListModel *)model
{
    _model = model;
    CGFloat width = SCREEN_WIDTH - 2*kHEIGHT(10) - 20 - kHEIGHT(38) - kHEIGHT(50);
    CGSize normalSize2 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(10)}];
    NSString *urlStr = [IPADDRESS stringByAppendingString:model.avatar];
    [self.iconBtn sd_setBackgroundImageWithURL:URLWITHSTR(urlStr) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    NSString *nameStr = [NSString stringWithFormat:@"%@  %@ | %@",model.created_nick_name,model.position,model.companName];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:nameStr];
    [str addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(0, model.created_nick_name.length)];
    [str addAttribute:NSFontAttributeName value:kFONT(10) range:NSMakeRange(model.nick_name.length,nameStr.length - model.created_nick_name.length)];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(127, 127, 127) range:NSMakeRange(model.created_nick_name.length,nameStr.length - model.created_nick_name.length)];
    self.nameLabel.attributedText = str;

    
    
    NSString *commentStr = model.comment_content;
    
    CGFloat height = [commentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*kHEIGHT(10) - 20 - kHEIGHT(38) - kHEIGHT(50), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(12)]} context:nil].size.height;
    self.commentLabel.frame = CGRectMake(self.iconBtn.right + 10, self.nameLabel.bottom + 8, width, height);
    self.commentLabel.numberOfLines = 0;
    NSString *description1 = [WPMySecurities textFromBase64String:commentStr];
    NSString *lastDestription = [WPMySecurities textFromEmojiString:description1];

    NSMutableAttributedString *comStr = [[NSMutableAttributedString alloc] initWithString:lastDestription];
    if ([model.speak_reply isEqualToString:@"1"]) {
        [comStr addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(3, model.by_user_name.length)];
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
    self.photoImage.hidden = !model.avatar.length;
   
    NSString *imgUrl = [IPADDRESS stringByAppendingString:model.avatar];
    [self.photoImage sd_setImageWithURL:URLWITHSTR(imgUrl) placeholderImage:[UIImage imageNamed:@"placeImage"]];
    
    
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}
+ (CGFloat)rowHeightWithModel:(DynamicNewsListModel *)model
{
    NSString *commentStr = model.comment_content;
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
