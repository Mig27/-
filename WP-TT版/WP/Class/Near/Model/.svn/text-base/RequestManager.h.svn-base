//
//  RequestManager.h
//  WP
//
//  Created by CBCCBC on 16/3/9.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusBlock) (id returnValue);
typedef void (^ErrorBlock) (NSError *error);

@interface RequestManager : NSObject

//@property (nonatomic ,strong)StatusBlock status;
//@property (nonatomic ,strong)ErrorBlock errorblock;

+ (instancetype)shareManager;
/**
 * 该类目前已有功能
 * 一 . 工作  收藏 . 取消收藏
 * 二 . 投递简历 . 取消投递简历
 * 三 . 请求企业信息
 * 四 . 修改企业信息
 * 五 . 获取我的企业
 * 六 .
 * 七 . 确定职位申请状态
 * 八 . 确定求职抢人状态
 * 九 . 
 * 十 .
 */

- (void)getCollectionWithJobid:(NSString *)job_id state:(BOOL)state status:(StatusBlock)status fail:(ErrorBlock)fail;
// 请求 收藏工作 方法 , 参数 : job_id , YES:收藏 NO:取消收藏 , 返回一个json文本,提示请求收藏结果
// 根据提供的 state 的不同提供 收藏 与 取消收藏 的功能

- (void)getInviteJobWithJobid:(NSString *)job_id state:(BOOL)state status:(StatusBlock)status fail:(ErrorBlock)fail;
// 请求 招聘信息 方法 , 参数 : job_id , YES:投递 NO:取消投递 , 返回一个json文本,提示请求结果
// 根据提供的 state 的不同提供 投递 与 取消投递 的功能


- (void)getCompanyInfoWithEpid:(NSString *)ep_id status:(StatusBlock)status fail:(ErrorBlock)fail;
// 请求一个企业信息 , 参数 : ep_id  , 返回一个json文本,获取企业信息


- (void)updateCompanyInfoWithEpid:(NSString *)ep_id Images:(NSArray *)images Params:(NSDictionary *)params status:(StatusBlock)status fail:(ErrorBlock)fail;
// 提交修改一个企业信息 , 参数 : ep_id  , 图片数组 , 其他配置参数 , 返回一个json文本,获取企业信息


- (void)getMyCompanyWithStatus:(StatusBlock)status fail:(ErrorBlock)fail;
// 获取登陆者名下所有的企业信息


- (void)cancelApplicationJobWithJobid:(NSString *)job_id status:(StatusBlock)status fail:(ErrorBlock)fail;
// 取消申请

- (void)cancelApplicationResumeWithResumeid:(NSString *)resume_id status:(StatusBlock)status fail:(ErrorBlock)fail;
// 取消抢人


- (void)getJobSignStatusWithJobid:(NSString *)job_id status:(StatusBlock)status fail:(ErrorBlock)fail;
// 获取  指定job_id  工作岗位 投递状况, 确定 已申请 或 未申请 状态


- (void)getResumeSignStatusWithResumeid:(NSString *)resume_id  status:(StatusBlock)status fail:(ErrorBlock)fail;
// 获取  指定resume_id  求职人员 抢人状况, 确定 已抢人 或 未抢人 状态


- (void)applicationJobWithJobid:(NSString *)job_id lists:(NSDictionary *)lists  status:(StatusBlock)status fail:(ErrorBlock)fail;
// 申请职位  参数需求 job_id  简历list  返回 申请  成功 或 失败 状态




@end
