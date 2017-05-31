//
//  WPResumeUserListModel.m
//  WP
//
//  Created by Kokia on 16/3/23.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPResumeUserListModel.h"


@implementation WPResumeUserModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"resumeUserId" : @"resume_user_id",
             @"userId" : @"user_id",
             @"updateTime" : @"update_Time",
             @"worktime" : @"WorkTime"
             };
}


@end


@implementation WPResumeUserListModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"resumeList" : @"WPResumeUserModel"
             };
}

@end
