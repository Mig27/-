//
//  WPMessageCell.m
//  WP
//
//  Created by Asuna on 15/5/20.
//  Copyright (c) 2015年 WP. All rights reserved.

#import "WPMessageCell.h"
#import "WPMessageModel.h"
#import "WPBadgeButton.h"

#import "UIImageView+WebCache.h"
#import "NSDate+Extension.h"

@interface WPMessageCell ()
@property (nonatomic, strong) WPBadgeButton* badgeButton;
@end

@implementation WPMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(10), kHEIGHT(43), kHEIGHT(43))];
        self.iconImage.layer.cornerRadius = 5;
        self.iconImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconImage];
        
        self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + 10, kHEIGHT(10), SCREEN_WIDTH - kHEIGHT(43) - 2*kHEIGHT(10) - 10 - 106, 21)];
        self.nameLable.font = kFONT(15);
        [self.contentView addSubview:self.nameLable];
        
        self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - 100, kHEIGHT(10), 100, 21)];
        self.timeLable.font = kFONT(12);
        self.timeLable.textAlignment = NSTextAlignmentRight;
        self.timeLable.textColor = RGB(170, 170, 170);
        [self.contentView addSubview:self.timeLable];
        
        self.detailLable = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + 10, self.iconImage.bottom - 21, SCREEN_WIDTH - kHEIGHT(43) - 2*kHEIGHT(10) - 10, 21)];
        self.detailLable.font = kFONT(12);
        self.detailLable.textColor = RGB(153, 153, 153);
        [self.contentView addSubview:self.detailLable];
        
        WPBadgeButton* badgeButton = [[WPBadgeButton alloc] init];
//        badgeButton.badgeValue = @"10";
        
        //badgeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:badgeButton];
        
        self.badgeButton = badgeButton;

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    // 添加一个提醒数字按钮
    WPBadgeButton* badgeButton = [[WPBadgeButton alloc] init];
    badgeButton.badgeValue = @"10";

    //badgeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:badgeButton];
    
    self.badgeButton = badgeButton;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageModel:(RSChatMessageModel *)messageModel
{
    if ([messageModel.avatarName isEqualToString:[NSString stringWithFormat:@"微聘团队"]]) {
        self.nameLable.textColor = WPColor(10, 110, 210);
    }
    //        [self.timeLable setTextColor:WPColor(187, 187, 187)];
    
    self.nameLable.text = messageModel.avatarName;
    //self.nameLable.frame = CGRectMake(67, 16, 80, 16);
    //        [self.nameLable setFont:[UIFont systemFontOfSize:15]];
    NSString *url = [IPADDRESS stringByAppendingString:messageModel.avatarUrl];
    [self.iconImage sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    //        self.iconImage.image = [UIImage imageNamed:messageModel.icon];
    self.detailLable.text = messageModel.messageDetail;
    //        [self.detailLable setTextColor:WPColor(170, 170, 170)];
    NSDate *currentData = [self dateFromString:messageModel.meaageTime];
    self.timeLable.text = [currentData prettyDateWithReference:[NSDate date]];
    self.badgeButton.frame = CGRectMake( kHEIGHT(45), kHEIGHT(2), 20, 20);
    if (messageModel.noReadCount == 0) {
        self.badgeButton.hidden = YES;
    } else {
        self.badgeButton.hidden = NO;
        self.badgeButton.badgeValue = [NSString stringWithFormat:@"%ld",messageModel.noReadCount];
    }

}

/**
 *  将字符串转换成NSDate类型
 *
 *  @param dateString 时间字符串
 *
 *  @return NSDate类型
 */
- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    return destDate;
    
}

+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString* ID = @"WPMessageCell";
    WPMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"WPMessageCell" owner:nil options:nil] lastObject];
        cell = [[WPMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

+ (CGFloat)rowHeight
{
    return kHEIGHT(58);
}

@end
