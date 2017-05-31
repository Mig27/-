//
//  WPPersonListModel.m
//  WP
//
//  Created by CBCCBC on 16/3/30.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPPersonListModel.h"

@implementation WPPersonListModel
+ (NSDictionary *)objectClassInArray{
    return @{@"resumeList" : [WPPersonModel class]};
}
@end

@implementation WPPersonModel
+ (NSDictionary *)objectClassInArray{
    return @{@"PhotoList" : [Photos class],
             @"VideoList":[Videos class]};
}
@end
 
@implementation Photos

@end

@implementation Videos

@end
