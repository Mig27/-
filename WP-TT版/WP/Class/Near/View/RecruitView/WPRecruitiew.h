//
//  WPRecuilistView.h
//  WP
//
//  Created by CBCCBC on 15/9/29.
//  Copyright (c) 2015年 WP. All rights reserved.
//

// 公司招聘信息

#import <UIKit/UIKit.h>
#import "UISelectCity.h"
@interface WPRecEditModel : NSObject

@property (copy, nonatomic) NSString *jobPositon;/**< 工作职位 */
@property (copy, nonatomic) NSString *jobIndustry;/**< 工作行业 */
@property (copy, nonatomic) NSString *salary;/**< 工资待遇 */
@property (copy, nonatomic) NSString *epRange;/**< 福利 */
@property (copy, nonatomic) NSString *workTime;/**< 工作年限 */
@property (copy, nonatomic) NSString *education;/**< 学历 */
@property (copy, nonatomic) NSString *sex;/**< 性别 */
@property (copy, nonatomic) NSString *age;/**< 年龄 */
@property (copy, nonatomic) NSString *invitenumbe;/**< 招聘人数 */
@property (copy, nonatomic) NSString *workAddress;/**< 工作区域 */
@property (copy, nonatomic) NSString *workAdS;/**< 详细地点 */
@property (copy, nonatomic) NSString *workAddressID;/**< 工作区域ID */
@property (copy, nonatomic) NSString *Industry_id;/**< 行业ID */
@property (copy, nonatomic) NSString *Tel;/**< 联系方式 */
@property (nonatomic, copy) NSString * TelIsShow;/** 是否显示联系方式 */
@property (copy, nonatomic) NSString *Require;/**< 任职要求 */
@property (copy, nonatomic) NSString *jobPositonID;/**< 招聘职位对应的ID */
@property (copy, nonatomic) NSString *industry;/**< 联系人 */
@property (copy, nonatomic) NSString *apply_Condition;/**< 招聘条件 */
@property (nonatomic, strong) NSAttributedString *requireString;
@property (nonatomic, copy) NSString *requstString;

@end

@interface WPRecruitiew : UIView

@property (strong, nonatomic) WPRecEditModel *model;
@property (strong, nonatomic) UIButton *deleteButton;
@property (copy, nonatomic) void (^addMorePositionBlock)();
@property (copy, nonatomic) void (^deletePositionBlock)(NSInteger number);
@property (nonatomic, copy) void (^InputPositionRequireBlock)(NSInteger tag);
@property (nonatomic, copy) void (^contentChanged)();
@property (nonatomic, copy) void (^telephoneShowOrHiddenBlock) (BOOL showed);
@property (nonatomic, strong)UISelectCity *areaCity;
@property (nonatomic, strong)UIView * subView1;
- (void)setNumber:(NSInteger)number;
//- (void)deleteHidden;

- (BOOL)allMessageIsComplete;

- (void)reloadDataWithTitleArray:(NSArray *)array IdArray:(NSArray *)idArray;

@end
