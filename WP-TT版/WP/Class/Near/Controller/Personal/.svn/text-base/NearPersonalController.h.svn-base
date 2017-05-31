//
//  NearPersonalController.h
//  WP
//
//  Created by CBCCBC on 15/9/24.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

typedef NS_ENUM(NSInteger,WPNearPersonalType) {
    WPNearPersonalTypeRecruit = 0,
    WPNearPersonalTypeInterview,
    WPNearPersonalTypeActivity,
};

@interface NearPersonalController : BaseViewController

@property (copy, nonatomic) NSString *userId;
@property (assign, nonatomic) BOOL isSelf;/**< 弃用（始终为NO） */
@property (assign, nonatomic) BOOL isRecruit;/**< 弃用（改为Type） */
@property (nonatomic, assign) WPNearPersonalType type;
@property (nonatomic, strong) NSString *nick_name;

@property (nonatomic, assign) BOOL isFromPersonalInfo;

@property (nonatomic, assign) NewRelationshipType newType; /**< 与当前登录人的关系 */

@end

/**
 *  招聘、求职、活动 Model
 */
@interface NearPersonalModel : BaseModel

@property (nonatomic, copy) NSString *nick_name;/**< 头部用户名 */
@property (nonatomic, copy) NSString *avatar;/**< 头部头像 */
@property (nonatomic, copy) NSString *position;/**< 头部职位 */
@property (nonatomic, copy) NSString *company;/**< 公司 */
@property (assign, nonatomic) int attention_state;/**< 关注状态 */
@property (nonatomic, copy) NSString *user_id;/**< 用户ID */
@property (strong, nonatomic) NSArray *list;/**< 简历列表 */

@property (copy, nonatomic) NSString *info;/**< 返回信息 */
@property (nonatomic, copy) NSString * signCount;//数量

@end

/**
 *  个人Model
 */
@interface NearPersonalListModel : BaseModel

//公用字段名
@property (copy, nonatomic) NSString *avatar;/**< 头像 */
@property (copy, nonatomic) NSString *position;/**< 职位 */
@property (copy, nonatomic) NSString *ranking;/**< 浏览数量 */
@property (copy, nonatomic) NSString *resumeId;/**< 职位ID */
@property (copy, nonatomic) NSString *signUp;/**< 报名数量 */
@property (copy, nonatomic) NSString *comcount;/**< 留言数量 */
@property (copy, nonatomic) NSString *sysMessage;/**< 系统消息 */
@property (copy, nonatomic) NSString *updateTime;/**< 更新时间 */
@property (copy, nonatomic) NSString *userId;/**< 用户ID */
@property (nonatomic ,strong)NSString *shareCount; // 分享数量
@property (nonatomic, copy)NSString * shelvesDown;//上下架
@property (nonatomic, copy)NSString * signCount;//数量
@property (nonatomic, copy)NSString * is_auto;//自动刷新
@property (nonatomic, copy)NSString * UnReadCount;//总数
@property (nonatomic, copy)NSString * sys_message;  //系统消息未读数
@property (nonatomic, copy) NSString * sys_count;   //系统消息数量

//招聘 所需要的字段名
@property (copy, nonatomic) NSString *enterprise_name;/**< 公司名称 */
@property (nonatomic ,strong)NSString *pageView;

@property (copy, nonatomic) NSString *enterprise_properties;//性质
@property (copy, nonatomic) NSString *dataIndustry;//行业
@property (copy, nonatomic) NSString *enterprise_scale;//规模
@property (copy, nonatomic) NSString *enterprise_address;
@property (copy, nonatomic) NSString *enterprise_brief;

//求职 所需要的字段名
@property (copy, nonatomic) NSString *worktime;/**< 工作时间 */
@property (copy, nonatomic) NSString *sex;/**< 性别 */
@property (copy, nonatomic) NSString *age;/**< 年龄 */
@property (copy, nonatomic) NSString *nike_name;/**< 昵称 */
@property (copy, nonatomic) NSString *education;/**< 学历 */
@property (copy, nonatomic) NSString *lightSpot;
@property (copy ,nonatomic) NSString *txtcontent;

//活动所需要的字段名
@property (assign, nonatomic) int game_type;/**< 活动类型 */
@property (assign ,nonatomic) BOOL isSelected;
@end
