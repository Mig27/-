//
//  WPApplyAndInviteTableViewCell.m
//  WP
//
//  Created by CC on 17/1/5.
//  Copyright © 2017年 WP. All rights reserved.
//

#import "WPApplyAndInviteTableViewCell.h"

@implementation WPApplyAndInviteTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
//    WPNewResumeTableViewCell
    if ( self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10), (kHEIGHT(58)-kHEIGHT(43))/2, kHEIGHT(43), kHEIGHT(43))];
        self.iconImageView.layer.cornerRadius = 5;
        self.iconImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImageView];
        
        self.PCLabel = [[UILabel alloc]init];
        self.PCLabel.font = kFONT(15);
        self.PCLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.PCLabel];
        
        self.introduceLabel = [[UILabel alloc]init];
        self.introduceLabel.font = kFONT(12);
        self.introduceLabel.textColor = RGB(127, 127, 127);
        [self.contentView addSubview:self.introduceLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.font = kFONT(10);
        self.timeLabel.textColor = RGB(170, 170, 170);
        [self.contentView addSubview:self.timeLabel];
        
        self.stateLabel = [[UILabel alloc]init];
        self.stateLabel.font = kFONT(10);
        self.stateLabel.textColor = RGB(170, 170, 170);
        [self.contentView addSubview:self.stateLabel];
        
        self.badgBtn = [[WPBadgeButton alloc]init];
        self.badgBtn.frame = CGRectMake(self.iconImageView.right, self.iconImageView.top-6, 20, 20);
        self.badgBtn.centerX = self.iconImageView.right;
        self.badgBtn.hidden = YES;
        [self.contentView addSubview:self.badgBtn];
        
        //SCREEN_WIDTH-stateSize.width-kHEIGHT(10),self.iconImageView.top +(kHEIGHT(43))/2, stateSize.width, (kHEIGHT(43))/2
        CGSize stateSize = [@"已下架" getSizeWithFont:FUCKFONT(10) Height:(kHEIGHT(43))/2];
        self.freshImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-stateSize.width-kHEIGHT(10)-19-2, kHEIGHT(58)-24, 15, 15)];
        self.freshImage.image = [UIImage imageNamed:@"quanzhi_shuaxinpr"];
        self.freshImage.hidden = YES;
        
        [self.contentView addSubview:self.freshImage];
        
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, kHEIGHT(58)-0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [self.contentView addSubview:line];
        
        
    }
    return self;
}
-(void)setModel:(NearPersonalListModel *)model
{
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]] placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    NSString * titleString = nil;
    self.type == WPNewMeResumeTypeInterview?(titleString = @"求职"):(titleString = @"招聘");
    self.PCLabel.text = [NSString stringWithFormat:@"%@",model.position];
    
    NSString * introduceString = nil;
    self.type == WPNewMeResumeTypeInterview?(introduceString = [NSString stringWithFormat:@"%@ %@ %@ %@",model.nike_name,model.sex,model.worktime,model.education]):(introduceString = model.enterprise_name);
    self.introduceLabel.text = introduceString;
    self.timeLabel.text = model.updateTime;
//    self.stateLabel.text = model.shelvesDown.integerValue?@"已下架":@"已上架";
    switch (model.shelvesDown.intValue) {
        case 0://上架
            self.stateLabel.text = @"已上架";
            self.stateLabel.textColor = RGB(0, 172, 255);
            break;
        case 1:
            self.stateLabel.text = @"已下架";
            self.stateLabel.textColor = RGB(170, 170, 170);
            break;
        case 2://被下架
            self.stateLabel.text = @"被下架";
            self.stateLabel.textColor = RGB(250, 0, 0);
            break;
        default:
            break;
    }
    
//    CGSize pcSize = [titleString getSizeWithFont:FUCKFONT(15) Height:(kHEIGHT(43))/2];
//    CGSize introSize = [introduceString getSizeWithFont:FUCKFONT(11) Height:(kHEIGHT(43))/2];
    CGSize timeSize = [model.updateTime getSizeWithFont:FUCKFONT(11) Height:(kHEIGHT(43))/2];
    CGSize stateSize = [@"已下架" getSizeWithFont:FUCKFONT(10) Height:(kHEIGHT(43))/2];
    
    self.timeLabel.frame = CGRectMake(SCREEN_WIDTH-timeSize.width-kHEIGHT(10), self.iconImageView.top, timeSize.width,(kHEIGHT(43))/2);
    self.PCLabel.frame = CGRectMake(self.iconImageView.right+kHEIGHT(12), self.iconImageView.top, SCREEN_WIDTH-self.iconImageView.right-kHEIGHT(10)-kHEIGHT(10)-timeSize.width,(kHEIGHT(43))/2);
    self.stateLabel.frame = CGRectMake(SCREEN_WIDTH-stateSize.width-kHEIGHT(10),self.iconImageView.top +(kHEIGHT(43))/2, stateSize.width, (kHEIGHT(43))/2);
    self.introduceLabel.frame = CGRectMake(self.iconImageView.right+kHEIGHT(12), self.iconImageView.top+(kHEIGHT(43))/2, SCREEN_WIDTH-self.iconImageView.right-2*kHEIGHT(10)-stateSize.width, (kHEIGHT(43))/2);
    
    self.badgBtn.badgeValue = model.UnReadCount;
    self.badgBtn.hidden = !(model.UnReadCount.intValue);
    
    self.freshImage.centerY = self.stateLabel.centerY;
    self.freshImage.hidden = !model.is_auto.intValue;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
