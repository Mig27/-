//
//  WPMeActivitiesCell.m
//  WP
//
//  Created by CBCCBC on 16/1/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMeActivitiesCell.h"

@implementation WPMeActivitiesCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat height = kHEIGHT(43);
        CGFloat width = kHEIGHT(18);
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(14), (height - width)/2, width, width)];
        [self.contentView addSubview:self.iconImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.right + kHEIGHT(14), (height - kHEIGHT(15))/2, SCREEN_WIDTH - width - 30, kHEIGHT(15))];
        self.titleLabel.font = kFONT(15);
        [self.contentView addSubview:self.titleLabel];
        
        //self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(14)-8, height/2-7, 8, 14)];
        imageView.image = [UIImage imageNamed:@"jinru"];
        [self.contentView addSubview:imageView];
        
        self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.left-105, 0, 100, height)];
        self.countLabel.textAlignment = NSTextAlignmentRight;
        self.countLabel.font = kFONT(15);
        self.countLabel.textColor = RGB(170, 170, 170);
        [self.contentView addSubview:self.countLabel];
        
        self.badgageBtn = [[WPBadgeButton alloc]init];
        CGSize size = [@"我发布的求职" getSizeWithFont:FUCKFONT(15) Height:kHEIGHT(43)];
        self.badgageBtn.frame = CGRectMake(2*(kHEIGHT(14))+kHEIGHT(18)+size.width+8, (kHEIGHT(43)-20)/2, 20, 20);
        self.badgageBtn.hidden = YES;
        self.badgageBtn.centerY = (kHEIGHT(43)/2);
        [self.contentView addSubview:self.badgageBtn];
    }
    return self;
}

-(void)setApplyCount:(NSString *)applyCount
{
    self.badgageBtn.badgeValue = applyCount;
    self.badgageBtn.hidden = !applyCount.intValue;
}

-(void)setInviteCount:(NSString *)inviteCount
{
    self.badgageBtn.badgeValue = inviteCount;
    self.badgageBtn.hidden = !inviteCount.intValue;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
