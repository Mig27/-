//
//  WPMessageAlertCell.h
//  WP
//
//  Created by 沈亮亮 on 16/4/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPMessageAlertCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) NSString *titleString;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)rowHeight;

@end
