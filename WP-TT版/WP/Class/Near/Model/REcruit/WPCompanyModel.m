//
//  WPCompanyModel.m
//  WP
//
//  Created by CBCCBC on 15/10/13.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPCompanyModel.h"

@implementation WPCompanyModel

+ (NSDictionary *)objectClassInArray{
    return @{@"companyList" : [WPCompanyListDetailModel class],
             @"draftList" : [WPCompanyListDetailModel class]};
}
@end

@implementation WPCompanyListDetailModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"jobId":@"job_id",
             @"epId":@"ep_id",
             @"enterpriseName":@"enterprise_name",
             @"QRCode":@"QR_code",
             @"enterpriseProperties":@"enterprise_properties",
             @"enterpriseScale":@"enterprise_scale",
             @"jobPositon":@"jobPositon"
             };
}

@end

