//
//  NSObject+Common.m
//  WPkeyboard
//
//  Created by Kokia on 16/3/8.
//  Copyright © 2016年 Kokia. All rights reserved.
//

#import "NSObject+Common.h"

@implementation NSObject (Common)


+ (void)showHudTipStr:(NSString *)tipStr{
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabelText = tipStr;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.0];
    }
}

@end
