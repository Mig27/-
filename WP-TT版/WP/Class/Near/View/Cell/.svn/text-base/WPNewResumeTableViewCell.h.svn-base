//
//  WPNewResumeTableViewCell.h
//  WP
//
//  Created by CBCCBC on 16/6/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPLabel.h"
#import "WPInterviewModel.h"
#import "WPNewResumeModel.h"

@interface WPNewResumeTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iconImage;

@property (strong, nonatomic) SPLabel     *nameLabel;
@property (strong, nonatomic) SPLabel     *detailLabel;
@property (strong, nonatomic) SPLabel     *timeLabel;

@property (strong, nonatomic) UIButton *against;

@property (strong, nonatomic) UIButton    *buttonArrow;

@property (strong, nonatomic) WPNewResumeListModel *model;

@property (strong, nonatomic) NSIndexPath *path;
@property (strong ,nonatomic) NSString *status;
@property (nonatomic,assign) BOOL canSlected;//未发送成功的不能点击
- (void)exchangeSubViewFrame:(BOOL)isEdit;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)rowHeight;

@end
