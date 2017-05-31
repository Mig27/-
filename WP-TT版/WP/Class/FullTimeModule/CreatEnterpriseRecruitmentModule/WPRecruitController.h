//
//  WPRecuilistController.h
//  WP
//
//  Created by CBCCBC on 15/9/29.
//  Copyright (c) 2015年 WP. All rights reserved.
//  创建企业招聘

// 企业招聘简历

#import "BaseViewController.h"
#import "WPCompanyListModel.h"

@class Dvlist,Pohotolist;
@interface SPRecuilistModel : NSObject

@property (copy, nonatomic) NSString *epName;/**< 公司名称 */
@property (copy, nonatomic) NSString *enterprise_scale;/**< 公司规模 */
@property (copy, nonatomic) NSString *enterprise_properties;/**< 公司性质 */
@property (copy, nonatomic) NSString *Industry;/**< 公司行业 */
@property (copy, nonatomic) NSString *enterprise_brief;/**< 公司简介 */
@property (copy, nonatomic) NSString *Industryid;/**< 公司行业ID */
@property (copy, nonatomic) NSString *logo;/**< 公司LOGO */
@property (copy, nonatomic) NSString *background;/**< 公司背景图 */
@property (nonatomic, strong) NSArray<Dvlist *> *dvList;/**< 视频数组 */
@property (nonatomic, strong) NSArray<Pohotolist *> *pohotoList;/**< 照片数组 */
@property (assign, nonatomic) NSInteger epid;/**< 企业ID */
@property (nonatomic, assign) BOOL status;/**< 返回状态 */

@end

@protocol WPRecuilistControllerDelegate <NSObject>

- (void)WPRecuilistControllerDelegate;

@end

@interface WPRecruitController : BaseViewController

@property (assign, nonatomic) BOOL isFirst;/**< 是创建过企业信息 */
@property (strong, nonatomic) WPCompanyListModel *model;/**< 数据Model */
//企业个数
@property(copy,nonatomic)NSString *count;
@property (assign, nonatomic) id <WPRecuilistControllerDelegate> delegate;
@property (assign, nonatomic)int isRecuilist;
@property (assign ,nonatomic) BOOL isBuild;
@property (nonatomic, copy) void(^uploadMyWant)(NSArray*array);
@end
