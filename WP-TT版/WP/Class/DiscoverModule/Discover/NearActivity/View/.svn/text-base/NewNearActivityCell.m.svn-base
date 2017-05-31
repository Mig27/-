//
//  NewNearActivityCell.m
//  WP
//
//  Created by 沈亮亮 on 15/11/2.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "NewNearActivityCell.h"
#import "UIImageView+WebCache.h"


@implementation NewNearActivityCell

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
    self.contentView.backgroundColor = RGB(235, 235, 235);
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(92))];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kHEIGHT(76), kHEIGHT(76))];
    self.iconImage.layer.cornerRadius = 5;
    self.iconImage.clipsToBounds = YES;
    [self.contentView addSubview:self.iconImage];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + 10, 10, SCREEN_WIDTH - self.iconImage.width - 30, kHEIGHT(15)*2.5)];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = kFONT(15);
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    
    UIImageView *address = [[UIImageView alloc] initWithFrame:CGRectMake(self.iconImage.right + 10, self.titleLabel.bottom + 6, 12, 12)];
    address.image = [UIImage imageNamed:@"activity_addres"];
    [self.contentView addSubview:address];
    
    self.addresLabel = [[UILabel alloc] initWithFrame:CGRectMake(address.right + 4, self.titleLabel.bottom + 6, SCREEN_WIDTH - self.iconImage.width - 30 - 16, kHEIGHT(12))];
    self.addresLabel.font = kFONT(12);
    self.addresLabel.textColor = kLightColor;
    [self.contentView addSubview:self.addresLabel];
    
    UIImageView *time = [[UIImageView alloc] initWithFrame:CGRectMake(self.iconImage.right + 10, self.addresLabel.bottom + 6, 12, 12)];
    time.image = [UIImage imageNamed:@"activity_time"];
    [self.contentView addSubview:time];
    
    CGSize normalSize = [@"报名" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    
    UILabel *apply = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - normalSize.width, self.addresLabel.bottom + 6, normalSize.width, kHEIGHT(12))];
    apply.text = @"报名";
    apply.font = kFONT(12);
    apply.textColor = kLightColor;
    [self.contentView addSubview:apply];
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(apply.left - 57, apply.bottom - kHEIGHT(14), 57, kHEIGHT(14))];
    self.numberLabel.font = kFONT(14);
    self.numberLabel.textColor = [UIColor redColor];
    self.numberLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.numberLabel];
    

    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(time.right + 4, self.addresLabel.bottom + 6, SCREEN_WIDTH - self.iconImage.width - 30 - 16 - normalSize.width - 57 , kHEIGHT(12))];
    self.timeLabel.font = kFONT(12);
    self.timeLabel.textColor = kLightColor;
    [self.contentView addSubview:self.timeLabel];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"NewNearActivityCellID";
    NewNearActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
        cell = [[NewNearActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

- (void)setModel:(NearActivityListModel *)model
{
    NSString *url = [IPADDRESS stringByAppendingString:model.show_img];
    [self.iconImage sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    self.titleLabel.text = model.title;
    self.addresLabel.text = model.address_2;
    self.timeLabel.text = model.bigen_time;
    self.numberLabel.text = [NSString stringWithFormat:@"%@人",model.sign];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
