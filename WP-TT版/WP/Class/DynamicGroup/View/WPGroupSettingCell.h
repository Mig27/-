//
//  WPGroupSettingCell.h
//  WP
//
//  Created by 沈亮亮 on 16/4/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPGroupSettingCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) UISwitch * messageSwitch;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)rowHeight;
@property (nonatomic, copy) void(^mssageSwitch)(BOOL isOrNot);

@property (nonatomic,assign) BOOL switchState;

@end
