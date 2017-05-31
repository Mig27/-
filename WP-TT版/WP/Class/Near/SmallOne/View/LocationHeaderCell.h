//
//  LocationHeaderCell.h
//  WP
//
//  Created by 沈亮亮 on 16/5/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationHeaderCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
