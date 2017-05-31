//
//  WPGroupCell.h
//  WP
//
//  Created by 沈亮亮 on 16/4/14.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobGroupModel.h"

@interface WPGroupCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *sumBtn;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIImageView *addressImg;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) JobGroupListModel *model;
@property (nonatomic, strong) UILabel * line;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)rowHeight;

@end
