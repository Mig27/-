//
//  WPcodeAlert.h
//  WP
//
//  Created by CC on 16/10/13.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPcodeAlert : UIViewController
@property (nonatomic, copy)void(^clickDefault)();
@property (nonatomic, copy)void(^clickCancle)();



-(void)creatAlert:(NSString*)title andMessage:(NSString*)messag aneCanTitle:(NSString*)cancel andDefault:(NSString*)defaultStr;
-(void)creatBottomAlert:(NSString*)title andMessage:(NSString*)messag aneCanTitle:(NSString*)cancel andDefault:(NSString*)defaultStr;
-(void)oneCreatAlert:(NSString*)title andMessage:(NSString*)messag aneCanTitle:(NSString*)cancel andDefault:(NSString*)defaultStr;
-(void)creatAlert:(NSString*)title andMessage:(NSString*)messag aneCanTitle:(NSString*)cancel andDefault:(NSString*)defaultStr clickCancel:(void(^)(id))Cancel clickSure:(void(^)(id))Sure;
@end
