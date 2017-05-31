//
//  WPInterView.h
//  WP
//
//  Created by CBCCBC on 15/9/21.
//  Copyright (c) 2015年 WP. All rights reserved.
//

// 求职简历界面

#import <UIKit/UIKit.h>
#import "WPUserListModel.h"
#import "WPInterviewDraftInfoModel.h"
#import "UISelectCity.h"

typedef NS_ENUM(NSInteger,WPInterViewActionType) {
    WPInterViewActionTypeName = 20,
    WPInterViewActionTypeSex,
    WPInterViewActionTypeBirthday,
    WPInterViewActionTypeEducation,
    WPInterViewActionTypeWorkTime,
    WPInterViewActionTypeNowSalary,
    WPInterViewActionTypeMarriage,
    WPInterViewActionTypeHometown,
    WPInterViewActionTypeAddress,
    WPInterViewActionTypeHopePosition,
    WPInterViewActionTypeHopeSalary,
    WPInterViewActionTypeHopeAddress,
    WPInterViewActionTypeTel,
    WPInterViewActionTypeHopeWelfare,
    WPInterViewActionTypeLightspot,
    WPInterViewActionTypeEducationList,
    WPInterViewActionTypeWorkList,
    WPInterViewActionTypeWeChat,
    WPInterViewActionTypeQQ,
    WPInterViewActionTypeEmail
};

@interface WPInterEditModel : NSObject

@property (copy, nonatomic) NSString *name;/**< 姓名 */
@property (copy, nonatomic) NSString *sex;/**< 性别 */
@property (copy, nonatomic) NSString *birthday;/**< 生日 */
@property (copy, nonatomic) NSString *education;/**< 学历 */
@property (copy, nonatomic) NSString *expe;/**< 工作年限 */
@property (copy, nonatomic) NSString *hometown;/**< 家乡名称 */
@property (copy, nonatomic) NSString *lifeAddress;/**< 现居住地 */
@property (copy, nonatomic) NSString *position;/**< 期望职位 */
@property (copy, nonatomic) NSString *wage;/**< 期望薪资 */
@property (copy, nonatomic) NSString *wel;/**< 期望福利 */
@property (copy, nonatomic) NSString *area;/**< 期望地区 */
@property (copy, nonatomic) NSString *works;/**< 工作经历 */
@property (copy, nonatomic) NSString *phone;/**< 联系方式 */
@property (nonatomic, copy) NSString * telIsShow;/** 是否显示号码 */
@property (copy, nonatomic) NSString *personal;/**< 个人亮点 */
@property (copy, nonatomic) NSString *homeTownId;/**< 家乡地址ID */
@property (copy, nonatomic) NSString *AddressId;/**< 现居住地ID */
@property (copy, nonatomic) NSString *HopePositionNo;/**< 期望职位ID */
@property (copy, nonatomic) NSString *HopeAddressId;/**< 期望地区ID */
@property (nonatomic, copy) NSString *nowSalary;
@property (nonatomic, copy) NSString *marriage;
@property (nonatomic, copy) NSString *WeChat;
@property (nonatomic, copy) NSString *QQ;
@property (nonatomic, copy) NSString *email;
@property (copy, nonatomic) NSString *applyCondition;/**< 报名条件 */


@end


@interface WPInterView : UIScrollView

@property (assign, nonatomic) BOOL isFirst;

@property (strong, nonatomic) UIScrollView *photosView;/**< 照片视频墙 */

@property (strong, nonatomic) WPInterEditModel *model;/**< 编辑Model */
@property (strong, nonatomic) NSMutableArray *photosArr;/**< 照片 */
@property (strong, nonatomic) NSMutableArray *videosArr;/**< 视频 */
@property (nonatomic, strong)UISelectCity * city;

@property (strong, nonatomic) NSArray *shareArr;/**< 分享 */


@property (copy, nonatomic) void (^addPhotosBlock)();/**< 添加图片Block */
//@property (copy, nonatomic) void (^addVideosBlock)();/**< 添加视频Block */
@property (copy, nonatomic) void (^checkPhotosBlock)();/**< 查看照片墙 */

//@property (copy, nonatomic) void (^checkAllVideosBlock)();/**< 查看视频墙（已取消） */

@property (copy, nonatomic) void (^checkPhotoBrowerBlock)(NSInteger number);/**< 查看图片播放 */
@property (copy, nonatomic) void (^checkVideosBlock)(NSInteger number);/**< 查看视频播放 */
@property (copy, nonatomic) void (^ChooseUserBlock)();/**< 选择求职者 */

@property (nonatomic, copy) void (^InterviewActionBlock)(WPInterViewActionType actionType);/**< 点击事件类型 */
@property (nonatomic, copy) void(^telePhoneShowOrHiddenBlock) (BOOL showed); /** 电话号码 显示或者隐藏 */

- (void)initSubViews;/**< 初始化控件 */
- (void)refreshData;/**< 刷新提交的数据 */
- (void)refreshPhotos;/**< 刷新照片墙 */
//-(void)refreshVideos;/**< 刷新视频墙（已取消） */
- (void)deleteAllDatas;/**< 删除所有数据 */
- (void)hideSubView;/**< 隐藏子视图 */
- (void)updateUserData:(WPUserListModel *)listModel;/**< 更新选择的用户信息 */
- (void)updateUserDatafromDraft:(WPInterviewDraftInfoModel *)listModel;

@end
