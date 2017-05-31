//
//  AppDelegate.h
//  WP
//
//  Created by Asuna on 15/5/20.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UMSocialControllerService.h"

#define UmengAppkey @"5681ef6167e58ee8fb0026c3"
static NSString *appKey = @"d06a9b9b5e32ee34700914ba";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) NSMutableArray *mobileArr;


@end

