//
//  ButtonMenuCollectionCell.h
//  WP
//
//  Created by 沈亮亮 on 15/11/4.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndustryModel.h"
#import "DynamicTopicTypeModel.h"

@interface ButtonMenuCollectionCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *sumLabel;
@property (nonatomic, strong) UIImageView *selectImage;
@property (nonatomic, strong) UIImageView *sumImage;
@property (nonatomic,strong) DynamicTopicTypeModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)rowHeight;

@end
