//
//  WPAddMePersonCell.h
//  WP
//
//  Created by Kokia on 16/5/16.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPToAddListFriendModel.h"
#import "WPBadgeButton.h"

@interface WPAddMePersonCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) WPToAddListFriendModel *model;

@property (nonatomic,strong) NSMutableArray *dataList;

@property (strong, nonatomic) WPBadgeButton *badgeButton;



@end
