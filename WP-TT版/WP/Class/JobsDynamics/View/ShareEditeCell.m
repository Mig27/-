
//
//  ShareEditeCell.m
//  WP
//
//  Created by 沈亮亮 on 16/2/3.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "ShareEditeCell.h"

@implementation ShareEditeCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
//        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-8, kHEIGHT(43)/2-7, 8, 14)];
        imageView.image = [UIImage imageNamed:@"jinru"];
        [self.contentView addSubview:imageView];
        
    }
    
    return self;
}

- (void)createUI
{
    self.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.iconBtn.frame = CGRectMake(kHEIGHT(10), kHEIGHT(43)/2 - 7.5, 15, 15);
    [self.contentView addSubview:self.iconBtn];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = kFONT(15);
    [self.contentView addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = kFONT(12);
    self.subTitleLabel.textColor = RGB(127, 127, 127);
    [self.contentView addSubview:self.subTitleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(43) - 0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(235, 235, 235);
    [self.contentView addSubview:line];

}

- (void)setDic:(NSDictionary *)dic
{
    CGSize normalSize1 = [dic[@"title"] sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize normalSize2 = [dic[@"subtitle"] sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    if (normalSize1.width > SCREEN_WIDTH - 4*kHEIGHT(10) - 15) {
        self.titleLabel.frame = CGRectMake(self.iconBtn.right + kHEIGHT(10), kHEIGHT(43)/2 - normalSize1.height/2, SCREEN_WIDTH - 4*kHEIGHT(10) - 15, normalSize1.height);
    } else {
        self.titleLabel.frame = CGRectMake(self.iconBtn.right + kHEIGHT(10), kHEIGHT(43)/2 - normalSize1.height/2, normalSize1.width, normalSize1.height);
    }
    
    self.titleLabel.text = dic[@"title"];
    
    self.subTitleLabel.frame = CGRectMake(SCREEN_WIDTH - 8-kHEIGHT(10)-8 - normalSize2.width, kHEIGHT(43)/2 - normalSize2.height/2, normalSize2.width, normalSize2.height);
    self.subTitleLabel.text = dic[@"subtitle"];
    [self.iconBtn setImage:[UIImage imageNamed:dic[@"image"]] forState:UIControlStateNormal];

}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"ShareEditeCellID";
    ShareEditeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
        cell = [[ShareEditeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

+ (CGFloat)cellHeight
{
    return kHEIGHT(43);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
