//
//  WPResumeMessageModel.h
//  WP
//
//  Created by CBCCBC on 15/12/2.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseModel.h"

@class WPResumeCheckMessageModel,WPResumeCheckReplayCommentListModel;
@interface WPResumeMessageModel : BaseModel


@property (nonatomic, strong) NSArray<WPResumeCheckMessageModel *> *CommentList;

@property (nonatomic, copy) NSString *status;/**< 状态 */

@property (nonatomic, copy) NSString *info;/**< 说明 */


@end
@interface WPResumeCheckMessageModel : NSObject

@property (nonatomic, copy) NSString *avatar;/**< 头像 */

@property (nonatomic, copy) NSString *commentId;/**< 评论ID */

@property (nonatomic, copy) NSString *createdUserId;/**< 创建者ID */

@property (nonatomic, strong) NSArray<WPResumeCheckReplayCommentListModel *> *ReplayCommentList;/**< 回复评论列表 */

@property (nonatomic, copy) NSString *commentContent;/**< 评论内容 */

@property (nonatomic, copy) NSString *userName;/**< 用户名 */

@property (nonatomic, copy) NSString *addTime;/**< 添加时间 */

@property (nonatomic, copy) NSString *company;/**< 公司 */

@property (nonatomic, copy) NSString *position;/**< 职位 */
@property (nonatomic, copy) NSString *to_nick_name;/**<被回复者昵称*/
@property (nonatomic, copy) NSString *to_user_id;/**<被回复者id*/
@property (nonatomic, copy) NSString *to_user_name;/**<被回复者名称*/

@end

@interface WPResumeCheckReplayCommentListModel : NSObject

@property (nonatomic, copy) NSString *replayUserId;/**< 回复者ID */

@property (nonatomic, copy) NSString *replayId;/**< 回复ID */

@property (nonatomic, copy) NSString *replayUserName;/**< 回复者名称 */

@property (nonatomic, copy) NSString *beReplayUserId;/**< 被回复者ID */

@property (nonatomic, copy) NSString *replayCommentContent;/**< 回复内容 */

@property (nonatomic, copy) NSString *beReplayUserName;/**< 被回复者名称 */

@end

