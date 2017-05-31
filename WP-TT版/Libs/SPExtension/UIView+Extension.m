//
//  UIView+Extension.m
//  WP
//
//  Created by CBCCBC on 15/12/11.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                         class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
