//
//  WPBlackLIstCell.h
//  WP
//
//  Created by Kokia on 16/5/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrienDListModel.h"


typedef void(^check)();

@class WPBlackLIstCell;
@protocol WPBlackLIstCellDelegate <NSObject>
@optional

- (void)didSelectWPBlackLIstCell:(WPBlackLIstCell *)cell;


@end


@interface WPBlackLIstCell : UITableViewCell

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) WPFriendModel *model;

@property (nonatomic,assign) BOOL isEditStatue;  // 决定是否展示√
@property (nonatomic,assign) BOOL isSeleted; // 单个cell 是否被选择

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<WPBlackLIstCellDelegate>  delegate;

@property (nonatomic,strong) UIButton *button;

@property (nonatomic,copy) check check;

+ (CGFloat)cellHeight;


@end
