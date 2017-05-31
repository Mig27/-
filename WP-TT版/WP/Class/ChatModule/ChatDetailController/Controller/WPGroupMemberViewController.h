//
//  WPGroupMemberViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/5/7.
//  Copyright © 2016年 WP. All rights reserved.
//  消息 --> 列表 --> 右上角 --> 群资料 --> 群成员

#import "BaseViewController.h"
#import "GroupInformationModel.h"
#import "ChattingModule.h"
@interface WPGroupMemberViewController : BaseViewController

@property (nonatomic, strong) GroupInformationListModel *model;
@property (nonatomic, assign) BOOL isOwner;
@property (nonatomic, copy) NSString * numOfMemeber;
@property (nonatomic, copy)NSString* deleteGroupId;//要移除成员的组id
@property (nonatomic, strong)ChattingModule*mouble;
@end
