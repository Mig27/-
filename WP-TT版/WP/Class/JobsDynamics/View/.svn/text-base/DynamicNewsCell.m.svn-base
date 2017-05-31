//
//  DynamicNewsCell.m
//  WP
//
//  Created by 沈亮亮 on 16/4/12.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "DynamicNewsCell.h"
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>
#import "WPMySecurities.h"

@implementation DynamicNewsCell

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
- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel
{

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
    [self.iconBtn addTarget:self action:@selector(clickIcon) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.iconBtn];
    
    self.nameLabel = [[MLLinkLabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 8,width, normalSize1.height)];
    self.nameLabel.font = kFONT(12);
    self.nameLabel.userInteractionEnabled = YES;
    self.nameLabel.dataDetectorTypes = MLDataDetectorTypeAttributedLink;
    [self.contentView addSubview:self.nameLabel];
    
    UITapGestureRecognizer * tapNameGstre = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickIcon)];
    [self.nameLabel addGestureRecognizer: tapNameGstre];
    
//  FIXME: 修改成block
    
    //在此处设置并没有效果需要看一下
//    __weak typeof(self) weakSelf = self;
//    [self.nameLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
//        if (weakSelf.clickPhoto) {
//            weakSelf.clickPhoto(weakSelf.index);
//        }
//        NSLog(@"点击了姓名");
//    }];

//    

    
    self.commentLabel = [[UILabel alloc] init];
    self.commentLabel.font = kFONT(12);
    self.commentLabel.numberOfLines = 0;
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
    
    self.dynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - kHEIGHT(50), 8, kHEIGHT(50), kHEIGHT(50))];
    self.dynamicLabel.font = kFONT(12);
    self.dynamicLabel.numberOfLines = 0;
    [self.contentView addSubview:self.dynamicLabel];
}
-(void)clickIcon
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
    DynamicNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicNewsCellId"];
    if (!cell) {
        cell = [[DynamicNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DynamicNewsCellId"];
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
    NSString *nameStr = [NSString stringWithFormat:@"%@  %@ | %@",model.nick_name,model.position,model.companName];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:nameStr];
    [str addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(0, model.nick_name.length)];
    [str addAttribute:NSFontAttributeName value:kFONT(10) range:NSMakeRange(model.nick_name.length,nameStr.length - model.nick_name.length)];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(127, 127, 127) range:NSMakeRange(model.nick_name.length,nameStr.length - model.nick_name.length)];
    self.nameLabel.attributedText = str;
    
    NSString * comStrin = model.com_content;
    comStrin = [WPMySecurities textFromEmojiString:comStrin];
    comStrin = [WPMySecurities textFromBase64String:comStrin];
    
    
    NSString *commentStr = [model.set_type isEqualToString:@"2"] ? @"分享" :comStrin;// [WPMySecurities textFromEmojiString:model.com_content]
    if ([model.speak_reply isEqualToString:@"1"]) {
        commentStr = [NSString stringWithFormat:@"回复 %@ ：%@",model.by_user_name,comStrin];//[WPMySecurities textFromEmojiString:model.com_content]
    }
    CGFloat height = [commentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*kHEIGHT(10) - 20 - kHEIGHT(38) - kHEIGHT(50), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(12)]} context:nil].size.height;
    self.commentLabel.frame = CGRectMake(self.iconBtn.right + 10, self.nameLabel.bottom + 8, width, height);
    NSMutableAttributedString *comStr = [[NSMutableAttributedString alloc] initWithString:commentStr];
    if ([model.speak_reply isEqualToString:@"1"]) {
        [comStr addAttribute:NSForegroundColorAttributeName value:AttributedColor range:NSMakeRange(3, model.by_user_name.length)];
    }
//    self.commentLabel.text = commentStr;
    self.commentLabel.attributedText = comStr;
    if ([model.set_type isEqualToString:@"0"]) {
        self.praiseImage.hidden = YES;
        self.commentLabel.hidden = NO;
        self.timeLabel.frame = CGRectMake(self.iconBtn.right + 10, self.commentLabel.bottom + 8, width, normalSize2.height);
    } else if ([model.set_type isEqualToString:@"2"]) {
        self.praiseImage.hidden = YES;
        self.commentLabel.hidden = NO;
        self.timeLabel.frame = CGRectMake(self.iconBtn.right + 10, self.commentLabel.bottom + 8, width, normalSize2.height);
    } else {
        self.commentLabel.hidden = YES;
        self.praiseImage.hidden = NO;
    }

    
    
    self.timeLabel.text = model.add_time;
    if ([model.content_type isEqualToString:@"1"]) {
        self.photoImage.hidden = YES;
        self.dynamicLabel.hidden = NO;
        self.dynamicLabel.text = [WPMySecurities textFromBase64String:model.speak_content];
    } else if ([model.content_type isEqualToString:@"2"]) {
        self.dynamicLabel.hidden = YES;
        self.photoImage.hidden = NO;
        NSString *urlStr = [IPADDRESS stringByAppendingString:model.speak_content];
        [self.photoImage sd_setImageWithURL:URLWITHSTR(urlStr) placeholderImage:[UIImage imageNamed:@"placeImage"]];
    } else {
        self.dynamicLabel.hidden = YES;
        self.photoImage.hidden = NO;
        NSString *urlStr = [IPADDRESS stringByAppendingString:model.speak_content];
        [self.photoImage sd_setImageWithURL:URLWITHSTR(urlStr) placeholderImage:[UIImage imageNamed:@"placeImage"]];
        UIButton *play = [UIButton buttonWithType:UIButtonTypeCustom];
        play.frame = CGRectMake(0, 0, kHEIGHT(50), kHEIGHT(50));
        play.userInteractionEnabled = NO;
        [play setImage:[UIImage imageNamed:@"播放小"] forState:UIControlStateNormal];
        //        play.center = video.center;
        [self.photoImage addSubview:play];

    }

}

+ (CGFloat)rowHeightWithModel:(DynamicNewsListModel *)model
{
    
    NSString * string = model.com_content;
    string = [WPMySecurities textFromEmojiString:string];
    string = [WPMySecurities textFromBase64String:string];
    if (!string.length) {
        string = [WPMySecurities textFromEmojiString:model.com_content];
    }
    
    
    NSString *commentStr = [model.set_type isEqualToString:@"2"] ? @"分享" : string;
    if ([model.speak_reply isEqualToString:@"1"]) {
        commentStr = [NSString stringWithFormat:@"回复 %@ ：%@",model.by_user_name,string];
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
