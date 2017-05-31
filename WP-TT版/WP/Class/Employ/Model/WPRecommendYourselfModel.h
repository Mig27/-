//
//  WPRecommendYourselfModel.h
//  WP
//
//  Created by CBCCBC on 15/11/19.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface WPRecommendYourselfModel : BaseModel

@property (copy, nonatomic) NSArray *list;

@end

@interface WPRecommendYourselfListModel : BaseModel

@property (copy, nonatomic) NSString *avatar;/**< 头像 */
@property (copy, nonatomic) NSString *distanceTime;/**< 时间 */
@property (copy, nonatomic) NSString *sid;/**< 职位ID */
@property (copy, nonatomic) NSString *hopeSalary;/**< 期望薪资 */
@property (copy, nonatomic) NSString *userId;/**< 用户ID */
@property (copy, nonatomic) NSString *HopePosition;/**< 期望职位 */
@property (copy, nonatomic) NSString *cityName;/**< 城市名称 */
@property (copy, nonatomic) NSString *sex;/**< 性别 */
@property (copy, nonatomic) NSString *age;/**< 年龄 */
@property (copy, nonatomic) NSString *education;/**< 学历 */
@property (copy, nonatomic) NSString *WorkTime;/**< 工作年限 */
@property (copy, nonatomic) NSString *name;/**< 名称 */
@property (assign, nonatomic) BOOL isSelected;

@end