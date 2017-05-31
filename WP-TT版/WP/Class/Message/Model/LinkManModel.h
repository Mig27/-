//
//  LinkManModel.h
//  WP
//
//  Created by 沈亮亮 on 15/12/23.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseModel.h"
#import "ChineseString.h"

@interface LinkManListModel : BaseModel

@property (nonatomic, strong) NSString *fk_id;    /**< 主键ID */
@property (nonatomic, strong) NSString *user_id;  /**< 用户ID */
@property (nonatomic, strong) NSString *mobile;   /**< 手机号 */
@property (nonatomic, strong) NSString *user_name;/**< 用户名 */
@property (nonatomic, strong) NSString *nick_name;/**< 昵称 */
@property (nonatomic, strong) NSString *friend_id;
@property (nonatomic, strong) id avatar;          /**< 头像 */
@property (nonatomic, strong) NSString *is_be;    /**< 1是存在该群 0是不存在该群 */
@property (nonatomic, strong) NSString *is_selected;/**< 1是已选择 0是未选择 */
@property (nonatomic, strong) NSString *wp_id;
@property (strong,nonatomic) ChineseString *chineseString;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *position;

@end

@interface LinkManModel : BaseModel

@property (nonatomic,strong) NSArray *list;

@end
