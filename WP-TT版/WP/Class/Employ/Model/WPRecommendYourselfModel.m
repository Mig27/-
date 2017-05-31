//
//  WPRecommendYourselfModel.m
//  WP
//
//  Created by CBCCBC on 15/11/19.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPRecommendYourselfModel.h"

@implementation WPRecommendYourselfModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list":@"WPRecommendYourselfListModel"};
}

@end

@implementation WPRecommendYourselfListModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"distanceTime":@"DistanceTime",
             @"sid":@"id",
             
             @"userId":@"user_id"};
}

@end