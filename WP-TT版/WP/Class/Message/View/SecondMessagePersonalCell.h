//
//  SecondMessagePersonalCell.h
//  WP
//
//  Created by 沈亮亮 on 16/1/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagePersonalModel.h"

@interface SecondMessagePersonalCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageV1;
@property (nonatomic, strong) UIImageView *imageV2;
@property (nonatomic, strong) UIImageView *imageV3;
@property (nonatomic, strong) UIImageView *imageV4;
@property (nonatomic, strong) MessagePersonalModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
