//
//  NearActivityCell.h
//  WP
//
//  Created by 沈亮亮 on 15/10/9.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearActivityModel.h"

@interface NearActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addresLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic,strong) NearActivityListModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
