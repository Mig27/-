//
//  ButtonMenuCollectionCell.m
//  WP
//
//  Created by 沈亮亮 on 15/11/4.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "ButtonMenuCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "WPDownLoadVideo.h"
@implementation ButtonMenuCollectionCell

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)]];
//        self.backgroundColor = [UIColor whiteColor];
//        CGSize normalSize1 = [@"好友圈动" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
//        CGSize normalSize2 = [@"好友圈动" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
//        CGFloat y = (kHEIGHT(58) - normalSize1.height - normalSize2.height - 10)/2;
//        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(58)/2 - kHEIGHT(43)/2, kHEIGHT(43), kHEIGHT(43))];
//        [self addSubview:self.iconImage];
//        self.iconImage.clipsToBounds = YES;
//        self.iconImage.layer.cornerRadius = 5;
//        self.iconImage.centerY = kHEIGHT(58)/2;
//
//        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + 10, y, SCREEN_WIDTH - 100, normalSize1.height)];
//        self.titleLabel.font = kFONT(15);
//        self.titleLabel.textColor = [UIColor blackColor];
//        [self addSubview:self.titleLabel];
//        
//        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom + 10, SCREEN_WIDTH - 100, normalSize2.height)];
//        self.subTitleLabel.font = kFONT(12);
//        self.subTitleLabel.textColor = RGB(127, 127, 127);
//        [self addSubview:self.subTitleLabel];
//        
//        self.sumLabel = [[UILabel alloc] init];
//        self.sumLabel.font = kFONT(12);
//        self.sumLabel.textColor = RGB(127, 127, 127);
//        [self addSubview:self.sumLabel];
//        
//        self.selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - 15, self.subTitleLabel.top - 8 - 15, 15, 15)];
//        self.selectImage.image = [UIImage imageNamed:@"topicTypeSelect"];
//        [self addSubview:self.selectImage];
//        self.selectImage.hidden = YES;
//        
//        self.sumImage = [[UIImageView alloc] init];
//        self.sumImage.image = [UIImage imageNamed:@"topicSum"];
//        [self addSubview:self.sumImage];
//        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(58) - 0.5, SCREEN_WIDTH, 0.5)];
//        line.backgroundColor = RGB(226, 226, 226);
//        [self addSubview:line];
//    }
//    return self;
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(226, 226, 226)]];
        self.backgroundColor = [UIColor whiteColor];
        CGSize normalSize1 = [@"好友圈动" sizeWithAttributes:@{NSFontAttributeName:kFONT(14)}];
        CGSize normalSize2 = [@"好友圈动" sizeWithAttributes:@{NSFontAttributeName:kFONT(10)}];
        CGFloat y = (kHEIGHT(58) - normalSize1.height - normalSize2.height - 10)/2;
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(58)/2 - kHEIGHT(43)/2, kHEIGHT(43), kHEIGHT(43))];
        [self addSubview:self.iconImage];
        self.iconImage.clipsToBounds = YES;
        self.iconImage.layer.cornerRadius = 5;
        self.iconImage.centerY = kHEIGHT(58)/2;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + 10, y, SCREEN_WIDTH - 100, normalSize1.height)];
        self.titleLabel.font = kFONT(14);
        self.titleLabel.textColor = RGB(51, 51, 51);
        [self addSubview:self.titleLabel];
        
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom + 10, SCREEN_WIDTH - 100, normalSize2.height)];
        self.subTitleLabel.font = kFONT(12);
        self.subTitleLabel.textColor = RGB(127, 127, 127);
//        [self addSubview:self.subTitleLabel];
        
        self.sumLabel = [[UILabel alloc] init];
        self.sumLabel.font = kFONT(10);
        self.sumLabel.textColor = RGB(127, 127, 127);
        self.sumLabel.frame = CGRectMake(self.titleLabel.left + 16, self.titleLabel.bottom + 10, 200, normalSize2.height);
        [self addSubview:self.sumLabel];
        
        self.selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kHEIGHT(10) - 15, self.sumLabel.top - 8 - 15, 15, 15)];
        self.selectImage.image = [UIImage imageNamed:@"topicTypeSelect"];
        [self addSubview:self.selectImage];
        self.selectImage.centerY = kHEIGHT(58)/2;
        self.selectImage.hidden = YES;
        
        self.sumImage = [[UIImageView alloc] init];
        self.sumImage.image = [UIImage imageNamed:@"topicSum"];
        self.sumImage.frame = CGRectMake(self.titleLabel.left, self.titleLabel.bottom + 10, 10, 12);
        [self addSubview:self.sumImage];
        self.sumImage.centerY = self.sumLabel.centerY;
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(58) - 0.5, SCREEN_WIDTH, 0.5)];
//        line.backgroundColor = RGB(226, 226, 226);
//        [self addSubview:line];
    }
    return self;
}
-(NSData*)imageData:(NSString*)filePath
{
    NSArray * pathArray = [filePath componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSData * data= [NSData dataWithContentsOfFile:fileName1];
    return data;
}
- (void)setModel:(DynamicTopicTypeModel *)model
{
//    NSString *url = [IPADDRESS stringByAppendingString:model.icon_url];
    NSData * data = [self imageData:model.icon_url];
    if (data) {
        self.iconImage.image = [UIImage imageWithData:data];
    }
    else
    {
        WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [down downLoadImage:[IPADDRESS stringByAppendingString:model.icon_url] success:^(id response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.iconImage.image = [UIImage imageWithData:response];
                });
            } failed:^(NSError *error) {
               dispatch_async(dispatch_get_main_queue(), ^{
                   self.iconImage.image = [UIImage imageNamed:@"small_cell_person"];
               });
            }];
        });
        
    }
//    [self.iconImage sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    self.sumLabel.text = model.CoutSum;
    self.titleLabel.text = model.type_name;
    self.subTitleLabel.text = model.remarks;
    self.selectImage.hidden = ![model.isSelected integerValue];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    ButtonMenuCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonMenuCollectionCellId"];
    if (!cell) {
        cell = [[ButtonMenuCollectionCell alloc] init];
    }
    
    return cell;
}

+ (CGFloat)rowHeight
{
    return kHEIGHT(58);
}

@end
