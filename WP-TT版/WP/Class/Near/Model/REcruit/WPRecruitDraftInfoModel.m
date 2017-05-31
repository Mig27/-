//
//  WPRecruitDraftInfoModel.m
//  WP
//
//  Created by CBCCBC on 15/12/9.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPRecruitDraftInfoModel.h"

@implementation WPRecruitDraftInfoModel

+ (NSDictionary *)objectClassInArray{
    return @{@"videoList" : [Dvlist class], @"photoList" : [Pohotolist class],@"epRemarkList":[WPRecruitDraftInfoRemarkModel class]};
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"jobId":@"job_id",
             @"epId":@"ep_id",
             @"userId":@"user_id",
             @"QRCode":@"QR_code",
             @"enterpriseName":@"enterprise_name",
             @"dataIndustryId":@"dataIndustry_id",
             @"enterpriseProperties":@"enterprise_properties",
             @"enterpriseScale":@"enterprise_scale",
             @"enterpriseAddressID":@"enterprise_addressID",
             @"enterpriseAddress":@"enterprise_address",
             @"enterprisePersonName":@"enterprise_personName",
             @"enterprisePersonTel":@"enterprise_personTel",
             @"enterpriseBrief":@"enterprise_brief",
             @"enterprisePhone":@"enterprise_phone",
             @"enterpriseQQ":@"enterprise_qq",
             @"enterpriseEmail":@"enterprise_email",
             @"enterpriseWebchat":@"enterprise_webchat",
             @"enterpriseWebsite":@"enterprise_website",
             @"enterpriseDewtailAddress":@"enterprise_ads",
             @"":@"",
             @"":@"",
             @"":@"",
             
             };
}

@end