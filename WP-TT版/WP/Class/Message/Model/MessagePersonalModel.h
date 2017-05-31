//
//  MessagePersonalModel.h
//  WP
//
//  Created by 沈亮亮 on 16/1/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface MessagePersonalModel : BaseModel

@property (nonatomic, copy) NSString *avatar;   /**< 头像 */
@property (nonatomic, copy) NSString *nick_name;/**< 昵称 */
@property (nonatomic, copy) NSString *mobile;   /**< 手机号 */
@property (nonatomic, copy) NSString *wp_id;    /**< 微聘号 */
@property (nonatomic, copy) NSString *signature;/**< 个性签名 */
@property (nonatomic, copy) NSString *company;  /**< 公司 */
@property (nonatomic, copy) NSString *position; /**< 职位 */
@property (nonatomic, copy) NSString *industry; /**< 行业 */
@property (nonatomic, copy) NSString *workAddress;/**< 工作地址 */
@property (nonatomic, copy) NSString *address;  /**< 生活地址 */
@property (nonatomic, copy) NSString *hobby;    /**< 兴趣爱好 */
@property (nonatomic, copy) NSString *specialty;/**< 特长 */
@property (nonatomic, copy) NSString *profession;/**< 家乡 */
@property (nonatomic, copy) NSString *attention;/**< 关注人数 */
@property (nonatomic, copy) NSString *fans;     /**< 粉丝人数 */
@property (nonatomic, copy) NSString *friends;  /**< 好友人数 */
@property (nonatomic, copy) NSString *inviteJob;/**< 招聘数 */
@property (nonatomic, copy) NSString *iresume;  /**< 求职数 */
@property (nonatomic, copy) NSString *Game;     /**< 活动数 */
@property (nonatomic, copy) NSString *isCollection; /**< 是否已收藏 */
@property (nonatomic, copy) NSString *isattention;  /**< 是否已关注 */
@property (nonatomic, copy) NSString *sex;          /**< 性别 */
@property (nonatomic, strong) NSArray *Photolist;/**< 头像列表 */
@property (nonatomic, strong) NSArray *ImgList; /**< 4张图片 */
@property (nonatomic, copy) NSString *fremark;

@property (nonatomic, copy) NSString *uid;

@end

@interface MessagePhotoListModel : BaseModel

@property (nonatomic, copy) NSString *original_path;/**< 原图 */
@property (nonatomic, copy) NSString *thumb_path;   /**< 缩略图 */

@end

@interface MessageImgListModel : BaseModel

@property (nonatomic, copy) NSString *media_type;   /**< 图片的类型,0视频,2图片 */
@property (nonatomic, copy) NSString *original_path;/**< 原图 */
@property (nonatomic, copy) NSString *thumb_path;   /**< 缩略图 */


@end