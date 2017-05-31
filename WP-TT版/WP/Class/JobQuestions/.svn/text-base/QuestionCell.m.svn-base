//
//  QuestionCell.m
//  WP
//
//  Created by 沈亮亮 on 15/8/7.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "QuestionCell.h"

#import "UIImageView+WebCache.h"
#import "UIImage+MR.h"
#import "WPHttpTool.h"
#import "UIButton+WebCache.h"

@implementation QuestionCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = RGBColor(235, 235, 235);
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200 - 6)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        //        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        //        self.iconImage.image = [UIImage imageNamed:@"small_cell_person"];
        //        self.iconImage.clipsToBounds  = YES;
        //        self.iconImage.layer.cornerRadius = 5;
        //        [self.contentView addSubview:self.iconImage];
        
        self.iconBtn = [[WPButton alloc] init];
        self.iconBtn.frame = CGRectMake(10, 10, 40, 40);
        self.iconBtn.clipsToBounds = YES;
        self.iconBtn.layer.cornerRadius = 5;
        [self.contentView addSubview:self.iconBtn];
        
        //        self.iconImage.userInteractionEnabled = YES;
        //        self.iconControl = [[WPControl alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        //        [self.iconImage addSubview:self.iconControl];
        
        self.nickName = [[UILabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 10, SCREEN_WIDTH - 120, 20)];
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
        //        [self.attentionBtn addTarget:self action:@selector(attentionClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.attentionBtn];
        
        self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 30, 34, 15)];
        self.positionLabel.textColor = [UIColor lightGrayColor];
        self.positionLabel.text = @"经理";
        self.positionLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.positionLabel];
        
//        UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(92, 32, 1, 12)];
//        //        line1.image = [UIImage imageNamed:@"small_bounds"];
//        line1.backgroundColor = RGBColor(235, 235, 235);
//        [self.contentView addSubview:line1];
        
        self.businessLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.positionLabel.right + 16, 30, SCREEN_WIDTH - 111, 15)];
        self.businessLabel.text = @"莱达商贸有限公司";
        self.businessLabel.textColor = [UIColor lightGrayColor];
        self.businessLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.businessLabel];
        
        UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 50, SCREEN_WIDTH - 68, 1)];
        //        line2.image = [UIImage imageNamed:@"small_seperator"];
        line2.backgroundColor = RGBColor(235, 235, 235);
        [self.contentView addSubview:line2];
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, line2.bottom + 8, SCREEN_WIDTH - 20, 0)];
        self.descriptionLabel.text = @"我是谁的水";
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.font = [UIFont systemFontOfSize:14];
        self.descriptionLabel.userInteractionEnabled = YES;
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo)];
        longPressGr.minimumPressDuration = 0.5;
        [self.descriptionLabel addGestureRecognizer:longPressGr];
        [self.contentView addSubview:self.descriptionLabel];
        
        self.photos = [[imageConsider alloc] initWithFrame:CGRectMake(0, self.descriptionLabel.bottom, SCREEN_WIDTH, 0)];
        //        self.photos.backgroundColor = [UIColor lightGrayColor];
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

- (void)longPressToDo{
    
}


- (void)confineCellwithData:(NSDictionary *)dic
{
    //    NSLog(@"^^^^^%@",dic[@"original_photos"][0][@"media_address"]);
//    NSLog(@"<<<<<<<>>>>>%@",dic);
    self.myDic = dic;
    NSInteger count = [dic[@"imgCount"] integerValue];
    NSInteger videoCount = [dic[@"videoCount"] integerValue];
    NSString *urlStr = [IPADDRESS stringByAppendingString:dic[@"avatar"]];
    [self.iconBtn sd_setImageWithURL:URLWITHSTR(urlStr) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    self.nickName.text = dic[@"nick_name"];
    self.positionLabel.text = dic[@"POSITION"];
    self.businessLabel.text = dic[@"company"];
    self.timeLabel.text = dic[@"speak_add_time"];
    self.descriptionLabel.text = dic[@"speak_comment_content"];
    
    CGFloat descriptionLabelHeight;//内容的显示高度
    if ([dic[@"speak_comment_content"] length] == 0) {
        descriptionLabelHeight = 0;
    } else {
        descriptionLabelHeight = [self sizeWithString:dic[@"speak_comment_content"] fontSize:14].height;
        if (descriptionLabelHeight > 16.702 *6) {
            if (self.type == QuestionCellTypeNormal) {
                descriptionLabelHeight = 16.702 *6;
            } else {
                descriptionLabelHeight = descriptionLabelHeight;
            }
        } else {
            descriptionLabelHeight = descriptionLabelHeight;
        }
    }
    
    self.descriptionLabel.frame = CGRectMake(10, 60, SCREEN_WIDTH - 20, descriptionLabelHeight);
    
    //    NSLog(@"******%ld",(long)self.descriptionLabel.numberOfLines);
    //    NSLog(@"####%f",self.descriptionLabel.size.height);
    
    __block CGFloat photosHeight;//定义照片的高度
    self.photos.condiderType = ConsiderLayoutTypeQuestion;
       if (videoCount == 1) {
            NSLog(@"cell 有视频");
            photosHeight = 76;
        } else {
            if (count == 0) {
                photosHeight = 0;
            } else if (count >= 1 && count <= 3) {
                photosHeight = 76;
            } else if (count >= 4 && count <= 6) {
                photosHeight = 76*2 + 3;
            } else {
                photosHeight = 76*3 + 6;
            }
            
        }
        
    self.photos.frame = CGRectMake(0, self.descriptionLabel.bottom - 2, SCREEN_WIDTH, photosHeight + 10);
    self.photos.dicInfo = dic;
    
    CGFloat backViewHeight;
    //    if (self.descriptionLabel.size.height > 16.702 *6) {
    //        self.descriptionLabel.frame = CGRectMake(58, 60, SCREEN_WIDTH - 68, 16.702*6);
    //        backViewHeight = 16.702*6 + photosHeight + 125 - 9;
    //    } else {
    backViewHeight = descriptionLabelHeight + photosHeight + 125 - 9;
    //    }
    
    if ([dic[@"address"] length] == 0) {
        if ([dic[@"original_photos"] count] == 0) {
            self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, backViewHeight - 27 + 6);
        } else {
            self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, backViewHeight - 22 + 6 + 2);
        }
    } else {
        self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, backViewHeight + 6);
    }
    
    
#pragma 更改下面的坐标
    
    CGSize nickNameSize = [dic[@"nick_name"] sizeWithAttributes:@{NSFontAttributeName:GetFont(15)}];
    self.nickName.frame =  (CGRect){{self.iconBtn.right + 10, 10},nickNameSize};
    CGSize positionSize = [dic[@"POSITION"] sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    self.positionLabel.frame = (CGRect){{60,self.nickName.bottom + 4},positionSize};
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.positionLabel.right + 6, self.nickName.bottom + 6, 1, 12)];
    //        line1.image = [UIImage imageNamed:@"small_bounds"];
    line1.backgroundColor = RGBColor(235, 235, 235);
    [self.contentView addSubview:line1];
    
    CGSize businessSize = [dic[@"company"] sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    self.businessLabel.frame = (CGRect){{self.positionLabel.right + 12,self.nickName.bottom + 4},businessSize};
    
    UIImageView *adress = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.photos.bottom + 10, 10, 13)];
    adress.image = [UIImage imageNamed:@"small_address"];
    [self.contentView addSubview:adress];
    
    CGSize adressSize = [dic[@"address"] sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    self.adressLabel.frame = (CGRect){{adress.right + 6, self.photos.bottom + 10},adressSize};
    
//    self.adressLabel.frame = CGRectMake(adress.right + 6, self.photos.bottom + 8, SCREEN_WIDTH - 120, 15);
    self.adressLabel.text = dic[@"address"];
    NSString *speak_trends_person = [NSString stringWithFormat:@"%@",dic[@"speak_trends_person"]];
    NSString *speak_praise_count = [NSString stringWithFormat:@"%@",dic[@"speak_praise_count"]];
    self.commentLabel.text = speak_trends_person;
    self.praiseLabel.text = speak_praise_count;
    NSString *is_own = [NSString stringWithFormat:@"%@",dic[@"is_own"]];
    if ([is_own isEqualToString:@"0"]) {
        self.attentionBtn.hidden = YES;
        self.dustbinBtn.hidden = NO;
    } else {
        self.attentionBtn.hidden = NO;
        self.dustbinBtn.hidden = YES;
    }
    
    NSString *attention_state = [NSString stringWithFormat:@"%@",dic[@"attention_state"]];
    if ([attention_state isEqualToString:@"0"]) {
        [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    } else if([attention_state isEqualToString:@"1"]) {
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
    } else if ([attention_state isEqualToString:@"2"]) {
        [self.attentionBtn setTitle:@"被关注" forState:UIControlStateNormal];
    } else if ([attention_state isEqualToString:@"3"]) {
        [self.attentionBtn setTitle:@"互关注" forState:UIControlStateNormal];
    }
    
    UIImageView *line3 = [[UIImageView alloc] init];
    
    if ([dic[@"address"] length] == 0) {
        adress.hidden = YES;
        if ([dic[@"original_photos"] count] == 0) {
            line3.frame = CGRectMake(10, self.photos.bottom + 1, SCREEN_WIDTH - 20, 1);
        } else {
            line3.frame = CGRectMake(10, self.photos.bottom + 10, SCREEN_WIDTH - 20, 1);
        }
    } else {
        line3.frame = CGRectMake(10, self.photos.bottom + 31, SCREEN_WIDTH - 20, 1);
    }
    
    //    line3.image = [UIImage imageNamed:@"small_seperator"];
    line3.backgroundColor = RGBColor(235, 235, 235);
    [self.contentView addSubview:line3];
    
    CGSize timeSize = [dic[@"speak_add_time"] sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    self.timeLabel.frame = (CGRect){{10,line3.bottom + 3},timeSize};
    
//    self.timeLabel.frame = CGRectMake(58, line3.bottom + 3, 52, 15);
    
    
    //    UIImageView *line4 = [[UIImageView alloc] initWithFrame:CGRectMake(109, line3.bottom + 10, 1, 15)];
    //    line4.image = [UIImage imageNamed:@"small_bounds"];
    //    [self.contentView addSubview:line4];
    
    self.dustbinBtn.frame = CGRectMake(self.timeLabel.right + 10, line3.bottom , 10 + 10, 12 + 10);
    [self.dustbinBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    self.functionBtn.frame = CGRectMake(SCREEN_WIDTH - 32, line3.bottom , 32, 25);
    [self.functionBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 10)];
    
    //    self.functionView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 32, line3.bottom + 2, 0, 32)];
    //    self.functionView.backgroundColor = RGBColor(108, 255, 255);
    //    self.y = self.functionView.frame.origin.y;
    //    [self.contentView addSubview:self.functionView];
    
    CGSize prasieSize = [speak_praise_count sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    self.praiseLabel.frame = (CGRect){{self.functionBtn.left - 18,line3.bottom + 5},prasieSize};
//    self.praiseLabel.frame = CGRectMake(SCREEN_WIDTH - 50, line3.bottom + 5, 28, 15);
    
    UIButton *praiseBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.praiseLabel.left - 18 - 5, line3.bottom + 6 - 5, 12 + 10, 11 + 10)];
    [praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [praiseBtn setImage:[UIImage imageNamed:@"small_good"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"praise_blue"] forState:UIControlStateSelected];
    self.praiseBtn = praiseBtn;
    self.praiseBtn.tag = 10000;
    if (self.type == QuestionCellTypeSpecial) {
        [self.praiseBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.contentView addSubview:praiseBtn];
    
    UIImageView *line5 = [[UIImageView alloc] initWithFrame:CGRectMake(praiseBtn.left - 18 + 5, line3.bottom + 5, 1, 15)];
    //    line5.image = [UIImage imageNamed:@"small_bounds"];
    line5.backgroundColor = RGBColor(235, 235, 235);
    [self.contentView addSubview:line5];
    
    CGSize commentSize = [speak_trends_person sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    self.commentLabel.frame = (CGRect){{line5.left-18-commentSize.width,line3.bottom + 5},commentSize};
//    self.commentLabel.frame = CGRectMake(line5.left - 22, line3.bottom + 5, 28, 15);
    
    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.commentLabel.left - 18 - 5, line3.bottom + 6 - 5, 12 + 10, 11 + 10)];
    if (!self.isComment) {
        [commentBtn setImage:[UIImage imageNamed:@"answer_gray"] forState:UIControlStateNormal];
        [commentBtn setImage:[UIImage imageNamed:@"answer_blue"] forState:UIControlStateSelected];
    } else {
        [commentBtn setImage:[UIImage imageNamed:@"small_message"] forState:UIControlStateNormal];
        [commentBtn setImage:[UIImage imageNamed:@"message_blue"] forState:UIControlStateSelected];
    }
    self.commentBtn = commentBtn;
    self.commentBtn.tag = 10001;
    if (self.type == QuestionCellTypeSpecial) {
        [self.commentBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.contentView addSubview:commentBtn];
    if (self.type == QuestionCellTypeSpecial) {
        if (self.is_praise) {
            _praiseBtn.selected = YES;
            _commentBtn.selected = NO;
        } else {
            _praiseBtn.selected = NO;
            _commentBtn.selected = YES;
        }
    }
    
//    if (self.type == QuestionCellTypeSpecial) {
//        self.praiseBtn.userInteractionEnabled = YES;
//        self.commentBtn.userInteractionEnabled = YES;
//    } else {
//        self.praiseBtn.userInteractionEnabled = NO;
//        self.commentBtn.userInteractionEnabled = NO;
//    }
}

- (void)buttonClick:(UIButton *)btn
{
    if (btn.tag == 10000) {
        _commentBtn.selected = NO;
        _praiseBtn.selected = YES;
        [self.delegate reloadDataWith:@"2"];
    } else {
        _commentBtn.selected = YES;
        _praiseBtn.selected = NO;
        [self.delegate reloadDataWith:@"1"];
    }
}

#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
