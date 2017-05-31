//
//  ApplyAndWantTableViewCell.h
//  WP
//
//  Created by CC on 16/8/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPLabel.h"
#import "WPMeApplyViewController.h"
#import "NearPersonalController.h"
@interface ApplyAndWantTableViewCell : UITableViewCell
@property (nonatomic, strong) SPLabel * titleLabel;
@property (nonatomic, strong) SPLabel * contentLabel;
@property (nonatomic, strong) SPLabel * timeLabel;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UIButton* selectbtn;
@property (nonatomic, copy) void (^choiseCell)(NSIndexPath*indexPath);
@property (nonatomic, strong) NSIndexPath * indexPath;
- (void)setListModel:(NearPersonalListModel *)listModel andApply:(BOOL)apply;
@end
