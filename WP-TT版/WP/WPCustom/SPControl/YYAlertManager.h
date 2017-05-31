//
//  YYAlertManager.h
//  WP
//
//  Created by CBCCBC on 16/1/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYAlertManager : UIView

+ (void)messages:(NSArray *)messages action:(void (^)())actions;

@end
