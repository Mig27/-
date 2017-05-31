//
//  WPCompanyModel.h
//  WP
//
//  Created by CBCCBC on 15/10/13.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WPCompanyListDetailModel;
@interface WPCompanyModel : NSObject

#pragma 公司
@property (nonatomic, strong) NSArray<WPCompanyListDetailModel *> *companyList;
#pragma 草稿
@property (nonatomic, strong) NSArray<WPCompanyListDetailModel *> *draftList;

@end

@interface WPCompanyListDetailModel : NSObject

@property (nonatomic, assign) BOOL itemIsSelected;
@property (nonatomic, copy) NSString *jobId;;/**< 草稿ID */
@property (nonatomic, copy) NSString *epId;/**< 公司ID */
@property (nonatomic, copy) NSString *enterpriseName;/**< 公司名称 */
@property (nonatomic, copy) NSString *QRCode;/**< 公司背景图片 */
@property (nonatomic, copy) NSString *dataIndustry;/**< 公司行业 */
@property (nonatomic, copy) NSString *enterpriseProperties;/**< 公司性质 */
@property (nonatomic, copy) NSString *enterpriseScale;/**< 公司规模 */
@property (nonatomic, copy) NSString *jobPositon;  /**<  招聘职位 */

@end



