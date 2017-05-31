//
//  WPPersonInfoFremarkSettedCell.h
//  WP
//
//  Created by Kokia on 16/5/24.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "MessagePersonalModel.h"

@interface WPPersonInfoFremarkSettedCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *wpLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *nikenameLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) MessagePersonalModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
