//
//  OpenCell.h
//  WP
//
//  Created by 沈亮亮 on 16/2/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) UIButton *selectImage;
@property (nonatomic, strong) NSIndexPath*index;
@property (nonatomic, copy) void(^choiseBtnClick)(NSIndexPath*index,BOOL isOrNot);
+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;


@end
