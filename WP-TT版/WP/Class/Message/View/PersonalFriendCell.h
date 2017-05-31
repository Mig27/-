//
//  PersonalFriendCell.h
//  WP
//
//  Created by 沈亮亮 on 16/1/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalFriendModel.h"

@interface PersonalFriendCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic,copy) void(^opertionAttentionBlock)(NSIndexPath *indexPath,NSString *title);
@property (nonatomic, strong) PersonalFriendListModel *model;
@property (nonatomic, strong) UILabel *line;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;


@end
