//
//  PreViewCell.m
//  WP
//
//  Created by 沈亮亮 on 15/9/9.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "PreViewCell.h"

#import "WPShareModel.h"
#import "UIButton+WebCache.h"
#import "preTitleView.h"
#import "PreImgConsider.h"

@implementation PreViewCell

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
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *dic = model.dic;
    self.iconBtn = [[WPButton alloc] init];
    self.iconBtn.frame = CGRectMake(10, 10, 40, 40);
    self.iconBtn.clipsToBounds = YES;
    self.iconBtn.layer.cornerRadius = 5;
    [self.contentView addSubview:self.iconBtn];
    
    self.nickName = [[UILabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 10, SCREEN_WIDTH - 120, 20)];
    self.nickName.font = [UIFont systemFontOfSize:15];
    self.nickName.text = @"华仔";
    [self.contentView addSubview:self.nickName];
    
    self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 30, 34, 15)];
    self.positionLabel.textColor = [UIColor lightGrayColor];
    self.positionLabel.text = @"经理";
    self.positionLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.positionLabel];
    
    self.businessLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.positionLabel.right + 16, 30, SCREEN_WIDTH - 111, 15)];
    self.businessLabel.text = @"莱达商贸有限公司";
    self.businessLabel.textColor = [UIColor lightGrayColor];
    self.businessLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.businessLabel];
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.iconBtn.right + 10, 50, SCREEN_WIDTH - 68, 1)];
    //        line2.image = [UIImage imageNamed:@"small_seperator"];
    line2.backgroundColor = RGBColor(235, 235, 235);
    [self.contentView addSubview:line2];
    
    NSString *urlStr = [IPADDRESS stringByAppendingString:dic[@"avatar"]];
    [self.iconBtn sd_setImageWithURL:URLWITHSTR(urlStr) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    NSString *nameStr = dic[@"nick_name"];
    NSString *nameStr1 = [nameStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    NSString *nameStr2 = [nameStr1 stringByReplacingOccurrencesOfString:@"&" withString:@":"];
    self.nickName.text = nameStr2;
//    self.nickName.text = dic[@"nick_name"];
    self.positionLabel.text = dic[@"position"];
    self.businessLabel.text = dic[@"company"];
    
    CGSize nickNameSize = [dic[@"nick_name"] sizeWithAttributes:@{NSFontAttributeName:GetFont(15)}];
    self.nickName.frame =  (CGRect){{self.iconBtn.right + 10, 10},nickNameSize};
    CGSize positionSize = [dic[@"position"] sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    self.positionLabel.frame = (CGRect){{60,self.nickName.bottom + 4},positionSize};
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.positionLabel.right + 6, self.nickName.bottom + 6, 1, 12)];
    //        line1.image = [UIImage imageNamed:@"small_bounds"];
    line1.backgroundColor = RGBColor(235, 235, 235);
    [self.contentView addSubview:line1];
    
    CGSize businessSize = [dic[@"company"] sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    self.businessLabel.frame = (CGRect){{self.positionLabel.right + 12,self.nickName.bottom + 4},businessSize};
    self.currentY = 50;

}

- (void)cofignCellWith:(NSArray *)preViewData andPic:(NSArray *)asset andAddres:(NSString *)addres
{
    
    for (int i = 0; i< preViewData.count; i ++) {
        NSDictionary *dic = preViewData[i];
        preTitleView *titleView = [[preTitleView alloc] init];
        titleView.dic = dic;
        NSString *title = dic[@"title"];
        NSString *content = dic[@"content"];
        CGSize normalSize = [title sizeWithAttributes:@{NSFontAttributeName:GetFont(14)}];
        CGSize size = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 - normalSize.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (i == 0) {
            titleView.frame = CGRectMake(0, _currentY + 10, SCREEN_WIDTH, size.height);
        } else {
            titleView.frame = CGRectMake(0, _currentY + 8, SCREEN_WIDTH, size.height);
        }
        [self.contentView addSubview:titleView];
        _currentY = titleView.origin.y + size.height;

    }
    
    PreImgConsider *consider = [[PreImgConsider alloc] init];
    [self.contentView addSubview:consider];
    if (asset.count != 0) {
        consider.frame = CGRectMake(0, _currentY + 8, SCREEN_WIDTH, 76);
        consider.dicInfo = asset;
    }
    
    UIImageView *adress = [[UIImageView alloc] init];
    
    adress.image = [UIImage imageNamed:@"small_address"];
    [self.contentView addSubview:adress];
    
    UILabel *position = [[UILabel alloc] init];
    position.text = addres;
    position.textColor = [UIColor lightGrayColor];
    position.font = [UIFont systemFontOfSize:12];
    CGSize positionSize = [addres sizeWithAttributes:@{NSFontAttributeName:GetFont(12)}];
    [self.contentView addSubview:position];
    
    if (addres.length != 0) {
        if (asset.count == 0) {
            adress.frame = CGRectMake(10, _currentY + 10, 10, 13);
            position.frame = (CGRect){{adress.right + 6, _currentY + 10},positionSize};
        } else {
            adress.frame = CGRectMake(10, consider.bottom + 10, 10, 13);
            position.frame = (CGRect){{adress.right + 6, consider.bottom + 10},positionSize};
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
