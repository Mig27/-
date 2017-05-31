//
//  DetailScanCell.m
//  WP
//
//  Created by 沈亮亮 on 16/3/2.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "DetailScanCell.h"
#import "UIImageView+WebCache.h"

@implementation DetailScanCell

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
    
    CGSize normalSize1 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGSize normalSize2 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(10)}];
    CGFloat y = (kHEIGHT(50) - normalSize1.height - normalSize2.height - 6)/2;
    CGFloat icon_X = (kHEIGHT(37) + kHEIGHT(10) + 10 - kHEIGHT(30))/2;
    CGFloat icon_Y = (kHEIGHT(50) - kHEIGHT(30))/2;
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(icon_X, icon_Y, kHEIGHT(30), kHEIGHT(30))];
    self.iconImage.layer.cornerRadius = 2.5;
    self.iconImage.clipsToBounds = YES;
    [self.contentView addSubview:self.iconImage];
    
    self.nickLabel = [[UILabel alloc] init];
    self.nickLabel.frame = CGRectMake(self.iconImage.right + icon_X, y, SCREEN_WIDTH - 100, normalSize1.height);
//    self.nickLabel.textColor = AttributedColor;
    self.nickLabel.font = kFONT(12);
    [self.contentView addSubview:self.nickLabel];
    
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80-kHEIGHT(10), y, 80, normalSize1.height)];
    self.timeLabel.font = kFONT(10);
    self.timeLabel.textColor= RGB(170, 170, 170);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    
    
    
    self.positionLabel = [[UILabel alloc] init];
    self.positionLabel.font = kFONT(10);
    self.positionLabel.frame = CGRectMake(self.nickLabel.left, self.nickLabel.bottom + 8, SCREEN_WIDTH - 100, normalSize2.height);
    self.positionLabel.textColor = RGB(127, 127, 127);
    [self.contentView addSubview:self.positionLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(50) - 0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(235, 235, 235);
    [self.contentView addSubview:line];
    
}

- (void)setDic:(NSDictionary *)dic
{
    NSString *urlStr = [IPADDRESS stringByAppendingString:dic[@"avatar"]];
    [self.iconImage sd_setImageWithURL:URLWITHSTR(urlStr) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    self.nickLabel.text = dic[@"nick_name"];
    self.timeLabel.text = dic[@"addtime"];
    self.positionLabel.text = [NSString stringWithFormat:@"%@ | %@",dic[@"position"],dic[@"company"]];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"DetailScanCellID";
    DetailScanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
        cell = [[DetailScanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

+ (CGFloat)cellHeight
{
    return kHEIGHT(50);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
