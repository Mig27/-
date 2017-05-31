//
//  GroupPhotoAlumModel.m
//  WP
//
//  Created by 沈亮亮 on 16/4/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "GroupPhotoAlumModel.h"

@implementation GroupPhotoAlumModel


+ (NSDictionary *)objectClassInArray
{
    return @{@"list":@"GroupPhotoAlumListModel"};
}

@end

@implementation GroupPhotoAlumListModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"CommentList":@"CommentListModel",
             @"PhotoList" : @"GroupPhotoListModel",
             @"PraiseList" : @"PraiseListModel",
             @"otherList" : @"otherListModel"};
}

@end

@implementation CommentListModel


@end


@implementation GroupPhotoListModel


@end

@implementation PraiseListModel


@end

@implementation otherListModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"comment_id" : @"id"
             };
}

@end

@implementation GroupAlumDetailModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"list":@"GroupPhotoAlumListModel"};
}

@end

@implementation GroupAlumDetailListModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"otherList" : @"otherListModel"
             };
}

@end
