//
//  LinkAddCell.h
//  WP
//
//  Created by 沈亮亮 on 15/12/29.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkAddCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *functionLabel;
@property (nonatomic, strong) NSDictionary *info;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@end
