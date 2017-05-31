//
//  WPGroupInformationCell1.h
//  WP
//
//  Created by 沈亮亮 on 16/4/19.
//  Copyright © 2016年 WP. All rights reserved.
//  群信息详情页cell 群公告/ 群介绍 / 群名称 / 群号码 / 群行业 / 群地点

#import <UIKit/UIKit.h>

@interface WPGroupInformationCell1 : UITableViewCell

@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UILabel *informationLabel;
@property (nonatomic, strong) UIImageView *accessImage;
@property (nonatomic, assign) BOOL milti; //是否多行
@property (nonatomic, assign) NSInteger lines;
@property (nonatomic, strong) NSString *itemStr;
@property (nonatomic, assign) NSString *informationStr;
@property (nonatomic, assign) BOOL siAccess;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)rowHeightWithString:(NSString *)string andLines:(NSInteger)line isMulti:(BOOL)multi;

@end
