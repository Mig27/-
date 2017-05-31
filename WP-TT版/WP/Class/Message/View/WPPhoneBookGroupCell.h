//
//  WPPhoneBookGroupCell.h
//  WP
//
//  Created by Kokia on 16/5/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPPhoneBookGroupModel.h"

@interface WPPhoneBookGroupCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) UIButton * sumBtn;
@property (nonatomic,strong) WPPhoneBookGroupModel *model;

@end
