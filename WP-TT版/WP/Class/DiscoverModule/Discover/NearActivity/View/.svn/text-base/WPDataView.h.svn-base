//
//  WPDataView.h
//  WP
//
//  Created by 沈亮亮 on 15/10/10.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPDataView : UIView

@property (copy, nonatomic) void (^getDateBlock)(NSString *dateStr);
@property (nonatomic,assign) BOOL isNeedSecond;
@property (strong, nonatomic) UIDatePicker *datePickerView;

-(void)showInView:(UIView *)view;
-(void)hide;
-(void)resetTitle:(NSString *)title;

@end
