//
//  WPResumeMessageModel.m
//  WP
//
//  Created by CBCCBC on 15/12/2.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPResumeMessageModel.h"

@implementation WPResumeMessageModel


+ (NSDictionary *)objectClassInArray{
    return @{@"CommentList" : [WPResumeCheckMessageModel class]};
}
@end
@implementation WPResumeCheckMessageModel

+ (NSDictionary *)objectClassInArray{
    return @{@"ReplayCommentList" : [WPResumeCheckReplayCommentListModel class]};
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"commentId":@"comment_id",
             @"createdUserId":@"created_user_id",
             @"commentContent":@"comment_content",
             @"userName":@"user_name",
             @"addTime":@"add_time"};
}

@end


@implementation WPResumeCheckReplayCommentListModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"replayUserId":@"replay_user_id",
             @"replayId":@"replay_id",
             @"replayUserName":@"replay_user_name",
             @"beReplayUserId":@"be_replay_user_id",
             @"replayCommentContent":@"replay_comment_content",
             @"beReplayUserName":@"be_replay_user_name"};
}

@end


