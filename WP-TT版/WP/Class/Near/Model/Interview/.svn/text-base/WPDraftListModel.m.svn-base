//
//  WPDraftListModel.m
//  WP
//
//  Created by CBCCBC on 15/12/10.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPDraftListModel.h"

@implementation WPDraftListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [WPDraftListContentModel class],
             @"draftList" : [WPDraftListContentModel class]};
}

@end

@implementation WPDraftListContentModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"resumeUserId":@"resume_user_id",
             @"resumeId":@"resume_id"};
}

@end


