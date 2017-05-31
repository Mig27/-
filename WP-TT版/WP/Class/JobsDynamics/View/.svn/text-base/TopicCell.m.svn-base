//
//  TopicCell.m
//  WP
//
//  Created by 沈亮亮 on 16/2/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "TopicCell.h"

@implementation TopicCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        //        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
    }
    
    return self;
}

- (void)createUI
{
    //    self.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.iconBtn.frame = CGRectMake(kHEIGHT(10), kHEIGHT(43)/2 - 7.5, 15, 15);
    //    [self.contentView addSubview:self.iconBtn];
    
    CGSize normalSize1 = [@"匿名吐槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize normalSize2 = [@"以匿名形式发布说说" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat y = (kHEIGHT(58) - normalSize1.height - normalSize2.height - 10)/2;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = kFONT(15);
    
    self.titleLabel.frame = CGRectMake(kHEIGHT(10), kHEIGHT(43)/2 - normalSize1.height/2, normalSize1.width, normalSize1.height);
    
    [self.contentView addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = kFONT(12);
    self.subTitleLabel.frame = CGRectMake(self.titleLabel.right + 8, kHEIGHT(43)/2 - normalSize2.height/2, normalSize2.width, normalSize2.height);
    self.subTitleLabel.text = @"已匿名形式发布说说";
    self.subTitleLabel.textColor = RGB(127, 127, 127);
    [self.contentView addSubview:self.subTitleLabel];
    
    self.subTitleLabel.hidden = YES;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(43) - 0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(235, 235, 235);
    [self.contentView addSubview:line];
    
}

- (void)setText:(NSString *)text
{
    self.subTitleLabel.hidden = YES;
    self.titleLabel.text = text;
    if (self.index.row == 1) {
        self.subTitleLabel.hidden = NO;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"TopicCellID";
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
        cell = [[TopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

+ (CGFloat)cellHeight
{
    return kHEIGHT(58);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
