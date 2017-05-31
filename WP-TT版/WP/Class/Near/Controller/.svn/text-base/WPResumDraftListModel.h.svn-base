//
//  WPResumDraftModel.h
//  WP
//
//  Created by Kokia on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

// My

#import <Foundation/Foundation.h>


/*
 
 {
 "resume_id": "351", 求职简历ID
 "avatar": "/upload/201512/30/thumb_201512301020071017.png",
 "nick_name": "王尼玛",
 "sex": "女",
 "birthday": "33",
 "education": "中专",
 "position": "高级硬件工程师",
 "worktime": "3-5年",
 "resume_user_id": "269"
 
 
 */


@interface WPResumDraftModel : NSObject

#pragma mark - 自定义字段
@property (nonatomic, assign) BOOL itemIsSelected; /**< 是否被选中 */

#pragma mark - 草稿和求职者公用

/** 求职简历ID */
@property (nonatomic, copy) NSString *resumeId;

/** 求职者ID */
@property (nonatomic, copy) NSString *resumeUserId;

/** 头像 */
@property (nonatomic, copy) NSString *avatar;

/** 昵称 */
@property (nonatomic, copy) NSString *nickName;

/** 性别 */
@property (nonatomic, copy) NSString *sex;

/** 年龄 */
@property (nonatomic, copy) NSString *birthday;

/** 学历 */
@property (nonatomic, copy) NSString *education;

/** 工作时间 */
@property (nonatomic, copy) NSString *worktime;

/** 手机号码 */
@property (nonatomic, copy) NSString *TelIsShow;
#pragma mark - 求职者列表
/** 求职 职位 */
@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *Hope_Position;
@end



@interface WPResumDraftListModel : NSObject


/** 草稿列表 */
@property (nonatomic, strong) NSArray *draftList;

/** 求职者列表 */
@property (nonatomic, strong) NSArray *list;



@property (nonatomic, copy) NSString *info;

@property (nonatomic, copy) NSString *status;

@end

