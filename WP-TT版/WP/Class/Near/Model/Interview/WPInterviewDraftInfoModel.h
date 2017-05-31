//
//  WPInterviewDraftInfoModel.h
//  WP
//
//  Created by CBCCBC on 15/12/17.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseModel.h"
#import "WPRecruitDraftInfoRemarkModel.h"

@interface WPInterviewDraftInfoModel : BaseModel

@property (nonatomic, copy) NSString *education;/**< 学历 */
@property (nonatomic, copy) NSString *lightspot;/**< 个人亮点 */
@property (nonatomic, copy) NSString *birthday;/**< 生日 */
@property (nonatomic, copy) NSString *webchat;/**< 微信 */
@property (nonatomic, copy) NSString *draftCount;/**< 草稿数量 */
@property (nonatomic, copy) NSString *resume_id;/**< 简历ID */
@property (nonatomic, copy) NSString *WorkTime;/**< 工作年限 */
@property (nonatomic, copy) NSString *sex;/**< 性别 */
@property (nonatomic, copy) NSString *Tel;/**< 电话 */
@property (nonatomic, copy) NSString * TelIsShow; /** 是否显示电话号码 */
@property (nonatomic, copy) NSString *resumeCount;/**< 简历数 */
@property (nonatomic, copy) NSString *status;/**< 返回状态 */
@property (nonatomic, copy) NSString *nowSalary;/**< 现在工资 */
@property (nonatomic, copy) NSString *Hope_salary;/**< 期望工资 */
@property (nonatomic, copy) NSString *Hope_address;/**< 期望地区 */
@property (nonatomic, copy) NSString *name;/**< 姓名 */
@property (nonatomic, copy) NSString *info;/**< 返回信息 */
@property (nonatomic, copy) NSString *homeTown_id;/**< 户籍ID */
@property (nonatomic, copy) NSString *resume_user_id;/**< 简历用户ID */
@property (nonatomic, copy) NSString *Hope_PositionNo;/**< 期望职位ID */
@property (nonatomic, copy) NSString *email;/**< 邮箱 */
@property (nonatomic, copy) NSString *Hope_addressID;/**< 期望地区ID */
@property (nonatomic, copy) NSString *marriage;/**< 婚姻状况 */
@property (nonatomic, copy) NSString *homeTown;/**< 户籍 */
@property (nonatomic, copy) NSString *qq;/**< qq */
@property (nonatomic, copy) NSString *Address_id;/**< 现居住地 */
@property (nonatomic, copy) NSString *Hope_Position;/**< 期望职位 */
@property (nonatomic, copy) NSString *address;/**< 先居住地 */
@property (nonatomic, copy) NSString *Hope_welfare;/**< 期望福利 */
@property (nonatomic, strong) NSArray<Dvlist *> *videoList;/**< 视频 */
@property (nonatomic, strong) NSArray<Pohotolist *> *photoList;/**< 照片 */
@property (nonatomic, strong) NSArray<Worklist *> *workList;/**< 工作经历 */
@property (nonatomic, strong) NSArray<Educationlist *> *educationList;/**< 教育经历 */
//@property (nonatomic, strong) NSArray<WPRecruitDraftInfoRemarkModel *> *lightspotList;/**< 个人亮点 */
@property (nonatomic, copy) NSString *lightspotList;//亮点描述
@end
