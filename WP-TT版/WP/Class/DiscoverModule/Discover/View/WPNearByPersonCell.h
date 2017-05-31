//
//  WPNearByPersonCell.h
//  WP
//
//  Created by Kokia on 16/5/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPNearbyPersonModel.h"

@interface WPNearByPersonCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIImageView *addressImg;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) WPNearbyPersonModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)rowHeight;

@end
