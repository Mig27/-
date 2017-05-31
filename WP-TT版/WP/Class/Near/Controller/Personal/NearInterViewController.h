//
//  NearInterViewController.h
//  WP
//
//  Created by CBCCBC on 15/9/24.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WPNewResumeModel.h"
#import "WPTitleView.h"
@protocol NearInterViewFourButtonDelegate <NSObject>

- (void)delegateActionWithIndex:(NSInteger)index;

@end

@interface NearInterViewFourButton : UIView
@property (nonatomic ,weak)id <NearInterViewFourButtonDelegate> delegate;
@property (nonatomic ,assign)BOOL aplly;
@property (nonatomic ,assign)BOOL collection;
@property (nonatomic ,assign)BOOL isRecuilist;
@end

typedef NS_ENUM(NSInteger, WPInterViewOperationType) {
    WPInterViewOperationTypeChat = 100,
    WPInterViewOperationTypeApply = 101,
    WPInterViewOperationTypecollection = 102,
    WPInterViewOperationTypeCheck = 103,
};

@interface NearInterViewController : BaseViewController
@property (nonatomic ,strong)WPNewResumeListModel *model;
@property (copy, nonatomic) NSString *subId;/**< 请求ID */
@property (assign, nonatomic) BOOL isSelf;/**< 是否是本人 */
@property (assign, nonatomic) int isRecuilist;/**< 是否为招聘：0，求职；1，招聘；2，公司； */
@property (copy, nonatomic) NSString *urlStr;/**< 请求URL */
@property (copy, nonatomic) NSString *userId;
@property (nonatomic, assign) BOOL isComeFromDynamic; /**< 是否来自工作圈的分享 */
@property (nonatomic, copy) NSString * resumeId;//简历id
@property (nonatomic, assign) BOOL isFromCompanyGive;
@property (nonatomic, assign) BOOL isFromChat;
@property (nonatomic, strong) NSDictionary * chatDic;
@property (nonatomic , assign) BOOL personalApply;//个人申请
@property (nonatomic, strong) WPTitleView * titleView;
@property (nonatomic , assign) BOOL isFromMyApply;//我申请的职位
@property (nonatomic , assign) BOOL isFromMyRob;//我抢的人

@property (nonatomic , assign) BOOL isFromCollection;//从收藏中申请

@property (nonatomic , assign) BOOL isFromMuchCollection;//收藏中多个面试招聘

@property (nonatomic, assign) BOOL isFromChatClick;

@property (nonatomic, assign) BOOL isNiMing;//是否时匿名
@property (nonatomic, strong) NSDictionary*shareDic;
@property (nonatomic, assign) BOOL isFromShuoShuo;
@end
