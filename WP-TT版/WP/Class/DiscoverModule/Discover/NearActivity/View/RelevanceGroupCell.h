//
//  RelevanceGroupCell.h
//  WP
//
//  Created by 沈亮亮 on 15/10/22.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelevanceGroupModel.h"
#import "WPButton.h"

@interface RelevanceGroupCell : UITableViewCell

@property (nonatomic,strong) WPButton *iconBtn;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *numberBtn;
@property (nonatomic,strong) UILabel *descripLabel;
@property (nonatomic,strong) RelevanceGroupListModel *model;

+(instancetype)cellWithTableView:(UITableView *)tableView;
+(CGFloat)height;

@end
