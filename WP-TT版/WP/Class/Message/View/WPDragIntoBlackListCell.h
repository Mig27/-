//
//  WPDragIntoBlackListCell.h
//  WP
//
//  Created by Kokia on 16/5/12.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPDragIntoBlackListCell;
@protocol WPDragIntoBlackListCellDelegate <NSObject>
@optional
- (void)WPDragIntoBlackListCellDidClickedCoverBtn:(WPDragIntoBlackListCell *)WPDragIntoBlackListCell;

@end


@interface WPDragIntoBlackListCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UISwitch *switchView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,assign) id<WPDragIntoBlackListCellDelegate> delegate;

@end
