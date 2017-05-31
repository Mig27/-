//
//  WPInterviewResumeController.h
//  WP
//
//  Created by CBCCBC on 15/12/3.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, WPInterviewResumeOperationType) {
    WPInterviewResumeOperationTypeChat = 100,
    WPInterviewResumeOperationTypeApply = 101,
    WPInterviewResumeOperationTypeCheck = 102,
};

@interface WPInterviewResumeController : BaseViewController

@property (copy, nonatomic) NSString *subId;/**< 请求ID */
@property (assign, nonatomic) BOOL isSelf;/**< 是否是本人 */
@property (assign, nonatomic) NSInteger isRecuilist;/**< 是否为招聘：0，求职；1，招聘；2，公司； */
@property (copy, nonatomic) NSString *urlStr;/**< 请求URL */
@property (copy, nonatomic) NSString *userId;

@end
