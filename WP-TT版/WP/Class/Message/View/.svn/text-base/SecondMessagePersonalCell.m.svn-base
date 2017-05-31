//
//  SecondMessagePersonalCell.m
//  WP
//
//  Created by 沈亮亮 on 16/1/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "SecondMessagePersonalCell.h"

#import "UIImageView+WebCache.h"

@implementation SecondMessagePersonalCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
    }
    
    return self;
}

- (void)createUI
{
    CGSize normalSize1 = [@"回忆录" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(14), kHEIGHT(72)/2 - normalSize1.height/2, normalSize1.width, normalSize1.height)];
    titleLabel.font = kFONT(15);
    titleLabel.text = @"回忆录";
    [self.contentView addSubview:titleLabel];
    
    CGFloat y = kHEIGHT(72)/2 - kHEIGHT(44)/2;
    
    for (int i = 0; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.right + kHEIGHT(14) + (kHEIGHT(44) + 8)*i, y, kHEIGHT(44), kHEIGHT(44))];
        imageView.layer.cornerRadius = 5;
        imageView.clipsToBounds = YES;
        imageView.tag = i + 1;
        [self.contentView addSubview:imageView];
        
        if (i == 0) {
            self.imageV1 = imageView;
        } else if (i == 1) {
            self.imageV2 = imageView;
        } else if (i == 2) {
            self.imageV3 = imageView;
        } else {
            self.imageV4 = imageView;
        }
    }

}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"SecondMessagePersonalCellID";
    SecondMessagePersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
        cell = [[SecondMessagePersonalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

- (void)setModel:(MessagePersonalModel *)model
{
    for (int i = 0; i < [model.ImgList count]; i++) {
        MessageImgListModel *imgModel = model.ImgList[i];
        UIImageView *imageV = (UIImageView *)[self viewWithTag:i+1];
        NSString *url = [IPADDRESS stringByAppendingString:imgModel.thumb_path];
        if ([imgModel.media_type isEqualToString:@"0"]) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, kHEIGHT(44), kHEIGHT(44));
            [btn setImage:[UIImage imageNamed:@"播放小"] forState:UIControlStateNormal];
            [imageV addSubview:btn];
        }
        [imageV sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
