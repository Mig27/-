//
//  WPSetCell.m
//  WP
//
//  Created by CBCCBC on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPSetCell.h"

@interface WPSetCell ()
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIImageView *image;
@property (nonatomic, strong)UILabel *smallLabel;
@end

@implementation WPSetCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.image];
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.smallLabel];
    }
    return self;
}

- (UIImageView *)image
{
    if (!_image) {
//        self.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
        CGFloat height = kHEIGHT(43);
        self.image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(14)-8, height/2-7, 8, 14)];
        self.image.image = [UIImage imageNamed:@"jinru"];
    }
    return _image;
}

- (UILabel *)label
{
    if (!_label) {
        CGFloat height = kHEIGHT(43);
        CGFloat width = kHEIGHT(18);
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(16, (height - kHEIGHT(15))/2, SCREEN_WIDTH - width - 30, kHEIGHT(15))];
        self.label.font = kFONT(15);
    }
    return _label;
}

- (UILabel *)smallLabel
{
    if (!_smallLabel) {
        self.smallLabel = [[UILabel alloc]init];
        self.smallLabel.font = kFONT(12);
        self.smallLabel.textColor = RGB(127, 127, 127);
    }
    return _smallLabel;
}

- (void)setDetailTitle:(NSString *)detailTitle
{
    _detailTitle = detailTitle;
    self.smallLabel.text = detailTitle;
    CGRect rect = [detailTitle boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFONT(12)} context:nil];
    self.smallLabel.frame = CGRectMake(self.image.frame.origin.x-rect.size.width-10, self.image.frame.origin.y, rect.size.width, kHEIGHT(15));

}
-(void)setWiFiDetail:(NSString *)WiFiDetail
{
    _detailTitle = WiFiDetail;
    self.smallLabel.text = WiFiDetail;
    CGRect rect = [WiFiDetail boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFONT(12)} context:nil];
    self.smallLabel.frame = CGRectMake(self.image.frame.origin.x-rect.size.width-10, (kHEIGHT(43)-kHEIGHT(15))/2, rect.size.width, kHEIGHT(15));
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.label.text = title;
}

- (void)setType:(NSString *)type
{
    _type = type;
    CGRect rect = [self.detailTitle boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFONT(12)} context:nil];
    self.smallLabel.frame = CGRectMake(SCREEN_WIDTH-kHEIGHT(14)-rect.size.width, self.image.frame.origin.y, rect.size.width, kHEIGHT(15));
    [self.image removeFromSuperview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
