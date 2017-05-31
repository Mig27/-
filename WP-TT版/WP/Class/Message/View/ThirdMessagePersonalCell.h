//
//  ThirdMessagePersonalCell.h
//  WP
//
//  Created by 沈亮亮 on 16/1/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdMessagePersonalCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numberLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
