//
//  RSChatMessageModel.m
//  WP
//
//  Created by 沈亮亮 on 15/12/16.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "RSChatMessageModel.h"

@implementation RSChatMessageModel

+ (instancetype)modelwithName:(NSString *)name avatar:(NSString *)avatar no:(NSInteger)ID_no type:(NotiMessageType)type detail:(NSString *)detail time:(NSString *)time noReadCount:(NSInteger)count loginID:(NSInteger)login_ID timestamp:(NSInteger)timetamp
{
    RSChatMessageModel *model = [[RSChatMessageModel alloc] init];
    model.avatarName = name;
    model.avatarUrl = avatar;
    model.messageID = ID_no;
    model.messageType = type;
    model.messageDetail = detail;
    model.meaageTime = time;
    model.noReadCount = count;
    model.loginID = login_ID;
    model.timestamp = timetamp;
    return model;
}

@end
