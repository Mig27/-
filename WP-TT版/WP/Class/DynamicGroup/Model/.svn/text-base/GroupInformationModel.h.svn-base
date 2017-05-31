//
//  GroupInformationModel.h
//  WP
//
//  Created by 沈亮亮 on 16/4/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface GroupInformationModel : BaseModel

@property (nonatomic, copy) NSArray *json;

@end

@interface GroupInformationListModel : BaseModel

@property (nonatomic, strong) NSString *group_id;    /**< 群ID */
@property (nonatomic, strong) NSString *group_name; /**< 群名称 */
@property (nonatomic, strong) NSString *group_no;   /**< 群号 */
@property (nonatomic, strong) NSString *group_Industry;/**< 群行业 */
@property (nonatomic, strong) NSString *add_address;/**< 群地址 */
@property (nonatomic, strong) NSString *add_addressDesc;
@property (nonatomic, strong) NSString *group_cont; /**< 群介绍 */
@property (nonatomic, strong) NSString *remark_name;/**< 我的群昵称 */
@property (nonatomic, copy) NSArray *iconList; /**< 头像图片 */
@property (nonatomic, copy) NSArray *PhotoList;/**< 相册图片 */
@property (nonatomic, copy) NSArray *NoticeList;/**< 群公告 */
@property (nonatomic, copy) NSArray *MenberList;/**< 群成员头像 */
@property (nonatomic, strong) NSString *photoCount; /**< 群相册数量 */
@property (nonatomic, strong) NSString *MenberCount;/**< 群成员数量 */
@property (nonatomic, strong) NSString *is_notice; /**< 群消息免打扰0接收 1屏蔽 */
@property (nonatomic, strong) NSString *is_near; /**< 是给附近的人查看 0否 1是 */
@property (nonatomic, strong) NSString *is_to;  /**< 消息是否置顶 0否 1是*/
@property (nonatomic, strong) NSString *is_sound; /**< 消息提醒模式0有声 1无声 2屏蔽 */
@property (nonatomic, strong) NSString *g_id;

@end

@interface iconListModel : BaseModel

@property (nonatomic, strong) NSString *isTop; /**< 1表示是第一张图片0表示不是 */
@property (nonatomic, strong) NSString *thumb_path; /**< 小图 */
@property (nonatomic, strong) NSString *original_path; /**< 原图 */

@end

@interface PhotoListModel : BaseModel

@property (nonatomic, strong) NSString *thumb_path; /**< 小图 */
@property (nonatomic, strong) NSString *original_path; /**< 原图 */

@end

@interface NoticeListModel : BaseModel

@property (nonatomic, strong) NSString *notice; /**< 公告 */

@end

@interface MenberListModel : BaseModel

@property (nonatomic, strong) NSString *avatar; /**< 头像 */
@property (nonatomic, copy) NSString*user_id;
@property (nonatomic, copy) NSString*is_create;
@end