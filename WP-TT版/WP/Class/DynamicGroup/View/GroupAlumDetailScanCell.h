//
//  GroupAlumDetailScanCell.h
//  WP
//
//  Created by 沈亮亮 on 16/5/3.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupPhotoAlumModel.h"

@interface GroupAlumDetailScanCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) otherListModel *dic;
@property (nonatomic, strong) UILabel *timeLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@end
