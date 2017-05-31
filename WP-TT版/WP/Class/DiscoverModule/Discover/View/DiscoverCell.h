//
//  DiscoverCell.h
//  WP
//
//  Created by 沈亮亮 on 15/9/22.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPBadgeButton.h"

@interface DiscoverCell : UITableViewCell

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *title;
@property (nonatomic, strong) WPBadgeButton *badgBtn;     /**< 小红点 */
@property (nonatomic, strong) UIImageView *tipIcon;       /**< 提示头像 */
@property (nonatomic, strong) UIImageView *redDot;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) UILabel * badgageLabel;
@property (nonatomic, strong) NSString *applyCount;//求职的个数
@property (nonatomic, strong) NSString *inviteCount;//招聘的个数

@end
