//
//  DynamicNewsModel.h
//  WP
//
//  Created by 沈亮亮 on 16/4/12.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface DynamicNewsModel : BaseModel

@property (nonatomic, copy) NSArray  *list;

@end

@interface DynamicNewsListModel : BaseModel

@property (nonatomic, copy) NSString *add_time;  /**< 评论时间 */
@property (nonatomic, copy) NSString *avatar;    /**< 头像 */
@property (nonatomic, copy) NSString *com_content;/**< 评论内容 */
@property (nonatomic, copy) NSString *companName; /**< 公司名称 */
@property (nonatomic, copy) NSString *content_type;/**< 动态类型，1文字，2图片，0视频 */
@property (nonatomic, copy) NSString *nick_name; /**< 昵称 */
@property (nonatomic, copy) NSString *position;  /**< 职位 */
@property (nonatomic, copy) NSString *set_type;  /**< 回复类型,0评论，1点赞，2分享,3系统消息,4个人申请 */
@property (nonatomic, copy) NSString *speak_content; /**< 动态内容，可以是文字，也可以是图片 */
@property (nonatomic, copy) NSString *speak_id;  /**< 动态ID */
@property (nonatomic, copy) NSString *dis_id;    /**< 调到的sid */
@property (nonatomic, copy) NSString *speak_reply; /**< 是否是回复 0否1是 */
@property (nonatomic, copy) NSString *by_user_id;  /**< 被回复人ID */
@property (nonatomic, copy) NSString *by_user_name; /**< 被回复人的昵称 */
@property (nonatomic, copy) NSString *img;/**< 招聘图标,为求职和招聘专用字段 */
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *from_user_id;
@property (nonatomic, copy) NSString * is_an;       //是否是匿名分享
@property (nonatomic, copy) NSString *album_id;
@property (nonatomic, copy) NSString *comment_content;
@property (nonatomic, copy) NSString *created_nick_name;
@property (nonatomic, copy) NSString *created_user_id;
@property (nonatomic, copy) NSString *created_user_name;
@property (nonatomic, copy) NSString *replay_comment_id;
@property (nonatomic, copy) NSString *replay_nick_name;
@property (nonatomic, copy) NSString *replay_user_id;
@property (nonatomic, copy) NSString *replay_user_name;



@end
