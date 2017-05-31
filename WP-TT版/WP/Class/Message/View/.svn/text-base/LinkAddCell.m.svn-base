//
//  LinkAddCell.m
//  WP
//
//  Created by 沈亮亮 on 15/12/29.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "LinkAddCell.h"


@implementation LinkAddCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self createUI];
    }
    
    return self;
}

- (void)createUI
{
    CGSize normalSize1 = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGSize normalSize2 = [@"草泥马" sizeWithAttributes:@{NSFontAttributeName:kFONT(12)}];
    CGFloat y = (kHEIGHT(58) - normalSize1.height - normalSize2.height - 4)/2;
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(58)/2 - kHEIGHT(32)/2, kHEIGHT(32), kHEIGHT(32))];
    [self.contentView addSubview:self.iconImage];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + 10, y, SCREEN_WIDTH - 120, normalSize1.height)];
    self.nameLabel.font = kFONT(15);
    [self.contentView addSubview:self.nameLabel];
    
    self.functionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right + 10, self.nameLabel.bottom +4, SCREEN_WIDTH - 120, normalSize2.height)];
    self.functionLabel.font = kFONT(12);
    self.functionLabel.textColor = RGB(153, 153, 153);
    [self.contentView addSubview:self.functionLabel];

}

- (void)setInfo:(NSDictionary *)info
{
    self.iconImage.image = [UIImage imageNamed:info[@"image"]];
    self.nameLabel.text = info[@"title"];
    self.functionLabel.text = info[@"subtitle"];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"LinkAddCellID";
    LinkAddCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
        cell = [[LinkAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
