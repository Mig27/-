//
//  WPCreateGroupNoticeViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/5/11.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupNoticeModel.h"
#import "GroupInformationModel.h"
#import "ChattingModule.h"
@interface WPCreateGroupNoticeViewController : BaseViewController

@property (nonatomic, strong) GroupNoticeListModel *model;
@property (nonatomic, strong) GroupInformationListModel *infoModel;
@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, copy) void (^createSuccessBlock)();
@property (nonatomic, copy) void (^modifiedSuccessBlock)();
@property (nonatomic, copy) NSString * groupId;
@property (nonatomic, copy) NSString * groupAvatar;
@property (nonatomic, strong)ChattingModule * mouble;
@property (nonatomic, copy)NSString * groupID;


@end
