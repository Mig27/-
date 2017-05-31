//
//  AnswerCell.m
//  WP
//
//  Created by 沈亮亮 on 15/8/11.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "AnswerCell.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
#import "UIImage+MR.h"
#import "WPHttpTool.h"
#import "UIButton+WebCache.h"

@implementation AnswerCell

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

- (void)createUI
{
    self.iconBtn = [[WPButton alloc] init];
    self.iconBtn.frame = CGRectMake(15, 10, 30, 30);
    self.iconBtn.clipsToBounds = YES;
    self.iconBtn.layer.cornerRadius = 5;
    [self.contentView addSubview:self.iconBtn];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 15, 10, SCREEN_WIDTH - 120, 20)];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.text = @"华仔";
    [self.contentView addSubview:self.nameLabel];

    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- 40, 10, 30, 15)];
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textColor = RGBColor(170, 170, 170);
    [self.contentView addSubview:self.timeLabel];
    
    self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 15, self.nameLabel.bottom + 5, SCREEN_WIDTH - 70, 10)];
    self.commentLabel.font = [UIFont systemFontOfSize:12];
    self.commentLabel.numberOfLines = 3;
    [self.contentView addSubview:self.commentLabel];
    
}

- (void)confignCellWith:(NSDictionary *)dic
{
    NSString *urlStr = [IPADDRESS stringByAppendingString:dic[@"avatar"]];
//    [self.iconBtn sd_setImageWithURL:URLWITHSTR(urlStr) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    [self.iconBtn sd_setImageWithURL:URLWITHSTR(urlStr) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"small_cell_person"] options:SDWebImageLowPriority];
    self.nameLabel.text = dic[@"nick_name"];
    self.timeLabel.text = dic[@"answer_time"];
    self.commentLabel.text = dic[@"answer_content"];
    
    CGSize nickNameSize = [dic[@"nick_name"] sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    self.nameLabel.frame =  (CGRect){{self.iconBtn.right + 15, 10},nickNameSize};
    
    CGSize timeSize = [dic[@"answer_time"] sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    self.timeLabel.frame =  (CGRect){{SCREEN_WIDTH - timeSize.width - 10, 10},timeSize};

    
    CGFloat descriptionLabelHeight;//内容的显示高度
    if ([dic[@"answer_content"] length] == 0) {
        descriptionLabelHeight = 0;
    } else {
        descriptionLabelHeight = [self sizeWithString:dic[@"answer_content"] fontSize:12].height;
        if (descriptionLabelHeight > 16.702 *3) {
            descriptionLabelHeight = 16.702 *3;
        } else {
            descriptionLabelHeight = descriptionLabelHeight;
        }
    }
    self.commentLabel.frame = CGRectMake(self.iconBtn.right + 15, self.nameLabel.bottom + 3, SCREEN_WIDTH - 70, descriptionLabelHeight);

}

#pragma mark - 获取string的size
- (CGSize)sizeWithString:(NSString *)string fontSize:(CGFloat)fontSize
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
