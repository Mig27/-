//
//  CommentCell.h
//  WP
//
//  Created by 沈亮亮 on 15/8/21.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPResumeMessageModel.h"
#import "MLLinkLabel.h"

@class WPHotspotLabel;

@protocol jumpToPersonalPage <NSObject>

- (void)jumpToPersonalPageWith:(NSString *)use_id andNickName:(NSString *)nickName;
- (void)commentTopicWith:(NSDictionary *)topicInfo;

@end

@interface CommentCell : UITableViewCell

@property (nonatomic,strong) MLLinkLabel *commentLabel;
@property (nonatomic,assign) id<jumpToPersonalPage>delegate;

- (void)confignDataWith:(NSDictionary *)dic;
- (void)confignDataWithModel:(WPResumeCheckReplayCommentListModel *)model;
@end
