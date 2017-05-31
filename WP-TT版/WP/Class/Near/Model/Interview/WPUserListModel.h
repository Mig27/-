//
//  WPUserListModel.h
//  WP
//
//  Created by CBCCBC on 15/10/21.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseModel.h"
#import "WPCompanyListModel.h"

@class Worklist,Educationlist;
@interface WPUserListModel : BaseModel

@property (nonatomic, copy) NSString *resumeUserId;/**< 求职者ID */
@property (nonatomic, copy) NSString *name;/**< 姓名 */
@property (nonatomic, copy) NSString *sex;/**< 性别 */
@property (nonatomic, copy) NSString *birthday;/**< 生日 */
@property (nonatomic, copy) NSString *education;/**< 学历 */
@property (nonatomic, copy) NSString *workTime;/**< 工作时间 */
@property (nonatomic, copy) NSString *homeTown;/**< 籍贯 */
@property (nonatomic, copy) NSString *homeTownId;/**< 籍贯ID */
@property (nonatomic, copy) NSString *addressId;/**< 地址ID */
@property (nonatomic, copy) NSString *address;/**< 地址 */
@property (nonatomic, copy) NSString *tel;/**< 联系电话 */
@property (nonatomic, copy) NSString *lightspot;/**< 个人亮点 */
@property (nonatomic, copy) NSString *nowSalary;/**< 目前工资 */
@property (nonatomic, copy) NSString *marriage;/**< 婚姻状况 */
@property (nonatomic, copy) NSString *webchat;/**< 微信 */
@property (nonatomic, copy) NSString *qq;/**< QQ */
@property (nonatomic, copy) NSString *email;/**< 邮箱 */
@property (nonatomic, strong) NSArray<Educationlist *> *educationList;/**< 教育经历 */
@property (nonatomic, strong) NSArray<Worklist *> *workList;/**< 工作经历 */
@property (nonatomic, strong) NSArray<Pohotolist *> *photoList;/**< 照片 */
@property (nonatomic, strong) NSArray <Dvlist *> *videoList;/**< 视频 */

@property (nonatomic, strong) NSArray<WPRecruitDraftInfoRemarkModel *> *lightspotList;/**< 个人亮点 */

@property (nonatomic, copy) NSString *info;/**< 返回信息 */
@property (nonatomic, assign) BOOL status;/**< 返回状态 */

//@property (nonatomic, strong) NSArray<Pohotolist *> *PhotoList;/**< 照片 */
//@property (nonatomic, strong) NSArray<Dvlist *> *VideoList;/**< 视频 */
//@property (nonatomic, copy) NSString *name;/**< 姓名 */
//@property (nonatomic, copy) NSString *sex;/**< 性别 */
//@property (nonatomic, copy) NSString *cardType;/**< 证件类型 */
//@property (nonatomic, copy) NSString *cardNo;/**< 证件号码 */
//@property (nonatomic, copy) NSString *age;/**< 年龄 */
//@property (nonatomic, copy) NSString *birthday;/**< 生日 */
//@property (nonatomic, copy) NSString *Tel;/**< 联系方式 */
//@property (nonatomic, copy) NSString *webchat;/**< 微信 */
//@property (nonatomic, copy) NSString *qq;/**< QQ */
//@property (nonatomic, copy) NSString *email;/**< 邮箱 */
//@property (nonatomic, copy) NSString *Position;/**< 职位 */
//@property (nonatomic, copy) NSString *PositionNo;/**< 职位ID */
//@property (nonatomic, copy) NSString *industry;/**< 职位 */
//@property (nonatomic, copy) NSString *industryNo;/**< 职位 */
//@property (nonatomic, copy) NSString *companyName;/**< 公司名称 */
//@property (nonatomic, copy) NSString *nowSalaryType;/**< 薪资类型 */
//@property (nonatomic, copy) NSString *nowSalary;/**< 目前薪资 */
//@property (nonatomic, copy) NSString *education;/**< 学历 */
//@property (nonatomic, copy) NSString *WorkTime;/**< 工作年限 */
//@property (nonatomic, copy) NSString *marriage;/**< 婚姻状况 */
//@property (nonatomic, copy) NSString *address;/**< 现居住地 */
//@property (nonatomic, copy) NSString *Address_id;/**< 现居住地ID */
//@property (nonatomic, copy) NSString *workexperience;/**< 工作经历 */
//@property (nonatomic, copy) NSString *sid;/**< 用户信息ID */
//@property (nonatomic, copy) NSString *status;/**< 返回状态 */
//@property (nonatomic, copy) NSString *user_avatar;/**< 用户头像 */
//
////再次修改增加的字段
//@property (nonatomic, copy) NSString *lightspot;/**< 个人亮点 */
//@property (nonatomic, copy) NSString *homeTown;/**< 户籍 */
//@property (nonatomic, copy) NSString *homeTown_id;/**< 户籍Id */
//@property (nonatomic, assign) BOOL userIsSelected;/**< 用户是否被选中 */

@end
