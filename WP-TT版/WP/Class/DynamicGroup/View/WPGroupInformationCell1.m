//
//  WPGroupInformationCell1.m
//  WP
//
//  Created by 沈亮亮 on 16/4/19.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGroupInformationCell1.h"

@implementation WPGroupInformationCell1

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

-(void)setSiAccess:(BOOL)siAccess
{
    if (siAccess)
    {
//         self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
        self.accessImage.hidden = NO;
    }
    else
    {
//       self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        self.accessImage.hidden = YES;
    }
}
- (void)createUI
{
    self.itemLabel = [[UILabel alloc] init];
    self.itemLabel.textColor = RGB(127, 127, 127);
    self.itemLabel.font = kFONT(15);
    [self.contentView addSubview:self.itemLabel];
    
    self.informationLabel = [[UILabel alloc] init];
    self.informationLabel.font = kFONT(15);
    [self.contentView addSubview:self.informationLabel];
    
    
    self.accessImage = [[UIImageView alloc]init];
    self.accessImage.image = [UIImage imageNamed:@"jinru"];
    self.accessImage.hidden = YES;
    [self.contentView addSubview:self.accessImage];
    

}

- (void)setItemStr:(NSString *)itemStr
{
    self.itemLabel.text = itemStr;
}

- (void)setInformationStr:(NSString *)informationStr
{
    self.informationLabel.numberOfLines = self.lines;
    self.informationLabel.text = informationStr;
    
    
    
    CGSize normalSize1 = [@"群名称" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGFloat strH = [informationStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(25) - 2*(kHEIGHT(10))-20 - normalSize1.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(15)]} context:nil].size.height;
    if (self.milti) {
        if (strH <= normalSize1.height) {
            self.itemLabel.frame = CGRectMake(16, 0, normalSize1.width, kHEIGHT(43));
            self.informationLabel.frame = CGRectMake(self.itemLabel.right + kHEIGHT(25), 0, SCREEN_WIDTH-kHEIGHT(25) - 2*(kHEIGHT(10))-20 - normalSize1.width, kHEIGHT(43));
            self.accessImage.frame =CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-8, self.height/2-7, 8, 14);
        } else if (strH <= normalSize1.height*self.lines && strH > normalSize1.height) {
            self.itemLabel.frame = CGRectMake(16, 0, normalSize1.width, strH + 2*16);
            self.informationLabel.frame = CGRectMake(self.itemLabel.right + kHEIGHT(25), 0, SCREEN_WIDTH-kHEIGHT(25) - 2*(kHEIGHT(10))-20 - normalSize1.width, strH + 2*16);
            self.accessImage.frame =CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-8, (strH + 2*16-14)/2, 8, 14);
            
        } else {
            self.itemLabel.frame = CGRectMake(16, 0, normalSize1.width, normalSize1.height*self.lines + 2*16);
            self.informationLabel.frame = CGRectMake(self.itemLabel.right + kHEIGHT(25), 0, SCREEN_WIDTH-kHEIGHT(25) - 2*(kHEIGHT(10))-20 - normalSize1.width, normalSize1.height*self.lines + 2*16);
            self.accessImage.frame =CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-8, (normalSize1.height*self.lines + 2*16-14)/2, 8, 14);
        }
    } else {
        self.itemLabel.frame = CGRectMake(16, 0, normalSize1.width, kHEIGHT(43));
        self.informationLabel.frame = CGRectMake(self.itemLabel.right + kHEIGHT(25), 0, SCREEN_WIDTH-kHEIGHT(25) - 2*(kHEIGHT(10))-20 - normalSize1.width, kHEIGHT(43));
        self.accessImage.frame =CGRectMake(SCREEN_WIDTH-kHEIGHT(10)-8, self.height/2-7, 8, 14);
    }
//    self.accessImage.backgroundColor = [UIColor redColor];
//    self.informationLabel.backgroundColor = [UIColor greenColor];
    
//    CGSize normalSize1 = [@"群名称" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
//    CGFloat strH = [informationStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(25) - 2*10 - normalSize1.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(15)]} context:nil].size.height;
//    if (self.milti) {
//        if (strH <= normalSize1.height) {
//            self.itemLabel.frame = CGRectMake(16, 0, normalSize1.width, kHEIGHT(43));
//            self.informationLabel.frame = CGRectMake(self.itemLabel.right + kHEIGHT(25), 0, SCREEN_WIDTH-kHEIGHT(25) - 2*16 - normalSize1.width, kHEIGHT(43));
//        } else if (strH <= normalSize1.height*self.lines && strH > normalSize1.height) {
//            self.itemLabel.frame = CGRectMake(16, 0, normalSize1.width, strH + 2*16);
//            self.informationLabel.frame = CGRectMake(self.itemLabel.right + kHEIGHT(25), 0, SCREEN_WIDTH-kHEIGHT(25) - 2*16 - normalSize1.width, strH + 2*16);
//        } else {
//            self.itemLabel.frame = CGRectMake(16, 0, normalSize1.width, normalSize1.height*self.lines + 2*16);
//            self.informationLabel.frame = CGRectMake(self.itemLabel.right + kHEIGHT(25), 0, SCREEN_WIDTH-kHEIGHT(25) - 2*16 - normalSize1.width, normalSize1.height*self.lines + 2*16);
//        }
//    } else {
//        self.itemLabel.frame = CGRectMake(16, 0, normalSize1.width, kHEIGHT(43));
//        self.informationLabel.frame = CGRectMake(self.itemLabel.right + kHEIGHT(25), 0, SCREEN_WIDTH-kHEIGHT(25) - 2*16 - normalSize1.width, kHEIGHT(43));
//    }

}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    WPGroupInformationCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"WPGroupInformationCell1Id"];
    if (!cell) {
        cell = [[WPGroupInformationCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WPGroupInformationCell1Id"];
    }
    return cell;
}

+ (CGFloat)rowHeightWithString:(NSString *)string andLines:(NSInteger)line isMulti:(BOOL)multi
{
    CGSize normalSize1 = [@"群名称" sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    CGFloat strH = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-kHEIGHT(25) - 2*10 - normalSize1.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FUCKFONT(15)]} context:nil].size.height;
    if (multi) {
        if (strH <= normalSize1.height) {
            return kHEIGHT(43);
        } else if (strH <= normalSize1.height*line && strH > normalSize1.height) {
            return strH + 2*16;
        } else {
            return normalSize1.height*line + 2*16;
        }
    } else {
        return kHEIGHT(43);
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
