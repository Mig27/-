//
//  WPGroupMemberCell.h
//  WP
//
//  Created by 沈亮亮 on 16/4/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupMemberModel.h"

@interface WPGroupMemberCell : UITableViewCell

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) GroupMemberListModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;


@end
