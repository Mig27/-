//
//  InfoViewController.h
//  WP
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseModel.h"

typedef NS_ENUM(NSInteger, kInfoItemType) {
    
    kInfoItemTypeHead = 10,
    kInfoItemTypeBackground = 11,
    kInfoItemTypePageScroll = 12,
};

@interface WPInfoModel : BaseModel

@property (copy, nonatomic ) NSString *userId;    /**< 用户名 */
@property (copy, nonatomic ) NSString *nickName;    /**< 昵称 */
@property (copy, nonatomic ) NSString *wpId;        /**< 微聘号ID */
@property (copy, nonatomic ) NSString *sex;         /**< 性别 */
@property (copy, nonatomic ) NSString *birthday;    /**< 生日 */
@property (copy, nonatomic ) NSString *signature;   /**< 个性签名 */
@property (copy, nonatomic ) NSString *company;     /**< 公司名称 */
@property (copy, nonatomic ) NSString *industry;    /**< 行业 */
@property (copy, nonatomic ) NSString *industryId;  /**< 行业ID */
@property (copy, nonatomic ) NSString *position;    /**< 职位 */
@property (copy, nonatomic ) NSString *positionId; /**< 职位ID */
@property (copy, nonatomic ) NSString *workAddress; /**< 工作地址 */
@property (copy, nonatomic ) NSString *address;     /**< 生活地址 */
@property (copy, nonatomic ) NSString *education;      /**< 学历 */
@property (copy, nonatomic ) NSString *school;      /**< 学校 */
@property (copy, nonatomic ) NSString *hobby;       /**< 爱好兴趣 */
@property (copy, nonatomic ) NSString *specialty;   /**< 擅长 */
@property (copy, nonatomic ) NSString *hometown;  /**< 家乡 */
@property (copy, nonatomic ) NSString *hometownId;  /**< 家乡ID */

@property (strong,nonatomic) NSArray<Pohotolist *>  *ImgPhoto;

@end

@protocol UpdateInfoDelegate <NSObject>

-(void)UpdateInfoDelegate;

@end

@interface WPInfoController : BaseViewController

@property (assign, nonatomic) id <UpdateInfoDelegate> delegate;

@end
