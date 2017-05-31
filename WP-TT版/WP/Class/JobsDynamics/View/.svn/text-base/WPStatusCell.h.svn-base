//
//  WPStatusCell.h
//  WP
//
//  Created by 沈亮亮 on 15/6/8.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WPStatusFrame;
@class  WPStatusView;
@class WPStatusCell;
@protocol WPStatusCellDelegate <NSObject>

@optional
- (void)didShowOperationView:(UIButton *)sender indexPath:(NSIndexPath *)indexPath;

@end

@interface WPStatusCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) WPStatusFrame *statusFrame;
@property (nonatomic, weak) WPStatusView *topView;

@property (nonatomic, weak) id <WPStatusCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
