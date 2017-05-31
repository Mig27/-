//
//  PersonalView.h
//  test
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 Spyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJExtension.h"

@interface PersonalModel : NSObject

@property (strong, nonatomic) NSArray *photoWallArr;/**< 照片墙图片数组 */
//@property (copy, nonatomic) NSString *backgroundImageStr;/**< 背景Str */
@property (copy, nonatomic) NSString *headImageStr;/**< 头像Str */
@property (copy, nonatomic) NSString *nameStr;/**< 用户名Str */
@property (copy, nonatomic) NSString *nicknameStr;/**< 昵称Str */
@property (copy, nonatomic) NSString *WPidStr;/**< 微聘号Str */

@property (copy, nonatomic) NSString *attentionCount;/**< 关注数 */
@property (copy, nonatomic) NSString *fansCount;/**< 粉丝数 */
@property (copy, nonatomic) NSString *friendsCount;/**< 好友数 */
@property (copy, nonatomic) NSString *position;
@property (copy, nonatomic) NSString *company;

@end

@interface PersonalView : UIView
@property (nonatomic, assign) BOOL hidePosition;
@property (strong, nonatomic) PersonalModel *model;/**< 数据模型 */

@property (assign, nonatomic) BOOL isAllowEdit;/**< 是否允许编辑 */

//@property (copy, nonatomic) void (^imageClick)(NSArray *imageUrls);/**< 点击背景函数 */
@property (copy, nonatomic) void (^editPersonalInfo)();/**< 点击个人资料编辑 */
@property (copy, nonatomic) void (^personalConenction)(NSInteger number);/**< 个人操作 */
@property (copy, nonatomic) void (^photoWallDetail)();/**< 照片墙详情 */

-(void)initWithSubViews;
-(void)reloadData;

@end
