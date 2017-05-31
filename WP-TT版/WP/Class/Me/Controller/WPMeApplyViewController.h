//
//  WPMeApplyViewController.h
//  WP
//
//  Created by CBCCBC on 16/1/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseModel.h"

typedef NS_ENUM(NSInteger, WPMeApplyViewControllerType) {
    WPMeApplyViewControllerTypeRecruit,
    WPMeApplyViewControllerTypeInterview,
};

@class WPMeGrablistModel;
@interface WPMeApplyViewController : BaseViewController

@property (nonatomic, assign) WPMeApplyViewControllerType type;

@end

@interface WPMeApplyModel : BaseModel

@property (nonatomic, copy) NSString *status;/**< 返回状态 */
@property (nonatomic, copy) NSString *info;/**< 返回信息 */
@property (nonatomic, copy) NSString *pageIndex;/**< 页数 */
@property (nonatomic, strong) NSArray<WPMeGrablistModel *> *grabList;/**< 数组 */

@end

@interface WPMeGrablistModel : NSObject

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *signId;/**< 报名ID */
@property (nonatomic, copy) NSString *sign_time;/**< 报名时间 */
@property (nonatomic, copy) NSString *postion;/**< 职位 */
@property (nonatomic, copy) NSString *name;/**< 求职人名称 */
@property (nonatomic, copy) NSString * resume_userID;//简历人id

//招聘
@property (nonatomic, copy) NSString *avatar;/**< 头像 */
@property (nonatomic, copy) NSString *age;/**< 年龄 */
@property (nonatomic, copy) NSString *education;/**< 学历 */
@property (nonatomic, copy) NSString *workTime;/**< 工作年限 */
@property (nonatomic, copy) NSString *sex;/**< 性别 */
@property (nonatomic, copy) NSString *resume_id;/**< 报名的简历ID */

//求职
@property (nonatomic, copy) NSString *invitejob_id;/**< 招聘ID */
@property (nonatomic, copy) NSString *logo;/**< LOGO */

@end

