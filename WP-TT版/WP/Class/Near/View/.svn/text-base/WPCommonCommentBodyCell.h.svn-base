//
//  WPCommonCommentBodyCell.h
//  WP
//
//  Created by CBCCBC on 15/12/2.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPResumeMessageModel.h"

@class WPHotspotLabel;

@interface WPCommonCommentBodyCell : UITableViewCell

@property (nonatomic,strong) WPHotspotLabel *commentLabel;
@property (nonatomic, copy) void (^GoToUserInfo)(NSString *userId, NSString *userName);
@property (nonatomic, copy) void (^ReplyThisContent)(WPResumeCheckReplayCommentListModel *model);
- (void)confignDataWithModel:(WPResumeCheckReplayCommentListModel *)model;

@end
