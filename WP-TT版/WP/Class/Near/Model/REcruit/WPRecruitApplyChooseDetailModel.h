//
//  WPRecruitApplyChooseDetailModel.h
//  WP
//
//  Created by CBCCBC on 15/11/9.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseModel.h"

@interface WPRecruitApplyChooseDetailModel : BaseModel

@property (nonatomic, copy) NSString *education;/**< 学历 */
@property (nonatomic, copy) NSString *lightspot;/**< 个人亮点 */
@property (nonatomic, copy) NSString *birthday;/**< 生日 */
@property (nonatomic, copy) NSString *webchat;/**< 微信 */
@property (nonatomic, copy) NSString *draftCount;/**< 草稿数量 */
@property (nonatomic, copy) NSString *resumeId;/**< 简历ID */
@property (nonatomic, copy) NSString *workTime;/**< 工作年限 */
@property (nonatomic, copy) NSString *sex;/**< 性别 */
@property (nonatomic, copy) NSString *tel;/**< 电话 */
@property (nonatomic, copy) NSString *resumeCount;/**< 简历数量 */
@property (nonatomic, copy) NSString *status;/**< 返回状态 */
@property (nonatomic, copy) NSString *nowSalary;/**< 目前薪资 */
@property (nonatomic, copy) NSString *HopeSalary;/**< 期望薪资 */
@property (nonatomic, copy) NSString *HopeAddress;/**< 期望地区 */
@property (nonatomic, copy) NSString *name;/**< 姓名 */
@property (nonatomic, copy) NSString *info;/**< 返回信息 */
@property (nonatomic, copy) NSString *homeTownId;/**< 户籍ID */
@property (nonatomic, copy) NSString *resumeUserId;/**< 简历的用户ID */
@property (nonatomic, copy) NSString *hopePositionNo;/**< 期望职位ID */
@property (nonatomic, copy) NSString *email;/**< 邮箱 */
@property (nonatomic, copy) NSString *hopeAddressID;/**< 期望地区ID */
@property (nonatomic, copy) NSString *marriage;/**< 婚姻状况 */
@property (nonatomic, copy) NSString *homeTown;/**< 户籍 */
@property (nonatomic, copy) NSString *qq;/**< QQ */
@property (nonatomic, copy) NSString *addressId;/**< 现居住地ID */
@property (nonatomic, copy) NSString *hopePosition;/**< 期望职位 */
@property (nonatomic, copy) NSString *address;/**< 现居住地 */
@property (nonatomic, copy) NSString *hopeWelfare;/**< 期望福利 */
@property (nonatomic, strong) NSArray<Pohotolist *> *photoList;/**< 照片 */
@property (nonatomic, strong) NSArray<Dvlist *> *videoList;/**< 视频 */
@property (nonatomic, strong) NSArray<Worklist *> *workList;/**< 工作经历 */
@property (nonatomic, strong) NSArray<Educationlist *> *educationList;/**< 教育经历 */
@property (nonatomic, strong) NSArray<WPRemarkModel *> *lightspotList;/**< 教育经历 */

//@property (nonatomic, copy) NSString *education;
//@property (nonatomic, copy) NSString *workexperience;
//@property (nonatomic, copy) NSString *birthday;
//@property (nonatomic, copy) NSString *webchat;
//@property (nonatomic, copy) NSString *status;
//@property (nonatomic, copy) NSString *resume_id;
//@property (nonatomic, copy) NSString *Tel;
//@property (nonatomic, copy) NSString *sex;
//@property (nonatomic, copy) NSString *WorkTime;
//@property (nonatomic, copy) NSString *nowSalary;
//@property (nonatomic, copy) NSString *Hope_salary;
//@property (nonatomic, copy) NSString *Hope_address;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *info;
//@property (nonatomic, copy) NSString *cardType;
//@property (nonatomic, copy) NSString *nowSalaryType;
//@property (nonatomic, copy) NSString *email;
//@property (nonatomic, copy) NSString *Hope_PositionNo;
//@property (nonatomic, copy) NSString *Hope_addressID;
//@property (nonatomic, copy) NSString *marriage;
//@property (nonatomic, copy) NSString *cardNo;
//@property (nonatomic, strong) NSArray<Pohotolist *> *Photo;
//@property (nonatomic, strong) NSArray<Dvlist *> *Video;
//@property (nonatomic, copy) NSString *qq;
//@property (nonatomic, copy) NSString *Address_id;
//@property (nonatomic, copy) NSString *Hope_Position;
//@property (nonatomic, copy) NSString *Hope_welfare;
//@property (nonatomic, copy) NSString *address;

@end
