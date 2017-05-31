//
//  WPMeActivitiesCell.h
//  WP
//
//  Created by CBCCBC on 16/1/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPBadgeButton.h"
@interface WPMeActivitiesCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) WPBadgeButton *badgageBtn;
@property (nonatomic, copy) NSString *applyCount;
@property (nonatomic, copy) NSString *inviteCount;
@end
