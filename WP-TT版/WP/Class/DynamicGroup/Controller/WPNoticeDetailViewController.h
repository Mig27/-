//
//  WPNoticeDetailViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/5/11.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupNoticeModel.h"
#import "GroupInformationModel.h"
#import "ChattingModule.h"
@interface WPNoticeDetailViewController : BaseViewController

@property (nonatomic, strong) GroupNoticeListModel *model;
@property (nonatomic, strong) GroupInformationListModel *infoModel;
@property (nonatomic, strong) NSString *gtype;
@property (nonatomic, strong) NSIndexPath *clickIndex;
@property (nonatomic, copy) void (^deletActionBlock)(NSIndexPath *index);
@property (nonatomic, copy) void (^changeNotice)(NSIndexPath*index);
@property (nonatomic, copy)NSString * noticeId;
@property (nonatomic, copy)NSString * groupID;
@property (nonatomic, strong) ChattingModule * mouble;

@end
