//
//  ShareResume.h
//  WP
//
//  Created by 沈亮亮 on 16/1/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ShareResumeType) {
    ShareResumeTypeJOb = 10,
    ShareResumeTypeInvite,
    ShareResumeTypeDynamic
};

@interface ShareResume : UIView

@property (nonatomic, strong) NSDictionary *resumeInfo;    /**< 分享的招聘或者简历信息 */
@property (nonatomic, assign) ShareResumeType type;        /**< 是简历还求职 2求职 3招聘*/
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *sid; 
@property (nonatomic, assign) BOOL canTap;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, copy) NSString *jobId;

@end
