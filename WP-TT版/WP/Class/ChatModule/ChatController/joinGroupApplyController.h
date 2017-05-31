//
//  joinGroupApplyController.h
//  WP
//
//  Created by CC on 16/9/7.
//  Copyright © 2016年 WP. All rights reserved.
//  聊天 --> 群通知 -->  详情控制器

#import "BaseViewController.h"

typedef void (^successBlock)(NSArray*array);
typedef void (^faieldBlock)(NSError*error);

@interface joinGroupApplyController : BaseViewController
@property (nonatomic, strong)NSDictionary * infoDic;
@property (nonatomic, copy)void (^listAgree)(NSIndexPath*indespath);
@property (nonatomic, copy)void (^listReject)(NSIndexPath*indexpath);
@property (nonatomic, strong)NSIndexPath*indexpath;

//@property (nonatomic, copy) void(^successBlock)(NSArray*array);
//@property (nonatomic, copy) void(^faieldBlock)(NSError*error);
//@property (nonatomic, copy)NSString * statues;
@end
