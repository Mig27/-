//
//  WPResumeAndInviteDetailModel.h
//  WP
//
//  Created by 沈亮亮 on 16/6/3.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface WPResumeAndInviteDetailModel : BaseModel

/**
 *  招聘
 */
@property (nonatomic, strong) NSString *jobPositon; /**< 招聘职位 */
@property (nonatomic, strong) NSString *enterprise_name; /**< 公司名称 */
@property (nonatomic, strong) NSString *jobPhoto; /**< 招聘图片 */

/**
 *  求职
 */
@property (nonatomic, strong) NSString *resumePhoto; /**< 求职图片 */
@property (nonatomic, strong) NSString *Hope_Position; /**< 求职标题 */
@property (nonatomic, strong) NSString *sex; /**< 性别 */
@property (nonatomic, strong) NSString *education; /**< 学历 */
@property (nonatomic, strong) NSString *birthday; /**< 年龄 */
@property (nonatomic, strong) NSString *nick_name; /**< 昵称 */
@property (nonatomic, strong) NSString *WorkTime;  /**< 工作时间 */


@end
