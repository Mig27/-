//
//  WPStrangerSettingController.h
//  WP
//
//  Created by Kokia on 16/5/14.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPStrangerSettingController : UIViewController

@property (nonatomic,copy) NSString *friendId;
@property (nonatomic, assign) BOOL isFromBlackList;//从黑名单中来
@property (nonatomic, copy)void(^pushToBlack)();
@end
