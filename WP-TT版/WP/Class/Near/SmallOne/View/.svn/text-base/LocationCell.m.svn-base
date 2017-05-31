//
//  LocationCell.m
//  WP
//
//  Created by 沈亮亮 on 15/7/30.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "LocationCell.h"


@implementation LocationCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    
    return self;
}

- (void)createUI
{
    
    CGSize normalSize1 = [@"好友圈动" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize normalSize2 = [@"好友圈动" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    
    CGFloat y = (kHEIGHT(58) - normalSize1.height - normalSize2.height - 8)/2;
    
    self.nameLabel  = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), y, SCREEN_WIDTH - 10, normalSize1.height)];
    self.nameLabel.font = kFONT(15);
    self.nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.nameLabel];
    
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHEIGHT(10), self.nameLabel.bottom + 8, SCREEN_WIDTH - 10, normalSize2.height)];
    self.locationLabel.font = kFONT(12);
    self.locationLabel.textColor = RGBColor(127, 127, 127);
    [self.contentView addSubview:self.locationLabel];
    
    
    self.choiseImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(15)-kHEIGHT(10), (kHEIGHT(58)-kHEIGHT(15))/2, kHEIGHT(15), kHEIGHT(15))];
    self.choiseImage.image = [UIImage imageNamed:@"common_xuanzhong"];
    self.choiseImage.hidden = YES;
    [self.contentView addSubview:self.choiseImage];
}

- (void)setLocationWith:(NSDictionary *)dic
{
    self.nameLabel.text = dic[@"name"];
    self.locationLabel.text = dic[@"address"];
    NSString * string = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCity"];
    if ([dic[@"name"] isEqualToString:string]) {
        CGSize normalSize1 = [@"好友圈动" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
        CGRect rect = self.nameLabel.frame;
        rect.origin.y = (self.height-normalSize1.height)/2;
        self.nameLabel.frame = rect;
    }
    else
    {
        CGSize normalSize1 = [@"好友圈动" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
        CGSize normalSize2 = [@"好友圈动" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
        CGFloat y = (kHEIGHT(58) - normalSize1.height - normalSize2.height - 8)/2;
        CGRect rect = self.nameLabel.frame;
        rect.origin.y = y;
        self.nameLabel.frame = rect;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
