//
//  WPPhoneBookGroupCell.m
//  WP
//
//  Created by Kokia on 16/5/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPhoneBookGroupCell.h"
#import "WPDownLoadVideo.h"
@interface WPPhoneBookGroupCell()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;


@end

@implementation WPPhoneBookGroupCell

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
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(kHEIGHT(10), kHEIGHT(50)/2 - kHEIGHT(32)/2, kHEIGHT(32), kHEIGHT(32))];
    self.icon.layer.cornerRadius = 5;
    self.icon.clipsToBounds = YES;
    [self.contentView addSubview:self.icon];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right + 10, kHEIGHT(50)/2 - 10, SCREEN_WIDTH - kHEIGHT(32) - 80, 20)];
    self.nameLabel.font = kFONT(15);
    [self.contentView addSubview:self.nameLabel];
    
    
    self.sumBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.nameLabel.right+6,0, kHEIGHT(28), kHEIGHT(12))];
    self.sumBtn.centerY = self.nameLabel.centerY;
    self.sumBtn.clipsToBounds = YES;
    self.sumBtn.layer.cornerRadius = 2.5;
    self.sumBtn.titleLabel.font = kFONT(10);
    self.sumBtn.layer.borderColor = RGB(0, 172, 255).CGColor;
    self.sumBtn.layer.borderWidth = 0.5;
    [self.sumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sumBtn setBackgroundColor:RGB(0, 172, 255)];
    [self.sumBtn setImage:[UIImage imageNamed:@"xiaoxi_qunrenshu"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.sumBtn];
    
    
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self.sumBtn setBackgroundColor:RGB(0, 172, 255)];
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self.sumBtn setBackgroundColor:RGB(0, 172, 255)];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"PhoneBookGroupCell";
    WPPhoneBookGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[WPPhoneBookGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}
-(NSData*)imageData:(NSString*)imageStr
{
    NSArray * pathArray = [imageStr componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSData * data = [NSData dataWithContentsOfFile:fileName1];
    return data;
}
- (void)setModel:(WPPhoneBookGroupModel *)model
{
    if ([model.group_icon isKindOfClass:[UIImage class]]) {
        self.icon.image = model.group_icon;
    } else {
        NSString *url = [IPADDRESS stringByAppendingString:model.group_icon];
        NSData * data = [self imageData:url];
        if (data) {
            self.icon.image = [UIImage imageWithData:data];
        }
        else
        {
            WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [down downLoadImage:url success:^(id response) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.icon.image = [UIImage imageWithData:response];
                    });
                } failed:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                      self.icon.image = [UIImage imageNamed:@"small_cell_person"];  
                    });
                    
                }];
            });
            
        }
        
//        [self.icon sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    }
    
    NSString * nameStr = model.group_name;
    NSArray * nameArray = [nameStr componentsSeparatedByString:@","];
    NSMutableArray * nickArray = [NSMutableArray array];
    if (nameArray.count > 3) {
        [nickArray addObject:nameArray[0]];
        [nickArray addObject:nameArray[1]];
        [nickArray addObject:nameArray[2]];
        nameStr = [nickArray componentsJoinedByString:@","];
    }
    self.nameLabel.text = nameStr;//model.group_name
    
    CGSize size = [nameStr sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
    if (self.nameLabel.left+size.width+6+kHEIGHT(30)+kHEIGHT(10)>SCREEN_WIDTH) {
        size.width = SCREEN_WIDTH-self.nameLabel.left-6-kHEIGHT(30)-kHEIGHT(10);
        CGRect rect = self.nameLabel.frame;
        rect.size.width = size.width;
        self.nameLabel.frame = rect;
        self.sumBtn.left = self.nameLabel.right+6;
    }
    else
    {
      CGSize size = [nameStr sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
      CGRect rect = self.nameLabel.frame;
      rect.size.width = size.width;
      self.nameLabel.frame = rect;
      self.sumBtn.left = self.nameLabel.right+6;
    }
    [self.sumBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)model.user_lest.count] forState:UIControlStateNormal];
    [self.sumBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
    [self.sumBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
    
}

@end
