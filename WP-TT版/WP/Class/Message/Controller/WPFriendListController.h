//
//  WPFriendListController.h
//  WP
//
//  Created by Kokia on 16/5/4.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPFriendListController : BaseViewController

@property (nonatomic ,assign) BOOL isCheck;
@property (nonatomic ,strong) NSString *controller;

@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic ,strong) NSString *transferIDs;  //1 说明是转移好友

@end
