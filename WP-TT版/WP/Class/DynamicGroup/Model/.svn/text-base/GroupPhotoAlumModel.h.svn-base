//
//  GroupPhotoAlumModel.h
//  WP
//
//  Created by 沈亮亮 on 16/4/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface GroupPhotoAlumModel : BaseModel

@property (nonatomic, copy) NSArray *list;

@end

@interface GroupPhotoAlumListModel : BaseModel

@property (nonatomic, copy) NSArray *CommentList;  /**< 评论列表 */
@property (nonatomic, copy) NSArray *PhotoList;    /**< 图片列表 */
@property (nonatomic, copy) NSArray *PraiseList;   /**< 点赞列表 */
@property (nonatomic, copy) NSArray *otherList;    /**< 详情其他列表，浏览，评论，点赞 */
@property (nonatomic, strong) NSString *add_time;  /**< 时间 */
@property (nonatomic, strong) NSString *user_name; /**< 用户名 */
@property (nonatomic, strong) NSString *position;  /**< 职位 */
@property (nonatomic, strong) NSString *company;   /**< 公司 */
@property (nonatomic, strong) NSString *remark;    /**< 文字内容 */
@property (nonatomic, strong) NSString *address;   /**< 地址 */
@property (nonatomic, strong) NSString *myPraise;  /**< 是否点赞，0未赞，1已赞 */
@property (nonatomic, strong) NSString *commentCount; /**< 评论人数 */
@property (nonatomic, strong) NSString *praiseCount;  /**< 点赞人数 */
@property (nonatomic, strong) NSString *browseCount;  /**< 浏览人数 */
@property (nonatomic, strong) NSString *albumnId;     /**< 相册的id */
@property (nonatomic, strong) NSString *avatar;       /**< 头像 */
@property (nonatomic, strong) NSString *disType;      /**< 当前显示的是什么内容 */
@property (nonatomic, strong) NSString *created_user_id;
@property (nonatomic, strong) NSString *is_del;

@end

@interface CommentListModel : BaseModel

@property (nonatomic, strong) NSString *commentId;  /**< 评论的ID */
@property (nonatomic, strong) NSString *album_id;   /**< 相册ID */
@property (nonatomic, strong) NSString *comment_content; /**< 评论内容 */
@property (nonatomic, strong) NSString *created_nick_name;/**< 评论发布者 */
@property (nonatomic, strong) NSString *created_user_id;  /**< 发布者user_id */
@property (nonatomic, strong) NSString *replay_comment_id;
@property (nonatomic, strong) NSString *replay_nick_name; /**< 被回复者nick_name */
@property (nonatomic, strong) NSString *replay_user_id;   /**< 被回复者user_id */
@property (nonatomic, strong) NSString *read_time;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *position;    /**< 职位 */
@property (nonatomic, strong) NSString *company;  /**< 公司 */
@property (nonatomic, strong) NSString *comment_id;
@end

@interface GroupPhotoListModel : BaseModel

@property (nonatomic, strong) NSString *original_path;   /**< 原图 */
@property (nonatomic, strong) NSString *thumb_path;   /**< 缩略图 */


@end

@interface PraiseListModel : BaseModel

@property (nonatomic, strong) NSString *created_nick_name;   /**< 点赞人的nick_name */
@property (nonatomic, strong) NSString *created_user_id;   /**< 点赞人的user_id */


@end

@interface otherListModel : BaseModel

@property (nonatomic, strong) NSString *album_id;  /**< 相册ID */
@property (nonatomic, strong) NSString *avatar;    /**< 头像 */
@property (nonatomic, strong) NSString *comment_content;/**< 回复内容 */
@property (nonatomic, strong) NSString *company;  /**< 公司 */
@property (nonatomic, strong) NSString *created_nick_name; /**< 评论人的昵称 */
@property (nonatomic, strong) NSString *created_user_id;   /**< 评论人的id */
@property (nonatomic, strong) NSString *position;    /**< 职位 */
@property (nonatomic, strong) NSString *replay_nick_name;  /**< 被回复人的昵称 */
@property (nonatomic, strong) NSString *replay_user_id;    /**< 被回复人的id */
@property (nonatomic, strong) NSString *comment_id;        /**< 评论的id */
@property (nonatomic, strong) NSString *nick_name;  /**< 浏览和赞的昵称 */
@property (nonatomic, strong) NSString *user_id;/**< 浏览人和点赞人的user_id */
@property (nonatomic, strong) NSString *read_time;
@property (nonatomic, strong) NSString *add_time;
@end

@interface GroupAlumDetailModel : BaseModel

@property (nonatomic, copy) NSArray *list;

@end

@interface GroupAlumDetailListModel : BaseModel

@property (nonatomic, copy) NSArray *otherList;       /**< 详情数据列表 */
@property (nonatomic, strong) NSString *commentCount; /**< 评论总量 */
@property (nonatomic, strong) NSString *praiseCount;  /**< 赞总量 */
@property (nonatomic, strong) NSString *browseCount;  /**< 浏览总量 */

@end

