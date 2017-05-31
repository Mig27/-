//
//  WPResumDraftModel.m
//  WP
//
//  Created by Kokia on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPResumDraftListModel.h"
#import "WPResumeUserInfoModel.h"


@implementation WPResumDraftModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"resumeId" : @"resume_id",
             @"nickName" : @"nick_name",
             @"updateTime" : @"update_Time",
             @"resumeUserId" : @"resume_user_id"
             };
}


@end


@implementation WPResumDraftListModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"draftList" : @"WPResumDraftModel"
             };
}


@end