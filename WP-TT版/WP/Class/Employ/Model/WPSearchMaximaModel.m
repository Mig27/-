//
//  WPSearchMaximaModel.m
//  WP
//
//  Created by CBCCBC on 15/11/19.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPSearchMaximaModel.h"

@implementation WPSearchMaximaModel

+(NSDictionary *)objectClassInArray{
    return @{@"list":@"WPSearchMaximaListModel"};
}

@end

@implementation WPSearchMaximaListModel

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"distanceTime":@"DistanceTime",
             @"userId":@"user_id",
             @"sid":@"id"};
}

@end