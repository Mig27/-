//
//  PersonalFriendModel.h
//  WP
//
//  Created by 沈亮亮 on 16/1/5.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface PersonalFriendListModel : BaseModel

@property (nonatomic, copy) NSString *avatar;          /**< 头像 */
@property (nonatomic, copy) NSString *nick_name;       /**< 昵称 */
@property (nonatomic, copy) NSString *position;        /**< 职位 */
@property (nonatomic, copy) NSString *company;         /**< 公司 */
@property (nonatomic, copy) NSString *attention_state; /**< 关注状态 */
@property (nonatomic, copy) NSString *by_user_id;      /**< id */

@end

@interface PersonalFriendModel : BaseModel

@property (nonatomic, strong) NSArray *FriendsList;

@end
