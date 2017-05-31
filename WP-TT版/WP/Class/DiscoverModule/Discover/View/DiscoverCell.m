//
//  DiscoverCell.m
//  WP
//
//  Created by 沈亮亮 on 15/9/22.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "DiscoverCell.h"
#import "WZLBadgeImport.h"

@implementation DiscoverCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat height = kHEIGHT(43);
        CGFloat width = kHEIGHT(18);
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(14), (height - width)/2, width, width)];
        [self.contentView addSubview:self.icon];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right + kHEIGHT(14), (height - kHEIGHT(15))/2, SCREEN_WIDTH - width - 30, kHEIGHT(15))];
        self.title.font = kFONT(15);
        [self.contentView addSubview:self.title];
        
        
        self.badgageLabel = [[UILabel alloc]init];
        self.badgageLabel.hidden = YES;
        [self.contentView addSubview:self.badgageLabel];
        
        self.badgBtn = [[WPBadgeButton alloc] init];
//        [self.contentView addSubview:self.badgBtn];
        self.badgBtn.hidden = YES;

        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(14)-8, height/2-7, 8, 14)];
        imageView.image = [UIImage imageNamed:@"jinru"];
        [self.contentView addSubview:imageView];
        
        self.tipIcon = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.left - 8 -kHEIGHT(32), height/2 - kHEIGHT(32)/2, kHEIGHT(32), kHEIGHT(32))];
        self.tipIcon.clipsToBounds = YES;
        self.tipIcon.layer.cornerRadius = 5;
        self.tipIcon.contentMode = UIViewContentModeScaleAspectFill;
        self.tipIcon.image = [UIImage imageNamed:@"small_cell_picture"];
        self.tipIcon.badgeCenterOffset = CGPointMake(14, 0);
        [self.contentView addSubview:self.tipIcon];
        
        [self.contentView addSubview:self.badgBtn];
        self.redDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_dot_image"]];
//        self.redDot = [[UIImageView alloc] init];
        self.redDot.frame = CGRectMake(self.tipIcon.right - 4, self.tipIcon.top - 4, 8, 8);
        self.redDot.backgroundColor = [UIColor redColor];
        self.redDot.layer.masksToBounds = YES;
        self.redDot.layer.cornerRadius = 4;
//        [self.contentView addSubview:self.redDot];
//        [self bringSubviewToFront:self.redDot];
//        [self bringSubviewToFront:self.badgBtn];

        self.tipIcon.hidden = YES;
        self.redDot.hidden = YES;
    }
    return self;
}
-(void)setApplyCount:(NSString *)applyCount
{
//    CGSize size = [@"我的求职" getSizeWithFont:FUCKFONT(15) Height:kHEIGHT(43)];
    CGSize size = [@"我的求职" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    self.badgBtn.frame = CGRectMake(2*(kHEIGHT(14))+kHEIGHT(18)+size.width+8, kHEIGHT(43)/2 - 20/2,20, 20);
    self.badgBtn.badgeValue = applyCount.intValue < 99 ? applyCount : @"···";
    self.badgBtn.centerY = self.title.centerY;
    self.badgBtn.hidden = !applyCount.intValue;
}

-(void)setInviteCount:(NSString *)inviteCount
{
    CGSize size = [@"我的求职" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    self.badgBtn.frame = CGRectMake(2*(kHEIGHT(14))+kHEIGHT(18)+size.width+8, kHEIGHT(43)/2 - 20/2,20, 20);
    self.badgBtn.badgeValue = inviteCount.intValue < 99 ? inviteCount : @"···";
    self.badgBtn.centerY = self.title.centerY;
    self.badgBtn.hidden = !inviteCount.intValue;
}

- (void)setDic:(NSDictionary *)dic
{
    self.icon.image = [UIImage imageNamed:dic[@"image"]];
    self.title.text = dic[@"title"];
    CGSize normalSize = [dic[@"title"] sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    self.title.frame = CGRectMake(self.icon.right + kHEIGHT(14), (kHEIGHT(43) - kHEIGHT(15))/2, normalSize.width, kHEIGHT(15));
    
    self.badgBtn.frame = CGRectMake(self.title.right + 6, kHEIGHT(43)/2 - 20/2,20, 20);
    self.badgBtn.badgeValue = [dic[@"count"] integerValue] < 99 ? dic[@"count"] : @"···";
    self.badgBtn.centerY = self.title.centerY;
    self.badgBtn.centerY = kHEIGHT(43)/2 - kHEIGHT(32)/2+6;
    self.badgBtn.centerX = self.tipIcon.right-6;
    
    
    NSString *rul = [NSString stringWithFormat:@"%@%@",IPADDRESS,dic[@"avatar"]];
    [self.tipIcon sd_setImageWithURL:URLWITHSTR(rul) placeholderImage:[UIImage imageNamed:@"small_cell_picture"]];
    self.badgBtn.hidden = ![dic[@"count"] length];
    if ([dic[@"count"] integerValue] == 0) {
        self.badgBtn.hidden = YES;
        self.tipIcon.hidden = YES;
    }
    self.tipIcon.hidden = ![dic[@"count"] integerValue];
    self.redDot.hidden = ![dic[@"count"] integerValue];
    self.badgageLabel.hidden = YES;
    if ([dic[@"publishAvatar"] length]) {
        self.badgageLabel.frame = CGRectMake(self.title.right+6, (kHEIGHT(43) - kHEIGHT(15))/2-2, 8, 8);
        self.badgageLabel.backgroundColor = [UIColor redColor];
        self.badgageLabel.layer.cornerRadius = 4;
        self.badgageLabel.clipsToBounds = YES;
        self.badgageLabel.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
