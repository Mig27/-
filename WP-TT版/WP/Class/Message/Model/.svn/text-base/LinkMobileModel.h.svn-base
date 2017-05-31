//
//  LinkMobileModel.h
//  WP
//
//  Created by 沈亮亮 on 15/12/25.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseModel.h"
#import "ChineseString.h"

@interface LinkMobileListModel : BaseModel

@property (nonatomic, copy) NSString *fk_id;        /**< ID */
@property (nonatomic, copy) NSString *user_id;      /**< 用户ID */
@property (nonatomic, copy) NSString *avatar;       /**< 头像 */
@property (nonatomic, copy) NSString *mobile;       /**< 手机号 */
@property (nonatomic, copy) NSString *mobileName;   /**< 手机通讯录里面的名称 */
@property (nonatomic, copy) NSString *user_name;    /**< 昵称 */
@property (nonatomic, copy) NSString *isatt;        /**< 关注状态 */
@property (nonatomic, copy) NSString *is_mf;        /**< 0表示微聘好友 1为手机好友 */

@property (nonatomic, copy) NSString *add_fuser_state; // 添加好友审核状态 0好友 1待通过 2陌生人
@property (nonatomic, copy) NSString *form_state;  //我对好友的状态 0默认 1等待验证 2等待接受
@property (nonatomic, copy) NSString *is_shield;  //是否黑名单 1是 0否

@property (nonatomic, copy) NSString *belongGroup;

@property (nonatomic, copy) NSString *showOnce; //1 

@property (strong,nonatomic) ChineseString *chineseString;

@end

@interface LinkMobileModel : BaseModel

@property (nonatomic, strong) NSArray *list;

@end
