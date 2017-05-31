//
//  WPResumeUserInfoModel.h
//  WP
//
//  Created by Kokia on 16/3/23.
//  Copyright © 2016年 WP. All rights reserved.
//

// My

// WPRecruitApplyChooseDetailModel
// 求职人，详情

#import "BaseModel.h"



#pragma mark - 个人亮点的描述
@interface WPPathModel : BaseModel
/** 类型 图片还是文字 图片用"img" 文字用"txt"*/
@property (nonatomic, copy) NSString *types;
/** 内容 具体的描述或者是图片的路径*/
@property (nonatomic, copy) NSString *txtcontent;

@end

#pragma mark - 照片 视频
@interface PhotoVideo : BaseModel

/** 缩略图地址 首屏截图*/
@property (nonatomic, copy) NSString *thumb_path;
/** 正常图地址  视频地址*/
@property (nonatomic, copy) NSString *original_path;

@end

#pragma mark - 视频
@interface Video : BaseModel

/** 首屏截图 */
@property (nonatomic, copy) NSString *thumb_path;
/** 视频地址 */
@property (nonatomic, copy) NSString *original_path;

@end



#pragma mark - 教育经历

@interface Education : BaseModel

@property (nonatomic, assign) BOOL isSelected;  // 是否选中

/** 教育ID */
@property (nonatomic, copy) NSString *educationId;
/** 入学时间 */
@property (nonatomic, copy) NSString *beginTime;
/** 毕业时间 */
@property (nonatomic, copy) NSString *endTime;
/** 学校名称 */
@property (nonatomic, copy) NSString *schoolName;
/** 专业 */
@property (nonatomic, copy) NSString *major;
/**专业ID*/
@property (nonatomic, copy) NSString * major_id;
/** 学历 */
@property (nonatomic, copy) NSString *education;
/** 备注 */
@property (nonatomic, copy) NSString *remark;

/** 教育经历介绍 描述列表 */
//@property (nonatomic, strong) NSArray *expList;

@property (nonatomic , copy)NSString * educationStr;//描述

@property (nonatomic, strong) NSArray<WPPathModel *> *expList;

@end


#pragma mark - 工作经历

@interface Work : BaseModel

@property (nonatomic, assign) BOOL isSelected; // 是否选中

/** 工作ID */
@property (nonatomic, copy) NSString *workId;
/** 入职时间 */
@property (nonatomic, copy) NSString *beginTime;
/** 离职时间 */
@property (nonatomic, copy) NSString *endTime;
/** 公司名称 */
@property (nonatomic, copy) NSString *epName;

/** 公司行业ID */
@property (nonatomic, copy) NSString *industryId;
/** 公司行业 */
@property (nonatomic, copy) NSString *industry;
/** 公司性质 */
@property (nonatomic, copy) NSString *epProperties;
/** 部门 */
@property (nonatomic, copy) NSString *department;
/** 职位 */
@property (nonatomic, copy) NSString *position;
/** 职位ID */
@property (nonatomic, copy) NSString *positionId;
/** 薪资 */
@property (nonatomic, copy) NSString *salary;
/** 职位描述*/
@property (nonatomic, copy) NSString *workStr;

/** 备注*/
@property (nonatomic, copy) NSString *remark;

/** 描述列表 */
//@property (nonatomic, strong) NSArray *expList;

@property (nonatomic, strong) NSArray<WPPathModel *> *expList;


@end






@interface WPResumeUserInfoModel : BaseModel

@property (nonatomic ,assign)BOOL itemIsSelected;
/** 简历的用户ID 求职者ID*/
@property (nonatomic, copy) NSString *resumeUserId;
/** 姓名 */
@property (nonatomic, copy) NSString *name;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 生日 */
@property (nonatomic, copy) NSString *birthday;
/** 学历 */
@property (nonatomic, copy) NSString *education;
/** 工作年限 */
@property (nonatomic, copy) NSString *workTime;
/** 户籍 */
@property (nonatomic, copy) NSString *homeTown;
/** 户籍ID */
@property (nonatomic, copy) NSString *homeTownId;
/**< 现居住地 */
@property (nonatomic, copy) NSString *address;
/** 现居住地ID */
@property (nonatomic, copy) NSString *addressId;
/** 电话 */
@property (nonatomic, copy) NSString *tel;

/** 个人亮点 */
@property (nonatomic, copy) NSString *lightspot;
//个人亮点描述
@property (nonatomic, copy)NSString *lightspotList;
/** 目前薪资 */
@property (nonatomic, copy) NSString *nowSalary;
/** 婚姻状况 */
@property (nonatomic, copy) NSString *marriage;
/** 微信 */
@property (nonatomic, copy) NSString *webchat;
/** QQ */
@property (nonatomic, copy) NSString *qq;
/** 邮箱 */
@property (nonatomic, copy) NSString *email;

/** 返回信息 */
@property (nonatomic, copy) NSString *info;
/** 返回状态 */
@property (nonatomic, copy) NSString *status;
/**< 简历id */
@property (nonatomic, copy) NSString *resume_id;
/**< 职位 */
@property (nonatomic, copy) NSString *postion;
/** 手机号码是否显示 0 显示 1 不显示 */
@property (nonatomic, copy)NSString * TelIsShow;
//是否在求职者中
@property (nonnull ,copy) NSString * is_user;




/** 个人亮点列表*/
//@property (nonatomic, strong) NSArray *lightspotList;
///** 照片列表 */
//@property (nonatomic, strong) NSArray *photoList;
///** 视频列表 */
//@property (nonatomic, strong) NSArray *videoList;
///** 教育经历 */
//@property (nonatomic, strong) NSArray *educationList;
///**< 工作经历 */
//@property (nonatomic, strong) NSArray *workList;

@property (nonatomic ,strong) NSString *avatar;

//@property (nonatomic, strong) NSArray<WPPathModel *> *lightspotList;
@property (nonatomic, strong) NSArray<PhotoVideo *> *photoList;
@property (nonatomic, strong) NSArray<PhotoVideo *> *videoList;
@property (nonatomic, strong) NSArray<Education *> *educationList;
@property (nonatomic, strong) NSArray<Work *> *workList;



// 过时的

/** 期望职位 */
@property (nonatomic, copy) NSString *Hope_Position;//hopePosition
/** 期望薪资 */
@property (nonatomic, copy) NSString *Hope_salary;//hopeSalary
/** 期望地区 */
@property (nonatomic, copy) NSString *Hope_address;//hopeAddress
/** 期望福利 */
@property (nonatomic, copy) NSString *Hope_welfare;

@property (nonatomic, copy) NSString *hopePositionNo;/**< 期望职位ID */
@property (nonatomic, copy) NSString *hopeAddressID;/**< 期望地区ID */



@property (nonatomic, copy) NSString *draftCount;/**< 草稿数量 */
@property (nonatomic, copy) NSString *resumeId;/**< 简历ID */

@property (nonatomic, copy) NSString *resumeCount;/**< 简历数量 */



@end

@interface WPResumeUserInfoListModel : BaseModel

/** 求职者列表 */
@property (nonatomic, strong) NSArray *resumeList;


@property (nonatomic, copy) NSString *info;

@property (nonatomic, copy) NSString *status;

@end
