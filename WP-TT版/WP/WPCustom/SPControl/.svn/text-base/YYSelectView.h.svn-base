//
//  YYSelectView.h
//  WP
//
//  Created by CBCCBC on 16/2/1.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AllInfo) {
    isAllInfo,
    isNotAllInfo,
};

@interface YYSelectView : UIView

+(void)superView:(UIView *)superView top:(CGFloat)top array:(NSArray *)array type:(AllInfo)type selectedItem:(NSInteger)selectedItem block:(void(^)(NSString *title,NSString *selectedId,NSInteger selectedItem,BOOL isRemoved))action;

+(void)removeFromSuperView:(UIView *)superView;

@end
