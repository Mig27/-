//
//  GroupMemberModel.h
//  WP
//
//  Created by 沈亮亮 on 16/4/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"
#import "ChineseString.h"

@interface GroupMemberModel : BaseModel

@property (nonatomic, strong) NSArray *list;

@end

@interface GroupMemberListModel : BaseModel

@property (nonatomic, strong) NSString *admin;       /**< 是否是管理员1是0否 */
@property (nonatomic, strong) NSString *avatar;      /**< 头像 */
@property (nonatomic, strong) NSString *is_create;   /**< 是否是创建人 1是 0否 */
@property (nonatomic, strong) NSString *nick_name;   /**< 用户名 */
@property (nonatomic, strong) NSString *remark_name; /**< 备注 */
@property (nonatomic, strong) NSString *user_id;     /**< 用户ID */
@property (nonatomic, strong) NSString *user_name;   /**< user_name */
@property (nonatomic, strong) NSString *is_selected; /**< 是否选中，1是0否 */
@property (strong,nonatomic) ChineseString *chineseString;

@end