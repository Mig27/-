//
//  WPInterViewOneCell.h
//  WP
//
//  Created by CBCCBC on 15/9/18.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPInterviewModel.h"
#import "SPLabel.h"

@interface WPInterViewTCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *iconImage;
@property (strong, nonatomic)  SPLabel *nameLable;
@property (strong, nonatomic)  SPLabel *detailLable;
@property (strong, nonatomic)  SPLabel *timeLable;
@property (strong, nonatomic)  UIImageView *imageAgainst;
@property (strong, nonatomic)  UIButton *buttonArrow;
@property (strong, nonatomic)  WPInterviewListModel *model;
@property (strong, nonatomic) NSIndexPath *path;
@property (strong, nonatomic) void (^cellIndexPathClick)(NSIndexPath *path);
//- (void)setModel:(WPInterviewListModel *)model;
+ (instancetype)cellWithTableView:(UITableView*)tableView;



@end
