//
//  NewNearActivityCell.h
//  WP
//
//  Created by 沈亮亮 on 15/11/2.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearActivityModel.h"

@interface NewNearActivityCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *addresLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *numberLabel;
@property (nonatomic,strong) NearActivityListModel *model;
@property (nonatomic,assign) CGFloat *iconImageHeight;   //图片的高度

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
