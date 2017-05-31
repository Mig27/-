//
//  WPRecruitDraftInfoModel.h
//  WP
//
//  Created by CBCCBC on 15/12/9.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseModel.h"
#import "WPCompanyListModel.h"
#import "WPRecruitDraftInfoRemarkModel.h"

@interface WPRecruitDraftInfoModel : BaseModel

@property (nonatomic, copy) NSString *enterpriseAddressID;/**< 招聘职位ID */
@property (nonatomic, copy) NSString *jobPositon;/**< 招聘职位名称 */
@property (nonatomic, copy) NSString *draftCount;/**< 草稿数量 */
@property (nonatomic, copy) NSString *education;/**< 学历要求 */
@property (nonatomic, copy) NSString *Require;/**< 任职要求 */
@property (nonatomic, copy) NSString *enterpriseQQ;/**< 企业QQ */
@property (nonatomic, copy) NSString *enterpriseEmail;/**< 企业邮箱 */
@property (nonatomic, copy) NSString *enterpriseName;/**< 企业名称 */
@property (nonatomic, copy) NSString *salary;/**< 工资待遇 */
@property (nonatomic, copy) NSString *workAdS;/**< 详细地点 */
@property (nonatomic, copy) NSString *workAddressID;/**< 工作地点ID */
@property (nonatomic, copy) NSString *enterpriseWebsite;/**< 企业官网 */
@property (nonatomic, copy) NSString *QRCode;/**< 企业背景图片 */
@property (nonatomic, copy) NSString *sex;/**< 性别要求 */
@property (nonatomic, copy) NSString *enterprisePersonTel;/**< 企业联系方式 */
@property (nonatomic, copy) NSString *enterpriseWebchat;/**< 企业微信 */
@property (nonatomic, copy) NSString *invitenumbe;/**< 招聘人数 */
@property (nonatomic, copy) NSString *info;/**< 返回说明 */
@property (nonatomic, copy) NSString *enterprisePersonName;/**< 联系人 */
@property (nonatomic, copy) NSString *enterpriseBrief;/**< 公司简介 */
@property (nonatomic, copy) NSString *epRange;/**< 公司福利 */
@property (nonatomic, copy) NSString *longitude;/**< 经度 */
@property (nonatomic, copy) NSString *status;/**< 返回状态 */
@property (nonatomic, copy) NSString *enterpriseAddress;/**< 公司地点 */
@property (nonatomic, copy) NSString *enterpriseDewtailAddress;//公司具体地址
@property (nonatomic, copy) NSString *enterpriseProperties;/**< 公司性质 */
@property (nonatomic, copy) NSString *userId;/**< 用户ID */
@property (nonatomic, copy) NSString *epId;/**< 企业ID */
@property (nonatomic, copy) NSString *dataIndustryId;/**< 公司行业ID */
@property (nonatomic, copy) NSString *jobPositonID;/**< 招聘职位ID */
@property (nonatomic, copy) NSString *age;/**< 年龄要求 */
@property (nonatomic, copy) NSString *workAddress;/**< 工作地点 */
@property (nonatomic, copy) NSString *enterprisePhone;/**< 公司联系方式 */
@property (nonatomic, copy) NSString *jobId;/**< 草稿ID */
@property (nonatomic, copy) NSString *dataIndustry;/**< 公司行业 */
@property (nonatomic, copy) NSString *enterpriseScale;/**< 公司规模 */
@property (nonatomic, copy) NSString *companyCount;/**< 公司数量 */
@property (nonatomic, copy) NSString *workTime;/**< 工作年限 */
@property (nonatomic, copy) NSString *latitude;/**< 纬度 */
@property (nonatomic, copy) NSString *guid_0;
@property (nonatomic, copy) NSString *Tel; /** 手机号码 */
@property (nonatomic, copy) NSString * TelIsShow;   /** 是否显示手机号码 */
@property (nonatomic, strong) NSArray<Pohotolist *> *photoList;/**< 照片 */
@property (nonatomic, strong) NSArray<Dvlist *> *videoList;/**< 视频 */
@property (nonatomic, strong) NSArray<WPRecruitDraftInfoRemarkModel *> *epRemarkList;/**< 公司简介数组 */

@end
