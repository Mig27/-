//
//  BaseModel.h
//  BoYue
//
//  Created by Leejay on 14/12/18.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface BaseModel : NSObject


@end

@interface Dvlist : NSObject

@property (nonatomic, copy) NSString *thumb_path;/**< 缩略图地址 */
@property (nonatomic, copy) NSString *original_path;/**< 正常图地址 */

@end

@interface Pohotolist : NSObject
@property (nonatomic, copy) NSString *thumb_path;/**< 缩略图地址 */
@property (nonatomic, copy) NSString *original_path;/**< 正常图地址 */

@end

@class WPRemarkModel;
@interface Worklist : NSObject

@property (nonatomic, copy) NSString *industry;/**< 公司行业 */
@property (nonatomic, copy) NSString *position;/**< 职位 */
@property (nonatomic, copy) NSString *epProperties;/**< 公司性质 */
@property (nonatomic, copy) NSString *salary;/**< 薪资 */
@property (nonatomic, copy) NSString *epName;/**< 公司名称 */
@property (nonatomic, copy) NSString *endTime;/**< 离职时间 */
@property (nonatomic, copy) NSString *workId;/**< 工作ID */
@property (nonatomic, copy) NSString *industryId;/**< 公司行业ID */
@property (nonatomic, copy) NSString *remark;/**< 母鸡 */
@property (nonatomic, copy) NSString *beginTime;/**< 入职时间 */
@property (nonatomic, copy) NSString *department;/**< 部门 */
@property (nonatomic, copy) NSString *positionId;/**< 职位ID */
@property (nonatomic, strong) NSArray<WPRemarkModel *> *expList;/**< 工作经历介绍 */

@end

@class WPRemarkModel;
@interface Educationlist : NSObject

@property (nonatomic, copy) NSString *remark;/**< 母鸡 */
@property (nonatomic, copy) NSString *major;/**< 专业 */
@property (nonatomic, copy) NSString *beginTime;/**< 入学时间 */
@property (nonatomic, copy) NSString *educationId;/**< 教育ID */
@property (nonatomic, copy) NSString *endTime;/**< 毕业时间 */
@property (nonatomic, copy) NSString *schoolName;/**< 学校名称 */
@property (nonatomic, copy) NSString *education;/**< 学历 */
@property (nonatomic, copy) NSString *educationStr;//专业描述
@property (nonatomic, strong) NSArray<WPRemarkModel *> *expList;/**< 教育经历介绍 */

@end

@interface WPRemarkModel : NSObject

@property (nonatomic, copy) NSString *types;/**< 类型 */
@property (nonatomic, copy) NSString *txtcontent;/**< 内容 */

@end
