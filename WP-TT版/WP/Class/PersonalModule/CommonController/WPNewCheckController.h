//
//  WPNewCheckController.h
//  WP
//
//  Created by CBCCBC on 16/2/2.
//  Copyright © 2016年 WP. All rights reserved.
//  个人---> 我的求职 --> 我发布的职位 ---> 查看
//  个人 --> 我的招聘 --> 我发布的招聘 ---> 查看
#import "BaseViewController.h"
#import "WPNewResumeController.h"
#import "WPNewResumeModel.h"

typedef NS_ENUM(NSInteger, WPNewCheckListType) {
    WPNewCheckListTypeApply = 3,
    WPNewCheckListTypeMessage = 2,
    WPNewCheckListTypeShare = 1,
    WPNewCheckListTypeBrowse = 0,
};

@interface WPNewCheckController : BaseViewController

@property (assign, nonatomic) WPMainPositionType type;
@property (assign, nonatomic) WPNewCheckListType listType;
@property (copy, nonatomic) NSString *resumeId;
@property (assign, nonatomic)int isRecuilist;
@property (nonatomic ,strong)WPNewResumeListModel *model;
@property (nonatomic, copy)NSString * subId;
@property (nonatomic, assign)BOOL listFix;
@property (nonatomic, assign)BOOL isFromMianShiMessage; //从面试的消息中来
@property (nonatomic, copy) NSString *scrollerID;
@property (nonatomic, copy) NSString *replayPerson;
@property (copy, nonatomic) NSString *replyUserId;
@property (copy, nonatomic) NSString *replyCommentId;
@property (nonatomic, assign) BOOL isHideBottom;
@property (nonatomic, assign) BOOL isFromQiuzhi;
@property (nonatomic, strong) NSIndexPath*choiseIndex;
@property (nonatomic, copy) void(^deleteSucvcess)(NSIndexPath*index);
@property (nonatomic, copy) void(^upAndDownSuccess)();
@property (nonatomic, copy) void(^companyClick)();
@property (nonatomic, copy) void(^clickSuccess)(NSIndexPath*index);

@end
