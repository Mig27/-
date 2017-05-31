//
//  PreViewCell.m
//  WP
//
//  Created by 沈亮亮 on 15/10/23.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "ActivityPreViewCell.h"

@implementation ActivityPreViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.pictureShow removeFromSuperview];
        [self.textShow removeFromSuperview];
        self.pictureShow = [[UIImageView alloc] init];
        self.textShow = [[TYAttributedLabel alloc] init];
        self.textShow.numberOfLines = 0;
        [self.contentView addSubview:self.pictureShow];
        [self.contentView addSubview:self.textShow];
    }
    return self;
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"ActivityPreViewCell";
    ActivityPreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ActivityPreViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//        cell = [[ActivityPreViewCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    
    //    self.textShow.frame = CGRectMake(10, 22, SCREEN_WIDTH - 20, 80);
    ////    self.textShow.backgroundColor = [UIColor redColor];
    //    self.textShow.attributedText = attributedString;
    [self.textShow setAttributedText:attributedString];
    self.textShow.linesSpacing = 4;
    self.textShow.characterSpacing = -1;
    [self.textShow setFrameWithOrign:CGPointMake(10, 5) Width:SCREEN_WIDTH - 20];
    //    self.textShow.backgroundColor = [UIColor cyanColor];
//    CGFloat height = self.textShow.frame.size.height;
//    if (height > 80) {
//        self.btnDown.frame = CGRectMake(SCREEN_WIDTH - 32, height, 22, 22);
//    } else {
//        self.btnDown.frame = CGRectMake(SCREEN_WIDTH - 32, 102 - 22, 22, 22);
//    }
}

- (void)setAsset:(MLSelectPhotoAssets *)asset
{
    //    self.imageView.backgroundColor = [UIColor redColor];
    ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
    CGFloat height;
    CGSize dimension = [representation dimensions];
    height = ((SCREEN_WIDTH - 20)/dimension.width)*dimension.height;
    //    NSLog(@"***%f----%f----%f",dimension.width,dimension.height,height);
    //    UIImage *image = [UIImage imageWithCGImage:representation.fullScreenImage];
    //    UIImage *newImage = [self fixOrientation:image];
    //    height = ((SCREEN_WIDTH - 20)/newImage.size.width)*newImage.size.height;
    self.pictureShow.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, height);
    //    self.pictureShow.image = newImage;
    self.pictureShow.image = [UIImage imageWithCGImage:representation.fullScreenImage];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
