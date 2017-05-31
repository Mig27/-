//
//  WPDateCheckView.h
//  WP
//
//  Created by CBCCBC on 16/4/1.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^startTimePicker) (NSString *startTime);
typedef void (^endTimePicker) (NSString *endTime);

@interface WPDateCheckView : UIView

@property (nonatomic ,strong)startTimePicker startTime;
@property (nonatomic ,strong)endTimePicker endTime;
-(void)showInView:(UIView *)view;
-(void)hide;

@end
