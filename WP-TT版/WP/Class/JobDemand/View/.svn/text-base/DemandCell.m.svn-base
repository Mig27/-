//
//  DemandCell.m
//  WP
//
//  Created by 沈亮亮 on 15/8/28.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "DemandCell.h"

#import "UIImageView+WebCache.h"
#import "UIImage+MR.h"
#import "WPHttpTool.h"
#import "UIButton+WebCache.h"

@implementation DemandCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBColor(235, 235, 235);
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 394)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        self.iconBtn = [[WPButton alloc] init];
        self.iconBtn.frame = CGRectMake(10, 10, 40, 40);
        self.iconBtn.clipsToBounds = YES;
        self.iconBtn.layer.cornerRadius = 5;
        [self.contentView addSubview:self.iconBtn];
        
        self.nickName = [[WPNicknameLabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 10, SCREEN_WIDTH - 120, 20)];
        self.nickName.userInteractionEnabled = YES;
        self.nickName.font = [UIFont systemFontOfSize:15];
        self.nickName.text = @"华仔";
        [self.contentView addSubview:self.nickName];
        
        self.attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 52, 10, 42, 18)];
        self.attentionBtn.clipsToBounds = YES;
        self.attentionBtn.layer.cornerRadius = 5;
        self.attentionBtn.layer.borderColor = RGBColor(226, 226, 226).CGColor;
        self.attentionBtn.layer.borderWidth = 0.5;
        [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
        [self.attentionBtn setTitleColor:RGBColor(90, 118, 172) forState:UIControlStateNormal];
        self.attentionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.attentionBtn];
        
        self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 30, 34, 15)];
        //    self.positionLabel.textColor = [UIColor lightGrayColor];
        self.positionLabel.textColor = RGBColor(153, 153, 153);
        self.positionLabel.text = @"经理";
        self.positionLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.positionLabel];
        
        self.businessLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.positionLabel.right + 16, 30, SCREEN_WIDTH - 111, 15)];
        self.businessLabel.text = @"莱达商贸有限公司";
        //    self.businessLabel.textColor = [UIColor lightGrayColor];
        self.businessLabel.textColor = RGBColor(153, 153, 153);
        self.businessLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.businessLabel];
        
        UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 50, SCREEN_WIDTH - 68, 0.5)];
        //        line2.image = [UIImage imageNamed:@"small_seperator"];
        line2.backgroundColor = RGBColor(226, 226, 226);
        [self.contentView addSubview:line2];
        
        NSString *str = @"测试高度:";
        
        CGSize normalSize = [str sizeWithAttributes:@{NSFontAttributeName:GetFont(14)}];
        
        self.title1 = [[titleView alloc] initWithFrame:CGRectMake(0, self.iconBtn.bottom + 10, SCREEN_WIDTH, normalSize.height)];
        [self.contentView addSubview:self.title1];
        
        self.title2 = [[titleView alloc] initWithFrame:CGRectMake(0, self.title1.bottom + 8, SCREEN_WIDTH, normalSize.height)];
        [self.contentView addSubview:self.title2];
        
        self.title3 = [[titleView alloc] initWithFrame:CGRectMake(0, self.title2.bottom + 8, SCREEN_WIDTH, normalSize.height)];
        [self.contentView addSubview:self.title3];
        
        self.title4 = [[titleView alloc] initWithFrame:CGRectMake(0, self.title3.bottom + 8, SCREEN_WIDTH, normalSize.height)];
        [self.contentView addSubview:self.title4];
        
        self.title5 = [[titleView alloc] initWithFrame:CGRectMake(0, self.title4.bottom + 8, SCREEN_WIDTH, normalSize.height)];
        [self.contentView addSubview:self.title5];
        
        self.title6 = [[titleView alloc] initWithFrame:CGRectMake(0, self.title5.bottom + 8, SCREEN_WIDTH, normalSize.height)];
        [self.contentView addSubview:self.title6];
        
        self.lookMore = [[UILabel alloc] initWithFrame:CGRectMake(10, self.title6.bottom + 8, 120, normalSize.height)];
        self.lookMore.text = @"显示全部";
        self.lookMore.font = [UIFont systemFontOfSize:14];
        self.lookMore.textColor = RGBColor(90, 118, 172);
        [self.contentView addSubview:self.lookMore];
        
        self.photos = [[PhotoConsider alloc] initWithFrame:CGRectMake(0, self.lookMore.bottom + 8, SCREEN_WIDTH, 2)];
        //    self.photos.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.photos];
        
        self.adressLabel = [[UILabel alloc] init];
        self.adressLabel.textColor = [UIColor lightGrayColor];
        self.adressLabel.text = @"中绿广场";
        self.adressLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.adressLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.text = @"4小时前";
        self.timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.timeLabel];
        
        self.dustbinBtn = [[UIButton alloc] init];
        [self.dustbinBtn setImage:[UIImage imageNamed:@"small_rubish"] forState:UIControlStateNormal];
        //        [self.dustbinBtn addTarget:self action:@selector(dustbinClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.dustbinBtn];
        
        self.functionBtn = [WPButton buttonWithType:UIButtonTypeCustom];
        [self.functionBtn setImage:[UIImage imageNamed:@"small_backgound_button"] forState:UIControlStateNormal];
        [self.functionBtn setImage:[UIImage imageNamed:@"small_button_"] forState:UIControlStateHighlighted];
        self.functionBtn.selected = NO;
        //        [self.functionBtn addTarget:self action:@selector(functionClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.functionBtn];
        
        self.praiseLabel = [[UILabel alloc] init];
        self.praiseLabel.text = @"30";
        self.praiseLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.praiseLabel];
        
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.text = @"30";
        self.commentLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.commentLabel];
    }
    return self;
}

- (void)createUI
{

}

- (void)confineCellwithData:(NSDictionary *)dic
{
    NSInteger count = [dic[@"Photo"] count];
//    NSLog(@"*****%ld",(long)count);
    NSString *urlStr = [IPADDRESS stringByAppendingString:dic[@"avatar"]];
    [self.iconBtn sd_setImageWithURL:URLWITHSTR(urlStr) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    NSString *nameStr = dic[@"user_name"];
    NSString *nameStr1 = [nameStr stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
    NSString *nameStr2 = [nameStr1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
    self.nickName.text = nameStr2;
    self.positionLabel.text = dic[@"user_postion"];
    self.businessLabel.text = dic[@"user_company"];
    self.timeLabel.text = dic[@"add_time"];
    NSArray *titles = dic[@"Info"];
    self.title1.dic = titles[0];
    self.title1.needColor = YES;
    self.title2.dic = titles[1];
    self.title3.dic = titles[2];
    self.title4.dic = titles[3];
    self.title5.dic = titles[4];
    self.title6.dic = titles[5];
    
    NSString *str = @"测试高度:";
    CGSize normalSize = [str sizeWithAttributes:@{NSFontAttributeName:GetFont(14)}];
    
    if (count > 0) {
        self.photos.frame = CGRectMake(0, self.lookMore.bottom + 8, SCREEN_WIDTH, 76);

    }
    
    self.photos.dicInfo = dic[@"Photo"];
    
    CGSize nickNameSize = [dic[@"user_name"] sizeWithAttributes:@{NSFontAttributeName:GetFont(15)}];
    self.nickName.frame =  (CGRect){{self.iconBtn.right + 10, 10},nickNameSize};
    CGSize positionSize = [dic[@"user_postion"] sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    self.positionLabel.frame = (CGRect){{60,self.nickName.bottom + 4},positionSize};
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.positionLabel.right + 6, self.nickName.bottom + 6, 0.5, 12)];
    //        line1.image = [UIImage imageNamed:@"small_bounds"];
    line1.backgroundColor = RGBColor(226, 226, 226);
    [self.contentView addSubview:line1];
    
    CGSize businessSize = [dic[@"user_company"] sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    self.businessLabel.frame = (CGRect){{self.positionLabel.right + 12,self.nickName.bottom + 4},businessSize};

    UIImageView *adress = [[UIImageView alloc] init];
    
    adress.image = [UIImage imageNamed:@"small_address"];
    [self.contentView addSubview:adress];
    
    CGSize adressSize = [dic[@"address"] sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    
    if (count > 0) {
        adress.frame = CGRectMake(10, self.photos.bottom + 10, 10, 13);
        self.adressLabel.frame = (CGRect){{adress.right + 6, self.photos.bottom + 10},adressSize};
    } else {
        adress.frame = CGRectMake(10, self.lookMore.bottom + 10, 10, 13);
        self.adressLabel.frame = (CGRect){{adress.right + 6, self.lookMore.bottom + 10},adressSize};
    }
    
    
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.adressLabel.bottom + 10, SCREEN_WIDTH - 10, 1)];
    //    line3.image = [UIImage imageNamed:@"small_seperator"];
    line3.backgroundColor = RGBColor(226, 226, 226);
    [self.contentView addSubview:line3];

    CGSize timeSize = [dic[@"add_time"] sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    self.timeLabel.frame = (CGRect){{10,line3.bottom + 3},timeSize};
    
    self.dustbinBtn.frame = CGRectMake(self.timeLabel.right + 10, line3.bottom , 10 + 10, 12 + 10);
    [self.dustbinBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    self.functionBtn.frame = CGRectMake(SCREEN_WIDTH - 32, line3.bottom , 32, 25);
    [self.functionBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 10)];
    CGFloat backViewHeight;
    if (count>0) {
        backViewHeight = 60 + 7*normalSize.height + 6*8 + 8 + 76 + 10 + adressSize.height + 10 + 26;
    } else {
        backViewHeight = 60 + 7*normalSize.height + 6*8 + 10 + adressSize.height + 10 + 26;
    }
    
    self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, backViewHeight);
    
    NSString *speak_trends_person = [NSString stringWithFormat:@"%@",dic[@"commentCount"]];
    NSString *speak_praise_count = [NSString stringWithFormat:@"%@",dic[@"entryCount"]];
    self.commentLabel.text = speak_trends_person;
    self.praiseLabel.text = speak_praise_count;

    CGSize prasieSize = [speak_praise_count sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    self.praiseLabel.frame = (CGRect){{self.functionBtn.left - 18,line3.bottom + 5},prasieSize};
    //    self.praiseLabel.frame = CGRectMake(SCREEN_WIDTH - 50, line3.bottom + 5, 28, 15);
    
    UIButton *praiseBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.praiseLabel.left - 18 - 5, line3.bottom + 6 - 5, 14 + 10, 11 + 10)];
    [praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [praiseBtn setImage:[UIImage imageNamed:@"join_gray"] forState:UIControlStateNormal];
//    [praiseBtn setImage:[UIImage imageNamed:@"praise_blue"] forState:UIControlStateSelected];
    [self.contentView addSubview:praiseBtn];
    
    UIImageView *line5 = [[UIImageView alloc] initWithFrame:CGRectMake(praiseBtn.left - 18 + 5, line3.bottom + 5, 0.5, 15)];
    //    line5.image = [UIImage imageNamed:@"small_bounds"];
    line5.backgroundColor = RGBColor(226, 226, 226);
    [self.contentView addSubview:line5];
    
    CGSize commentSize = [speak_trends_person sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    self.commentLabel.frame = (CGRect){{line5.left-18-commentSize.width,line3.bottom + 5},commentSize};
    //    self.commentLabel.frame = CGRectMake(line5.left - 22, line3.bottom + 5, 28, 15);
    
    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.commentLabel.left - 18 - 5, line3.bottom + 6 - 5, 12 + 10, 11 + 10)];
    [commentBtn setImage:[UIImage imageNamed:@"small_message"] forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@"message_blue"] forState:UIControlStateSelected];
    [self.contentView addSubview:commentBtn];
    
    NSString *attention_state = [NSString stringWithFormat:@"%@",dic[@"isAttent"]];
    if ([attention_state isEqualToString:@"0"]) {
        [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    } else if([attention_state isEqualToString:@"1"]) {
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
    } else if ([attention_state isEqualToString:@"2"]) {
        [self.attentionBtn setTitle:@"关注我" forState:UIControlStateNormal];
    } else if ([attention_state isEqualToString:@"3"]) {
        [self.attentionBtn setTitle:@"互关注" forState:UIControlStateNormal];
    }

    NSString *is_own = [NSString stringWithFormat:@"%@",dic[@"isMyself"]];
    if ([is_own isEqualToString:@"1"]) {
        self.attentionBtn.hidden = YES;
        self.dustbinBtn.hidden = NO;
    } else {
        self.attentionBtn.hidden = NO;
        self.dustbinBtn.hidden = YES;
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
