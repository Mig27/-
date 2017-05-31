//
//  ThirdMessagePersonalCell.m
//  WP
//
//  Created by 沈亮亮 on 16/1/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "ThirdMessagePersonalCell.h"


@implementation ThirdMessagePersonalCell

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
//    self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
    CGSize normalSize1 = [@"他的招聘" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(14), kHEIGHT(43)/2 - kHEIGHT(18)/2, kHEIGHT(18), kHEIGHT(18))];
    [self.contentView addSubview:self.iconImage];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + kHEIGHT(14), kHEIGHT(43)/2 - normalSize1.height/2, normalSize1.width, normalSize1.height)];
    self.titleLabel.font = kFONT(15);
    [self.contentView addSubview:self.titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] init];//WithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(14)-8, kHEIGHT(50)/2-7, 8, 14)
    imageView.image = [UIImage imageNamed:@"jinru"];
    [self.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-16);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@14);
        make.width.equalTo(@8);
    }];
    
    self.numberLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(SCREEN_WIDTH - 20 - 8 - 80, kHEIGHT(43)/2 - 7, 80, 14)
    self.numberLabel.font = kFONT(12);
    self.numberLabel.textColor = RGB(153, 153, 153);
    self.numberLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView.mas_left).with.offset(-8);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@80);
        make.height.equalTo(@14);
    }];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"ThirdMessagePersonalCellID";
    ThirdMessagePersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
        cell = [[ThirdMessagePersonalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
