//
//  InterestedCell.h
//  WP
//
//  Created by 沈亮亮 on 15/12/28.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterestedModel.h"

@interface InterestedCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic,copy) void(^opertionAttentionBlock)(NSIndexPath *indexPath,NSString *title);
@property (nonatomic, strong) InterestedListModel *model;

@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIImageView *addressImageV;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;


@end
