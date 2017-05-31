//
//  LinkmanCell.m
//  WP
//
//  Created by 沈亮亮 on 15/12/23.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "LinkmanCell.h"
#import "UIImageView+WebCache.h"
#import "WPDownLoadVideo.h"

@implementation LinkmanCell

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
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, kHEIGHT(50)/2 - kHEIGHT(32)/2, kHEIGHT(32), kHEIGHT(32))];
    self.icon.layer.cornerRadius = 5;
    self.icon.clipsToBounds = YES;
    [self.contentView addSubview:self.icon];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right + 10, kHEIGHT(50)/2 - 10, SCREEN_WIDTH - kHEIGHT(32) - 80, 20)];
    self.nameLabel.font = kFONT(15);
    [self.contentView addSubview:self.nameLabel];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"LinkmanCellId";
    LinkmanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //        cell = [[NSBundle mainBundle] loadNibNamed:@"NearActivityCell" owner:self options:nil][0];
        cell = [[LinkmanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

- (void)setModel:(LinkManListModel *)model
{
    if ([model.avatar isKindOfClass:[UIImage class]]) {
        self.icon.image = model.avatar;
    } else {
        NSString *url = [IPADDRESS stringByAppendingString:model.avatar];
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
                    self.icon.image = [UIImage imageNamed:@"small_cell_person"];
                }];
            });
            
        }
//        [self.icon sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    }
    
    if (model.nick_name) {
        self.nameLabel.text = model.nick_name;
    }else{
        self.nameLabel.text = model.user_name;
    }
    
    
}
-(NSData *)imageData:(NSString*)imageStr
{
    NSArray * pathArray = [imageStr componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSData * data = [NSData dataWithContentsOfFile:fileName1];
    return data;
}
+ (CGFloat)cellHeight
{
    return kHEIGHT(50);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
