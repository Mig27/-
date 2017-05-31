//
//  WPResumeController.h
//  WP
//
//  Created by CBCCBC on 15/11/30.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "WPNewResumeModel.h"
#import "WPResumeAndInviteDetailModel.h"
typedef NS_ENUM(NSInteger, WPResumeCheckUserInfoType) {
    WPResumeCheckUserInfoTypeIcon = 10,/**< 头像 */
    WPResumeCheckUserInfoTypeTitle = 11,/**< 标题 */
    WPResumeCheckUserInfoTypeContent = 12,/**< 内容 */
    WPResumeCheckUserInfoTypeTime = 13,/**< 时间 */
    WPResumeCheckUserInfoTypeApplyTitle = 14,/**< 报名标题 */
    WPResumeCheckUserInfoTypeMessageTitle = 15,/**< 留言标题 */
    WPResumeCheckUserInfoTypeGlanceTitle = 16,/**< 浏览标题 */
    WPResumeCheckUserInfoTypeIndicater = 17,/**< 报名按钮 */
    WPResumeCheckUserInfoTypeApplyAction = 18,/**< 报名按钮 */
    WPResumeCheckUserInfoTypeShare = 19, // 分享
};

typedef NS_ENUM(NSInteger, DataType) {
    WPResumeCheckBrowseType = 1,// 浏览
    WPResumeCheckShareType,     // 分享
    WPResumeCheckMessageType    // 留言
};

@interface WPResumeCheckController : BaseViewController

@property (copy, nonatomic) NSString *resumeId;
@property (assign, nonatomic) int isRecruit;
@property (nonatomic, assign) BOOL isApply;
@property (nonatomic ,strong)WPNewResumeListModel *model;
@property (nonatomic ,strong)WPResumeAndInviteDetailModel *detailModel;
@property (nonatomic,assign)BOOL isComeFromDynamic;
@property (nonatomic,copy)NSString * userId;
@property (nonatomic, assign) BOOL isFromShuoShuo;
@property (nonatomic, assign)BOOL listFix;
@property (nonatomic, copy)NSString * scrollerID;
@property (nonatomic, assign) BOOL isFromMianShiMessage;
@property (nonatomic, assign) DataType currentType;
@property (copy, nonatomic) NSString *replyCommentId;
@property (copy, nonatomic) NSString *replyUserId;
@property (nonatomic, copy) NSString *replayName;
@end

