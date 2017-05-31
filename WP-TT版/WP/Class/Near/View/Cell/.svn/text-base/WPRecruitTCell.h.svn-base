//
//  UIEmployOneCell.h
//  WP
//
//  Created by Asuna on 15/5/21.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPRecruitModel.h"
#import "SPLabel.h"

@interface WPRecruitTCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *iconImage;
@property (strong, nonatomic)  SPLabel *nameLable;
@property (strong, nonatomic)  SPLabel *detailLable;
@property (strong, nonatomic)  UIButton *detailBtn;
@property (strong, nonatomic)  SPLabel *timeLable;
@property (strong, nonatomic)  UIImageView *imageAgainst;
@property (strong, nonatomic)  UIButton *buttonArrow;
@property (strong, nonatomic)  NSObject *model;

@property (strong, nonatomic) NSIndexPath *path;
@property (strong, nonatomic) void (^cellIndexPathClick)(NSIndexPath *path);
@property (strong, nonatomic) void (^detailBlock)(NSIndexPath *path);
//- (void)setModel:(WPRecruitListModel *)model;
+ (instancetype)cellWithTableView:(UITableView*)tableView;
+ (CGFloat)rowHeight;
@end
