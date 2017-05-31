//
//  WPDraftListModel.h
//  WP
//
//  Created by CBCCBC on 15/12/10.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseModel.h"


@class WPDraftListContentModel;
/**
 *  草稿和求职者列表Model
 */
@interface WPDraftListModel : BaseModel

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *info;

/** 求职者列表 */
@property (nonatomic, strong) NSArray<WPDraftListContentModel *> *list;
@property (nonatomic, strong) NSArray<WPDraftListContentModel *> *draftList;/**< 草稿列表 */

@end

/**
 *  草稿和求职者列表内容Model
 */
@interface WPDraftListContentModel : NSObject

#pragma mark - 自定义字段
@property (nonatomic, assign) BOOL itemIsSelected;/**< 是否被选中 */

#pragma mark - 草稿和求职者公用
@property (nonatomic, copy) NSString *avatar;/**< 头像 */
@property (nonatomic, copy) NSString *resumeUserId;/**< 求职者ID */
@property (nonatomic, copy) NSString *resumeId;/**< 草稿ID */

#pragma mark - 求职者列表
@property (nonatomic, copy) NSString *WorkTime;/**< 工作年限 */
@property (nonatomic, copy) NSString *age;/**< 年龄 */
@property (nonatomic, copy) NSString *education;/**< 学历 */
@property (nonatomic, copy) NSString *sex;/**< 性别 */
@property (nonatomic, copy) NSString *name;/**< 名称 */

@end

