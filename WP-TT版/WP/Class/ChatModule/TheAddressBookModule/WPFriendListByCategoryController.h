//
//  WPFriendListByCategoryController.h
//  WP
//
//  Created by Kokia on 16/5/4.
//  Copyright © 2016年 WP. All rights reserved.
//  好友列表

#import <UIKit/UIKit.h>

@interface WPFriendListByCategoryController : UIViewController

@property (nonatomic,copy) NSString *categoryName;//好友类别名称
@property (nonatomic,copy) NSString *typeId;//好友类别ID

@property (nonatomic ,assign) BOOL isCheck;

@end
