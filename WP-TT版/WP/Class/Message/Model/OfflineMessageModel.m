//
//  OfflineMessageModel.m
//  WP
//
//  Created by 沈亮亮 on 16/1/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "OfflineMessageModel.h"

@implementation OfflineMessageModel

+(NSDictionary *)objectClassInArray
{
    return @{
             @"MsgBegin":@"OfflineMsgModel"
             };
}

@end

@implementation OfflineMsgModel

+(NSDictionary *)objectClassInArray
{
    return @{
             @"MsgList":@"OfflineMsgListModel"
             };
}

@end

@implementation OfflineMsgListModel

@end