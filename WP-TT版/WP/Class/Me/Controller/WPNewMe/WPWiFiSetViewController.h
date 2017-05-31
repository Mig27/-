//
//  WPWiFiSetViewController.h
//  WP
//
//  Created by CC on 16/9/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"

@interface WPWiFiSetViewController : BaseViewController
@property (nonatomic, copy)void (^choiseSet)(NSString *name);
@property (nonatomic, copy)NSString * WiFiStr;

@end
