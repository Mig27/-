//
//  BaseModel.m
//  BoYue
//
//  Created by Leejay on 14/12/18.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

@end

@implementation Dvlist

@end


@implementation Pohotolist

@end

@implementation Worklist

+ (NSDictionary *)objectClassInArray{
    return @{@"expList":[WPRemarkModel class]};
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"workId":@"work_id",
             @"industryId":@"Industry_id",
             @"epProperties":@"ep_properties",
             @"positionId":@"position_id"};
}

@end


@implementation Educationlist

+ (NSDictionary *)objectClassInArray{
    return @{@"expList":[WPRemarkModel class]};
}

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"educationId":@"education_id"};
}

@end

@implementation WPRemarkModel

@end