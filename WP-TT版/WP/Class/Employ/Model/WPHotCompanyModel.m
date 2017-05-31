//
//  WPHotCompanyModel.m
//  WP
//
//  Created by CBCCBC on 15/11/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPHotCompanyModel.h"

@implementation WPHotCompanyModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list":@"WPHotCompanyListModel"};
}

@end

@implementation WPHotCompanyListModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"enterpriseName":@"enterprise_name",
             @"sid":@"companyId",
             @"userId":@"user_id"};
}

@end