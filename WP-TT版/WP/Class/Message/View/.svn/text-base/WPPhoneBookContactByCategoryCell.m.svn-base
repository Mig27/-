//
//  WPPhoneBookContactByCategoryCell.m
//  WP
//
//  Created by Kokia on 16/5/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPhoneBookContactByCategoryCell.h"
#import "WPDownLoadVideo.h"
@interface WPPhoneBookContactByCategoryCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;



@end

@implementation WPPhoneBookContactByCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}


-(UIButton *)button{
    if (_button == nil) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setImage:[UIImage imageNamed:@"common_xuanze"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"common_xuanzhong"] forState:UIControlStateSelected];
//        [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.button];
    }
    return _button;
}

- (void)createUI
{
    UIImageView *icon =[[UIImageView alloc] init];
    self.icon = icon;
    self.icon.layer.cornerRadius = 5;
    self.icon.clipsToBounds = YES;
    [self.contentView addSubview:self.icon];
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = kFONT(15);
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).with.offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@(SCREEN_WIDTH - kHEIGHT(32) - 80));
        make.height.equalTo(@20);
    }];
    
}



- (void)setNeedSelect:(BOOL)needSelect
{
    _needSelect = needSelect;
    if (needSelect) {
        self.button.frame = CGRectMake(kHEIGHT(10), 0, self.button.imageView.width+kHEIGHT(20), kHEIGHT(43));
//        self.button.layer.cornerRadius = (self.button.width - self.button.imageView.width)/2;
        
    }
}


- (void)buttonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.contactModel.selected = sender.selected;
}



-(void)setContactModel:(WPPhoneBookContactDetailModel *)contactModel{
    _contactModel = contactModel;
    self.button.selected = contactModel.selected;
    if (_needSelect) {
        self.icon.frame = CGRectMake(self.button.right + kHEIGHT(10), (50 -kHEIGHT(32))/2, kHEIGHT(32), kHEIGHT(32));
    }else{
        self.icon.frame = CGRectMake(kHEIGHT(10), (50 -kHEIGHT(32))/2, kHEIGHT(32), kHEIGHT(32));
    }
    
    
    NSString *url = [IPADDRESS stringByAppendingString:contactModel.avatar];
    NSArray * pathArray = [url componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSData * data = [NSData dataWithContentsOfFile:fileName1];
    if (data)
    {
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
//    [self.icon sd_setImageWithURL:URLWITHSTR(url) placeholderImage:[UIImage imageNamed:@"small_cell_person"]];
    self.nameLabel.text = contactModel.nick_name;
    
}



@end
