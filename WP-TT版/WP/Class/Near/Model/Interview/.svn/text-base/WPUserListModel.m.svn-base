//
//  WPUserListModel.m
//  WP
//
//  Created by CBCCBC on 15/10/21.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPUserListModel.h"

@implementation WPUserListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"photoList" : [Pohotolist class],@"videoList" : [Dvlist class], @"workList" : [Worklist class], @"educationList" : [Educationlist class],@"lightspotList":[WPRecruitDraftInfoRemarkModel class]};
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"resumeUserId":@"resume_user_id",
             @"homeTownId":@"homeTown_id",
             @"addressId":@"Address_id",
             @"workTime":@"WorkTime",
             @"tel":@"Tel",
             @"photoList":@"PhotoList",
             @"videoList":@"VideoList"};
}

@end




