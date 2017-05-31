//
//  WPGetNewNearByResult.m
//  WP
//
//  Created by CC on 16/6/3.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPGetNewNearByResult.h"

@interface WPNewNearbyPersonModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *industryID;
@property (nonatomic, copy) NSString *positionID;
@property (nonatomic, copy) NSString *fatherID;
@property (nonatomic, copy) NSString *positionName;
@property (nonatomic, copy) NSString *industryName;
@property (nonatomic, copy) NSString *layer;
@property (nonatomic, copy) NSString *recommend;
@property (nonatomic, copy) NSString *address;

@end

@implementation WPGetNewNearByResult

+(NSDictionary *)objectClassInArray
{
    return @{
             @"list":@"WPNewNearbyPersonModel"
             };
}


@end
