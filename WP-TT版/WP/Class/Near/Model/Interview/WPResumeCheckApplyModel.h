//
//  WPResumeCheckApplyModel.h
//  WP
//
//  Created by CBCCBC on 15/12/1.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseModel.h"

@class ApplyCompanyList;
@interface WPResumeCheckApplyModel : BaseModel


@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) NSArray<ApplyCompanyList *> *signList;
@property (nonatomic, strong) NSArray<ApplyCompanyList *> *browseList;
@property (strong, nonatomic) NSArray<ApplyCompanyList *> *list;

@property (nonatomic, copy) NSString *info;/**< 说明 */


@end
@interface ApplyCompanyList : NSObject

#pragma mark - 共用属性
@property (nonatomic, copy) NSString *avatar;/**< 头像 */
@property (nonatomic, copy) NSString *resumeId;/**< 简历ID */
@property (nonatomic, copy) NSString *userId;/**< 用户ID */
@property (nonatomic, copy) NSString *name;/**< 公司名称 */
@property (nonatomic, copy) NSString *addTime;/**< 报名时间 */
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *is_an;   /** 是否是匿名评论 */
#pragma mark - 报名Model属性
@property (nonatomic, copy) NSString *signId;/**< 报名ID */
@property (nonatomic, copy) NSString *signState;/**< 报名状态 */
@property (nonatomic, copy) NSString *jobTitle;/**< 招聘职位 */

#pragma mark - 浏览Model属性
@property (nonatomic, copy) NSString *browseId;/**< 浏览ID */
@property (nonatomic, copy) NSString *company;/**< 公司名称 */
@property (nonatomic, copy) NSString *position;/**< 求职职位 */

#pragma mark - 分享model属性
@property (copy, nonatomic) NSString *shareId;

@end

