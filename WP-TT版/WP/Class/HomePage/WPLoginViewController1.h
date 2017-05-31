//
//  WPLoginViewController1.h
//  WP
//
//  Created by apple on 15/7/2.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPLoginViewController1 : BaseViewController
@property (nonatomic,strong)UITextField * textfiled1;
@property (nonatomic,strong)UITextField * textfiled2;
@property (nonatomic, copy) NSString * phoneStr;

@property (nonatomic, assign) BOOL isFromQuit;

@property (nonatomic, assign) BOOL isFromKick;//被挤掉

@property (nonatomic, copy) void(^registNotifi)();
@end
