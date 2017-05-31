//
//  WPRecentLinkManController.h
//  WP
//
//  Created by CC on 16/8/29.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"

@interface WPRecentLinkManController : BaseViewController
@property (nonatomic, strong)NSArray * dataSource;
@property (nonatomic, copy)NSString * transStr;
@property (nonatomic, copy)NSString *display_type;
@property (nonatomic, strong)NSArray * moreTranitArray;
@property (nonatomic, copy) NSString * toUserId;
@property (nonatomic, assign) BOOL fromChatNotCreat;
@property (nonatomic, assign) BOOL isFromShuoDetail;
@property (nonatomic, assign) BOOL isFromApplyInvite;
@property (nonatomic, assign) int isRecruit;
@property (nonatomic, copy) NSString * shuoID;



@end
