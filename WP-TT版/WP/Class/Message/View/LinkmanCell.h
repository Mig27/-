//
//  LinkmanCell.h
//  WP
//
//  Created by 沈亮亮 on 15/12/23.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinkManModel.h"

@interface LinkmanCell : UITableViewCell

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) LinkManListModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@end
