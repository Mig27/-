//
//  WPNewSchoolResumeModel.h
//  WP
//
//  Created by CBCCBC on 16/1/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"
#import "WPNewResumeController.h"

@class WPNewSearchResumeListModel;
@interface WPNewSearchResumeModel : BaseModel

@property (nonatomic, strong) NSArray<WPNewSearchResumeListModel *> *list;

@end

@interface WPNewSearchResumeListModel : BaseModel

#pragma mark - 共用
@property (copy, nonatomic) NSString *distanceTime;/**< 时间 */
@property (copy, nonatomic) NSString *resumeId;/**< 职位ID */
@property (copy, nonatomic) NSString *userId;/**< 用户ID */
@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) WPMainPositionType type;

#pragma mark - 招聘
@property (copy, nonatomic) NSString *epName;
@property (copy, nonatomic) NSString *jobPositon;
@property (copy, nonatomic) NSString *logo;
@property (copy, nonatomic) NSString *salary;

#pragma mark - 求职
@property (copy, nonatomic) NSString *avatar;/**< 头像 */
@property (copy, nonatomic) NSString *hopeSalary;/**< 期望薪资 */
@property (copy, nonatomic) NSString *HopePosition;/**< 期望职位 */
@property (copy, nonatomic) NSString *cityName;/**< 城市名称 */
@property (copy, nonatomic) NSString *sex;/**< 性别 */
@property (copy, nonatomic) NSString *age;/**< 年龄 */
@property (copy, nonatomic) NSString *education;/**< 学历 */
@property (copy, nonatomic) NSString *WorkTime;/**< 工作年限 */
@property (copy, nonatomic) NSString *name;/**< 名称 */


@end
