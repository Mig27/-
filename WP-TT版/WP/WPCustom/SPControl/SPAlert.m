//
//  SPAlert.m
//  WP
//
//  Created by CBCCBC on 15/11/27.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "SPAlert.h"

@implementation SPAlert

+(void)quickNotice:(UIViewController *)controller{

    [SPAlert alertControllerWithTitle:@"提示" message:@"暂未完成" superController:controller cancelButtonTitle:@"确认" cancelAction:nil];
}

+ (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message superController:(UIViewController *)controller cancelButtonTitle:(NSString *)cancelTitle cancelAction:(AlertcancelAction)cancelAction defaultButtonTitle:(NSString *)defaultTitle defaultAction:(AlertDefaultAction)defaultAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelAction) {
            cancelAction();
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:defaultTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (defaultAction) {
            defaultAction();
        }
    }]];
    
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message superController:(UIViewController *)controller cancelButtonTitle:(NSString *)cancelTitle cancelAction:(AlertcancelAction)cancelAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelAction) {
            cancelAction();
        }
    }]];
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
