//
//  OpenCell.m
//  WP
//
//  Created by 沈亮亮 on 16/2/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "OpenCell.h"

@implementation OpenCell

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
    
    CGSize normalSize1 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize normalSize2 = [@"卧槽" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat y = (kHEIGHT(58) - normalSize1.height - normalSize2.height - 10)/2;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = kFONT(15);
    
    self.titleLabel.frame = CGRectMake(36, y, SCREEN_WIDTH - 100, normalSize1.height);
    
    [self.contentView addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = kFONT(12);
    self.subTitleLabel.frame = CGRectMake(36, self.titleLabel.bottom + 10, SCREEN_WIDTH - 100, normalSize2.height);
    self.subTitleLabel.textColor = RGB(127, 127, 127);
    [self.contentView addSubview:self.subTitleLabel];
    
//    self.selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - 18, 10, 18, 18)];//
//    self.selectImage.image = [UIImage imageNamed:@"common_xuanzhong"];
//    [self addSubview:self.selectImage];
//    self.selectImage.centerY = kHEIGHT(58)/2;
//    self.selectImage.hidden = YES;
    self.selectImage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectImage.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(43), 0, kHEIGHT(43), kHEIGHT(58));
    [self.selectImage setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
    [self.selectImage setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
    [self.selectImage setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.selectImage setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0, kHEIGHT(10))];
    [self.selectImage addTarget:self action:@selector(choise:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.selectImage];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(58) - 0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(235, 235, 235);
    [self.contentView addSubview:line];
}
//点击cell上的选择
-(void)choise:(UIButton*)btn
{
    btn.selected = !btn.selected;
    if (self.choiseBtnClick) {
        self.choiseBtnClick(self.index,btn.selected);
    }
}
- (void)setDic:(NSDictionary *)dic
{
    self.titleLabel.text = dic[@"type_name"];
    self.subTitleLabel.text = dic[@"users_name"];
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"OpenCellID";
    OpenCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
        cell = [[OpenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
