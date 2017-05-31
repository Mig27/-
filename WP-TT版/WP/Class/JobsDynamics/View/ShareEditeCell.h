//
//  ShareEditeCell.h
//  WP
//
//  Created by 沈亮亮 on 16/2/3.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareEditeCell : UITableViewCell

@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) NSDictionary *dic;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@end
