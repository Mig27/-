//
//  WPResumeUserListModel.h
//  WP
//
//  Created by Kokia on 16/3/23.
//  Copyright © 2016年 WP. All rights reserved.
//

// My

#import <UIKit/UIKit.h>

@interface WPResumeUserModel : NSObject

/** 是否被选中 */
@property (nonatomic, assign) BOOL itemIsSelected;

/** 求职者ID */
@property (nonatomic, copy) NSString *resumeUserId;

/** 创建人ID */
@property (nonatomic, copy) NSString *userId;

/** 头像 */
@property (nonatomic, copy) NSString *avatar;

/** 昵称 求职名称 */
@property (nonatomic, copy) NSString *name;

/** 性别 */
@property (nonatomic, copy) NSString *sex;

/** 年龄 */
@property (nonatomic, copy) NSString *age;

/** 学历 */
@property (nonatomic, copy) NSString *education;

/** 工作时间 */
@property (nonatomic, copy) NSString *worktime;

@property (nonatomic ,copy) NSString *resume_id;
@end


@interface WPResumeUserListModel : NSObject

/** 求职者列表 */
@property (nonatomic, strong) NSArray *resumeList;


@property (nonatomic, copy) NSString *info;

@property (nonatomic, copy) NSString *status;

@end


