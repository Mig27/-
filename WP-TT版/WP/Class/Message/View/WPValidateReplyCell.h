//
//  WPValidateReplyCell.h
//  WP
//
//  Created by Kokia on 16/5/17.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPReplyListModel.h"

@interface WPValidateReplyCell : UITableViewCell
//
//@class WPDragIntoBlackListCell;
//@protocol WPDragIntoBlackListCellDelegate <NSObject>
//@optional
//- (void)WPDragIntoBlackListCellDidClickedCoverBtn:(WPDragIntoBlackListCell *)WPDragIntoBlackListCell;
//
//@end

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) WPReplyListModel *msgModel;

@end
