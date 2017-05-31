//
//  WPPhonebookSwitchCell.h
//  WP
//
//  Created by Kokia on 16/5/24.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPPhonebookSwitchCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UISwitch *switchView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
